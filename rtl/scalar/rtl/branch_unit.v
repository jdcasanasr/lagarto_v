module branch_unit (
	instr_type_i,
	pc_i,
	data_rs1_i,
	data_rs2_i,
	imm_i,
	taken_o,
	result_o,
	link_pc_o
);
	input wire [6:0] instr_type_i;
	localparam riscv_pkg_XLEN = 64;
	input wire [63:0] pc_i;
	input wire [63:0] data_rs1_i;
	input wire [63:0] data_rs2_i;
	input wire [63:0] imm_i;
	output reg taken_o;
	output wire [63:0] result_o;
	output wire [63:0] link_pc_o;
	wire equal;
	wire less;
	wire less_u;
	reg [63:0] target;
	assign equal = data_rs1_i == data_rs2_i;
	assign less = $signed(data_rs1_i) < $signed(data_rs2_i);
	assign less_u = data_rs1_i < data_rs2_i;
	always @(*)
		case (instr_type_i)
			7'd20: target = (pc_i + imm_i) & 64'hfffffffffffffffe;
			7'd19: target = (data_rs1_i + imm_i) & 64'hfffffffffffffffe;
			7'd13, 7'd14, 7'd15, 7'd16, 7'd17, 7'd18: target = pc_i + imm_i;
			default: target = 0;
		endcase
	always @(*)
		case (instr_type_i)
			7'd20: taken_o = 1'd0;
			7'd19: taken_o = 1'd1;
			7'd17: taken_o = (equal ? 1'd1 : 1'd0);
			7'd18: taken_o = (~equal ? 1'd1 : 1'd0);
			7'd13: taken_o = (less ? 1'd1 : 1'd0);
			7'd15: taken_o = (~less ? 1'd1 : 1'd0);
			7'd14: taken_o = (less_u ? 1'd1 : 1'd0);
			7'd16: taken_o = (~less_u ? 1'd1 : 1'd0);
			default: taken_o = 1'd0;
		endcase
	assign result_o = (taken_o == 1'd1 ? target : pc_i + 4);
	assign link_pc_o = pc_i + 4;
endmodule
module immediate (
	instr_i,
	imm_o
);
	localparam riscv_pkg_INST_SIZE = 32;
	input wire [31:0] instr_i;
	output reg [63:0] imm_o;
	wire [31:0] imm_itype;
	wire [31:0] imm_stype;
	wire [31:0] imm_btype;
	wire [31:0] imm_utype;
	wire [31:0] imm_jtype;
	wire [63:0] imm_uitype;
	wire [63:0] imm_shamt;
	wire [63:0] imm_shamt_big;
	wire [31:0] sign_extended;
	assign imm_shamt_big = {{57 {instr_i[26]}}, instr_i[26:20]};
	assign imm_shamt = {{58 {instr_i[25]}}, instr_i[25:20]};
	assign imm_itype = {{20 {instr_i[31]}}, instr_i[31-:12]};
	assign imm_stype = {{20 {instr_i[31]}}, instr_i[31-:7], instr_i[11-:5]};
	assign imm_btype = {{20 {instr_i[31]}}, instr_i[7], instr_i[30-:6], instr_i[11-:4], 1'b0};
	assign imm_utype = {instr_i[31-:20], 12'b000000000000};
	assign imm_jtype = {{11 {instr_i[31]}}, instr_i[31], instr_i[19-:8], instr_i[20], instr_i[30-:10], 1'b0};
	assign imm_uitype = {{59 {1'b0}}, instr_i[19-:5]};
	assign sign_extended = {32 {instr_i[31]}};
	always @(*)
		case (instr_i[6-:7])
			7'b0110111, 7'b0010111: imm_o = {sign_extended, imm_utype};
			7'b1101111: imm_o = {sign_extended, imm_jtype};
			7'b1100111, 7'b0000011: imm_o = {sign_extended, imm_itype};
			7'b0010011:
				case (instr_i[14-:3])
					3'b001, 3'b101: imm_o = imm_shamt_big;
					default: imm_o = {sign_extended, imm_itype};
				endcase
			7'b0011011:
				case (instr_i[14-:3])
					3'b001, 3'b101: imm_o = imm_shamt;
					default: imm_o = {sign_extended, imm_itype};
				endcase
			7'b1100011: imm_o = {sign_extended, imm_btype};
			7'b0100011: imm_o = {sign_extended, imm_stype};
			7'b1110011:
				case (instr_i[14-:3])
					3'b001, 3'b010, 3'b011, 3'b101, 3'b110, 3'b111, 3'b000: imm_o = {sign_extended, imm_itype};
					default: imm_o = 64'b0000000000000000000000000000000000000000000000000000000000000000;
				endcase
			default: imm_o = 64'b0000000000000000000000000000000000000000000000000000000000000000;
		endcase
endmodule
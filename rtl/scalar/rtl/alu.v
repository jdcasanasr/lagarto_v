module alu (
	data_rs1_i,
	data_rs2_i,
	instr_type_i,
	result_o
);
	input wire [63:0] data_rs1_i;
	input wire [63:0] data_rs2_i;
	input wire [6:0] instr_type_i;
	output reg [63:0] result_o;
	always @(*)
		case (instr_type_i)
			7'd0: result_o = data_rs1_i + data_rs2_i;
			7'd2: begin
				result_o[31:0] = data_rs1_i[31:0] + data_rs2_i[31:0];
				result_o[63:32] = {32 {result_o[31]}};
			end
			7'd1: result_o = data_rs1_i - data_rs2_i;
			7'd3: begin
				result_o[31:0] = data_rs1_i[31:0] - data_rs2_i[31:0];
				result_o[63:32] = {32 {result_o[31]}};
			end
			7'd9: result_o = data_rs1_i << data_rs2_i[5:0];
			7'd11: begin
				result_o[31:0] = data_rs1_i[31:0] << data_rs2_i[4:0];
				result_o[63:32] = {32 {result_o[31]}};
			end
			7'd21: result_o = {63'b000000000000000000000000000000000000000000000000000000000000000, $signed(data_rs1_i) < $signed(data_rs2_i)};
			7'd22: result_o = {63'b000000000000000000000000000000000000000000000000000000000000000, data_rs1_i < data_rs2_i};
			7'd4: result_o = data_rs1_i ^ data_rs2_i;
			7'd8: result_o = data_rs1_i >> data_rs2_i[5:0];
			7'd10: begin
				result_o[31:0] = data_rs1_i[31:0] >> data_rs2_i[4:0];
				result_o[63:32] = {32 {result_o[31]}};
			end
			7'd7: result_o = $signed(data_rs1_i) >>> data_rs2_i[5:0];
			7'd12: begin
				result_o[31:0] = $signed(data_rs1_i[31:0]) >>> data_rs2_i[4:0];
				result_o[63:32] = {32 {result_o[31]}};
			end
			7'd5: result_o = data_rs1_i | data_rs2_i;
			7'd6: result_o = data_rs1_i & data_rs2_i;
			default: result_o = 0;
		endcase
endmodule
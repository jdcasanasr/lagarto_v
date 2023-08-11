module mul_unit (
	clk_i,
	rstn_i,
	kill_mul_i,
	request_i,
	func3_i,
	int_32_i,
	src1_i,
	src2_i,
	result_o,
	stall_o
);
	input wire clk_i;
	input wire rstn_i;
	input wire kill_mul_i;
	input wire request_i;
	input wire [2:0] func3_i;
	input wire int_32_i;
	input wire [63:0] src1_i;
	input wire [63:0] src2_i;
	output reg [63:0] result_o;
	output reg stall_o;
	wire same_sign;
	reg [63:0] src1_def_q;
	reg [63:0] src1_def_d;
	reg [63:0] src2_def_q;
	reg [63:0] src2_def_d;
	reg neg_def_q;
	reg neg_def_d;
	reg [1:0] state_q;
	reg [1:0] state_d;
	wire [95:0] result1_d;
	wire [95:0] result2_d;
	reg [95:0] result1_q;
	reg [95:0] result2_q;
	wire [127:0] result_128;
	reg [127:0] result_128_def;
	wire [63:0] result_32_aux;
	wire [63:0] result_32;
	reg [63:0] result_64;
	reg done_tick;
	parameter IDLE = 2'b00;
	parameter MULT = 2'b01;
	parameter DONE = 2'b10;
	assign same_sign = (int_32_i ? ~(src2_i[31] ^ src1_i[31]) : ~(src2_i[63] ^ src1_i[63]));
	always @(*)
		case ({func3_i})
			3'b000: begin
				src1_def_d = ((src1_i[63] & !int_32_i) | (src1_i[31] & int_32_i) ? ~src1_i + 64'b0000000000000000000000000000000000000000000000000000000000000001 : src1_i);
				src2_def_d = ((src2_i[63] & !int_32_i) | (src2_i[31] & int_32_i) ? ~src2_i + 64'b0000000000000000000000000000000000000000000000000000000000000001 : src2_i);
				neg_def_d = !same_sign;
			end
			3'b001: begin
				src1_def_d = (src1_i[63] ? ~src1_i + 64'b0000000000000000000000000000000000000000000000000000000000000001 : src1_i);
				src2_def_d = (src2_i[63] ? ~src2_i + 64'b0000000000000000000000000000000000000000000000000000000000000001 : src2_i);
				neg_def_d = !same_sign;
			end
			3'b010: begin
				src1_def_d = (src1_i[63] ? ~src1_i + 64'b0000000000000000000000000000000000000000000000000000000000000001 : src1_i);
				src2_def_d = src2_i;
				neg_def_d = src1_i[63];
			end
			3'b011: begin
				src1_def_d = src1_i;
				src2_def_d = src2_i;
				neg_def_d = 1'b0;
			end
			default: begin
				src1_def_d = 64'b0000000000000000000000000000000000000000000000000000000000000000;
				src2_def_d = 64'b0000000000000000000000000000000000000000000000000000000000000000;
				neg_def_d = 1'b0;
			end
		endcase
	assign result1_d = src1_def_q * src2_def_q[31:0];
	assign result2_d = src1_def_q * src2_def_q[63:32];
	assign result_32_aux = (neg_def_q ? ~result1_q[63:0] + 64'b0000000000000000000000000000000000000000000000000000000000000001 : result1_q[63:0]);
	assign result_32 = {{32 {result_32_aux[31]}}, result_32_aux[31:0]};
	always @(posedge clk_i or negedge rstn_i)
		if (~rstn_i) begin
			state_q <= IDLE;
			result1_q <= 0;
			result2_q <= 0;
			src1_def_q <= 0;
			src2_def_q <= 0;
			neg_def_q <= 0;
		end
		else begin
			state_q <= state_d;
			result1_q <= result1_d;
			result2_q <= result2_d;
			src1_def_q <= src1_def_d;
			src2_def_q <= src2_def_d;
			neg_def_q <= neg_def_d;
		end
	always @(*)
		case (state_q)
			IDLE:
				if (request_i & ~kill_mul_i) begin
					state_d = MULT;
					done_tick = 1'b0;
					stall_o = 1'b1;
				end
				else begin
					state_d = IDLE;
					done_tick = 1'b0;
					stall_o = 1'b0;
				end
			MULT:
				if (kill_mul_i) begin
					state_d = IDLE;
					stall_o = 1'b0;
				end
				else begin
					state_d = DONE;
					stall_o = 1'b1;
				end
			DONE:
				if (kill_mul_i) begin
					state_d = IDLE;
					done_tick = 1'b0;
					stall_o = 1'b0;
				end
				else begin
					state_d = IDLE;
					done_tick = 1'b1;
					stall_o = 1'b0;
				end
		endcase
	assign result_128 = {32'b00000000000000000000000000000000, result1_q} + {result2_q[95:0], 32'b00000000000000000000000000000000};
	always @(*) result_128_def = (neg_def_q ? ~result_128 + 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001 : result_128);
	always @(*)
		case ({func3_i})
			3'b000: result_64 = result_128_def[63:0];
			3'b001: result_64 = result_128_def[127:64];
			3'b010: result_64 = result_128_def[127:64];
			3'b011: result_64 = result_128_def[127:64];
			default: result_64 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
		endcase
	always @(*) result_o = (done_tick ? (int_32_i ? result_32 : result_64) : 64'b0000000000000000000000000000000000000000000000000000000000000000);
endmodule
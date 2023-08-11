module div_unit (
	clk_i,
	rstn_i,
	kill_div_i,
	request_i,
	int_32_i,
	signed_op_i,
	dvnd_i,
	dvsr_i,
	quo_o,
	rmd_o,
	stall_o
);
	input wire clk_i;
	input wire rstn_i;
	input wire kill_div_i;
	input wire request_i;
	input wire int_32_i;
	input wire signed_op_i;
	input wire [63:0] dvnd_i;
	input wire [63:0] dvsr_i;
	output wire [63:0] quo_o;
	output wire [63:0] rmd_o;
	output reg stall_o;
	reg done_tick;
	reg [2:0] state_q;
	reg [2:0] state_d;
	reg [5:0] n_q;
	reg [5:0] n_d;
	wire div_zero;
	wire same_sign;
	reg int_32_q;
	reg int_32_d;
	wire [63:0] dvnd_def;
	wire [63:0] dvsr_def;
	wire [63:0] quo_aux;
	wire [63:0] rmd_aux;
	wire [63:0] remanent_out;
	wire [63:0] dividend_quotient_out;
	wire [63:0] divisor_out;
	reg [63:0] remanent_q;
	reg [63:0] remanent_d;
	reg [63:0] dividend_quotient_q;
	reg [63:0] dividend_quotient_d;
	reg [63:0] divisor_q;
	reg [63:0] divisor_d;
	div_4bits div_4bits_ints(
		.remanent_i(remanent_q),
		.dividend_quotient_i(dividend_quotient_q),
		.divisor_i(divisor_q),
		.remanent_o(remanent_out),
		.dividend_quotient_o(dividend_quotient_out),
		.divisor_o(divisor_out)
	);
	parameter IDLE = 3'b000;
	parameter OP = 3'b001;
	parameter FIRST = 3'b010;
	parameter DONE = 3'b011;
	assign div_zero = ~(|dvsr_i) || (int_32_i && ~(|dvsr_i[31:0]));
	assign same_sign = (int_32_i ? ~(dvsr_i[31] ^ dvnd_i[31]) : ~(dvsr_i[63] ^ dvnd_i[63]));
	assign dvnd_def = (((dvnd_i[63] & signed_op_i) & !int_32_i) | ((dvnd_i[31] & signed_op_i) & int_32_i) ? ~dvnd_i + 64'b0000000000000000000000000000000000000000000000000000000000000001 : dvnd_i);
	assign dvsr_def = (((dvsr_i[63] & signed_op_i) & !int_32_i) | ((dvsr_i[31] & signed_op_i) & int_32_i) ? ~dvsr_i + 64'b0000000000000000000000000000000000000000000000000000000000000001 : dvsr_i);
	always @(*) begin
		remanent_d = 0;
		dividend_quotient_d = 0;
		state_d = state_q;
		stall_o = 1'b0;
		done_tick = 1'b0;
		divisor_d = divisor_q;
		n_d = n_q;
		int_32_d = int_32_q;
		case (state_q)
			IDLE:
				if (request_i & ~kill_div_i) begin
					stall_o = 1'b1;
					remanent_d = 0;
					dividend_quotient_d = (int_32_i ? {dvnd_def[31:0], 32'b00000000000000000000000000000000} : dvnd_def);
					divisor_d = (int_32_i ? {32'b00000000000000000000000000000000, dvsr_def[31:0]} : dvsr_def);
					int_32_d = int_32_i;
					n_d = (int_32_i ? 15 : 31);
					state_d = OP;
				end
				else begin
					state_d = IDLE;
					stall_o = 1'b0;
				end
			OP:
				if (kill_div_i) begin
					state_d = IDLE;
					stall_o = 1'b0;
				end
				else begin
					stall_o = 1'b1;
					remanent_d = remanent_out;
					dividend_quotient_d = dividend_quotient_out;
					divisor_d = divisor_out;
					if (n_q == 0)
						state_d = DONE;
					else
						n_d = n_q - 1;
				end
			DONE:
				if (kill_div_i) begin
					state_d = IDLE;
					stall_o = 1'b0;
				end
				else begin
					stall_o = 1'b0;
					done_tick = 1'b1;
					state_d = IDLE;
				end
			default: state_d = IDLE;
		endcase
	end
	assign quo_aux = (done_tick ? (div_zero ? 64'hffffffffffffffff : (signed_op_i ? (same_sign ? dividend_quotient_q : ~dividend_quotient_q + 64'b0000000000000000000000000000000000000000000000000000000000000001) : dividend_quotient_q)) : 64'b0000000000000000000000000000000000000000000000000000000000000000);
	assign quo_o = (int_32_i ? {{32 {quo_aux[31]}}, quo_aux[31:0]} : quo_aux);
	assign rmd_aux = (done_tick ? (div_zero ? dvnd_i : (signed_op_i ? ((dvnd_i[63] & !int_32_i) | (dvnd_i[31] & int_32_i) ? ~remanent_q + 64'b0000000000000000000000000000000000000000000000000000000000000001 : remanent_q) : remanent_q)) : 64'b0000000000000000000000000000000000000000000000000000000000000000);
	assign rmd_o = (int_32_i ? {{32 {rmd_aux[31]}}, rmd_aux[31:0]} : rmd_aux);
	always @(posedge clk_i or negedge rstn_i)
		if (~rstn_i) begin
			state_q <= IDLE;
			remanent_q <= 0;
			dividend_quotient_q <= 0;
			divisor_q <= 0;
			n_q <= 0;
			int_32_q <= 0;
		end
		else begin
			state_q <= state_d;
			remanent_q <= remanent_d;
			dividend_quotient_q <= dividend_quotient_d;
			divisor_q <= divisor_d;
			n_q <= n_d;
			int_32_q <= int_32_d;
		end
endmodule
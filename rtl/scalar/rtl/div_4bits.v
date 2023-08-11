module div_4bits (
	remanent_i,
	dividend_quotient_i,
	divisor_i,
	remanent_o,
	dividend_quotient_o,
	divisor_o
);
	input wire [63:0] remanent_i;
	input wire [63:0] dividend_quotient_i;
	input wire [63:0] divisor_i;
	output wire [63:0] remanent_o;
	output wire [63:0] dividend_quotient_o;
	output wire [63:0] divisor_o;
	reg [63:0] tmp_remanent [1:0];
	reg [63:0] tmp_remanent_sub [1:0];
	reg [63:0] tmp_dividend_quotient [1:0];
	reg quotient_bit [1:0];
	always @(*) begin
		tmp_remanent[1] = {remanent_i[62:0], dividend_quotient_i[63]};
		tmp_dividend_quotient[1] = {dividend_quotient_i[62:0], quotient_bit[1]};
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i >= 0; i = i - 1)
				begin
					tmp_remanent[i] = {tmp_remanent_sub[i + 1][62:0], tmp_dividend_quotient[i + 1][63]};
					tmp_dividend_quotient[i] = {tmp_dividend_quotient[i + 1][62:0], quotient_bit[i]};
				end
		end
	end
	always @(*) begin : sv2v_autoblock_2
		reg signed [31:0] i;
		for (i = 1; i >= 0; i = i - 1)
			if (tmp_remanent[i] >= divisor_i) begin
				tmp_remanent_sub[i] = tmp_remanent[i] - divisor_i;
				quotient_bit[i] = 1'b1;
			end
			else begin
				tmp_remanent_sub[i] = tmp_remanent[i];
				quotient_bit[i] = 1'b0;
			end
	end
	assign remanent_o = tmp_remanent_sub[0];
	assign dividend_quotient_o = tmp_dividend_quotient[0];
	assign divisor_o = divisor_i;
endmodule
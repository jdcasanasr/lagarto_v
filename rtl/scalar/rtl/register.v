`default_nettype none
module register (
	clk_i,
	rstn_i,
	flush_i,
	load_i,
	input_i,
	output_o
);
	parameter WIDTH = 64;
	input wire clk_i;
	input wire rstn_i;
	input wire flush_i;
	input wire load_i;
	input wire [WIDTH - 1:0] input_i;
	
	output reg [WIDTH - 1:0] output_o;
	always @(posedge clk_i or negedge rstn_i)
		if (~rstn_i)
			output_o <= 0;
		else if (flush_i)
			output_o <= 0;
		else if (load_i)
			output_o <= input_i;
		else
			output_o <= output_o;
endmodule
`default_nettype wire
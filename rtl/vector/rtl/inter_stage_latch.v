module inter_stage_latch	
#(
	parameter WIDTH = 64
)(
	input	wire 					clk_i,
	input	wire 					rstn_i,
	input	wire 					flush_i,
	input	wire 					load_i,
	input	wire	[WIDTH - 1:0]	input_i,
	output	reg		[WIDTH - 1:0]	output_o
);
	always @(posedge clk_i,	negedge rstn_i)
		if (!rstn_i)
			output_o	<=	{WIDTH{1'b0}};
		else if (flush_i)
			output_o	<=	{WIDTH{1'b0}};
		else if (load_i)
			output_o	<=	input_i;
		else
			output_o	<=	output_o;
endmodule
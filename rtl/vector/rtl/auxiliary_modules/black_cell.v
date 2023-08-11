module black_cell
(
	input  		g_previous,
	input  		p_previous,
	input  		g_current,
	input  		p_current,
	
	output reg 	g_combined_current,
	output reg 	p_combined_current,
	output reg 	g_combined_next,
	output reg 	p_combined_next
);
	always @ (*)
		begin
			g_combined_current 	= g_current | (g_previous & p_current);
			p_combined_current 	= p_previous & p_current;
			g_combined_next 	= g_combined_current;
			p_combined_next 	= p_combined_current;
		end

endmodule 
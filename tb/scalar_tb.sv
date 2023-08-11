module	scalar_tb;
	bit		rst,clk;
	
	initial
	begin
		rst	=	0;
		clk	=	0;
		#5
		rst	=	1;
	end
	
	always	#5	clk	=	~clk;
	
	top_datapath	DUT	(
		.clk	(clk),
		.rst	(rst)
	);
	
endmodule

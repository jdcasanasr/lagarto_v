`include		"../includes/riscv_vector.vh"
`include		"../includes/riscv_vector_integer.vh"
module scalarINST_tb ();
	bit									clk, rst, flush,load,we_tb,re_tb,en_o;
	logic	[`instruction_length-1:0]	instruction;
	logic	[2:0]						vsew;
	logic	[`vs1_address_length-1:0]	vs1ADDRESS,vs2ADDRESS,vresADD;
	logic	[1:0]						f3,op;
	logic	[7:0]						vs1									[15:0];
	logic	[7:0]						vs2									[15:0];
	logic	[7:0]						vd									[15:0];
	logic 	[`data_length-1:0]			tb_i_vs1R,tb_i_vs2R;
	integer								addr;

	top_datapath	DUT	(
		.clk				(clk),
		.rst				(rst),
		.clk_data			(clk),
		.rst_data			(rst),
		.inst_we_i			(en_o),
		.data_we_i			(en_o),
		.inst_addr_i		(addr-1'b1),
		.instruction_i		(instruction),
		.vsew_i				(vsew),
		.output_data		({vd[15],vd[14],vd[13],vd[12],vd[11],vd[10],vd[9],vd[8],vd[7],vd[6],vd[5],vd[4],vd[3],vd[2],vd[1],vd[0]}),
		.vs1_output_data	(tb_i_vs1R),
		.vs2_output_data	(tb_i_vs2R)
	);
	
	reg [`instruction_length-1:0] mem [31:0];
	
	initial
	begin
		$readmemh("burbuja_esimecul.hex", mem);
		addr	=	0;
		clk 	= 	1'b1;
		rst 	= 	1'b0;
		flush 	= 	1'b0;
		load 	= 	1'b0;
        vsew    =	3'b0;
		f3		=	2'b0;
		en_o	=	1'b1;
		#5
		rst 	= 	1'b1;
		load 	= 	1'b1;
	end
	
	always
	begin
		#5
		clk		=	~clk;
	end
	
	always	@	(posedge	clk)
	begin
		if	(addr	<32)
		begin
			instruction	=	mem[addr];
			addr++;
		end
		else
		begin
			en_o	=	1'b0;
		end
	end

endmodule

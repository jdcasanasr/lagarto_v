`include		"../includes/riscv_vector.vh"
`include		"../includes/riscv_vector_integer.vh"
module	Vhun_tb;

	bit									clk, rst, flush,load,we_tb,re_tb,en_o;
	integer								addr;
	logic	[`instruction_length-1:0]	instruction;
	logic	[2:0]						vsew;
	logic	[`vs1_address_length-1:0]	vs1ADDRESS,vs2ADDRESS,vresADD;
	logic	[1:0]						f3,op;
	logic	[7:0]						vs1									[15:0];
	logic	[7:0]						vs2									[15:0];
	logic	[7:0]						vd									[15:0];
	logic 	[`data_length-1:0]			tb_i_vs1R,tb_i_vs2R;

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
	
	always
	begin
		#3
		if((tb_i_vs1R	||	tb_i_vs2R) > 128'b0)
		begin
			we_tb	=	1'b1;
		end
		else
		begin
			we_tb	=	1'b0;
		end
	end
	
	fifo#(
		.WIDTH		(`data_length),
		.DEPTH		(5)
	)	SaveData1	(
		.clk		(clk),
		.rst		(rst),
		.data_i		(tb_i_vs1R),
		.we_i		(we_tb),
		.re_i		(re_tb),
		.data_o		({vs1[15],vs1[14],vs1[13],vs1[12],vs1[11],vs1[10],vs1[9],vs1[8],vs1[7],vs1[6],vs1[5],vs1[4],vs1[3],vs1[2],vs1[1],vs1[0]}),
		.full_o		(),
		.empty_o	(),
		.afull_o	(),
		.aempty_o	()
	);
	
	fifo#(
		.WIDTH		(`data_length),
		.DEPTH		(5)
	)	SaveData2	(
		.clk		(clk),
		.rst		(rst),
		.data_i		(tb_i_vs2R),
		.we_i		(we_tb),
		.re_i		(re_tb),
		.data_o		({vs2[15],vs2[14],vs2[13],vs2[12],vs2[11],vs2[10],vs2[9],vs2[8],vs2[7],vs2[6],vs2[5],vs2[4],vs2[3],vs2[2],vs2[1],vs2[0]}),
		.full_o		(),
		.empty_o	(),
		.afull_o	(),
		.aempty_o	()
	);
	
	integer x;
	
	initial
	begin
		clk 	= 		1'b1;
		rst 	= 		1'b0;
		flush 	= 		1'b0;
		load 	= 		1'b0;
        vsew    =       3'b0;
		f3		=		2'b0;
		#5
		rst 	= 		1'b1;
		load 	= 		1'b1;
	end
	
	initial
	begin
		addr				=			 0;
		en_o				=		  1'b1;
		instruction			=		 32'b0;
		tb_i_vs1R			=		128'b0;
		tb_i_vs2R			=		128'b0;
		vs1ADDRESS		 	= 		  5'b0;
		vs2ADDRESS		 	= 		  5'b0;
		vresADD			 	= 		  5'b0;
		we_tb				=		  1'b0;
        re_tb				=		  1'b0;
        x                   =            2;
		op					=		  1'b0;
	end
	
	always
	begin 
		#5
		clk = ~clk;
	end
	
	always
	begin
		#10
		vs1ADDRESS	=	{$random}%32;
		vs2ADDRESS	=	{$random}%32;
		vresADD		=	{$random}%32;
		f3			=	{$random}%3;
		op			=	{$random}%2;
		if	(op	==	2'b01)
			vsew	=	{$random}%3;
		else
			vsew	=	{$random}%4;
		case	(op)
			2'b00:
			begin
				case	(f3)
					2'b00:
					begin
						instruction	=	{{`vadd},{1'b0},{vs2ADDRESS},{vs1ADDRESS},{`OPIVV},{vresADD},{7'b1010111}};
					end
					2'b01:
					begin
						instruction	=	{{`vadd},{1'b0},{vs2ADDRESS},{vs1ADDRESS},{`OPIVI},{vresADD},{7'b1010111}};
					end
					2'b10:
					begin
						instruction	=	{{`vadd},{1'b0},{vs2ADDRESS},{vs1ADDRESS},{`OPIVX},{vresADD},{7'b1010111}};
					end
				endcase
				addr++;
			end
			2'b01:
			begin
				case	(f3)
					2'b00:
					begin
						instruction	=	{{`vsll_vmul},{1'b0},{vs2ADDRESS},{vs1ADDRESS},{`OPMVV},{vresADD},{7'b1010111}};
					end
					2'b01:
					begin
						instruction	=	{{`vsll_vmul},{1'b0},{vs2ADDRESS},{vs1ADDRESS},{`OPMVX},{vresADD},{7'b1010111}};
					end
					2'b10:
					begin
						instruction	=	{{`vsll_vmul},{1'b0},{vs2ADDRESS},{vs1ADDRESS},{`OPMVX},{vresADD},{7'b1010111}};
					end
				endcase
				addr++;
			end
		endcase
	end
    
    always
    begin
		#2
        if  ({vd[15],vd[14],vd[13],vd[12],vd[11],vd[10],vd[9],vd[8],vd[7],vd[6],vd[5],vd[4],vd[3],vd[2],vd[1],vd[0]}   >   128'b0)
            re_tb      =    1'b1;
        else
            re_tb      =    1'b0;
    end
    /*if	(re_tb)
	begin
		if	({vd[15],vd[14],vd[13],vd[12],vd[11],vd[10],vd[9],vd[8],vd[7],vd[6],vd[5],vd[4],vd[3],vd[2],vd[1],vd[0]}
	end
	*/
endmodule

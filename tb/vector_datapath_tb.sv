`include		"../includes/riscv_vector.vh"
`include		"../includes/riscv_vector_integer.vh"
module	vector_datapath_tb;

	bit									clk, rst, flush,load,we_tb,re_tb,en_o;
	integer								addr;
	logic	[`instruction_length-1:0]	instruction;
	logic	[2:0]						vsew;
	logic	[`vs1_address_length-1:0]	vs1R,vs2R,vdR;
	logic	[1:0]						f3,op;
	logic 	[(`data_length/2)-1:0]		tb_i_vs1R_high,tb_i_vs1R_low,tb_i_vs2R_high,tb_i_vs2R_low,Result_high,Result_low,tb_vs1R_high,tb_vs1R_low,tb_vs2R_high,tb_vs2R_low;

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
		.output_data		({Result_high,Result_low}),
		.vs1_output_data	({tb_i_vs1R_high,tb_i_vs1R_low}),
		.vs2_output_data	({tb_i_vs2R_high,tb_i_vs2R_low})
	);
	/*
	vector_datapath	DUT	(
		.clk_i				(clk),
		.rstn_i				(rst),
		.flush_i			(flush),
		.load_i				(load),
		.instruction_i		(instruction),
		.vsew_i				(vsew),
		.output_data		({Result_high,Result_low}),
		.vs1_output_data	({tb_i_vs1R_high,tb_i_vs1R_low}),
		.vs2_output_data	({tb_i_vs2R_high,tb_i_vs2R_low}),
		.vd_output_data		()
	);
	*/
	always
	begin
		#3
		if(({tb_i_vs1R_high,tb_i_vs1R_low}	||	{tb_i_vs2R_high,tb_i_vs2R_low}) > 128'b0)
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
		.data_i		({tb_i_vs1R_high,tb_i_vs1R_low}),
		.we_i		(we_tb),
		.re_i		(re_tb),
		.data_o		({tb_vs1R_high,tb_vs1R_low}),
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
		.data_i		({tb_i_vs2R_high,tb_i_vs2R_low}),
		.we_i		(we_tb),
		.re_i		(re_tb),
		.data_o		({tb_vs2R_high,tb_vs2R_low}),
		.full_o		(),
		.empty_o	(),
		.afull_o	(),
		.aempty_o	()
	);
	
	integer x;
	
	initial
	begin
		clk 	= 		1;
		rst 	= 		0;
		flush 	= 		0;
		load 	= 		0;
        vsew    =       3'b011;
		f3		=		2'b0;
		#5
		rst 	= 		1;
		load 	= 		1;
	end
	
	initial
	begin
		en_o				=		 1'b1;
		addr				=			0;
		instruction			=		32'b0;
		tb_i_vs1R_high		=		64'b0;
		tb_i_vs1R_low		=		64'b0;
		tb_i_vs2R_high		=		64'b0;
		tb_i_vs2R_low		=		64'b0;
		vs1R		 		= 		 5'b0;
		vs2R		 		= 		 5'b0;
		vdR			 		= 		 5'b0;
		we_tb				=		 1'b0;
        re_tb				=		 1'b0;
        x                   =           2;
		op					=		 1'b0;
	end
	
	always
	begin 
		#5
		clk = ~clk;
	end
	
	always
	begin
		#10
		vs1R	=	{$random}%32;
		vs2R	=	{$random}%32;
		vdR		=	{$random}%32;
		f3		=	{$random}%3;
		op		=	2'b00;
		/*case	(op)
			2'b00:
				case	(f3)
					2'b00:
					begin
						instruction	=	{{`vadd},{1'b0},{vs2R},{vs1R},{`OPIVV},{vdR},{7'b1010111}};
					end
					2'b01:
					begin
						instruction	=	{{`vadd},{1'b0},{vs2R},{vs1R},{`OPIVI},{vdR},{7'b1010111}};
					end
					2'b10:
					begin
						instruction	=	{{`vadd},{1'b0},{vs2R},{vs1R},{`OPIVX},{vdR},{7'b1010111}};
					end
				endcase
			2'b01:
				case	(f3)
					2'b00:
					begin
						instruction	=	{{`vsll_vmul},{1'b0},{vs2R},{vs1R},{`OPMVV},{vdR},{7'b1010111}};
					end
					2'b01:
					begin
						instruction	=	{{`vsll_vmul},{1'b0},{vs2R},{vs1R},{`OPMVX},{vdR},{7'b1010111}};
					end
					2'b10:
					begin
						instruction	=	{{`vsll_vmul},{1'b0},{vs2R},{vs1R},{`OPMVX},{vdR},{7'b1010111}};
					end
				endcase
		endcase*/
		case	(op)
			2'b00:
			begin
				case	(f3)
					2'b00:
					begin
						instruction	=	{{`vadd},{1'b0},{vs2R},{vs1R},{`OPIVV},{vdR},{7'b1010111}};
					end
					2'b01:
					begin
						instruction	=	{{`vadd},{1'b0},{vs2R},{vs1R},{`OPIVI},{vdR},{7'b1010111}};
					end
					2'b10:
					begin
						instruction	=	{{`vadd},{1'b0},{vs2R},{vs1R},{`OPIVX},{vdR},{7'b1010111}};
					end
				endcase
				addr++;
			end
			2'b01:
			begin
				case	(f3)
					2'b00:
					begin
						instruction	=	{{`vsll_vmul},{1'b0},{vs2R},{vs1R},{`OPMVV},{vdR},{7'b1010111}};
					end
					2'b01:
					begin
						instruction	=	{{`vsll_vmul},{1'b0},{vs2R},{vs1R},{`OPMVX},{vdR},{7'b1010111}};
					end
					2'b10:
					begin
						instruction	=	{{`vsll_vmul},{1'b0},{vs2R},{vs1R},{`OPMVX},{vdR},{7'b1010111}};
					end
				endcase
				addr++;
			end
		endcase
//		case	(f3)
//			2'b00:
//			begin
//				instruction	=	{{7'b0},{vs2R},{vs1R},{`OPIVV},{vdR},{7'b1010111}};
//			end
//			2'b01:
//			begin
//				instruction	=	{{7'b0},{vs2R},{vs1R},{`OPIVI},{vdR},{7'b1010111}};
//			end
//			2'b10:
//			begin
//				instruction	=	{{7'b0},{vs2R},{vs1R},{`OPIVX},{vdR},{7'b1010111}};
//			end
//		endcase
		
	end
    
    always
    begin
		#2
        if  ({Result_high,Result_low}   >   128'b0)
            re_tb      =    1'b1;
        else
            re_tb      =    1'b0;
    end
    
    always
    begin
        #2
        if  (!clk)
        begin
			if  (((tb_vs1R_high+tb_vs2R_high)  ==  Result_high) &&  ((tb_vs1R_low+tb_vs2R_low)  ==  Result_low)	&&	({Result_high,Result_low}	>	128'b0))
            begin
                case	(f3)
					2'b00:
					begin
						$display("OK	VV");
					end
					2'b01:
					begin
						$display("OK	VI");
					end
					2'b10:
					begin
						$display("OK	VX");
					end
				endcase
                x   =   0;
            end
            else	if	(re_tb	==	0)
			begin
				x	=	2;
			end
			else
            begin
				case	(f3)
					2'b00:
					begin
						$display("Error    VV	Output Data:%H  ;   TB Data:    %H",{Result_high,Result_low},{(tb_vs1R_high+tb_vs2R_high),(tb_vs1R_low+tb_vs2R_low)});
					end
					2'b01:
					begin
						$display("Error    VI	Output Data:%H  ;   TB Data:    %H",{Result_high,Result_low},{(tb_vs1R_high+tb_vs2R_high),(tb_vs1R_low+tb_vs2R_low)});
					end
					2'b10:
					begin
						$display("Error    VX	Output Data:%H  ;   TB Data:    %H",{Result_high,Result_low},{(tb_vs1R_high+tb_vs2R_high),(tb_vs1R_low+tb_vs2R_low)});
					end
				endcase
                x   =   1;
            end
        end
    end
	
endmodule

import lagarto_fpu_pkg::*;

module	VFP_multiplier_unit	(
	input					clk_i,
	input					rst_ni,
	input					chip_enable_i,
	input			[1:0]	vsew_i,
	input			[127:0]	vs1_i,
	input			[127:0]	vs2_i,
	output	reg		[127:0]	vd_o,
	output	reg				busy,
	output	reg				done,
	output	reg		[1:0]	counter,
	output	reg		[1:0]	p32_p64				//only for testbench
);
/////////////////////////////	signal statment	////////////////////////////////////

	fp_operation_t	op_type;															//operation type (addition,subtraction)
	unit_input_t	s2d_vs1_i_01,s2d_vs1_i_02,s2d_vs1_i_03,s2d_vs1_i_04;				//single precision to double precision converter input from vs1
	unit_output_t	s2d_vs1_o_01,s2d_vs1_o_02,s2d_vs1_o_03,s2d_vs1_o_04;				//single precision to double precision converter output from vs1
	unit_input_t	s2d_vs2_i_01,s2d_vs2_i_02,s2d_vs2_i_03,s2d_vs2_i_04;				//single precision to double precision converter input from vs2
	unit_output_t	s2d_vs2_o_01,s2d_vs2_o_02,s2d_vs2_o_03,s2d_vs2_o_04;				//single precision to double precision converter output from vs2
	unit_input_t	d2s_result_i_01,d2s_result_i_02,d2s_result_i_03,d2s_result_i_04;	//double precision to single precision converter input from result
	unit_output_t	d2s_result_o_01,d2s_result_o_02,d2s_result_o_03,d2s_result_o_04;	//double precision to single precision converter output from result
	logic	[6:0]	tag01_i,tag02_i,tag03_i,tag04_i;									//input tag for presicion type identify
	logic	[6:0]	tag01_o,tag02_o,tag03_o,tag04_o;									//output tag for presicion type identify
	logic			op_32b_64b,op_32b;													//module enabler
	logic			done_32,done_64;													//process finish identifier
	logic	[63:0]	operand_a1,operand_a2,operand_a3,operand_a4;						//"A" input for each module
	logic	[63:0]	operand_b1,operand_b2,operand_b3,operand_b4;						//"B" input for each module
	logic	[63:0]	result_r1,result_r2,result_r3,result_r4;							//result for each module 
	logic			busy1,busy2,busy3,busy4;											//module-at-work identifier
	
/////////////////////////////	convertion values	////////////////////////////////
	assign	s2d_vs1_i_01.operand_a	=	{32'b0,vs1_i[127:96]};
	assign	s2d_vs1_i_02.operand_a	=	{32'b0,vs1_i[95:64]};
	assign	s2d_vs1_i_03.operand_a	=	{32'b0,vs1_i[63:32]};
	assign	s2d_vs1_i_04.operand_a	=	{32'b0,vs1_i[31:0]};
	
	assign	s2d_vs2_i_01.operand_a	=	{32'b0,vs2_i[127:96]};
	assign	s2d_vs2_i_02.operand_a	=	{32'b0,vs2_i[95:64]};
	assign	s2d_vs2_i_03.operand_a	=	{32'b0,vs2_i[63:32]};
	assign	s2d_vs2_i_04.operand_a	=	{32'b0,vs2_i[31:0]};
	
	f2d_unit	s2d_vs1_converter_01
	(
		.unit_input_i	(s2d_vs1_i_01),
		.unit_output_o	(s2d_vs1_o_01)
	);
	
	f2d_unit	s2d_vs1_converter_02
	(
		.unit_input_i	(s2d_vs1_i_02),
		.unit_output_o	(s2d_vs1_o_02)
	);
	
	f2d_unit	s2d_vs1_converter_03
	(
		.unit_input_i	(s2d_vs1_i_03),
		.unit_output_o	(s2d_vs1_o_03)
	);
	
	f2d_unit	s2d_vs1_converter_04
	(
		.unit_input_i	(s2d_vs1_i_04),
		.unit_output_o	(s2d_vs1_o_04)
	);
	
	f2d_unit	s2d_vs2_converter_01
	(
		.unit_input_i	(s2d_vs2_i_01),
		.unit_output_o	(s2d_vs2_o_01)
	);
	
	f2d_unit	s2d_vs2_converter_02
	(
		.unit_input_i	(s2d_vs2_i_02),
		.unit_output_o	(s2d_vs2_o_02)
	);
	
	f2d_unit	s2d_vs2_converter_03
	(
		.unit_input_i	(s2d_vs2_i_03),
		.unit_output_o	(s2d_vs2_o_03)
	);
	
	f2d_unit	s2d_vs2_converter_04
	(
		.unit_input_i	(s2d_vs2_i_04),
		.unit_output_o	(s2d_vs2_o_04)
	);
	
/////////////////////////////	multiplication control	////////////////////////////////////
	always	@	(*)
		if(chip_enable_i)
			case	(vsew_i)
				2'b10	:	begin	//	multiplication	32bits
					operand_a1	=	s2d_vs1_o_01.result;
					operand_a2	=	s2d_vs1_o_02.result;
					operand_a3	=	s2d_vs1_o_03.result;
					operand_a4	=	s2d_vs1_o_04.result;
					operand_b1	=	s2d_vs2_o_01.result;
					operand_b2	=	s2d_vs2_o_02.result;
					operand_b3	=	s2d_vs2_o_03.result;
					operand_b4	=	s2d_vs2_o_04.result;
					op_32b_64b	=	1'b1;
					op_32b		=	1'b1;
					op_type		=	MUL;
					tag01_i		=	7'b01;
					tag02_i		=	7'b01;
					tag03_i		=	7'b01;
					tag04_i		=	7'b01;
				end
				2'b11	:	begin	//	multiplication	64bits
					operand_a1	=	vs1_i[127:64];
					operand_a2	=	vs1_i[63:0];
					operand_a3	=	64'b0;
					operand_a4	=	64'b0;
					operand_b1	=	vs2_i[127:64];
					operand_b2	=	vs2_i[63:0];
					operand_b3	=	64'b0;
					operand_b4	=	64'b0;
					op_32b_64b	=	1'b1;
					op_32b		=	1'b0;
					op_type		=	MUL;
					tag01_i		=	7'b01;
					tag02_i		=	7'b01;
					tag03_i		=	7'b00;
					tag04_i		=	7'b00;
				end
				default	:	begin	//	no operation
					operand_a1	=	64'b00;
					operand_a2	=	64'b00;
					operand_a3	=	64'b00;
					operand_a4	=	64'b00;
					operand_b1	=	64'b00;
					operand_b2	=	64'b00;
					operand_b3	=	64'b00;
					operand_b4	=	64'b00;
					op_32b_64b	=	1'b0;
					op_32b		=	1'b0;
					op_type		=	MUL;
					tag01_i		=	7'b00;
					tag02_i		=	7'b00;
					tag03_i		=	7'b00;
					tag04_i		=	7'b00;
				end
			endcase
		else	begin
			operand_a1	=	64'b00;
			operand_a2	=	64'b00;
			operand_a3	=	64'b00;
			operand_a4	=	64'b00;
			operand_b1	=	64'b00;
			operand_b2	=	64'b00;
			operand_b3	=	64'b00;
			operand_b4	=	64'b00;
			op_32b_64b	=	1'b0;
			op_32b		=	1'b0;
			op_type		=	MUL;
			tag01_i		=	7'b00;
			tag02_i		=	7'b00;
			tag03_i		=	7'b00;
			tag04_i		=	7'b00;
		end
			
/////////////////////////////	multiplication stage	////////////////////////////////////

	lagarto_fp_multiplier VFP_mul_1
	(
		.clk_i			(clk_i		),
		.rstn_i			(rst_ni		),
		.flush_i		(			),
		.op_valid_i		(op_32b_64b	),
		.op_i			(op_type	),
		.fmt_i			(			),
		.rnd_mode_i		(			),
		.operand_a_i	(operand_a1	),
		.operand_b_i	(operand_b1	),
		.tag_id_i		(tag01_i	),
		.op_ready_o		(			),
		.result_o		(result_r1	),
		.status_o		(			),
		.tag_id_o		(tag01_o	),
		.busy_o			(busy1		),
		.cycle_counter	(counter)
	);
	
	lagarto_fp_multiplier VFP_mul_2
	(
		.clk_i			(clk_i		),
		.rstn_i			(rst_ni		),
		.flush_i		(			),
		.op_valid_i		(op_32b_64b	),
		.op_i			(op_type	),
		.fmt_i			(			),
		.rnd_mode_i		(			),
		.operand_a_i	(operand_a2	),
		.operand_b_i	(operand_b2	),
		.tag_id_i		(tag02_i	),
		.op_ready_o		(done_32	),
		.result_o		(result_r2	),
		.status_o		(			),
		.tag_id_o		(tag02_o	),
		.busy_o			(busy2		),
		.cycle_counter	()
	);
	
	lagarto_fp_multiplier VFP_mul_3
	(
		.clk_i			(clk_i		),
		.rstn_i			(rst_ni		),
		.flush_i		(			),
		.op_valid_i		(op_32b		),
		.op_i			(op_type	),
		.fmt_i			(			),
		.rnd_mode_i		(			),
		.operand_a_i	(operand_a3	),
		.operand_b_i	(operand_b3	),
		.tag_id_i		(tag03_i	),
		.op_ready_o		(			),
		.result_o		(result_r3	),
		.status_o		(			),
		.tag_id_o		(tag03_o	),
		.busy_o			(busy3		),
		.cycle_counter	()
	);
	
	lagarto_fp_multiplier VFP_mul_4
	(
		.clk_i			(clk_i		),
		.rstn_i			(rst_ni		),
		.flush_i		(			),
		.op_valid_i		(op_32b		),
		.op_i			(op_type	),
		.fmt_i			(			),
		.rnd_mode_i		(			),
		.operand_a_i	(operand_a4	),
		.operand_b_i	(operand_b4	),
		.tag_id_i		(tag04_i	),
		.op_ready_o		(done_64),
		.result_o		(result_r4	),
		.status_o		(			),
		.tag_id_o		(tag04_o	),
		.busy_o			(busy4		),
		.cycle_counter	()
	);
	
/////////////////////////////	output stage	////////////////////////////////////
	assign	d2s_result_i_01.operand_a	=	result_r1;
	assign	d2s_result_i_02.operand_a	=	result_r2;
	assign	d2s_result_i_03.operand_a	=	result_r3;
	assign	d2s_result_i_04.operand_a	=	result_r4;

	d2f_unit	d2s_result_converter_01
	(
		.unit_input_i	(d2s_result_i_01),
		.unit_output_o	(d2s_result_o_01)
	);
	d2f_unit	d2s_result_converter_02
	(
		.unit_input_i	(d2s_result_i_02),
		.unit_output_o	(d2s_result_o_02)
	);
	d2f_unit	d2s_result_converter_03
	(
		.unit_input_i	(d2s_result_i_03),
		.unit_output_o	(d2s_result_o_03)
	);
	d2f_unit	d2s_result_converter_04
	(
		.unit_input_i	(d2s_result_i_04),
		.unit_output_o	(d2s_result_o_04)
	);
	
	always	@	(*)
		case	({tag01_o[0],tag02_o[0],tag03_o[0],tag04_o[0]})
			4'b1111	:	begin	//	4 single precision outputs
				vd_o	=	{d2s_result_o_01.result[31:0],d2s_result_o_02.result[31:0],d2s_result_o_03.result[31:0],d2s_result_o_04.result[31:0]};
				p32_p64	=	2'b01;
			end
			4'b1100	:	begin	//	2 double precision outputs
				vd_o	=	{result_r1,result_r2};
				p32_p64	=	2'b00;
			end
			default	:	begin	//	no operation
				vd_o	=	128'b0;
				p32_p64	=	2'b11;
			end
		endcase
endmodule
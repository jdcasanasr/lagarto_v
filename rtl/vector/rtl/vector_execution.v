`include	"../../includes/riscv_vector.vh"
module	vector_execution	(
	input										clk_i,
	input										rst_ni,
	input		[3:0]							vadd_control_vector_o,
	input		[1:0]							vlog_control_vector_o,
	input		[1:0]							vshft_control_vector_o,
	input		[2:0]							vmul_control_vector_o,
	input		[`resource_vector_length-1:0]	resource_vector_i,
	input		[`operation_vector_length-1:0]	operation_vector_i,
	input		[`data_length-1:0]				vs1_i,
	input		[`data_length-1:0]				vs2_i,
	input		[`data_length-1:0]				vd_i,
	input		[`data_length-1:0]				vmask_i,
	input		[1:0]							vsew_i,
	output	reg	[`data_length-1:0]				vd_o
);

	localparam	DATA_LENGTH				=	`data_length;
	localparam	RESOURCE_VECTOR_LENGTH	=	`resource_vector_length;
	localparam	OPERATION_VECTOR_LENGTH	=	`operation_vector_length;

	wire	[DATA_LENGTH-1:0]				vd_addition_w;
	wire	[DATA_LENGTH-1:0]				vd_multiplication_w;
	wire	[DATA_LENGTH-1:0]				vd_shifter_w;
	wire	[DATA_LENGTH-1:0]				vd_logic_w;
	wire	[DATA_LENGTH-1:0]				vd_vdiv_w;
	wire	[DATA_LENGTH-1:0]				vd_vmerge_w;
	wire	[DATA_LENGTH-1:0]				vd_vmaxmin_w;
	
	//signals pos-latch
	wire	[DATA_LENGTH-1:0]				vd_madd_w;
	wire	[DATA_LENGTH-1:0]				vs1_effective_w;
	wire	[DATA_LENGTH-1:0]				vs2_effective_w;
	wire	[1:0]							vsew_effective_w;
	wire	[RESOURCE_VECTOR_LENGTH-1:0]	resource_vector_effective_w;
	
	always	@	(*)
		case	(resource_vector_i[`resource_vector_vmerge:`resource_vector_vadd])
			8'b00000001:	vd_o	=	vd_addition_w;
			8'b00100000:	vd_o	=	vd_multiplication_w;
			8'b00000100:	vd_o	=	vd_logic_w;
			8'b00001000:	vd_o	=	vd_shifter_w;
			8'b00100001:	vd_o	=	vd_addition_w;	//multiply-add
			default:		vd_o	=	128'b0;
		endcase
		
	//assign	vmul_vs2_effective	=	vmul_vs2_vd		?	vs2_i:vd_i;
	
	vector_multiplication_unit	vmul
	(
		.clock_i				(clk_i										),
		.reset_ni				(rst_ni										),
		.request_i				(resource_vector_i[`resource_vector_vmul]	),
		.vsew_i					(vsew_i										),
		.vs2_signed_unsigned_i	(operation_vector_i[`operation_vector_vsb]	),
		.vs1_signed_unsigned_i	(operation_vector_i[`operation_vector_vsa]	),
		.vd_high_low_part_i		(operation_vector_i[`operation_vector_vhl]	),
		.vs2_i					(vs2_i										),
		.vs1_i					(vs1_i										),
		.vd_o					(),
		.vd_complete_o			(),
		.cycle_counter			()
	);

	/*vector_multiplication_unit	vmul
	(
		.chip_en				(),
		.vs2_i					(),
		.vs1_i					(),
		.vsew_i					(),
		.vs2_signed_unsigned_i	(),
		.vs1_signed_unsigned_i	(),
		.vd_high_low_part_i		(),
		.vd_o					(vd_multiplication_w						)
	);*/
	
	inter_stage_latch
	#(
		.WIDTH 					({(3*DATA_LENGTH)+2+RESOURCE_VECTOR_LENGTH})
	)	vexe2	(
		.clk_i					(clk_i),
		.rstn_i					(rst_ni),
		.flush_i				(1'b0),
		.load_i					(1'b0),
		.input_i				({vd_multiplication_w,vs1_i,vs2_i,vsew_i,resource_vector_i}),
		.output_o				({vd_madd_w,vs1_effective_w,vs2_effective_w,vsew_effective_w,resource_vector_effective_w})
	);
	
	//assign	vadd_vs2_effective	=	vmul_vs2_vd		?	vd_i:vs2_i;
	
	vector_addition_unit	vadd
	(
		.request_i				(resource_vector_i[`resource_vector_vadd]	),
		.vs1_i					(vs1_i										),
		.vs2_i					(vs2_i										),
		.vmask_i				(vmask_i[15:0]								),
		.vsew_i					(vsew_i										),
		.add_sub_i				(vadd_control_vector_o[1]					),
		.compute_carry_i		(vadd_control_vector_o[2]					),
		.with_carry_borrow_i	(vadd_control_vector_o[3]					),
		.reversed_i				(vadd_control_vector_o[0]					),
		.vd_o					(vd_addition_w								)
	);
	
	vector_shift_unit			vshift
	(
		.chip_enable_i			(resource_vector_i[`resource_vector_vshft]	),
		.shift_type_i			(vshft_control_vector_o						),
		.vsew_i					(vsew_i										),
		.vs1_i					(vs1_i										),
		.vs2_i					(vs2_i										),
		.vd_o 					(vd_shifter_w								)
	);
	
	vector_logic_unit			vlogic
	(
		.chip_enable_i			(resource_vector_i[`resource_vector_vlogic]	),
		.logic_type_i			(vlog_control_vector_o						),
		.vs1_i					(vs1_i										),
		.vs2_i					(vs2_i										),
		.vd_o 					(vd_logic_w									)
	);
	
	vector_merge_unit			vmerge
	(
		.chip_enable_i			(resource_vector_i[`resource_vector_vmerge]	),
		.vsew_i					(vsew_i										),
		.vs1_i					(vs1_i										),
		.vs2_i					(vs2_i										),
		.vmask_i				(vmask_i[15:0]								),
		.vd_o					(vd_merge_w									)
	);
	
	vector_maxmin_unit			vmaxmin
	(
		.chip_enable_i			(resource_vector_i[`resource_vector_vcmp]	),
		.signed_unsigned_i		(),
		.maxmin_type_i			(),
		.vsew_i					(vsew_i										),
		.vs1_i					(vs1_i										),
		.vs2_i					(vs2_i										),
		.vd_o					(vd_maxmin_w								)
	);
	
	vector_division_unit		vdiv
	(
		.chip_enable_i			(resource_vector_i[`resource_vector_vdiv]	),
		.division_type_i		(),
		.vsew_i					(vsew_i										),
		.vs1_i					(vs1_i										),
		.vs2_i					(vs2_i										),
		.vd_o					(vd_vdiv_w									)
	);

endmodule

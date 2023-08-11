`include		"../../includes/riscv_vector.vh"
module	vector_datapath	
#(
	parameter	INSTRUCTION_LENGTH			=	`instruction_length,
	parameter	DATA_LENGTH					=	`data_length
)(
//scalar input/output
	input	wire	[63:0]						rs1_data_i,
	output	wire	[5:0]						rs1_address_o,
	output	wire								rs1_Ven_o,
//vector input/oputput
	input	wire								clk_i,
	input	wire								rstn_i,
	input	wire								flush_i,
	input	wire								load_i,
	input	wire	[INSTRUCTION_LENGTH-1:0]	instruction_i,
	input	wire	[2:0]						vsew_i,
	output 	wire 	[DATA_LENGTH-1:0]			output_data,
	output 	wire 	[DATA_LENGTH-1:0]			vs1_output_data,
	output 	wire 	[DATA_LENGTH-1:0]			vs2_output_data,
	output 	wire 	[DATA_LENGTH-1:0]			vd_output_data	
);
	localparam	VSEW_LENGTH					=	3;
	localparam	F6_LENGTH					=	`funct6_length;
	localparam	SYSTEM_VECTOR_LENGTH		=	`system_vector_length;
	localparam	RESOURCE_VECTOR_LENGTH		=	`resource_vector_length;
	localparam	REGISTER_VECTOR_LENGTH		=	`register_vector_length;
	localparam	OPERATION_VECTOR_LENGTH		=	`operation_vector_length;
	localparam	VS1_ADDRESS_LENGTH			=	`vs1_address_length;
	localparam	VS2_ADDRESS_LENGTH			=	`vs2_address_length;
	localparam	VD_ADDRESS_LENGTH			=	`vd_address_length;
//////////////////////////////////////////////////////////////
//		INTERNAL SIGNALS
//////////////////////////////////////////////////////////////
	//	from if_vid_latch
	wire	[INSTRUCTION_LENGTH-1:0]		if_vid_instruction_o;
	wire	[VSEW_LENGTH-1:0]				if_vid_vsew_o;
	//	from decode_interface
	wire	[SYSTEM_VECTOR_LENGTH-1:0]		vid_system_vector_o;
	wire	[RESOURCE_VECTOR_LENGTH-1:0]	vid_resource_vector_o;
	wire	[REGISTER_VECTOR_LENGTH-1:0]	vid_register_vector_o;
	wire	[OPERATION_VECTOR_LENGTH-1:0]	vid_operation_vector_o;
	//	from vid_vrr_latch
	wire	[VS1_ADDRESS_LENGTH-1:0]		vid_vrr_vs1_address_o;
	wire	[VS2_ADDRESS_LENGTH-1:0]		vid_vrr_vs2_address_o;
	wire	[VD_ADDRESS_LENGTH-1:0]			vid_vrr_vd_address_o;
	wire	[SYSTEM_VECTOR_LENGTH-1:0]		vid_vrr_system_vector_o;
	wire	[RESOURCE_VECTOR_LENGTH-1:0]	vid_vrr_resource_vector_o;
	wire	[REGISTER_VECTOR_LENGTH-1:0]	vid_vrr_register_vector_o;
	wire	[OPERATION_VECTOR_LENGTH-1:0]	vid_vrr_operation_vector_o;
	wire	[VSEW_LENGTH-1:0]				vid_vrr_vsew_o;
	wire	[F6_LENGTH-1:0]					vid_vrr_f6_o;
	//	from vector_register_read_interface
	wire	[DATA_LENGTH-1:0]				vrr_vd_write_data_i;
	wire	[DATA_LENGTH-1:0]				vrr_vmask_read_data_o;
	wire	[DATA_LENGTH-1:0]				vrr_vs1_read_data_o;
	wire	[DATA_LENGTH-1:0]				vrr_vs2_read_data_o;
	wire	[DATA_LENGTH-1:0]				vrr_rs1_read_data_o;
	wire	[DATA_LENGTH-1:0]				vrr_vd_read_data_o;
	wire	[REGISTER_VECTOR_LENGTH-1:0]	vrr_register_vector_i;
	//	from vrr_vexe_latch
	wire	[DATA_LENGTH-1:0]				vrr_vexe_vmask_data_o;
	wire	[DATA_LENGTH-1:0]				vrr_vexe_vs1_data_o;
	wire	[DATA_LENGTH-1:0]				vrr_vexe_vs2_data_o;
	wire	[DATA_LENGTH-1:0]				vrr_vexe_rs1_data_o;
	wire	[DATA_LENGTH-1:0]				vrr_vexe_vd_data_o;
	wire	[VS1_ADDRESS_LENGTH-1:0]		vrr_vexe_vs1_address_o;
	wire	[VS2_ADDRESS_LENGTH-1:0]		vrr_vexe_vs2_address_o;
	wire	[VD_ADDRESS_LENGTH-1:0]			vrr_vexe_vd_address_o;
	wire	[SYSTEM_VECTOR_LENGTH-1:0]		vrr_vexe_system_vector_o;
	wire	[RESOURCE_VECTOR_LENGTH-1:0]	vrr_vexe_resource_vector_o;
	wire	[REGISTER_VECTOR_LENGTH-1:0]	vrr_vexe_register_vector_o;
	wire	[OPERATION_VECTOR_LENGTH-1:0]	vrr_vexe_operation_vector_o;
	wire	[VSEW_LENGTH-1:0]				vrr_vexe_vsew_o;
	wire	[F6_LENGTH-1:0]					vrr_vexe_f6_o;
	//	from vector_alu_control
	wire	[3:0]							vexe_vadd_control_vector_o;
	wire	[1:0]							vexe_vlog_control_vector_o;
	wire	[1:0]							vexe_vshft_control_vector_o;
	wire	[2:0]							vexe_vmul_control_vector_o;
	// 	from forward
	wire	[DATA_LENGTH-1:0]				vd_fw_dataa_o;
	wire	[DATA_LENGTH-1:0]				vd_fw_datab_o;
	//	from vector_execution_interface
	wire	[DATA_LENGTH-1:0]				vd_dataa_i;
	wire	[DATA_LENGTH-1:0]				vexe_vdata_o;
	//	from vexe_vwb_latch
	wire	[DATA_LENGTH-1:0]				vexe_vwb_vdata_o;
	wire	[VD_ADDRESS_LENGTH-1:0]			vexe_vwb_vd_address_o;
	wire	[REGISTER_VECTOR_LENGTH-1:0]	vexe_vwb_register_vector_o;
	
//////////////////////////////////////////////////////////////
//		VECTOR INSTRUCTION DECODE STAGE
//////////////////////////////////////////////////////////////

	inter_stage_latch	
	#(.WIDTH 		(INSTRUCTION_LENGTH+VSEW_LENGTH))
	if_vid_latch		//if: instruction fetch	,	vid: vector instruction decode
	(
		.clk_i		(clk_i	),
		.rstn_i		(rstn_i	),
		.flush_i	(flush_i),
		.load_i		(load_i	),
		.input_i	({instruction_i,vsew_i}),
		.output_o	({if_vid_instruction_o,if_vid_vsew_o})
	);
	
	vector_decode	decode_interface
	(
		.instruction_i			(if_vid_instruction_o),
		.system_vector_o		(vid_system_vector_o),
		.resource_vector_o		(vid_resource_vector_o),
		.register_vector_o		(vid_register_vector_o),
		.operation_vector_o		(vid_operation_vector_o)
	);
	
//////////////////////////////////////////////////////////////
//		VECTOR REGISTER READ STAGE
//////////////////////////////////////////////////////////////

	inter_stage_latch	
	#(.WIDTH 		({VS1_ADDRESS_LENGTH+VS2_ADDRESS_LENGTH+VD_ADDRESS_LENGTH+SYSTEM_VECTOR_LENGTH+RESOURCE_VECTOR_LENGTH+REGISTER_VECTOR_LENGTH+OPERATION_VECTOR_LENGTH+VSEW_LENGTH+F6_LENGTH}))
	vid_vrr_latch		//vid: vector instruction decode	,	vrr: vector register read
	(
		.clk_i		(clk_i	),
		.rstn_i		(rstn_i	),
		.flush_i	(flush_i),
		.load_i		(load_i	),
		.input_i	({if_vid_instruction_o[`vd_rd_vs3],if_vid_instruction_o[`vs2_sumop_lumop],if_vid_instruction_o[`vs1_rs1_imm],vid_system_vector_o,vid_resource_vector_o,vid_register_vector_o,vid_operation_vector_o,if_vid_vsew_o,if_vid_instruction_o[`funct6]}),
		.output_o	({vid_vrr_vd_address_o,vid_vrr_vs2_address_o,vid_vrr_vs1_address_o,vid_vrr_system_vector_o,vid_vrr_resource_vector_o,vid_vrr_register_vector_o,vid_vrr_operation_vector_o,vid_vrr_vsew_o,vid_vrr_f6_o})
	);
	assign	rs1_Ven_o		=	vid_vrr_register_vector_o[`register_vector_rs1];
	assign	rs1_address_o	=	vid_vrr_vs1_address_o;
	
	assign	vrr_register_vector_i	=	{vid_vrr_register_vector_o[`register_vector_vmask:`register_vector_vd_read],vexe_vwb_register_vector_o[`register_vector_vd_write],vid_vrr_register_vector_o[`register_vector_rs1:`register_vector_rd]};
	
	vector_register_read	vector_register_read_interface
	(
		.clk_i					(clk_i),
		.rs1_i					(rs1_data_i),
		.vs1_read_address_i		(vid_vrr_vs1_address_o),
		.vs2_read_address_i		(vid_vrr_vs2_address_o),
		.vd_read_address_i		(vid_vrr_vd_address_o ),
		.vsew_i					(vid_vrr_vsew_o),
		.vd_write_address_i		(vexe_vwb_vd_address_o),
		.vd_write_data_i		(vexe_vwb_vdata_o),
		.register_vector_i		(vrr_register_vector_i),
        .operation_vector_i     (vid_vrr_operation_vector_o),
		.vmask_read_data_o		(vrr_vmask_read_data_o	),
		.vs1_read_data_o		(vrr_vs1_read_data_o	),
		.vs2_read_data_o		(vrr_vs2_read_data_o	), 
		.rs1_read_data_o		(vrr_rs1_read_data_o	),
		.vd_read_data_o			(vrr_vd_read_data_o		)
	);
	
	assign vd_output_data 	= vrr_vd_read_data_o;
	
//////////////////////////////////////////////////////////////
//		VECTOR EXECUTION
//////////////////////////////////////////////////////////////

	
	inter_stage_latch	
	#(	.WIDTH 		(VS1_ADDRESS_LENGTH+VS2_ADDRESS_LENGTH+DATA_LENGTH+DATA_LENGTH+DATA_LENGTH+DATA_LENGTH+DATA_LENGTH+VD_ADDRESS_LENGTH+SYSTEM_VECTOR_LENGTH+RESOURCE_VECTOR_LENGTH+REGISTER_VECTOR_LENGTH+OPERATION_VECTOR_LENGTH+VSEW_LENGTH+F6_LENGTH))
	vrr_vexe_latch		//vrr: vector register read		,		vexe: vector execution
	(
		.clk_i		(clk_i	),
		.rstn_i		(rstn_i	),
		.flush_i	(flush_i),
		.load_i		(load_i	),
		.input_i	({vid_vrr_vs1_address_o,vid_vrr_vs2_address_o,vrr_rs1_read_data_o,vrr_vmask_read_data_o,vrr_vs1_read_data_o,vrr_vs2_read_data_o,vrr_vd_read_data_o,vid_vrr_vd_address_o,vid_vrr_system_vector_o,vid_vrr_resource_vector_o,vid_vrr_register_vector_o,vid_vrr_operation_vector_o,vid_vrr_vsew_o,vid_vrr_f6_o}),
		.output_o	({vrr_vexe_vs1_address_o,vrr_vexe_vs2_address_o,vrr_vexe_rs1_data_o,vrr_vexe_vmask_data_o,vrr_vexe_vs1_data_o,vrr_vexe_vs2_data_o,vrr_vexe_vd_data_o,vrr_vexe_vd_address_o,vrr_vexe_system_vector_o,vrr_vexe_resource_vector_o,vrr_vexe_register_vector_o,vrr_vexe_operation_vector_o,vrr_vexe_vsew_o,vrr_vexe_f6_o})
	);
	
	vector_alu_control_unit	vector_alu_control
	(
		.resource_vector_i			(vrr_vexe_resource_vector_o[`resource_vector_vfconv:`resource_vector_vadd]),
		.funct6_i					(vrr_vexe_f6_o),
		.vadd_control_vector_o		(vexe_vadd_control_vector_o	),
		.vlog_control_vector_o		(vexe_vlog_control_vector_o	),
		.vshft_control_vector_o		(vexe_vshft_control_vector_o),
		.vmul_control_vector_o		(vexe_vmul_control_vector_o	),
		.vmul_add_control_vector_o	()
	);
	
	vector_forward forward
	(
		.vrr_vexe_vs1_i		(vrr_vexe_vs1_address_o	),
		.vrr_vexe_vs2_i		(vrr_vexe_vs2_address_o	),
		.vexe_vwb_vd_i		(vexe_vwb_vd_address_o	),
		.vrr_vexe_dataa_i	(vrr_vexe_vs1_data_o	),
		.vrr_vexe_datab_i	(vrr_vexe_vs2_data_o	),
		.wb_vd_data_i		(vexe_vwb_vdata_o		),
		.vd_dataa_o			(vd_fw_dataa_o			),
		.vd_datab_o			(vd_fw_datab_o			)
	);
	
	assign	vd_dataa_i		=	(vrr_vexe_register_vector_o[`register_vector_vs1])	?	vd_fw_dataa_o:vrr_vexe_rs1_data_o;
	
    assign	vs1_output_data	=	vd_dataa_i;
	assign	vs2_output_data	=	vd_fw_datab_o;
    vector_execution	vector_execution_interface
	(
		.clk_i					(clk_i),
		.rst_ni					(rstn_i),
		.vadd_control_vector_o	(vexe_vadd_control_vector_o	),
		.vlog_control_vector_o	(vexe_vlog_control_vector_o	),
		.vshft_control_vector_o	(vexe_vshft_control_vector_o),
		.vmul_control_vector_o	(vexe_vmul_control_vector_o	),
		.resource_vector_i		(vrr_vexe_resource_vector_o	),
		.operation_vector_i		(vrr_vexe_operation_vector_o),
		.vs1_i					(vd_dataa_i					),
		.vs2_i					(vd_fw_datab_o				),
		.vd_i					(vrr_vexe_vd_data_o			),
		.vmask_i				(vrr_vexe_vmask_data_o		),
		.vsew_i					(vrr_vexe_vsew_o[1:0]		),
		.vd_o					(vexe_vdata_o				)
	);
/*
	vector_execution	vector_execution_interface	(
		.resource_vector_i		(vrr_vexe_resource_vector_o),
		.operation_vector_i		(vrr_vexe_operation_vector_o),
		.vs1_i					(vd_dataa_i),
		.vs2_i					(vd_fw_datab_o),
		.vsew_i					(vrr_vexe_vsew_o[1:0]),
		.vd_o					(vexe_vdata_o)
	);
	*/
//////////////////////////////////////////////////////////////
//		VECTOR WRITE BACK
//////////////////////////////////////////////////////////////

	inter_stage_latch	
	#(	.WIDTH 		(DATA_LENGTH+VD_ADDRESS_LENGTH+REGISTER_VECTOR_LENGTH))
	vexe_vwb_latch		//vexe: vector execution	,	vwb: vector write back
	(
		.clk_i		(clk_i	),
		.rstn_i		(rstn_i	),
		.flush_i	(flush_i),
		.load_i		(load_i	),
		.input_i	({vexe_vdata_o,vrr_vexe_vd_address_o,vrr_vexe_register_vector_o}),
		.output_o	({vexe_vwb_vdata_o,vexe_vwb_vd_address_o,vexe_vwb_register_vector_o})
	);
	
	assign output_data = vexe_vwb_vdata_o;
	
endmodule

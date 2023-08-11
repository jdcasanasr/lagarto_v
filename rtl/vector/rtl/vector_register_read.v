`include "../../includes/riscv_vector.vh"
module	vector_register_read	
#(
	parameter	VRF_WIDTH 			=	128,
	parameter	VRF_DEPTH 			=	32,
	parameter	VRF_ADDRESS_WIDTH 	=	$clog2(VRF_DEPTH),
	parameter	XRF_WIDTH			=	64
)(
	// From Lagarto-Hun
	input 	wire 									clk_i,
	input	wire	[XRF_WIDTH-1:0]					rs1_i,
	
	// From Vector Decode Stage
	input 	wire	[VRF_ADDRESS_WIDTH - 1:0] 		vs1_read_address_i,
	input 	wire	[VRF_ADDRESS_WIDTH - 1:0] 		vs2_read_address_i,
	input 	wire	[VRF_ADDRESS_WIDTH - 1:0] 		vd_read_address_i,
	input	wire	[1:0]							vsew_i,
	
	// From Vector Write-Back Stage
	input 	wire 	[VRF_ADDRESS_WIDTH - 1:0]		vd_write_address_i,
	input 	wire 	[VRF_WIDTH - 1:0]				vd_write_data_i,
	
	// From Vector Decode Stage (Let In Only the Vector Portion)
	input 	wire	[`REGISTER_VECTOR_WIDTH - 1:0] 	register_vector_i,
	input 	wire	[`OPERATION_VECTOR_WIDTH - 1:0] operation_vector_i,
	input 	wire	[`RESOURCE_VECTOR_WIDTH - 1:0] 	resource_vector_i,
	
	output 	wire 	[VRF_WIDTH - 1:0] 				vmask_read_data_o,
	output 	wire 	[VRF_WIDTH - 1:0] 				vs1_read_data_o,
	output 	wire 	[VRF_WIDTH - 1:0] 				vs2_read_data_o, 
	output 	wire 	[VRF_WIDTH - 1:0] 				rs1_read_data_o,
	output 	wire 	[VRF_WIDTH - 1:0] 				vd_read_data_o
);
	
	wire	[XRF_WIDTH-1:0]	imm_extended_o;
	wire	[XRF_WIDTH-1:0]	sc_unit_i;

    immediate_extension_unit	immediate_extension_unit_inst
    (
        .imm5_i             (vs1_read_address_i),
        .extension_type_i   (operation_vector_i[`operation_vector_sa]),
        .imm5_extended_o    (imm_extended_o)
    );
	assign	sc_unit_i	=	(register_vector_i[`register_vector_rs1])	?	rs1_i:imm_extended_o;
    
    scalar_conversion_unit	scalar_conversion_unit_inst
    (
        .rs1_i          (sc_unit_i),
        .vsew_i         (vsew_i),
        .chip_enable    ({resource_vector_i[`resource_vector_imm]	||	register_vector_i[`register_vector_rs1]}),
        .v_rs1_o		(rs1_read_data_o)
    );

	vector_register_file
	#(
		.VRF_WIDTH 				(VRF_WIDTH 			),
		.VRF_DEPTH 				(VRF_DEPTH 			),
		.VRF_ADDRESS_WIDTH 		(VRF_ADDRESS_WIDTH	)
	)
	register_file
	(
		.clk_i					(clk_i				),
		.vs1_read_address_i		(vs1_read_address_i	),
		.vs2_read_address_i		(vs2_read_address_i	),
		.vd_read_address_i		(vd_read_address_i	),
		.vd_write_address_i		(vd_write_address_i	),
		.vd_write_data_i		(vd_write_data_i	),
		.register_vector_i		(register_vector_i	),
		.vmask_read_data_o		(vmask_read_data_o	),
		.vs1_read_data_o		(vs1_read_data_o	),
		.vs2_read_data_o		(vs2_read_data_o	),
		.vd_read_data_o			(vd_read_data_o		)
	);
endmodule

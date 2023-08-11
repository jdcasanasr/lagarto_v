`include	"../Headers/riscv_vector.vh"
`include	"../Headers/riscv_vector_integer.vh"
`include	"../Headers/riscv_vector_memory.vh"
`include	"../Headers/riscv_vector_reduction.vh"
`include	"../Headers/riscv_vector_permutation.vh"
`include	"../Headers/riscv_vector_fixed_point.vh"
`include	"../Headers/riscv_vector_floating_point.vh"
`include	"../Headers/riscv_vector_mask.vh"
`include 	"../Headers/riscv_vector_instructions.vh"

module vdecode_tb ();

	localparam INSTRUCTION_LENGTH	 	= 	`instruction_length;
	localparam SYSTEM_VECTOR_LENGTH 	=	`system_vector_length;
	localparam RESOURCE_VECTOR_LENGTH 	= 	`resource_vector_length;
	localparam REGISTER_VECTOR_LENGTH 	=	`register_vector_length;
	localparam OPERATION_VECTOR_LENGTH 	= 	`operation_vector_length;

	reg 	[INSTRUCTION_LENGTH - 1:0] 		instruction_i_r;
	
	wire 	[SYSTEM_VECTOR_LENGTH - 1:0] 	system_vector_o_w;
	wire 	[RESOURCE_VECTOR_LENGTH - 1:0] 	resource_vector_o_w;
	wire 	[REGISTER_VECTOR_LENGTH - 1:0] 	register_vector_o_w;
	wire 	[OPERATION_VECTOR_LENGTH - 1:0] operation_vector_o_w;

	initial
		instruction_i_r = {INSTRUCTION_LENGTH{1'b0}};
		
	always
		begin
			//	integer
			#20 instruction_i_r = `vadd_vv;
			#5	if	(system_vector_o_w	==	`vadd_vv_system_vector	&&	resource_vector_o_w	==	`vadd_vv_resource_vector	&&	register_vector_o_w	==	`vadd_vv_register_vector	&&	operation_vector_o_w	==	`vadd_vv_operation_vector)
			$monitor("instruction:	vadd_vv			yes");
			else
			$monitor("instruction:	vadd_vv			no");
			#20 instruction_i_r = `vadd_vx;
			#5	if	(system_vector_o_w	==	`vadd_vx_system_vector	&&	resource_vector_o_w	==	`vadd_vx_resource_vector	&&	register_vector_o_w	==	`vadd_vx_register_vector	&&	operation_vector_o_w	==	`vadd_vx_operation_vector)
			$monitor("instruction:	vadd_vx			yes");
			else
			$monitor("instruction:	vadd_vx			no");
			#20 instruction_i_r = `vadd_vi;
			#5	if	(system_vector_o_w	==	`vadd_vi_system_vector	&&	resource_vector_o_w	==	`vadd_vi_resource_vector	&&	register_vector_o_w	==	`vadd_vi_register_vector	&&	operation_vector_o_w	==	`vadd_vi_operation_vector)
			$monitor("instruction:	vadd_vi			yes");
			else
			$monitor("instruction:	vadd_vi			no");
			//	floating point
			#20 instruction_i_r = `vfadd_vv;
			#5	if	(system_vector_o_w	==	`vfadd_vv_system_vector	&&	resource_vector_o_w	==	`vfadd_vv_resource_vector	&&	register_vector_o_w	==	`vfadd_vv_register_vector	&&	operation_vector_o_w	==	`vfadd_vv_operation_vector)
			$monitor("instruction:	vfadd_vv			yes");
			else
			$monitor("instruction:	vfadd_vv			no");
			#20 instruction_i_r = `vfadd_vf;
			#5	if	(system_vector_o_w	==	`vfadd_vf_system_vector	&&	resource_vector_o_w	==	`vfadd_vf_resource_vector	&&	register_vector_o_w	==	`vfadd_vf_register_vector	&&	operation_vector_o_w	==	`vfadd_vf_operation_vector)
			$monitor("instruction:	vfadd_vf			yes");
			else
			$monitor("instruction:	vfadd_vf			no");
			//	reduction
			#20 instruction_i_r = `vredsum_vs;
			#5	if	(system_vector_o_w	==	`vredsum_vf_system_vector	&&	resource_vector_o_w	==	`vredsum_vf_resource_vector	&&	register_vector_o_w	==	`vredsum_vf_register_vector	&&	operation_vector_o_w	==	`vredsum_vf_operation_vector)
			$monitor("instruction:	vredsum_vf			yes");
			else
			$monitor("instruction:	vredsum_vf			no");
			//	permutation
			#20 instruction_i_r = `vmv_x_s;
			#5	if	(system_vector_o_w	==	`vmv_x_s_system_vector	&&	resource_vector_o_w	==	`vmv_x_s_resource_vector	&&	register_vector_o_w	==	`vmv_x_s_register_vector	&&	operation_vector_o_w	==	`vmv_x_s_operation_vector)
			$monitor("instruction:	vmv_x_s			yes");
			else
			$monitor("instruction:	vmv_x_s			no");
			//	mask
			#20 instruction_i_r = `vmand_mm;
			#5	if	(system_vector_o_w	==	`vmand_mm_system_vector	&&	resource_vector_o_w	==	`vmand_mm_resource_vector	&&	register_vector_o_w	==	`vmand_mm_register_vector	&&	operation_vector_o_w	==	`vmand_mm_operation_vector)
			$monitor("instruction:	vmand_mm			yes");
			else
			$monitor("instruction:	vmand_mm			no");
			//	memory
			#20 instruction_i_r = `vle8_v;
			#5	if	(system_vector_o_w	==	`vle8_v_system_vector	&&	resource_vector_o_w	==	`vle8_v_resource_vector	&&	register_vector_o_w	==	`vle8_v_register_vector	&&	operation_vector_o_w	==	`vle8_v_operation_vector)
			$monitor("instruction:	vle8_v			yes");
			else
			$monitor("instruction:	vle8_v			no");
			#20 instruction_i_r = `vle16_v;
			#5	if	(system_vector_o_w	==	`vle16_v_system_vector	&&	resource_vector_o_w	==	`vle16_v_resource_vector	&&	register_vector_o_w	==	`vle16_v_register_vector	&&	operation_vector_o_w	==	`vle16_v_operation_vector)
			$monitor("instruction:	vle16_v			yes");
			else
			$monitor("instruction:	vle16_v			no");
			#20 instruction_i_r = `vle32_v;
			#5	if	(system_vector_o_w	==	`vle32_v_system_vector	&&	resource_vector_o_w	==	`vle32_v_resource_vector	&&	register_vector_o_w	==	`vle32_v_register_vector	&&	operation_vector_o_w	==	`vle32_v_operation_vector)
			$monitor("instruction:	vle32_v			yes");
			else
			$monitor("instruction:	vle32_v			no");
			#20 instruction_i_r = `vle64_v;
			#5	if	(system_vector_o_w	==	`vle64_v_system_vector	&&	resource_vector_o_w	==	`vle64_v_resource_vector	&&	register_vector_o_w	==	`vle64_v_register_vector	&&	operation_vector_o_w	==	`vle64_v_operation_vector)
			$monitor("instruction:	vle64_v			yes");
			else
			$monitor("instruction:	vle64_v			no");
			//	fixed point
			#20 instruction_i_r = `vsaddu_vv;
			#5	if	(system_vector_o_w	==	`vsaddu_vv_system_vector	&&	resource_vector_o_w	==	`vsaddu_vv_resource_vector	&&	register_vector_o_w	==	`vsaddu_vv_register_vector	&&	operation_vector_o_w	==	`vsaddu_vv_operation_vector)
			$monitor("instruction:	vsaddu_vv			yes");
			else
			$monitor("instruction:	vsaddu_vv			no");
			#20 instruction_i_r = `vsaddu_vx;
			#5	if	(system_vector_o_w	==	`vsaddu_vx_system_vector	&&	resource_vector_o_w	==	`vsaddu_vx_resource_vector	&&	register_vector_o_w	==	`vsaddu_vx_register_vector	&&	operation_vector_o_w	==	`vsaddu_vx_operation_vector)
			$monitor("instruction:	vsaddu_vx			yes");
			else
			$monitor("instruction:	vsaddu_vx			no");
			#20 instruction_i_r = `vsaddu_vi;
			#5	if	(system_vector_o_w	==	`vsaddu_vi_system_vector	&&	resource_vector_o_w	==	`vsaddu_vi_resource_vector	&&	register_vector_o_w	==	`vsaddu_vi_register_vector	&&	operation_vector_o_w	==	`vsaddu_vi_operation_vector)
			$monitor("instruction:	vsaddu_vi			yes");
			else
			$monitor("instruction:	vsaddu_vi			no");
			#20;
			#20 $stop;
		end
	
	// Module Instances
	vdecode vdecode_instance
	(
		.instruction_i 		(instruction_i_r),
		
		.system_vector_o 	(system_vector_o_w),
		.resource_vector_o 	(resource_vector_o_w),
		.register_vector_o 	(register_vector_o_w),
		.operation_vector_o (operation_vector_o_w)
	);
	
endmodule

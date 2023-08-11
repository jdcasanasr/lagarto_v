`include	"includes/riscv_vector.vh"
`include	"includes/riscv_vector_integer.vh"
`include	"includes/riscv_vector_memory.vh"
`include	"includes/riscv_vector_reduction.vh"
`include	"includes/riscv_vector_permutation.vh"
`include	"includes/riscv_vector_fixed_point.vh"
`include	"includes/riscv_vector_floating_point.vh"
`include	"includes/riscv_vector_mask.vh"
`include	"includes/latency_decode.vh"

module	latency_decode_unit
(
	input		[`resource_vector_length-1:0]	resource_vector_i,
	input		[1:0]							vsew_i,

	output	reg	[$clog2(`maximum_latency):0]	latency_o
);

	always @ (*)
		begin
			case (resource_vector_i)
				//******************Integer Instructions****************//
				`vmul_vv_resource_vector	:	latency_o	=	`vmul_latency;			//for multiplication module latency

				`vmadd_vv_resource_vector	:	latency_o	=	`vmadd_latency;			//for multiply-add module latency 
				`vdiv_vv_resource_vector	:
					begin									//for division module latency
						case	(vsew_i)
							`vsew_64b	:	latency_o	=	`vdiv_latency_64b;
							`vsew_32b	:	latency_o	=	`vdiv_latency_32b;
							default		:	latency_o	=	`standard_latency;
						endcase
					end

				//******************Floating-Point Instructions**********//
				`vfadd_vv_resource_vector	:	latency_o	=	`vfadd_module_latency;	//for floating point adder module latency
				`vfmul_vv_resource_vector	:	latency_o	=	`vfmul_module_latency;	//for floating point multiplication module latency
				`vfdiv_vv_resource_vector	:	latency_o	=	`vfdiv_module_latency;	//for floating point division module latency
				`vfmax_vv_resource_vector	:	latency_o	=	`vfcomp_module_latency;	//for floating point comparision module latency
				`vfmacc_vv_resource_vector	:	latency_o	=	`vfmadd_module_latency;	//for floating point multiply-add module latency

				//******************Other Instructions******************//
				default						:	latency_o	=	`standard_latency; 		// VADD, VSZEXT, VLOGIC, VSHFT, VCMP, VMERGE
			endcase
		end

endmodule

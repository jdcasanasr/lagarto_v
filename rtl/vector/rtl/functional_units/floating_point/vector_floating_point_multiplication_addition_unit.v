// {negate_product_i, multiplication_addition_subtraction_i, overwrite_addend_multiplicand_i}.
`define vfmacc 		3'b000
`define vfnmacc 	3'b110

`define vfmsac 		3'b010
`define vfnmsac 	3'b100

`define vfmadd 		3'b000
`define vfnmadd 	3'b110

`define vfmsub 		3'b010
`define vfnmsub 	3'b100

// SEW
`define vsew_8b     2'b00
`define vsew_16b    2'b01
`define vsew_32b    2'b10
`define vsew_64b    2'b11

module vector_floating_point_multiplication_addition_unit
#(parameter VLEN = 128)
(
	input 						clock_i,
	input 						reset_ni,

	input 						request_i,

	input 		[1:0] 			vsew_i,

	input  						negate_product_i,
	input  						multiplication_addition_subtraction_i,
	input  						overwrite_addend_multiplicand_i,

	input 		[VLEN - 1:0] 	vs2_i,
	input 		[VLEN - 1:0] 	vs1_i,
	input 		[VLEN - 1:0] 	vd_old_i,

	output reg 	[VLEN - 1:0] 	vd_o
);

	// vector_floating_point_multiplication_unit Signals.
	reg 	[VLEN - 1:0] multiplicand_effective_r;
	wire 	[VLEN - 1:0] vfmul_vd_w;
	
	reg 	[VLEN - 1:0] product_effective_r;
	reg  	[VLEN - 1:0] addend_effective_r;
	wire 	[VLEN - 1:0] vfadd_vd_w;

	// vector_floating_point_addition_unit Pipeline.
	reg 	[2:0]	configuration_vector_r [3:0];
	wire 	[2:0]	configuration_vector_w [3:0];

	reg  	[127:0] vd_old_r 	[3:0];
	wire  	[127:0] vd_old_w 	[3:0];

	reg  	[127:0] vs2_r 		[3:0];
	wire  	[127:0] vs2_w 		[3:0];
	
	reg 	[1:0] 	vsew_r 		[3:0];
	wire  	[1:0] 	vsew_w 		[3:0];

	reg 	[8:0]	request_r;
	wire  	[8:0]	request_w;

	// Manage multiplicand_effective_r.
	always @ (*)
		case ({negate_product_i, multiplication_addition_subtraction_i, overwrite_addend_multiplicand_i})
			`vfmacc , `vfnmacc, `vfmsac , `vfnmsac 	: multiplicand_effective_r = vs2_i;
			`vfmadd , `vfnmadd, `vfmsub , `vfnmsub 	: multiplicand_effective_r = vd_old_i;

			default 								: multiplicand_effective_r = 128'b0;
		endcase

	// Manage product_effective_r.
	always @ (*)
		case (configuration_vector_w[3])
			`vfnmacc, `vfnmsac, `vfnmadd, `vfnmsub 	:
				case (vsew_w[3])
					`vsew_32b 	:
						begin
							product_effective_r[31:0] 	= {~vfmul_vd_w[31], 	vfmul_vd_w[30:0]};
							product_effective_r[63:32] 	= {~vfmul_vd_w[63], 	vfmul_vd_w[62:32]};
							product_effective_r[95:64] 	= {~vfmul_vd_w[95], 	vfmul_vd_w[94:64]};
							product_effective_r[127:96] = {~vfmul_vd_w[127], 	vfmul_vd_w[126:96]};
						end

					`vsew_64b 	:
						begin
							product_effective_r[63:0] 	= {~vfmul_vd_w[63], 	vfmul_vd_w[62:0]};
							product_effective_r[127:64] = {~vfmul_vd_w[127], 	vfmul_vd_w[126:64]};
						end

					default 	: product_effective_r = 128'b0;
				endcase

			`vfmacc, `vfmsac, `vfmadd, `vfmsub 		: product_effective_r = vfmul_vd_w;

			default 								: product_effective_r = 128'b0;
		endcase

	// Manage addend_effective_r.
	always @ (*)
		case (configuration_vector_w[3])
			`vfmacc , `vfnmacc, `vfmsac , `vfnmsac 	: addend_effective_r = vd_old_w[3];
			`vfmadd , `vfnmadd, `vfmsub , `vfnmsub 	: addend_effective_r = vs2_w[3];

			default 								: addend_effective_r = 128'b0;
		endcase

	// Manane vector_floating_point_addition_unit Pipeline.
	assign vsew_w[0] 					= vsew_r[0];
	assign vsew_w[1] 					= vsew_r[1];
	assign vsew_w[2] 					= vsew_r[2];
	assign vsew_w[3] 					= vsew_r[3];

	assign configuration_vector_w[0] 	= configuration_vector_r[0];
	assign configuration_vector_w[1] 	= configuration_vector_r[1];
	assign configuration_vector_w[2] 	= configuration_vector_r[2];
	assign configuration_vector_w[3] 	= configuration_vector_r[3];

	assign vd_old_w[0] 					= vd_old_r[0];
	assign vd_old_w[1] 					= vd_old_r[1];
	assign vd_old_w[2] 					= vd_old_r[2];
	assign vd_old_w[3] 					= vd_old_r[3];

	assign vs2_w[0] 					= vs2_r[0];
	assign vs2_w[1] 					= vs2_r[1];
	assign vs2_w[2] 					= vs2_r[2];
	assign vs2_w[3] 					= vs2_r[3];

	assign request_w[0] 				= request_r[0];
	assign request_w[1] 				= request_r[1];
	assign request_w[2] 				= request_r[2];
	assign request_w[3] 				= request_r[3];
	assign request_w[4] 				= request_r[4];
	assign request_w[5] 				= request_r[5];
	assign request_w[6] 				= request_r[6];
	assign request_w[7] 				= request_r[7];
	assign request_w[8] 				= request_r[8];

	always @ (posedge clock_i, negedge reset_ni)
		if (!reset_ni)
			begin
				configuration_vector_r[0] 	= 3'b0;
				configuration_vector_r[1] 	= 3'b0;
				configuration_vector_r[2] 	= 3'b0;
				configuration_vector_r[3] 	= 3'b0;

				vsew_r[0] 					= 2'b0;
				vsew_r[1] 					= 2'b0;
				vsew_r[2] 					= 2'b0;
				vsew_r[3] 					= 2'b0;

				vd_old_r[0] 				= 128'b0;
				vd_old_r[1] 				= 128'b0;
				vd_old_r[2] 				= 128'b0;
				vd_old_r[3] 				= 128'b0;

				vs2_r[0] 					= 128'b0;
				vs2_r[1] 					= 128'b0;
				vs2_r[2] 					= 128'b0;
				vs2_r[3] 					= 128'b0;

				request_r[0] 				= 1'b0;
				request_r[1] 				= 1'b0;
				request_r[2] 				= 1'b0;
				request_r[3] 				= 1'b0;
				request_r[4] 				= 1'b0;
				request_r[5] 				= 1'b0;
				request_r[6] 				= 1'b0;
				request_r[7] 				= 1'b0;
				request_r[8] 				= 1'b0;
			end
		else
			begin
				configuration_vector_r[0] = {negate_product_i, multiplication_addition_subtraction_i, overwrite_addend_multiplicand_i};
				configuration_vector_r[1] = configuration_vector_w[0];
				configuration_vector_r[2] = configuration_vector_w[1];
				configuration_vector_r[3] = configuration_vector_w[2];

				vsew_r[0] 					= vsew_i;
				vsew_r[1] 					= vsew_w[0];
				vsew_r[2] 					= vsew_w[1];
				vsew_r[3] 					= vsew_w[2];

				vd_old_r[0] 				= vd_old_i;
				vd_old_r[1] 				= vd_old_w[0];
				vd_old_r[2] 				= vd_old_w[1];
				vd_old_r[3] 				= vd_old_w[2];

				vs2_r[0] 					= vs2_i;
				vs2_r[1] 					= vs2_w[0];
				vs2_r[2] 					= vs2_w[1];
				vs2_r[3] 					= vs2_w[2];
				
				request_r[0] 				= request_i;
				request_r[1] 				= request_w[0];
				request_r[2] 				= request_w[1];
				request_r[3] 				= request_w[2];
				request_r[4] 				= request_w[3];
				request_r[5] 				= request_w[4];
				request_r[6] 				= request_w[5];
				request_r[7] 				= request_w[6];
				request_r[8] 				= request_w[7];
			end

	// Manage vd_o.
	always @ (*)
		if (request_w[8])
			vd_o = vfadd_vd_w;
		else
			vd_o = 128'b0;

	VFP_multiplier_unit	vector_floating_point_multiplication_unit_instance
	(
		.clk_i 			(clock_i),
		.rst_ni 		(reset_ni),

		.chip_enable_i 	(request_i),

		.vsew_i			(vsew_i),

		.vs2_i 			(multiplicand_effective_r),
		.vs1_i 			(vs1_i),
		
		.vd_o 			(vfmul_vd_w),

		.busy 			(),
		.done 			(),
		.counter 		(),
		.p32_p64 		()
	);

	VFP_addsub_unit	vector_floating_point_addition_unit_instance
	(
		.clk_i 			(clock_i),
		.rst_ni 		(reset_ni),

		.add_sub_i 		(configuration_vector_w[3][1]),

		.vsew_i 		(vsew_w[3]),

		.vs2_i 			(product_effective_r),
		.vs1_i 			(addend_effective_r),
		

		.vd_o 			(vfadd_vd_w),

		.busy 			(),
		.done 			(),
		.cycle_counter 	(),
		.p32_p64 		()
	);

endmodule
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

module vector_floating_point_multiplication_addition_unit_tb ();

	bit 			clock_r;
	bit 			reset_nr;

	bit 			request_r;

	bit [1:0] 		vsew_r;

	bit 			negate_product_r;
	bit 			multiplication_addition_subtraction_r;
	bit 			overwrite_addend_multiplicand_r;

	bit [127:0] 	vs2_r;
	bit [127:0] 	vs1_r;
	bit [127:0] 	vd_old_r;

	wire [127:0] 	vd_w;

	initial
		begin
			clock_r 																					= '1;
			reset_nr 																					= '1;

			request_r 																					= '0;

			vsew_r 																						= '0;

			{negate_product_r, multiplication_addition_subtraction_r, overwrite_addend_multiplicand_r} 	= '0;

			vs2_r 																						= '0;
			vs1_r 																						= '0;
			vd_old_r 																					= '0;
		end

	initial
		forever
			#10 clock_r = ~clock_r;

	initial
		begin
			#5 reset_nr = '0;
			#5 reset_nr = '1;
		end

	initial
		begin
			#20 request_r 																					= '1;
				vsew_r 																						= `vsew_32b;
				{negate_product_r, multiplication_addition_subtraction_r, overwrite_addend_multiplicand_r} 	= `vfmacc;

				vs2_r 																						= {32'b01000000000100001100010010011100, 32'b01000000110011110111010010111100, 32'b01000001000010101101100100010111, 32'b01000000111111000010000011000101};
				vs1_r 																						= {32'b01000001000100100111101011100001, 32'b01000000111101011010100111111100, 32'b01000000110010010001111010111000, 32'b01000000110010000000100000110001};
				vd_old_r 																					= {32'b01000000110011000100000110001001, 32'b01000001000010010001001001101111, 32'b01000000101111101011100001010010, 32'b00111111101011101011100001010010};

			#20 request_r 																					= '1;
				vsew_r 																						= `vsew_32b;
				{negate_product_r, multiplication_addition_subtraction_r, overwrite_addend_multiplicand_r} 	= `vfnmacc;

				vs2_r 																						= {32'b01000000000100001100010010011100, 32'b01000000110011110111010010111100, 32'b01000001000010101101100100010111, 32'b01000000111111000010000011000101};
				vs1_r 																						= {32'b01000001000100100111101011100001, 32'b01000000111101011010100111111100, 32'b01000000110010010001111010111000, 32'b01000000110010000000100000110001};
				vd_old_r 																					= {32'b01000000110011000100000110001001, 32'b01000001000010010001001001101111, 32'b01000000101111101011100001010010, 32'b00111111101011101011100001010010};

			#20 request_r 																					= '0;
				vsew_r 																						= '0;
				{negate_product_r, multiplication_addition_subtraction_r, overwrite_addend_multiplicand_r} 	= '0;

				vs2_r 																						= '0;
				vs1_r 																						= '0;
				vd_old_r 																					= '0;


			#200 ;
			#20 $stop;
		end

	vector_floating_point_multiplication_addition_unit dut
	(
		.clock_i 								(clock_r),
		.reset_ni 								(reset_nr),

		.request_i 								(request_r),

		.vsew_i 								(vsew_r),

		.negate_product_i 						(negate_product_r),
		.multiplication_addition_subtraction_i 	(multiplication_addition_subtraction_r),
		.overwrite_addend_multiplicand_i 		(overwrite_addend_multiplicand_r),

		.vs2_i 									(vs2_r),
		.vs1_i 									(vs1_r),
		.vd_old_i 								(vd_old_r),

		.vd_o 									(vd_w)
	);

endmodule
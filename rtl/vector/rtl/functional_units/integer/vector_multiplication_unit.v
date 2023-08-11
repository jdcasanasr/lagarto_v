// Vector SEW Values.
`define vsew_32b 	2'b10 	// SEW = 32
`define vsew_64b 	2'b11 	// SEW = 64

// Scalar funct3 Values.
`define mul 		3'b000 	// Scalar Signed Product.
`define mulh		3'b001 	// Scalar Signed Product, Return High Half.
`define mulhsu 		3'b010 	// Scalar Signed Multiplicand, Unsigned Multiplier Product, Return High Half.
`define mulhu 		3'b011 	// Scalar Unsigned Product, Return High Half.

// Control Signals Concatenation.
// {vs2_signed_unsigned_i, vs1_signed_unsigned_i, vd_high_low_part_i}.
`define vmul 		3'b110 	// Vector Signed Product, Return Low Half.
`define vmulh 		3'b111 	// Vector Signed Product, Return High Half.
`define vmulhsu 	3'b101 	// Vector Signed Multiplicand, Unsigned Multiplier Product, Return High Half.
`define vmulhu 		3'b001 	// Vector Unsigned Product, Return High Half.

module vector_multiplication_unit
(
	input					clock_i,
	input					reset_ni,
	input					request_i,
	input			[1:0] 	vsew_i,
	input					vs2_signed_unsigned_i, 	// vs2 Is Signed Or Unsigned.
	input					vs1_signed_unsigned_i, 	// vs1 Is Signed Or Unsigned.
	input					vd_high_low_part_i, 	// Enable High Or Low Half.
	input			[127:0] vs2_i,
	input			[127:0] vs1_i,
	output	reg		[127:0] vd_o, 					// Return High Or Low Half Of The Product.
	output	reg		[255:0] vd_complete_o, 			// Return Complete Product.
	output	wire	[1:0]	cycle_counter
);
	Latency_Counter
	#(
		.LATENCY 	(3)
	)	cycle_count	(
		.clock_i	(clock_i		),
		.reset_ni	(reset_ni		),
		.request_i	(request_i		),
		.counter_o	(cycle_counter	)
	);
	// Effective Vector Inputs.
	reg [63:0] vs2_effective_r [3:0];
	reg [63:0] vs1_effective_r [3:0];

	// Scalar Sub-Modules Control Signals.
	reg [3:0] 	scalar_request_r;
	reg [2:0] 	funct3_r;
	reg 		multiplication_32b_r;

	// Scalar Sub-Modules Output Signals.
	wire 	[63:0] 	scalar_result_w 			[3:0];
	wire 	[127:0] scalar_complete_result_w 	[3:0];
	reg 	[255:0] vd_complete_o_r;

	// Manage scalar_request_r.
	always @ (*)
		if (request_i)
			case (vsew_i)
				`vsew_32b 	: scalar_request_r = 4'b1111;
				`vsew_64b 	: scalar_request_r = 4'b0011;

				default 	: scalar_request_r = 4'b0000;
			endcase
		else
			scalar_request_r = 4'b0000;

	// Manage funct3_r.
	always @ (*)
		case ({vs2_signed_unsigned_i, vs1_signed_unsigned_i, vd_high_low_part_i})
			`vmul 		: funct3_r = `mul;
			`vmulh 		: funct3_r = `mulh;
			`vmulhsu 	: funct3_r = `mulhsu;
			`vmulhu 	: funct3_r = `mulhu;

			default 	: funct3_r = 3'b000;
		endcase

	// Manage multiplication_32b_r.
	always @ (*)
		multiplication_32b_r = ((vsew_i == `vsew_32b) ? 1'b1 : 1'b0);

	// Manage vs2_effective_r And vs1_effective_r.
	always @ (*)
		case (vsew_i)
			`vsew_32b 	:
				begin
					vs1_effective_r[0] = (vs1_i[31] 	? {{32{vs1_i[31]}}, 	vs1_i[31:0]} 	: {{32{1'b0}}, vs1_i[31:0]});
					vs1_effective_r[1] = (vs1_i[63] 	? {{32{vs1_i[63]}}, 	vs1_i[63:32]} 	: {{32{1'b0}}, vs1_i[63:32]});
					vs1_effective_r[2] = (vs1_i[95] 	? {{32{vs1_i[95]}}, 	vs1_i[95:64]} 	: {{32{1'b0}}, vs1_i[95:64]});
					vs1_effective_r[3] = (vs1_i[127] 	? {{32{vs1_i[127]}}, 	vs1_i[127:96]} 	: {{32{1'b0}}, vs1_i[127:96]});

					vs2_effective_r[0] = (vs2_i[31] 	? {{32{vs2_i[31]}}, 	vs2_i[31:0]} 	: {{32{1'b0}}, vs2_i[31:0]});
					vs2_effective_r[1] = (vs2_i[63] 	? {{32{vs2_i[63]}}, 	vs2_i[63:32]} 	: {{32{1'b0}}, vs2_i[63:32]});
					vs2_effective_r[2] = (vs2_i[95] 	? {{32{vs2_i[95]}}, 	vs2_i[95:64]} 	: {{32{1'b0}}, vs2_i[95:64]});
					vs2_effective_r[3] = (vs2_i[127] 	? {{32{vs2_i[127]}}, 	vs2_i[127:96]} 	: {{32{1'b0}}, vs2_i[127:96]});
				end

			`vsew_64b 	:
				begin
					vs1_effective_r[0] = vs1_i[63:0];
					vs1_effective_r[1] = vs1_i[127:64];
					vs1_effective_r[2] = 64'b0;
					vs1_effective_r[3] = 64'b0;

					vs2_effective_r[0] = vs2_i[63:0];
					vs2_effective_r[1] = vs2_i[127:64];
					vs2_effective_r[2] = 64'b0;
					vs2_effective_r[3] = 64'b0;
				end

			default 	:
				begin
					vs1_effective_r[0] = 64'b0;
					vs1_effective_r[1] = 64'b0;
					vs1_effective_r[2] = 64'b0;
					vs1_effective_r[3] = 64'b0;

					vs2_effective_r[0] = 64'b0;
					vs2_effective_r[1] = 64'b0;
					vs2_effective_r[2] = 64'b0;
					vs2_effective_r[3] = 64'b0;
				end
		endcase

	// Manage vd_o.
	always @ (*)
		case (vsew_i)
			`vsew_32b 	: vd_o = {	scalar_result_w[3][31:0], scalar_result_w[2][31:0],
									scalar_result_w[1][31:0], scalar_result_w[0][31:0]};

			`vsew_64b 	: vd_o = {scalar_result_w[1], scalar_result_w[0]};

			default 	: vd_o = 64'b0;
		endcase

	// Manage vd_complete_o_r.
	always @ (*)
		case (vsew_i)
			`vsew_32b 	: vd_complete_o_r = {	scalar_complete_result_w[3][63:0], scalar_complete_result_w[2][63:0],
												scalar_complete_result_w[1][63:0], scalar_complete_result_w[0][63:0]};

			`vsew_64b 	: vd_complete_o_r = {scalar_complete_result_w[1], scalar_complete_result_w[0]};

			default 	: vd_complete_o_r = 256'b0;
		endcase

	// Manage vd_o_complete.
	always @ (*)
		vd_complete_o = vd_complete_o_r;

	// Scalar Sub-Modules Instances.
	scalar_32b_64b_multiplication_unit scalar_32b_64b_multiplication_unit_instance_0
	(
		.clock_i 				(clock_i),
		.reset_ni 				(reset_ni),

		.request_i 				(scalar_request_r[0]),

		.funct3_i 				(funct3_r),
		.multiplication_32b_i 	(multiplication_32b_r),

		.rs1_i 					(vs1_effective_r[0]),
		.rs2_i 					(vs2_effective_r[0]),

		.rd_o 					(scalar_result_w[0]),
		.rd_complete_o 			(scalar_complete_result_w[0])
	);

	scalar_32b_64b_multiplication_unit scalar_32b_64b_multiplication_unit_instance_1
	(
		.clock_i 				(clock_i),
		.reset_ni 				(reset_ni),

		.request_i 				(scalar_request_r[1]),

		.funct3_i 				(funct3_r),
		.multiplication_32b_i 	(multiplication_32b_r),

		.rs1_i 					(vs1_effective_r[1]),
		.rs2_i 					(vs2_effective_r[1]),

		.rd_o 					(scalar_result_w[1]),
		.rd_complete_o 			(scalar_complete_result_w[1])
	);

	scalar_32b_64b_multiplication_unit scalar_32b_64b_multiplication_unit_instance_2
	(
		.clock_i 				(clock_i),
		.reset_ni 				(reset_ni),

		.request_i 				(scalar_request_r[2]),

		.funct3_i 				(funct3_r),
		.multiplication_32b_i 	(multiplication_32b_r),

		.rs1_i 					(vs1_effective_r[2]),
		.rs2_i 					(vs2_effective_r[2]),

		.rd_o 					(scalar_result_w[2]),
		.rd_complete_o 			(scalar_complete_result_w[2])
	);

	scalar_32b_64b_multiplication_unit scalar_32b_64b_multiplication_unit_instance_3
	(
		.clock_i 				(clock_i),
		.reset_ni 				(reset_ni),

		.request_i 				(scalar_request_r[3]),

		.funct3_i 				(funct3_r),
		.multiplication_32b_i 	(multiplication_32b_r),

		.rs1_i 					(vs1_effective_r[3]),
		.rs2_i 					(vs2_effective_r[3]),

		.rd_o 					(scalar_result_w[3]),
		.rd_complete_o 			(scalar_complete_result_w[3])
	);

endmodule
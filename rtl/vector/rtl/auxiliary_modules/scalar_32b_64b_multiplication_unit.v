// funct3 Definitions For Scalar Integer Products.
`define mul 	3'b000 	// Signed Product.
`define mulh	3'b001 	// Signed Product, Return High Half.
`define mulhu 	3'b011 	// Unsigned Product, Return High Half.
`define mulhsu 	3'b010 	// Signed Multiplicand, Unsigned Multiplier Product, Return High Half.

module scalar_32b_64b_multiplication_unit
(
	input 				clock_i,
	input 				reset_ni,
	
	input 				request_i,

	input 		[2:0] 	funct3_i,
	input 				multiplication_32b_i, 	// Enable 32-bit Multiplication.

	input 		[63:0] 	rs1_i, 					// Multiplicand.
	input 		[63:0] 	rs2_i,					// Multiplier.

	output reg 	[63:0] 	rd_o,					// Low Or High Half Of The Product.
	output reg 	[127:0] rd_complete_o 			// Complete Product.
);

	// Inter-Stage Latches.
	// Idle-Multiplying Latches.
	reg 		request_0_r;
	reg [2:0] 	funct3_r;
	reg 		multiplication_32b_r;

	reg [63:0]	rs1_r;
	reg [63:0] 	rs2_r;

	// Multiplying-Done Latches.
	wire 		request_0_w;
	reg 		request_1_r;
	reg [63:0] 	rd_r;
	reg [127:0] rd_complete_r;

	// Result Buses.
	reg 		result_sign_r;
	reg [63:0] 	result_64b_r;
	reg [127:0] result_128b_r;
	reg [127:0] result_128b_effective_r;

	// Effective Inputs.
	reg [63:0] 	rs1_effective_r;
	reg [63:0] 	rs2_effective_r;

	assign request_0_w = request_0_r;

	// Manage result_sign_r
	always @ (*)
		result_sign_r = (multiplication_32b_r ? rs1_r[31] ^ rs2_r[31] : rs1_r[63] ^ rs2_r[63]);
	
	// Manage rs1_effective_r And rs2_effective_r.
	always @ (*)
		if (multiplication_32b_r)
			begin
				rs1_effective_r = (rs1_r[31] ? ~rs1_r + 64'd1 : rs1_r);
				rs2_effective_r = (rs2_r[31] ? ~rs2_r + 64'd1 : rs2_r);
			end
		else
			begin
				rs1_effective_r = (rs1_r[63] ? ~rs1_r + 64'd1 : rs1_r);
				rs2_effective_r = (rs2_r[63] ? ~rs2_r + 64'd1 : rs2_r);
			end

	// Perform Complete 128-bit Product.
	always @ (*)
		result_128b_r = rs1_effective_r * rs2_effective_r;

	// Manage result_128b_effective_r.
	always @ (*)
		case (funct3_r)
			`mul, `mulh : result_128b_effective_r = (result_sign_r ? ~result_128b_r + 128'd1 : result_128b_r);
			`mulhu 		: result_128b_effective_r = result_128b_r;
			`mulhsu 	:
				if (multiplication_32b_r)
					result_128b_effective_r = (rs1_r[31] ? ~result_128b_r + 128'd1 : result_128b_r);
				else
					result_128b_effective_r = (rs1_r[63] ? ~result_128b_r + 128'd1 : result_128b_r);

			default 	: result_128b_effective_r = 128'b0;
		endcase

	// Manage rd_r
	always @ (*)
		if (multiplication_32b_r)
			result_64b_r = result_128b_effective_r[63:0];
		else
			case (funct3_r)
				`mul 					: result_64b_r = result_128b_effective_r[63:0];
				`mulh, `mulhu, `mulhsu 	: result_64b_r = result_128b_effective_r[127:64];

				default 				: result_64b_r = 64'b0;
			endcase

	// Manage rd_o
	always @ (*)
		if (request_1_r)
			begin
				rd_o 			= rd_r;
				rd_complete_o 	= rd_complete_r;
			end
		else
			begin
				rd_o 			= 64'd0;
				rd_complete_o 	= 128'd0;
			end

	// Manage FSM States And Internal Pipeline Stages.
	always @ (posedge clock_i, negedge reset_ni)
		if (!reset_ni)
			begin
				// Idle-Multiplying Transition.
				request_0_r 			= 1'b0;
				funct3_r				= 3'b0;
				multiplication_32b_r 	= 1'b0;

				rs1_r 					= 64'b0;
				rs2_r 					= 64'b0;

				// Multiplying-Done Transition.
				request_1_r 			= 1'b0;
				rd_r 					= 64'b0;
				rd_complete_r 			= 128'b0;
			end

		else
			begin
				// Idle-Multiplying Transition.
				request_0_r 			= request_i;
				funct3_r				= funct3_i;
				multiplication_32b_r 	= multiplication_32b_i;

				rs1_r 					= rs1_i;
				rs2_r 					= rs2_i;

				// Multiplying-Done Transition.
				request_1_r 			= request_0_w;
				rd_r 					= result_64b_r;
				rd_complete_r 			= result_128b_effective_r;
			end

endmodule
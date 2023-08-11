`define vmadc_m 4'b0011
`define vmadc 	4'b0010
`define vmsbc_m 4'b0111
`define vmsbc	4'b0110

module vector_adder_64b
(
	input 		[63:0] 	vs2_i,
	input 		[63:0] 	vs1_i,
	
	// For add-with-carry and subtract-with-borrow
	// Operations, vmask Contains Input Carries/Borrows
	// Note: Only the Necessary bits are Let Through
	input 		[7:0] 	vmask_i,
	
	input 		[1:0] 	vsew_i,
	
	// In this case, add_sub_i Will Select Between
	// Addition and Subtraction
	input 				add_sub_i,
	
	// If set, vd_o Will Have the Output Carries
	// in Mask Format Instead of the Result of
	// an Addition or a Subtraction
	input				compute_carry_i,
	
	// If set, vmask_i Will Be Taken As the Carry/
	// Borrow Input
	input 				with_carry_borrow_i,
	
	// If set, (vs1 - vs2) will be performed instead of
	// (vs2 - vs1)
	input				reversed_i,

	output reg 	[63:0] 	vd_o,
	output reg 		 	carry_o
);
	// Buses for vs2_i's and vs1_i's Effective Versions
	reg [63:0] vs2_i_effective_w;
	reg [63:0] vs1_i_effective_w;
	
	// Carry/Borrow from vmask_i
	reg [7:0] external_carry_borrow_r;
	
	// Control Signals for Inter-Byte Multiplexers
	wire [1:0] multiplexer_control_w [7:0];

	// Multiplexers' Output Bus
	wire [7:0] multiplexer_selection_w;
	
	// Whole full_adder_byte Network's carry_o Bus
	wire [7:0] full_adder_byte_carry_output_w;
	
	// Bus for full_adder_byte Instances' Outputs
	wire [63:0] vd_o_w;
	
	// Bus for full_adder_byte Instances' Output,
	// When Computing Carries Instead of Additions
	// or Subtractions
	reg [7:0] vd_o_carry_r;
	
	// Manage vd_o_carry_w's Bits in Mask Format
	always @ (*)
		case (vsew_i)
			2'b00 : vd_o_carry_r = full_adder_byte_carry_output_w;
			
			2'b01 :
				begin
					vd_o_carry_r[0] 	= full_adder_byte_carry_output_w[1];
					vd_o_carry_r[1] 	= full_adder_byte_carry_output_w[3];
					vd_o_carry_r[2] 	= full_adder_byte_carry_output_w[5];
					vd_o_carry_r[3] 	= full_adder_byte_carry_output_w[7];
					vd_o_carry_r[7:4] 	= 4'b0;
				end
			
			2'b10 :
				begin
					vd_o_carry_r[0] 	= full_adder_byte_carry_output_w[3];
					vd_o_carry_r[1] 	= full_adder_byte_carry_output_w[7];
					vd_o_carry_r[7:2] 	= 6'b0;
				end
				
			2'b11 :
				begin
					vd_o_carry_r[0] 	= full_adder_byte_carry_output_w[7];
					vd_o_carry_r[7:1] 	= 7'b0;
				end
		endcase
	
	// Manage vmask_i's Bits to Fit Every SEW Case
	always @ (*)
		case ({add_sub_i, with_carry_borrow_i})
			// Add-with-Carry Case
			2'b01 	:
				case (vsew_i)
					2'b00 : external_carry_borrow_r = vmask_i;
					
					2'b01 :
						begin
							external_carry_borrow_r[0] = vmask_i[0];
							external_carry_borrow_r[2] = vmask_i[1];
							external_carry_borrow_r[4] = vmask_i[2];
							external_carry_borrow_r[6] = vmask_i[3];
							
							external_carry_borrow_r[1] = 1'b0;
							external_carry_borrow_r[3] = 1'b0;
							external_carry_borrow_r[5] = 1'b0;
							external_carry_borrow_r[7] = 1'b0;
						end
						
					2'b10 :
						begin
							external_carry_borrow_r[0] = vmask_i[0];
							external_carry_borrow_r[4] = vmask_i[1];
							
							external_carry_borrow_r[1] = 1'b0;
							external_carry_borrow_r[2] = 1'b0;
							external_carry_borrow_r[3] = 1'b0;
							external_carry_borrow_r[5] = 1'b0;
							external_carry_borrow_r[6] = 1'b0;
							external_carry_borrow_r[7] = 1'b0;
						end
					
					2'b11 :
						begin
							external_carry_borrow_r[0] = vmask_i[0];
							
							external_carry_borrow_r[1] = 1'b0;
							external_carry_borrow_r[2] = 1'b0;
							external_carry_borrow_r[3] = 1'b0;
							external_carry_borrow_r[4] = 1'b0;
							external_carry_borrow_r[5] = 1'b0;
							external_carry_borrow_r[6] = 1'b0;
							external_carry_borrow_r[7] = 1'b0;
						end	
				endcase
			
			// Subtract-with-Borrow Case
			2'b11 	:
				case (vsew_i)
					2'b00 : external_carry_borrow_r = ~vmask_i;
					
					2'b01 :
						begin
							external_carry_borrow_r[0] = ~vmask_i[0];
							external_carry_borrow_r[2] = ~vmask_i[1];
							external_carry_borrow_r[4] = ~vmask_i[2];
							external_carry_borrow_r[6] = ~vmask_i[3];
							
							external_carry_borrow_r[1] = 1'b0;
							external_carry_borrow_r[3] = 1'b0;
							external_carry_borrow_r[5] = 1'b0;
							external_carry_borrow_r[7] = 1'b0;
						end
						
					2'b10 :
						begin
							external_carry_borrow_r[0] = ~vmask_i[0];
							external_carry_borrow_r[4] = ~vmask_i[1];
							
							external_carry_borrow_r[1] = 1'b0;
							external_carry_borrow_r[2] = 1'b0;
							external_carry_borrow_r[3] = 1'b0;
							external_carry_borrow_r[5] = 1'b0;
							external_carry_borrow_r[6] = 1'b0;
							external_carry_borrow_r[7] = 1'b0;
						end
					
					2'b11 :
						begin
							external_carry_borrow_r[0] = ~vmask_i[0];
							
							external_carry_borrow_r[1] = 1'b0;
							external_carry_borrow_r[2] = 1'b0;
							external_carry_borrow_r[3] = 1'b0;
							external_carry_borrow_r[4] = 1'b0;
							external_carry_borrow_r[5] = 1'b0;
							external_carry_borrow_r[6] = 1'b0;
							external_carry_borrow_r[7] = 1'b0;
						end	
				endcase
				
			// Common add/sub Operation (Without External
			// Carries)
			default : external_carry_borrow_r = 8'b0;
		endcase
		
	// Depending on add_sub_i's and inverted_i's Value, 
	// We'll Let Through Either an Inverted version of vs1
	// or vs2 (for Subtraction)or As They Are, for Addition
	always @ (*)
		case ({add_sub_i, reversed_i})
			2'b00 :
				begin
					vs2_i_effective_w = vs2_i;
					vs1_i_effective_w = vs1_i;
				end
				
			2'b10 :
				begin
					vs2_i_effective_w = vs2_i;
					vs1_i_effective_w = ~vs1_i;
				end
				
			2'b11 :
				begin
					vs2_i_effective_w = vs1_i;
					vs1_i_effective_w = ~vs2_i;
				end
				
			default :
				begin
					vs2_i_effective_w = 64'b0;
					vs1_i_effective_w = 64'b0;
				end
		endcase
	
	// Drive vd_o with vd_o_w (full_adder_byte Instances'
	// Outputs) Or vd_carry_o_r (Carry Outputs)
	always @ (*)
		case ({reversed_i, add_sub_i, compute_carry_i, with_carry_borrow_i})
			`vmadc_m, `vmadc 	: vd_o = {{56{1'b0}}, vd_o_carry_r};
			`vmsbc_m, `vmsbc 	: vd_o = {{56{1'b0}}, ~vd_o_carry_r};

			default 			: vd_o = vd_o_w;
		endcase

	// Drive full_adder_byte_inst_7's Carry Output with
	// vector_addition_unit's carry_o Value
	always @ (*)
		carry_o = full_adder_byte_carry_output_w[7];
	
	// Sub-Module Instances
	// multiplexer_control_unit
	multiplexer_control_unit multiplexer_control_unit_inst
	(
		.add_sub_i 					(add_sub_i),
		.with_carry_borrow_i		(with_carry_borrow_i),

		.vsew_i 					(vsew_i),
		
		.multiplexer_selection_0_o 	(multiplexer_control_w[0]),
		.multiplexer_selection_1_o 	(multiplexer_control_w[1]),
		.multiplexer_selection_2_o 	(multiplexer_control_w[2]),
		.multiplexer_selection_3_o 	(multiplexer_control_w[3]),
		.multiplexer_selection_4_o 	(multiplexer_control_w[4]),
		.multiplexer_selection_5_o 	(multiplexer_control_w[5]),
		.multiplexer_selection_6_o 	(multiplexer_control_w[6]),
		.multiplexer_selection_7_o 	(multiplexer_control_w[7])
	);
	
	// multiplexer_4x1
	multiplexer_4x1 multiplexer_4x1_inst_0
	(
		.a_i 			(1'b0), 						// Interconnection
		.b_i 			(1'b0), 						// Addition
		.c_i 			(1'b1), 						// Subtraction
		.d_i 			(external_carry_borrow_r[0]), 	// External Carry
		
		.control_i 		(multiplexer_control_w[0]),
		
		.selection_o 	(multiplexer_selection_w[0])
	);
	
	multiplexer_4x1 multiplexer_4x1_inst_1
	(
		.a_i 			(full_adder_byte_carry_output_w[0]),
		.b_i 			(1'b0),
		.c_i 			(1'b1),
		.d_i 			(external_carry_borrow_r[1]),
		
		.control_i 		(multiplexer_control_w[1]),
		
		.selection_o 	(multiplexer_selection_w[1])
	);
	
	multiplexer_4x1 multiplexer_4x1_inst_2
	(
		.a_i 			(full_adder_byte_carry_output_w[1]),
		.b_i 			(1'b0),
		.c_i 			(1'b1),
		.d_i 			(external_carry_borrow_r[2]),
		
		.control_i 		(multiplexer_control_w[2]),
		
		.selection_o 	(multiplexer_selection_w[2])
	);
	
	multiplexer_4x1 multiplexer_4x1_inst_3
	(
		.a_i 			(full_adder_byte_carry_output_w[2]),
		.b_i 			(1'b0),
		.c_i 			(1'b1),
		.d_i 			(external_carry_borrow_r[3]),
		
		.control_i 		(multiplexer_control_w[3]),
		
		.selection_o 	(multiplexer_selection_w[3])
	);
	
	multiplexer_4x1 multiplexer_4x1_inst_4
	(
		.a_i 			(full_adder_byte_carry_output_w[3]),
		.b_i 			(1'b0),
		.c_i 			(1'b1),
		.d_i 			(external_carry_borrow_r[4]),
		
		.control_i 		(multiplexer_control_w[4]),
		
		.selection_o 	(multiplexer_selection_w[4])
	);
	
	multiplexer_4x1 multiplexer_4x1_inst_5
	(
		.a_i 			(full_adder_byte_carry_output_w[4]),
		.b_i 			(1'b0),
		.c_i 			(1'b1),
		.d_i 			(external_carry_borrow_r[5]),
		
		.control_i 		(multiplexer_control_w[5]),
		
		.selection_o 	(multiplexer_selection_w[5])
	);
	
	multiplexer_4x1 multiplexer_4x1_inst_6
	(
		.a_i 			(full_adder_byte_carry_output_w[5]),
		.b_i 			(1'b0),
		.c_i 			(1'b1),
		.d_i 			(external_carry_borrow_r[6]),
		
		.control_i 		(multiplexer_control_w[6]),
		
		.selection_o 	(multiplexer_selection_w[6])
	);
	
	multiplexer_4x1 multiplexer_4x1_inst_7
	(
		.a_i 			(full_adder_byte_carry_output_w[6]),
		.b_i 			(1'b0),
		.c_i 			(1'b1),
		.d_i 			(external_carry_borrow_r[7]),
		
		.control_i 		(multiplexer_control_w[7]),
		
		.selection_o 	(multiplexer_selection_w[7])
	);
	
	// full_adder_byte
	full_adder_byte full_adder_byte_inst_0
	(
		.a_i 		(vs2_i_effective_w[7:0]),
		.b_i 		(vs1_i_effective_w[7:0]),
		.carry_i 	(multiplexer_selection_w[0]),
		
		.sum_o 		(vd_o_w[7:0]),
		.carry_o 	(full_adder_byte_carry_output_w[0])
	);
	
	full_adder_byte full_adder_byte_inst_1
	(
		.a_i 		(vs2_i_effective_w[15:8]),
		.b_i 		(vs1_i_effective_w[15:8]),
		.carry_i 	(multiplexer_selection_w[1]),
		
		.sum_o 		(vd_o_w[15:8]),
		.carry_o 	(full_adder_byte_carry_output_w[1])
	);
	
	full_adder_byte full_adder_byte_inst_2
	(
		.a_i 		(vs2_i_effective_w[23:16]),
		.b_i 		(vs1_i_effective_w[23:16]),
		.carry_i 	(multiplexer_selection_w[2]),
		
		.sum_o 		(vd_o_w[23:16]),
		.carry_o 	(full_adder_byte_carry_output_w[2])
	);
	
	full_adder_byte full_adder_byte_inst_3
	(
		.a_i 		(vs2_i_effective_w[31:24]),
		.b_i 		(vs1_i_effective_w[31:24]),
		.carry_i 	(multiplexer_selection_w[3]),
		
		.sum_o 		(vd_o_w[31:24]),
		.carry_o 	(full_adder_byte_carry_output_w[3])
	);
	
	full_adder_byte full_adder_byte_inst_4
	(
		.a_i 		(vs2_i_effective_w[39:32]),
		.b_i 		(vs1_i_effective_w[39:32]),
		.carry_i 	(multiplexer_selection_w[4]),
		
		.sum_o 		(vd_o_w[39:32]),
		.carry_o 	(full_adder_byte_carry_output_w[4])
	);
	
	full_adder_byte full_adder_byte_inst_5
	(
		.a_i 		(vs2_i_effective_w[47:40]),
		.b_i 		(vs1_i_effective_w[47:40]),
		.carry_i 	(multiplexer_selection_w[5]),
		
		.sum_o 		(vd_o_w[47:40]),
		.carry_o 	(full_adder_byte_carry_output_w[5])
	);
	
	full_adder_byte full_adder_byte_inst_6
	(
		.a_i 		(vs2_i_effective_w[55:48]),
		.b_i 		(vs1_i_effective_w[55:48]),
		.carry_i 	(multiplexer_selection_w[6]),
		
		.sum_o 		(vd_o_w[55:48]),
		.carry_o 	(full_adder_byte_carry_output_w[6])
	);
	
	full_adder_byte full_adder_byte_inst_7
	(
		.a_i 		(vs2_i_effective_w[63:56]),
		.b_i 		(vs1_i_effective_w[63:56]),
		.carry_i 	(multiplexer_selection_w[7]),
		
		.sum_o 		(vd_o_w[63:56]),
		.carry_o 	(full_adder_byte_carry_output_w[7])
	);
	
endmodule
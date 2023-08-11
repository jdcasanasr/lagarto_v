`define vadd_8b 	4'b0000
`define vadd_16b 	4'b0001
`define vadd_32b 	4'b0010
`define vadd_64b 	4'b0011

`define vsub_8b 	4'b1000
`define vsub_16b 	4'b1001
`define vsub_32b 	4'b1010
`define vsub_64b 	4'b1011

`define vadc_8b 	4'b0100
`define vadc_16b 	4'b0101
`define vadc_32b 	4'b0110
`define vadc_64b 	4'b0111

`define vsbc_8b 	4'b1100
`define vsbc_16b 	4'b1101
`define vsbc_32b 	4'b1110
`define vsbc_64b 	4'b1111

`define interconnection 2'b00
`define addition		2'b01
`define subtraction		2'b10
`define external_carry 	2'b11

module multiplexer_control_unit
(
	input				add_sub_i,
	input				with_carry_borrow_i,

	input		[1:0]	vsew_i,
	
	
	output reg	[1:0]	multiplexer_selection_0_o,
	output reg	[1:0]	multiplexer_selection_1_o,
	output reg	[1:0]	multiplexer_selection_2_o,
	output reg	[1:0]	multiplexer_selection_3_o,
	output reg	[1:0]	multiplexer_selection_4_o,
	output reg	[1:0]	multiplexer_selection_5_o,
	output reg	[1:0]	multiplexer_selection_6_o,
	output reg	[1:0]	multiplexer_selection_7_o
);

	always @ (*)
		case ({add_sub_i, with_carry_borrow_i, vsew_i})
			`vadd_8b  			:
				begin
					multiplexer_selection_0_o = `addition;
					multiplexer_selection_1_o = `addition;
					multiplexer_selection_2_o = `addition;
					multiplexer_selection_3_o = `addition;
					multiplexer_selection_4_o = `addition;
					multiplexer_selection_5_o = `addition;
					multiplexer_selection_6_o = `addition;
					multiplexer_selection_7_o = `addition;
				end

			`vadd_16b			:
				begin
					multiplexer_selection_0_o = `addition;
					multiplexer_selection_1_o = `interconnection;
					multiplexer_selection_2_o = `addition;
					multiplexer_selection_3_o = `interconnection;
					multiplexer_selection_4_o = `addition;
					multiplexer_selection_5_o = `interconnection;
					multiplexer_selection_6_o = `addition;
					multiplexer_selection_7_o = `interconnection;
				end

			`vadd_32b			:
				begin
					multiplexer_selection_0_o = `addition;
					multiplexer_selection_1_o = `interconnection;
					multiplexer_selection_2_o = `interconnection;
					multiplexer_selection_3_o = `interconnection;
					multiplexer_selection_4_o = `addition;
					multiplexer_selection_5_o = `interconnection;
					multiplexer_selection_6_o = `interconnection;
					multiplexer_selection_7_o = `interconnection;
				end

			`vadd_64b			:
				begin
					multiplexer_selection_0_o = `addition;
					multiplexer_selection_1_o = `interconnection;
					multiplexer_selection_2_o = `interconnection;
					multiplexer_selection_3_o = `interconnection;
					multiplexer_selection_4_o = `interconnection;
					multiplexer_selection_5_o = `interconnection;
					multiplexer_selection_6_o = `interconnection;
					multiplexer_selection_7_o = `interconnection;
				end

			`vsub_8b  			:
				begin
					multiplexer_selection_0_o = `subtraction;
					multiplexer_selection_1_o = `subtraction;
					multiplexer_selection_2_o = `subtraction;
					multiplexer_selection_3_o = `subtraction;
					multiplexer_selection_4_o = `subtraction;
					multiplexer_selection_5_o = `subtraction;
					multiplexer_selection_6_o = `subtraction;
					multiplexer_selection_7_o = `subtraction;
				end

			`vsub_16b			:
				begin
					multiplexer_selection_0_o = `subtraction;
					multiplexer_selection_1_o = `interconnection;
					multiplexer_selection_2_o = `subtraction;
					multiplexer_selection_3_o = `interconnection;
					multiplexer_selection_4_o = `subtraction;
					multiplexer_selection_5_o = `interconnection;
					multiplexer_selection_6_o = `subtraction;
					multiplexer_selection_7_o = `interconnection;
				end

			`vsub_32b			:
				begin
					multiplexer_selection_0_o = `subtraction;
					multiplexer_selection_1_o = `interconnection;
					multiplexer_selection_2_o = `interconnection;
					multiplexer_selection_3_o = `interconnection;
					multiplexer_selection_4_o = `subtraction;
					multiplexer_selection_5_o = `interconnection;
					multiplexer_selection_6_o = `interconnection;
					multiplexer_selection_7_o = `interconnection;
				end

			`vsub_64b			:
				begin
					multiplexer_selection_0_o = `subtraction;
					multiplexer_selection_1_o = `interconnection;
					multiplexer_selection_2_o = `interconnection;
					multiplexer_selection_3_o = `interconnection;
					multiplexer_selection_4_o = `interconnection;
					multiplexer_selection_5_o = `interconnection;
					multiplexer_selection_6_o = `interconnection;
					multiplexer_selection_7_o = `interconnection;
				end

			`vadc_8b, `vsbc_8b	:
				begin
					multiplexer_selection_0_o = `external_carry;
					multiplexer_selection_1_o = `external_carry;
					multiplexer_selection_2_o = `external_carry;
					multiplexer_selection_3_o = `external_carry;
					multiplexer_selection_4_o = `external_carry;
					multiplexer_selection_5_o = `external_carry;
					multiplexer_selection_6_o = `external_carry;
					multiplexer_selection_7_o = `external_carry;
				end

			`vadc_16b, `vsbc_16b 	:
				begin
					multiplexer_selection_0_o = `external_carry;
					multiplexer_selection_1_o = `interconnection;
					multiplexer_selection_2_o = `external_carry;
					multiplexer_selection_3_o = `interconnection;
					multiplexer_selection_4_o = `external_carry;
					multiplexer_selection_5_o = `interconnection;
					multiplexer_selection_6_o = `external_carry;
					multiplexer_selection_7_o = `interconnection;
				end

			`vadc_32b, `vsbc_32b	:
				begin
					multiplexer_selection_0_o = `external_carry;
					multiplexer_selection_1_o = `interconnection;
					multiplexer_selection_2_o = `interconnection;
					multiplexer_selection_3_o = `interconnection;
					multiplexer_selection_4_o = `external_carry;
					multiplexer_selection_5_o = `interconnection;
					multiplexer_selection_6_o = `interconnection;
					multiplexer_selection_7_o = `interconnection;
				end

			`vadc_64b, `vsbc_64b	:
				begin
					multiplexer_selection_0_o = `external_carry;
					multiplexer_selection_1_o = `interconnection;
					multiplexer_selection_2_o = `interconnection;
					multiplexer_selection_3_o = `interconnection;
					multiplexer_selection_4_o = `interconnection;
					multiplexer_selection_5_o = `interconnection;
					multiplexer_selection_6_o = `interconnection;
					multiplexer_selection_7_o = `interconnection;
				end
		endcase

endmodule
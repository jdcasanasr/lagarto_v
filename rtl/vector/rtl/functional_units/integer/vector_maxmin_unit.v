module vector_maxmin_unit(
	input					chip_enable_i,
	input					signed_unsigned_i,
	input					maxmin_type_i,
	input		[2:0]		vsew_i,
	input		[127:0]		vs1_i,
	input		[127:0]		vs2_i,
	output reg	[127:0]		vd_o
);
	reg [15:0]		input_carry_w;
	wire [15:0] 	output_carry_w;
	wire [127:0]	vs1_inverted_bus_w;
	wire [127:0] 	output_sum_bus_w;
	
	reg [15:0]		less_than_8_w;
	reg [7:0]		less_than_16_w;
	reg [3:0]		less_than_32_w;
	reg [1:0]		less_than_64_w;
		
	reg [14:0]		carry_selection_w;
	reg [15:0]		byte_selection_w;
	
	assign vs1_inverted_bus_w = ~vs1_i;
	// Manage carry_selection[i].
	always @(*)
		begin
			case(vsew_i)
				3'b000:
					begin
						carry_selection_w  = 15'h7FFF;
						//carry_selection_w[0]  = 1'b1;	// Byte 1.
						//carry_selection_w[1]  = 1'b1;	// Byte 2.
						//carry_selection_w[2]  = 1'b1;	// Byte 3.
						//carry_selection_w[3]  = 1'b1;	// Byte 4.
						//carry_selection_w[4]  = 1'b1;	// Byte 5.
						//carry_selection_w[5]  = 1'b1;	// Byte 6.
						//carry_selection_w[6]  = 1'b1;	// Byte 7.
						//carry_selection_w[7]  = 1'b1;	// Byte 8.
						//carry_selection_w[8]  = 1'b1;	// Byte 9.
						//carry_selection_w[9]  = 1'b1;	// Byte 10.
						//carry_selection_w[10] = 1'b1;	// Byte 11.
						//carry_selection_w[11] = 1'b1;	// Byte 12.
						//carry_selection_w[12] = 1'b1;	// Byte 13.
						//carry_selection_w[13] = 1'b1;	// Byte 14.
						//carry_selection_w[14] = 1'b1;	// Byte 15.
					end
				3'b001:
					begin
						carry_selection_w  = 15'h2AAA;
						//carry_selection_w[0]  = 1'b0;	// Byte 1.
						//carry_selection_w[1]  = 1'b1;	// Byte 2.
						//carry_selection_w[2]  = 1'b0;	// Byte 3.
						//carry_selection_w[3]  = 1'b1;	// Byte 4.
						//carry_selection_w[4]  = 1'b0;	// Byte 5.
						//carry_selection_w[5]  = 1'b1;	// Byte 6.
						//carry_selection_w[6]  = 1'b0;	// Byte 7.
						//carry_selection_w[7]  = 1'b1;	// Byte 8.
						//carry_selection_w[8]  = 1'b0;	// Byte 9.
						//carry_selection_w[9]  = 1'b1;	// Byte 10.
						//carry_selection_w[10] = 1'b0;	// Byte 11.
						//carry_selection_w[11] = 1'b1;	// Byte 12.
						//carry_selection_w[12] = 1'b0;	// Byte 13.
						//carry_selection_w[13] = 1'b1;	// Byte 14.
						//carry_selection_w[14] = 1'b0;	// Byte 15.
					end
					
				3'b010:
					begin
						carry_selection_w  = 15'h0888;
						//carry_selection_w[0]  = 1'b0;	// Byte 1.
						//carry_selection_w[1]  = 1'b0;	// Byte 2.
						//carry_selection_w[2]  = 1'b0;	// Byte 3.
						//carry_selection_w[3]  = 1'b1;	// Byte 4.
						//carry_selection_w[4]  = 1'b0;	// Byte 5.
						//carry_selection_w[5]  = 1'b0;	// Byte 6.
						//carry_selection_w[6]  = 1'b0;	// Byte 7.
						//carry_selection_w[7]  = 1'b1;	// Byte 8.
						//carry_selection_w[8]  = 1'b0;	// Byte 9.
						//carry_selection_w[9]  = 1'b0;	// Byte 10.
						//carry_selection_w[10] = 1'b0;	// Byte 11.
						//carry_selection_w[11] = 1'b1;	// Byte 12.
						//carry_selection_w[12] = 1'b0;	// Byte 13.
						//carry_selection_w[13] = 1'b0;	// Byte 14.
						//carry_selection_w[14] = 1'b0;	// Byte 15.
					end
				3'b011:
					begin
						carry_selection_w  = 15'h0;
						//carry_selection_w[0]  = 1'b0;	// Byte 1.
						//carry_selection_w[1]  = 1'b0;	// Byte 2.
						//carry_selection_w[2]  = 1'b0;	// Byte 3.
						//carry_selection_w[3]  = 1'b0;	// Byte 4.
						//carry_selection_w[4]  = 1'b0;	// Byte 5.
						//carry_selection_w[5]  = 1'b0;	// Byte 6.
						//carry_selection_w[6]  = 1'b0;	// Byte 7.
						//carry_selection_w[7]  = 1'b0;	// Byte 8.
						//carry_selection_w[8]  = 1'b0;	// Byte 9.
						//carry_selection_w[9]  = 1'b0;	// Byte 10.
						//carry_selection_w[10] = 1'b0;	// Byte 11.
						//carry_selection_w[11] = 1'b0;	// Byte 12.
						//carry_selection_w[12] = 1'b0;	// Byte 13.
						//carry_selection_w[13] = 1'b0;	// Byte 14.
						//carry_selection_w[14] = 1'b0;	// Byte 15.
					end
				default:
					carry_selection_w	=	'b0;
			endcase
		end
		
	// Manage input_carry_w[0].
	always @(*)
		input_carry_w[0] = 1'b1;
	
	// Manage input_carry_w[1].
	always @(*)
		if (carry_selection_w[0])
			input_carry_w[1] = 1'b1;
			
		else
			input_carry_w[1] = output_carry_w[0];
	
	// Manage input_carry_w[2].
	always @(*)
		if (carry_selection_w[1])
			input_carry_w[2] = 1'b1;
			
		else
			input_carry_w[2] = output_carry_w[1];
	
	// Manage input_carry[3].
	always @(*)
		if (carry_selection_w[2])
			input_carry_w[3] = 1'b1;
			
		else
			input_carry_w[3] = output_carry_w[2];
			
	// Manage input_carry[4].
	always @(*)
		if (carry_selection_w[3])
			input_carry_w[4] = 1'b1;
			
		else
			input_carry_w[4] = output_carry_w[3];
			
	// Manage input_carry[5].
	always @(*)
		if (carry_selection_w[4])
			input_carry_w[5] = 1'b1;
			
		else
			input_carry_w[5] = output_carry_w[4];
			
	// Manage input_carry[6].
	always @(*)
		if (carry_selection_w[5])
			input_carry_w[6] = 1'b1;
			
		else
			input_carry_w[6] = output_carry_w[5];
	
	// Manage input_carry[7].
	always @(*)
		if (carry_selection_w[6])
			input_carry_w[7] = 1'b1;
			
		else
			input_carry_w[7] = output_carry_w[6];
	
	// Manage input_carry_w[8].
	always @(*)
		if (carry_selection_w[7])
			input_carry_w[8] = 1'b1;
			
		else
			input_carry_w[8] = output_carry_w[7];
	
	// Manage input_carry_w[9].
	always @(*)
		if (carry_selection_w[8])
			input_carry_w[9] = 1'b1;
			
		else
			input_carry_w[9] = output_carry_w[8];
	
	// Manage input_carry_w[10].
	always @(*)
		if (carry_selection_w[9])
			input_carry_w[10] = 1'b1;
			
		else
			input_carry_w[10] = output_carry_w[9];
	
	// Manage input_carry_w[11].
	always @(*)
		if (carry_selection_w[10])
			input_carry_w[11] = 1'b1;
			
		else
			input_carry_w[11] = output_carry_w[10];
			
	// Manage input_carry_w[12].
	always @(*)
		if (carry_selection_w[11])
			input_carry_w[12] = 1'b1;
			
		else
			input_carry_w[12] = output_carry_w[11];
			
	// Manage input_carry_w[13].
	always @(*)
		if (carry_selection_w[12])
			input_carry_w[13] = 1'b1;
			
		else
			input_carry_w[13] = output_carry_w[12];
			
	// Manage input_carry_w[14].
	always @(*)
		if (carry_selection_w[13])
			input_carry_w[14] = 1'b1;
			
		else
			input_carry_w[14] = output_carry_w[13];
	
	// Manage input_carry_w[15].
	always @(*)
		if (carry_selection_w[14])
			input_carry_w[15] = 1'b1;
			
		else
			input_carry_w[15] = output_carry_w[14];
	
	// Assign "less than" signals.
	always @(*)
		case (signed_unsigned_i)
			1'b0: // SIGNED SIGNED
				begin
					less_than_8_w[0]  = output_sum_bus_w[7]   ^  (~(vs2_i[7]  ^ vs1_inverted_bus_w[7])   & (output_sum_bus_w[7]   ^ vs1_inverted_bus_w[7]));
					less_than_8_w[1]  = output_sum_bus_w[15]  ^ (~(vs2_i[15]  ^ vs1_inverted_bus_w[15])  & (output_sum_bus_w[15]  ^ vs1_inverted_bus_w[15]));
					less_than_8_w[2]  = output_sum_bus_w[23]  ^ (~(vs2_i[23]  ^ vs1_inverted_bus_w[23])  & (output_sum_bus_w[23]  ^ vs1_inverted_bus_w[23]));
					less_than_8_w[3]  = output_sum_bus_w[31]  ^ (~(vs2_i[31]  ^ vs1_inverted_bus_w[31])  & (output_sum_bus_w[31]  ^ vs1_inverted_bus_w[31]));
					less_than_8_w[4]  = output_sum_bus_w[39]  ^ (~(vs2_i[39]  ^ vs1_inverted_bus_w[39])  & (output_sum_bus_w[39]  ^ vs1_inverted_bus_w[39]));
					less_than_8_w[5]  = output_sum_bus_w[47]  ^ (~(vs2_i[47]  ^ vs1_inverted_bus_w[47])  & (output_sum_bus_w[47]  ^ vs1_inverted_bus_w[47]));
					less_than_8_w[6]  = output_sum_bus_w[55]  ^ (~(vs2_i[55]  ^ vs1_inverted_bus_w[55])  & (output_sum_bus_w[55]  ^ vs1_inverted_bus_w[55]));
					less_than_8_w[7]  = output_sum_bus_w[63]  ^ (~(vs2_i[63]  ^ vs1_inverted_bus_w[63])  & (output_sum_bus_w[63]  ^ vs1_inverted_bus_w[63]));
					less_than_8_w[8]  = output_sum_bus_w[71]  ^ (~(vs2_i[71]  ^ vs1_inverted_bus_w[71])  & (output_sum_bus_w[71]  ^ vs1_inverted_bus_w[71]));
					less_than_8_w[9]  = output_sum_bus_w[79]  ^ (~(vs2_i[79]  ^ vs1_inverted_bus_w[79])  & (output_sum_bus_w[79]  ^ vs1_inverted_bus_w[79]));
					less_than_8_w[10] = output_sum_bus_w[87]  ^ (~(vs2_i[87]  ^ vs1_inverted_bus_w[87])  & (output_sum_bus_w[87]  ^ vs1_inverted_bus_w[87]));
					less_than_8_w[11] = output_sum_bus_w[95]  ^ (~(vs2_i[95]  ^ vs1_inverted_bus_w[95])  & (output_sum_bus_w[95]  ^ vs1_inverted_bus_w[95]));
					less_than_8_w[12] = output_sum_bus_w[103] ^ (~(vs2_i[103] ^ vs1_inverted_bus_w[103]) & (output_sum_bus_w[103] ^ vs1_inverted_bus_w[103]));
					less_than_8_w[13] = output_sum_bus_w[111] ^ (~(vs2_i[111] ^ vs1_inverted_bus_w[111]) & (output_sum_bus_w[111] ^ vs1_inverted_bus_w[111]));
					less_than_8_w[14] = output_sum_bus_w[119] ^ (~(vs2_i[119] ^ vs1_inverted_bus_w[119]) & (output_sum_bus_w[119] ^ vs1_inverted_bus_w[119]));
					less_than_8_w[15] = output_sum_bus_w[127] ^ (~(vs2_i[127] ^ vs1_inverted_bus_w[127]) & (output_sum_bus_w[127] ^ vs1_inverted_bus_w[127]));
				
					less_than_16_w[0] = output_sum_bus_w[15]  ^ (~(vs2_i[15]  ^ vs1_inverted_bus_w[15])  & (output_sum_bus_w[15]  ^ vs1_inverted_bus_w[15]));
					less_than_16_w[1] = output_sum_bus_w[31]  ^ (~(vs2_i[31]  ^ vs1_inverted_bus_w[31])  & (output_sum_bus_w[31]  ^ vs1_inverted_bus_w[31]));
					less_than_16_w[2] = output_sum_bus_w[47]  ^ (~(vs2_i[47]  ^ vs1_inverted_bus_w[47])  & (output_sum_bus_w[47]  ^ vs1_inverted_bus_w[47]));
					less_than_16_w[3] = output_sum_bus_w[63]  ^ (~(vs2_i[63]  ^ vs1_inverted_bus_w[63])  & (output_sum_bus_w[63]  ^ vs1_inverted_bus_w[63]));
					less_than_16_w[4] = output_sum_bus_w[79]  ^ (~(vs2_i[79]  ^ vs1_inverted_bus_w[79])  & (output_sum_bus_w[79]  ^ vs1_inverted_bus_w[79]));
					less_than_16_w[5] = output_sum_bus_w[95]  ^ (~(vs2_i[95]  ^ vs1_inverted_bus_w[95])  & (output_sum_bus_w[95]  ^ vs1_inverted_bus_w[95]));
					less_than_16_w[6] = output_sum_bus_w[111] ^ (~(vs2_i[111] ^ vs1_inverted_bus_w[111]) & (output_sum_bus_w[111] ^ vs1_inverted_bus_w[111]));
					less_than_16_w[7] = output_sum_bus_w[127] ^ (~(vs2_i[127] ^ vs1_inverted_bus_w[127]) & (output_sum_bus_w[127] ^ vs1_inverted_bus_w[127]));
				
					less_than_32_w[0] = output_sum_bus_w[31]  ^ (~(vs2_i[31]  ^ vs1_inverted_bus_w[31])  & (output_sum_bus_w[31]  ^ vs1_inverted_bus_w[31]));
					less_than_32_w[1] = output_sum_bus_w[63]  ^ (~(vs2_i[63]  ^ vs1_inverted_bus_w[63])  & (output_sum_bus_w[63]  ^ vs1_inverted_bus_w[63]));
					less_than_32_w[2] = output_sum_bus_w[95]  ^ (~(vs2_i[95]  ^ vs1_inverted_bus_w[95])  & (output_sum_bus_w[95]  ^ vs1_inverted_bus_w[95]));
					less_than_32_w[3] = output_sum_bus_w[127] ^ (~(vs2_i[127] ^ vs1_inverted_bus_w[127]) & (output_sum_bus_w[127] ^ vs1_inverted_bus_w[127]));
				
					less_than_64_w[0] = output_sum_bus_w[63]  ^ (~(vs2_i[63]  ^ vs1_inverted_bus_w[63])  & (output_sum_bus_w[63]  ^ vs1_inverted_bus_w[63]));					
					less_than_64_w[1] = output_sum_bus_w[127] ^ (~(vs2_i[127] ^ vs1_inverted_bus_w[127]) & (output_sum_bus_w[127] ^ vs1_inverted_bus_w[127]));
				end
			
			1'b1: // UNSIGNED UNSIGNED
				begin
					less_than_8_w[0]  = ~output_carry_w[0];
					less_than_8_w[1]  = ~output_carry_w[1];
					less_than_8_w[2]  = ~output_carry_w[2];
					less_than_8_w[3]  = ~output_carry_w[3];
					less_than_8_w[4]  = ~output_carry_w[4];
					less_than_8_w[5]  = ~output_carry_w[5];
					less_than_8_w[6]  = ~output_carry_w[6];
					less_than_8_w[7]  = ~output_carry_w[7];
					less_than_8_w[8]  = ~output_carry_w[8];
					less_than_8_w[9]  = ~output_carry_w[9];
					less_than_8_w[10] = ~output_carry_w[10];
					less_than_8_w[11] = ~output_carry_w[11];
					less_than_8_w[12] = ~output_carry_w[12];
					less_than_8_w[13] = ~output_carry_w[13];
					less_than_8_w[14] = ~output_carry_w[14];
					less_than_8_w[15] = ~output_carry_w[15];
					
					less_than_16_w[0] = ~output_carry_w[1];
					less_than_16_w[1] = ~output_carry_w[3];
					less_than_16_w[2] = ~output_carry_w[5];
					less_than_16_w[3] = ~output_carry_w[7];
					less_than_16_w[4] = ~output_carry_w[9];
					less_than_16_w[5] = ~output_carry_w[11];
					less_than_16_w[6] = ~output_carry_w[13];
					less_than_16_w[7] = ~output_carry_w[15];
					
					less_than_32_w[0] = ~output_carry_w[3];
					less_than_32_w[1] = ~output_carry_w[7];
					less_than_32_w[2] = ~output_carry_w[11];
					less_than_32_w[3] = ~output_carry_w[15];
					
					less_than_64_w[0] = ~output_carry_w[7];
					less_than_64_w[1] = ~output_carry_w[15];
				end
				
			default :
				begin
					less_than_64_w 	= 'b0;
					less_than_32_w	= 'b0;
					less_than_16_w	= 'b0;
					less_than_8_w 	= 'b0;
				end
				
		endcase
		
	// Assign "byte_selection" signals, according to the
	// SEW settings adn if we want the minimum or maximum
	// element.
	always @(*)
		if(chip_enable_i)
			if (maxmin_type_i) 	// Choose maximum, i. e., invert the signal.
				case (vsew_i)
					3'b000:
						begin
							byte_selection_w[0]  = ~less_than_8_w[0];
							byte_selection_w[1]  = ~less_than_8_w[1];
							byte_selection_w[2]  = ~less_than_8_w[2];
							byte_selection_w[3]  = ~less_than_8_w[3];
							byte_selection_w[4]  = ~less_than_8_w[4];
							byte_selection_w[5]  = ~less_than_8_w[5];
							byte_selection_w[6]  = ~less_than_8_w[6];
							byte_selection_w[7]  = ~less_than_8_w[7];
							byte_selection_w[8]  = ~less_than_8_w[8];
							byte_selection_w[9]  = ~less_than_8_w[9];
							byte_selection_w[10] = ~less_than_8_w[10];
							byte_selection_w[11] = ~less_than_8_w[11];
							byte_selection_w[12] = ~less_than_8_w[12];
							byte_selection_w[13] = ~less_than_8_w[13];
							byte_selection_w[14] = ~less_than_8_w[14];
							byte_selection_w[15] = ~less_than_8_w[15];
						end
						
					3'b001:
						begin
							byte_selection_w[0]  = ~less_than_16_w[0];
							byte_selection_w[1]  = ~less_than_16_w[0];
							byte_selection_w[2]  = ~less_than_16_w[1];
							byte_selection_w[3]  = ~less_than_16_w[1];
							byte_selection_w[4]  = ~less_than_16_w[2];
							byte_selection_w[5]  = ~less_than_16_w[2];
							byte_selection_w[6]  = ~less_than_16_w[3];
							byte_selection_w[7]  = ~less_than_16_w[3];
							byte_selection_w[8]  = ~less_than_16_w[4];
							byte_selection_w[9]  = ~less_than_16_w[4];
							byte_selection_w[10] = ~less_than_16_w[5];
							byte_selection_w[11] = ~less_than_16_w[5];
							byte_selection_w[12] = ~less_than_16_w[6];
							byte_selection_w[13] = ~less_than_16_w[6];
							byte_selection_w[14] = ~less_than_16_w[7];
							byte_selection_w[15] = ~less_than_16_w[7];
						end
					
					3'b010:
						begin
							byte_selection_w[0]  = ~less_than_32_w[0];
							byte_selection_w[1]  = ~less_than_32_w[0];
							byte_selection_w[2]  = ~less_than_32_w[0];
							byte_selection_w[3]  = ~less_than_32_w[0];
							byte_selection_w[4]  = ~less_than_32_w[1];
							byte_selection_w[5]  = ~less_than_32_w[1];
							byte_selection_w[6]  = ~less_than_32_w[1];
							byte_selection_w[7]  = ~less_than_32_w[1];
							byte_selection_w[8]  = ~less_than_32_w[2];
							byte_selection_w[9]  = ~less_than_32_w[2];
							byte_selection_w[10] = ~less_than_32_w[2];
							byte_selection_w[11] = ~less_than_32_w[2];
							byte_selection_w[12] = ~less_than_32_w[3];
							byte_selection_w[13] = ~less_than_32_w[3];
							byte_selection_w[14] = ~less_than_32_w[3];
							byte_selection_w[15] = ~less_than_32_w[3];
						end
						
					3'b011:
						begin
							byte_selection_w[0]  = ~less_than_64_w[0];
							byte_selection_w[1]  = ~less_than_64_w[0];
							byte_selection_w[2]  = ~less_than_64_w[0];
							byte_selection_w[3]  = ~less_than_64_w[0];
							byte_selection_w[4]  = ~less_than_64_w[0];
							byte_selection_w[5]  = ~less_than_64_w[0];
							byte_selection_w[6]  = ~less_than_64_w[0];
							byte_selection_w[7]  = ~less_than_64_w[0];
							byte_selection_w[8]  = ~less_than_64_w[1];
							byte_selection_w[9]  = ~less_than_64_w[1];
							byte_selection_w[10] = ~less_than_64_w[1];
							byte_selection_w[11] = ~less_than_64_w[1];
							byte_selection_w[12] = ~less_than_64_w[1];
							byte_selection_w[13] = ~less_than_64_w[1];
							byte_selection_w[14] = ~less_than_64_w[1];
							byte_selection_w[15] = ~less_than_64_w[1];
						end
						
					default:
						byte_selection_w = 'b0;
				endcase	
						
			else	// Choose minimum.
				case (vsew_i)
					3'b000:
						begin
							byte_selection_w[0]  = less_than_8_w[0];
							byte_selection_w[1]  = less_than_8_w[1];
							byte_selection_w[2]  = less_than_8_w[2];
							byte_selection_w[3]  = less_than_8_w[3];
							byte_selection_w[4]  = less_than_8_w[4];
							byte_selection_w[5]  = less_than_8_w[5];
							byte_selection_w[6]  = less_than_8_w[6];
							byte_selection_w[7]  = less_than_8_w[7];
							byte_selection_w[8]  = less_than_8_w[8];
							byte_selection_w[9]  = less_than_8_w[9];
							byte_selection_w[10] = less_than_8_w[10];
							byte_selection_w[11] = less_than_8_w[11];
							byte_selection_w[12] = less_than_8_w[12];
							byte_selection_w[13] = less_than_8_w[13];
							byte_selection_w[14] = less_than_8_w[14];
							byte_selection_w[15] = less_than_8_w[15];
						end
						
					3'b001:
						begin
							byte_selection_w[0]  = less_than_16_w[0];
							byte_selection_w[1]  = less_than_16_w[0];
							byte_selection_w[2]  = less_than_16_w[1];
							byte_selection_w[3]  = less_than_16_w[1];
							byte_selection_w[4]  = less_than_16_w[2];
							byte_selection_w[5]  = less_than_16_w[2];
							byte_selection_w[6]  = less_than_16_w[3];
							byte_selection_w[7]  = less_than_16_w[3];
							byte_selection_w[8]  = less_than_16_w[4];
							byte_selection_w[9]  = less_than_16_w[4];
							byte_selection_w[10] = less_than_16_w[5];
							byte_selection_w[11] = less_than_16_w[5];
							byte_selection_w[12] = less_than_16_w[6];
							byte_selection_w[13] = less_than_16_w[6];
							byte_selection_w[14] = less_than_16_w[7];
							byte_selection_w[15] = less_than_16_w[7];
						end
					
					3'b010:
						begin
							byte_selection_w[0]  = less_than_32_w[0];
							byte_selection_w[1]  = less_than_32_w[0];
							byte_selection_w[2]  = less_than_32_w[0];
							byte_selection_w[3]  = less_than_32_w[0];
							byte_selection_w[4]  = less_than_32_w[1];
							byte_selection_w[5]  = less_than_32_w[1];
							byte_selection_w[6]  = less_than_32_w[1];
							byte_selection_w[7]  = less_than_32_w[1];
							byte_selection_w[8]  = less_than_32_w[2];
							byte_selection_w[9]  = less_than_32_w[2];
							byte_selection_w[10] = less_than_32_w[2];
							byte_selection_w[11] = less_than_32_w[2];
							byte_selection_w[12] = less_than_32_w[3];
							byte_selection_w[13] = less_than_32_w[3];
							byte_selection_w[14] = less_than_32_w[3];
							byte_selection_w[15] = less_than_32_w[3];
						end
						
					3'b011:
						begin
							byte_selection_w[0]  = less_than_64_w[0];
							byte_selection_w[1]  = less_than_64_w[0];
							byte_selection_w[2]  = less_than_64_w[0];
							byte_selection_w[3]  = less_than_64_w[0];
							byte_selection_w[4]  = less_than_64_w[0];
							byte_selection_w[5]  = less_than_64_w[0];
							byte_selection_w[6]  = less_than_64_w[0];
							byte_selection_w[7]  = less_than_64_w[0];
							byte_selection_w[8]  = less_than_64_w[1];
							byte_selection_w[9]  = less_than_64_w[1];
							byte_selection_w[10] = less_than_64_w[1];
							byte_selection_w[11] = less_than_64_w[1];
							byte_selection_w[12] = less_than_64_w[1];
							byte_selection_w[13] = less_than_64_w[1];
							byte_selection_w[14] = less_than_64_w[1];
							byte_selection_w[15] = less_than_64_w[1];
						end
						
					default:
						byte_selection_w = 'b0;
				endcase
		else
			byte_selection_w = 'b0;
	
	// Select the proper bytes for output.
	// Manage byte 0
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[0])
					vd_o[7:0] = vs2_i[7:0];
				else
					vd_o[7:0] = vs1_i[7:0];
			end
		else
			vd_o[7:0] = 'b0;
			
	// Manage byte 1
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[1])
					vd_o[15:8] = vs2_i[15:8];
				else
					vd_o[15:8] = vs1_i[15:8];
			end
		else
			vd_o[15:8] = 'b0;
	// Manage byte 2
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[2])
					vd_o[23:16] = vs2_i[23:16];
				else
					vd_o[23:16] = vs1_i[23:16];
			end
		else
				vd_o[23:16] = 'b0;
	// Manage byte 3
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[3])
					vd_o[31:24] = vs2_i[31:24];
				else
					vd_o[31:24] = vs1_i[31:24];
			end
		else
				vd_o[31:24] = 'b0;
			
	// Manage byte 4
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[4])
					vd_o[39:32] = vs2_i[39:32];
				else
					vd_o[39:32] = vs1_i[39:32];
			end
		else
				vd_o[39:32] = 'b0;
			
	// Manage byte 5
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[5])
					vd_o[47:40] = vs2_i[47:40];
				else
					vd_o[47:40] = vs1_i[47:40];
			end
		else
				vd_o[47:40] = 'b0;
			
	// Manage byte 6
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[6])
					vd_o[55:48] = vs2_i[55:48];
				else
					vd_o[55:48] = vs1_i[55:48];
			end
		else
				vd_o[55:48] = 'b0;
	
	// Manage byte 7
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[7])
					vd_o[63:56] = vs2_i[63:56];
				else
					vd_o[63:56] = vs1_i[63:56];
			end
		else
				vd_o[63:56] = 'b0;
	
	// Manage byte 8
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[8])
					vd_o[71:64] = vs2_i[71:64];
				else
					vd_o[71:64] = vs1_i[71:64];
			end
		else
			vd_o[71:64] = 'b0;
			
	// Manage byte 9
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[9])
					vd_o[79:72] = vs2_i[79:72];
				else
					vd_o[79:72] = vs1_i[79:72];
			end
		else
			vd_o[79:72] = 'b0;
			
	// Manage byte 10
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[10])
					vd_o[87:80] = vs2_i[87:80];
				else
					vd_o[87:80] = vs1_i[87:80];
			end
		else
			vd_o[87:80] = 'b0;
			
	// Manage byte 11
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[11])
					vd_o[95:88] = vs2_i[95:88];
				else
					vd_o[95:88] = vs1_i[95:88];
			end
		else
			vd_o[95:88] = 'b0;
			
	// Manage byte 12
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[12])
					vd_o[103:96] = vs2_i[103:96];
				else
					vd_o[103:96] = vs1_i[103:96];
			end
		else
			vd_o[103:96] = 'b0;
			
	// Manage byte 13
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[13])
					vd_o[111:104] = vs2_i[111:104];
				else
					vd_o[111:104] = vs1_i[111:104];
			end
		else
			vd_o[111:104] = 'b0;
			
	// Manage byte 14
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[14])
					vd_o[119:112] = vs2_i[119:112];
				else
					vd_o[119:112] = vs1_i[119:112];
			end
		else
			vd_o[119:112] = 'b0;
	
	// Manage byte 15
	always @(*)
		if(chip_enable_i)
			begin
				if (byte_selection_w[15])
					vd_o[127:120] = vs2_i[127:120];
				else
					vd_o[127:120] = vs1_i[127:120];
			end
		else
			vd_o[127:120] = 'b0;
			
	full_adder_byte add_8_0(
		.a_i		(vs2_i[7:0]),
		.b_i		(vs1_inverted_bus_w[7:0]),
		.carry_i	(input_carry_w[0]),
		.sum_o		(output_sum_bus_w[7:0]),
		.carry_o	(output_carry_w[0])
	);
			
	full_adder_byte add_8_1(
		.a_i		(vs2_i[15:8]),
		.b_i		(vs1_inverted_bus_w[15:8]),
		.carry_i	(input_carry_w[1]),
		.sum_o		(output_sum_bus_w[15:8]),
		.carry_o	(output_carry_w[1])
	);
			
	full_adder_byte add_8_2(
		.a_i		(vs2_i[23:16]),
		.b_i		(vs1_inverted_bus_w[23:16]),
		.carry_i	(input_carry_w[2]),
		.sum_o		(output_sum_bus_w[23:16]),
		.carry_o	(output_carry_w[2])
	);
			
	full_adder_byte add_8_3(
		.a_i		(vs2_i[31:24]),
		.b_i		(vs1_inverted_bus_w[31:24]),
		.carry_i	(input_carry_w[3]),
		.sum_o		(output_sum_bus_w[31:24]),
		.carry_o	(output_carry_w[3])
	);
			
	full_adder_byte add_8_4(
		.a_i		(vs2_i[39:32]),
		.b_i		(vs1_inverted_bus_w[39:32]),
		.carry_i	(input_carry_w[4]),
		.sum_o		(output_sum_bus_w[39:32]),
		.carry_o	(output_carry_w[4])
	);
			
	full_adder_byte add_8_5(
		.a_i		(vs2_i[47:40]),
		.b_i		(vs1_inverted_bus_w[47:40]),
		.carry_i	(input_carry_w[5]),
		.sum_o		(output_sum_bus_w[47:40]),
		.carry_o	(output_carry_w[5])
	);
			
	full_adder_byte add_8_6(
		.a_i		(vs2_i[55:48]),
		.b_i		(vs1_inverted_bus_w[55:48]),
		.carry_i	(input_carry_w[6]),
		.sum_o		(output_sum_bus_w[55:48]),
		.carry_o	(output_carry_w[6])
	);
			
	full_adder_byte add_8_7(
		.a_i		(vs2_i[63:56]),
		.b_i		(vs1_inverted_bus_w[63:56]),
		.carry_i	(input_carry_w[7]),
		.sum_o		(output_sum_bus_w[63:56]),
		.carry_o	(output_carry_w[7])
	);
			
	full_adder_byte add_8_8(
		.a_i		(vs2_i[71:64]),
		.b_i		(vs1_inverted_bus_w[71:64]),
		.carry_i	(input_carry_w[8]),
		.sum_o		(output_sum_bus_w[71:64]),
		.carry_o	(output_carry_w[8])
	);
			
	full_adder_byte add_8_9(
		.a_i		(vs2_i[79:72]),
		.b_i		(vs1_inverted_bus_w[79:72]),
		.carry_i	(input_carry_w[9]),
		.sum_o		(output_sum_bus_w[79:72]),
		.carry_o	(output_carry_w[9])
	);
			
	full_adder_byte add_8_10(
		.a_i		(vs2_i[87:80]),
		.b_i		(vs1_inverted_bus_w[87:80]),
		.carry_i	(input_carry_w[10]),
		.sum_o		(output_sum_bus_w[87:80]),
		.carry_o	(output_carry_w[10])
	);
			
	full_adder_byte add_8_11(
		.a_i		(vs2_i[95:88]),
		.b_i		(vs1_inverted_bus_w[95:88]),
		.carry_i	(input_carry_w[11]),
		.sum_o		(output_sum_bus_w[95:88]),
		.carry_o	(output_carry_w[11])
	);
			
	full_adder_byte add_8_12(
		.a_i		(vs2_i[103:96]),
		.b_i		(vs1_inverted_bus_w[103:96]),
		.carry_i	(input_carry_w[12]),
		.sum_o		(output_sum_bus_w[103:96]),
		.carry_o	(output_carry_w[12])
	);
			
	full_adder_byte add_8_13(
		.a_i		(vs2_i[111:104]),
		.b_i		(vs1_inverted_bus_w[111:104]),
		.carry_i	(input_carry_w[13]),
		.sum_o		(output_sum_bus_w[111:104]),
		.carry_o	(output_carry_w[13])
	);
			
	full_adder_byte add_8_14(
		.a_i		(vs2_i[119:112]),
		.b_i		(vs1_inverted_bus_w[119:112]),
		.carry_i	(input_carry_w[14]),
		.sum_o		(output_sum_bus_w[119:112]),
		.carry_o	(output_carry_w[14])
	);
			
	full_adder_byte add_8_15(
		.a_i		(vs2_i[127:120]),
		.b_i		(vs1_inverted_bus_w[127:120]),
		.carry_i	(input_carry_w[15]),
		.sum_o		(output_sum_bus_w[127:120]),
		.carry_o	(output_carry_w[15])
	);

endmodule
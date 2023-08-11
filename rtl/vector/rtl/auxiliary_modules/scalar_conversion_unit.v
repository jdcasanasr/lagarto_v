// Transforms a 64-bit Scalar into a 128-Bit Vector,
// According to Current SEW Settings.
module scalar_conversion_unit
(
	// rs1_i Can Come From, Either the Scalar Register
	// File, or a Sign-Zero Extension of an Immediate
	input 		[63:0] 	rs1_i,
	input 		[1:0] 	vsew_i,
	input 				chip_enable,
	
	
	output reg 	[127:0] v_rs1_o
);

	always @ (*)
		if (chip_enable)
			case (vsew_i)
				2'b00 : v_rs1_o = {	{rs1_i[7:0]}, {rs1_i[7:0]}, {rs1_i[7:0]}, {rs1_i[7:0]},
									{rs1_i[7:0]}, {rs1_i[7:0]}, {rs1_i[7:0]}, {rs1_i[7:0]},
									{rs1_i[7:0]}, {rs1_i[7:0]}, {rs1_i[7:0]}, {rs1_i[7:0]},
									{rs1_i[7:0]}, {rs1_i[7:0]}, {rs1_i[7:0]}, {rs1_i[7:0]}};
				
				
				2'b01 : v_rs1_o = {	{rs1_i[15:0]}, {rs1_i[15:0]}, {rs1_i[15:0]}, {rs1_i[15:0]},
				                    {rs1_i[15:0]}, {rs1_i[15:0]}, {rs1_i[15:0]}, {rs1_i[15:0]}};
									
				2'b10 : v_rs1_o = {	{rs1_i[31:0]}, {rs1_i[31:0]}, {rs1_i[31:0]}, {rs1_i[31:0]}};
				
				2'b11 : v_rs1_o = {	{rs1_i[63:0]}, {rs1_i[63:0]}};
			endcase
			
		else
			v_rs1_o = 128'b0;

endmodule
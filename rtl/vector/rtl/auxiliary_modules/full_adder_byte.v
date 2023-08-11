module full_adder_byte
(
	input 		[7:0] 	a_i,
	input 		[7:0] 	b_i,
	input 				carry_i,
	
	output reg 	[7:0] 	sum_o,
	output reg 		 	carry_o

);
	wire [7:0] 	carry_bitwise_o_w;
	wire 		carry_o_w;
	
	always @ (*)
		begin
			sum_o 	= a_i ^ b_i ^ carry_bitwise_o_w;
			carry_o = carry_o_w;
		end
		
	// Sub-Module Instances
	// kogge_stone_byte
	kogge_stone_byte kogge_stone_byte_inst
	(
		.a_i				(a_i),
		.b_i				(b_i),
		.carry_i			(carry_i),
		
		.carry_bitwise_o 	(carry_bitwise_o_w),
		.carry_o			(carry_o_w)
	);
	
endmodule
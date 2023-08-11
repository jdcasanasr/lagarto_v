module immediate_extension_unit
(
	input 		[4:0] 	imm5_i,
	input 				extension_type_i,

	output reg 	[63:0] 	imm5_extended_o
);
	
	// When extension_type_i is Active, We Interpret
	// a Sign Extension is Wanted, and a Zero extension
	// On the Opposite Case.
	always @ (*)	
		if (extension_type_i)
			imm5_extended_o = {{59{imm5_i[4]}}, imm5_i[4:0]};
			
		else
			imm5_extended_o = {{59{1'b0}}, imm5_i[4:0]};

endmodule
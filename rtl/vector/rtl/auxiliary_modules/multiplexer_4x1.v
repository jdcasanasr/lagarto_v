module multiplexer_4x1
(
	input 		a_i,
	input 		b_i,
	input 		c_i,
	input 		d_i,
	
	input [1:0] control_i,

	output reg 	selection_o
);

	always @ (*)
		case (control_i)
			2'b00 : selection_o = a_i;
			2'b01 : selection_o = b_i;
			2'b10 : selection_o = c_i;
			2'b11 : selection_o = d_i;
		endcase

endmodule
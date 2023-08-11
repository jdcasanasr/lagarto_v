module leading_zeroes_counter
# (
	parameter INPUT_WIDTH 	= 64,
	parameter OUTPUT_WIDTH 	= $clog2(INPUT_WIDTH)
)
(
	input 	wire [INPUT_WIDTH - 1:0] 	input_vector,
	
	output 	wire [OUTPUT_WIDTH - 1:0] 	count_vector
);

	generate
	
		// Base case: We either have 2'b1x or 2'b0x. Return
		// a negated version of the MSB.
		if (INPUT_WIDTH == 2)
			assign count_vector = !input_vector[1];
	
		// Recursive case:
		// Q: Why does it work with "wire" but not with "logic"?
		else
			begin
				wire [OUTPUT_WIDTH - 2:0] count_vector_half; 	// Count vector for either half (left or right).
				wire [(INPUT_WIDTH / 2) - 1:0] left_half = input_vector[(INPUT_WIDTH / 2) +: (INPUT_WIDTH / 2)]; // Indexed part-select notation.
				wire [(INPUT_WIDTH / 2) - 1:0] right_half = input_vector[0 +: (INPUT_WIDTH / 2)];
				wire is_left_half_empty = ~| left_half; 	// Is the left hand side zero ?
				
				leading_zeroes_counter # (.INPUT_WIDTH (INPUT_WIDTH / 2)) leading_zeroes_counter_recursive
				(
					.input_vector 	(is_left_half_empty ? right_half : left_half),
					
					.count_vector 	(count_vector_half)
				);
				
				// Each bit is a power of two!
				assign count_vector = {is_left_half_empty, count_vector_half};
			end
	
	endgenerate

endmodule 
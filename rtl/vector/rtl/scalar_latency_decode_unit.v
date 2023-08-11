`include "lagarto_hun_decoder.vh"
`include "includes/latency_decode.vh"

module scalar_latency_decode_unit
(
	input 		[2:0] 								functional_unit_i,

	output reg 	[$clog2(`maximum_latency) - 1:0] 	scalar_latency_o
);

	always @ (*)
		case (functional_unit_i)
			`UNIT_ALU, `UNIT_BRANCH 	: scalar_latency_o = 3'd1;
			`UNIT_DIV   				: scalar_latency_o = 3'd34;
			`UNIT_MUL   				: scalar_latency_o = 3'd2;

			default 					: scalar_latency_o = 3'd1;
		endcase

endmodule
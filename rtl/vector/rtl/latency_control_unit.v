module latency_control_unit
#(parameter MAX_LATENCY = 32)
(
	input 								clock_i,
	input 								reset_ni,

	input [$clog2(MAX_LATENCY) - 1:0] 	incoming_latency_i,

	output reg 							halt_pipeline_o
);

	// Current latency counter. It signals how many cycles
	// are left until all operations are done.
	reg [$clog2(MAX_LATENCY) - 1:0] current_latency_r;

	// Manage current_latency_r.
	always @ (posedge clock_i, negedge reset_ni)
		if (!reset_ni)
			current_latency_r = {$clog2(MAX_LATENCY){1'b0}};
		else if (incoming_latency_i > current_latency_r)
			current_latency_r = incoming_latency_i - 1;
		else if (current_latency_r > 0)
			current_latency_r = current_latency_r - 1;

	// If the incoming latency is smaller than the current
	// one, we'll stop the pipeline in order to preserve
	// execution order.
	always @ (*)
		if ((current_latency_r > 0) && (incoming_latency_i < current_latency_r))
			halt_pipeline_o = 1'b1;
		else if ((current_latency_r == 0) || (incoming_latency_i > current_latency_r))
			halt_pipeline_o = 1'b0;

endmodule

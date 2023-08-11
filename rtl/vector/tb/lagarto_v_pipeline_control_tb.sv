`define MAX_LATENCY 32
`define DATA_WIDTH 	32

module lagarto_v_pipeline_control_tb ();

	bit 													clock_b;
	bit 													reset_nb;
	bit  					[$clog2(`MAX_LATENCY) - 1:0] 	latency_b;
	bit  					[`DATA_WIDTH - 1:0] 			data_b;

	wire 					halt_pipeline_w;
	wire 					latch_load_w;
	wire 					fake_memory_request_w;

	wire  	[(`DATA_WIDTH + $clog2(`MAX_LATENCY)) - 1:0] packet [3:0];

	assign latch_load_w 															= ~halt_pipeline_w;
	assign fake_memory_request_w 													= ~halt_pipeline_w;
	assign packet[0][$clog2(`MAX_LATENCY) - 1:0] 									= latency_b;
	assign packet[0][(`DATA_WIDTH + $clog2(`MAX_LATENCY)) - 1:$clog2(`MAX_LATENCY)] = data_b;

	initial
		begin
			clock_b 	= '1;
			reset_nb 	= '1;
		end

	initial
		forever
			#10 clock_b = ~clock_b;

	initial
		begin
			#5 reset_nb = '0;
			#5 reset_nb = '1;
		end

	initial
		begin
			repeat (100)
				begin
					#20 if (fake_memory_request_w)
							begin
								latency_b 	= $urandom % `MAX_LATENCY;
								data_b 		= $random;
							end
						else
							begin
								latency_b 	= latency_b;
								data_b 		= data_b;
							end
				end
			
			#20 ;
			#20 $stop;
		end

	inter_stage_latch #(.WIDTH(`DATA_WIDTH + $clog2(`MAX_LATENCY))) vif_vid_latch_instance
	(
		.clock_i 	(clock_b),
		.reset_ni 	(reset_nb),
		.flush_i 	(1'b0),
		.load_i 	(latch_load_w),

		.d_i 		(packet[0]),

		.q_o 		(packet[1])
	);

	inter_stage_latch #(.WIDTH(`DATA_WIDTH + $clog2(`MAX_LATENCY))) vid_vrr_latch_instance
	(
		.clock_i 	(clock_b),
		.reset_ni 	(reset_nb),
		.flush_i 	(1'b0),
		.load_i 	(latch_load_w),

		.d_i 		(packet[1]),

		.q_o 		(packet[2])
	);

	inter_stage_latch #(.WIDTH(`DATA_WIDTH + $clog2(`MAX_LATENCY))) vrr_exe_latch_instance
	(
		.clock_i 	(clock_b),
		.reset_ni 	(reset_nb),
		.flush_i 	(1'b0),
		.load_i 	(latch_load_w),

		.d_i 		(packet[2]),

		.q_o 		(packet[3])
	);

	latency_control_unit #(.MAX_LATENCY(`MAX_LATENCY)) latency_control_unit_instance
	(
		.clock_i 			(clock_b),
		.reset_ni 			(reset_nb),

		.incoming_latency_i (packet[2][$clog2(`MAX_LATENCY) - 1:0]),

		.halt_pipeline_o 	(halt_pipeline_w)
	);

endmodule
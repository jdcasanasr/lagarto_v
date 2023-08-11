`timescale 1ns / 1ns

import vector_addition_unit_pkg :: *;

module vector_addition_unit_tb;

	bit				clock;

	// Input Buses
	wire [127:0] 	vs2_i_w;
	wire [127:0] 	vs1_i_w;
	wire [15:0] 	vmask_i_w;
	
	// Control Signals & Buses
	wire [1:0] 		vsew_i_w;
	
	wire 			reversed_i_w;
	wire 			add_sub_i_w;
	wire			compute_carry_i_w;
	wire 			with_carry_borrow_i_w;
	
	// Output Signals & Buses
	wire [127:0] 	vd_o_w;

	// Constrained, Random Signals & Buses
	vector_t 		vs2;
	vector_t 		vs1;
	vector_t 		vmask;

	vsew_t 			vsew;
	operation_t 	operation;
	
	vector_t 		vd_predicted;
	vector_t 		vd_computed;

	// Coverage Block For The Whole Range Of Operations
	//covergroup vadd_coverage_block;
	//	operation_set 		: coverpoint operation;
	//	vsew_set 			: coverpoint vsew;
	//	vadd_all_operations : cross operation_set, vsew_set;
	//endgroup

	//vadd_coverage_block coverage_block;

	// Assign An enum Value To Input Buses For
	// Testing Purposes
	assign vs2_i_w 					= vs2;
	assign vs1_i_w 					= vs1;
	assign vmask_i_w				= vmask[15:0];

	assign vsew_i_w 				= vsew;
	assign {reversed_i_w,
			add_sub_i_w,
			compute_carry_i_w,
			with_carry_borrow_i_w} 	= operation;

	assign vd_computed 				= vd_o_w;

	// Initialize Variables To A Known Value
	initial
		begin  	: initialize_variables
			clock 			= '1;

			vsew 			= vsew_8b;
			operation 		= vadd;

			vs2 			= '0;
			vs1				= '0;
			vd_predicted 	= '0;

	//		coverage_block 	= new ();
		end 	: initialize_variables

	// Manage clock Signal
	initial
		forever
			#10 clock = ~clock;

	// Get Constrained, Random Values
	initial
		begin 	: tester
			repeat (1000)
				begin
					@ (posedge clock)
					vsew 			= get_random_vsew ();
					operation 		= get_random_operation ();

					vs2 			= get_random_vector ();
					vs1 			= get_random_vector ();
					vmask 			= get_random_vector ();
					vd_predicted 	= perform_operation (vs2, vs1, vmask, vsew, operation);

	//				coverage_block.sample ();
				end

			$stop;
		end 	: tester

	// Check And Report Results
	always @ (negedge clock)
		begin 	: scoreboard
			$display ("| Operation = %s\t|\tSEW = %s\t|\tVerdict = %s\t|", operation, vsew, (vd_computed == vd_predicted ? "OK" : "ERROR"));
		end 	: scoreboard
	
	// DUT Instance
	vector_addition_unit dut 
	(
		.vs2_i 					(vs2_i_w), 
		.vs1_i 					(vs1_i_w), 
		.vmask_i 				(vmask_i_w),
		
		.vsew_i 				(vsew_i_w),
		
		.reversed_i 			(reversed_i_w), 
		.add_sub_i 				(add_sub_i_w),
		.compute_carry_i 		(compute_carry_i_w),
		.with_carry_borrow_i 	(with_carry_borrow_i_w),
		
		.vd_o 					(vd_o_w)
	);

endmodule

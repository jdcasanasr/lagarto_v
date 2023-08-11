module bimodal_predictor (
	clk_i,
	pc_fetch_i,
	pc_execution_i,
	branch_addr_result_exec_i,
	branch_taken_result_exec_i,
	is_branch_EX_i,
	bimodal_predict_taken_o,
	bimodal_predict_addr_o
);
	input clk_i;
	localparam riscv_pkg_XLEN = 64;
	input wire [63:0] pc_fetch_i;
	input wire [63:0] pc_execution_i;
	input wire [63:0] branch_addr_result_exec_i;
	input branch_taken_result_exec_i;
	input is_branch_EX_i;
	output wire bimodal_predict_taken_o;
	output reg [63:0] bimodal_predict_addr_o;
	localparam _BITS_BIMODAL_STATE_MACHINE_ = 2;
	reg [1:0] new_state_to_pht;
	reg [1:0] readed_state_pht;
	reg [1:0] past_state_pht;
	localparam _LENGTH_BIMODAL_INDEX_ = 6;
	localparam _NUM_BIMODAL_ENTRIES_ = 64;
	reg [1:0] pattern_history_table [0:63];
	reg [63:0] branch_target_buffer [0:63];
	integer i;
	localparam _INITIAL_STATE_BIMODAL_ = 2'b10;
	initial for (i = 0; i < _NUM_BIMODAL_ENTRIES_; i = i + 1)
		begin
			pattern_history_table[i] = _INITIAL_STATE_BIMODAL_;
			branch_target_buffer[i] = 64'h0000000000000000;
		end
	localparam drac_pkg_LEAST_SIGNIFICATIVE_INDEX_BIT_BP = 2;
	localparam drac_pkg_MOST_SIGNIFICATIVE_INDEX_BIT_BP = 7;
	always @(*) begin
		readed_state_pht = pattern_history_table[pc_fetch_i[drac_pkg_MOST_SIGNIFICATIVE_INDEX_BIT_BP:drac_pkg_LEAST_SIGNIFICATIVE_INDEX_BIT_BP]];
		past_state_pht = pattern_history_table[pc_execution_i[drac_pkg_MOST_SIGNIFICATIVE_INDEX_BIT_BP:drac_pkg_LEAST_SIGNIFICATIVE_INDEX_BIT_BP]];
		bimodal_predict_addr_o = branch_target_buffer[pc_fetch_i[drac_pkg_MOST_SIGNIFICATIVE_INDEX_BIT_BP:drac_pkg_LEAST_SIGNIFICATIVE_INDEX_BIT_BP]];
	end
	always @(*)
		if ((past_state_pht == 2'b00) && (branch_taken_result_exec_i == 1'b0))
			new_state_to_pht = 2'b00;
		else if ((past_state_pht == 2'b11) && (branch_taken_result_exec_i == 1'b1))
			new_state_to_pht = 2'b11;
		else if (branch_taken_result_exec_i == 1'b1)
			new_state_to_pht = past_state_pht + 2'b01;
		else
			new_state_to_pht = past_state_pht - 2'b01;
	always @(posedge clk_i) begin
		if (is_branch_EX_i)
			pattern_history_table[pc_execution_i[drac_pkg_MOST_SIGNIFICATIVE_INDEX_BIT_BP:drac_pkg_LEAST_SIGNIFICATIVE_INDEX_BIT_BP]] <= new_state_to_pht;
		branch_target_buffer[pc_execution_i[drac_pkg_MOST_SIGNIFICATIVE_INDEX_BIT_BP:drac_pkg_LEAST_SIGNIFICATIVE_INDEX_BIT_BP]] <= branch_addr_result_exec_i;
	end
	assign bimodal_predict_taken_o = readed_state_pht[1];
endmodule
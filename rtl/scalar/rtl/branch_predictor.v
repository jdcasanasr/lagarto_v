module branch_predictor (
	clk_i,
	rstn_i,
	pc_fetch_i,
	pc_execution_i,
	branch_addr_result_exec_i,
	branch_taken_result_exec_i,
	is_branch_EX_i,
	branch_predict_is_branch_o,
	branch_predict_taken_o,
	branch_predict_addr_o
);
	input wire clk_i;
	input wire rstn_i;
	localparam riscv_pkg_XLEN = 64;
	input wire [63:0] pc_fetch_i;
	input wire [63:0] pc_execution_i;
	input wire [63:0] branch_addr_result_exec_i;
	input wire branch_taken_result_exec_i;
	input wire is_branch_EX_i;
	output wire branch_predict_is_branch_o;
	output wire branch_predict_taken_o;
	output wire [63:0] branch_predict_addr_o;
	wire bimodal_predict_taken;
	wire [63:0] bimodal_predict_addr;
	localparam drac_pkg_MOST_SIGNIFICATIVE_INDEX_BIT_BP = 7;
	reg [31:0] is_branch_tag;
	wire is_branch_prediction;
	reg is_branch_tag_valid;
	bimodal_predictor bimodal_predictor_inst(
		.clk_i(clk_i),
		.pc_fetch_i(pc_fetch_i),
		.pc_execution_i(pc_execution_i),
		.branch_addr_result_exec_i(branch_addr_result_exec_i),
		.branch_taken_result_exec_i(branch_taken_result_exec_i),
		.is_branch_EX_i(is_branch_EX_i),
		.bimodal_predict_taken_o(bimodal_predict_taken),
		.bimodal_predict_addr_o(bimodal_predict_addr)
	);
	localparam NUM_IS_BRANCH_ENTRIES = 64;
	reg [31:0] is_branch_table [0:63];
	reg is_branch_table_valid [0:63];
	localparam drac_pkg_LEAST_SIGNIFICATIVE_INDEX_BIT_BP = 2;
	always @(*) begin
		is_branch_tag = is_branch_table[pc_fetch_i[drac_pkg_MOST_SIGNIFICATIVE_INDEX_BIT_BP:drac_pkg_LEAST_SIGNIFICATIVE_INDEX_BIT_BP]];
		is_branch_tag_valid = is_branch_table_valid[pc_fetch_i[drac_pkg_MOST_SIGNIFICATIVE_INDEX_BIT_BP:drac_pkg_LEAST_SIGNIFICATIVE_INDEX_BIT_BP]];
	end
	always @(posedge clk_i or negedge rstn_i)
		if (~rstn_i) begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < NUM_IS_BRANCH_ENTRIES; i = i + 1)
				is_branch_table_valid[i] <= 1'b0;
		end
		else if (is_branch_EX_i) begin
			is_branch_table[pc_execution_i[drac_pkg_MOST_SIGNIFICATIVE_INDEX_BIT_BP:drac_pkg_LEAST_SIGNIFICATIVE_INDEX_BIT_BP]] <= pc_execution_i[39:8];
			is_branch_table_valid[pc_execution_i[drac_pkg_MOST_SIGNIFICATIVE_INDEX_BIT_BP:drac_pkg_LEAST_SIGNIFICATIVE_INDEX_BIT_BP]] <= 1'b1;
		end
	assign is_branch_prediction = (is_branch_tag == pc_fetch_i[39:8]) && is_branch_tag_valid;
	assign branch_predict_addr_o = bimodal_predict_addr;
	assign branch_predict_taken_o = bimodal_predict_taken;
	assign branch_predict_is_branch_o = is_branch_prediction;
endmodule
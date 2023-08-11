`include	"../../includes/if_stage.vh"
module if_stage (
	clk_i,
	rstn_i,
	reset_addr_i,
	stall_i,
	stall_debug_i,
	cu_if_i,
	invalidate_icache_i,
	invalidate_buffer_i,
	pc_jump_i,
	resp_icache_cpu_i,
	exe_if_branch_pred_i,
	retry_fetch_i,
	req_cpu_icache_o,
	fetch_o
);
	input wire clk_i;
	input wire rstn_i;
	localparam drac_pkg_ADDR_SIZE = 40;
	input wire [39:0] reset_addr_i;
	input wire stall_i;
	input wire stall_debug_i;
	input wire [1:0] cu_if_i;
	input wire invalidate_icache_i;
	input wire invalidate_buffer_i;
	localparam riscv_pkg_XLEN = 64;
	input wire [63:0] pc_jump_i;
	localparam riscv_pkg_INST_SIZE = 32;
	input wire [33:0] resp_icache_cpu_i;
	input wire [129:0] exe_if_branch_pred_i;
	input wire retry_fetch_i;
	output wire [43:0] req_cpu_icache_o;
	output reg [291:0] fetch_o;
	reg [63:0] next_pc;
	reg [63:0] pc;
	reg ex_addr_misaligned_int;
	reg ex_if_addr_fault_int;
	reg ex_if_page_fault_int;
	wire branch_predict_is_branch;
	wire branch_predict_taken;
	wire [63:0] branch_predict_addr;
	
	always @(*)
		case (cu_if_i[`change_pc])
			2'b01: next_pc = pc;
			2'b00:
				if (branch_predict_is_branch && branch_predict_taken)
					next_pc = branch_predict_addr;
				else
					next_pc = pc + 64'h4;
			2'b10, 2'b11: next_pc = pc_jump_i;
			default: next_pc = pc + 64'h4;
		endcase
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i)
			pc <= {24'b0, reset_addr_i};
		else
			pc <= next_pc;
	always @(*)
		if ((pc[38] ? !(&pc[63:39]) : |pc[63:39]))
			ex_if_addr_fault_int = 1'b1;
		else
			ex_if_addr_fault_int = 1'b0;
	always @(*)
		if (|pc[1:0])
			ex_addr_misaligned_int = 1'b1;
		else
			ex_addr_misaligned_int = 1'b0;
	always @(*)
		if (resp_icache_cpu_i[33] && resp_icache_cpu_i[0])
			ex_if_page_fault_int = 1'b1;
		else
			ex_if_page_fault_int = 1'b0;
	assign req_cpu_icache_o[`instruction_memory_valid] = !ex_addr_misaligned_int && !stall_debug_i;
	assign req_cpu_icache_o[`instruccion_memory_virtual_addres] = pc[39:0];
	assign req_cpu_icache_o[`invalidate_icache] = invalidate_icache_i;					//not used
	assign req_cpu_icache_o[`invalidate_buffer] = invalidate_buffer_i | retry_fetch_i;	//not used
	assign req_cpu_icache_o[`invalidate_fecth] = retry_fetch_i;							//not used
	wire [64:1] sv2v_tmp_E1022;
	assign sv2v_tmp_E1022 = pc;
	always @(*) fetch_o[`fetch_o_pc] = sv2v_tmp_E1022;
	wire [32:1] sv2v_tmp_42900;
	assign sv2v_tmp_42900 = resp_icache_cpu_i[32-:32];
	always @(*) fetch_o[`fetch_o_resp_icache_cpu_i] = sv2v_tmp_42900;
	wire [1:1] sv2v_tmp_99BA0;
	assign sv2v_tmp_99BA0 = (!stall_debug_i && !stall_i) && (resp_icache_cpu_i[33] || ((ex_addr_misaligned_int | ex_if_addr_fault_int) | ex_if_page_fault_int));
	always @(*) fetch_o[`fetch_o_valid] = sv2v_tmp_99BA0;
	branch_predictor brach_predictor_inst(
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.pc_fetch_i(pc),
		.pc_execution_i(exe_if_branch_pred_i[`branch_predictor_i_pc]),
		.branch_addr_result_exec_i(exe_if_branch_pred_i[`branch_predictor_i_adrres_result]),
		.branch_taken_result_exec_i(exe_if_branch_pred_i[`branch_predictor_i_taken_result]),
		.is_branch_EX_i(exe_if_branch_pred_i[`branch_predictor_i_execution]),
		.branch_predict_is_branch_o(branch_predict_is_branch),
		.branch_predict_taken_o(branch_predict_taken),
		.branch_predict_addr_o(branch_predict_addr)
	);
	function automatic [63:0] sv2v_cast_B42F7;
		input reg [63:0] inp;
		sv2v_cast_B42F7 = inp;
	endfunction
	always @(*)
		if (ex_addr_misaligned_int) begin
			fetch_o[`fetch_o_exception_cause] = sv2v_cast_B42F7(`INSTR_ADDR_MISALIGNED);
			fetch_o[`fetch_o_exception_valid] = 1'b1;
		end
		else if (ex_if_addr_fault_int) begin
			fetch_o[`fetch_o_exception_cause] = sv2v_cast_B42F7(`INSTR_ACCESS_FAULT);
			fetch_o[`fetch_o_exception_valid] = 1'b1;
		end
		else if (ex_if_page_fault_int) begin
			fetch_o[`fetch_o_exception_cause] = sv2v_cast_B42F7(`INSTR_PAGE_FAULT);
			fetch_o[`fetch_o_exception_valid] = 1'b1;
		end
		else begin
			fetch_o[`fetch_o_exception_cause] = sv2v_cast_B42F7(`INSTR_ADDR_MISALIGNED);
			fetch_o[`fetch_o_exception_valid] = 1'b0;
		end
	wire [64:1] sv2v_tmp_3C2FF;
	assign sv2v_tmp_3C2FF = pc;
	always @(*) fetch_o[`fetch_o_exception_origin] = sv2v_tmp_3C2FF;
	wire [1:1] sv2v_tmp_E8B4A;
	assign sv2v_tmp_E8B4A = branch_predict_is_branch;
	always @(*) fetch_o[`fetch_o_is_branch] = sv2v_tmp_E8B4A;
	wire [1:1] sv2v_tmp_B6B35;
	assign sv2v_tmp_B6B35 = (branch_predict_taken & branch_predict_is_branch ? 1'd1 : 1'd0);
	always @(*) fetch_o[`fetch_o_branch_decision] = sv2v_tmp_B6B35;
	wire [64:1] sv2v_tmp_121AE;
	assign sv2v_tmp_121AE = branch_predict_addr;
	always @(*) fetch_o[`fetch_o_branch_address] = sv2v_tmp_121AE;
endmodule
`default_nettype wire
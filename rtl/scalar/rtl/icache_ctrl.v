module icache_ctrl (
	clk_i,
	rstn_i,
	cache_enable_i,
	paddr_is_nc_i,
	flush_i,
	flush_done_i,
	cmp_enable_o,
	cache_rd_ena_o,
	cache_wr_ena_o,
	ireq_valid_i,
	ireq_kill_i,
	ireq_kill_d,
	iresp_ready_o,
	iresp_valid_o,
	mmu_ex_valid_i,
	mmu_miss_i,
	mmu_ptw_valid_i,
	treq_valid_o,
	valid_ifill_resp_i,
	ifill_resp_valid_i,
	ifill_sent_ack_i,
	ifill_req_valid_o,
	cline_hit_i,
	miss_o,
	miss_kill_o,
	replay_valid_o,
	flush_en_o
);
	input wire clk_i;
	input wire rstn_i;
	input wire cache_enable_i;
	input wire paddr_is_nc_i;
	input wire flush_i;
	input wire flush_done_i;
	output reg cmp_enable_o;
	output reg cache_rd_ena_o;
	output reg cache_wr_ena_o;
	input wire ireq_valid_i;
	input wire ireq_kill_i;
	input wire ireq_kill_d;
	output reg iresp_ready_o;
	output reg iresp_valid_o;
	input wire mmu_ex_valid_i;
	input wire mmu_miss_i;
	input wire mmu_ptw_valid_i;
	output reg treq_valid_o;
	input wire valid_ifill_resp_i;
	input wire ifill_resp_valid_i;
	input wire ifill_sent_ack_i;
	output reg ifill_req_valid_o;
	localparam [31:0] drac_icache_pkg_ICACHE_N_WAY = 4;
	input wire [3:0] cline_hit_i;
	output reg miss_o;
	output reg miss_kill_o;
	output reg replay_valid_o;
	output reg flush_en_o;
	wire new_request;
	wire is_hit_or_excpt;
	wire is_hit;
	wire is_flush_or_kill;
	wire valid_ifill_resp;
	wire is_TLB_MISS;
	assign new_request = ~ifill_resp_valid_i & ireq_valid_i;
	assign valid_ifill_resp = valid_ifill_resp_i;
	assign is_hit = |cline_hit_i;
	assign is_hit_or_excpt = is_hit | mmu_ex_valid_i;
	assign is_flush_or_kill = flush_i | ireq_kill_i;
	reg [2:0] state_d;
	reg [2:0] state_q;
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i)
			state_q <= 3'd0;
		else
			state_q <= state_d;
	always @(*)
		case (state_q)
			3'd1: begin
				state_d = (is_flush_or_kill || !new_request ? 3'd1 : ((!is_hit_or_excpt && !mmu_miss_i) && new_request ? 3'd2 : ((is_hit_or_excpt && !mmu_miss_i) && new_request ? 3'd1 : 3'd3)));
				treq_valid_o = 1'b0;
				cmp_enable_o = cache_enable_i;
				cache_rd_ena_o = 1'b0;
				iresp_ready_o = !new_request;
				ifill_req_valid_o = (((!is_hit_or_excpt && !mmu_miss_i) && !is_flush_or_kill) && new_request) && !ireq_kill_d;
				miss_o = 1'b0;
				miss_kill_o = 1'b0;
				iresp_valid_o = ((is_hit && !mmu_miss_i) && !is_flush_or_kill) && new_request;
				cache_wr_ena_o = 1'b0;
				flush_en_o = flush_i;
				replay_valid_o = 1'b0;
			end
			3'd2: begin
				state_d = (is_flush_or_kill || mmu_ex_valid_i ? 3'd5 : (valid_ifill_resp ? 3'd4 : 3'd2));
				iresp_valid_o = 1'b0;
				cache_wr_ena_o = ifill_resp_valid_i && !is_flush_or_kill;
				cmp_enable_o = 1'b0;
				iresp_ready_o = 1'b0;
				miss_o = 1'b1;
				miss_kill_o = 1'b0;
				treq_valid_o = 1'b0;
				ifill_req_valid_o = 1'b0;
				cache_rd_ena_o = 1'b0;
				flush_en_o = flush_i;
				replay_valid_o = 1'b0;
			end
			3'd3: begin
				state_d = ((is_flush_or_kill || mmu_ex_valid_i) || !mmu_miss_i ? 3'd1 : (mmu_ptw_valid_i ? 3'd6 : 3'd3));
				treq_valid_o = (!mmu_miss_i && !mmu_ex_valid_i) && !is_flush_or_kill;
				cmp_enable_o = cache_enable_i;
				cache_rd_ena_o = (!mmu_miss_i && !mmu_ex_valid_i) && !is_flush_or_kill;
				iresp_valid_o = mmu_ex_valid_i;
				miss_o = 1'b0;
				miss_kill_o = 1'b0;
				iresp_ready_o = 1'b0;
				ifill_req_valid_o = 1'b0;
				cache_wr_ena_o = 1'b0;
				flush_en_o = flush_i;
				replay_valid_o = (is_flush_or_kill || mmu_ex_valid_i) || !mmu_miss_i;
			end
			3'd4: begin
				state_d = 3'd1;
				cmp_enable_o = cache_enable_i;
				iresp_ready_o = 1'b0;
				iresp_valid_o = mmu_ex_valid_i;
				cache_rd_ena_o = !is_flush_or_kill && !mmu_ex_valid_i;
				cache_wr_ena_o = 1'b0;
				miss_o = 1'b0;
				miss_kill_o = 1'b0;
				treq_valid_o = 1'b0;
				ifill_req_valid_o = 1'b0;
				flush_en_o = flush_i;
				replay_valid_o = !is_flush_or_kill && !mmu_ex_valid_i;
			end
			3'd5: begin
				state_d = (!ifill_sent_ack_i ? 3'd1 : 3'd5);
				cmp_enable_o = 1'b0;
				iresp_ready_o = 1'b0;
				iresp_valid_o = mmu_ex_valid_i;
				cache_rd_ena_o = 1'b0;
				cache_wr_ena_o = 1'b0;
				miss_o = 1'b0;
				miss_kill_o = 1'b1;
				treq_valid_o = 1'b0;
				ifill_req_valid_o = 1'b0;
				flush_en_o = 1'b0;
				replay_valid_o = 1'b0;
			end
			3'd6: begin
				state_d = 3'd1;
				cmp_enable_o = cache_enable_i;
				iresp_ready_o = 1'b0;
				iresp_valid_o = mmu_ex_valid_i;
				cache_rd_ena_o = (!mmu_miss_i && !mmu_ex_valid_i) && !is_flush_or_kill;
				cache_wr_ena_o = 1'b0;
				miss_o = 1'b0;
				miss_kill_o = 1'b0;
				treq_valid_o = (!mmu_miss_i && !mmu_ex_valid_i) && !is_flush_or_kill;
				ifill_req_valid_o = 1'b0;
				flush_en_o = flush_i;
				replay_valid_o = 1'b1;
			end
			default: begin
				state_d = 3'd1;
				cmp_enable_o = 1'b0;
				iresp_ready_o = 1'b0;
				iresp_valid_o = 1'b0;
				cache_rd_ena_o = 1'b0;
				cache_wr_ena_o = 1'b0;
				miss_o = 1'b0;
				miss_kill_o = 1'b0;
				treq_valid_o = 1'b0;
				ifill_req_valid_o = 1'b0;
				flush_en_o = 1'b0;
				replay_valid_o = 1'b0;
			end
		endcase
	assign is_TLB_MISS = state_q == 3'd3;
endmodule
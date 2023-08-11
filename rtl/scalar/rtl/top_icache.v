module top_icache (
	clk_i,
	rstn_i,
	flush_i,
	lagarto_ireq_i,
	icache_resp_o,
	mmu_tresp_i,
	icache_treq_o,
	ifill_resp_i,
	icache_ifill_req_o,
	imiss_time_pmu_o,
	imiss_kill_pmu_o
);
	input wire clk_i;
	input wire rstn_i;
	input wire flush_i;
	localparam drac_pkg_ICACHE_IDX_BITS_SIZE = 12;
	localparam drac_pkg_ICACHE_VPN_BITS_SIZE = 28;
	input wire [41:0] lagarto_ireq_i;
	localparam drac_pkg_ICACHELINE_SIZE = 127;
	localparam [31:0] drac_icache_pkg_FETCH_WIDHT = 128;
	localparam drac_pkg_ADDR_SIZE = 40;
	localparam [31:0] drac_icache_pkg_VADDR_SIZE = drac_pkg_ADDR_SIZE;
	output wire [170:0] icache_resp_o;
	input wire [22:0] mmu_tresp_i;
	output wire [28:0] icache_treq_o;
	localparam [31:0] drac_icache_pkg_WORD_SIZE = 64;
	localparam [31:0] drac_icache_pkg_SET_WIDHT = 128;
	localparam [31:0] drac_icache_pkg_WAY_WIDHT = drac_icache_pkg_SET_WIDHT;
	input wire [131:0] ifill_resp_i;
	localparam [31:0] drac_icache_pkg_ICACHE_N_WAY = 4;
	localparam [31:0] drac_icache_pkg_PADDR_SIZE = 26;
	output wire [28:0] icache_ifill_req_o;
	output wire imiss_time_pmu_o;
	output wire imiss_kill_pmu_o;
	localparam [31:0] drac_icache_pkg_TAG_WIDHT = 20;
	localparam [31:0] drac_icache_pkg_ICACHE_TAG_WIDTH = drac_icache_pkg_TAG_WIDHT;
	wire [19:0] cline_tag_d;
	wire [19:0] cline_tag_q;
	wire [19:0] tag_paddr;
	localparam [31:0] drac_icache_pkg_ICACHE_DEPTH = 256;
	localparam [31:0] drac_icache_pkg_ADDR_WIDHT = 8;
	localparam [31:0] drac_icache_pkg_ICACHE_IDX_WIDTH = drac_icache_pkg_ADDR_WIDHT;
	wire [7:0] vaddr_index;
	wire [1:0] way_to_replace_q;
	wire [1:0] way_to_replace_d;
	wire [3:0] tag_req_valid;
	wire [3:0] data_req_valid;
	wire [3:0] way_valid_bits;
	wire [7:0] addr_valid;
	wire [3:0] cline_hit;
	wire [(drac_icache_pkg_ICACHE_N_WAY * drac_icache_pkg_TAG_WIDHT) - 1:0] way_tags;
	wire [(drac_icache_pkg_ICACHE_N_WAY * drac_icache_pkg_WAY_WIDHT) - 1:0] cline_data_rd;
	wire [11:0] idx_d;
	wire [11:0] idx_q;
	wire [27:0] vpn_d;
	wire [27:0] vpn_q;
	wire ifill_req_valid;
	wire flush_d;
	wire flush_q;
	wire paddr_is_nc;
	wire replay_valid;
	wire valid_ireq_d;
	wire valid_ireq_q;
	wire ireq_kill_d;
	wire ireq_kill_q;
	wire flush_enable;
	wire cache_rd_ena;
	wire cache_wr_ena;
	wire req_valid;
	wire tag_we_valid;
	wire cmp_enable;
	wire cmp_enable_q;
	wire treq_valid;
	wire ifill_req_was_sent_d;
	wire ifill_req_was_sent_q;
	wire [22:0] mmu_tresp_d;
	wire [22:0] mmu_tresp_q;
	assign valid_ireq_d = lagarto_ireq_i[41] || replay_valid;
	wire is_flush_d;
	assign is_flush_d = flush_i;
	assign ireq_kill_d = lagarto_ireq_i[40];
	assign vpn_d = (lagarto_ireq_i[41] ? {lagarto_ireq_i[27-:drac_pkg_ICACHE_VPN_BITS_SIZE]} : vpn_q);
	assign idx_d = (lagarto_ireq_i[41] ? {lagarto_ireq_i[39-:12]} : idx_q);
	assign icache_treq_o[27-:drac_pkg_ICACHE_VPN_BITS_SIZE] = vpn_d;
	assign icache_treq_o[28] = treq_valid || valid_ireq_d;
	assign mmu_tresp_d = mmu_tresp_i;
	localparam [31:0] drac_icache_pkg_ICACHE_INDEX_WIDTH = 12;
	localparam [31:0] drac_icache_pkg_ICACHE_OFFSET_WIDTH = 4;
	assign vaddr_index = (cache_wr_ena ? {idx_d[11:6], ifill_resp_i[1-:2]} : idx_d[11:drac_icache_pkg_ICACHE_OFFSET_WIDTH]);
	assign cline_tag_d = mmu_tresp_q[20-:20];
	assign icache_resp_o[40-:40] = {vpn_q, idx_q};
	wire icache_resp_valid;
	assign icache_resp_o[0] = mmu_tresp_q[0] && icache_resp_valid;
	assign icache_resp_o[169] = icache_resp_valid && !ireq_kill_d;
	assign icache_ifill_req_o[25-:drac_icache_pkg_PADDR_SIZE] = {cline_tag_d, idx_q[11:6]};
	assign icache_ifill_req_o[28] = ifill_req_valid && !ireq_kill_d;
	wire valid_ifill_resp;
	assign valid_ifill_resp = ifill_resp_i[131] & ifill_resp_i[130];
	assign ifill_req_was_sent_d = icache_ifill_req_o[28] | (ifill_req_was_sent_q & ~valid_ifill_resp);
	wire is_flush_q;
	icache_ctrl icache_ctrl(
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.cache_enable_i(1'b1),
		.paddr_is_nc_i(paddr_is_nc),
		.flush_i(is_flush_q),
		.flush_done_i(1'b0),
		.cmp_enable_o(cmp_enable),
		.cache_rd_ena_o(cache_rd_ena),
		.cache_wr_ena_o(cache_wr_ena),
		.ireq_valid_i(valid_ireq_q),
		.ireq_kill_i(ireq_kill_q),
		.ireq_kill_d(ireq_kill_d),
		.iresp_ready_o(icache_resp_o[170]),
		.iresp_valid_o(icache_resp_valid),
		.mmu_miss_i(mmu_tresp_q[22]),
		.mmu_ptw_valid_i(mmu_tresp_q[21]),
		.mmu_ex_valid_i(mmu_tresp_q[0]),
		.treq_valid_o(treq_valid),
		.valid_ifill_resp_i(valid_ifill_resp),
		.ifill_resp_valid_i(ifill_resp_i[131]),
		.ifill_sent_ack_i(ifill_req_was_sent_d),
		.ifill_req_valid_o(ifill_req_valid),
		.cline_hit_i(cline_hit),
		.miss_o(imiss_time_pmu_o),
		.miss_kill_o(imiss_kill_pmu_o),
		.replay_valid_o(replay_valid),
		.flush_en_o(flush_enable)
	);
	top_memory icache_memory(
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.tag_req_i(tag_req_valid),
		.data_req_i(data_req_valid),
		.tag_we_i(tag_we_valid),
		.data_we_i(cache_wr_ena),
		.flush_en_i(is_flush_d),
		.valid_bit_i(cache_wr_ena),
		.cline_i(ifill_resp_i[129-:128]),
		.tag_i(cline_tag_q),
		.addr_i(addr_valid),
		.tag_way_o(way_tags),
		.cline_way_o(cline_data_rd),
		.valid_bit_o(way_valid_bits)
	);
	icache_replace_unit replace_unit(
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.inval_i(1'sb0),
		.cline_index_i(vaddr_index),
		.cache_rd_ena_i(valid_ireq_d | cache_rd_ena),
		.cache_wr_ena_i(cache_wr_ena),
		.flush_ena_i(flush_enable),
		.way_valid_bits_i(way_valid_bits),
		.we_valid_o(tag_we_valid),
		.addr_valid_o(addr_valid),
		.cmp_en_q(cmp_enable_q),
		.way_to_replace_q(way_to_replace_q),
		.way_to_replace_d(way_to_replace_d),
		.way_to_replace_o(icache_ifill_req_o[27-:2]),
		.data_req_valid_o(data_req_valid),
		.tag_req_valid_o(tag_req_valid)
	);
	icache_checker ichecker(
		.read_tags_i(way_tags),
		.cmp_enable_q(cmp_enable_q),
		.cline_tag_d(cline_tag_d),
		.way_valid_bits_i(way_valid_bits),
		.data_rd_i(cline_data_rd),
		.cline_hit_o(cline_hit),
		.ifill_data_i(ifill_resp_i[129-:128]),
		.data_o(icache_resp_o[168-:128])
	);
	icache_ff icache_ff(
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.vpn_d(vpn_d),
		.vpn_q(vpn_q),
		.idx_d(idx_d),
		.idx_q(idx_q),
		.flush_d(is_flush_d),
		.flush_q(is_flush_q),
		.cline_tag_d(cline_tag_d),
		.cline_tag_q(cline_tag_q),
		.cmp_enable_d(cmp_enable),
		.cmp_enable_q(cmp_enable_q),
		.way_to_replace_q(way_to_replace_q),
		.way_to_replace_d(way_to_replace_d),
		.valid_ireq_d(valid_ireq_d),
		.valid_ireq_q(valid_ireq_q),
		.ireq_kill_d(ireq_kill_d),
		.ireq_kill_q(ireq_kill_q),
		.mmu_tresp_d(mmu_tresp_d),
		.mmu_tresp_q(mmu_tresp_q),
		.cache_enable_d(ifill_req_was_sent_d),
		.cache_enable_q(ifill_req_was_sent_q)
	);
endmodule
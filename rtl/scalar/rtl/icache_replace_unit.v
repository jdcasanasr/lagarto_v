module icache_replace_unit (
	clk_i,
	rstn_i,
	inval_i,
	flush_ena_i,
	cache_rd_ena_i,
	cache_wr_ena_i,
	way_valid_bits_i,
	cmp_en_q,
	cline_index_i,
	way_to_replace_q,
	way_to_replace_d,
	way_to_replace_o,
	we_valid_o,
	addr_valid_o,
	data_req_valid_o,
	tag_req_valid_o
);
	input clk_i;
	input rstn_i;
	localparam [31:0] drac_icache_pkg_ICACHE_INDEX_WIDTH = 12;
	localparam [31:0] drac_icache_pkg_ICACHE_N_WAY = 4;
	input wire [15:0] inval_i;
	input wire flush_ena_i;
	input wire cache_rd_ena_i;
	input wire cache_wr_ena_i;
	input wire [3:0] way_valid_bits_i;
	input wire cmp_en_q;
	localparam [31:0] drac_icache_pkg_ICACHE_DEPTH = 256;
	localparam [31:0] drac_icache_pkg_ADDR_WIDHT = 8;
	localparam [31:0] drac_icache_pkg_ICACHE_IDX_WIDTH = drac_icache_pkg_ADDR_WIDHT;
	input wire [7:0] cline_index_i;
	input wire [1:0] way_to_replace_q;
	output wire [1:0] way_to_replace_d;
	output wire [1:0] way_to_replace_o;
	output wire we_valid_o;
	output wire [7:0] addr_valid_o;
	output wire [3:0] data_req_valid_o;
	output wire [3:0] tag_req_valid_o;
	wire inval_req;
	wire lfsr_ena;
	wire all_ways_valid;
	wire [7:0] addr_to_inval;
	reg [3:0] way_to_inval_oh;
	reg [3:0] way_to_replace_q_oh;
	wire [1:0] a_random_way;
	wire [1:0] a_invalid_way;
	assign inval_req = ~flush_ena_i & inval_i[15];
	localparam [31:0] drac_icache_pkg_ICACHE_OFFSET_WIDTH = 4;
	assign addr_to_inval = inval_i[13:6];
	always @(*) begin
		way_to_inval_oh = 1'sb0;
		if (inval_req)
			way_to_inval_oh[inval_i[1-:2]] = 1'b1;
	end
	assign addr_valid_o = (inval_req ? addr_to_inval : cline_index_i);
	assign tag_req_valid_o = (cache_rd_ena_i ? {4 {1'sb1}} : (inval_req && inval_i[14] ? {4 {1'sb1}} : (inval_req ? way_to_inval_oh : way_to_replace_q_oh)));
	assign we_valid_o = cache_wr_ena_i | inval_req;
	assign lfsr_ena = cache_wr_ena_i & all_ways_valid;
	assign way_to_replace_o = (all_ways_valid ? a_random_way : a_invalid_way);
	assign way_to_replace_d = (cmp_en_q ? way_to_replace_o : way_to_replace_q);
	always @(*) begin
		way_to_replace_q_oh = 1'sb0;
		way_to_replace_q_oh[way_to_replace_q] = 1'b1;
	end
	assign data_req_valid_o = (cache_rd_ena_i ? {4 {1'sb1}} : (cache_wr_ena_i ? way_to_replace_q_oh : {4 {1'sb0}}));
	icache_lfsr lfsr(
		.clk_i(clk_i),
		.rst_ni(rstn_i),
		.en_i(lfsr_ena),
		.refill_way_o(a_random_way)
	);
	icache_tzc tzc(
		.in_i(~way_valid_bits_i),
		.inval_way_o(a_invalid_way),
		.empty_o(all_ways_valid)
	);
endmodule
module icache_checker (
	cmp_enable_q,
	cline_tag_d,
	way_valid_bits_i,
	ifill_data_i,
	cline_hit_o,
	data_o,
	read_tags_i,
	data_rd_i
);
	input wire cmp_enable_q;
	localparam [31:0] drac_icache_pkg_TAG_WIDHT = 20;
	localparam [31:0] drac_icache_pkg_ICACHE_TAG_WIDTH = drac_icache_pkg_TAG_WIDHT;
	input wire [19:0] cline_tag_d;
	localparam [31:0] drac_icache_pkg_ICACHE_N_WAY = 4;
	input wire [3:0] way_valid_bits_i;
	localparam [31:0] drac_icache_pkg_WORD_SIZE = 64;
	localparam [31:0] drac_icache_pkg_SET_WIDHT = 128;
	localparam [31:0] drac_icache_pkg_WAY_WIDHT = drac_icache_pkg_SET_WIDHT;
	input wire [127:0] ifill_data_i;
	output wire [3:0] cline_hit_o;
	localparam drac_pkg_ICACHELINE_SIZE = 127;
	localparam [31:0] drac_icache_pkg_FETCH_WIDHT = 128;
	output wire [127:0] data_o;
	input wire [(drac_icache_pkg_ICACHE_N_WAY * drac_icache_pkg_TAG_WIDHT) - 1:0] read_tags_i;
	input wire [(drac_icache_pkg_ICACHE_N_WAY * drac_icache_pkg_WAY_WIDHT) - 1:0] data_rd_i;
	wire [1:0] idx;
	wire [(drac_icache_pkg_ICACHE_N_WAY * drac_icache_pkg_FETCH_WIDHT) - 1:0] cline_sel;
	genvar i;
	generate
		for (i = 0; i < drac_icache_pkg_ICACHE_N_WAY; i = i + 1) begin : tag_cmp
			assign cline_hit_o[i] = (read_tags_i[i * drac_icache_pkg_TAG_WIDHT+:drac_icache_pkg_TAG_WIDHT] == cline_tag_d) & way_valid_bits_i[i];
			assign cline_sel[i * drac_icache_pkg_FETCH_WIDHT+:drac_icache_pkg_FETCH_WIDHT] = data_rd_i[(i * drac_icache_pkg_WAY_WIDHT) + 127-:drac_icache_pkg_FETCH_WIDHT];
		end
	endgenerate
	icache_tzc_idx tzc_idx(
		.in_i(cline_hit_o),
		.way_o(idx)
	);
	assign data_o = cline_sel[idx * drac_icache_pkg_FETCH_WIDHT+:drac_icache_pkg_FETCH_WIDHT];
endmodule
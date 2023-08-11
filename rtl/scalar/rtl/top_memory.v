module top_memory (
	clk_i,
	rstn_i,
	tag_req_i,
	data_req_i,
	tag_we_i,
	data_we_i,
	flush_en_i,
	valid_bit_i,
	cline_i,
	tag_i,
	addr_i,
	tag_way_o,
	cline_way_o,
	valid_bit_o
);
	input wire clk_i;
	input wire rstn_i;
	localparam [31:0] drac_icache_pkg_ICACHE_N_WAY = 4;
	input wire [3:0] tag_req_i;
	input wire [3:0] data_req_i;
	input wire tag_we_i;
	input wire data_we_i;
	input wire flush_en_i;
	input wire valid_bit_i;
	localparam [31:0] drac_icache_pkg_WORD_SIZE = 64;
	localparam [31:0] drac_icache_pkg_SET_WIDHT = 128;
	localparam [31:0] drac_icache_pkg_WAY_WIDHT = drac_icache_pkg_SET_WIDHT;
	input wire [127:0] cline_i;
	localparam [31:0] drac_icache_pkg_TAG_WIDHT = 20;
	input wire [19:0] tag_i;
	localparam [31:0] drac_icache_pkg_ICACHE_DEPTH = 256;
	localparam [31:0] drac_icache_pkg_ADDR_WIDHT = 8;
	input wire [7:0] addr_i;
	output wire [(drac_icache_pkg_ICACHE_N_WAY * drac_icache_pkg_TAG_WIDHT) - 1:0] tag_way_o;
	output wire [(drac_icache_pkg_ICACHE_N_WAY * drac_icache_pkg_WAY_WIDHT) - 1:0] cline_way_o;
	output wire [3:0] valid_bit_o;
	idata_memory idata_memory(
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.req_i(data_req_i),
		.we_i(data_we_i),
		.data_i(cline_i),
		.addr_i(addr_i),
		.data_way_o(cline_way_o)
	);
	itag_memory itag_memory(
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.req_i(tag_req_i),
		.we_i(tag_we_i),
		.vbit_i(valid_bit_i),
		.flush_i(flush_en_i),
		.data_i(tag_i),
		.addr_i(addr_i),
		.tag_way_o(tag_way_o),
		.vbit_o(valid_bit_o)
	);
endmodule
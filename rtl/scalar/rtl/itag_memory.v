module itag_memory (
	clk_i,
	rstn_i,
	req_i,
	we_i,
	vbit_i,
	flush_i,
	data_i,
	addr_i,
	tag_way_o,
	vbit_o
);
	input wire clk_i;
	input wire rstn_i;
	localparam [31:0] drac_icache_pkg_ICACHE_N_WAY = 4;
	input wire [3:0] req_i;
	input wire we_i;
	input wire vbit_i;
	input wire flush_i;
	localparam [31:0] drac_icache_pkg_TAG_WIDHT = 20;
	input wire [19:0] data_i;
	localparam [31:0] drac_icache_pkg_ICACHE_DEPTH = 256;
	localparam [31:0] drac_icache_pkg_ADDR_WIDHT = 8;
	input wire [7:0] addr_i;
	output wire [(drac_icache_pkg_ICACHE_N_WAY * drac_icache_pkg_TAG_WIDHT) - 1:0] tag_way_o;
	output wire [3:0] vbit_o;
	genvar i;
	generate
		for (i = 0; i < drac_icache_pkg_ICACHE_N_WAY; i = i + 1) begin : tag_way
			tag_way_memory tag_way(
				.clk_i(clk_i),
				.rstn_i(rstn_i),
				.req_i(req_i[i]),
				.we_i(we_i),
				.vbit_i(vbit_i),
				.flush_i(flush_i),
				.data_i(data_i),
				.addr_i(addr_i),
				.data_o(tag_way_o[i * drac_icache_pkg_TAG_WIDHT+:drac_icache_pkg_TAG_WIDHT]),
				.vbit_o(vbit_o[i])
			);
		end
	endgenerate
endmodule
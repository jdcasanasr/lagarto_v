module idata_memory (
	clk_i,
	rstn_i,
	req_i,
	we_i,
	data_i,
	addr_i,
	data_way_o
);
	input wire clk_i;
	input wire rstn_i;
	localparam [31:0] drac_icache_pkg_ICACHE_N_WAY = 4;
	input wire [3:0] req_i;
	input wire we_i;
	localparam [31:0] drac_icache_pkg_WORD_SIZE = 64;
	localparam [31:0] drac_icache_pkg_SET_WIDHT = 128;
	input wire [127:0] data_i;
	localparam [31:0] drac_icache_pkg_ICACHE_DEPTH = 256;
	localparam [31:0] drac_icache_pkg_ADDR_WIDHT = 8;
	input wire [7:0] addr_i;
	output wire [(drac_icache_pkg_ICACHE_N_WAY * drac_icache_pkg_SET_WIDHT) - 1:0] data_way_o;
	genvar i;
	generate
		for (i = 0; i < drac_icache_pkg_ICACHE_N_WAY; i = i + 1) begin : n_way
			icache_way way(
				.clk_i(clk_i),
				.rstn_i(rstn_i),
				.req_i(req_i[i]),
				.we_i(we_i),
				.data_i(data_i),
				.addr_i(addr_i),
				.data_o(data_way_o[i * drac_icache_pkg_SET_WIDHT+:drac_icache_pkg_SET_WIDHT])
			);
		end
	endgenerate
endmodule
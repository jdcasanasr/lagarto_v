module cleaning_module (
	clk_i,
	rstn_i,
	flush_enable_i,
	flush_done_o,
	addr_q
);
	input wire clk_i;
	input wire rstn_i;
	input wire flush_enable_i;
	output wire flush_done_o;
	localparam [31:0] drac_icache_pkg_ICACHE_DEPTH = 256;
	localparam [31:0] drac_icache_pkg_ADDR_WIDHT = 8;
	output reg [7:0] addr_q;
	wire [31:0] depth;
	wire [7:0] addr_d;
	assign depth = 255;
	assign addr_d = (flush_enable_i ? addr_q + 1'b1 : addr_q);
	assign flush_done_o = addr_q == depth[7:0];
	always @(posedge clk_i)
		if (!rstn_i || flush_done_o)
			addr_q <= 1'sb0;
		else
			addr_q <= addr_d;
endmodule
module set_ram (
	clk_i,
	rstn_i,
	req_i,
	we_i,
	data_i,
	addr_i,
	data_o
);
	input wire clk_i;
	input wire rstn_i;
	input wire req_i;
	input wire we_i;
	localparam [31:0] drac_icache_pkg_WORD_SIZE = 64;
	localparam [31:0] drac_icache_pkg_SET_WIDHT = 128;
	input wire [127:0] data_i;
	localparam [31:0] drac_icache_pkg_ICACHE_DEPTH = 256;
	localparam [31:0] drac_icache_pkg_ADDR_WIDHT = 8;
	input wire [7:0] addr_i;
	output reg [127:0] data_o;
	reg [127:0] memory [0:255];
	always @(posedge clk_i)
		if (!rstn_i)
			data_o <= 1'sb0;
		else if (req_i)
			if (we_i)
				memory[addr_i] <= data_i;
			else
				data_o <= memory[addr_i];
endmodule
module tag_way_memory (
	clk_i,
	rstn_i,
	req_i,
	we_i,
	vbit_i,
	flush_i,
	data_i,
	addr_i,
	data_o,
	vbit_o
);
	input wire clk_i;
	input wire rstn_i;
	input wire req_i;
	input wire we_i;
	input wire vbit_i;
	input wire flush_i;
	localparam [31:0] drac_icache_pkg_TAG_WIDHT = 20;
	input wire [19:0] data_i;
	localparam [31:0] drac_icache_pkg_ICACHE_DEPTH = 256;
	localparam [31:0] drac_icache_pkg_ADDR_WIDHT = 8;
	input wire [7:0] addr_i;
	output reg [19:0] data_o;
	output reg vbit_o;
	reg [19:0] memory [0:255];
	reg [255:0] vbit_vec;
	always @(posedge clk_i)
		if (!rstn_i)
			data_o <= 1'sb0;
		else if (req_i)
			if (we_i)
				memory[addr_i] <= {data_i};
			else
				data_o <= memory[addr_i];
	always @(posedge clk_i)
		if (!rstn_i || flush_i)
			vbit_vec <= 1'sb0;
		else if (req_i)
			if (we_i)
				vbit_vec[addr_i] <= vbit_i;
			else
				vbit_o <= vbit_vec[addr_i];
endmodule
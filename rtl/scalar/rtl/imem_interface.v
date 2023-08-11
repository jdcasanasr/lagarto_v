module imem_interface (
	clk_extern_i,
	dbgr_we_i,
	dbgr_addr_i,
	dbgr_data_i,
	req_fetch_icache_i,
	resp_icache_fetch_o
);
	parameter MEM_WORD_WIDTH = 32;
	parameter MEM_SIZE = 16384;
	localparam MEM_DEPTH = MEM_SIZE / (MEM_WORD_WIDTH / 8);
	localparam ADDRS_WIDTH = $clog2(MEM_DEPTH);
	input wire clk_extern_i;
	input wire dbgr_we_i;
	input wire [ADDRS_WIDTH - 1:0] dbgr_addr_i;
	input wire [31:0] dbgr_data_i;
	localparam drac_pkg_ADDR_SIZE = 40;
	input wire [43:0] req_fetch_icache_i;
	localparam riscv_pkg_INST_SIZE = 32;
	output reg [33:0] resp_icache_fetch_o;
	reg [MEM_WORD_WIDTH - 1:0] mem [MEM_DEPTH - 1:0];
	//initial $readmemh("burbuja_esimecul.hex", mem);
	always @(posedge clk_extern_i) begin : proc_mem_write
		if (dbgr_we_i)
			mem[dbgr_addr_i] <= dbgr_data_i;
	end
	always @(*) begin : proc_mem_read
		resp_icache_fetch_o[33] = (req_fetch_icache_i[43] ? 1'b1 : 1'b0);
		resp_icache_fetch_o[32-:32] = mem[req_fetch_icache_i[3 + (ADDRS_WIDTH + 1):5]];
		resp_icache_fetch_o[0] = 1'b0;
	end
endmodule
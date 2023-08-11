module regfile (
	clk_i,
	write_enable_i,
	write_addr_i,
	write_data_i,
	read_addr1_i,
	read_addr2_i,
	read_data1_o,
	read_data2_o
);
	input wire clk_i;
	input wire write_enable_i;
	localparam drac_pkg_REGFILE_WIDTH = 5;
	input [4:0] write_addr_i;
	input wire [63:0] write_data_i;
	input [4:0] read_addr1_i;
	input [4:0] read_addr2_i;
	output wire [63:0] read_data1_o;
	output wire [63:0] read_data2_o;
	reg [63:0] registers [0:31];
	assign read_data1_o = (read_addr1_i == 0 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : ((write_addr_i == read_addr1_i) && write_enable_i ? write_data_i : registers[read_addr1_i]));
	assign read_data2_o = (read_addr2_i == 0 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : ((write_addr_i == read_addr2_i) && write_enable_i ? write_data_i : registers[read_addr2_i]));
	
	initial $readmemh("rf.hex", registers);
	
	always @(posedge clk_i)
		if (write_enable_i && (write_addr_i > 0))
			registers[write_addr_i] <= write_data_i;
endmodule
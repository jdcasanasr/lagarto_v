module itag_memory_sram64x80 (
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
	output reg [3:0] vbit_o;
	reg [255:0] vbit_vec [0:3];
	wire [79:0] q_sram;
	wire [79:0] write_mask;
	wire [79:0] write_data;
	wire [79:0] w_mask;
	wire [79:0] w_data;
	wire [79:0] mask;
	wire write_enable;
	genvar i;
	generate
		for (i = 0; i < drac_icache_pkg_ICACHE_N_WAY; i = i + 1) begin : genblk1
			always @(posedge clk_i)
				if (!rstn_i || flush_i)
					vbit_vec[i] <= 1'sb0;
				else if (req_i[i])
					if (we_i)
						vbit_vec[i][addr_i] <= vbit_i;
					else
						vbit_o[i] <= vbit_vec[i][addr_i];
		end
	endgenerate
	function automatic [19:0] sv2v_cast_20;
		input reg [19:0] inp;
		sv2v_cast_20 = inp;
	endfunction
	assign mask[19:0] = sv2v_cast_20(req_i[0]);
	assign mask[39:20] = sv2v_cast_20(req_i[1]);
	assign mask[59:40] = sv2v_cast_20(req_i[2]);
	assign mask[79:60] = sv2v_cast_20(req_i[3]);
	assign w_mask = sv2v_cast_20(we_i) & mask;
	assign w_data[19:0] = data_i;
	assign w_data[39:20] = data_i;
	assign w_data[59:40] = data_i;
	assign w_data[79:60] = data_i;
	assign write_mask = ~w_mask;
	assign write_data = w_data;
	assign write_enable = ~we_i;
	wire RW0A;
	TS1N65LPA64X80M4 IC_tag_array(
		.A(RW0A),
		.D(write_data),
		.BWEB(write_mask),
		.WEB(write_enable),
		.CEB(~(|req_i)),
		.CLK(clk_i),
		.Q(q_sram)
	);
	assign tag_way_o[0+:drac_icache_pkg_TAG_WIDHT] = q_sram[19:0];
	assign tag_way_o[drac_icache_pkg_TAG_WIDHT+:drac_icache_pkg_TAG_WIDHT] = q_sram[39:20];
	assign tag_way_o[40+:drac_icache_pkg_TAG_WIDHT] = q_sram[59:40];
	assign tag_way_o[60+:drac_icache_pkg_TAG_WIDHT] = q_sram[79:60];
endmodule
module icache_lfsr (
	clk_i,
	rst_ni,
	en_i,
	refill_way_o
);
	input wire clk_i;
	input wire rst_ni;
	input wire en_i;
	localparam [31:0] drac_icache_pkg_ICACHE_N_WAY = 4;
	output reg [1:0] refill_way_o;
	reg [7:0] shift_d;
	reg [7:0] shift_q;
	always @(*) begin : sv2v_autoblock_1
		reg shift_in;
		shift_in = !(((shift_q[7] ^ shift_q[3]) ^ shift_q[2]) ^ shift_q[1]);
		shift_d = shift_q;
		if (en_i)
			shift_d = {shift_q[6:0], shift_in};
		refill_way_o = shift_q[1:0];
	end
	always @(posedge clk_i or negedge rst_ni) begin : proc_
		if (!rst_ni)
			shift_q <= 1'sb0;
		else
			shift_q <= shift_d;
	end
endmodule
module icache_tzc_idx (
	in_i,
	way_o
);
	localparam [31:0] drac_icache_pkg_ICACHE_N_WAY = 4;
	input wire [3:0] in_i;
	output reg [1:0] way_o;
	always @(*) begin : sv2v_autoblock_1
		reg [0:1] _sv2v_jump;
		_sv2v_jump = 2'b00;
		way_o = 1'sb0;
		begin : sv2v_autoblock_2
			reg [31:0] i;
			for (i = 0; i < drac_icache_pkg_ICACHE_N_WAY; i = i + 1)
				if (_sv2v_jump < 2'b10) begin
					_sv2v_jump = 2'b00;
					if (in_i[i]) begin
						way_o = i[1:0];
						_sv2v_jump = 2'b10;
					end
				end
			if (_sv2v_jump != 2'b11)
				_sv2v_jump = 2'b00;
		end
	end
endmodule
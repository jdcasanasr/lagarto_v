module icache_ff (
	clk_i,
	rstn_i,
	vaddr_d,
	vaddr_q,
	idx_d,
	idx_q,
	vpn_d,
	vpn_q,
	cline_tag_d,
	cline_tag_q,
	way_to_replace_d,
	way_to_replace_q,
	cmp_enable_d,
	cmp_enable_q,
	flush_d,
	flush_q,
	valid_ireq_d,
	valid_ireq_q,
	ireq_kill_d,
	ireq_kill_q,
	mmu_tresp_d,
	mmu_tresp_q,
	cache_enable_d,
	cache_enable_q
);
	input wire clk_i;
	input wire rstn_i;
	localparam drac_pkg_ADDR_SIZE = 40;
	localparam [31:0] drac_icache_pkg_VADDR_SIZE = drac_pkg_ADDR_SIZE;
	input wire [39:0] vaddr_d;
	output reg [39:0] vaddr_q;
	localparam drac_pkg_ICACHE_IDX_BITS_SIZE = 12;
	input wire [11:0] idx_d;
	output reg [11:0] idx_q;
	localparam drac_pkg_ICACHE_VPN_BITS_SIZE = 28;
	input wire [27:0] vpn_d;
	output reg [27:0] vpn_q;
	localparam [31:0] drac_icache_pkg_TAG_WIDHT = 20;
	localparam [31:0] drac_icache_pkg_ICACHE_TAG_WIDTH = drac_icache_pkg_TAG_WIDHT;
	input wire [19:0] cline_tag_d;
	output reg [19:0] cline_tag_q;
	localparam [31:0] drac_icache_pkg_ICACHE_N_WAY = 4;
	input wire [1:0] way_to_replace_d;
	output reg [1:0] way_to_replace_q;
	input wire cmp_enable_d;
	output reg cmp_enable_q;
	input wire flush_d;
	output reg flush_q;
	input wire valid_ireq_d;
	output reg valid_ireq_q;
	input wire ireq_kill_d;
	output reg ireq_kill_q;
	input wire [22:0] mmu_tresp_d;
	output reg [22:0] mmu_tresp_q;
	input wire cache_enable_d;
	output reg cache_enable_q;
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i) begin
			cache_enable_q <= 1'sb0;
			cmp_enable_q <= 1'sb0;
			vaddr_q <= 1'sb0;
			vpn_q <= 1'sb0;
			idx_q <= 1'sb0;
			flush_q <= 1'sb0;
			cline_tag_q <= 1'sb0;
			way_to_replace_q <= 1'sb0;
			mmu_tresp_q <= 1'sb0;
			valid_ireq_q <= 1'sb0;
			ireq_kill_q <= 1'sb0;
		end
		else begin
			cache_enable_q <= cache_enable_d;
			cmp_enable_q <= cmp_enable_d;
			vaddr_q <= vaddr_d;
			vpn_q <= vpn_d;
			idx_q <= idx_d;
			flush_q <= flush_d;
			cline_tag_q <= cline_tag_d;
			way_to_replace_q <= way_to_replace_d;
			valid_ireq_q <= valid_ireq_d;
			ireq_kill_q <= ireq_kill_d;
			mmu_tresp_q <= mmu_tresp_d;
		end
endmodule
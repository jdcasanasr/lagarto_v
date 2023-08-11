`include	"../../includes/icache_interface.vh"
module icache_interface (
	clk_i,
	rstn_i,
	req_fetch_icache_i,
	icache_resp_datablock_i,
	icache_resp_vaddr_i,
	icache_resp_valid_i,
	icache_req_ready_i,
	tlb_resp_xcp_if_i,
	icache_invalidate_o,
	icache_req_bits_idx_o,
	icache_req_kill_o,
	icache_req_valid_o,
	icache_req_bits_vpn_o,
	resp_icache_fetch_o,
	buffer_miss_o
);
	input wire clk_i;
	input wire rstn_i;
	localparam drac_pkg_ADDR_SIZE = 40;
	input wire [43:0] req_fetch_icache_i;
	localparam drac_pkg_ICACHELINE_SIZE = 127;
	input wire [drac_pkg_ICACHELINE_SIZE:0] icache_resp_datablock_i;
	input wire [39:0] icache_resp_vaddr_i;
	input wire icache_resp_valid_i;
	input wire icache_req_ready_i;
	input wire tlb_resp_xcp_if_i;
	output wire icache_invalidate_o;
	localparam drac_pkg_ICACHE_IDX_BITS_SIZE = 12;
	output wire [11:0] icache_req_bits_idx_o;
	output wire icache_req_kill_o;
	output reg icache_req_valid_o;
	localparam drac_pkg_ICACHE_VPN_BITS_SIZE = 28;
	output wire [27:0] icache_req_bits_vpn_o;
	localparam riscv_pkg_INST_SIZE = 32;
	output reg [33:0] resp_icache_fetch_o;
	output wire buffer_miss_o;
	reg [drac_pkg_ICACHELINE_SIZE:0] icache_line_reg_q;
	reg [drac_pkg_ICACHELINE_SIZE:0] icache_line_reg_d;
	wire [drac_pkg_ICACHELINE_SIZE:0] icache_line_int;
	reg [39:0] pc_buffer_d;
	reg [39:0] pc_buffer_q;
	reg [39:0] old_pc_req_d;
	reg [39:0] old_pc_req_q;
	reg valid_buffer_q;
	reg valid_buffer_d;
	wire buffer_diff_int;
	wire icache_access_needed_int;
	wire buffer_miss_int;
	reg [1:0] state_int;
	reg [1:0] next_state_int;
	wire do_request_int;
	wire new_addr_req;
	wire is_same_addr;
	wire a_valid_resp;
	wire to_NoReqi;
	reg kill;
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i)
			state_int <= `not_request;
		else
			state_int <= next_state_int;
	assign do_request_int = (icache_access_needed_int & ~req_fetch_icache_i[1]) & icache_req_ready_i;
	assign new_addr_req = old_pc_req_q[39:4] != req_fetch_icache_i[42:7];
	assign is_same_addr = icache_resp_vaddr_i[39:4] == req_fetch_icache_i[42:7];
	assign a_valid_resp = icache_resp_valid_i & is_same_addr;
	wire to_NoReq;
	assign to_NoReq = ((new_addr_req | a_valid_resp) | req_fetch_icache_i[0]) | req_fetch_icache_i[2];
	assign icache_req_bits_vpn_o = (do_request_int ? req_fetch_icache_i[42:15] : old_pc_req_q[39:12]);
	assign icache_req_bits_idx_o = (do_request_int ? req_fetch_icache_i[14:3] : old_pc_req_q[11:0]);
	assign icache_req_kill_o = req_fetch_icache_i[0] | kill;
	always @(*)
		case (state_int)
			`not_request: begin
				next_state_int = (do_request_int && !tlb_resp_xcp_if_i ? `request_valid : `not_request);
				icache_req_valid_o = do_request_int;
				resp_icache_fetch_o[33] = ~buffer_miss_int | (tlb_resp_xcp_if_i & do_request_int);
				kill = 1'b0;
			end
			`request_valid: begin
				next_state_int = (to_NoReq ? `not_request : `request_valid);
				icache_req_valid_o = 1'b0;
				resp_icache_fetch_o[33] = ~buffer_miss_int | a_valid_resp;
				kill = new_addr_req;
			end
			default: begin
				next_state_int = `not_request;
				icache_req_valid_o = 1'b0;
				resp_icache_fetch_o[33] = 1'b0;
				kill = 1'b0;
			end
		endcase
	assign icache_access_needed_int = req_fetch_icache_i[43] & buffer_miss_int;
	assign icache_invalidate_o = req_fetch_icache_i[2];
	wire tlb_req_valid_o;
	assign tlb_req_valid_o = icache_req_valid_o;
	wire [1:1] sv2v_tmp_093BE;
	assign sv2v_tmp_093BE = tlb_resp_xcp_if_i & buffer_miss_int;
	always @(*) resp_icache_fetch_o[0] = sv2v_tmp_093BE;
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i) begin
			icache_line_reg_q <= 128'b0;
			valid_buffer_q <= 1'b0;
		end
		else begin
			icache_line_reg_q <= icache_line_int;
			valid_buffer_q <= valid_buffer_d;
		end
	always @(*) valid_buffer_d = (valid_buffer_q | icache_resp_valid_i) && ~req_fetch_icache_i[1];
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i) begin
			pc_buffer_q <= {drac_pkg_ADDR_SIZE {1'b0}};
			old_pc_req_q <= {drac_pkg_ADDR_SIZE {1'b0}};
		end
		else begin
			pc_buffer_q <= pc_buffer_d;
			old_pc_req_q <= old_pc_req_d;
		end
	wire [40:1] sv2v_tmp_DCA12;
	assign sv2v_tmp_DCA12 = (do_request_int && (state_int == `not_request) ? req_fetch_icache_i[42-:40] : old_pc_req_q);
	always @(*) old_pc_req_d = sv2v_tmp_DCA12;
	assign icache_line_int = ((icache_resp_valid_i & !tlb_resp_xcp_if_i) & (icache_resp_vaddr_i[39:4] == req_fetch_icache_i[42:7]) ? icache_resp_datablock_i : icache_line_reg_q);
	wire [40:1] sv2v_tmp_651F8;
	assign sv2v_tmp_651F8 = ((icache_resp_valid_i & !tlb_resp_xcp_if_i) & (icache_resp_vaddr_i[39:4] == req_fetch_icache_i[42:7]) ? req_fetch_icache_i[42-:40] : pc_buffer_q);
	always @(*) pc_buffer_d = sv2v_tmp_651F8;
	assign buffer_diff_int = valid_buffer_q & (pc_buffer_q[39:4] != req_fetch_icache_i[42:7]);
	assign buffer_miss_int = !valid_buffer_q | buffer_diff_int;
	always @(*)
		if (tlb_resp_xcp_if_i & buffer_miss_int)
			resp_icache_fetch_o[`response_icache_data] = 32'h0;
		else
			case (req_fetch_icache_i[6:5])
				2'b00: 		resp_icache_fetch_o[`response_icache_data] = icache_line_int[31:0];
				2'b01: 		resp_icache_fetch_o[`response_icache_data] = icache_line_int[63:32];
				2'b10: 		resp_icache_fetch_o[`response_icache_data] = icache_line_int[95:64];
				2'b11: 		resp_icache_fetch_o[`response_icache_data] = icache_line_int[127:96];
				default: 	resp_icache_fetch_o[`response_icache_data] = 32'h0;
			endcase
	assign buffer_miss_o = icache_access_needed_int;
endmodule
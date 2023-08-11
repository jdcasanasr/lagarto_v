module top_drac (
	CLK,
	RST,
	SOFT_RST,
	RESET_ADDRESS,
	debug_halt_i,
	IO_FETCH_PC_VALUE,
	IO_FETCH_PC_UPDATE,
	IO_REG_READ,
	IO_REG_ADDR,
	IO_REG_WRITE,
	IO_REG_WRITE_DATA,
	CSR_RW_RDATA,
	CSR_CSR_STALL,
	CSR_XCPT,
	CSR_XCPT_CAUSE,
	CSR_TVAL,
	CSR_ERET,
	CSR_EVEC,
	CSR_INTERRUPT,
	CSR_INTERRUPT_CAUSE,
	io_csr_csr_replay,
	csr_priv_lvl_i,
	PTWINVALIDATE,
	TLB_RESP_MISS,
	TLB_RESP_XCPT_IF,
	itlb_resp_ppn_i,
	iptw_resp_valid_i,
	io_mem_grant_valid,
	io_mem_grant_bits_data,
	io_mem_grant_bits_addr_beat,
	DMEM_REQ_READY,
	DMEM_RESP_BITS_DATA_SUBW,
	DMEM_RESP_BITS_NACK,
	DMEM_RESP_BITS_REPLAY,
	DMEM_RESP_VALID,
	DMEM_XCPT_MA_ST,
	DMEM_XCPT_MA_LD,
	DMEM_XCPT_PF_ST,
	DMEM_XCPT_PF_LD,
	DMEM_ORDERED,
	CSR_RW_ADDR,
	CSR_RW_CMD,
	CSR_RW_WDATA,
	CSR_EXCEPTION,
	CSR_RETIRE,
	CSR_CAUSE,
	CSR_PC,
	TLB_REQ_BITS_VPN,
	TLB_REQ_VALID,
	io_mem_acquire_valid,
	io_mem_acquire_bits_addr_block,
	io_mem_acquire_bits_client_xact_id,
	io_mem_acquire_bits_addr_beat,
	io_mem_acquire_bits_data,
	io_mem_acquire_bits_is_builtin_type,
	io_mem_acquire_bits_a_type,
	io_mem_acquire_bits_union,
	io_mem_grant_ready,
	DMEM_REQ_VALID,
	DMEM_OP_TYPE,
	DMEM_REQ_CMD,
	DMEM_REQ_BITS_DATA,
	DMEM_REQ_BITS_ADDR,
	DMEM_REQ_BITS_TAG,
	DMEM_REQ_INVALIDATE_LR,
	DMEM_REQ_BITS_KILL,
	IO_FETCH_PC,
	IO_DEC_PC,
	IO_RR_PC,
	IO_EXE_PC,
	IO_WB_PC,
	IO_WB_PC_VALID,
	IO_WB_ADDR,
	IO_WB_WE,
	IO_WB_BITS_ADDR,
	IO_REG_READ_DATA,
	io_core_pmu_l2_hit_i,
	io_core_pmu_branch_miss,
	io_core_pmu_is_branch,
	io_core_pmu_branch_taken,
	io_core_pmu_EXE_STORE,
	io_core_pmu_EXE_LOAD,
	io_core_pmu_new_instruction,
	io_core_pmu_icache_req,
	io_core_pmu_icache_kill,
	io_core_pmu_stall_if,
	io_core_pmu_stall_id,
	io_core_pmu_stall_rr,
	io_core_pmu_stall_exe,
	io_core_pmu_stall_wb,
	io_core_pmu_buffer_miss,
	io_core_pmu_imiss_kill,
	io_core_pmu_icache_bussy,
	io_core_pmu_imiss_time
);
	input wire CLK;
	input wire RST;
	input wire SOFT_RST;
	localparam drac_pkg_ADDR_SIZE = 40;
	input wire [39:0] RESET_ADDRESS;
	input debug_halt_i;
	input wire [39:0] IO_FETCH_PC_VALUE;
	input IO_FETCH_PC_UPDATE;
	input IO_REG_READ;
	input [4:0] IO_REG_ADDR;
	input IO_REG_WRITE;
	input wire [63:0] IO_REG_WRITE_DATA;
	input wire [63:0] CSR_RW_RDATA;
	input wire CSR_CSR_STALL;
	input wire CSR_XCPT;
	input [63:0] CSR_XCPT_CAUSE;
	input [63:0] CSR_TVAL;
	input wire CSR_ERET;
	input wire [39:0] CSR_EVEC;
	input wire CSR_INTERRUPT;
	input wire [63:0] CSR_INTERRUPT_CAUSE;
	input wire io_csr_csr_replay;
	input [1:0] csr_priv_lvl_i;
	input wire PTWINVALIDATE;
	input wire TLB_RESP_MISS;
	input wire TLB_RESP_XCPT_IF;
	input wire [19:0] itlb_resp_ppn_i;
	input wire iptw_resp_valid_i;
	input wire io_mem_grant_valid;
	input wire [127:0] io_mem_grant_bits_data;
	input wire [1:0] io_mem_grant_bits_addr_beat;
	input wire DMEM_REQ_READY;
	input wire [63:0] DMEM_RESP_BITS_DATA_SUBW;
	input wire DMEM_RESP_BITS_NACK;
	input wire DMEM_RESP_BITS_REPLAY;
	input wire DMEM_RESP_VALID;
	input wire DMEM_XCPT_MA_ST;
	input wire DMEM_XCPT_MA_LD;
	input wire DMEM_XCPT_PF_ST;
	input wire DMEM_XCPT_PF_LD;
	input wire DMEM_ORDERED;
	output wire [11:0] CSR_RW_ADDR;
	output wire [2:0] CSR_RW_CMD;
	output wire [63:0] CSR_RW_WDATA;
	output wire CSR_EXCEPTION;
	output wire CSR_RETIRE;
	output wire [63:0] CSR_CAUSE;
	output wire [39:0] CSR_PC;
	output wire [27:0] TLB_REQ_BITS_VPN;
	output wire TLB_REQ_VALID;
	output wire io_mem_acquire_valid;
	output wire [25:0] io_mem_acquire_bits_addr_block;
	output wire io_mem_acquire_bits_client_xact_id;
	output wire [1:0] io_mem_acquire_bits_addr_beat;
	output wire [127:0] io_mem_acquire_bits_data;
	output wire io_mem_acquire_bits_is_builtin_type;
	output wire [2:0] io_mem_acquire_bits_a_type;
	output wire [16:0] io_mem_acquire_bits_union;
	output wire io_mem_grant_ready;
	output wire DMEM_REQ_VALID;
	output wire [3:0] DMEM_OP_TYPE;
	output wire [4:0] DMEM_REQ_CMD;
	output wire [63:0] DMEM_REQ_BITS_DATA;
	output wire [39:0] DMEM_REQ_BITS_ADDR;
	output wire [7:0] DMEM_REQ_BITS_TAG;
	output wire DMEM_REQ_INVALIDATE_LR;
	output wire DMEM_REQ_BITS_KILL;
	output wire [39:0] IO_FETCH_PC;
	output wire [39:0] IO_DEC_PC;
	output wire [39:0] IO_RR_PC;
	output wire [39:0] IO_EXE_PC;
	output wire [39:0] IO_WB_PC;
	output wire IO_WB_PC_VALID;
	output wire [4:0] IO_WB_ADDR;
	output wire IO_WB_WE;
	output wire [63:0] IO_WB_BITS_ADDR;
	output wire [63:0] IO_REG_READ_DATA;
	input wire io_core_pmu_l2_hit_i;
	output wire io_core_pmu_branch_miss;
	output wire io_core_pmu_is_branch;
	output wire io_core_pmu_branch_taken;
	output wire io_core_pmu_EXE_STORE;
	output wire io_core_pmu_EXE_LOAD;
	output wire io_core_pmu_new_instruction;
	output wire io_core_pmu_icache_req;
	output wire io_core_pmu_icache_kill;
	output wire io_core_pmu_stall_if;
	output wire io_core_pmu_stall_id;
	output wire io_core_pmu_stall_rr;
	output wire io_core_pmu_stall_exe;
	output wire io_core_pmu_stall_wb;
	output wire io_core_pmu_buffer_miss;
	output wire io_core_pmu_imiss_kill;
	output wire io_core_pmu_icache_bussy;
	output wire io_core_pmu_imiss_time;
	localparam riscv_pkg_INST_SIZE = 32;
	wire [33:0] resp_icache_interface_datapath;
	wire [43:0] req_datapath_icache_interface;
	wire [133:0] resp_dcache_interface_datapath;
	localparam drac_pkg_REGFILE_WIDTH = 5;
	wire [248:0] req_datapath_dcache_interface;
	wire [324:0] resp_csr_interface_datapath;
	reg [39:0] dcache_addr;
	localparam riscv_pkg_XLEN = 64;
	wire [136:0] debug_in;
	wire [270:0] debug_out;
	localparam drac_pkg_ICACHELINE_SIZE = 127;
	localparam [31:0] drac_icache_pkg_FETCH_WIDHT = 128;
	localparam [31:0] drac_icache_pkg_VADDR_SIZE = drac_pkg_ADDR_SIZE;
	wire [170:0] icache_resp;
	localparam drac_pkg_ICACHE_IDX_BITS_SIZE = 12;
	localparam drac_pkg_ICACHE_VPN_BITS_SIZE = 28;
	wire [41:0] lagarto_ireq;
	wire [22:0] itlb_tresp;
	wire [28:0] itlb_treq;
	localparam [31:0] drac_icache_pkg_WORD_SIZE = 64;
	localparam [31:0] drac_icache_pkg_SET_WIDHT = 128;
	localparam [31:0] drac_icache_pkg_WAY_WIDHT = drac_icache_pkg_SET_WIDHT;
	wire [131:0] ifill_resp;
	localparam [31:0] drac_icache_pkg_ICACHE_N_WAY = 4;
	localparam [31:0] drac_icache_pkg_PADDR_SIZE = 26;
	wire [28:0] ifill_req;
	wire iflush;
	wire [7:0] pmu_flags;
	wire buffer_miss;
	wire imiss_time_pmu;
	wire imiss_kill_pmu;
	wire imiss_l2_hit;
	assign debug_in[136] = debug_halt_i;
	assign debug_in[135-:64] = {24'b000000000000000000000000, IO_FETCH_PC_VALUE};
	assign debug_in[71] = IO_FETCH_PC_UPDATE;
	assign debug_in[70] = IO_REG_READ;
	assign debug_in[69-:5] = IO_REG_ADDR;
	assign debug_in[64] = IO_REG_WRITE;
	assign debug_in[63-:64] = IO_REG_WRITE_DATA;
	assign IO_FETCH_PC = debug_out[270-:40];
	assign IO_DEC_PC = debug_out[230-:40];
	assign IO_RR_PC = debug_out[190-:40];
	assign IO_EXE_PC = debug_out[150-:40];
	assign IO_WB_PC = debug_out[110-:40];
	assign IO_WB_PC_VALID = debug_out[70];
	assign IO_WB_ADDR = debug_out[69-:5];
	assign IO_WB_WE = debug_out[64];
	assign IO_REG_READ_DATA = debug_out[63-:64];
	always @(posedge CLK or negedge RST)
		if (~RST)
			dcache_addr <= 0;
		else
			dcache_addr <= DMEM_REQ_BITS_ADDR;
	assign IO_WB_BITS_ADDR = {24'b000000000000000000000000, dcache_addr};
	assign resp_csr_interface_datapath[324-:64] = CSR_RW_RDATA;
	assign resp_csr_interface_datapath[260] = 1'b0;
	assign resp_csr_interface_datapath[259] = CSR_CSR_STALL;
	assign resp_csr_interface_datapath[258] = CSR_XCPT;
	assign resp_csr_interface_datapath[257-:64] = CSR_XCPT_CAUSE;
	assign resp_csr_interface_datapath[63-:64] = CSR_TVAL;
	assign resp_csr_interface_datapath[193] = CSR_ERET;
	assign resp_csr_interface_datapath[192-:64] = {{25 {CSR_EVEC[39]}}, CSR_EVEC[38:0]};
	assign resp_csr_interface_datapath[128] = CSR_INTERRUPT;
	assign resp_csr_interface_datapath[127-:64] = CSR_INTERRUPT_CAUSE;
	localparam drac_pkg_CSR_ADDR_SIZE = 12;
	localparam drac_pkg_CSR_CMD_SIZE = 3;
	wire [208:0] req_datapath_csr_interface;
	assign CSR_RW_ADDR = req_datapath_csr_interface[208-:12];
	assign CSR_RW_CMD = req_datapath_csr_interface[196-:3];
	assign CSR_RW_WDATA = req_datapath_csr_interface[193-:64];
	assign CSR_EXCEPTION = req_datapath_csr_interface[129];
	assign CSR_RETIRE = req_datapath_csr_interface[128];
	assign CSR_CAUSE = req_datapath_csr_interface[127-:64];
	assign CSR_PC = req_datapath_csr_interface[39:0];
	assign ifill_resp[129-:128] = io_mem_grant_bits_data;
	assign ifill_resp[1-:2] = io_mem_grant_bits_addr_beat;
	assign ifill_resp[131] = io_mem_grant_valid;
	assign ifill_resp[130] = io_mem_grant_bits_addr_beat[0] & io_mem_grant_bits_addr_beat[1];
	assign io_mem_acquire_valid = ifill_req[28];
	assign io_mem_acquire_bits_addr_block = ifill_req[25-:drac_icache_pkg_PADDR_SIZE];
	assign io_mem_acquire_bits_client_xact_id = 1'b0;
	assign io_mem_acquire_bits_addr_beat = 2'b00;
	assign io_mem_acquire_bits_data = 127'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	assign io_mem_acquire_bits_is_builtin_type = 1'b1;
	assign io_mem_acquire_bits_a_type = 3'b001;
	assign io_mem_acquire_bits_union = 17'b00000000111000001;
	assign io_mem_grant_ready = 1'b1;
	assign itlb_tresp[22] = TLB_RESP_MISS;
	assign itlb_tresp[21] = iptw_resp_valid_i;
	assign itlb_tresp[20-:20] = itlb_resp_ppn_i;
	assign itlb_tresp[0] = TLB_RESP_XCPT_IF;
	assign TLB_REQ_BITS_VPN = itlb_treq[27-:drac_pkg_ICACHE_VPN_BITS_SIZE];
	assign TLB_REQ_VALID = itlb_treq[28];
	assign io_core_pmu_icache_req = lagarto_ireq[41];
	assign io_core_pmu_icache_kill = lagarto_ireq[40];
	assign io_core_pmu_stall_if = pmu_flags[7];
	assign io_core_pmu_stall_id = pmu_flags[6];
	assign io_core_pmu_stall_rr = pmu_flags[5];
	assign io_core_pmu_stall_exe = pmu_flags[4];
	assign io_core_pmu_stall_wb = pmu_flags[3];
	assign io_core_pmu_branch_miss = pmu_flags[2];
	assign io_core_pmu_is_branch = pmu_flags[1];
	assign io_core_pmu_branch_taken = pmu_flags[0];
	assign io_core_pmu_new_instruction = req_datapath_csr_interface[128];
	assign io_core_pmu_buffer_miss = imiss_l2_hit;
	assign io_core_pmu_imiss_time = imiss_time_pmu;
	assign io_core_pmu_imiss_kill = imiss_kill_pmu;
	assign io_core_pmu_icache_bussy = !icache_resp[170];
	datapath datapath_inst(
		.clk_i(CLK),
		.rstn_i(RST),
		.reset_addr_i(RESET_ADDRESS),
		.soft_rstn_i(SOFT_RST),
		.resp_icache_cpu_i(resp_icache_interface_datapath),
		.resp_dcache_cpu_i(resp_dcache_interface_datapath),
		.resp_csr_cpu_i(resp_csr_interface_datapath),
		.debug_i(debug_in),
		.req_cpu_dcache_o(req_datapath_dcache_interface),
		.req_cpu_icache_o(req_datapath_icache_interface),
		.req_cpu_csr_o(req_datapath_csr_interface),
		.debug_o(debug_out),
		.csr_priv_lvl_i(csr_priv_lvl_i),
		.pmu_flags_o(pmu_flags)
	);
	icache_interface icache_interface_inst(
		.clk_i(CLK),
		.rstn_i(RST),
		.icache_resp_datablock_i(icache_resp[168-:128]),
		.icache_resp_vaddr_i(icache_resp[40-:40]),
		.icache_resp_valid_i(icache_resp[169]),
		.icache_req_ready_i(icache_resp[170]),
		.tlb_resp_xcp_if_i(icache_resp[0]),
		.icache_invalidate_o(iflush),
		.icache_req_bits_idx_o(lagarto_ireq[39-:12]),
		.icache_req_kill_o(lagarto_ireq[40]),
		.icache_req_valid_o(lagarto_ireq[41]),
		.icache_req_bits_vpn_o(lagarto_ireq[27-:drac_pkg_ICACHE_VPN_BITS_SIZE]),
		.req_fetch_icache_i(req_datapath_icache_interface),
		.resp_icache_fetch_o(resp_icache_interface_datapath),
		.buffer_miss_o(buffer_miss)
	);
	dcache_interface dcache_interface_inst(
		.clk_i(CLK),
		.rstn_i(RST),
		.req_cpu_dcache_i(req_datapath_dcache_interface),
		.dmem_resp_replay_i(DMEM_RESP_BITS_REPLAY),
		.dmem_resp_data_i(DMEM_RESP_BITS_DATA_SUBW),
		.dmem_req_ready_i(DMEM_REQ_READY),
		.dmem_resp_valid_i(DMEM_RESP_VALID),
		.dmem_resp_nack_i(DMEM_RESP_BITS_NACK),
		.dmem_xcpt_ma_st_i(DMEM_XCPT_MA_ST),
		.dmem_xcpt_ma_ld_i(DMEM_XCPT_MA_LD),
		.dmem_xcpt_pf_st_i(DMEM_XCPT_PF_ST),
		.dmem_xcpt_pf_ld_i(DMEM_XCPT_PF_LD),
		.dmem_req_valid_o(DMEM_REQ_VALID),
		.dmem_req_cmd_o(DMEM_REQ_CMD),
		.dmem_req_addr_o(DMEM_REQ_BITS_ADDR),
		.dmem_op_type_o(DMEM_OP_TYPE),
		.dmem_req_data_o(DMEM_REQ_BITS_DATA),
		.dmem_req_tag_o(DMEM_REQ_BITS_TAG),
		.dmem_req_invalidate_lr_o(DMEM_REQ_INVALIDATE_LR),
		.dmem_req_kill_o(DMEM_REQ_BITS_KILL),
		.dmem_is_store_o(io_core_pmu_EXE_STORE),
		.dmem_is_load_o(io_core_pmu_EXE_LOAD),
		.resp_dcache_cpu_o(resp_dcache_interface_datapath)
	);
	top_icache icache(
		.clk_i(CLK),
		.rstn_i(RST),
		.flush_i(iflush),
		.lagarto_ireq_i(lagarto_ireq),
		.icache_resp_o(icache_resp),
		.mmu_tresp_i(itlb_tresp),
		.icache_treq_o(itlb_treq),
		.ifill_resp_i(ifill_resp),
		.icache_ifill_req_o(ifill_req),
		.imiss_time_pmu_o(imiss_time_pmu),
		.imiss_kill_pmu_o(imiss_kill_pmu)
	);
	assign imiss_l2_hit = ifill_resp[130] & io_core_pmu_l2_hit_i;
endmodule
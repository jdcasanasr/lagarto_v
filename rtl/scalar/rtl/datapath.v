module datapath (
//vector signal input/output
	rs1_addr_Ven_i,
	rs1_addr_i,
	rs1_data_o,
//scalar signal input/output
	clk_i,
	rstn_i,
	reset_addr_i,
	soft_rstn_i,
	resp_icache_cpu_i,
	resp_dcache_cpu_i,
	resp_csr_cpu_i,
	debug_i,
	csr_priv_lvl_i,
	req_cpu_dcache_o,
	req_cpu_icache_o,
	req_cpu_csr_o,
	debug_o,
	pmu_flags_o,
	reg_file_wr_event_o
);
//vector signal input/output
	input	wire 		rs1_addr_Ven_i;
	input	wire [5:0]	rs1_addr_i;
	output	wire [63:0]	rs1_data_o;
//scalar signal input/output
	input wire clk_i;
	input wire rstn_i;
	localparam drac_pkg_ADDR_SIZE = 40;
	input wire [39:0] reset_addr_i;
	input wire soft_rstn_i;
	localparam riscv_pkg_INST_SIZE = 32;
	input wire [33:0] resp_icache_cpu_i;
	input wire [133:0] resp_dcache_cpu_i;
	input wire [324:0] resp_csr_cpu_i;
	localparam riscv_pkg_XLEN = 64;
	input wire [136:0] debug_i;
	input [1:0] csr_priv_lvl_i;
	localparam drac_pkg_REGFILE_WIDTH = 5;
	output wire [248:0] req_cpu_dcache_o;
	output wire [43:0] req_cpu_icache_o;
	localparam drac_pkg_CSR_ADDR_SIZE = 12;
	localparam drac_pkg_CSR_CMD_SIZE = 3;
	output wire [208:0] req_cpu_csr_o;
	output wire [270:0] debug_o;
	output wire [7:0] pmu_flags_o;
	localparam debugger_pkg_V_REGS = 32;
	localparam debugger_pkg_RF_IDX_BITS = 5;
	localparam debugger_pkg_ARCH_BITS = 64;
	output wire [69:0] reg_file_wr_event_o;
	wire [63:0] pc_if;
	wire [63:0] pc_id;
	wire [63:0] pc_rr;
	wire [63:0] pc_exe;
	wire [63:0] pc_wb;
	wire valid_if;
	wire valid_id;
	wire valid_rr;
	wire valid_exe;
	wire valid_wb;
	wire [6:0] control_int;
	wire [4:0] flush_int;
	wire [1:0] cu_if_int;
	reg [63:0] pc_jump_if_int;
	reg [63:0] pc_evec_q;
	wire [291:0] stage_if_id_d;
	wire [291:0] stage_if_id_q;
	wire invalidate_icache_int;
	wire invalidate_buffer_int;
	reg retry_fetch;
	wire [358:0] stage_id_rr_d;
	wire [358:0] stage_id_rr_q;
	wire [551:0] stage_rr_exe_d;
	wire [551:0] stage_rr_exe_q;
	wire [1:0] id_cu_int;
	wire [64:0] jal_id_if_int;
	wire stall_exe_out;
	wire [4:0] exe_cu_int;
	wire [420:0] exe_to_wb_exe;
	wire [420:0] exe_to_wb_wb;
	wire [129:0] exe_if_branch_pred_int;
	wire [69:0] wb_to_exe_exe;
	wire wb_xcpt;
	reg [39:0] io_base_addr;
	wire [72:0] wb_cu_int;
	wire [0:0] rr_cu_int;
	wire [1:0] cu_rr_int;
	wire wb_csr_ena_int;
	wire [63:0] data_wb_rr_int;
	wire correct_branch_pred;
	wire [63:0] reg_wr_data;
	wire [4:0] reg_wr_addr;
	wire [4:0] reg_rd1_addr;
	wire stall_if;
	
	//vector 
	wire	[5:0]	rs1_addr_w;
	assign	rs1_addr_w	=	rs1_addr_Ven_i	?	rs1_addr_i:reg_rd1_addr;
	assign	rs1_data_o	=	rs1_addr_Ven_i	?	stage_rr_exe_d[192-:64]:64'b0;
	
	
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i)
			io_base_addr <= 40'h0040000000;
		else if (!soft_rstn_i)
			io_base_addr <= 40'h0040000000;
		else
			io_base_addr <= io_base_addr;
			
	control_unit control_unit_inst
	(
		.clk_i					(clk_i),
		.rstn_i					(rstn_i),
		.valid_fetch			(resp_icache_cpu_i[33]),
		
		.id_cu_i				(id_cu_int),
		.rr_cu_i				(rr_cu_int),
		.exe_cu_i				(exe_cu_int),
		.csr_cu_i				(resp_csr_cpu_i),
		.wb_cu_i				(wb_cu_int),
		
		
		.correct_branch_pred_i	(correct_branch_pred),
		.debug_halt_i			(debug_i[136]),
		.debug_change_pc_i		(debug_i[71]),
		.debug_wr_valid_i		(debug_i[64]),
		
		.cu_if_o				(cu_if_int),
		.cu_rr_o				(cu_rr_int),
		
		.pipeline_ctrl_o		(control_int),
		.pipeline_flush_o		(flush_int),
		
		.invalidate_icache_o	(invalidate_icache_int),
		.invalidate_buffer_o	(invalidate_buffer_int)
	);
	
	always @(*) begin
		retry_fetch = 1'b0;
		if (control_int[1-:2] == 2'b11)
			pc_jump_if_int = debug_i[135-:64];
		else if (control_int[1-:2] == 2'b00)
			pc_jump_if_int = exe_to_wb_exe[343-:64];
		else if (control_int[1-:2] == 2'b01) begin
			pc_jump_if_int = pc_evec_q;
			retry_fetch = 1'b1;
		end
		else
			pc_jump_if_int = jal_id_if_int[63-:riscv_pkg_XLEN];
	end
	assign stall_if = control_int[6] || debug_i[136];
	
	if_stage if_stage_inst(
		.clk_i					(clk_i),
		.rstn_i					(rstn_i),
		.reset_addr_i			(reset_addr_i),
		.stall_debug_i			(debug_i[136]),
		.stall_i				(stall_if),
		.cu_if_i				(cu_if_int),
		.invalidate_icache_i	(invalidate_icache_int),
		.invalidate_buffer_i	(invalidate_buffer_int),
		.pc_jump_i				(pc_jump_if_int),
		.resp_icache_cpu_i		(resp_icache_cpu_i),
		.retry_fetch_i			(retry_fetch),
		
		.req_cpu_icache_o		(req_cpu_icache_o),
		.fetch_o				(stage_if_id_d),
		.exe_if_branch_pred_i	(exe_if_branch_pred_int)
	);
	
	register #(292) reg_if_inst
	(
		.clk_i		(clk_i),
		.rstn_i		(rstn_i),
		.flush_i	(flush_int[4]),
		.load_i		(!control_int[6]),
		
		.input_i	(stage_if_id_d),
		
		.output_o	(stage_if_id_q)
	);
	
	decoder id_decode_inst
	(
		.decode_i		(stage_if_id_q),
		
		.decode_instr_o	(stage_id_rr_d),
		.jal_id_if_o	(jal_id_if_int)
	);
	
	assign id_cu_int[1] = jal_id_if_int[64];
	assign id_cu_int[0] = stage_id_rr_d[0] && stage_id_rr_d[358];
	
	register #(359) reg_id_inst(
		.clk_i		(clk_i),
		.rstn_i		(rstn_i),
		.flush_i	(flush_int[3]),
		.load_i		(!control_int[5]),
		.input_i	(stage_id_rr_d),
		
		.output_o	(stage_id_rr_q)
	);
	
	assign reg_wr_data 	= (debug_i[64] && debug_i[136] ? debug_i[63-:64] 	: data_wb_rr_int);
	assign reg_wr_addr 	= (debug_i[64] && debug_i[136] ? debug_i[69-:5] 	: exe_to_wb_wb[279-:5]);
	assign reg_rd1_addr = (debug_i[70] && debug_i[136] ? debug_i[69-:5] 	: stage_id_rr_q[98-:5]);
	
	regfile rr_stage_inst
	(
		.clk_i			(clk_i),
		.write_enable_i	(cu_rr_int[1] | cu_rr_int[0]),
		
		.write_addr_i	(reg_wr_addr),
		.write_data_i	(reg_wr_data),
		
		.read_addr1_i	(rs1_addr_w),
		.read_addr2_i	(stage_id_rr_q[93-:5]),
		
		.read_data1_o	(stage_rr_exe_d[192-:64]),
		.read_data2_o	(stage_rr_exe_d[128-:64])
	);
	
	assign reg_file_wr_event_o[0] = (cu_rr_int[1] | cu_rr_int[0]) & (reg_wr_addr > 0);
	assign reg_file_wr_event_o[69-:5] = reg_wr_addr;
	assign reg_file_wr_event_o[64-:64] = reg_wr_data;
	assign stage_rr_exe_d[551-:359] = stage_id_rr_q;
	assign stage_rr_exe_d[63-:64] = resp_csr_cpu_i[127-:64];
	assign stage_rr_exe_d[64] = resp_csr_cpu_i[128];
	assign rr_cu_int[0] = stage_rr_exe_d[193] && stage_rr_exe_d[551];
	
	register #(552) reg_rr_inst
	(
		.clk_i		(clk_i),
		.rstn_i		(rstn_i),
		.flush_i	(flush_int[2]),
		.load_i		(!control_int[4]),
		.input_i	(stage_rr_exe_d),
		
		.output_o	(stage_rr_exe_q)
	);
	
	//Agregado Microse, hacia abajo
	reg	[3:0]		ReadMemory_r;
	wire	[63:0]	DataMemory_r;
	assign			DataMemory_r	=	resp_dcache_cpu_i[132-:64];
	always @(posedge	clk_i)
	begin
		ReadMemory_r	<=	stage_rr_exe_q[273:271];
//		DataMemory_r	<=	exe_to_wb_exe[274-:64];
	end
	//Agregado Microse, hacia arriba
	
	exe_stage exe_stage_inst(
		.clk_i					(clk_i),
		.rstn_i					(rstn_i),
		.kill_i					(flush_int[1]),
		.csr_interrupt_i		(stage_rr_exe_q[64]),
		.csr_interrupt_cause_i	(stage_rr_exe_q[63-:64]),
		.from_rr_i				(stage_rr_exe_q),
		.from_wb_i				(wb_to_exe_exe),
		.resp_dcache_cpu_i		(resp_dcache_cpu_i),
		.io_base_addr_i			(io_base_addr),
		
		.to_wb_o				(exe_to_wb_exe),
		.stall_o				(exe_cu_int[1]),
		.req_cpu_dcache_o		(req_cpu_dcache_o),
		.exe_if_branch_pred_o	(exe_if_branch_pred_int),
		.correct_branch_pred_o	(correct_branch_pred),
		
		.pmu_is_branch_o		(pmu_flags_o[1]),
		.pmu_branch_taken_o		(pmu_flags_o[0]),
		.pmu_miss_prediction_o	(pmu_flags_o[2]),
		.pmu_stall_mul_o		(pmu_flags_o[5]),
		.pmu_stall_div_o		(pmu_flags_o[4]),
		.pmu_stall_mem_o		(pmu_flags_o[3])
	);
	assign exe_cu_int[4] = stage_rr_exe_q[551];
	assign exe_cu_int[3] = stage_rr_exe_q[270];
	assign exe_cu_int[0] = stage_rr_exe_q[193] && stage_rr_exe_q[551];
	
	//Agregado Microse, hacia abajo
	wire [420:0] exe_to_wb_wb2;
	assign	exe_to_wb_wb	=	(ReadMemory_r == 3'd4) ? {exe_to_wb_wb2[420:275], DataMemory_r, exe_to_wb_wb2[210:0]} : exe_to_wb_wb2;
	//Agregado Microse, hacia arriba
	
	register #(421) reg_exe_inst(
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.flush_i(flush_int[1]),
		.load_i(!control_int[3]),
		.input_i(exe_to_wb_exe),
		.output_o(exe_to_wb_wb2)
	);
	
	csr_interface csr_interface_inst(
		.wb_xcpt_i(wb_xcpt),
		.exe_to_wb_wb_i(exe_to_wb_wb),
		.stall_exe_i(control_int[3]),
		.wb_csr_ena_int_o(wb_csr_ena_int),
		.req_cpu_csr_o(req_cpu_csr_o)
	);
	assign wb_xcpt = exe_to_wb_wb[15];
	assign data_wb_rr_int = (wb_csr_ena_int ? resp_csr_cpu_i[324-:64] : exe_to_wb_wb[274-:64]);
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i)
			pc_evec_q <= 'b0;
		else
			pc_evec_q <= resp_csr_cpu_i[192-:64];
	assign wb_to_exe_exe[69] = exe_to_wb_wb[14] && exe_to_wb_wb[420];
	assign wb_to_exe_exe[68-:5] = exe_to_wb_wb[279-:5];
	assign wb_to_exe_exe[63-:64] = exe_to_wb_wb[274-:64];
	assign wb_cu_int[8] = exe_to_wb_wb[420];
	assign wb_cu_int[7] = exe_to_wb_wb[13];
	assign wb_cu_int[6] = wb_csr_ena_int;
	assign wb_cu_int[4] = exe_to_wb_wb[12] && exe_to_wb_wb[420];
	assign wb_cu_int[3] = wb_xcpt;
	assign wb_cu_int[5] = exe_to_wb_wb[14];
	assign wb_cu_int[2] = ((exe_to_wb_wb[350-:7] == 7'd26) || (exe_to_wb_wb[350-:7] == 7'd33)) || (exe_to_wb_wb[350-:7] == 7'd27);
	assign wb_cu_int[1] = ((exe_to_wb_wb[350-:7] == 7'd30) || (exe_to_wb_wb[350-:7] == 7'd29)) || (exe_to_wb_wb[350-:7] == 7'd31);
	assign wb_cu_int[0] = (exe_to_wb_wb[350-:7] == 7'd30) || (exe_to_wb_wb[350-:7] == 7'd31);
	assign pc_if = stage_if_id_d[291-:64];
	assign pc_id = (valid_id ? stage_id_rr_d[357-:64] : 64'b0000000000000000000000000000000000000000000000000000000000000000);
	assign pc_rr = (valid_rr ? stage_rr_exe_d[550-:64] : 64'b0000000000000000000000000000000000000000000000000000000000000000);
	assign pc_exe = (valid_exe ? stage_rr_exe_q[550-:64] : 64'b0000000000000000000000000000000000000000000000000000000000000000);
	assign pc_wb = (valid_wb ? exe_to_wb_wb[419-:64] : 64'b0000000000000000000000000000000000000000000000000000000000000000);
	assign valid_if = stage_if_id_d[195];
	assign valid_id = stage_id_rr_d[358];
	assign valid_rr = stage_rr_exe_d[551];
	assign valid_exe = stage_rr_exe_q[551];
	assign valid_wb = exe_to_wb_wb[420];
	assign debug_o[270-:40] = pc_if[39:0];
	assign debug_o[230-:40] = pc_id[39:0];
	assign debug_o[190-:40] = pc_rr[39:0];
	assign debug_o[150-:40] = pc_exe[39:0];
	assign debug_o[110-:40] = pc_wb[39:0];
	assign debug_o[70] = exe_to_wb_wb[420];
	assign debug_o[69-:5] = exe_to_wb_wb[279-:5];
	assign debug_o[64] = cu_rr_int[1];
	assign debug_o[63-:64] = stage_rr_exe_d[192-:64];
	assign pmu_flags_o[7] = resp_csr_cpu_i[259];
	assign pmu_flags_o[6] = exe_cu_int[1];
endmodule
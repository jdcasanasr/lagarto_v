module lagarto_core (
	rs1_addr_Ven_i,
	rs1_addr_i,
	rs1_data_o,
	inst_o,
	clk,
	rst,
	PC,
	data_int_0,
//	data_int_1,
//	data_int_2,
//	data_int_3,
	addr_int_0,
//	addr_int_1,
//	addr_int_2,
//	addr_int_3,
	enable_int_0,
//	enable_int_1,
//	enable_int_2,
//	enable_int_3,
//	data_float_0,
//	data_float_1,
//	data_float_2,
//	data_float_3,
//	addr_float_0,
//	addr_float_1,
//	addr_float_2,
//	addr_float_3,
//	enable_float_0,
//	enable_float_1,
//	enable_float_2,
//	enable_float_3,
	data_Dmem,
	addr_Dmem,
	enable_Dmem,
	clk_write,
	rst_n_write,
	writing_data,
	writing_inst,
	wr_enable,
	data_write,
	addr_write
);
//vector signal input/output
	input	wire			rs1_addr_Ven_i;
	input	wire	[5:0]	rs1_addr_i;
	output	wire	[63:0]	rs1_data_o;
	output	wire	[31:0]	inst_o;
//scalar signal input/output
	input clk;
	input rst;
	output wire [31:0] PC;
	output wire [63:0] data_int_0;
//	output wire [63:0] data_int_1;
//	output wire [63:0] data_int_2;
//	output wire [63:0] data_int_3;
	output wire [4:0] addr_int_0;
//	output wire [4:0] addr_int_1;
//	output wire [4:0] addr_int_2;
//	output wire [4:0] addr_int_3;
	output wire enable_int_0;
//	output wire enable_int_1;
//	output wire enable_int_2;
//	output wire enable_int_3;
//	output wire [63:0] data_float_0;
//	output wire [63:0] data_float_1;
//	output wire [63:0] data_float_2;
//	output wire [63:0] data_float_3;
//	output wire [4:0] addr_float_0;
//	output wire [4:0] addr_float_1;
//	output wire [4:0] addr_float_2;
//	output wire [4:0] addr_float_3;
//	output wire enable_float_0;
//	output wire enable_float_1;
//	output wire enable_float_2;
//	output wire enable_float_3;
	output wire [63:0] data_Dmem;
	output wire [63:0] addr_Dmem;
	output wire enable_Dmem;
	input clk_write;
	input rst_n_write;
	input writing_data;
	input writing_inst;
	input wr_enable;
	input [31:0] data_write;
	input [15:0] addr_write;
	wire [31:0] Data_MEM_out_Port;
	localparam drac_pkg_ADDR_SIZE = 40;
	wire [39:0] reset_addr_int;
	localparam riscv_pkg_INST_SIZE = 32;
	wire [33:0] resp_icache_cpu_int;
	wire [133:0] resp_dcache_cpu_int;
	wire [324:0] resp_csr_cpu_int;
	localparam riscv_pkg_XLEN = 64;
	wire [136:0] debug_int;
	wire [1:0] csr_priv_lvl_int;
	localparam drac_pkg_REGFILE_WIDTH = 5;
	wire [248:0] req_cpu_dcache_int;
	wire [43:0] req_cpu_icache_int;
	localparam drac_pkg_CSR_ADDR_SIZE = 12;
	localparam drac_pkg_CSR_CMD_SIZE = 3;
	wire [208:0] req_cpu_csr_int;
	wire [270:0] debug_o_int;
	wire [7:0] pmu_flags_int;
	localparam debugger_pkg_V_REGS = 32;
	localparam debugger_pkg_RF_IDX_BITS = 5;
	localparam debugger_pkg_ARCH_BITS = 64;
	wire [69:0] reg_file_wr_event_int;
	assign reset_addr_int = 1'sb0;
	assign resp_csr_cpu_int = 1'sb0;
	assign debug_int = 1'sb0;
	assign csr_priv_lvl_int = 2'b00;
	datapath lagarto_core(
		.rs1_addr_Ven_i		(rs1_addr_Ven_i	),
		.rs1_addr_i			(rs1_addr_i		),
		.rs1_data_o			(rs1_data_o		),
		.clk_i(clk),
		.rstn_i(rst),
		.reset_addr_i(reset_addr_int),
		.soft_rstn_i(1'b1),
		.resp_icache_cpu_i(resp_icache_cpu_int),
		.resp_dcache_cpu_i(resp_dcache_cpu_int),
		.resp_csr_cpu_i(resp_csr_cpu_int),
		.debug_i(debug_int),
		.csr_priv_lvl_i(csr_priv_lvl_int),
		.req_cpu_dcache_o(req_cpu_dcache_int),
		.req_cpu_icache_o(req_cpu_icache_int),
		.req_cpu_csr_o(req_cpu_csr_int),
		.debug_o(debug_o_int),
		.pmu_flags_o(pmu_flags_int),
		.reg_file_wr_event_o(reg_file_wr_event_int)
	);
	imem_interface imem_inst(
		.clk_extern_i(clk_write),
		.dbgr_we_i(wr_enable & writing_inst),
		.dbgr_addr_i(addr_write),
		.dbgr_data_i(data_write[31:0]),
		.req_fetch_icache_i(req_cpu_icache_int),
		.resp_icache_fetch_o(resp_icache_cpu_int)
	);
	
	assign	inst_o	=	resp_icache_cpu_int[32:1];
	
	localparam debugger_pkg_DCACHE_LINE_SIZE = 64;
	localparam debugger_pkg_DCACHE_LINE_BYTES = 8;
	localparam debugger_pkg_DCACHE_SIZE = 16384;
	localparam debugger_pkg_DCACHE_DEPTH = 2048;
	localparam debugger_pkg_DCACHE_IDX = 11;

	dmem_interface dmem_inst(
		.clk(clk_write),
//		.clk_en(clk),
//		.arst_n(rst_n_write),
		.req_cpu_dcache_i(req_cpu_dcache_int),
		.resp_dcache_cpu_o(resp_dcache_cpu_int)//,
//		.debugger_write_i(writing_data && wr_enable),
//		.debugger_data_i({32'b00000000000000000000000000000000, data_write}),
//		.debugger_addr_i(addr_write[10:0]),
//		.debugger_event_o(enable_Dmem),
//		.debugger_data_o(data_Dmem),
//		.debugger_addr_o(addr_Dmem[10:0])
	);	
	
//	dmem_interface dmem_inst(
//		.clk(clk_write),
//		.clk_en(clk),
//		.arst_n(rst_n_write),
//		.req_cpu_dcache_i(req_cpu_dcache_int),
//		.resp_dcache_cpu_o(resp_dcache_cpu_int),
//		.debugger_write_i(writing_data && wr_enable),
//		.debugger_data_i({32'b00000000000000000000000000000000, data_write}),
//		.debugger_addr_i(addr_write[10:0]),
//		.debugger_event_o(enable_Dmem),
//		.debugger_data_o(data_Dmem),
//		.debugger_addr_o(addr_Dmem[10:0])
//	);
	assign addr_Dmem[63:debugger_pkg_DCACHE_IDX] = {52 {1'b0}};
	assign PC = debug_o_int[102:71];
	assign data_int_0 = reg_file_wr_event_int[64:1];
//	assign data_int_1 = 1'sb0;
//	assign data_int_2 = 1'sb0;
//	assign data_int_3 = 1'sb0;
	assign addr_int_0 = reg_file_wr_event_int[69-:5];
//	assign addr_int_1 = 1'sb0;
//	assign addr_int_2 = 1'sb0;
//	assign addr_int_3 = 1'sb0;
	assign enable_int_0 = reg_file_wr_event_int[0];
//	assign enable_int_1 = 1'sb0;
//	assign enable_int_2 = 1'sb0;
//	assign enable_int_3 = 1'sb0;
//	assign data_float_0 = 1'sb0;
//	assign data_float_1 = 1'sb0;
//	assign data_float_2 = 1'sb0;
//	assign data_float_3 = 1'sb0;
//	assign addr_float_0 = 1'sb0;
//	assign addr_float_1 = 1'sb0;
//	assign addr_float_2 = 1'sb0;
//	assign addr_float_3 = 1'sb0;
//	assign enable_float_0 = 1'sb0;
//	assign enable_float_1 = 1'sb0;
//	assign enable_float_2 = 1'sb0;
//	assign enable_float_3 = 1'sb0;
endmodule

module	lagarto_core_tb	();
	//inputs
	reg				clk;
	reg				rst;
	reg				clk_write;
	reg				rst_n_write;
	reg				writing_data;
	reg				writing_inst;
	reg				wr_enable;
	reg	[31:0]	data_write;
	reg	[15:0]	addr_write;

	
	//outputs
	wire	[31:0]	PC;
	wire	[63:0]	data_int_0;
	wire	[4:0]		addr_int_0;
	wire				enable_int_0;
	wire	[63:0]	data_Dmem;
	wire	[63:0]	addr_Dmem;
	wire				enable_Dmem;
	
	initial
	begin
		clk				=	1'b1;
		rst				=	1'b0;
		clk_write		=	1'b1;
		rst_n_write		=	1'b0;
		writing_data	=	1'b0;
		writing_inst	=	1'b0;
		wr_enable		=	1'b0;
		data_write		=	32'b0;
		addr_write		=	16'b0;
	end

	lagarto_core		core_tb	(
		.clk					(clk				),
		.rst					(rst				),
		.clk_write			(clk_write		),
		.rst_n_write		(rst_n_write	),
		.writing_data		(writing_data	),
		.writing_inst		(writing_inst	),
		.wr_enable			(wr_enable		),
		.data_write			(data_write		),
		.addr_write			(addr_write		),
		.PC					(PC				),
		.data_int_0			(data_int_0		),
		.addr_int_0			(addr_int_0		),
		.enable_int_0		(enable_int_0	),
		.data_Dmem			(data_Dmem		),
		.addr_Dmem			(addr_Dmem		),
		.enable_Dmem		(enable_Dmem	)
	);						
	
	always
	begin
		#50
			clk			=	~clk;
			clk_write	=	~clk_write;
	end
	
	always
	begin
		#100
			rst			=	1'b1;
			rst_n_write	=	1'b1;
	end
endmodule 
module control_unit (
	rstn_i,
	clk_i,
	valid_fetch,
	id_cu_i,
	rr_cu_i,
	exe_cu_i,
	wb_cu_i,
	csr_cu_i,
	correct_branch_pred_i,
	debug_halt_i,
	debug_change_pc_i,
	debug_wr_valid_i,
	pipeline_ctrl_o,
	pipeline_flush_o,
	cu_if_o,
	invalidate_icache_o,
	invalidate_buffer_o,
	cu_rr_o
);
	input wire rstn_i;
	input wire clk_i;
	input wire valid_fetch;
	input wire [1:0] id_cu_i;
	input wire [0:0] rr_cu_i;
	input wire [4:0] exe_cu_i;
	localparam riscv_pkg_XLEN = 64;
	input wire [72:0] wb_cu_i;
	input wire [324:0] csr_cu_i;
	input wire correct_branch_pred_i;
	input wire debug_halt_i;
	input wire debug_change_pc_i;
	input wire debug_wr_valid_i;
	output reg [6:0] pipeline_ctrl_o;
	output reg [4:0] pipeline_flush_o;
	output reg [1:0] cu_if_o;
	output wire invalidate_icache_o;
	output wire invalidate_buffer_o;
	output reg [1:0] cu_rr_o;
	reg jump_enable_int;
	reg exception_enable_q;
	wire exception_enable_d;
	always @(*) jump_enable_int = (exe_cu_i[4] && ~correct_branch_pred_i) || id_cu_i[1];
	assign exception_enable_d = (exception_enable_q ? 1'b0 : (((wb_cu_i[8] && wb_cu_i[3]) || csr_cu_i[193]) || csr_cu_i[258]) || (wb_cu_i[8] && wb_cu_i[2]));
	
	always @(*)
		if (((wb_cu_i[8] && !wb_cu_i[3]) && !csr_cu_i[258]) && wb_cu_i[5])
			cu_rr_o[1] = 1'b1;
		else
			cu_rr_o[1] = 1'b0;
	always @(*)
		if (debug_wr_valid_i && debug_halt_i)
			cu_rr_o[0] = 1'b1;
		else
			cu_rr_o[0] = 1'b0;
	always @(*)
		if (debug_change_pc_i && debug_halt_i)
			cu_if_o[1-:2] = 2'b11;
		else if (jump_enable_int || exception_enable_q)
			cu_if_o[1-:2] = 2'b10;
		else if (((((((!valid_fetch || pipeline_ctrl_o[6]) || id_cu_i[0]) || rr_cu_i[0]) || exe_cu_i[0]) || wb_cu_i[4]) || (wb_cu_i[8] && wb_cu_i[1])) || debug_halt_i)
			cu_if_o[1-:2] = 2'b01;
		else
			cu_if_o[1-:2] = 2'b00;
	always @(*)
		if (exception_enable_q)
			pipeline_ctrl_o[1-:2] = 2'b01;
		else if (exe_cu_i[4] && ~correct_branch_pred_i)
			pipeline_ctrl_o[1-:2] = 2'b00;
		else if (debug_change_pc_i && debug_halt_i)
			pipeline_ctrl_o[1-:2] = 2'b11;
		else
			pipeline_ctrl_o[1-:2] = 2'b10;
	assign invalidate_icache_o = wb_cu_i[8] && wb_cu_i[0];
	assign invalidate_buffer_o = wb_cu_i[8] && ((wb_cu_i[0] | exception_enable_q) | (wb_cu_i[4] & !wb_cu_i[1]));
	always @(*) begin
		pipeline_flush_o[4] = 1'b0;
		pipeline_flush_o[3] = 1'b0;
		pipeline_flush_o[2] = 1'b0;
		pipeline_flush_o[1] = 1'b0;
		pipeline_flush_o[0] = 1'b0;
		if ((wb_cu_i[3] & wb_cu_i[8]) || exception_enable_q) begin
			pipeline_flush_o[4] = 1'b1;
			pipeline_flush_o[3] = 1'b1;
			pipeline_flush_o[2] = 1'b1;
			pipeline_flush_o[1] = 1'b1;
			pipeline_flush_o[0] = 1'b0;
		end
		else if (exe_cu_i[4] & ~correct_branch_pred_i) begin
			if (exe_cu_i[1]) begin
				pipeline_flush_o[4] = 1'b1;
				pipeline_flush_o[3] = 1'b1;
				pipeline_flush_o[2] = 1'b0;
				pipeline_flush_o[1] = 1'b0;
				pipeline_flush_o[0] = 1'b0;
			end
			else begin
				pipeline_flush_o[4] = 1'b1;
				pipeline_flush_o[3] = 1'b1;
				pipeline_flush_o[2] = 1'b1;
				pipeline_flush_o[1] = 1'b0;
				pipeline_flush_o[0] = 1'b0;
			end
		end
		else if ((((id_cu_i[0] | rr_cu_i[0]) | exe_cu_i[0]) | wb_cu_i[4]) && !(csr_cu_i[259] || exe_cu_i[1])) begin
			pipeline_flush_o[4] = 1'b1;
			pipeline_flush_o[3] = 1'b0;
			pipeline_flush_o[2] = 1'b0;
			pipeline_flush_o[1] = 1'b0;
			pipeline_flush_o[0] = 1'b0;
		end
		else if ((id_cu_i[1] || (wb_cu_i[8] && wb_cu_i[1])) && !(csr_cu_i[259] || exe_cu_i[1])) begin
			pipeline_flush_o[4] = 1'b1;
			pipeline_flush_o[3] = 1'b0;
			pipeline_flush_o[2] = 1'b0;
			pipeline_flush_o[1] = 1'b0;
			pipeline_flush_o[0] = 1'b0;
		end
	end
	always @(*) begin
		pipeline_ctrl_o[6] = 1'b0;
		pipeline_ctrl_o[5] = 1'b0;
		pipeline_ctrl_o[4] = 1'b0;
		pipeline_ctrl_o[3] = 1'b0;
		pipeline_ctrl_o[2] = 1'b0;
		if (csr_cu_i[259] || exe_cu_i[1]) begin
			pipeline_ctrl_o[6] = 1'b1;
			pipeline_ctrl_o[5] = 1'b1;
			pipeline_ctrl_o[4] = 1'b1;
			pipeline_ctrl_o[3] = 1'b1;
			pipeline_ctrl_o[2] = 1'b0;
		end
		else if (wb_cu_i[8] && wb_cu_i[4]) begin
			pipeline_ctrl_o[6] = 1'b1;
			pipeline_ctrl_o[5] = 1'b0;
			pipeline_ctrl_o[4] = 1'b0;
			pipeline_ctrl_o[3] = 1'b0;
			pipeline_ctrl_o[2] = 1'b0;
		end
	end
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i)
			exception_enable_q <= 1'b0;
		else
			exception_enable_q <= exception_enable_d;
endmodule
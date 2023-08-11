module dcache_interface (
	clk_i,
	rstn_i,
	req_cpu_dcache_i,
	dmem_resp_replay_i,
	dmem_resp_data_i,
	dmem_req_ready_i,
	dmem_resp_valid_i,
	dmem_resp_nack_i,
	dmem_xcpt_ma_st_i,
	dmem_xcpt_ma_ld_i,
	dmem_xcpt_pf_st_i,
	dmem_xcpt_pf_ld_i,
	dmem_req_valid_o,
	dmem_req_cmd_o,
	dmem_req_addr_o,
	dmem_op_type_o,
	dmem_req_data_o,
	dmem_req_tag_o,
	dmem_req_invalidate_lr_o,
	dmem_req_kill_o,
	resp_dcache_cpu_o,
	dmem_is_store_o,
	dmem_is_load_o
);
	input wire clk_i;
	input wire rstn_i;
	localparam drac_pkg_ADDR_SIZE = 40;
	localparam drac_pkg_REGFILE_WIDTH = 5;
	input wire [248:0] req_cpu_dcache_i;
	input wire dmem_resp_replay_i;
	input wire [63:0] dmem_resp_data_i;
	input wire dmem_req_ready_i;
	input wire dmem_resp_valid_i;
	input wire dmem_resp_nack_i;
	input wire dmem_xcpt_ma_st_i;
	input wire dmem_xcpt_ma_ld_i;
	input wire dmem_xcpt_pf_st_i;
	input wire dmem_xcpt_pf_ld_i;
	output reg dmem_req_valid_o;
	output reg [4:0] dmem_req_cmd_o;
	output wire [39:0] dmem_req_addr_o;
	output wire [3:0] dmem_op_type_o;
	output wire [63:0] dmem_req_data_o;
	output wire [7:0] dmem_req_tag_o;
	output wire dmem_req_invalidate_lr_o;
	output wire dmem_req_kill_o;
	output reg [133:0] resp_dcache_cpu_o;
	output wire dmem_is_store_o;
	output wire dmem_is_load_o;
	wire mem_xcpt;
	wire io_address_space;
	wire kill_io_resp;
	wire kill_mem_ope;
	reg [1:0] state;
	reg [1:0] next_state;
	wire [63:0] dmem_req_addr_64;
	reg [1:0] type_of_op;
	reg dmem_xcpt_ma_st_reg;
	reg dmem_xcpt_ma_ld_reg;
	reg dmem_xcpt_pf_st_reg;
	reg dmem_xcpt_pf_ld_reg;
	parameter ResetState = 2'b00;
	parameter Idle = 2'b01;
	parameter MakeRequest = 2'b10;
	parameter WaitResponse = 2'b11;
	parameter MEM_NOP = 2'b00;
	parameter MEM_LOAD = 2'b01;
	parameter MEM_STORE = 2'b10;
	parameter MEM_AMO = 2'b11;
	assign mem_xcpt = ((dmem_xcpt_ma_st_i | dmem_xcpt_ma_ld_i) | dmem_xcpt_pf_st_i) | dmem_xcpt_pf_ld_i;
	assign io_address_space = (dmem_req_addr_o >= req_cpu_dcache_i[39-:drac_pkg_ADDR_SIZE]) & (dmem_req_addr_o < 40'h0080000000);
	assign kill_io_resp = io_address_space & (type_of_op == MEM_STORE);
	assign kill_mem_ope = mem_xcpt | req_cpu_dcache_i[247];
	always @(posedge clk_i or negedge rstn_i)
		if (~rstn_i) begin
			state <= ResetState;
			dmem_xcpt_ma_st_reg <= 1'b0;
			dmem_xcpt_ma_ld_reg <= 1'b0;
			dmem_xcpt_pf_st_reg <= 1'b0;
			dmem_xcpt_pf_ld_reg <= 1'b0;
		end
		else begin
			state <= next_state;
			dmem_xcpt_ma_st_reg <= dmem_xcpt_ma_st_i;
			dmem_xcpt_ma_ld_reg <= dmem_xcpt_ma_ld_i;
			dmem_xcpt_pf_st_reg <= dmem_xcpt_pf_st_i;
			dmem_xcpt_pf_ld_reg <= dmem_xcpt_pf_ld_i;
		end
	always @(*)
		case (state)
			ResetState: begin
				dmem_req_valid_o = 1'b0;
				resp_dcache_cpu_o[68] = 1'b0;
				next_state = Idle;
			end
			Idle: begin
				dmem_req_valid_o = (!req_cpu_dcache_i[247] & req_cpu_dcache_i[248]) & dmem_req_ready_i;
				resp_dcache_cpu_o[68] = req_cpu_dcache_i[248];
				next_state = (dmem_req_valid_o ? MakeRequest : (req_cpu_dcache_i[247] ? ResetState : Idle));
			end
			MakeRequest: begin
				dmem_req_valid_o = 1'b0;
				resp_dcache_cpu_o[68] = 1'b1;
				next_state = (!kill_mem_ope ? WaitResponse : ResetState);
			end
			WaitResponse:
				if (dmem_resp_valid_i) begin
					dmem_req_valid_o = 1'b0;
					next_state = Idle;
					resp_dcache_cpu_o[68] = 1'b0;
				end
				else if (dmem_resp_nack_i) begin
					dmem_req_valid_o = 1'b0;
					next_state = Idle;
					resp_dcache_cpu_o[68] = 1'b1;
				end
				else begin
					dmem_req_valid_o = 1'b0;
					next_state = ((req_cpu_dcache_i[247] | mem_xcpt) | kill_io_resp ? ResetState : WaitResponse);
					resp_dcache_cpu_o[68] = 1'b1;
				end
			default: next_state = ResetState;
		endcase
	always @(*) begin
		type_of_op = MEM_NOP;
		case (req_cpu_dcache_i[118-:7])
			7'd53, 7'd54: begin
				dmem_req_cmd_o = 5'b00110;
				type_of_op = MEM_AMO;
			end
			7'd55, 7'd56: begin
				dmem_req_cmd_o = 5'b00111;
				type_of_op = MEM_AMO;
			end
			7'd57, 7'd66: begin
				dmem_req_cmd_o = 5'b00100;
				type_of_op = MEM_AMO;
			end
			7'd58, 7'd67: begin
				dmem_req_cmd_o = 5'b01000;
				type_of_op = MEM_AMO;
			end
			7'd61, 7'd70: begin
				dmem_req_cmd_o = 5'b01001;
				type_of_op = MEM_AMO;
			end
			7'd59, 7'd68: begin
				dmem_req_cmd_o = 5'b01011;
				type_of_op = MEM_AMO;
			end
			7'd60, 7'd69: begin
				dmem_req_cmd_o = 5'b01010;
				type_of_op = MEM_AMO;
			end
			7'd64, 7'd73: begin
				dmem_req_cmd_o = 5'b01100;
				type_of_op = MEM_AMO;
			end
			7'd62, 7'd71: begin
				dmem_req_cmd_o = 5'b01101;
				type_of_op = MEM_AMO;
			end
			7'd65, 7'd74: begin
				dmem_req_cmd_o = 5'b01110;
				type_of_op = MEM_AMO;
			end
			7'd63, 7'd72: begin
				dmem_req_cmd_o = 5'b01111;
				type_of_op = MEM_AMO;
			end
			7'd42, 7'd44, 7'd45, 7'd47, 7'd48, 7'd50, 7'd52: begin
				dmem_req_cmd_o = 5'b00000;
				type_of_op = MEM_LOAD;
			end
			7'd43, 7'd46, 7'd49, 7'd51: begin
				dmem_req_cmd_o = 5'b00001;
				type_of_op = MEM_STORE;
			end
			default: dmem_req_cmd_o = 5'b00000;
		endcase
	end
	assign dmem_req_addr_64 = (type_of_op == MEM_AMO ? req_cpu_dcache_i[246-:64] : req_cpu_dcache_i[246-:64] + req_cpu_dcache_i[103-:64]);
	assign dmem_req_addr_o = dmem_req_addr_64[39:0];
	assign dmem_op_type_o = {1'b0, req_cpu_dcache_i[111-:3]};
	assign dmem_req_data_o = req_cpu_dcache_i[182-:64];
	assign dmem_req_tag_o = {2'b00, req_cpu_dcache_i[108-:5], 1'b0};
	assign dmem_req_invalidate_lr_o = req_cpu_dcache_i[247];
	assign dmem_req_kill_o = mem_xcpt | req_cpu_dcache_i[247];
	wire [1:1] sv2v_tmp_F7CE3;
	assign sv2v_tmp_F7CE3 = dmem_resp_valid_i & (type_of_op != MEM_STORE);
	always @(*) resp_dcache_cpu_o[133] = sv2v_tmp_F7CE3;
	wire [64:1] sv2v_tmp_37E64;
	assign sv2v_tmp_37E64 = dmem_resp_data_i;
	always @(*) resp_dcache_cpu_o[132-:64] = sv2v_tmp_37E64;
	wire [1:1] sv2v_tmp_E1686;
	assign sv2v_tmp_E1686 = dmem_xcpt_ma_st_reg;
	always @(*) resp_dcache_cpu_o[67] = sv2v_tmp_E1686;
	wire [1:1] sv2v_tmp_CF648;
	assign sv2v_tmp_CF648 = dmem_xcpt_ma_ld_reg;
	always @(*) resp_dcache_cpu_o[66] = sv2v_tmp_CF648;
	wire [1:1] sv2v_tmp_AB3E4;
	assign sv2v_tmp_AB3E4 = dmem_xcpt_pf_st_reg;
	always @(*) resp_dcache_cpu_o[65] = sv2v_tmp_AB3E4;
	wire [1:1] sv2v_tmp_10E1E;
	assign sv2v_tmp_10E1E = dmem_xcpt_pf_ld_reg;
	always @(*) resp_dcache_cpu_o[64] = sv2v_tmp_10E1E;
	wire [64:1] sv2v_tmp_C40D6;
	assign sv2v_tmp_C40D6 = dmem_req_addr_64;
	always @(*) resp_dcache_cpu_o[63-:64] = sv2v_tmp_C40D6;
	assign dmem_is_store_o = (type_of_op == MEM_STORE) && dmem_req_valid_o;
	assign dmem_is_load_o = (type_of_op == MEM_LOAD) && dmem_req_valid_o;
endmodule
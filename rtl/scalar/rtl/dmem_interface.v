module dmem_interface	(
	input					clk,
	input		[248:0]	req_cpu_dcache_i,
	output	[133:0]	resp_dcache_cpu_o
);
	//Definicion de la memoria
	
	wire 		[63:0]	mem_line;
	wire		[10:0]	mem_address;
	wire		[63:0]	cpu_req_store_data;
	wire					cpu_req_is_store;
	wire		[10:0]	cpu_req_address;

//	function automatic [10:0] sv2v_cast_5F058;
//		input reg [10:0] inp;
//		sv2v_cast_5F058 = inp;
//	endfunction
	
//	assign cpu_req_address = sv2v_cast_5F058(req_cpu_dcache_i[246-:64] + req_cpu_dcache_i[103-:64]);
	assign cpu_req_address = req_cpu_dcache_i[246-:64] + req_cpu_dcache_i[103-:64];
	assign cpu_req_is_store = |{req_cpu_dcache_i[118-:7] == 7'd51, req_cpu_dcache_i[118-:7] == 7'd49, req_cpu_dcache_i[118-:7] == 7'd46, req_cpu_dcache_i[118-:7] == 7'd43};
	
	assign mem_address	=	{2'b0, cpu_req_address[10:2]};
	
//	function automatic [63:0] sv2v_cast_64;
//		input reg [63:0] inp;
//		sv2v_cast_64 = inp;
//	endfunction
	
//	assign cpu_req_store_data = sv2v_cast_64(req_cpu_dcache_i[182-:64]);
	assign cpu_req_store_data = req_cpu_dcache_i[182-:64];
	
	MemData	MemoryData(
		.clk			(clk),
		.address_i	(mem_address),
		.data_i		(cpu_req_store_data),
		.we_i			(cpu_req_is_store),
		.data_o		(mem_line)
	);
	
	assign resp_dcache_cpu_o[133] = 1'b1;
	assign resp_dcache_cpu_o[132-:64] = mem_line;
	assign resp_dcache_cpu_o[68] = 1'b0;
	assign resp_dcache_cpu_o[67] = 1'b0;
	assign resp_dcache_cpu_o[66] = 1'b0;
	assign resp_dcache_cpu_o[65] = 1'b0;
	assign resp_dcache_cpu_o[64] = 1'b0;
//	assign resp_dcache_cpu_o[63-:64] = sv2v_cast_64(cpu_req_address);	
	assign resp_dcache_cpu_o[63-:64] = cpu_req_address;	
	
endmodule

module	MemData	(
	input						clk,
	input			[10:0]	address_i,
	input			[63:0]	data_i,
	input						we_i,
	output wire	[63:0]	data_o
);
	reg			[63:0]	mem [2047:0];
	
	reg			[10:0]	address_reg;
//	assign					address_reg	=	address_i[6:0];
	
	always @(posedge clk)
	begin
		if (we_i)
			mem[address_i]	<=	data_i;
		address_reg		<=	address_i;
	end

	assign		data_o	=	mem[address_reg];

endmodule




/*
module dmem_interface (
	clk,
	clk_en,
	arst_n,
	req_cpu_dcache_i,
	resp_dcache_cpu_o,
	debugger_write_i,
	debugger_data_i,
	debugger_addr_i,
	debugger_event_o,
	debugger_data_o,
	debugger_addr_o
);

	input wire clk;
	input wire clk_en;
	input wire arst_n;
	localparam drac_pkg_ADDR_SIZE = 40;
	localparam drac_pkg_REGFILE_WIDTH = 5;
	input wire [248:0] req_cpu_dcache_i;
	output wire [133:0] resp_dcache_cpu_o;
	input wire debugger_write_i;
	input wire [63:0] debugger_data_i;
	localparam debugger_pkg_DCACHE_LINE_SIZE = 64;
	localparam debugger_pkg_DCACHE_LINE_BYTES = 8;
	localparam debugger_pkg_DCACHE_SIZE = 16384;
	localparam debugger_pkg_DCACHE_DEPTH = 2048;
	localparam debugger_pkg_DCACHE_IDX = 11;
	input wire [10:0] debugger_addr_i;
	output wire debugger_event_o;
	output wire [63:0] debugger_data_o;
	output wire [10:0] debugger_addr_o;
	reg [63:0] mem [2047:0];
	wire [10:0] debugger_write_address;
	wire [10:0] mem_address;
	wire [10:0] cpu_req_address;
	wire [63:0] cpu_req_store_data;
	reg [63:0] cpu_resp_load_data;
	localparam debugger_pkg_DCACHE_LINE_OFFSET = 3;
	wire [2:0] cpu_req_line_offset;
	reg [63:0] cpu_req_line_mask;
	reg [63:0] mem_line;
	reg [63:0] insert_store_data;
	reg [63:0] read_data;
	wire cpu_req_is_store;
	reg [1:0] fsm_state;
	
	function automatic [10:0] sv2v_cast_5F058;
		input reg [10:0] inp;
		sv2v_cast_5F058 = inp;
	endfunction
	
	assign cpu_req_address = sv2v_cast_5F058(req_cpu_dcache_i[246-:64] + req_cpu_dcache_i[103-:64]);
	assign cpu_req_is_store = |{req_cpu_dcache_i[118-:7] == 7'd51, req_cpu_dcache_i[118-:7] == 7'd49, req_cpu_dcache_i[118-:7] == 7'd46, req_cpu_dcache_i[118-:7] == 7'd43};
	assign debugger_write_address = sv2v_cast_5F058({debugger_addr_i, {debugger_pkg_DCACHE_LINE_OFFSET {1'b0}}});
	assign mem_address = {cpu_req_address[10:debugger_pkg_DCACHE_LINE_OFFSET], {debugger_pkg_DCACHE_LINE_OFFSET {1'b0}}};
	
	function automatic [63:0] sv2v_cast_242AB;
		input reg [63:0] inp;
		sv2v_cast_242AB = inp;
	endfunction
	
	always @(*)
		case (req_cpu_dcache_i[118-:7])
			7'd50, 7'd52, 7'd51: cpu_req_line_mask = sv2v_cast_242AB({{56 {1'b0}}, {8 {1'b1}}} << {cpu_req_line_offset, 3'b000});
			7'd47, 7'd48, 7'd49: cpu_req_line_mask = sv2v_cast_242AB({{48 {1'b0}}, {16 {1'b1}}} << {cpu_req_line_offset, 3'b000});
			7'd44, 7'd45, 7'd46: cpu_req_line_mask = sv2v_cast_242AB({{32 {1'b0}}, {32 {1'b1}}} << {cpu_req_line_offset, 3'b000});
			7'd42, 7'd43: cpu_req_line_mask = {64 {1'b1}};
			default: cpu_req_line_mask = {64 {1'b1}};
		endcase
	assign cpu_req_line_offset = cpu_req_address[2:0];
	
	function automatic [63:0] sv2v_cast_64;
		input reg [63:0] inp;
		sv2v_cast_64 = inp;
	endfunction
	
//	assign cpu_req_store_data = sv2v_cast_64(req_cpu_dcache_i[182-:64] << {cpu_req_line_offset, 3'b000});
	assign cpu_req_store_data = sv2v_cast_64(req_cpu_dcache_i[182-:64]);
	
	always @(*) begin
		cpu_resp_load_data = sv2v_cast_64((mem_line & cpu_req_line_mask) >> {cpu_req_line_offset, 3'b000});
		case (req_cpu_dcache_i[118-:7])
			7'd50: cpu_resp_load_data = {{56 {cpu_resp_load_data[7]}}, cpu_resp_load_data[7:0]};
			7'd47: cpu_resp_load_data = {{48 {cpu_resp_load_data[15]}}, cpu_resp_load_data[15:0]};
			7'd44: cpu_resp_load_data = {{32 {cpu_resp_load_data[31]}}, cpu_resp_load_data[31:0]};
			default: cpu_resp_load_data = cpu_resp_load_data;
		endcase
	end
	
	always @(*) begin : sv2v_autoblock_1
		reg signed [31:0] i;
		for (i = 0; i < debugger_pkg_DCACHE_LINE_SIZE; i = i + 1)
			insert_store_data[i] = (cpu_req_line_mask[i] ? cpu_req_store_data[i] : mem_line[i]);
	end
	
/////////////////////////////////////////////	
	//Aqui se realizan las lecturas
//	always @(posedge clk)
//		mem_line <= mem[mem_address];	
		
	wire	[10:0]	new_mem_address;
	assign			new_mem_address	= {2'b0,cpu_req_address[10:2]};
	//Aqui se realizan las lecturas
	always	@(*)
	begin
		mem_line	=	mem[new_mem_address];
	end
	//assign	mem_line = mem[new_mem_address];
/////////////////////////////////////////////
	
//	always @(posedge clk or negedge arst_n)
//		if (~arst_n) begin
//			read_data <= sv2v_cast_242AB(0);
//			fsm_state <= 2'd0;
//		end
//		else
//			case (fsm_state)
//				2'd0:
//					if (debugger_write_i)
//						mem[debugger_write_address] <= debugger_data_i;
//					else if (clk_en & req_cpu_dcache_i[248])
//						case (cpu_req_is_store)
//							1'b0: fsm_state <= 2'd2;
//							1'b1: fsm_state <= 2'd3;
//						endcase
//				2'd3: begin
//					mem[mem_address] <= insert_store_data;
//					fsm_state <= 2'd0;
//				end
//				2'd2: begin
//					read_data <= cpu_resp_load_data;
//					fsm_state <= 2'd0;
//				end
//				default: fsm_state <= 2'd0;
//			endcase

//Aqui se realizan las escrituras
	always @(posedge	clk)
	begin
		if (cpu_req_is_store)
			mem[new_mem_address]	<=	cpu_req_store_data;
	end
///////////////////////////////////////////////////////////
	assign resp_dcache_cpu_o[133] = 1'b1;
//	assign resp_dcache_cpu_o[132-:64] = read_data;
	assign resp_dcache_cpu_o[132-:64] = mem_line;
	assign resp_dcache_cpu_o[68] = 1'b0;
	assign resp_dcache_cpu_o[67] = 1'b0;
	assign resp_dcache_cpu_o[66] = 1'b0;
	assign resp_dcache_cpu_o[65] = 1'b0;
	assign resp_dcache_cpu_o[64] = 1'b0;
	assign resp_dcache_cpu_o[63-:64] = sv2v_cast_64(cpu_req_address);
	assign debugger_event_o = req_cpu_dcache_i[248] & cpu_req_is_store;
	assign debugger_data_o = insert_store_data;
	assign debugger_addr_o = cpu_req_address;

endmodule
*/ 

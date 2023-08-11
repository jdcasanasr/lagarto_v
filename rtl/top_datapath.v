module	top_datapath	(
	input						clk,
	input						rst,
	input						clk_data,
	input						rst_data,
	input						inst_we_i,
	input						data_we_i,
	input			[15:0]		inst_addr_i,
	input			[31:0]		instruction_i,
	input			[2:0]		vsew_i,
	output 	wire 	[127:0]		output_data,
	output 	wire 	[127:0]		vs1_output_data,
	output 	wire 	[127:0]		vs2_output_data
);
	wire	[63:0]	x_rs1_data_o;
	wire	[5:0]	x_rs1_addr_i;
	wire			x_rs1_addr_Ven_i;
	wire	[31:0]	x_inst_o;

lagarto_core scalar_lagarto(
	.rs1_addr_Ven_i		(1'b0	),
	.rs1_addr_i			(x_rs1_addr_i		),
	.rs1_data_o			(x_rs1_data_o		),
	.inst_o				(x_inst_o),	
	.clk				(clk),
	.rst				(rst),
	.PC					(),	//PC on write back stage
	.data_int_0			(),	//data writen on register file	(64bits)	*ouput*
	.addr_int_0			(),	//address (5bits)							*ouput*
	.enable_int_0		(),	//register file write enabler				*ouput*
	.data_Dmem			(),	//disabled
	.addr_Dmem			(),	//disabled
	.enable_Dmem		(),	//disabled
	.clk_write			(clk_data),	//for data & instruction memory clock
	.rst_n_write		(rst_data),	//for data & instruction memory clock
	.writing_data		(1'b0 ),	//disabled
	.writing_inst		(inst_we_i),	//instruction memory enabler
	.wr_enable			(data_we_i),	//data & instruction memory enabler
	.data_write			(instruction_i),	//data input for instriction memory	(32bits)
	.addr_write			(inst_addr_i)	//address input for instruction memory (32bits)
);

vector_datapath	vector_lagarto(
	// Scalar-Vector Interface
	.rs1_data_i			(x_rs1_data_o),
	.rs1_address_o		(x_rs1_addr_i),
	.rs1_Ven_o			(x_rs1_addr_Ven_i),
	
	// Datapath Control Signals
	.clk_i				(clk),
	.rstn_i				(rst),
	.flush_i			(1'b0),
	.load_i				(1'b1),
	
	// Input Ports
	.instruction_i		(x_inst_o),
	.vsew_i				(vsew_i),
	
	// Output Ports (Testing Only)
	.output_data		(output_data	),
	.vs1_output_data	(vs1_output_data),
	.vs2_output_data	(vs2_output_data),
	.vd_output_data		()
);
endmodule

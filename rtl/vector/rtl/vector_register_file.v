`include "../../../includes/riscv_vector.vh"

module vector_register_file
#(
	parameter VRF_WIDTH 			= 128,
	parameter VRF_DEPTH 			= 32,
	parameter VRF_ADDRESS_WIDTH 	= $clog2(VRF_DEPTH)
)
(
	// From Lagarto-Hun
	input 	wire 									clk_i,
	
	// From Vector Decode Stage
	input 	wire	[VRF_ADDRESS_WIDTH - 1:0] 		vs1_read_address_i,
	input 	wire	[VRF_ADDRESS_WIDTH - 1:0] 		vs2_read_address_i,
	input 	wire	[VRF_ADDRESS_WIDTH - 1:0] 		vd_read_address_i,
	
	// From Vector Write-Back Stage
	input 	wire 	[VRF_ADDRESS_WIDTH - 1:0]		vd_write_address_i,
	input 	wire 	[VRF_WIDTH - 1:0]				vd_write_data_i,
	
	// From Vector Decode Stage (Let In Only the Vector Portion)
	input 	wire	[`REGISTER_VECTOR_WIDTH - 1:0] 	register_vector_i,
	
	output 	reg 	[VRF_WIDTH - 1:0] 				vmask_read_data_o,
	output 	reg 	[VRF_WIDTH - 1:0] 				vs1_read_data_o,
	output 	reg 	[VRF_WIDTH - 1:0] 				vs2_read_data_o, 
	output 	reg 	[VRF_WIDTH - 1:0] 				vd_read_data_o
);

	// As of v1.0, The Vector Mask is Always Stored in v0
	localparam VMASK_ADDRESS = {VRF_ADDRESS_WIDTH{1'b0}};

	// Declare a VRF_WIDTH by VRF_DEPTH-bits Array
	//(* ramstyle = "M4K" *) reg [VRF_WIDTH - 1:0] vrf [VRF_DEPTH - 1:0];
	reg [VRF_WIDTH - 1:0] vrf [VRF_DEPTH - 1:0];
	
	// Initialize vrf Array (Testing Only)
	initial
		$readmemh("vrf.hex", vrf);
	
	// Deal with VRF Read Asynchronously
	always @ (*)
		begin
			vmask_read_data_o 	<= (register_vector_i[`register_vector_vmask] 	? vrf[VMASK_ADDRESS] 		: {VRF_WIDTH{1'b0}});
			vs1_read_data_o 	<= (register_vector_i[`register_vector_vs1] 	? vrf[vs1_read_address_i] 	: {VRF_WIDTH{1'b0}});
			vs2_read_data_o 	<= (register_vector_i[`register_vector_vs2] 	? vrf[vs2_read_address_i] 	: {VRF_WIDTH{1'b0}});
			vd_read_data_o 		<= (register_vector_i[`register_vector_vd_read] ? vrf[vd_read_address_i] 	: {VRF_WIDTH{1'b0}});
		end
	
	// Deal with VRF Writes Synchronously
	always @ (posedge clk_i)
		if (register_vector_i[`register_vector_vd_write])
			vrf[vd_write_address_i] <= vd_write_data_i;
	
endmodule
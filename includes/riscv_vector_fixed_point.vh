// Reference: https://github.com/jdcasanasr/lagarto_v/tree/main/doc

/*	Resource Vectors
		System Vector
			BIT 5 	-> 	Cache Sync Atomic Operation (AMO)
			BIT 4 	-> 	System Operation (SYS)
			BIT 3 	-> 	Halt Operation (HALT)
			BIT 2 	-> 	Memory Sync Fence Operation (FENCE)
			BIT 1 	-> 	Memory Load Operation (L)
			BIT 0 	-> 	Memory Store Operation (S)
			
		Resource Vector
			BIT 21 	-> 	Vector Conversion Unit (VFCONF)
			BIT 20 	-> 	Vector Floating-Point Classification Unit (VFCLASS)
			BIT 19 	-> 	Vector Floating-Point Comparison Unit (VFCMP)
			BIT 18	-> 	Vector Floating Point Square-Root Unit (VFSQRT)
			BIT 17 	-> 	Vector Floating-Point Division Unit (VFDIV)
			BIT 16 	-> 	Vector Floating-Point Multiplication Unit (VFMUL)
			BIT 15 	-> 	Vector Floating-Point Addition Unit (VFADD)
			BIT 14 	-> 	Vector Merge Unit (VMERGE)
			BIT 13 	-> 	Vector Division Unit (VDIV)
			BIT 12 	-> 	Vector Multiplication Unit (VMUL)
			BIT 11 	-> 	Vector Comparison Unit (VCMP)
			BIT 10 	-> 	Vector Shift Unit (VSHFT)
			BIT 9 	-> 	Vector Logic Unit (VLOGIC)
			BIT 8	-> 	Vector Sign/Zero Extension Unit (VSZEXT)
			BIT 7 	-> 	Vector Add Unit (VADD)
			BIT 6 	-> 	Scalar Sign/Zero-Extension Unit (IMM)
			BIT 5 	-> 	Branch Unit (BR)
			BIT 4 	-> 	Scalar Set-On-Less-Than Unit (SLT)
			BIT 3	-> 	Scalar Shift Unit (SHFT)
			BIT 2 	-> 	Scalar Logic Unit (LOGIC)
			BIT 1 	-> 	Scalar Multiplication Unit (MUL)
			BIT 0 	-> 	Scalar Addition Unit (ADD)
			
		Register Vector
			BIT 6 	-> 	Vector v0 Register is Needed to Perform the Operation (VMASK)
			BIT 5 	-> 	Vector vs1 Register Field is Present in the Instruction Format (VS1)
			BIT 4 	-> 	Vector vs2 Register Field is Present in the Instruction Format (VS2)
			BIT 3	-> 	Vector vd Register Field is Present in the Instruction Format (VD)
			BIT 2 	-> 	Scalar rs1 Register Field is Present in the Instruction Format (RS1)
			BIT 1 	-> 	Scalar rs2 Register Field is Present in the Instruction Format (RS2)
			BIT 0 	-> 	Scalar rd Register Field is Present in the Instruction Format (RD)
			
		Operation Vector
			BIT 28 	-> 	Vector Instruction Returns the High Part of the Operation (VHL)
			BIT 27	-> 	Vector Instruction Field vs2 is Needed for Decoding (VS2)
			BIT 26	-> 	Vector Instruction Field vs1 is Needed for Decoding (VS1)
			BIT 25 	-> 	Vector Instruction Field funct6 is Needed for Decoding (F6)
			BIT 24	-> 	Vector Instruction Field vm is Needed for Decoding (VM)
			BIT 23	-> 	Vector Operand vs2's Elements are Signed (VSB)
			BIT 22	-> 	Vector Operand vs1's Elements are Signed (VSA)
			BIT 21 	-> 	Vector Memory Operation (VMEM)
			BIT 20 	-> 	Vector Fixed-Point Operation (VFXP)
			BIT 19 	-> 	Vector Floating-Point Operation (VFP)
			BIT 18	-> 	Vector Integer Operation (VINT)
			BIT 17 	-> 	Vector Operation (VEC)
			BIT 16 	-> 	Floating-Point Operation (FP)
			BIT 15 	-> 	Exception-Handling Operation (EH)
			BIT 14 	-> 	Scalar Memory Operation (MEM)
			BIT 13 	-> 	Scalar Integer Operation (INT)
			BIT 12 	-> 	opcode/funct7 is Needed for Decoding (OP/F7)
			BIT 11 	-> 	f3 is Needed for Decoding (F3)
			BIT 10 	-> 	Reserved (R)
			BIT 9 	-> 	Reserved (R)
			BIT 8	-> 	Relative-to-PC Address-Calculation Operation (PC)
			BIT 7 	-> 	Scalar rs2 is Signed (SB)
			BIT 6 	-> 	Scalar rs1 is Signed (SA)
			BIT 5 	-> 	Word's High-Part Operation (HL)
			BIT 4 	-> 	One-Word Operation (W)
			BIT 3	-> 	Atomic Memory Sync (Wait-for-Pipeline) Instruction (WP)
			BIT 2 	-> 	Conditional Branch Operation (BR)
			BIT 1 	-> 	Jump-Register Operation (JR)
			BIT 0 	-> 	Jump Operation (J)
*/
//case function 6 fixed point
`define		vsaddu			6'b100000
`define		vsadd			6'b100001
`define		vssubu			6'b100010
`define		vssub			6'b100011
`define		vaaddu			6'b001000
`define		vaadd			6'b001001
`define		vasubu			6'b001010
`define		vasub			6'b001011
`define		vsmul			6'b100111
`define		vssrl			6'b101010
`define		vssra			6'b101011
`define		vnclipu			6'b101110
`define		vnclip			6'b101111

//data vectors
	//system vector
`define		vsaddu_vv_system_vector		6'b000000
`define		vsaddu_vx_system_vector		6'b000000
`define		vsaddu_vi_system_vector		6'b000000
`define		vsadd_vv_system_vector		6'b000000
`define		vsadd_vx_system_vector		6'b000000
`define		vsadd_vi_system_vector		6'b000000
`define		vssubu_vv_system_vector		6'b000000
`define		vssubu_vx_system_vector		6'b000000
`define		vssub_vv_system_vector		6'b000000
`define		vssub_vx_system_vector		6'b000000
`define		vaaddu_vv_system_vector		6'b000000
`define		vaaddu_vx_system_vector		6'b000000
`define		vaadd_vv_system_vector		6'b000000
`define		vaadd_vx_system_vector		6'b000000
`define		vasubu_vv_system_vector		6'b000000
`define		vasubu_vx_system_vector		6'b000000
`define		vasub_vv_system_vector		6'b000000
`define		vasub_vx_system_vector		6'b000000
`define		vsmul_vv_system_vector		6'b000000
`define		vsmul_vx_system_vector		6'b000000
`define		vssrl_vv_system_vector		6'b000000
`define		vssrl_vx_system_vector		6'b000000
`define		vssrl_vi_system_vector		6'b000000
`define		vssra_vv_system_vector		6'b000000
`define		vssra_vx_system_vector		6'b000000
`define		vssra_vi_system_vector		6'b000000
`define		vnclip_wv_system_vector		6'b000000
`define		vnclip_wx_system_vector		6'b000000
`define		vnclip_wi_system_vector		6'b000000
`define		vnclipu_wv_system_vector	6'b000000
`define		vnclipu_wx_system_vector	6'b000000
`define		vnclipu_wi_system_vector	6'b000000

	//resource vector
`define		vsaddu_vv_resource_vector		22'b0000000000000010000000
`define		vsaddu_vx_resource_vector		22'b0000000000000010000000
`define		vsaddu_vi_resource_vector		22'b0000000000000011000000
`define		vsadd_vv_resource_vector		22'b0000000000000010000000
`define		vsadd_vx_resource_vector		22'b0000000000000010000000
`define		vsadd_vi_resource_vector		22'b0000000000000011000000
`define		vssubu_vv_resource_vector		22'b0000000000000010000000
`define		vssubu_vx_resource_vector		22'b0000000000000010000000
`define		vssub_vv_resource_vector		22'b0000000000000010000000
`define		vssub_vx_resource_vector		22'b0000000000000010000000
`define		vaaddu_vv_resource_vector		22'b0000000000000010000000
`define		vaaddu_vx_resource_vector		22'b0000000000000010000000
`define		vaadd_vv_resource_vector		22'b0000000000000010000000
`define		vaadd_vx_resource_vector		22'b0000000000000010000000
`define		vasubu_vv_resource_vector		22'b0000000000000010000000
`define		vasubu_vx_resource_vector		22'b0000000000000010000000
`define		vasub_vv_resource_vector		22'b0000000000000010000000
`define		vasub_vx_resource_vector		22'b0000000000000010000000
`define		vsmul_vv_resource_vector		22'b0000000001000000000000
`define		vsmul_vx_resource_vector		22'b0000000001000000000000
`define		vssrl_vv_resource_vector		22'b0000000000010100000000
`define		vssrl_vx_resource_vector		22'b0000000000010100000000
`define		vssrl_vi_resource_vector		22'b0000000000010101000000
`define		vssra_vv_resource_vector		22'b0000000000010100000000
`define		vssra_vx_resource_vector		22'b0000000000010100000000
`define		vssra_vi_resource_vector		22'b0000000000010101000000
`define		vnclip_wv_resource_vector		22'b0000000000010000000000
`define		vnclip_wx_resource_vector		22'b0000000000010000000000
`define		vnclip_wi_resource_vector		22'b0000000000010001000000
`define		vnclipu_wv_resource_vector		22'b0000000000010000000000
`define		vnclipu_wx_resource_vector		22'b0000000000010000000000
`define		vnclipu_wi_resource_vector		22'b0000000000010001000000

	//register vector
`define		vsaddu_vv_register_vector		8'b01101000
`define		vsaddu_vx_register_vector		8'b00101100
`define		vsaddu_vi_register_vector		8'b00101000
`define		vsadd_vv_register_vector		8'b01101000
`define		vsadd_vx_register_vector		8'b00101100
`define		vsadd_vi_register_vector		8'b00101000
`define		vssubu_vv_register_vector		8'b01101000
`define		vssubu_vx_register_vector		8'b00101100
`define		vssub_vv_register_vector		8'b01101000
`define		vssub_vx_register_vector		8'b00101100
`define		vaaddu_vv_register_vector		8'b01101000
`define		vaaddu_vx_register_vector		8'b00101100
`define		vaadd_vv_register_vector		8'b01101000
`define		vaadd_vx_register_vector		8'b00101100
`define		vasubu_vv_register_vector		8'b01101000
`define		vasubu_vx_register_vector		8'b00101100
`define		vasub_vv_register_vector		8'b01101000
`define		vasub_vx_register_vector		8'b00101100
`define		vsmul_vv_register_vector		8'b01101000
`define		vsmul_vx_register_vector		8'b00101100
`define		vssrl_vv_register_vector		8'b01101000
`define		vssrl_vx_register_vector		8'b00101100
`define		vssrl_vi_register_vector		8'b00101000
`define		vssra_vv_register_vector		8'b01101000
`define		vssra_vx_register_vector		8'b00101100
`define		vssra_vi_register_vector		8'b00101000
`define		vnclip_wv_register_vector		8'b01101000
`define		vnclip_wx_register_vector		8'b00101100
`define		vnclip_wi_register_vector		8'b00101000
`define		vnclipu_wv_register_vector		8'b01101000
`define		vnclipu_wx_register_vector		8'b00101100
`define		vnclipu_wi_register_vector		8'b00101000

	//operation vector
`define		vsaddu_vv_operation_vector		29'b00011000100100001100000000000
`define		vsaddu_vx_operation_vector		29'b00011000100100001100000000000
`define		vsaddu_vi_operation_vector		29'b00011000100100001100000000000
`define		vsadd_vv_operation_vector		29'b00011110100100001100000000000
`define		vsadd_vx_operation_vector		29'b00011100100100001100001000000
`define		vsadd_vi_operation_vector		29'b00011100100100001100000000000
`define		vssubu_vv_operation_vector		29'b00011000100100001100000000000
`define		vssubu_vx_operation_vector		29'b00011000100100001100000000000
`define		vssub_vv_operation_vector		29'b00011110100100001100000000000
`define		vssub_vx_operation_vector		29'b00011100100100001100001000000
`define		vaaddu_vv_operation_vector		29'b00011000100100001100000000000
`define		vaaddu_vx_operation_vector		29'b00011000100100001100000000000
`define		vaadd_vv_operation_vector		29'b00011110100100001100000000000
`define		vaadd_vx_operation_vector		29'b00011100100100001100001000000
`define		vasubu_vv_operation_vector		29'b00011000100100001100000000000
`define		vasubu_vx_operation_vector		29'b00011000100100001100000000000
`define		vasub_vv_operation_vector		29'b00011110100100001100000000000
`define		vasub_vx_operation_vector		29'b00011100100100001100001000000
`define		vsmul_vv_operation_vector		29'b00011110100100001100000000000
`define		vsmul_vx_operation_vector		29'b00011100100100001100001000000
`define		vssrl_vv_operation_vector		29'b00011000100100001100000000000
`define		vssrl_vx_operation_vector		29'b00011000100100001100000000000
`define		vssrl_vi_operation_vector		29'b00011000100100001100000000000
`define		vssra_vv_operation_vector		29'b00011110100100001100000000000
`define		vssra_vx_operation_vector		29'b00011100100100001100001000000
`define		vssra_vi_operation_vector		29'b00011100100100001100000000000
`define		vnclip_wv_operation_vector		29'b00011000100100001100000000000
`define		vnclip_wx_operation_vector		29'b00011000100100001100000000000
`define		vnclip_wi_operation_vector		29'b00011000100100001100000000000
`define		vnclipu_wv_operation_vector		29'b00011110100100001100000000000
`define		vnclipu_wx_operation_vector		29'b00011100100100001100001000000
`define		vnclipu_wi_operation_vector		29'b00011100100100001100000000000
// Reference: https://github.com/jdcasanasr/lagarto_v/tree/main/doc

/*	Resource Vectors
		resource Vector
			BIT 5 	-> 	Cache Sync Atomic Operation (AMO)
			BIT 4 	-> 	resource Operation (SYS)
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
//funct6
`define 	vmand							6'b011001
`define 	vmnand							6'b011101
`define 	vmandn							6'b011000
`define 	vmxor							6'b011011
`define 	vmor							6'b011010
`define 	vmnor							6'b011110
`define 	vmorn							6'b011100
`define 	vmxnor							6'b011111
`define 	vcpop							6'b010000
`define 	vfirst							6'b010000
`define 	vmsbf							6'b010100
`define 	vmsif							6'b010100
`define 	vmsof							6'b010100
`define 	viota							6'b010100
`define 	vid								6'b010100

//vs1_rs1_imm
`define 	vcpop_vs1						5'b10000
`define 	vfirst_vs1						5'b10001
`define 	vmsbf_vs1						5'b00001
`define 	vmsif_vs1						5'b00011
`define 	vmsof_vs1						5'b00010
`define 	viota_vs1						5'b10000
`define 	vid_vs1							5'b10001

//vs2
`define 	vid_vs2							5'b00000

//data vectors
	//system vector
`define 	vmand_mm_system_vector		6'b000000
`define 	vmnand_mm_system_vector		6'b000000
`define 	vmandn_mm_system_vector		6'b000000
`define 	vmxor_mm_system_vector		6'b000000
`define 	vmor_mm_system_vector		6'b000000
`define 	vmnor_mm_system_vector		6'b000000
`define 	vmorn_mm_system_vector		6'b000000
`define 	vmxnor_mm_system_vector		6'b000000
`define 	vcpop_m_system_vector		6'b000000
`define 	vfirst_m_system_vector		6'b000000
`define 	vmsbf_m_system_vector		6'b000000
`define 	vmsif_m_system_vector		6'b000000
`define 	vmsof_m_system_vector		6'b000000
`define 	viota_m_system_vector		6'b000000
`define		vid_v_system_vector			6'b000000
	
	//resource vector	
`define 	vmand_mm_resource_vector		22'b0000000000001000000000
`define 	vmnand_mm_resource_vector		22'b0000000000001000000000
`define 	vmandn_mm_resource_vector		22'b0000000000001000000000
`define 	vmxor_mm_resource_vector		22'b0000000000001000000000
`define 	vmor_mm_resource_vector			22'b0000000000001000000000
`define 	vmnor_mm_resource_vector		22'b0000000000001000000000
`define 	vmorn_mm_resource_vector		22'b0000000000001000000000
`define 	vmxnor_mm_resource_vector		22'b0000000000001000000000
`define 	vcpop_m_resource_vector			22'b0000000000001000000000
`define 	vfirst_m_resource_vector		22'b0000000000001000000000
`define 	vmsbf_m_resource_vector			22'b0000000000001000000000
`define 	vmsif_m_resource_vector			22'b0000000000001000000000
`define 	vmsof_m_resource_vector			22'b0000000000001000000000
`define 	viota_m_resource_vector			22'b0000000000001000000000
`define		vid_v_resource_vector			22'b0000000000001000000000
	
	//register vector	
`define 	vmand_mm_register_vector		8'b01101000
`define 	vmnand_mm_register_vector		8'b01101000
`define 	vmandn_mm_register_vector		8'b01101000
`define 	vmxor_mm_register_vector		8'b01101000
`define 	vmor_mm_register_vector			8'b01101000
`define 	vmnor_mm_register_vector		8'b01101000
`define 	vmorn_mm_register_vector		8'b01101000
`define 	vmxnor_mm_register_vector		8'b01101000
`define 	vcpop_m_register_vector			8'b00100001
`define 	vfirst_m_register_vector		8'b00100001
`define 	vmsbf_m_register_vector			8'b00101000
`define 	vmsif_m_register_vector			8'b00101000
`define 	vmsof_m_register_vector			8'b00101000
`define 	viota_m_register_vector			8'b00101000
`define		vid_v_register_vector			8'b10001000

	//operation vector
`define 	vmand_mm_operation_vector		29'b00010000000100001100000000000
`define 	vmnand_mm_operation_vector		29'b00010000000100001100000000000
`define 	vmandn_mm_operation_vector		29'b00010000000100001100000000000
`define 	vmxor_mm_operation_vector		29'b00010000000100001100000000000
`define 	vmor_mm_operation_vector		29'b00010000000100001100000000000
`define 	vmnor_mm_operation_vector		29'b00010000000100001100000000000
`define 	vmorn_mm_operation_vector		29'b00010000000100001100000000000
`define 	vmxnor_mm_operation_vector		29'b00010000000100001100000000000
`define 	vcpop_m_operation_vector		29'b00111000000100001100000000000
`define 	vfirst_m_operation_vector		29'b00111000000100001100000000000
`define 	vmsbf_m_operation_vector		29'b00111000000100001100000000000
`define 	vmsif_m_operation_vector		29'b00111000000100001100000000000
`define 	vmsof_m_operation_vector		29'b00111000000100001100000000000
`define 	viota_m_operation_vector		29'b00111000000100001100000000000
`define		vid_v_operation_vector			29'b00111000000100001100000000000
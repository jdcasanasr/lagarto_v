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
//case function 6 reduction
`define 	vredsum 					6'b000000
`define 	vredmaxu 					6'b000110
`define 	vredmax 					6'b000111
`define 	vredminu 					6'b000100
`define 	vredmin 					6'b000101
`define 	vredand 					6'b000001
`define 	vredor 						6'b000010
`define 	vredxor 					6'b000011
`define 	vwredsumu 					6'b110000
`define 	vwredsum 					6'b110001
`define 	vfredosum					6'b000011
`define 	vfredusum 					6'b000001
`define 	vfredmax 					6'b000111
`define 	vfredmin 					6'b000101
`define 	vfwredosum 					6'b110011
`define 	vfwredusum 					6'b110001

// Reduction Operations
	//system vector
`define 	vredsum_vs_system_vector		6'b000000
`define 	vredmaxu_vs_system_vector		6'b000000
`define 	vredmax_vs_system_vector		6'b000000
`define 	vredminu_vs_system_vector		6'b000000
`define 	vredmin_vs_system_vector		6'b000000
`define 	vredand_vs_system_vector		6'b000000
`define 	vredor_vs_system_vector			6'b000000
`define 	vredxor_vs_system_vector		6'b000000
`define 	vwredsumu_vs_system_vector		6'b000000
`define 	vwredsum_vs_system_vector		6'b000000
`define 	vfredosum_vs_system_vector		6'b000000
`define 	vfredusum_vs_system_vector		6'b000000
`define 	vfredmax_vs_system_vector		6'b000000
`define 	vfredmin_vs_system_vector		6'b000000
`define 	vfwredosum_vs_system_vector		6'b000000
`define 	vfwredusum_vs_system_vector		6'b000000

	//resource vector
`define 	vredsum_vs_resource_vector		22'b0000001000000010000000
`define 	vredmaxu_vs_resource_vector		22'b0000000000100000000000
`define 	vredmax_vs_resource_vector		22'b0000000000100000000000
`define 	vredminu_vs_resource_vector		22'b0000000000100000000000
`define 	vredmin_vs_resource_vector		22'b0000000000100000000000
`define 	vredand_vs_resource_vector		22'b0000000000001000000000
`define 	vredor_vs_resource_vector		22'b0000000000001000000000
`define 	vredxor_vs_resource_vector		22'b0000000000001000000000
`define 	vwredsumu_vs_resource_vector	22'b0000001000000110000000
`define 	vwredsum_vs_resource_vector		22'b0000001000000110000000
`define 	vfredosum_vs_resource_vector	22'b0000001000000000000000
`define 	vfredusum_vs_resource_vector	22'b0000001000000000000000
`define 	vfredmax_vs_resource_vector		22'b0010000000000000000000
`define 	vfredmin_vs_resource_vector		22'b0010000000000000000000
`define 	vfwredosum_vs_resource_vector	22'b0000001000000000000000
`define 	vfwredusum_vs_resource_vector	22'b0000001000000000000000

	//register vector
`define 	vredsum_vs_register_vector		8'b01101000
`define 	vredmaxu_vs_register_vector		8'b01101000
`define 	vredmax_vs_register_vector		8'b01101000
`define 	vredminu_vs_register_vector		8'b01101000
`define 	vredmin_vs_register_vector		8'b01101000
`define 	vredand_vs_register_vector		8'b01101000
`define 	vredor_vs_register_vector		8'b01101000
`define 	vredxor_vs_register_vector		8'b01101000
`define 	vwredsumu_vs_register_vector	8'b01101000
`define 	vwredsum_vs_register_vector		8'b01101000
`define 	vfredosum_vs_register_vector	8'b01101000
`define 	vfredusum_vs_register_vector	8'b01101000
`define 	vfredmax_vs_register_vector		8'b01101000
`define 	vfredmin_vs_register_vector		8'b01101000
`define 	vfwredosum_vs_register_vector	8'b01101000
`define 	vfwredusum_vs_register_vector	8'b01101000

	//operation vector
`define 	vredsum_vs_operation_vector		29'b00011110001100001100000000000
`define 	vredmaxu_vs_operation_vector	29'b00011000001100001100000000000
`define 	vredmax_vs_operation_vector		29'b00011110001100001100000000000
`define 	vredminu_vs_operation_vector	29'b00011000001100001100000000000
`define 	vredmin_vs_operation_vector		29'b00011110001100001100000000000
`define 	vredand_vs_operation_vector		29'b00011000001100001100000000000
`define 	vredor_vs_operation_vector		29'b00011000001100001100000000000
`define 	vredxor_vs_operation_vector		29'b00011000001100001100000000000
`define 	vwredsumu_vs_operation_vector	29'b00011000001100001100000000000
`define 	vwredsum_vs_operation_vector	29'b00011110001100001100000000000
`define 	vfredosum_vs_operation_vector	29'b00011000010100001100000000000
`define 	vfredusum_vs_operation_vector	29'b00011000010100001100000000000
`define 	vfredmax_vs_operation_vector	29'b00011000010100001100000000000
`define 	vfredmin_vs_operation_vector	29'b00011000010100001100000000000
`define 	vfwredosum_vs_operation_vector	29'b00011000010100001100000000000
`define 	vfwredusum_vs_operation_vector	29'b00011000010100001100000000000
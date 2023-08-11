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
// vsew 
`define	vsew_8						3'b000
`define	vsew_16						3'b001
`define	vsew_32						3'b010
`define	vsew_64						3'b011

// Resource Vectors' Widths
`define SYSTEM_VECTOR_WIDTH     6
`define RESOURCE_VECTOR_WIDTH   22
`define REGISTER_VECTOR_WIDTH   8
`define OPERATION_VECTOR_WIDTH  29

// Resource Vectors' Bit Positions
//system vector
`define	system_vector_amo			5
`define	system_vector_sys			4
`define	system_vector_halt			3
`define	system_vector_fence			2
`define	system_vector_l				1
`define	system_vector_s				0

// Resource Vector
`define	resource_vector_vfconv		21
`define	resource_vector_vfclass		20
`define	resource_vector_vfcmp		19
`define	resource_vector_vfsqrt		18
`define	resource_vector_vfdiv		17
`define	resource_vector_vfmul		16
`define	resource_vector_vfadd		15
`define	resource_vector_vmerge		14
`define	resource_vector_vdiv		13
`define	resource_vector_vmul		12
`define	resource_vector_vcmp		11
`define	resource_vector_vshft		10
`define	resource_vector_vlogic		9
`define	resource_vector_vszext		8
`define	resource_vector_vadd		7
`define	resource_vector_imm		    6
`define	resource_vector_br		    5
`define	resource_vector_slt		    4
`define	resource_vector_shft		3
`define	resource_vector_logic		2
`define	resource_vector_mul			1
`define	resource_vector_add			0

// Register Vector
`define register_vector_vmask 		7
`define register_vector_vs1 		6
`define register_vector_vs2 		5
`define register_vector_vd_read 	4
`define register_vector_vd_write 	3
`define register_vector_rs1 		2
`define register_vector_rs2 		1
`define register_vector_rd 			0

//operation vector
`define operation_vector_vhl		28
`define operation_vector_vs2		27
`define operation_vector_vs1		26
`define operation_vector_f6			25
`define operation_vector_vm			24
`define operation_vector_vsb		23
`define operation_vector_vsa		22
`define operation_vector_vmem		21
`define operation_vector_vfxp		20
`define operation_vector_vfp		19
`define operation_vector_vint		18
`define operation_vector_vec		17
`define operation_vector_fp			16
`define operation_vector_eh			15
`define operation_vector_mem		14
`define operation_vector_int		13
`define operation_vector_op_f7		12
`define operation_vector_f3			11
`define operation_vector_r			10
`define operation_vector_r			9
`define operation_vector_pc			8
`define operation_vector_sb			7
`define operation_vector_sa			6
`define operation_vector_hl			5
`define operation_vector_w			4
`define operation_vector_wp			3
`define operation_vector_br			2
`define operation_vector_jr			1
`define operation_vector_j			0

//lenghts
`define		data_length					128
`define		instruction_length			32
`define	    system_vector_length	    6
`define	    resource_vector_length	    22
`define	    register_vector_length	    8
`define	    operation_vector_length	    29
`define     funct6_length               6
`define     funct3_length               3
`define		vs1_address_length			5
`define		vs2_address_length			5
`define		vd_address_length			5

// instruction format bits position
`define		opcode						6:0
`define     vd_rd_vs3                   11:7
`define     funct3_width                14:12
`define     vs1_rs1_imm                 19:15
`define     vs2_sumop_lumop             24:20
`define		vm							25
`define     funct6                      31:26
`define		mop							27:26
`define		mew							28
`define		nf							31:29

//case op code
`define		op_arithmetic				7'b1010111
`define		op_load						7'b0000111
`define		op_store					7'b0100111
`define		op_floating_point			7'b1010111
`define		op_fixed_point				7'b1010111

//case function 3 
`define		OPIVV						3'b000
`define		OPFVV						3'b001
`define		OPMVV						3'b010
`define		OPIVI						3'b011
`define		OPIVX						3'b100
`define		OPFVF						3'b101
`define		OPMVX						3'b110

//data vectors default
`define		system_vector_default			6'b0
`define		resource_vector_default			22'b0
`define		register_vector_default			7'b0
`define		operation_vector_default		29'b0
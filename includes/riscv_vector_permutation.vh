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
// case funct6 permutation
`define vmv_x_s							6'b010000
`define vmv_s_x							6'b010000
`define vfmv_f_s						6'b010000
`define vfmv_s_f						6'b010000
`define vslideup						6'b001110
`define vslidedown						6'b001111
`define vslide1up						6'b001110
`define vfslide1up						6'b001110
`define vslide1down						6'b001111
`define vfslide1down					6'b001111
`define vrgather						6'b001100
`define vrgatheri16						6'b001110
`define vcompress						6'b010111
`define vmvx_r							6'b100111

//vs1_rs1_imm
`define		vmv							5'b0

// Permutation Operations
	//system Vector
`define		vmv_x_s_system_vector				6'b000000
`define		vmv_s_x_system_vector				6'b000000
`define		vfmv_f_s_system_vector				6'b000000
`define		vfmv_s_f_system_vector				6'b000000
`define		vslideup_vx_system_vector			6'b000000
`define		vslideup_vi_system_vector			6'b000000
`define		vslidedown_vx_system_vector			6'b000000
`define		vslidedown_vi_system_vector			6'b000000
`define		vslide1up_vx_system_vector			6'b000000
`define		vfslide1up_vf_system_vector			6'b000000
`define		vslide1down_vx_system_vector		6'b000000
`define		vfslide1down_vf_system_vector		6'b000000
`define		vrgather_vv_system_vector			6'b000000
`define		vrgather_vx_system_vector			6'b000000
`define		vrgather_vi_system_vector			6'b000000
`define		vrgatheri16_vv_system_vector		6'b000000
`define		vcompress_vm_system_vector			6'b000000
`define		vmvx_r_system_vector				6'b000000

	//Resource Vector
`define		vmv_x_s_resource_vector				22'b0000000000000000000000
`define		vmv_s_x_resource_vector				22'b0000000000000000000000
`define		vfmv_f_s_resource_vector			22'b0000000000000000000000
`define		vfmv_s_f_resource_vector			22'b0000000000000000000000
`define		vslideup_vx_resource_vector			22'b0000000000000000000000
`define		vslideup_vi_resource_vector			22'b0000000000000001000000
`define		vslidedown_vx_resource_vector		22'b0000000000000000000000
`define		vslidedown_vi_resource_vector		22'b0000000000000001000000
`define		vslide1up_vx_resource_vector		22'b0000000000000000000000
`define		vfslide1up_vf_resource_vector		22'b0000000000000001000000
`define		vslide1down_vx_resource_vector		22'b0000000000000000000000
`define		vfslide1down_vf_resource_vector		22'b0000000000000001000000
`define		vrgather_vv_resource_vector			22'b0000000000000000000000
`define		vrgather_vx_resource_vector			22'b0000000000000000000000
`define		vrgather_vi_resource_vector			22'b0000000000000001000000
`define		vrgatheri16_vv_resource_vector		22'b0000000000000000000000
`define		vcompress_vm_resource_vector		22'b0000000000000000000000
`define		vmvx_r_resource_vector				22'b0000000000000000000000

	//Register Vector
`define		vmv_x_s_register_vector				8'b00100001
`define		vmv_s_x_register_vector				8'b00001100
`define		vfmv_f_s_register_vector			8'b00100001
`define		vfmv_s_f_register_vector			8'b00100001
`define		vslideup_vx_register_vector			8'b00101100
`define		vslideup_vi_register_vector			8'b00101000
`define		vslidedown_vx_register_vector		8'b00101100
`define		vslidedown_vi_register_vector		8'b00101000
`define		vslide1up_vx_register_vector		8'b00101100
`define		vfslide1up_vf_register_vector		8'b00101100
`define		vslide1down_vx_register_vector		8'b00101100
`define		vfslide1down_vf_register_vector		8'b00101100
`define		vrgather_vv_register_vector			8'b01101000
`define		vrgather_vx_register_vector			8'b00101100
`define		vrgather_vi_register_vector			8'b00101000
`define		vrgatheri16_vv_register_vector		8'b01101000
`define		vcompress_vm_register_vector		8'b10101000
`define		vmvx_r_register_vector				8'b00101000

	//Operation Vector
`define		vmv_x_s_operation_vector			29'b00110000001100001100000000000
`define		vmv_s_x_operation_vector			29'b01010000001100001100000000000
`define		vfmv_f_s_operation_vector			29'b00110000010100001100000000000
`define		vfmv_s_f_operation_vector			29'b01010000010100001100000000000
`define		vslideup_vx_operation_vector		29'b00011000000100001100000000000
`define		vslideup_vi_operation_vector		29'b00011000000100001100000000000
`define		vslidedown_vx_operation_vector		29'b00011000000100001100000000000
`define		vslidedown_vi_operation_vector		29'b00011000000100001100000000000
`define		vslide1up_vx_operation_vector		29'b00011000001100001100000000000
`define		vfslide1up_vf_operation_vector		29'b00011000010100001100000000000
`define		vslide1down_vx_operation_vector		29'b00011000001100001100000000000
`define		vfslide1down_vf_operation_vector	29'b00011000010100001100000000000
`define		vrgather_vv_operation_vector		29'b00011000000100001100000000000
`define		vrgather_vx_operation_vector		29'b00011000000100001100000000000
`define		vrgather_vi_operation_vector		29'b00011000000100001100000000000
`define		vrgatheri16_vv_operation_vector		29'b00011000000100001100000000000
`define		vcompress_vm_operation_vector		29'b00010000000100001100000000000
`define		vmvx_r_operation_vector				29'b00110000000100001100000000000
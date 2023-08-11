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
// CASE FUNCT6 FLOATING POINT
`define		vfadd			6'b000000
`define		vfsub			6'b000010
`define		vfrsub			6'b100111
`define		vfwadd			6'b110000
`define		vfwsub			6'b110010
`define		vfwadd_w		6'b110100
`define		vfwsub_w		6'b110110
`define		vfmul			6'b100100
`define		vfdiv			6'b100000
`define		vfrdiv			6'b100001
`define		vfwmul			6'b111000
`define		vfmacc			6'b101100
`define		vfnmacc			6'b101101
`define		vfmsac			6'b101110
`define		vfnmsac			6'b101111
`define		vfmadd			6'b101000
`define		vfnmadd			6'b101001
`define		vfmsub			6'b101010
`define		vfnmsub			6'b101011
`define		vfwmacc			6'b111100
`define		vfwnmacc		6'b111101
`define		vfwmsac			6'b111110
`define		vfwnmsac		6'b111111
`define		vfunary1		6'b010011
//`define		vfsqrt_v		6'b010011
//`define		vfrsqrt7_v		6'b010011
//`define		vfrec7_v		6'b010011
//`define		vfclass_v		6'b010011
`define		vfmin			6'b000100
`define		vfmax			6'b000110
`define		vfsgnj			6'b001000
`define		vfsgnjn			6'b001001
`define		vfsgnjx			6'b001010
`define		vmfeq			6'b011000
`define		vmfne			6'b011100
`define		vmflt			6'b011011
`define		vmfle			6'b011001
`define		vmfgt			6'b011101
`define		vmfge			6'b011111
`define		vfmerge_vfmv	6'b010111
`define		vfunary0		6'b010010
//`define		vfcvt_xu_f_v		6'b010010
//`define		vfcvt_x_f_v			6'b010010
//`define		vfcvt_rtz_xu_f_v	6'b010010
//`define		vfcvt_rtz_x_f_v		6'b010010
//`define		vfcvt_f_xu_v		6'b010010
//`define		vfcvt_f_x_v			6'b010010
//`define		vfwcvt_xu_f_v		6'b010010
//`define		vfwcvt_x_f_v		6'b010010
//`define		vfwcvt_rtz_xu_f_v	6'b010010
//`define		vfwcvt_rtz_x_f_v	6'b010010
//`define		vfwcvt_f_f_v		6'b010010
//`define		vfncvt_xu_f_w		6'b010010
//`define		vfncvt_x_f_w		6'b010010
//`define		vfncvt_rtz_xu_f_w	6'b010010
//`define		vfncvt_rtz_x_f_w	6'b010010
//`define		vfncvt_f_xu_w		6'b010010
//`define		vfncvt_f_x_w		6'b010010
//`define		vfncvt_f_f_w		6'b010010
//`define		vfncvt_rod_f_f_w	6'b010010
//`define		vfwcvt_f_xu_v		6'b010010
//`define		vfwcvt_f_x_v		6'b010010

//CASE FUNCT5
`define		funct5_vfsqrt_v				5'b00000
`define		funct5_vfrsqrt7_v			5'b00100
`define		funct5_vfrec7_v				5'b00101
`define		funct5_vfclass_v			5'b10000
`define		funct5_vfcvt_xu_f_v			5'b00000
`define		funct5_vfcvt_x_f_v			5'b00001
`define		funct5_vfcvt_rtz_xu_f_v		5'b00110
`define		funct5_vfcvt_rtz_x_f_v		5'b00111
`define		funct5_vfcvt_f_xu_v			5'b00010
`define		funct5_vfcvt_f_x_v			5'b00011
`define		funct5_vfwcvt_xu_f_v		5'b01000
`define		funct5_vfwcvt_x_f_v			5'b01001
`define		funct5_vfwcvt_rtz_xu_f_v	5'b01110
`define		funct5_vfwcvt_rtz_x_f_v		5'b01111
`define		funct5_vfwcvt_f_f_v			5'b01100
`define		funct5_vfncvt_xu_f_w		5'b10000
`define		funct5_vfncvt_x_f_w			5'b10001
`define		funct5_vfncvt_rtz_xu_f_w	5'b10110
`define		funct5_vfncvt_rtz_x_f_w		5'b10111
`define		funct5_vfncvt_f_xu_w		5'b10010
`define		funct5_vfncvt_f_x_w			5'b10011
`define		funct5_vfncvt_f_f_w			5'b10100
`define		funct5_vfncvt_rod_f_f_w		5'b10101
`define		funct5_vfwcvt_f_xu_v		5'b01010
`define		funct5_vfwcvt_f_x_v			5'b01011

// DATA VECTORS
	//SYSTEM VECTOR
`define		vfadd_vv_system_vector				6'b000000
`define		vfadd_vf_system_vector				6'b000000
`define		vfsub_vv_system_vector				6'b000000
`define		vfsub_vf_system_vector				6'b000000
`define		vfrsub_vf_system_vector				6'b000000
`define		vfwadd_vv_system_vector				6'b000000
`define		vfwadd_vf_system_vector				6'b000000
`define		vfwsub_vv_system_vector				6'b000000
`define		vfwsub_vf_system_vector				6'b000000
`define		vfwadd_wv_system_vector				6'b000000
`define		vfwadd_wf_system_vector				6'b000000
`define		vfwsub_wv_system_vector				6'b000000
`define		vfwsub_wf_system_vector				6'b000000
`define		vfmul_vv_system_vector				6'b000000
`define		vfmul_vf_system_vector				6'b000000
`define		vfdiv_vv_system_vector				6'b000000
`define		vfdiv_vf_system_vector				6'b000000
`define		vfrdiv_vf_system_vector				6'b000000
`define		vfwmul_vv_system_vector				6'b000000
`define		vfwmul_vf_system_vector				6'b000000
`define		vfmacc_vv_system_vector				6'b000000
`define		vfmacc_vf_system_vector				6'b000000
`define		vfnmacc_vv_system_vector			6'b000000
`define		vfnmacc_vf_system_vector			6'b000000
`define		vfmsac_vv_system_vector				6'b000000
`define		vfmsac_vf_system_vector				6'b000000
`define		vfnmsac_vv_system_vector			6'b000000
`define		vfnmsac_vf_system_vector			6'b000000
`define		vfmadd_vv_system_vector				6'b000000
`define		vfmadd_vf_system_vector				6'b000000
`define		vfnmadd_vv_system_vector			6'b000000
`define		vfnmadd_vf_system_vector			6'b000000
`define		vfmsub_vv_system_vector				6'b000000
`define		vfmsub_vf_system_vector				6'b000000
`define		vfnmsub_vv_system_vector			6'b000000
`define		vfnmsub_vf_system_vector			6'b000000
`define		vfwmacc_vv_system_vector			6'b000000
`define		vfwmacc_vf_system_vector			6'b000000
`define		vfwnmacc_vv_system_vector			6'b000000
`define		vfwnmacc_vf_system_vector			6'b000000
`define		vfwmsac_vv_system_vector			6'b000000
`define		vfwmsac_vf_system_vector			6'b000000
`define		vfwnmsac_vv_system_vector			6'b000000
`define		vfwnmsac_vf_system_vector			6'b000000
`define		vfsqrt_v_system_vector				6'b000000
`define		vfrsqrt7_v_system_vector			6'b000000
`define		vfrec7_v_system_vector				6'b000000
`define		vfmin_vv_system_vector				6'b000000
`define		vfmin_vf_system_vector				6'b000000
`define		vfmax_vv_system_vector				6'b000000
`define		vfmax_vf_system_vector				6'b000000
`define		vfsgnj_vv_system_vector				6'b000000
`define		vfsgnj_vf_system_vector				6'b000000
`define		vfsgnjn_vv_system_vector			6'b000000
`define		vfsgnjn_vf_system_vector			6'b000000
`define		vfsgnjx_vv_system_vector			6'b000000
`define		vfsgnjx_vf_system_vector			6'b000000
`define		vmfeq_vv_system_vector				6'b000000
`define		vmfeq_vf_system_vector				6'b000000
`define		vmfne_vv_system_vector				6'b000000
`define		vmfne_vf_system_vector				6'b000000
`define		vmflt_vv_system_vector				6'b000000
`define		vmflt_vf_system_vector				6'b000000
`define		vmfle_vv_system_vector				6'b000000
`define		vmfle_vf_system_vector				6'b000000
`define		vmfgt_vf_system_vector				6'b000000
`define		vmfge_vf_system_vector				6'b000000
`define		vfclass_v_system_vector				6'b000000
`define		vfmerge_vfm_system_vector			6'b000000
`define		vfmv_v_f_system_vector				6'b000000
`define		vfcvt_xu_f_v_system_vector			6'b000000
`define		vfcvt_x_f_v_system_vector			6'b000000
`define		vfcvt_rtz_xu_f_v_system_vector		6'b000000
`define		vfcvt_rtz_x_f_v_system_vector		6'b000000
`define		vfcvt_f_xu_v_system_vector			6'b000000
`define		vfcvt_f_x_v_system_vector			6'b000000
`define		vfwcvt_xu_f_v_system_vector			6'b000000
`define		vfwcvt_x_f_v_system_vector			6'b000000
`define		vfwcvt_rtz_xu_f_v_system_vector		6'b000000
`define		vfwcvt_rtz_x_f_v_system_vector		6'b000000
`define		vfwcvt_f_f_v_system_vector			6'b000000
`define		vfncvt_xu_f_w_system_vector			6'b000000
`define		vfncvt_x_f_w_system_vector			6'b000000
`define		vfncvt_rtz_xu_f_w_system_vector		6'b000000
`define		vfncvt_rtz_x_f_w_system_vector		6'b000000
`define		vfncvt_f_xu_w_system_vector			6'b000000
`define		vfncvt_f_x_w_system_vector			6'b000000
`define		vfncvt_f_f_w_system_vector			6'b000000
`define		vfncvt_rod_f_f_w_system_vector		6'b000000
`define		vfwcvt_f_xu_v_system_vector			6'b000000
`define		vfwcvt_f_x_v_system_vector			6'b000000

	// RESOURCE VECTOR
`define		vfadd_vv_resource_vector			22'b0000001000000000000000
`define		vfadd_vf_resource_vector			22'b0000001000000000000000
`define		vfsub_vv_resource_vector			22'b0000001000000000000000
`define		vfsub_vf_resource_vector			22'b0000001000000000000000
`define		vfrsub_vf_resource_vector			22'b0000001000000000000000
`define		vfwadd_vv_resource_vector			22'b0000001000000000000000
`define		vfwadd_vf_resource_vector			22'b0000001000000000000000
`define		vfwsub_vv_resource_vector			22'b0000001000000000000000
`define		vfwsub_vf_resource_vector			22'b0000001000000000000000
`define		vfwadd_wv_resource_vector			22'b0000001000000000000000
`define		vfwadd_wf_resource_vector			22'b0000001000000000000000
`define		vfwsub_wv_resource_vector			22'b0000001000000000000000
`define		vfwsub_wf_resource_vector			22'b0000001000000000000000
`define		vfmul_vv_resource_vector			22'b0000010000000000000000
`define		vfmul_vf_resource_vector			22'b0000010000000000000000
`define		vfdiv_vv_resource_vector			22'b0000100000000000000000
`define		vfdiv_vf_resource_vector			22'b0000100000000000000000
`define		vfrdiv_vf_resource_vector			22'b0000100000000000000000
`define		vfwmul_vv_resource_vector			22'b0000010000000000000000
`define		vfwmul_vf_resource_vector			22'b0000010000000000000000
`define		vfmacc_vv_resource_vector			22'b0000011000000000000000
`define		vfmacc_vf_resource_vector			22'b0000011000000000000000
`define		vfnmacc_vv_resource_vector			22'b0000011000000000000000
`define		vfnmacc_vf_resource_vector			22'b0000011000000000000000
`define		vfmsac_vv_resource_vector			22'b0000011000000000000000
`define		vfmsac_vf_resource_vector			22'b0000011000000000000000
`define		vfnmsac_vv_resource_vector			22'b0000011000000000000000
`define		vfnmsac_vf_resource_vector			22'b0000011000000000000000
`define		vfmadd_vv_resource_vector			22'b0000011000000000000000
`define		vfmadd_vf_resource_vector			22'b0000011000000000000000
`define		vfnmadd_vv_resource_vector			22'b0000011000000000000000
`define		vfnmadd_vf_resource_vector			22'b0000011000000000000000
`define		vfmsub_vv_resource_vector			22'b0000011000000000000000
`define		vfmsub_vf_resource_vector			22'b0000011000000000000000
`define		vfnmsub_vv_resource_vector			22'b0000011000000000000000
`define		vfnmsub_vf_resource_vector			22'b0000011000000000000000
`define		vfwmacc_vv_resource_vector			22'b0000011000000000000000
`define		vfwmacc_vf_resource_vector			22'b0000011000000000000000
`define		vfwnmacc_vv_resource_vector			22'b0000011000000000000000
`define		vfwnmacc_vf_resource_vector			22'b0000011000000000000000
`define		vfwmsac_vv_resource_vector			22'b0000011000000000000000
`define		vfwmsac_vf_resource_vector			22'b0000011000000000000000
`define		vfwnmsac_vv_resource_vector			22'b0000011000000000000000
`define		vfwnmsac_vf_resource_vector			22'b0000011000000000000000
`define		vfsqrt_v_resource_vector			22'b0001000000000000000000
`define		vfrsqrt7_v_resource_vector			22'b0001000000000000000000
`define		vfrec7_v_resource_vector			22'b0000100000000000000000
`define		vfmin_vv_resource_vector			22'b0010000000000000000000
`define		vfmin_vf_resource_vector			22'b0010000000000000000000
`define		vfmax_vv_resource_vector			22'b0010000000000000000000
`define		vfmax_vf_resource_vector			22'b0010000000000000000000
`define		vfsgnj_vv_resource_vector			22'b0000000000001000000000
`define		vfsgnj_vf_resource_vector			22'b0000000000001000000000
`define		vfsgnjn_vv_resource_vector			22'b0000000000001000000000
`define		vfsgnjn_vf_resource_vector			22'b0000000000001000000000
`define		vfsgnjx_vv_resource_vector			22'b0000000000001000000000
`define		vfsgnjx_vf_resource_vector			22'b0000000000001000000000
`define		vmfeq_vv_resource_vector			22'b0010000000000000000000
`define		vmfeq_vf_resource_vector			22'b0010000000000000000000
`define		vmfne_vv_resource_vector			22'b0010000000000000000000
`define		vmfne_vf_resource_vector			22'b0010000000000000000000
`define		vmflt_vv_resource_vector			22'b0010000000000000000000
`define		vmflt_vf_resource_vector			22'b0010000000000000000000
`define		vmfle_vv_resource_vector			22'b0010000000000000000000
`define		vmfle_vf_resource_vector			22'b0010000000000000000000
`define		vmfgt_vf_resource_vector			22'b0010000000000000000000
`define		vmfge_vf_resource_vector			22'b0010000000000000000000
`define		vfclass_v_resource_vector			22'b0100000000000000000000
`define		vfmerge_vfm_resource_vector			22'b0000000100000000000000
`define		vfmv_v_f_resource_vector			22'b0000000000000000000000
`define		vfcvt_xu_f_v_resource_vector		22'b1000000000000000000000
`define		vfcvt_x_f_v_resource_vector			22'b1000000000000000000000
`define		vfcvt_rtz_xu_f_v_resource_vector	22'b1000000000000000000000
`define		vfcvt_rtz_x_f_v_resource_vector		22'b1000000000000000000000
`define		vfcvt_f_xu_v_resource_vector		22'b1000000000000000000000
`define		vfcvt_f_x_v_resource_vector			22'b1000000000000000000000
`define		vfwcvt_xu_f_v_resource_vector		22'b1000000000000000000000
`define		vfwcvt_x_f_v_resource_vector		22'b1000000000000000000000
`define		vfwcvt_rtz_xu_f_v_resource_vector	22'b1000000000000000000000
`define		vfwcvt_rtz_x_f_v_resource_vector	22'b1000000000000000000000
`define		vfwcvt_f_f_v_resource_vector		22'b1000000000000000000000
`define		vfncvt_xu_f_w_resource_vector		22'b1000000000000000000000
`define		vfncvt_x_f_w_resource_vector		22'b1000000000000000000000
`define		vfncvt_rtz_xu_f_w_resource_vector	22'b1000000000000000000000
`define		vfncvt_rtz_x_f_w_resource_vector	22'b1000000000000000000000
`define		vfncvt_f_xu_w_resource_vector		22'b1000000000000000000000
`define		vfncvt_f_x_w_resource_vector		22'b1000000000000000000000
`define		vfncvt_f_f_w_resource_vector		22'b1000000000000000000000
`define		vfncvt_rod_f_f_w_resource_vector	22'b1000000000000000000000
`define		vfwcvt_f_xu_v_resource_vector		22'b1000000000000000000000
`define		vfwcvt_f_x_v_resource_vector		22'b1000000000000000000000

	// REGISTER VECTOR
`define		vfadd_vv_register_vector			8'b01101000
`define		vfadd_vf_register_vector			8'b00101100
`define		vfsub_vv_register_vector			8'b01101000
`define		vfsub_vf_register_vector			8'b00101100
`define		vfrsub_vf_register_vector			8'b00101100
`define		vfwadd_vv_register_vector			8'b01101000
`define		vfwadd_vf_register_vector			8'b00101100
`define		vfwsub_vv_register_vector			8'b01101000
`define		vfwsub_vf_register_vector			8'b00101100
`define		vfwadd_wv_register_vector			8'b01101000
`define		vfwadd_wf_register_vector			8'b00101100
`define		vfwsub_wv_register_vector			8'b01101000
`define		vfwsub_wf_register_vector			8'b00101100
`define		vfmul_vv_register_vector			8'b01101000
`define		vfmul_vf_register_vector			8'b00101100
`define		vfdiv_vv_register_vector			8'b01101000
`define		vfdiv_vf_register_vector			8'b00101100
`define		vfrdiv_vf_register_vector			8'b00101100
`define		vfwmul_vv_register_vector			8'b01101000
`define		vfwmul_vf_register_vector			8'b00101100
`define		vfmacc_vv_register_vector			8'b01111000
`define		vfmacc_vf_register_vector			8'b00111100
`define		vfnmacc_vv_register_vector			8'b01111000
`define		vfnmacc_vf_register_vector			8'b00111100
`define		vfmsac_vv_register_vector			8'b01111000
`define		vfmsac_vf_register_vector			8'b00111100
`define		vfnmsac_vv_register_vector			8'b01111000
`define		vfnmsac_vf_register_vector			8'b00111100
`define		vfmadd_vv_register_vector			8'b01111000
`define		vfmadd_vf_register_vector			8'b00111100
`define		vfnmadd_vv_register_vector			8'b01111000
`define		vfnmadd_vf_register_vector			8'b00111100
`define		vfmsub_vv_register_vector			8'b01111000
`define		vfmsub_vf_register_vector			8'b00111100
`define		vfnmsub_vv_register_vector			8'b01111000
`define		vfnmsub_vf_register_vector			8'b00111100
`define		vfwmacc_vv_register_vector			8'b01111000
`define		vfwmacc_vf_register_vector			8'b00111100
`define		vfwnmacc_vv_register_vector			8'b01111000
`define		vfwnmacc_vf_register_vector			8'b00111100
`define		vfwmsac_vv_register_vector			8'b01111000
`define		vfwmsac_vf_register_vector			8'b00111100
`define		vfwnmsac_vv_register_vector			8'b01111000
`define		vfwnmsac_vf_register_vector			8'b00111100
`define		vfsqrt_v_register_vector			8'b00101000
`define		vfrsqrt7_v_register_vector			8'b00101000
`define		vfrec7_v_register_vector			8'b00101000
`define		vfmin_vv_register_vector			8'b01101000
`define		vfmin_vf_register_vector			8'b00101100
`define		vfmax_vv_register_vector			8'b01101000
`define		vfmax_vf_register_vector			8'b00101100
`define		vfsgnj_vv_register_vector			8'b01101000
`define		vfsgnj_vf_register_vector			8'b00101100
`define		vfsgnjn_vv_register_vector			8'b01101000
`define		vfsgnjn_vf_register_vector			8'b00101100
`define		vfsgnjx_vv_register_vector			8'b01101000
`define		vfsgnjx_vf_register_vector			8'b00101100
`define		vmfeq_vv_register_vector			8'b01101000
`define		vmfeq_vf_register_vector			8'b00101100
`define		vmfne_vv_register_vector			8'b01101000
`define		vmfne_vf_register_vector			8'b00101100
`define		vmflt_vv_register_vector			8'b01101000
`define		vmflt_vf_register_vector			8'b00101100
`define		vmfle_vv_register_vector			8'b01101000
`define		vmfle_vf_register_vector			8'b00101100
`define		vmfgt_vf_register_vector			8'b00101100
`define		vmfge_vf_register_vector			8'b00101100
`define		vfclass_v_register_vector			8'b00101000
`define		vfmerge_vfm_register_vector			8'b10101100
`define		vfmv_v_f_register_vector			8'b00001100
`define		vfcvt_xu_f_v_register_vector		8'b00101000
`define		vfcvt_x_f_v_register_vector			8'b00101000
`define		vfcvt_rtz_xu_f_v_register_vector	8'b00101000
`define		vfcvt_rtz_x_f_v_register_vector		8'b00101000
`define		vfcvt_f_xu_v_register_vector		8'b00101000
`define		vfcvt_f_x_v_register_vector			8'b00101000
`define		vfwcvt_xu_f_v_register_vector		8'b00101000
`define		vfwcvt_x_f_v_register_vector		8'b00101000
`define		vfwcvt_rtz_xu_f_v_register_vector	8'b00101000
`define		vfwcvt_rtz_x_f_v_register_vector	8'b00101000
`define		vfwcvt_f_f_v_register_vector		8'b00101000
`define		vfncvt_xu_f_w_register_vector		8'b00101000
`define		vfncvt_x_f_w_register_vector		8'b00101000
`define		vfncvt_rtz_xu_f_w_register_vector	8'b00101000
`define		vfncvt_rtz_x_f_w_register_vector	8'b00101000
`define		vfncvt_f_xu_w_register_vector		8'b00101000
`define		vfncvt_f_x_w_register_vector		8'b00101000
`define		vfncvt_f_f_w_register_vector		8'b00101000
`define		vfncvt_rod_f_f_w_register_vector	8'b00101000
`define		vfwcvt_f_xu_v_register_vector		8'b00101000
`define		vfwcvt_f_x_v_register_vector		8'b00101000

	// OPERATION VECTOR
`define		vfadd_vv_operation_vector			29'b00011000010100001100000000000
`define		vfadd_vf_operation_vector			29'b00011000010100001100000000000
`define		vfsub_vv_operation_vector			29'b00011000010100001100000000000
`define		vfsub_vf_operation_vector			29'b00011000010100001100000000000
`define		vfrsub_vf_operation_vector			29'b00011000010100001100000000000
`define		vfwadd_vv_operation_vector			29'b00011000010100001100000000000
`define		vfwadd_vf_operation_vector			29'b00011000010100001100000000000
`define		vfwsub_vv_operation_vector			29'b00011000010100001100000000000
`define		vfwsub_vf_operation_vector			29'b00011000010100001100000000000
`define		vfwadd_wv_operation_vector			29'b00011000010100001100000000000
`define		vfwadd_wf_operation_vector			29'b00011000010100001100000000000
`define		vfwsub_wv_operation_vector			29'b00011000010100001100000000000
`define		vfwsub_wf_operation_vector			29'b00011000010100001100000000000
`define		vfmul_vv_operation_vector			29'b00011000010100001100000000000
`define		vfmul_vf_operation_vector			29'b00011000010100001100000000000
`define		vfdiv_vv_operation_vector			29'b00011000010100001100000000000
`define		vfdiv_vf_operation_vector			29'b00011000010100001100000000000
`define		vfrdiv_vf_operation_vector			29'b00011000010100001100000000000
`define		vfwmul_vv_operation_vector			29'b00011000010100001100000000000
`define		vfwmul_vf_operation_vector			29'b00011000010100001100000000000
`define		vfmacc_vv_operation_vector			29'b00011000010100001100000000000
`define		vfmacc_vf_operation_vector			29'b00011000010100001100000000000
`define		vfnmacc_vv_operation_vector			29'b00011000010100001100000000000
`define		vfnmacc_vf_operation_vector			29'b00011000010100001100000000000
`define		vfmsac_vv_operation_vector			29'b00011000010100001100000000000
`define		vfmsac_vf_operation_vector			29'b00011000010100001100000000000
`define		vfnmsac_vv_operation_vector			29'b00011000010100001100000000000
`define		vfnmsac_vf_operation_vector			29'b00011000010100001100000000000
`define		vfmadd_vv_operation_vector			29'b00011000010100001100000000000
`define		vfmadd_vf_operation_vector			29'b00011000010100001100000000000
`define		vfnmadd_vv_operation_vector			29'b00011000010100001100000000000
`define		vfnmadd_vf_operation_vector			29'b00011000010100001100000000000
`define		vfmsub_vv_operation_vector			29'b00011000010100001100000000000
`define		vfmsub_vf_operation_vector			29'b00011000010100001100000000000
`define		vfnmsub_vv_operation_vector			29'b00011000010100001100000000000
`define		vfnmsub_vf_operation_vector			29'b00011000010100001100000000000
`define		vfwmacc_vv_operation_vector			29'b00011000010100001100000000000
`define		vfwmacc_vf_operation_vector			29'b00011000010100001100000000000
`define		vfwnmacc_vv_operation_vector		29'b00011000010100001100000000000
`define		vfwnmacc_vf_operation_vector		29'b00011000010100001100000000000
`define		vfwmsac_vv_operation_vector			29'b00011000010100001100000000000
`define		vfwmsac_vf_operation_vector			29'b00011000010100001100000000000
`define		vfwnmsac_vv_operation_vector		29'b00011000010100001100000000000
`define		vfwnmsac_vf_operation_vector		29'b00011000010100001100000000000
`define		vfsqrt_v_operation_vector			29'b00111000010100001100000000000
`define		vfrsqrt7_v_operation_vector			29'b00111000010100001100000000000
`define		vfrec7_v_operation_vector			29'b00111000010100001100000000000
`define		vfmin_vv_operation_vector			29'b00011000010100001100000000000
`define		vfmin_vf_operation_vector			29'b00011000010100001100000000000
`define		vfmax_vv_operation_vector			29'b00011000010100001100000000000
`define		vfmax_vf_operation_vector			29'b00011000010100001100000000000
`define		vfsgnj_vv_operation_vector			29'b00011000010100001100000000000
`define		vfsgnj_vf_operation_vector			29'b00011000010100001100000000000
`define		vfsgnjn_vv_operation_vector			29'b00011000010100001100000000000
`define		vfsgnjn_vf_operation_vector			29'b00011000010100001100000000000
`define		vfsgnjx_vv_operation_vector			29'b00011000010100001100000000000
`define		vfsgnjx_vf_operation_vector			29'b00011000010100001100000000000
`define		vmfeq_vv_operation_vector			29'b00011000010100001100000000000
`define		vmfeq_vf_operation_vector			29'b00011000010100001100000000000
`define		vmfne_vv_operation_vector			29'b00011000010100001100000000000
`define		vmfne_vf_operation_vector			29'b00011000010100001100000000000
`define		vmflt_vv_operation_vector			29'b00011000010100001100000000000
`define		vmflt_vf_operation_vector			29'b00011000010100001100000000000
`define		vmfle_vv_operation_vector			29'b00011000010100001100000000000
`define		vmfle_vf_operation_vector			29'b00011000010100001100000000000
`define		vmfgt_vf_operation_vector			29'b00011000010100001100000000000
`define		vmfge_vf_operation_vector			29'b00011000010100001100000000000
`define		vfclass_v_operation_vector			29'b00111000010100001100000000000
`define		vfmerge_vfm_operation_vector		29'b00010000010100001100000000000
`define		vfmv_v_f_operation_vector			29'b01010000010100001100000000000
`define		vfcvt_xu_f_v_operation_vector		29'b00111000010100001100000000000
`define		vfcvt_x_f_v_operation_vector		29'b00111000010100001100000000000
`define		vfcvt_rtz_xu_f_v_operation_vector	29'b00111000010100001100000000000
`define		vfcvt_rtz_x_f_v_operation_vector	29'b00111000010100001100000000000
`define		vfcvt_f_xu_v_operation_vector		29'b00111000001100001100000000000
`define		vfcvt_f_x_v_operation_vector		29'b00111100001100001100000000000
`define		vfwcvt_xu_f_v_operation_vector		29'b00111000010100001100000000000
`define		vfwcvt_x_f_v_operation_vector		29'b00111000010100001100000000000
`define		vfwcvt_rtz_xu_f_v_operation_vector	29'b00111000010100001100000000000
`define		vfwcvt_rtz_x_f_v_operation_vector	29'b00111000010100001100000000000
`define		vfwcvt_f_f_v_operation_vector		29'b00111000010100001100000000000
`define		vfncvt_xu_f_w_operation_vector		29'b00111000010100001100000000000
`define		vfncvt_x_f_w_operation_vector		29'b00111000010100001100000000000
`define		vfncvt_rtz_xu_f_w_operation_vector	29'b00111000010100001100000000000
`define		vfncvt_rtz_x_f_w_operation_vector	29'b00111000010100001100000000000
`define		vfncvt_f_xu_w_operation_vector		29'b00111000010100001100000000000
`define		vfncvt_f_x_w_operation_vector		29'b00111000010100001100000000000
`define		vfncvt_f_f_w_operation_vector		29'b00111000010100001100000000000
`define		vfncvt_rod_f_f_w_operation_vector	29'b00111000010100001100000000000
`define		vfwcvt_f_xu_v_operation_vector		29'b00111000001100001100000000000
`define		vfwcvt_f_x_v_operation_vector		29'b00111100001100001100000000000
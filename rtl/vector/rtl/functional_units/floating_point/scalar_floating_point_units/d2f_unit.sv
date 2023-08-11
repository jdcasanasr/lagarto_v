import lagarto_fpu_pkg::*;

module	d2f_unit	(
	input	unit_input_t	unit_input_i,
	output	unit_output_t	unit_output_o
);

fp_t						op;
sfp_encoding_t				result;
fp_status_flags				status;
fp_class_t					dfp_class;
reg	[DFP_EXPONENT_BITS-1:0]	exp_effective;
reg	[DFP_EXPONENT_BITS-1:0]	dif;

assign	op.sign			=	unit_input_i.operand_a[63];
assign	op.exp			=	unit_input_i.operand_a[62:52];
assign	op.mnt			=	unit_input_i.operand_a[51:0];

classifier_DFP DFP_class
(
  .fp_operand_i	(op),
  .fp_class_o	(dfp_class)
);

always	@	(*)
begin
	case	(dfp_class)
		POS_INFINITY,NEG_INFINITY	:	begin
			result.sign	=	op.sign;
			result.exp	=	{SFP_EXPONENT_BITS{1'b1}};
			result.mnt	=	{SFP_MANTISSA_BITS{1'b0}};
		end
		POS_ZERO,NEG_ZERO			:	begin
			result.sign	=	op.sign;
			result.exp	=	{SFP_EXPONENT_BITS{1'b0}};
			result.mnt	=	{SFP_MANTISSA_BITS{1'b0}};
		end
		SNAN,QNAN					:	begin
			result.sign	=	op.sign;
			result.exp	=	{SFP_EXPONENT_BITS{1'b1}};
			result.mnt	=	op.mnt[DFP_MANTISSA_BITS-1:DFP_MANTISSA_BITS-SFP_MANTISSA_BITS];
		end
		POS_SUBNORMAL,NEG_SUBNORMAL	:	begin			//underflow to infinite
			result.sign	=	op.sign;
			result.exp	=	{SFP_EXPONENT_BITS{1'b1}};
			result.mnt	=	{SFP_MANTISSA_BITS{1'b0}};
		end
		POS_NORMAL,NEG_NORMAL		:	begin
			exp_effective	=	op.exp	-	896;
			if	(exp_effective	>	254)	begin		//overflow
				result.sign	=	op.sign;
				result.exp	=	{SFP_EXPONENT_BITS{1'b1}};
				result.mnt	=	{SFP_MANTISSA_BITS{1'b0}};
			end
			else	if	(exp_effective	<	0) begin	//underflow to subnormal
				dif			=	896	-	op.exp;
				result.sign	=	op.sign;
				result.exp	=	{SFP_EXPONENT_BITS{1'b0}};
				result.mnt	=	{1'b1,op.mnt[DFP_MANTISSA_BITS-1:DFP_MANTISSA_BITS-SFP_MANTISSA_BITS]}>>dif;
			end	else	begin
				result.sign		=	op.sign;
				result.exp		=	exp_effective[SFP_EXPONENT_BITS-1:0];
				result.mnt		=	op.mnt[DFP_MANTISSA_BITS-1:DFP_MANTISSA_BITS-SFP_MANTISSA_BITS];
			end
		end
	endcase
end

assign	unit_output_o.tag_id	=	'0;
assign	unit_output_o.status	=	status;
assign	unit_output_o.op_ready	=	unit_input_i.op_valid;
assign	unit_output_o.busy		=	'0;
assign	unit_output_o.result	=	{'0,result.sign, result.exp, result.mnt};

endmodule

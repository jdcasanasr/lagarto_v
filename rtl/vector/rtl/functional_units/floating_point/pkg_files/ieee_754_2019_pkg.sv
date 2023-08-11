package ieee_754_2019_pkg;

	parameter IEEE_754_SINGLE_PRECISION_EXPONENT_WIDTH = 8;
	parameter IEEE_754_DOUBLE_PRECISION_EXPONENT_WIDTH = 11;
	parameter IEEE_754_SINGLE_PRECISION_MANTISSA_WIDTH = ;
	parameter IEEE_754_DOUBLE_PRECISION_MANTISSA_WIDTH = ;

	typedef struct packed
	{
		bit 													sign;
		bit [IEEE_754_SINGLE_PRECISION_EXPONENT_WIDTH - 1:0] 	exponent;
		bit [IEEE_754_SINGLE_PRECISION_MANTISSA_WIDTH - 1:0] 	mantissa;
	} ieee_754_single_precision_t;

	typedef struct packed
	{
		bit 													sign;
		bit [IEEE_754_DOUBLE_PRECISION_EXPONENT_WIDTH - 1:0] 	exponent;
		bit [IEEE_754_DOUBLE_PRECISION_MANTISSA_WIDTH - 1:0] 	mantissa;
	} ieee_754_single_precision_t;

endpackage
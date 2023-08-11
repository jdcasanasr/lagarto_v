`include	"../../../includes/riscv_vector.vh"
module vector_logic_unit(
	input						chip_enable_i,
	input			[1:0]		logic_type_i,
	input			[127:0]	vs1_i,
	input			[127:0]	vs2_i,
	output reg	[127:0]	vd_o 
);
	always @(*)
		begin
			if(chip_enable_i)
				case(logic_type_i)
					2'b01:
							vd_o	<=		vs1_i	&	vs2_i;
					2'b10:
							vd_o	<=		vs1_i	|	vs2_i;
					2'b11:
							vd_o	<=		vs1_i ^	vs2_i;
					default:
							vd_o	<=		'b0;
				endcase
			else
				vd_o <=	'b0; 
		end
endmodule
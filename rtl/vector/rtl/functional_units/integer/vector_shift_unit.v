`include	"../../../includes/riscv_vector.vh"
module vector_shift_unit(
	input									chip_enable_i,
	input			[1:0]					shift_type_i,
	input			[2:0]					vsew_i,
	input			[127:0]	vs1_i,
	input			[127:0]	vs2_i,
	output reg	[127:0]	vd_o 
);
wire [127:0]	data_sl;
wire [127:0]	data_sr;
wire [127:0]	data_sra;

always @(*)
	begin
		if(chip_enable_i)
			case(shift_type_i)
				2'b01:
					vd_o = data_sl;
				2'b10:
					vd_o = data_sr;
				2'b11:
					vd_o = data_sra;
				default:
					vd_o = 128'b0;
			endcase
		else
			vd_o = 128'b0;
	end

	shift_left sl(
		.vsew_i		(vsew_i),
		.a				(vs1_i),
		.b				(vs2_i),
		.s				(data_sl)
	);
	
	shift_right sr
	(
		.vsew_i		(vsew_i),
		.a				(vs1_i),
		.b				(vs2_i),
		.s				(data_sr)
	);
	
	shift_right_arithmetic sra
	(
		.vsew_i		(vsew_i),
		.a				(vs1_i),
		.b				(vs2_i),
		.s				(data_sra)
	);
endmodule
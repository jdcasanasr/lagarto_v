module vector_forward(
	input			[4:0]		vrr_vexe_vs1_i,
	input			[4:0]		vrr_vexe_vs2_i,
	input			[4:0]		vexe_vwb_vd_i,
	input			[127:0]		vrr_vexe_dataa_i,
	input			[127:0]		vrr_vexe_datab_i,
	input			[127:0]		wb_vd_data_i,
	output	reg		[127:0]		vd_dataa_o,
	output	reg		[127:0]		vd_datab_o
);
	always @(*)
		begin
			if (vrr_vexe_vs1_i == vexe_vwb_vd_i)
				vd_dataa_o = wb_vd_data_i;
			else
				vd_dataa_o = vrr_vexe_dataa_i;
		end

	always @(*)
		begin
			if (vrr_vexe_vs2_i == vexe_vwb_vd_i)
				vd_datab_o = wb_vd_data_i;
			else
				vd_datab_o = vrr_vexe_datab_i;
		end
endmodule
module decoder (
	decode_i,
	decode_instr_o,
	jal_id_if_o
);
	localparam riscv_pkg_XLEN = 64;
	localparam riscv_pkg_INST_SIZE = 32;
	input wire [291:0] decode_i;
	localparam drac_pkg_REGFILE_WIDTH = 5;
	output reg [358:0] decode_instr_o;
	output reg [64:0] jal_id_if_o;
	wire [63:0] imm_value;
	reg xcpt_illegal_instruction_int;
	reg xcpt_addr_misaligned_int;
	immediate immediate_inst(
		.instr_i(decode_i[227-:32]),
		.imm_o(imm_value)
	);
	function automatic [4:0] sv2v_cast_5;
		input reg [4:0] inp;
		sv2v_cast_5 = inp;
	endfunction
	always @(*) begin
		xcpt_illegal_instruction_int = 1'b0;
		xcpt_addr_misaligned_int = 1'b0;
		decode_instr_o[357-:64] = decode_i[291-:64];
		decode_instr_o[293-:66] = decode_i[194-:66];
		decode_instr_o[358] = decode_i[195];
		decode_instr_o[98-:5] = decode_i[215-:5];
		decode_instr_o[93-:5] = decode_i[220-:5];
		decode_instr_o[88-:5] = decode_i[207-:5];
		decode_instr_o[77] = 1'b0;
		decode_instr_o[76] = 1'b0;
		decode_instr_o[83] = 1'b0;
		decode_instr_o[82] = 1'b0;
		decode_instr_o[81] = 1'b0;
		decode_instr_o[75-:7] = 7'd0;
		decode_instr_o[80-:3] = 3'd0;
		decode_instr_o[68-:64] = imm_value;
		decode_instr_o[3-:3] = decode_i[210-:3];
		decode_instr_o[4] = 1'b0;
		jal_id_if_o[64] = 1'b0;
		jal_id_if_o[63-:riscv_pkg_XLEN] = 64'b0000000000000000000000000000000000000000000000000000000000000000;
		decode_instr_o[0] = 1'b0;
		if (!decode_i[0] && decode_i[195])
			case (decode_i[202-:7])
				7'b0110111: begin
					decode_instr_o[76] = 1'b1;
					decode_instr_o[83] = 1'b1;
					decode_instr_o[98-:5] = 1'sb0;
					decode_instr_o[75-:7] = 7'd5;
				end
				7'b0010111: begin
					decode_instr_o[76] = 1'b1;
					decode_instr_o[83] = 1'b1;
					decode_instr_o[82] = 1'b1;
					decode_instr_o[75-:7] = 7'd0;
				end
				7'b1101111: begin
					decode_instr_o[76] = 1'b1;
					decode_instr_o[77] = 1'b0;
					decode_instr_o[83] = 1'b1;
					decode_instr_o[82] = 1'b1;
					decode_instr_o[75-:7] = 7'd20;
					decode_instr_o[80-:3] = 3'd3;
					xcpt_addr_misaligned_int = |imm_value[1:0];
					jal_id_if_o[64] = !xcpt_addr_misaligned_int & decode_i[195];
					jal_id_if_o[63-:riscv_pkg_XLEN] = imm_value + decode_i[291-:64];
				end
				7'b1100111: begin
					decode_instr_o[76] = 1'b1;
					decode_instr_o[77] = 1'b1;
					decode_instr_o[83] = 1'b1;
					decode_instr_o[82] = 1'b1;
					decode_instr_o[75-:7] = 7'd19;
					decode_instr_o[80-:3] = 3'd3;
					if (decode_i[210-:3] != 'h0)
						xcpt_illegal_instruction_int = 1'b1;
				end
				7'b1100011: begin
					decode_instr_o[76] = 1'b0;
					decode_instr_o[77] = 1'b1;
					decode_instr_o[83] = 1'b1;
					decode_instr_o[82] = 1'b1;
					decode_instr_o[80-:3] = 3'd3;
					case (decode_i[210-:3])
						3'b000: decode_instr_o[75-:7] = 7'd17;
						3'b001: decode_instr_o[75-:7] = 7'd18;
						3'b100: decode_instr_o[75-:7] = 7'd13;
						3'b101: decode_instr_o[75-:7] = 7'd15;
						3'b110: decode_instr_o[75-:7] = 7'd14;
						3'b111: decode_instr_o[75-:7] = 7'd16;
						default: xcpt_illegal_instruction_int = 1'b1;
					endcase
				end
				7'b0000011: begin
					decode_instr_o[76] = 1'b1;
					decode_instr_o[83] = 1'b1;
					decode_instr_o[80-:3] = 3'd4;
					case (decode_i[210-:3])
						3'b000: decode_instr_o[75-:7] = 7'd50;
						3'b001: decode_instr_o[75-:7] = 7'd47;
						3'b010: decode_instr_o[75-:7] = 7'd44;
						3'b011: decode_instr_o[75-:7] = 7'd42;
						3'b100: decode_instr_o[75-:7] = 7'd52;
						3'b101: decode_instr_o[75-:7] = 7'd48;
						3'b110: decode_instr_o[75-:7] = 7'd45;
						default: xcpt_illegal_instruction_int = 1'b1;
					endcase
				end
				7'b0100011: begin
					decode_instr_o[76] = 1'b0;
					decode_instr_o[83] = 1'b1;
					decode_instr_o[80-:3] = 3'd4;
					case (decode_i[210-:3])
						3'b000: decode_instr_o[75-:7] = 7'd51;
						3'b001: decode_instr_o[75-:7] = 7'd49;
						3'b010: decode_instr_o[75-:7] = 7'd46;
						3'b011: decode_instr_o[75-:7] = 7'd43;
						default: xcpt_illegal_instruction_int = 1'b1;
					endcase
				end
				7'b0101111: begin
					decode_instr_o[76] = 1'b1;
					decode_instr_o[83] = 1'b0;
					decode_instr_o[80-:3] = 3'd4;
					case (decode_i[210-:3])
						3'b010:
							case (sv2v_cast_5(decode_i[227-:7] >> 2))
								5'b00010:
									if (decode_i[220-:5] != 'h0)
										xcpt_illegal_instruction_int = 1'b1;
									else
										decode_instr_o[75-:7] = 7'd53;
								5'b00011: decode_instr_o[75-:7] = 7'd55;
								5'b00001: decode_instr_o[75-:7] = 7'd57;
								5'b00000: decode_instr_o[75-:7] = 7'd58;
								5'b00100: decode_instr_o[75-:7] = 7'd61;
								5'b01100: decode_instr_o[75-:7] = 7'd59;
								5'b01000: decode_instr_o[75-:7] = 7'd60;
								5'b10000: decode_instr_o[75-:7] = 7'd64;
								5'b10100: decode_instr_o[75-:7] = 7'd62;
								5'b11000: decode_instr_o[75-:7] = 7'd65;
								5'b11100: decode_instr_o[75-:7] = 7'd63;
								default: xcpt_illegal_instruction_int = 1'b1;
							endcase
						3'b011:
							case (decode_i[227:223])
								5'b00010:
									if (decode_i[220-:5] != 'h0)
										xcpt_illegal_instruction_int = 1'b1;
									else
										decode_instr_o[75-:7] = 7'd54;
								5'b00011: decode_instr_o[75-:7] = 7'd56;
								5'b00001: decode_instr_o[75-:7] = 7'd66;
								5'b00000: decode_instr_o[75-:7] = 7'd67;
								5'b00100: decode_instr_o[75-:7] = 7'd70;
								5'b01100: decode_instr_o[75-:7] = 7'd68;
								5'b01000: decode_instr_o[75-:7] = 7'd69;
								5'b10000: decode_instr_o[75-:7] = 7'd73;
								5'b10100: decode_instr_o[75-:7] = 7'd71;
								5'b11000: decode_instr_o[75-:7] = 7'd74;
								5'b11100: decode_instr_o[75-:7] = 7'd72;
								default: xcpt_illegal_instruction_int = 1'b1;
							endcase
						default: xcpt_illegal_instruction_int = 1'b1;
					endcase
				end
				7'b0010011: begin
					decode_instr_o[83] = 1'b1;
					decode_instr_o[76] = 1'b1;
					case (decode_i[210-:3])
						3'b000: decode_instr_o[75-:7] = 7'd0;
						3'b010: decode_instr_o[75-:7] = 7'd21;
						3'b011: decode_instr_o[75-:7] = 7'd22;
						3'b100: decode_instr_o[75-:7] = 7'd4;
						3'b110: decode_instr_o[75-:7] = 7'd5;
						3'b111: decode_instr_o[75-:7] = 7'd6;
						3'b001: begin
							decode_instr_o[75-:7] = 7'd9;
							if ((decode_i[227-:7] >> 1) != (7'b0000000 >> 1))
								xcpt_illegal_instruction_int = 1'b1;
							else
								xcpt_illegal_instruction_int = 1'b0;
						end
						3'b101:
							case (decode_i[227-:7] >> 1)
								7'b0100000 >> 1: decode_instr_o[75-:7] = 7'd7;
								7'b0000000 >> 1: decode_instr_o[75-:7] = 7'd8;
								default: xcpt_illegal_instruction_int = 1'b1;
							endcase
					endcase
				end
				7'b0110011: begin
					decode_instr_o[76] = 1'b1;
					case ({decode_i[227-:7], decode_i[210-:3]})
						10'b0000000000: decode_instr_o[75-:7] = 7'd0;
						10'b0100000000: decode_instr_o[75-:7] = 7'd1;
						10'b0000000001: decode_instr_o[75-:7] = 7'd9;
						10'b0000000010: decode_instr_o[75-:7] = 7'd21;
						10'b0000000011: decode_instr_o[75-:7] = 7'd22;
						10'b0000000100: decode_instr_o[75-:7] = 7'd4;
						10'b0000000101: decode_instr_o[75-:7] = 7'd8;
						10'b0100000101: decode_instr_o[75-:7] = 7'd7;
						10'b0000000110: decode_instr_o[75-:7] = 7'd5;
						10'b0000000111: decode_instr_o[75-:7] = 7'd6;
						10'b0000001000: begin
							decode_instr_o[75-:7] = 7'd75;
							decode_instr_o[80-:3] = 3'd2;
						end
						10'b0000001001: begin
							decode_instr_o[75-:7] = 7'd76;
							decode_instr_o[80-:3] = 3'd2;
						end
						10'b0000001010: begin
							decode_instr_o[75-:7] = 7'd78;
							decode_instr_o[80-:3] = 3'd2;
						end
						10'b0000001011: begin
							decode_instr_o[75-:7] = 7'd77;
							decode_instr_o[80-:3] = 3'd2;
						end
						10'b0000001100: begin
							decode_instr_o[75-:7] = 7'd80;
							decode_instr_o[80-:3] = 3'd1;
							decode_instr_o[4] = 1'b1;
						end
						10'b0000001101: begin
							decode_instr_o[75-:7] = 7'd81;
							decode_instr_o[80-:3] = 3'd1;
						end
						10'b0000001110: begin
							decode_instr_o[75-:7] = 7'd84;
							decode_instr_o[80-:3] = 3'd1;
							decode_instr_o[4] = 1'b1;
						end
						10'b0000001111: begin
							decode_instr_o[75-:7] = 7'd85;
							decode_instr_o[80-:3] = 3'd1;
						end
						default: xcpt_illegal_instruction_int = 1'b1;
					endcase
				end
				7'b0011011: begin
					decode_instr_o[83] = 1'b1;
					decode_instr_o[76] = 1'b1;
					decode_instr_o[81] = 1'b1;
					case (decode_i[210-:3])
						3'b000: decode_instr_o[75-:7] = 7'd2;
						3'b001: begin
							decode_instr_o[75-:7] = 7'd11;
							if (decode_i[227-:7] != 7'b0000000)
								xcpt_illegal_instruction_int = 1'b1;
							else
								xcpt_illegal_instruction_int = 1'b0;
						end
						3'b101:
							case (decode_i[227-:7])
								7'b0100000: decode_instr_o[75-:7] = 7'd12;
								7'b0000000: decode_instr_o[75-:7] = 7'd10;
								default: xcpt_illegal_instruction_int = 1'b1;
							endcase
						default: xcpt_illegal_instruction_int = 1'b1;
					endcase
				end
				7'b0111011: begin
					decode_instr_o[76] = 1'b1;
					decode_instr_o[81] = 1'b1;
					case ({decode_i[227-:7], decode_i[210-:3]})
						10'b0000000000: decode_instr_o[75-:7] = 7'd2;
						10'b0100000000: decode_instr_o[75-:7] = 7'd3;
						10'b0000000001: decode_instr_o[75-:7] = 7'd11;
						10'b0000000101: decode_instr_o[75-:7] = 7'd10;
						10'b0100000101: decode_instr_o[75-:7] = 7'd12;
						10'b0000001000: begin
							decode_instr_o[75-:7] = 7'd79;
							decode_instr_o[80-:3] = 3'd2;
						end
						10'b0000001100: begin
							decode_instr_o[75-:7] = 7'd82;
							decode_instr_o[80-:3] = 3'd1;
							decode_instr_o[4] = 1'b1;
						end
						10'b0000001101: begin
							decode_instr_o[75-:7] = 7'd83;
							decode_instr_o[80-:3] = 3'd1;
						end
						10'b0000001110: begin
							decode_instr_o[75-:7] = 7'd86;
							decode_instr_o[80-:3] = 3'd1;
							decode_instr_o[4] = 1'b1;
						end
						10'b0000001111: begin
							decode_instr_o[75-:7] = 7'd87;
							decode_instr_o[80-:3] = 3'd1;
						end
						default: xcpt_illegal_instruction_int = 1'b1;
					endcase
				end
				7'b0001111:
					case (decode_i[210-:3])
						3'b000: begin
							decode_instr_o[75-:7] = 7'd29;
							decode_instr_o[0] = 1'b1;
						end
						3'b001: begin
							decode_instr_o[75-:7] = 7'd30;
							decode_instr_o[0] = 1'b1;
						end
						default: xcpt_illegal_instruction_int = 1'b1;
					endcase
				7'b1110011: begin
					decode_instr_o[83] = 1'b1;
					decode_instr_o[76] = 1'b1;
					decode_instr_o[80-:3] = 3'd6;
					case (decode_i[210-:3])
						3'b000: begin
							decode_instr_o[76] = 1'b0;
							if (decode_i[207-:5] != 'h0)
								xcpt_illegal_instruction_int = 1'b1;
							else
								case (decode_i[227-:7])
									7'b0000000:
										if (decode_i[215-:5] != 'h0)
											xcpt_illegal_instruction_int = 1'b1;
										else
											case (decode_i[220-:5])
												5'b00000: begin
													decode_instr_o[75-:7] = 7'd26;
													decode_instr_o[0] = 1'b1;
												end
												5'b00001: begin
													decode_instr_o[75-:7] = 7'd27;
													decode_instr_o[0] = 1'b1;
												end
												5'b00010: begin
													decode_instr_o[75-:7] = 7'd25;
													decode_instr_o[0] = 1'b1;
												end
												default: xcpt_illegal_instruction_int = 1'b1;
											endcase
									7'b0001000:
										if (decode_i[215-:5] != 'h0)
											xcpt_illegal_instruction_int = 1'b1;
										else
											case (decode_i[220-:5])
												5'b00010: begin
													decode_instr_o[75-:7] = 7'd24;
													decode_instr_o[0] = 1'b1;
												end
												5'b00101: begin
													decode_instr_o[75-:7] = 7'd28;
													decode_instr_o[0] = 1'b1;
												end
												5'b00001: begin
													decode_instr_o[75-:7] = 7'd31;
													decode_instr_o[0] = 1'b1;
												end
												default: xcpt_illegal_instruction_int = 1'b1;
											endcase
									7'b0011000:
										if (decode_i[215-:5] != 'h0)
											xcpt_illegal_instruction_int = 1'b1;
										else
											case (decode_i[220-:5])
												5'b00010: begin
													decode_instr_o[75-:7] = 7'd23;
													decode_instr_o[0] = 1'b1;
												end
												default: xcpt_illegal_instruction_int = 1'b1;
											endcase
									7'b0001001: begin
										decode_instr_o[75-:7] = 7'd31;
										decode_instr_o[0] = 1'b1;
									end
									default: xcpt_illegal_instruction_int = 1'b1;
								endcase
						end
						3'b001: begin
							decode_instr_o[75-:7] = 7'd36;
							decode_instr_o[0] = 1'b1;
						end
						3'b010: begin
							decode_instr_o[75-:7] = 7'd37;
							decode_instr_o[0] = 1'b1;
						end
						3'b011: begin
							decode_instr_o[75-:7] = 7'd38;
							decode_instr_o[0] = 1'b1;
						end
						3'b101: begin
							decode_instr_o[75-:7] = 7'd39;
							decode_instr_o[0] = 1'b1;
						end
						3'b110: begin
							decode_instr_o[75-:7] = 7'd40;
							decode_instr_o[0] = 1'b1;
						end
						3'b111: begin
							decode_instr_o[75-:7] = 7'd41;
							decode_instr_o[0] = 1'b1;
						end
						default: xcpt_illegal_instruction_int = 1'b1;
					endcase
				end
				default: xcpt_illegal_instruction_int = 1'b1;
			endcase
	end
	function automatic [63:0] sv2v_cast_93998;
		input reg [63:0] inp;
		sv2v_cast_93998 = inp;
	endfunction
	always @(*)
		if (!decode_i[0]) begin
			if (xcpt_addr_misaligned_int) begin
				decode_instr_o[99] = 1'b1;
				decode_instr_o[227-:64] = sv2v_cast_93998(64'h0000000000000000);
				decode_instr_o[163-:64] = jal_id_if_o[63-:riscv_pkg_XLEN];
			end
			else if (xcpt_illegal_instruction_int) begin
				decode_instr_o[99] = 1'b1;
				decode_instr_o[227-:64] = sv2v_cast_93998(64'h0000000000000002);
				decode_instr_o[163-:64] = 'h0;
			end
			else begin
				decode_instr_o[99] = 'h0;
				decode_instr_o[227-:64] = sv2v_cast_93998(64'h00000000000000ff);
				decode_instr_o[163-:64] = 'h0;
			end
		end
		else
			decode_instr_o[227-:129] = decode_i[128-:129];
endmodule
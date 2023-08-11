/*******************************************************************************************************************/
/*| TITLE      |  LAGARTO FPU: Rounding Unit                                                                      |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| FILE       |  lagarto_fpu_rm.sv                                                                               |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| LANGUAGE   |  System Verilog                                                                                  |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| PROJECT    |  LAGARTO : https://www.proyectos.cic.ipn.mx/index.php/lagarto                                    |*/
/*|            |  BSC Projects (add here new projects)                                                            |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| REVISION   |  0.1 - MIPS FPU implementation Jun 2015                                                          |*/
/*|            |  0.2 - RISCV FPU Update - November 2021                                                          |*/
/*|            |                                                                                                  |*/
/*|---------------------------------------------------------------------------------------------------------------|*/
/*| AUTHOR(S)                                   | E-MAIL(S)                                                       |*/
/*|---------------------------------------------|-----------------------------------------------------------------|*/
/*| (CR) Cristóbal Ramírez Lazo                 | cristobal.ramirez@bsc.es, cristobal.ramirez.lazo@gmail.com      |*/
/*|---------------------------------------------|-----------------------------------------------------------------|*/
/*| COLABORATOR(S)                              | E-MAIL(S)                                                       |*/
/*|---------------------------------------------|-----------------------------------------------------------------|*/
/*|                                             |                                                                 |*/
/*|                                             |                                                                 |*/
/*|---------------------------------------------------------------------------------------------------------------|*/
/*| Copyright (c) 2021                                                                                            |*/
/*|     Centro de Investigación en Computación - IPN, Mexico,                                                     |*/
/*|     Barcelona Supercomputing Center - BSC, Spain.                                                             |*/
/*| All rights reserved. See LICENCE for license details.                                                         |*/
/*******************************************************************************************************************/

import lagarto_fpu_pkg::*;

module lagarto_fpu_rm (
	input fp_rounding_mode round,
	input logic	sign,
	input logic [11:0] exponent,
	input logic [54:0] mantisa,
	output logic sign_out,
	output logic [11:0] exponent_out,
	output logic [54:0] mantisa_out,
	output logic overflow_o
);

  // Rounding modes
  // RNE = 3'b000, // Round to Nearest, ties to Even
  // RTZ = 3'b001, // Round towards Zero
  // RDN = 3'b010, // Round Down (towards −∞)
  // RUP = 3'b011, // Round Up (towards +∞)
  // RMM = 3'b100, // Round to Nearest, ties to Max Magnitude
  // DYN = 3'b111  // In instruction’s rm field, selects dynamic rounding mode; In Rounding Mode register, Invalid.

  // G-guard bit, R-round bit, S-sticky bit

// Solo 54 bits. {overflow bit, normalized bit , 52 bit mantisa}
wire [55:0] round_amount;
assign round_amount = 56'b0000000000000000000000000000000000000000000000000000100;
wire [55:0] mantisa_round;
assign mantisa_round = {1'b0,mantisa} + round_amount;

wire [1:0] round_sticky_bits;
assign round_sticky_bits = mantisa[1:0];

reg [55:0] mantisa_rounded;

always_comb begin
	case(round)
		3'b000:		begin// Round to Nearest, ties to Even
						case (round_sticky_bits)
						2'b00: mantisa_rounded = {1'b0,mantisa};
						2'b01: mantisa_rounded = {1'b0,mantisa};
						2'b10: mantisa_rounded = (mantisa[2]) ? mantisa_round : {1'b0,mantisa};
						2'b11: mantisa_rounded = mantisa_round;
						endcase
					end
		3'b001: 	begin//round_to_zero
						mantisa_rounded={1'b0,mantisa};
					end
		3'b010: 	begin//round_up
						if((mantisa[1] | mantisa[0]) & ~sign)
							mantisa_rounded= mantisa_round;
						else
							mantisa_rounded={1'b0,mantisa};
					end
		3'b011:		begin //round_to_Down
						if((mantisa[1] | mantisa[0]) & sign)
							mantisa_rounded= mantisa_round;
						else
							mantisa_rounded={1'b0,mantisa};
					end
		default: 	mantisa_rounded={1'b0,mantisa};
	endcase
end

assign overflow_o = mantisa_rounded[55];

always_comb begin
	if (overflow_o) begin // Si hubo desbordamiento se recorre 1 posición a la derecha y se suma uno en el exponente
		mantisa_out = mantisa_rounded[55:1];
		exponent_out = exponent + 12'b000000000001;
	end else begin
		mantisa_out = mantisa_rounded[54:0];
		exponent_out = exponent;
	end
end

assign sign_out = sign;

endmodule

/*******************************************************************************************************************/
/*| TITLE      |  LAGARTO FPU: Integer multiplier                                                                 |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| FILE       |  lagarto_fp_mantissa_mult.sv                                                       		      |*/
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

import lagarto_fpu_pkg :: *;

module lagarto_fp_mantissa_mult#(
  parameter int unsigned MANTISSA = 53
) (
    input logic                     clk_i,
    input logic                     rstn_i,
    input logic                     lock_i,
    input logic                     flush_i,
    input logic                     op_valid_i,
    input logic   [MANTISSA-1:0]    src1_i,
    input logic   [MANTISSA-1:0]    src2_i,

    output logic                    result_valid_o,
    output logic [(MANTISSA*2)-1:0] result_data_o
);

logic signed [(MANTISSA*2)-1:0]  stg1_result_q;
logic stg1_op_valid_q;

logic signed [(MANTISSA*2)-1:0] mult_aux;
assign mult_aux = src1_i * src2_i;

always @(posedge clk_i, negedge rstn_i) begin
    if (~rstn_i) begin
        stg1_op_valid_q    <= '0;
        stg1_result_q      <= '0;
    end else if (flush_i) begin
        stg1_op_valid_q    <= '0;
        stg1_result_q      <= '0;
    end else if (lock_i) begin
        stg1_op_valid_q    <= stg1_op_valid_q;
        stg1_result_q      <= stg1_result_q;
    end else begin
        stg1_op_valid_q    <= op_valid_i;
        stg1_result_q      <= mult_aux;
    end
end

assign result_valid_o = stg1_op_valid_q;
assign result_data_o = (stg1_op_valid_q) ? stg1_result_q[(MANTISSA*2)-1:0] : '0;

endmodule
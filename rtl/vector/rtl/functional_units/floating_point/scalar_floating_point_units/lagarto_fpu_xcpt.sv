/*******************************************************************************************************************/
/*| TITLE      |  LAGARTO FPU: Exception Unit                                                                     |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| FILE       |  lagarto_fpu_xcpt.sv                                                                             |*/
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


module lagarto_fpu_xcpt (
    input logic [11:0]      exponent_i,
    input logic [54:0]      mantissa_i,
    input logic             overflow_round_i,
    input logic             invalid_operation_i,
    output logic            underflow_o,
    output logic            overflow_o,
    output logic            inexact_o,
    output logic            zero_o
);

logic result_inf_int;
logic denormalized_int;
logic exp_or;
logic mantisa_or;
logic exp_or_inp_neg;

assign exp_or = |exponent_i;
assign exp_or_inp_neg= ~(|(~exponent_i[10:0]));
assign mantisa_or= |mantissa_i[54:2];

//Zero
assign zero_o = ~(mantisa_or || exp_or);

// Overflow Exception
// An Overflow exception is signaled when the magnitude of a rounded floating point result, were the exponent range
// unbounded, is larger than the destination format’s largest finite number.
assign result_inf_int = exp_or_inp_neg | exponent_i[11];
// debe de haber un exponente infinito pero no debe ser una operación invalida
assign overflow_o = result_inf_int & ~invalid_operation_i;

// Inexact Exception
// Supplies a rounded result. If caused by an overflow without the overflow trap enabled,
// supplies the overflowed result.
assign inexact_o=(|mantissa_i[1:0]) | (overflow_round_i & ~overflow_o);

// Underflow Exception
// Supplies a rounded result.
assign denormalized_int = (~(|exponent_i)) & (|mantissa_i);
// Debe cumplir con que sea un número muy pequeño y que sea un resultado inexacto
assign underflow_o = (denormalized_int & inexact_o) | denormalized_int;

endmodule

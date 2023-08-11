/*******************************************************************************************************************/
/*| TITLE      |  LAGARTO FPU: Leading Zero Count                                                                 |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| FILE       |  lagarto_fp_lzc.sv                                                                               |*/
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

module lagarto_fp_lzc(
    input clk,
    input [63:0] A1,
    output reg [5:0] Z1,      // Número de zeros a la izquierda antes del primer 1
    output reg V1            // Si todo el vector es de ceros
);

reg [63:0]A;
always@(*) // posedge clk
begin
A=A1;
end

// Primeros 16 bits 
wire [2:0]Z0_0;
wire V0_0;
LZC_8bits LZC_0_0(A[7:0],Z0_0,V0_0);

wire [2:0]Z0_1;
wire V0_1;
LZC_8bits LZC_0_1(A[15:8],Z0_1,V0_1);

wire [3:0]Z1_0;
wire V1_0;
assign Z1_0[3]= V0_1;
assign Z1_0[2]= Z0_1[2] | ( Z0_0[2] & ~V0_1);
assign Z1_0[1]= Z0_1[1] | ( Z0_0[1] & ~V0_1);
assign Z1_0[0]= Z0_1[0] | ( Z0_0[0] & ~V0_1);
assign V1_0= V0_0 | V0_1;

//----------------------------------------------
// Segundos 16 bits
wire [2:0]Z0_2;
wire V0_2;
LZC_8bits LZC_0_2(A[23:16],Z0_2,V0_2);

wire [2:0]Z0_3;
wire V0_3;
LZC_8bits LZC_0_3(A[31:24],Z0_3,V0_3);

wire [3:0]Z1_1;
wire V1_1;
assign Z1_1[3]= V0_3;
assign Z1_1[2]= Z0_3[2] | ( Z0_2[2] & ~V0_3);
assign Z1_1[1]= Z0_3[1] | ( Z0_2[1] & ~V0_3);
assign Z1_1[0]= Z0_3[0] | ( Z0_2[0] & ~V0_3);
assign V1_1= V0_2 | V0_3;

//----------------------------------------------
// Union de los primeros 32 bits
wire [4:0]Z2_0;
wire V2_0;
assign Z2_0[4]= V1_1;
assign Z2_0[3]= Z1_1[3] | ( Z1_0[3] & ~V1_1);
assign Z2_0[2]= Z1_1[2] | ( Z1_0[2] & ~V1_1);
assign Z2_0[1]= Z1_1[1] | ( Z1_0[1] & ~V1_1);
assign Z2_0[0]= Z1_1[0] | ( Z1_0[0] & ~V1_1);
assign V2_0= V1_0 | V1_1;
//----------------------------------------------
//----------------------------------------------

// Terceros 16 bits 
wire [2:0]Z0_4;
wire V0_4;
LZC_8bits LZC_0_4(A[39:32],Z0_4,V0_4);

wire [2:0]Z0_5;
wire V0_5;
LZC_8bits LZC_0_5(A[47:40],Z0_5,V0_5);

wire [3:0]Z1_2;
wire V1_2;
assign Z1_2[3]= V0_5;
assign Z1_2[2]= Z0_5[2] | ( Z0_4[2] & ~V0_5);
assign Z1_2[1]= Z0_5[1] | ( Z0_4[1] & ~V0_5);
assign Z1_2[0]= Z0_5[0] | ( Z0_4[0] & ~V0_5);
assign V1_2= V0_4 | V0_5;

//----------------------------------------------
// Cuartos 16 bits
wire [2:0]Z0_6;
wire V0_6;
LZC_8bits LZC_0_6(A[55:48],Z0_6,V0_6);

wire [2:0]Z0_7;
wire V0_7;
LZC_8bits LZC_0_7(A[63:56],Z0_7,V0_7);

wire [3:0]Z1_3;
wire V1_3;
assign Z1_3[3]= V0_7;
assign Z1_3[2]= Z0_7[2] | ( Z0_6[2] & ~V0_7);
assign Z1_3[1]= Z0_7[1] | ( Z0_6[1] & ~V0_7);
assign Z1_3[0]= Z0_7[0] | ( Z0_6[0] & ~V0_7);
assign V1_3= V0_6 | V0_7;

//----------------------------------------------
// Union de los segundos 32 bits
wire [4:0]Z2_1;
wire V2_1;
assign Z2_1[4]= V1_3;
assign Z2_1[3]= Z1_3[3] | ( Z1_2[3] & ~V1_3);
assign Z2_1[2]= Z1_3[2] | ( Z1_2[2] & ~V1_3);
assign Z2_1[1]= Z1_3[1] | ( Z1_2[1] & ~V1_3);
assign Z2_1[0]= Z1_3[0] | ( Z1_2[0] & ~V1_3);
assign V2_1= V1_2 | V1_3;
//----------------------------------------------

//----------------------------------------------
// Union de los 64 bits
wire [5:0]Z;
wire  V;	

assign Z[5]= V2_1;
assign Z[4]= Z2_1[4] | ( Z2_0[4] & ~V2_1);
assign Z[3]= Z2_1[3] | ( Z2_0[3] & ~V2_1);
assign Z[2]= Z2_1[2] | ( Z2_0[2] & ~V2_1);
assign Z[1]= Z2_1[1] | ( Z2_0[1] & ~V2_1);
assign Z[0]= Z2_1[0] | ( Z2_0[0] & ~V2_1);
assign V= (V2_0 | V2_1);
//----------------------------------------------
// V=1 contiene algo
// V=0 No contiene nada 
// Restamos 9 a la cuenta total ya que el circuito es de 64 bits y el vector entrante será de solo 55 bits, por lo que sobran 9 bits
wire [5:0]ZF;
wire [5:0]ZFinal;

assign ZF[0]= ~Z[0];
assign ZF[1]= ~Z[1];
assign ZF[2]= ~Z[2];
assign ZF[3]= ~Z[3];
assign ZF[4]= ~Z[4];
assign ZF[5]= ~Z[5];

assign ZFinal= ZF; //(V) ? (ZF-6'b001001):6'b000000; 

always@(*) //posedge clk
begin
Z1=ZFinal;
V1=V;
end

endmodule

//----------------------------------------------
//----------------------------------------------
//----------------------------------------------

module LZC_8bits(
input [7:0]A,
output [2:0]Z,	// Número de zeros a la izquierda antes del primer 1
output V			//Si todo el vector es de ceros
);

wire V1,Z0_1,Z1_1;
assign Z1_1= A[3] | A[2];
assign Z0_1= A[3] | ( A[1] & ~Z1_1);
assign V1 = Z1_1 | (A[0] | A[1]) ;

wire V2,Z0_2,Z1_2;
assign Z1_2= A[7] | A[6];
assign Z0_2= A[7] | ( A[5] & ~Z1_2);
assign V2 = Z1_2| (A[4] | A[5]) ;

wire VN,Z0N,Z1N,Z2N;
assign Z2N= V2;
assign Z1N= Z1_2 | ( Z1_1 & ~V2);
assign Z0N= Z0_2 | ( Z0_1 & ~V2);
assign VN = V1| V2 ;

assign Z[2]= Z2N;
assign Z[1]= Z1N;
assign Z[0]= Z0N;
assign V =VN;

endmodule

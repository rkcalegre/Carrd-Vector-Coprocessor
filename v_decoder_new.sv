//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// v_decoder.sv -- Vector Decoder Unit
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 199 Carrd: RISC-V Vector Coprocessor Group (2SAY2223)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: valu.sv
// Description: This module implements the decoder that translates 32bit vector instructions into
//              their corresponding control signals. Instruction format is based on R RISC-V "V"
//              Vector Extension Version 1.0 Specifications
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//                        
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps

module v_decoder #(
    parameter int OFF = 0
)(
    input [31:0] instr,

    output [3:0] v_alu_op,
    output is_mul,
    output [2:0] v_red_op,
    output [2:0] v_sldu_op
);

    import v_pkg::*;                    // contains constants
    logic [5:0] opcode;
    logic [2:0] funct3;
    logic [5:0] funct6;

    assign opcode = instr[5:0];
    assign funct3 = instr[14:12];
    assign funct6 = instr[31:26];

    //  v_alu_op
    //  1  - vadd
    //  2  - vsub
    //  3  - vand
    //  4  - vor
    //  5  - vxor
    //  6  - vsll
    //  7  - vsrl
    //  8  - vsra
    //  9  - vmin
    //  10 - vmax

    assign v_alu_op = (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI)) ? 
                    ((funct6 == VADD)  ? VALU_VADD : 
                    ((funct6 == VSUB)  ? VALU_SUB  :
                    ((funct6 == VAND)  ? VALU_VAND :
                    ((funct6 == VOR)   ? VALU_VOR  :
                    ((funct6 == VXOR)  ? VALU_VXOR :
                    ((funct6 == VSLL)  ? VALU_VSLL :
                    ((funct6 == VSRL)  ? VALU_VSRA :
                    ((funct6 == VMIN)  ? VALU_VMIN :
                    ((funct6 == VMAX)  ? VALU_VMAX))))))))) : OFF;

    //  is_mul
    //  0  - OFF
    //  1  - vmul

    assign is_mul = (opcode == OPC_RTYPE && funct6 == VMUL) ? 1'b1 : OFF;

    //  v_red_op
    //  1  - vredsum
    //  2  - vredmax

    assign v_red_op = (opcode == OPC_RTYPE && (funct3 == OPM_VV)) ?
                    ((funct6 == VREDSUM) ? VRED_VREDSUM :
                    ((funct6 == VREDMAX) ? VRED_VREDMAX)) : OFF;

    //  v_sldu_op
    //  1  - vslideup
    //  2  - vslidedown
    //  3  - vlslide1up
    //  4  - vslide1down
    //  5  - vmv

    assign v_sldu_op = (opcode == OPC_RTYPE) ?
                        (((funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VSLIDEUP)   ? VSLDU_VSLIDEUP :
                        (((funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VSLIDEDOWN) ? VSLDU_VSLIDEDOWN :
                        ((funct3 == OPM_VX && funct6 == VSLIDE1UP)                        ? VSLDU_VSLIDE1UP :
                        ((funct3 == OPM_VX && funct6 == VSLIDE1DOWN)                      ? VSLDU_VSLIDE1DOWN :
                        ((funct3 == OPI_VX && funct6 == VMV)                              ? VSLDU_VMV))))) : OFF;

endmodule
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

    output is_vconfig,
    output [3:0] v_alu_op,
    output is_mul,
    output [2:0] v_red_op,
    output [2:0] v_sldu_op,
    output [3:0] v_lsu_op,

    output [2:0] v_op_sel_A,
    output [1:0] v_op_sel_B,
    output [1:0] v_sel_dest
);

    import v_pkg::*;                    // contains constants
    logic [5:0] opcode;
    logic [2:0] funct3;
    logic [5:0] funct6;
    logic [2:0] width;
    logic [1:0] mop;

    assign opcode = instr[5:0];
    assign funct3 = instr[14:12];
    assign funct6 = instr[31:26];
    assign width = (opcode == OPC_LTYPE || opcode == OPC_STYPE) ? instr[14:12] : OFF;
    assign mop = (opcode == OPC_LTYPE || opcode == OPC_STYPE) ? instr[27:26] : OFF;

    assign is_vconfig = (opcode == OPC_RTYPE && funct3 == OP_SET);

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

    assign is_mul = (opcode == OPC_RTYPE && funct6 == VMUL && (funct3 == OPM_VV || funct3 == OPM_VX)) ? 1'b1 : OFF;

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

    // v_lsu_op
    // 1 - vle8
    // 2 - vle16
    // 3 - vle32
    // 4 - vlse8
    // 5 - vlse16
    // 6 - vlse32
    // 7 - vse8
    // 8 - vse16
    // 9 - vse32
    // 10 - vsse8
    // 11 - vsse16
    // 12 - vsse32

    assign v_lsu_op = (opcode == OPC_LTYPE && mop == MOP_UNIT_STRIDE && width == WIDTH_8)     ? VLSU_VLE8 :
                        (opcode == OPC_LTYPE && mop == MOP_UNIT_STRIDE && width == WIDTH_16)  ? VLSU_VLE16 :
                        (opcode == OPC_LTYPE && mop == MOP_UNIT_STRIDE && width == WIDTH_32)  ? VLSU_VLE32 :
                        (opcode == OPC_LTYPE && mop == MOP_STRIDED && width == WIDTH_8)       ? VLSU_VLSE8 :
                        (opcode == OPC_LTYPE && mop == MOP_STRIDED && width == WIDTH_16)      ? VLSU_VLSE16 :
                        (opcode == OPC_LTYPE && mop == MOP_STRIDED && width == WIDTH_32)      ? VLSU_VLSE32 :
                        (opcode == OPC_STYPE && mop == MOP_UNIT_STRIDE && width == WIDTH_8)   ? VLSU_VSE8 :
                        (opcode == OPC_STYPE && mop == MOP_UNIT_STRIDE && width == WIDTH_16)  ? VLSU_VSE16 :
                        (opcode == OPC_STYPE && mop == MOP_UNIT_STRIDE && width == WIDTH_32)  ? VLSU_VSE32 :
                        (opcode == OPC_STYPE && mop == MOP_STRIDED && width == WIDTH_8)       ? VLSU_VSSE8 :
                        (opcode == OPC_STYPE && mop == MOP_STRIDED && width == WIDTH_16)      ? VLSU_VSSE16 :
                        (opcode == OPC_STYPE && mop == MOP_STRIDED && width == WIDTH_32)      ? VLSU_VSSE32 : OFF;

    // v_op_sel_A (instr[19:15])
    // 1 - select vs1 
    // 2 - select rs1 
    // 3 - select immediate

    assign v_op_sel_A = (funct3 == OPI_VV || funct3 == OPM_VV)                                                                   ? 2'b01 :
                        (funct3 == OPI_VX || funct3 == OPM_VX || funct3 == OP_SET || opcode == OPC_LTYPE || opcode == OPC_STYPE) ? 2'b10 :
                        (funct3 == OPI_VI)                                                                                       ? 2'b11 : OFF;

    // v_op_sel_B (instr[24:20])
    // 1 - select vs2
    // 2 - rs2 (for load/store strided)
    // 3 - zimm[10:0] (vtype: for vconfig)

    assign v_op_sel_B = (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI || funct3 == OPM_VV || funct3 == OPM_VX) ? 2'b01 :
                        (opcode == OPC_STYPE || opcode == OPC_LTYPE && mop == MOP_STRIDED)                                 ? 2'b10 :
                        (funct3 == OP_SET) 
                                                                                                            ? 2'b11 : OFF;
    // v_sel_dest
    // 1 - select vd
    // 2 - select rd
    assign v_sel_dest = (opcode == OPC_LTYPE || opcode == OPC_STYPE || funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI || funct3 == OPM_VV || funct3 == OPM_VX) ? 2'b01 :
                        (opcode == OP_SET)                                                                                                                               ? 2'b10 : OFF;


endmodule
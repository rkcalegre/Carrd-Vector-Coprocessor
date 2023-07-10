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
    input logic v_reg_wr_en,
    input logic x_reg_wr_en,
    input logic s_done,

    output logic is_vector,
    output logic is_vconfig,
    output logic [3:0] v_alu_op,
    output logic is_mul,
    output logic [2:0] v_red_op,
    output logic [2:0] v_sldu_op,
    output logic [3:0] v_lsu_op,
    //output logic is_vstype,
    //output logic is_vltype,

    output logic [2:0] v_op_sel_A,
    output logic [1:0] v_op_sel_B,
    output logic [1:0] v_sel_dest,
    output logic [4:0] vd,
    output logic [4:0] vs1,
    output logic [4:0] vs2,
    //output logic [4:0] vs3,
    output logic [4:0] imm,
    output logic [10:0] zimm

);

    import v_pkg::*;                    // contains constants
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [5:0] funct6;
    logic [2:0] width;
    logic [1:0] mop;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct6 = instr[31:26];
    assign width = (opcode == OPC_LTYPE || opcode == OPC_STYPE) ? instr[14:12] : OFF;
    assign mop = (opcode == OPC_LTYPE || opcode == OPC_STYPE) ? instr[27:26] : OFF;

    always_comb begin : vDecoder

        is_vconfig = (opcode == OPC_RTYPE && funct3 == OP_SET);
        is_vector = (opcode == OPC_RTYPE || opcode == OPC_LTYPE || opcode == OPC_STYPE);
        
        case (opcode)
            OPC_RTYPE, OPC_LTYPE, OPC_STYPE: begin

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
                //  11 - vmseq
                //  12 - vmsne
                //  13 - vmslt
                //  14 - vmsle
                //  15 - vmsgt

                v_alu_op = (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VADD)  ? VALU_VADD : 
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX                    ) && funct6 == VSUB)  ? VALU_VSUB  :
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VAND)  ? VALU_VAND  :
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VOR)   ? VALU_VOR   :
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VXOR)  ? VALU_VXOR  :
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VSLL)  ? VALU_VSLL  :
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VSRL)  ? VALU_VSRL  :
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VSRA)  ? VALU_VSRA  :
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX                    ) && funct6 == VMIN)  ? VALU_VMIN  :
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX                    ) && funct6 == VMAX)  ? VALU_VMAX  :
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VMSEQ) ? VALU_VMSEQ :
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VMSNE) ? VALU_VMSNE :
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX                    ) && funct6 == VMSLT) ? VALU_VMSLT :
                                (opcode == OPC_RTYPE && (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VMSLE) ? VALU_VMSLE :
                                (opcode == OPC_RTYPE && (                    funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VMSGT) ? VALU_VMSGT : OFF;
                
                //  is_mul
                //  0  - OFF
                //  1  - vmul

                is_mul = (opcode == OPC_RTYPE && funct6 == VMUL && (funct3 == OPM_VV || funct3 == OPM_VX)) ? 1'b1 : OFF;

                //  v_red_op
                //  1  - vredsum
                //  2  - vredmax

                v_red_op = (opcode == OPC_RTYPE && funct3 == OPM_VV && funct6 == VREDSUM) ? VRED_VREDSUM 
                                : (opcode == OPC_RTYPE && funct3 == OPM_VV && funct6 == VREDMAX) ? VRED_VREDMAX : OFF;

                //  v_sldu_op
                //  1  - vslideup
                //  2  - vslidedown
                //  3  - vlslide1up
                //  4  - vslide1down
                //  5  - vmv

                v_sldu_op =  ((opcode == OPC_RTYPE) && (funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VSLIDEUP)   ? VSLDU_VSLIDEUP :
                                    ((opcode == OPC_RTYPE) && (funct3 == OPI_VX || funct3 == OPI_VI) && funct6 == VSLIDEDOWN) ? VSLDU_VSLIDEDOWN :
                                    ((opcode == OPC_RTYPE) && funct3 == OPM_VX && funct6 == VSLIDE1UP)                        ? VSLDU_VSLIDE1UP :
                                    ((opcode == OPC_RTYPE) && funct3 == OPM_VX && funct6 == VSLIDE1DOWN)                      ? VSLDU_VSLIDE1DOWN :
                                    ((opcode == OPC_RTYPE) && (funct3 == OPM_VV || funct3 == OPM_VX) && (funct6 == VMOVE || funct6 == VMOVE1)) ? VSLDU_VMV : OFF;

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

                v_lsu_op = (opcode == OPC_LTYPE && mop == MOP_UNIT_STRIDE && width == WIDTH_8)     ? VLSU_VLE8 :
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

                //is_vstype = (opcode == OPC_STYPE) ? 1'b1 : OFF;
                //is_vltype = (opcode == OPC_LTYPE) ? 1'b1 : OFF;

                // v_op_sel_A (instr[19:15])
                // 1 - select vs1 
                // 2 - select rs1 
                // 3 - select immediate

                v_op_sel_A = ((funct3 == OPI_VV || funct3 == OPM_VV) && !(opcode == OPC_LTYPE || opcode == OPC_STYPE))? 2'b01 :
                                    (funct3 == OPI_VX || funct3 == OPM_VX || funct3 == OP_SET || opcode == OPC_LTYPE || opcode == OPC_STYPE) ? 2'b10 :
                                    (funct3 == OPI_VI)                                                                                       ? 2'b11 : OFF;

                // v_op_sel_B (instr[24:20])
                // 1 - select vs2
                // 2 - rs2 (for load/store strided)
                // 3 - zimm[10:0] (vtype: for vconfig)

                v_op_sel_B = (funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI || funct3 == OPM_VV || funct3 == OPM_VX) ? 2'b01 :
                                    (opcode == OPC_STYPE || opcode == OPC_LTYPE && mop == MOP_STRIDED)                                 ? 2'b10 :
                                    (funct3 == OP_SET) 
                                                                                                                        ? 2'b11 : OFF;
                // v_sel_dest
                // 1 - select vd
                // 2 - select rd
                v_sel_dest = (opcode == OPC_LTYPE || opcode == OPC_STYPE || funct3 == OPI_VV || funct3 == OPI_VX || funct3 == OPI_VI || funct3 == OPM_VV || funct3 == OPM_VX) ? 2'b01 :
                                    (opcode == OP_SET)                                                                                                                               ? 2'b10 : OFF;
                
                vd = instr[11:7];
                //vs1 = (is_vstype == 1) ? instr[11:7] : instr[19:15];
                vs1 = instr[19:15];
                vs2 = instr[24:20];
                //vs3 = instr[11:7];
                imm = instr[19:15];
                zimm = instr[30:20];
            end
            default: begin
                case (v_reg_wr_en || x_reg_wr_en)
                    1'b1: begin
                        is_vconfig = 0;
                        v_alu_op = 0;
                        is_mul = 0;
                        v_red_op = 0;
                        v_sldu_op = 0;
                        v_lsu_op = 0;
                        //is_vltype = 0;
                        //is_vstype = 0;
                    end
                endcase
                if (s_done) begin
                    v_lsu_op = 0;
                    //is_vstype = 0;
                end
            end
        endcase        
    end




endmodule
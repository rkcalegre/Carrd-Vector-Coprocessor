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
//`include "vstructs.sv"

module v_decoder #(
    parameter int OFF_SIGNAL = 0
)(
    input logic [31:0] instr,
    output logic [5:0] v_alu_op,
    output logic [5:0] v_mul_op,
    output logic [5:0] v_lsu_op,
    output logic [5:0] v_sldu_op,
    output logic [5:0] v_red_op,

    output logic [4:0] vrs1,
    output logic [4:0] vrs2,
    output logic [4:0] imm,
    output logic [4:0] vd,
    output logic [4:0] rs2          //for load and store strided instructions

);
    import v_pkg::*;
    logic [6:0] opcode;
    logic [3:0] funct3;
    logic [5:0] funct6;
    logic [1:0] mop;

    logic [4:0] temp_vrs1;
    logic [4:0] temp_vrs2;
    logic [4:0] temp_rs2;
    logic [4:0] temp_imm;
    logic [4:0] temp_vd;
    logic [5:0] temp_op;

    //for load and store instructions
    //logic width_instr; //specifies size of memory elements, and distinguishes from FP scalar
    //logic [4:0] lsumop; // lumop[4:0]/sumop[4:0] are additional field encoding variants of unit-stride instructions


    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct6 = instr[31:26];
    assign mop = instr[27:26];

    always @(*) begin
       case (opcode)                                // determines instruction type (load, store, or arithmetic instructions)
        OPC_LTYPE: begin                            // for load instructions
            case (mop)
                MOP_UNIT_STRIDE: begin
                    /**
                    nf = instr[31:29]; 
                    mew = instr[28]; 
                    vm = instr[25]; 
                    width_instr = instr[14:12];
                    lsumop = instr[24:20];          //lumop=0 if strided or indexed
                    **/ 
                    temp_vd = instr[11:7];          // vd
                    temp_vrs1 = instr[19:15];       // rs1
                    temp_vrs2 = 0;                  //lumop=0
                    temp_rs2 = 0;       
                    temp_op = funct6;
                    
                end
                MOP_STRIDED: begin
                    temp_vd = instr[11:7];          // vd
                    temp_vrs1 = instr[19:15];       // rs1
                    temp_vrs2 = 0;                  
                    temp_rs2 = instr[24:20];        //rs2
                    temp_op = funct6;
                end
                MOP_INDEXED_UNORDERED, MOP_INDEXED_ORDERED: begin
                    temp_vd = instr[11:7];          // vd
                    temp_vrs1 = instr[19:15];       // rs1
                    temp_vrs2 = instr[24:20];       //vs2
                    temp_rs2 = 0;       
                    temp_op = funct6;
                end
            endcase
        end
        OPC_STYPE: begin
            case (mop)
                MOP_UNIT_STRIDE: begin
                    temp_vd = instr[11:7];          // vd
                    temp_vrs1 = instr[19:15];       // rs1
                    temp_vrs2 = 0;                  //lumop=0
                    temp_rs2 = 0;       
                    temp_op = funct6;
                    
                end
                MOP_STRIDED: begin
                    temp_vd = instr[11:7];          // vd
                    temp_vrs1 = instr[19:15];       // rs1
                    temp_vrs2 = 0;                  
                    temp_rs2 = instr[24:20];        //rs2
                    temp_op = funct6;
                end
                MOP_INDEXED_UNORDERED, MOP_INDEXED_ORDERED: begin
                    temp_vd = instr[11:7];          // vd
                    temp_vrs1 = instr[19:15];       // rs1
                    temp_vrs2 = instr[24:20];       //vs2
                    temp_rs2 = 0;       
                    temp_op = funct6;
                end
            endcase 
        end
        OPC_RTYPE: begin
            case (funct3)                           // determines the operand type (VV: vector-vector, VI: vector-imm, VX: vector-scalar)
                OPI_VV: begin
                    temp_vd = instr[11:7];          // vd
                    temp_vrs1 = instr[19:15];       // vs1
                    temp_vrs2 = instr[24:20];       // 
                    temp_rs2 = 0;    
                    temp_imm = 0;
                    temp_op = funct6;
                end
                OPI_VI: begin
                    temp_vd = instr[11:7];          // vd
                    temp_vrs1 = 0;                  
                    temp_vrs2 = instr[24:20];       // vs2
                    temp_rs2 = 0;    
                    temp_imm = instr[19:15];        // imm
                    temp_op = funct6;
                end
                OPI_VX: begin
                    temp_vd = instr[11:7];          // vd
                    temp_vrs1 = instr[19:15];       // rs1
                    temp_vrs2 = instr[24:20];       // vs2
                    temp_rs2 = 0;    
                    temp_imm = 0;
                    temp_op = funct6;
                end 
                OPM_VV: begin
                    temp_vd = instr[11:7];          // vd
                    temp_vrs1 = instr[19:15];       // rs1
                    temp_vrs2 = instr[24:20];       // vs2
                    temp_rs2 = 0;    
                    temp_imm = 0;
                    temp_op = funct6; 
                end
                OPM_VX: begin                       // for Reduction Block
                    temp_vd = instr[11:7];          // vd
                    temp_vrs1 = instr[19:15];       // rs1
                    temp_vrs2 = instr[24:20];       // vs2
                    temp_rs2 = 0;    
                    temp_imm = 0;
                    temp_op = funct6;
                end
                default: begin //for non-implemented instructions //copied from OPM_VV //CAN BE DELETED
                    temp_vd = instr[11:7];          // vd
                    temp_vrs1 = instr[19:15];       // rs1
                    temp_vrs2 = instr[24:20];       // vs2
                    temp_rs2 = 0;    
                    temp_imm = 0;
                    temp_op = funct6; 
                end
            endcase
        end
       endcase 
    end

    assign vd = temp_vd;
    assign vrs1 = temp_vrs1;
    assign vrs2 = temp_vrs2;
    assign rs2 = temp_rs2;
    assign imm = temp_imm;
    assign v_alu_op = (opcode == OPC_RTYPE)? temp_op : OFF_SIGNAL;  // determine anong bit dapat ang magiindicate na no operation ang VALU + IADD NA UNG RED INSTR sa structs na file
    assign v_mul_op = (opcode == OPC_RTYPE)? temp_op : OFF_SIGNAL;  // RTYPE DIN AND MUL HMMM; di ko pa sila na ttake into account sa vstructs keme
    assign v_lsu_op = (opcode == OPC_LTYPE || opcode == OPC_STYPE)? temp_op : OFF_SIGNAL;  
    assign v_sldu_op = (opcode == OPC_RTYPE)? temp_op : OFF_SIGNAL; // TO EDIT: SANG TYPE NG INSTR NAG-FFALL UNG MGA PERMUTATION
    assign v_red_op = (opcode == OPC_RTYPE && funct3 == OPM_VX)? temp_op : OFF_SIGNAL; // TO EDIT: SANG TYPE NG INSTR NAG-FFALL UNG MGA PERMUTATION

endmodule
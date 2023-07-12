//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// v_sequencer.sv -- Sequencer Unit
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 199 Carrd: RISC-V Vector Coprocessor Group (2SAY2223)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: v_sequencer.sv
// Description: The Sequencer -----
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments: how to determine if a slot is filled? (status bit?)
//                      how to fill up the table - do we start at 7 or at 0? use *FIFO*?
//                        
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps

module v_sequencer #(
    parameter int IST_ENTRY_BITS = 40,       // For Instruction Status Table: 6 bits (maybe for opcode?) + 3 bits (instr_status)
    parameter int NO_OF_SLOTS = 8
)(
    input logic clk,
    input logic nrst,
    input logic [31:0] base_instr, 
    input logic [1:0] sel_op_A, sel_op_B, sel_dest, vsew, lmul,
    input logic [4:0] src_A, src_B, dest, imm,
    input logic [3:0] v_alu_op, v_lsu_op,
    input logic [2:0] v_red_op, v_sldu_op,
    input logic is_mul, is_vector, is_vconfig,
    input logic done_alu, done_mul, done_lsu, done_sldu, done_red,
    input logic [127:0] result_valu_1, result_valu_2, result_valu_3, result_valu_4, result_vmul_1, result_vmul_2, result_vmul_3, result_vmul_4, 
    input logic [31:0] result_vred,
    input logic [511:0] result_vsldu, result_vlsu,
    output logic is_vstype, is_vltype,
    output logic [2:0] optype_read,
    output logic [4:0] dest_wb,
    output logic [3:0] op_alu, op_mul, op_lsu, op_sldu, op_red,        // vector operation (6) (decoder)
    output logic [2:0] vsew_alu, vsew_mul, vsew_lsu, vsew_sldu, vsew_red, vsew_wb,      // Functional unit producing Fj (3) 
    output logic [2:0] lmul_alu, lmul_mul, lmul_lsu, lmul_sldu, lmul_red, lmul_wb,      // Functional unit producing Fk(3) (is_type)
    output logic [2:0] Qj_alu, Qj_mul, Qj_lsu, Qj_sldu, Qj_red, Qi_lsu,       // Functional unit producing Fj (3) 
    output logic [2:0] Qk_alu, Qk_mul, Qk_lsu, Qk_sldu, Qk_red, Qi_sldu,      // Functional unit producing Fk(3) (is_type)
    output logic [4:0] Fj_alu, Fj_mul, Fj_lsu, Fj_sldu, Fj_red,        // source register 1 (5) (decoder)
    output logic [4:0] Fk_alu, Fk_mul, Fk_lsu, Fk_sldu, Fk_red,        // source register 2 (5) (decoder)
    output logic [4:0] Fi_lsu, Fi_sldu,      // destination reg (5) (decoder)
    output logic [4:0] Imm_alu, Imm_mul, Imm_lsu, Imm_sldu, Imm_red,  // scalar operand (5) (decoder)
    output logic v_reg_wr_en, x_reg_wr_en, el_wr_en,
    output logic [127:0]  reg_wr_data, reg_wr_data_2, reg_wr_data_3, reg_wr_data_4,
    //output logic busy_alu, busy_mul, busy_lsu, busy_sldu, busy_red,
    output logic [5:0] el_wr_addr
);



    //***************************FU Status Guide***********************************//
    // 000 - VRF
    // 001 = VALU
    // 010 = VMUL
    // 011 = VLSU
    // 100 = VSLDU
    // 101 = VRED
    // 111 = default off

    //Instructions
    // 2 bit sel_dest [39:38]
    // 2 bit vsew [37:36]
    // 2 bit lmul [35:34]
    // 2 bit sel_op_A [33:32]
    // 2 bit sel_op_B [31:30]
    // 3 bits operation type [29:27]
    // 4 bits operation [26:23]
    // 5 bits src_A [22:18]
    // 5 bits src_B [17:13] 
    // 5 bits dest [12:8]
    // 5 bits immediate [7:3]
    // 3 bits instr status [2:0]
    
    //*************************** INSTRUCTION STATUS BLOCK *************************************//
    // contains 8 slots used for keeping track of instructions
    // executing within the pipeline, specifically the stage each instruction is currently in.
    // Represented by 3 bits to denote each stage:
    // 3'b001 - issue stage (vIS)
    // 3'b010 - read operands stage
    // 3'b011 - execution stage (vEX)
    // 3'b100 - writes results stage 
    // 3'b000 - default value

    // uses v1 format of table
    logic [IST_ENTRY_BITS-1:0] instr_status_table [0:NO_OF_SLOTS-1];         // instruction status table
    logic [3:0] fifo_count;                                                  // keeps track of # of instructions currently in the table
    logic [2:0] op;
    logic [3:0] op_instr; 
    logic busy_alu/*  = 0 */;
    logic busy_mul/*  = 0 */;
    logic busy_lsu/*  = 0 */;
    logic busy_sldu/*  = 0 */;
    logic busy_red/*  = 0 */; 
    logic Rj_alu = 0;            // indicates if Fj is available (1),
    logic Rj_mul = 0;
    logic Rj_lsu = 0;
    logic Rj_sldu = 0;
    logic Rj_red = 0;
    logic Rk_alu = 0;             // indicates if Fk is available (1)
    logic Rk_mul = 0; 
    logic Rk_lsu = 0; 
    logic Rk_sldu = 0; 
    logic Rk_red = 0; 
    logic Ri_lsu = 0;
    logic [5:0] Fi_alu = 0;
    logic [5:0] Fi_mul = 0;
    logic [5:0] Fi_red = 0;
    logic [IST_ENTRY_BITS-1:0] instr_1;
    logic [IST_ENTRY_BITS-1:0] instr_2; 
    logic [IST_ENTRY_BITS-1:0] instr_3; 
    logic [IST_ENTRY_BITS-1:0] instr_4; 
    logic [IST_ENTRY_BITS-1:0] instr_5; 
    logic [IST_ENTRY_BITS-1:0] instr_6; 
    logic [IST_ENTRY_BITS-1:0] instr_7;
    logic [IST_ENTRY_BITS-1:0] instr_8; // IST  
    logic [IST_ENTRY_BITS-1:0] instr_read; 
    logic [IST_ENTRY_BITS-1:0] alu_read, mul_read, lsu_read, sldu_read, red_read;
    logic [IST_ENTRY_BITS-1:0] alu_exec; 
    logic [IST_ENTRY_BITS-1:0] mul_exec; 
    logic [IST_ENTRY_BITS-1:0] lsu_exec; 
    logic [IST_ENTRY_BITS-1:0] sldu_exec; 
    logic [IST_ENTRY_BITS-1:0] red_exec; 
    logic [IST_ENTRY_BITS-1:0] wb_instr = 0;
    logic [2:0] instr_read_index; 
    logic [2:0] alu_read_index; 
    logic [2:0] mul_read_index; 
    logic [2:0] lsu_read_index;
    logic [2:0] sldu_read_index; 
    logic [2:0] red_read_index; 
    logic [2:0] alu_exec_index; 
    logic [2:0] mul_exec_index; 
    logic [2:0] lsu_exec_index; 
    logic [2:0] sldu_exec_index; 
    logic [2:0] red_exec_index; 
    logic [2:0] wb_instr_index = 0;
    logic [2:0] sel_dest_alu = 0; 
    logic [2:0] sel_dest_mul = 0; 
    logic [2:0] sel_dest_lsu = 0; 
    logic [2:0] sel_dest_sldu = 0; 
    logic [2:0] sel_dest_red = 0;
    logic wr_alu = 0;
    logic wr_mul = 0; 
    logic wr_lsu = 0; 
    logic wr_sldu = 0; 
    logic wr_red = 0;
    logic lsu_raw;
    logic [5:0] dest_1, dest_2, dest_3, dest_4, dest_5, dest_6, dest_7, dest_8;
    logic opA_1;
    logic opA_2; 
    logic opA_3;
    logic opA_4;
    logic opA_5;
    logic opA_6; 
    logic opA_7;
    logic opA_8;
    logic opB_1;
    logic opB_2; 
    logic opB_3;
    logic opB_4;
    logic opB_5;
    logic opB_6; 
    logic opB_7;
    logic opB_8;
    logic opC_1;
    logic opC_2; 
    logic opC_3;
    logic opC_4;
    logic opC_5;
    logic opC_6; 
    logic opC_7;
    logic opC_8;
    logic write = 0;

// input
    assign fifo_full = (fifo_count == NO_OF_SLOTS);
    assign instr_1 = instr_status_table[0];
    assign instr_2 = instr_status_table[1];
    assign instr_3 = instr_status_table[2];
    assign instr_4 = instr_status_table[3];
    assign instr_5 = instr_status_table[4];
    assign instr_6 = instr_status_table[5];
    assign instr_7 = instr_status_table[6];
    assign instr_8 = instr_status_table[7];
    assign fifo_count = instr_1 == 0 ? 4'b0000: instr_2 == 0 ? 4'b0001: instr_3 == 0 ? 4'b0010: instr_4 == 0 ? 4'b0011: instr_5 == 0 ? 4'b0100: instr_6 == 0 ? 4'b0101: instr_7 == 0 ? 4'b0110: instr_8 == 0 ? 4'b0111: 4'b1000;

//issue
    assign op = (v_alu_op != 0) ? 3'b001: (is_mul != 0) ? 3'b010: v_lsu_op != 0 ? 3'b011: (v_sldu_op != 0) ? 3'b100: (v_red_op != 0) ? 3'b101:3'b000;
    assign op_instr = op == 3'b001 ? v_alu_op: op == 3'b010 ? is_mul: op == 3'b011 ? v_lsu_op: op == 3'b100 ? v_sldu_op: 3'b101 ? v_red_op: 0;
    assign dest_1 = (instr_1[29:27] != 3'b011 && (instr_1[26:23] inside {[7:12]} != 0)) ? {1'b1, instr_1[12:8]}: {1'b0, instr_1[12:8]};
    assign dest_2 = (instr_2[29:27] != 3'b011 && (instr_2[26:23] inside {[7:12]} != 0)) ? {1'b1, instr_2[12:8]}: {1'b0, instr_2[12:8]};
    assign dest_3 = (instr_3[29:27] != 3'b011 && (instr_3[26:23] inside {[7:12]} != 0)) ? {1'b1, instr_3[12:8]}: {1'b0, instr_3[12:8]};
    assign dest_4 = (instr_4[29:27] != 3'b011 && (instr_4[26:23] inside {[7:12]} != 0)) ? {1'b1, instr_4[12:8]}: {1'b0, instr_4[12:8]};
    assign dest_5 = (instr_5[29:27] != 3'b011 && (instr_5[26:23] inside {[7:12]} != 0)) ? {1'b1, instr_5[12:8]}: {1'b0, instr_5[12:8]};
    assign dest_6 = (instr_6[29:27] != 3'b011 && (instr_6[26:23] inside {[7:12]} != 0)) ? {1'b1, instr_6[12:8]}: {1'b0, instr_6[12:8]};
    assign dest_7 = (instr_7[29:27] != 3'b011 && (instr_7[26:23] inside {[7:12]} != 0)) ? {1'b1, instr_7[12:8]}: {1'b0, instr_7[12:8]};
    assign dest_8 = (instr_8[29:27] != 3'b011 && (instr_8[26:23] inside {[7:12]} != 0)) ? {1'b1, instr_8[12:8]}: {1'b0, instr_8[12:8]};
    assign alu_read_index = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b001) ? 0: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b001) ? 1: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b001) ? 2: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b001) ? 3: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b001) ? 4: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b001) ? 5: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b001) ? 6: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b001) ? 7: 0);
    assign mul_read_index = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b001) ? 0: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b001) ? 1: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b001) ? 2: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b001) ? 3: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b001) ? 4: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b001) ? 5: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b001) ? 6: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b001) ? 7: 0);
    assign lsu_read_index = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b001) ? 0: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b001) ? 1: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b001) ? 2: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b001) ? 3: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b001) ? 4: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b001) ? 5: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b001) ? 6: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b001) ? 7: 0);
    assign sldu_read_index = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b001) ? 0: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b001) ? 1: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b001) ? 2: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b001) ? 3: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b001) ? 4: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b001) ? 5: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b001) ? 6: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b001) ? 7: 0);
    assign red_read_index = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b001) ? 0: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b001) ? 1: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b001) ? 2: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b001) ? 3: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b001) ? 4: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b001) ? 5: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b001) ? 6: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b001) ? 7: 0);
    assign opA_2 = (instr_2[33:32] != 3'b001) ? 1:  (dest_1 == {1'b0, instr_2[22:18]} && instr_1[2:0] != 3'b100) ? 0: 1;
    assign opB_2 = (instr_2[31:30] != 3'b001) ? 1:  (dest_1 == {1'b0, instr_2[17:13]} && instr_1[2:0] != 3'b100) ? 0: 1;
    assign opC_2 = ((instr_2[29:27] != 3'b100) || (instr_2[29:27] != 3'b011 && (instr_2[26:23] inside {[7:12]} != 0))) ? 1: (dest_1 == {1'b0, instr_2[18:12]} && instr_1[2:0] != 3'b100) ? 0: 1;
    assign opA_3 = (instr_3[33:32] != 3'b001) ? 1:  ((dest_1 == {1'b0, instr_3[22:18]} && instr_3[2:0] != 3'b100) || (dest_2 == {1'b0, instr_3[22:18]} && instr_2[2:0] != 3'b100)) ? 0: 1;
    assign opB_3 = (instr_3[31:30] != 3'b001) ? 1:  ((dest_1 == {1'b0, instr_3[17:13]} && instr_3[2:0] != 3'b100) || (dest_2 == {1'b0, instr_3[17:13]} && instr_2[2:0] != 3'b100)) ? 0: 1;
    assign opC_3 = ((instr_3[29:27] != 3'b100) || (instr_3[29:27] != 3'b011 && (instr_3[26:23] inside {[7:12]} != 0))) ? 1: ((dest_1 == {1'b0, instr_3[12:8]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_3[12:8]} && instr_2[2:0] != 3'b100)) ? 0: 1;
    assign opA_4 = (instr_4[33:32] != 3'b001) ? 1:  ((dest_1 == {1'b0, instr_4[22:18]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_4[22:18]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_4[22:18]} && instr_3[2:0] != 3'b100)) ? 0: 1;
    assign opB_4 = (instr_4[31:30] != 3'b001) ? 1:  ((dest_1 == {1'b0, instr_4[17:13]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_4[17:13]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_4[17:13]} && instr_3[2:0] != 3'b100)) ? 0: 1;
    assign opC_4 = ((instr_4[29:27] != 3'b100) || (instr_4[29:27] != 3'b011 && (instr_4[26:23] inside {[7:12]} != 0))) ? 1: ((dest_1 == {1'b0, instr_4[12:8]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_4[12:8]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_4[12:8]} && instr_3[2:0] != 3'b100)) ? 0: 1;
    assign opA_5 = (instr_5[33:32] != 3'b001) ? 1:  ((dest_1 == {1'b0, instr_5[22:18]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_5[22:18]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_5[22:18]} && instr_3[2:0] != 3'b100) || (dest_4 == {1'b0, instr_5[22:18]} && instr_4[2:0] != 3'b100)) ? 0: 1;
    assign opB_5 = (instr_5[31:30] != 3'b001) ? 1:  ((dest_1 == {1'b0, instr_5[17:13]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_5[17:13]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_5[17:13]} && instr_3[2:0] != 3'b100) || (dest_4 == {1'b0, instr_5[17:13]} && instr_4[2:0] != 3'b100)) ? 0: 1;
    assign opC_5 = ((instr_5[29:27] != 3'b100) || (instr_5[29:27] != 3'b011 && (instr_5[26:23] inside {[7:12]} != 0))) ? 1: ((dest_1 == {1'b0, instr_5[12:8]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_5[12:8]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_5[12:8]} && instr_4[2:0] != 3'b100) || (dest_4 == {1'b0, instr_5[12:8]} && instr_4[2:0] != 3'b100)) ? 0: 1;
    assign opA_6 = (instr_6[33:32] != 3'b001) ? 1:  ((dest_1 == {1'b0, instr_6[22:18]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_6[22:18]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_6[22:18]} && instr_3[2:0] != 3'b100) || (dest_4 == {1'b0, instr_6[22:18]} && instr_4[2:0] != 3'b100) || (dest_5 == {1'b0, instr_6[22:18]} && instr_5[2:0] != 3'b100)) ? 0: 1;
    assign opB_6 = (instr_6[31:30] != 3'b001) ? 1:  ((dest_1 == {1'b0, instr_6[17:13]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_6[17:13]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_6[17:13]} && instr_3[2:0] != 3'b100) || (dest_4 == {1'b0, instr_6[17:13]} && instr_4[2:0] != 3'b100) || (dest_5 == {1'b0, instr_6[17:13]} && instr_5[2:0] != 3'b100)) ? 0: 1;
    assign opC_6 = ((instr_6[29:27] != 3'b100) || (instr_6[29:27] != 3'b011 && (instr_6[26:23] inside {[7:12]} != 0))) ? 1: ((dest_1 == {1'b0, instr_6[12:8]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_6[12:8]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_6[12:8]} && instr_4[2:0] != 3'b100) || (dest_4 == {1'b0, instr_5[12:8]} && instr_4[2:0] != 3'b100) || (dest_5 == {1'b0, instr_6[12:8]} && instr_5[2:0] != 3'b100)) ? 0: 1;
    assign opA_7 = (instr_7[33:32] != 3'b001) ? 1:  ((dest_1 == {1'b0, instr_7[22:18]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_7[22:18]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_7[22:18]} && instr_3[2:0] != 3'b100) || (dest_4 == {1'b0, instr_7[22:18]} && instr_4[2:0] != 3'b100) || (dest_5 == {1'b0, instr_7[22:18]} && instr_5[2:0] != 3'b100) || (dest_6 == {1'b0, instr_7[22:18]} && instr_6[2:0] != 3'b100)) ? 0: 1;
    assign opB_7 = (instr_7[31:30] != 3'b001) ? 1:  ((dest_1 == {1'b0, instr_7[17:13]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_7[17:13]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_7[17:13]} && instr_3[2:0] != 3'b100) || (dest_4 == {1'b0, instr_7[17:13]} && instr_4[2:0] != 3'b100) || (dest_5 == {1'b0, instr_7[17:13]} && instr_5[2:0] != 3'b100) || (dest_6 == {1'b0, instr_7[22:18]} && instr_6[2:0] != 3'b100)) ? 0: 1;
    assign opC_7 = ((instr_7[29:27] != 3'b100) || (instr_7[29:27] != 3'b011 && (instr_7[26:23] inside {[7:12]} != 0))) ? 1: ((dest_1 == {1'b0, instr_7[12:8]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_7[12:8]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_7[12:8]} && instr_4[2:0] != 3'b100) || (dest_4 == {1'b0, instr_5[12:8]} && instr_4[2:0] != 3'b100) || (dest_5 == {1'b0, instr_7[12:8]} && instr_5[2:0] != 3'b100) || (dest_6 == {1'b0, instr_7[12:8]} && instr_6[2:0] != 3'b100)) ? 0: 1;
    assign opA_8 = (instr_8[33:32] != 3'b001) ? 1:  ((dest_1 == {1'b0, instr_8[22:18]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_8[22:18]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_8[22:18]} && instr_3[2:0] != 3'b100) || (dest_4 == {1'b0, instr_8[22:18]} && instr_4[2:0] != 3'b100) || (dest_5 == {1'b0, instr_8[22:18]} && instr_5[2:0] != 3'b100) || (dest_6 == {1'b0, instr_8[22:18]} && instr_6[2:0] != 3'b100) || (dest_7 == {1'b0, instr_8[22:18]} && instr_7[2:0] != 3'b100)) ? 0: 1;
    assign opB_8 = (instr_8[31:30] != 3'b001) ? 1:  ((dest_1 == {1'b0, instr_8[17:13]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_8[17:13]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_8[17:13]} && instr_3[2:0] != 3'b100) || (dest_4 == {1'b0, instr_8[17:13]} && instr_4[2:0] != 3'b100) || (dest_5 == {1'b0, instr_8[17:13]} && instr_5[2:0] != 3'b100) || (dest_6 == {1'b0, instr_8[22:18]} && instr_6[2:0] != 3'b100) || (dest_7 == {1'b0, instr_8[22:18]} && instr_7[2:0] != 3'b100)) ? 0: 1;
    assign opC_8 = ((instr_8[29:27] != 3'b100) || (instr_8[29:27] != 3'b011 && (instr_8[26:23] inside {[7:12]} != 0))) ? 1: ((dest_1 == {1'b0, instr_8[12:8]} && instr_1[2:0] != 3'b100) || (dest_2 == {1'b0, instr_8[12:8]} && instr_2[2:0] != 3'b100) || (dest_3 == {1'b0, instr_8[12:8]} && instr_4[2:0] != 3'b100) || (dest_4 == {1'b0, instr_5[12:8]} && instr_4[2:0] != 3'b100) || (dest_5 == {1'b0, instr_8[12:8]} && instr_5[2:0] != 3'b100) || (dest_6 == {1'b0, instr_8[12:8]} && instr_6[2:0] != 3'b100) || (dest_7 == {1'b0, instr_8[12:8]} && instr_7[2:0] != 3'b100)) ? 0: 1;




//read
/*     assign instr_read = ((instr_1[2:0] == 3'b010 && ((instr_1[29:27] == 3'b001 && busy_alu == 0) || (instr_1[29:27] == 3'b010 && busy_mul == 0) || (instr_1[29:27] == 3'b011 && busy_lsu == 0) || (instr_1[29:27] == 3'b100 && busy_sldu == 0) || (instr_1[29:27] == 3'b101 && busy_red == 0))) ? instr_1: 
                    (instr_2[2:0] == 3'b010 && ((instr_2[29:27] == 3'b001 && busy_alu == 0) || (instr_2[29:27] == 3'b010 && busy_mul == 0) || (instr_2[29:27] == 3'b011 && busy_lsu == 0) || (instr_2[29:27] == 3'b100 && busy_sldu == 0) || (instr_2[29:27] == 3'b101 && busy_red == 0))) ? instr_2: 
                    (instr_3[2:0] == 3'b010 && ((instr_3[29:27] == 3'b001 && busy_alu == 0) || (instr_3[29:27] == 3'b010 && busy_mul == 0) || (instr_3[29:27] == 3'b011 && busy_lsu == 0) || (instr_3[29:27] == 3'b100 && busy_sldu == 0) || (instr_3[29:27] == 3'b101 && busy_red == 0))) ? instr_3: 
                    (instr_4[2:0] == 3'b010 && ((instr_4[29:27] == 3'b001 && busy_alu == 0) || (instr_4[29:27] == 3'b010 && busy_mul == 0) || (instr_4[29:27] == 3'b011 && busy_lsu == 0) || (instr_4[29:27] == 3'b100 && busy_sldu == 0) || (instr_4[29:27] == 3'b101 && busy_red == 0))) ? instr_4: 
                    (instr_5[2:0] == 3'b010 && ((instr_5[29:27] == 3'b001 && busy_alu == 0) || (instr_5[29:27] == 3'b010 && busy_mul == 0) || (instr_5[29:27] == 3'b011 && busy_lsu == 0) || (instr_5[29:27] == 3'b100 && busy_sldu == 0) || (instr_5[29:27] == 3'b101 && busy_red == 0))) ? instr_5: 
                    (instr_6[2:0] == 3'b010 && ((instr_6[29:27] == 3'b001 && busy_alu == 0) || (instr_6[29:27] == 3'b010 && busy_mul == 0) || (instr_6[29:27] == 3'b011 && busy_lsu == 0) || (instr_6[29:27] == 3'b100 && busy_sldu == 0) || (instr_6[29:27] == 3'b101 && busy_red == 0))) ? instr_6: 
                    (instr_7[2:0] == 3'b010 && ((instr_7[29:27] == 3'b001 && busy_alu == 0) || (instr_7[29:27] == 3'b010 && busy_mul == 0) || (instr_7[29:27] == 3'b011 && busy_lsu == 0) || (instr_7[29:27] == 3'b100 && busy_sldu == 0) || (instr_7[29:27] == 3'b101 && busy_red == 0))) ? instr_7: 
                    (instr_8[2:0] == 3'b010 && ((instr_8[29:27] == 3'b001 && busy_alu == 0) || (instr_8[29:27] == 3'b010 && busy_mul == 0) || (instr_8[29:27] == 3'b011 && busy_lsu == 0) || (instr_8[29:27] == 3'b100 && busy_sldu == 0) || (instr_8[29:27] == 3'b101 && busy_red == 0))) ? instr_8: 0);        
 */  
     assign instr_read = ((instr_1[2:0] == 3'b010 && ((instr_1[29:27] == 3'b001 && busy_alu == 0) || (instr_1[29:27] == 3'b010 && busy_mul == 0) || (instr_1[29:27] == 3'b011 && busy_lsu == 0) || (instr_1[29:27] == 3'b100 && busy_sldu == 0) || (instr_1[29:27] == 3'b101 && busy_red == 0))) ? instr_1: 
                    ((instr_2[2:0] == 3'b010 && opA_2 == 1 && opB_2 == 1 && opC_2 == 1) && ((instr_2[29:27] == 3'b001 && busy_alu == 0) || (instr_2[29:27] == 3'b010 && busy_mul == 0) || (instr_2[29:27] == 3'b011 && busy_lsu == 0) || (instr_2[29:27] == 3'b100 && busy_sldu == 0) || (instr_2[29:27] == 3'b101 && busy_red == 0))) ? instr_2: 
                    ((instr_3[2:0] == 3'b010 && opA_3 == 1 && opB_3 == 1 && opC_3 == 1) && ((instr_3[29:27] == 3'b001 && busy_alu == 0) || (instr_3[29:27] == 3'b010 && busy_mul == 0) || (instr_3[29:27] == 3'b011 && busy_lsu == 0) || (instr_3[29:27] == 3'b100 && busy_sldu == 0) || (instr_3[29:27] == 3'b101 && busy_red == 0))) ? instr_3: 
                    ((instr_4[2:0] == 3'b010 && opA_4 == 1 && opB_4 == 1 && opC_4 == 1) && ((instr_4[29:27] == 3'b001 && busy_alu == 0) || (instr_4[29:27] == 3'b010 && busy_mul == 0) || (instr_4[29:27] == 3'b011 && busy_lsu == 0) || (instr_4[29:27] == 3'b100 && busy_sldu == 0) || (instr_4[29:27] == 3'b101 && busy_red == 0))) ? instr_4: 
                    ((instr_5[2:0] == 3'b010 && opA_5 == 1 && opB_5 == 1 && opC_5 == 1) && ((instr_5[29:27] == 3'b001 && busy_alu == 0) || (instr_5[29:27] == 3'b010 && busy_mul == 0) || (instr_5[29:27] == 3'b011 && busy_lsu == 0) || (instr_5[29:27] == 3'b100 && busy_sldu == 0) || (instr_5[29:27] == 3'b101 && busy_red == 0))) ? instr_5: 
                    ((instr_6[2:0] == 3'b010 && opA_6 == 1 && opB_6 == 1 && opC_6 == 1) && ((instr_6[29:27] == 3'b001 && busy_alu == 0) || (instr_6[29:27] == 3'b010 && busy_mul == 0) || (instr_6[29:27] == 3'b011 && busy_lsu == 0) || (instr_6[29:27] == 3'b100 && busy_sldu == 0) || (instr_6[29:27] == 3'b101 && busy_red == 0))) ? instr_6: 
                    ((instr_7[2:0] == 3'b010 && opA_7 == 1 && opB_7 == 1 && opC_7 == 1) && ((instr_7[29:27] == 3'b001 && busy_alu == 0) || (instr_7[29:27] == 3'b010 && busy_mul == 0) || (instr_7[29:27] == 3'b011 && busy_lsu == 0) || (instr_7[29:27] == 3'b100 && busy_sldu == 0) || (instr_7[29:27] == 3'b101 && busy_red == 0))) ? instr_7: 
                    ((instr_8[2:0] == 3'b010 && opA_8 == 1 && opB_8 == 1 && opC_8 == 1) && ((instr_8[29:27] == 3'b001 && busy_alu == 0) || (instr_8[29:27] == 3'b010 && busy_mul == 0) || (instr_8[29:27] == 3'b011 && busy_lsu == 0) || (instr_8[29:27] == 3'b100 && busy_sldu == 0) || (instr_8[29:27] == 3'b101 && busy_red == 0))) ? instr_8: 0);        
    //assign instr_read_index = ((instr_1 == instr_read && instr_read != 0) ? 0: (instr_2 == instr_read && instr_read != 0) ? 1: (instr_3 == instr_read && instr_read != 0) ? 2: (instr_4 == instr_read && instr_read != 0) ? 3: (instr_5 == instr_read && instr_read != 0) ? 4: (instr_6 == instr_read && instr_read != 0) ? 5: (instr_7 == instr_read && instr_read != 0) ? 6: (instr_8 == instr_read && instr_read != 0) ? 7: 0);
    assign instr_read_index = ((instr_1[2:0] == 3'b010 && ((instr_1[29:27] == 3'b001 && busy_alu == 0) || (instr_1[29:27] == 3'b010 && busy_mul == 0) || (instr_1[29:27] == 3'b011 && busy_lsu == 0) || (instr_1[29:27] == 3'b100 && busy_sldu == 0) || (instr_1[29:27] == 3'b101 && busy_red == 0))) ? 0: 
                    ((instr_2[2:0] == 3'b010 && opA_2 == 1 && opB_2 == 1 && opC_2 == 1) && ((instr_2[29:27] == 3'b001 && busy_alu == 0) || (instr_2[29:27] == 3'b010 && busy_mul == 0) || (instr_2[29:27] == 3'b011 && busy_lsu == 0) || (instr_2[29:27] == 3'b100 && busy_sldu == 0) || (instr_2[29:27] == 3'b101 && busy_red == 0))) ? 1: 
                    ((instr_3[2:0] == 3'b010 && opA_3 == 1 && opB_3 == 1 && opC_3 == 1) && ((instr_3[29:27] == 3'b001 && busy_alu == 0) || (instr_3[29:27] == 3'b010 && busy_mul == 0) || (instr_3[29:27] == 3'b011 && busy_lsu == 0) || (instr_3[29:27] == 3'b100 && busy_sldu == 0) || (instr_3[29:27] == 3'b101 && busy_red == 0))) ? 2: 
                    ((instr_4[2:0] == 3'b010 && opA_4 == 1 && opB_4 == 1 && opC_4 == 1) && ((instr_4[29:27] == 3'b001 && busy_alu == 0) || (instr_4[29:27] == 3'b010 && busy_mul == 0) || (instr_4[29:27] == 3'b011 && busy_lsu == 0) || (instr_4[29:27] == 3'b100 && busy_sldu == 0) || (instr_4[29:27] == 3'b101 && busy_red == 0))) ? 3: 
                    ((instr_5[2:0] == 3'b010 && opA_5 == 1 && opB_5 == 1 && opC_5 == 1) && ((instr_5[29:27] == 3'b001 && busy_alu == 0) || (instr_5[29:27] == 3'b010 && busy_mul == 0) || (instr_5[29:27] == 3'b011 && busy_lsu == 0) || (instr_5[29:27] == 3'b100 && busy_sldu == 0) || (instr_5[29:27] == 3'b101 && busy_red == 0))) ? 4: 
                    ((instr_6[2:0] == 3'b010 && opA_6 == 1 && opB_6 == 1 && opC_6 == 1) && ((instr_6[29:27] == 3'b001 && busy_alu == 0) || (instr_6[29:27] == 3'b010 && busy_mul == 0) || (instr_6[29:27] == 3'b011 && busy_lsu == 0) || (instr_6[29:27] == 3'b100 && busy_sldu == 0) || (instr_6[29:27] == 3'b101 && busy_red == 0))) ? 5: 
                    ((instr_7[2:0] == 3'b010 && opA_7 == 1 && opB_7 == 1 && opC_7 == 1) && ((instr_7[29:27] == 3'b001 && busy_alu == 0) || (instr_7[29:27] == 3'b010 && busy_mul == 0) || (instr_7[29:27] == 3'b011 && busy_lsu == 0) || (instr_7[29:27] == 3'b100 && busy_sldu == 0) || (instr_7[29:27] == 3'b101 && busy_red == 0))) ? 6: 
                    ((instr_8[2:0] == 3'b010 && opA_8 == 1 && opB_8 == 1 && opC_8 == 1) && ((instr_8[29:27] == 3'b001 && busy_alu == 0) || (instr_8[29:27] == 3'b010 && busy_mul == 0) || (instr_8[29:27] == 3'b011 && busy_lsu == 0) || (instr_8[29:27] == 3'b100 && busy_sldu == 0) || (instr_8[29:27] == 3'b101 && busy_red == 0))) ? 7: 0);
//execute
    assign is_vstype = (op_lsu inside {[7:12]});
    assign is_vltype = (op_lsu inside {[1:6]});
    assign lsu_raw = is_vltype == 1 ? 1: is_vstype == 1 ? 0: 0;
    //alu
    assign alu_exec = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b011) ? instr_8: 0);
    assign alu_exec_index = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b011) ? 7: 0);
    //mul
    assign mul_exec = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b011) ? instr_8: 0);
    assign mul_exec_index = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b011) ? 7: 0);
    //lsu
    assign lsu_exec = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b011) ? instr_8: 0);
    assign lsu_exec_index = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b011) ? 7: 0);
    //sldu
    assign sldu_exec = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b011) ? instr_8: 0);
    assign sldu_exec_index = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b011) ? 7: 0);
    //red
    assign red_exec = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b011) ? instr_8: 0);
    assign red_exec_index = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b011) ? 7: 0);

//write
/*     assign wb_instr = (instr_1[2:0] == 3'b100) ? instr_1: 0;
    assign dest_wb = (wb_instr != 0) ? wb_instr[12:8] : 0;   
    assign vsew_wb = (wb_instr != 0) ? wb_instr [37:36] : 0;
    assign lmul_wb = (wb_instr != 0) ? wb_instr [35:34] : 0;
 */
    initial begin
            optype_read <= 0; dest_wb <= 0; el_wr_addr <= 0;
            //op_alu <= 0; op_mul <= 0; op_lsu <= 0; op_sldu <= 0; op_red <= 0;
            vsew_alu <= 0; vsew_mul <= 0; vsew_lsu <= 0; vsew_sldu <= 0; vsew_red <= 0; /* vsew_wb <= 0; */
            lmul_alu <= 0; lmul_mul <= 0; lmul_lsu <= 0; lmul_sldu <= 0; lmul_red <= 0; /* lmul_wb <= 0; */
            Qj_alu <= 0; Qj_mul <= 0; Qj_lsu <= 0; Qj_sldu <= 0; Qj_red <= 0; Qi_lsu <= 0;
            Qk_alu <= 0; Qk_mul <= 0; Qk_lsu <= 0; Qk_sldu <= 0; Qk_red <= 0; Qi_sldu <= 0;
            Fi_lsu <= 0; Fi_sldu <= 0;
            Fj_alu <= 0; Fj_mul <= 0; Fj_lsu <= 0; Fj_sldu <= 0; Fj_red <= 0;
            Fk_alu <= 0; Fk_mul <= 0; Fk_lsu <= 0; Fk_sldu <= 0; Fk_red <= 0;
            Imm_alu <= 0; Imm_mul <= 0; Imm_lsu <= 0; Imm_sldu <= 0; Imm_red <= 0;
            v_reg_wr_en <= 0; x_reg_wr_en <= 0; el_wr_en <= 0;
            reg_wr_data <= 0; reg_wr_data_2 <= 0; reg_wr_data_3 <= 0; reg_wr_data_4 <= 0;
            //busy_alu <= 0; busy_mul <= 0; busy_lsu <= 0; busy_sldu <= 0; busy_red <= 0;
    end
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            for (int i = 0; i < NO_OF_SLOTS; i++) begin
                instr_status_table[i] <= {IST_ENTRY_BITS{1'b0}};
                busy_alu <= 0; busy_mul <= 0; busy_lsu <= 0; busy_sldu <= 0; busy_red <= 0;
                op_alu <= 0; op_mul <= 0; op_lsu <= 0; op_sldu <= 0; op_red <= 0;
            end
        end
        else begin
        //write/issue
            if (fifo_full == 0 && base_instr != 0 && is_vector == 1 && is_vconfig ==  0) begin
                instr_status_table[fifo_count] = {sel_dest, vsew, lmul, sel_op_A, sel_op_B, op, op_instr, src_A, src_B, dest, imm, 3'b010};
            end
        //read 
            if (instr_read != 0) begin
                /* if (wb_instr_index == 0 && wb_instr != 0 && !(fifo_full == 0 && base_instr != 0 && is_vector == 1 && is_vconfig ==  0))
                    instr_status_table[instr_read_index - 1][2:0] <=  3'b011;
                else if (!(wb_instr_index == 0 && wb_instr != 0) && fifo_full == 0 && base_instr != 0 && is_vector == 1 && is_vconfig ==  0)
                    instr_status_table[instr_read_index + 1][2:0] <=  3'b011;
                else */
                instr_status_table[instr_read_index][2:0] <=  3'b011;
                case(instr_read[29:27]) 
                default: begin
                    busy_alu <= 0;
                    busy_mul <= 0;
                    busy_lsu <= 0;
                    busy_sldu <= 0;
                    busy_red <= 0;
                end
                3'b001: begin
                    busy_alu <= 1; 
                    op_alu <= instr_read[26:23];
                end 
                3'b010: begin
                    busy_mul <= 1;
                    op_mul <= instr_read[26:23];
                end 
                3'b011: begin
                    busy_lsu <= 1;
                    op_lsu <= instr_read[26:23];
                end 
                3'b100: begin
                    busy_sldu <= 1;
                    op_sldu <= instr_read[26:23];
                end 
                3'b101:begin
                    busy_red <= 1;
                    op_red <= instr_read[26:23];
                end 
                endcase
            end
        //execute
            if (done_alu == 1 && alu_exec != 0) begin
            //if (op_alu == 0 && alu_exec != 0) begin
                instr_status_table[alu_exec_index][2:0] <= 3'b100;
                op_alu = 0;
            end
            if (done_mul == 1 && mul_exec != 0) begin
            //if (op_mul == 0 && mul_exec != 0) begin
                instr_status_table[mul_exec_index][2:0] <= 3'b100;
                op_mul = 0;
            end
            if (done_lsu == 1 && lsu_exec != 0) begin
            //if (op_lsu == 0 && lsu_exec != 0) begin
                instr_status_table[lsu_exec_index][2:0] <= 3'b100;
                op_lsu = 0;
            end
            if (done_sldu == 1  && sldu_exec != 0) begin
            //if (op_sldu == 0 && sldu_exec != 0) begin
                instr_status_table[sldu_exec_index][2:0] <= 3'b100;
                op_sldu = 0;
            end
            if (done_red == 1 && red_exec != 0) begin
            //if (op_red == 0 && red_exec != 0) begin
                instr_status_table[red_exec_index][2:0] <= 3'b100;
                op_red = 0;
            end
        //writeback
            if (wb_instr_index == 0 && wb_instr != 0) begin
                case(wb_instr[29:27]) 
                default: begin
                    busy_alu <= 0;
                    busy_mul <= 0;
                    busy_lsu <= 0;
                    busy_sldu <= 0;
                    busy_red <= 0;
                end
                3'b001: begin
                    busy_alu <= 0;
                end 
                3'b010: begin
                    busy_mul <= 0;
                end 
                3'b011: begin
                    busy_lsu <= 0;
                end 
                3'b100: begin
                    busy_sldu <= 0;
                end 
                3'b101:begin
                    busy_red <= 0;
                end 
                endcase
                if (instr_read_index == 1)
                    instr_status_table[0] <= {{instr_status_table[1][39:3]}, 3'b011};
                else if ((done_alu == 1 && alu_exec_index == 1) || (done_mul == 1 && mul_exec_index == 1) || (done_lsu == 1 && lsu_exec_index == 1) || (done_sldu == 1 && sldu_exec_index == 1) || (done_red == 1 && red_exec_index == 1))
                    instr_status_table[0] <= {{instr_status_table[1][39:3]}, 3'b100};
                else instr_status_table[0] <= instr_status_table[1];

                if (instr_read_index == 2) 
                    instr_status_table[1] <= {{instr_status_table[2][39:3]}, 3'b011 };
                else if ((done_alu == 1 && alu_exec_index == 2) || (done_mul == 1 && mul_exec_index == 2) || (done_lsu == 1 && lsu_exec_index == 2) || (done_sldu == 1 && sldu_exec_index == 2) || (done_red == 1 && red_exec_index == 2))
                    instr_status_table[1] <= {{instr_status_table[2][39:3]}, 3'b100};
                else instr_status_table[1] <= instr_status_table[2];

                if (instr_read_index == 3) 
                    instr_status_table[2] <= {{instr_status_table[3][39:3]}, 3'b011 };
                else if ((done_alu == 1 && alu_exec_index == 3) || (done_mul == 1 && mul_exec_index == 3) || (done_lsu == 1 && lsu_exec_index == 3) || (done_sldu == 1 && sldu_exec_index == 3) || (done_red == 1 && red_exec_index == 3))
                    instr_status_table[2] <= {{instr_status_table[3][39:3]}, 3'b100};
                else instr_status_table[2] <= instr_status_table[3];

                if (instr_read_index == 4) 
                    instr_status_table[3] <= {{instr_status_table[4][39:3]}, 3'b011 };
                else if ((done_alu == 1 && alu_exec_index == 4) || (done_mul == 1 && mul_exec_index == 4) || (done_lsu == 1 && lsu_exec_index == 4) || (done_sldu == 1 && sldu_exec_index == 4) || (done_red == 1 && red_exec_index == 4))
                    instr_status_table[3] <= {{instr_status_table[4][39:3]}, 3'b100};
                else instr_status_table[3] <= instr_status_table[4];

                if (instr_read_index == 5) 
                    instr_status_table[4] <= {{instr_status_table[5][39:3]}, 3'b011 };
                else if ((done_alu == 1 && alu_exec_index == 5) || (done_mul == 1 && mul_exec_index == 5) || (done_lsu == 1 && lsu_exec_index == 5) || (done_sldu == 1 && sldu_exec_index == 5) || (done_red == 1 && red_exec_index == 5))
                    instr_status_table[4] <= {{instr_status_table[5][39:3]}, 3'b100};
                else instr_status_table[4] <= instr_status_table[5];

                if (instr_read_index == 6) 
                    instr_status_table[5] <= {{instr_status_table[6][39:3]}, 3'b011 };
                else if ((done_alu == 1 && alu_exec_index == 6) || (done_mul == 1 && mul_exec_index == 6) || (done_lsu == 1 && lsu_exec_index == 6) || (done_sldu == 1 && sldu_exec_index == 6) || (done_red == 1 && red_exec_index == 6))
                    instr_status_table[5] <= {{instr_status_table[6][39:3]}, 3'b100};
                else instr_status_table[5] <= instr_status_table[6];

                if (instr_read_index == 7) 
                    instr_status_table[6] <= {{instr_status_table[7][39:3]}, 3'b011 };
                else if ((done_alu == 1 && alu_exec_index == 7) || (done_mul == 1 && mul_exec_index == 7) || (done_lsu == 1 && lsu_exec_index == 7) || (done_sldu == 1 && sldu_exec_index == 7) || (done_red == 1 && red_exec_index == 7))
                    instr_status_table[6] <= {{instr_status_table[7][39:3]}, 3'b100};
                else instr_status_table[6] <= instr_status_table[7];

                instr_status_table[7] <= {IST_ENTRY_BITS{1'b0}};
            end 
        end
    end


    always @(*) begin
    // ******************READ******************
            if (instr_read != 0) begin
                case (instr_read[29:27])
                    //alu
                    3'b001: begin 
                        sel_dest_alu = instr_read[39:38];
                        Fj_alu =  instr_read[22:18];
                        Fk_alu = instr_read[17:13];
                        Imm_alu = instr_read[7:3];
                        Qj_alu = ((instr_read[33:32] == 2'b10) ? 3'b110: (instr_read[33:32] == 2'b11) ? 3'b111: (Fj_alu == Fi_alu && busy_alu == 1) ? 3'b001: (Fj_alu == Fi_mul && busy_mul == 1) ? 3'b010: (Fj_alu == Fi_lsu && busy_lsu == 1 && lsu_raw == 1) ? 3'b011: (Fj_alu == Fi_sldu && busy_sldu == 1) ? 3'b100: (Fj_alu == Fi_red && busy_red == 1) ? 3'b101: 3'b000);
                        Qk_alu = ((instr_read[31:30] == 2'b10) ? 3'b110: (instr_read[31:30] == 2'b11) ? 3'b111: (Fk_alu == Fi_alu && busy_alu == 1) ? 3'b001: (Fk_alu == Fi_mul && busy_mul == 1) ? 3'b010: (Fk_alu == Fi_lsu && busy_lsu == 1 && lsu_raw == 1) ? 3'b011: (Fk_alu == Fi_sldu && busy_sldu == 1) ? 3'b100: (Fk_alu == Fi_red && busy_red == 1) ? 3'b101: 3'b000);                
                        Fi_alu = instr_read[12:8];       
                        //op_alu = instr_read[26:23];
                        vsew_alu = instr_read[37:36];
                        lmul_alu = instr_read[35:34];
                    end
                    //mul
                    3'b010: begin
                        sel_dest_mul = instr_read[39:38];
                        Fj_mul =  instr_read[22:18];
                        Fk_mul = instr_read[17:13];
                        Imm_mul = instr_read[7:3];
                        Qj_mul = ((instr_read[33:32] == 2'b10) ? 3'b110: (instr_read[33:32] == 2'b11) ? 3'b111: (Fj_mul == Fi_alu && busy_alu == 1) ? 3'b001: (Fj_mul == Fi_mul && busy_mul == 1) ? 3'b010: (Fj_mul == Fi_lsu && busy_lsu == 1 && lsu_raw == 1) ? 3'b011: (Fj_mul == Fi_sldu && busy_sldu == 1) ? 3'b100: (Fj_mul == Fi_red && busy_red == 1) ? 3'b101: 3'b000);
                        Qk_mul = ((instr_read[31:30] == 2'b10) ? 3'b110: (instr_read[31:30] == 2'b11) ? 3'b111: (Fk_mul == Fi_alu && busy_alu == 1) ? 3'b001: (Fk_mul == Fi_mul && busy_mul == 1) ? 3'b010: (Fk_mul == Fi_lsu && busy_lsu == 1 && lsu_raw == 1) ? 3'b011: (Fk_mul == Fi_sldu && busy_sldu == 1) ? 3'b100: (Fk_mul == Fi_red && busy_red == 1) ? 3'b101: 3'b000);                
                        Fi_mul = instr_read[12:8];      
                        //op_mul = instr_read[26:23];
                        vsew_mul = instr_read[37:36];
                        lmul_mul = instr_read[35:34];
                    end
                    //lsu
                    3'b011:  begin
                        sel_dest_lsu = instr_read[39:38];
                        Fj_lsu =  instr_read[22:18];
                        Fk_lsu = instr_read[17:13];
                        Imm_lsu = instr_read[7:3];
                        Qi_lsu = (instr_read[26:23] inside {[7:12]}) ? ((instr_read[12:8] == Fi_alu && busy_alu == 1) ? 3'b001: (instr_read[12:8] == Fi_mul && busy_mul == 1) ? 3'b010: (instr_read[12:8] == Fi_lsu && busy_lsu == 1 && lsu_raw == 1) ? 3'b011: (instr_read[12:8] == Fi_sldu && busy_sldu == 1) ? 3'b100: (instr_read[12:8] == Fi_red && busy_red == 1) ? 3'b101: 3'b000): 3'b000;
                        Qj_lsu = ((instr_read[33:32] == 2'b10) ? 3'b110: (instr_read[33:32] == 2'b11) ? 3'b111: (Fj_lsu == Fi_alu && busy_alu == 1) ? 3'b001: (Fj_lsu == Fi_mul && busy_mul == 1) ? 3'b010: (Fj_lsu == Fi_lsu && busy_lsu == 1 && lsu_raw == 1) ? 3'b011: (Fj_lsu == Fi_sldu && busy_sldu == 1) ? 3'b100: (Fj_lsu == Fi_red && busy_red == 1) ? 3'b101: 3'b000);
                        Qk_lsu = ((instr_read[31:30] == 2'b10) ? 3'b110: (instr_read[31:30] == 2'b11) ? 3'b111: (Fk_lsu == Fi_alu && busy_alu == 1) ? 3'b001: (Fk_lsu == Fi_mul && busy_mul == 1) ? 3'b010: (Fk_lsu == Fi_lsu && busy_lsu == 1 && lsu_raw == 1) ? 3'b011: (Fk_lsu == Fi_sldu && busy_sldu == 1) ? 3'b100: (Fk_lsu == Fi_red && busy_red == 1) ? 3'b101: 3'b000);                
                        Fi_lsu = instr_read[12:8];   
                        //op_lsu = instr_read[26:23];
                        vsew_lsu = instr_read[37:36];
                        lmul_lsu = instr_read[35:34];
                    end
                    //sldu
                    3'b100: begin
                        sel_dest_sldu = instr_read[39:38];
                        Fj_sldu =  instr_read[22:18];
                        Fk_sldu = instr_read[17:13];
                        Imm_sldu = instr_read[7:3];
                        Qi_sldu = ((instr_read[12:8] == Fi_alu && busy_alu == 1) ? 3'b001: (instr_read[12:8] == Fi_mul && busy_mul == 1) ? 3'b010: (instr_read[12:8] == Fi_lsu && busy_lsu == 1 && lsu_raw == 1) ? 3'b011: (instr_read[12:8] == Fi_sldu && busy_sldu == 1) ? 3'b100: (instr_read[12:8] == Fi_red && busy_red == 1) ? 3'b101: 3'b000);
                        Qj_sldu = ((instr_read[33:32] == 2'b10) ? 3'b110: (instr_read[33:32] == 2'b11) ? 3'b111: (Fj_sldu == Fi_alu && busy_alu == 1) ? 3'b001: (Fj_sldu == Fi_mul && busy_mul == 1) ? 3'b010: (Fj_sldu == Fi_lsu && busy_lsu == 1 && lsu_raw == 1) ? 3'b011: (Fj_sldu == Fi_sldu && busy_sldu == 1) ? 3'b100: (Fj_sldu == Fi_red && busy_red == 1) ? 3'b101: 3'b000);
                        Qk_sldu = ((instr_read[31:30] == 2'b10) ? 3'b110: (instr_read[31:30] == 2'b11) ? 3'b111: (Fk_sldu == Fi_alu && busy_alu == 1) ? 3'b001: (Fk_sldu == Fi_mul && busy_mul == 1) ? 3'b010: (Fk_sldu == Fi_lsu && busy_lsu == 1 && lsu_raw == 1) ? 3'b011: (Fk_sldu == Fi_sldu && busy_sldu == 1) ? 3'b100: (Fk_sldu == Fi_red && busy_red == 1) ? 3'b101: 3'b000);                
                        Fi_sldu = instr_read[12:8];   
                        //op_sldu = instr_read[26:23];
                        vsew_sldu = instr_read[37:36];
                        lmul_sldu = instr_read[35:34];
                    end
                    3'b101: begin
                        optype_read = instr_read[29:27];
                        sel_dest_red = instr_read[39:38];
                        Fj_red =  instr_read[22:18];
                        Fk_red = instr_read[17:13];
                        Imm_red = instr_read[7:3];
                        Qj_red = ((instr_read[33:32] == 2'b10) ? 3'b110: (instr_read[33:32] == 2'b11) ? 3'b111: (Fj_red == Fi_alu && busy_alu == 1) ? 3'b001: (Fj_red == Fi_mul && busy_mul == 1) ? 3'b010: (Fj_red == Fi_lsu && busy_lsu == 1 && lsu_raw == 1) ? 3'b011: (Fj_red == Fi_sldu && busy_sldu == 1) ? 3'b100: (Fj_red == Fi_red && busy_red == 1) ? 3'b101: 3'b000);
                        Qk_red = ((instr_read[31:30] == 2'b10) ? 3'b110: (instr_read[31:30] == 2'b11) ? 3'b111: (Fk_red == Fi_alu && busy_alu == 1) ? 3'b001: (Fk_red == Fi_mul && busy_mul == 1) ? 3'b010: (Fk_red == Fi_lsu && busy_lsu == 1 && lsu_raw == 1) ? 3'b011: (Fk_red == Fi_sldu && busy_sldu == 1) ? 3'b100: (Fk_red == Fi_red && busy_red == 1) ? 3'b101: 3'b000);                
                        Fi_red = instr_read[12:8];        
                        //op_red = instr_read[26:23];
                        vsew_red = instr_read[37:36];
                        lmul_red = instr_read[35:34];
                    end
                    default: optype_read = 0;
                endcase
                optype_read = instr_read[29:27];
            end        

    // ******************EXECUTE******************
/*         if (done_alu == 1 && alu_exec != 0) begin
            op_alu = 0;
        end
        if (done_mul == 1 && mul_exec != 0) begin
            op_mul = 0;
        end
        if (done_lsu == 1 && lsu_exec != 0) begin
            op_lsu = 0;
        end
        if (done_sldu == 1 && sldu_exec != 0) begin
            op_sldu = 0;
        end
        if (done_red == 1 && red_exec != 0) begin
            op_red = 0;
        end  */
   // ******************WRITEBACK******************
        wb_instr = (instr_1[2:0] == 3'b100) ? instr_1: 0;
        dest_wb = (wb_instr != 0) ? wb_instr[12:8] : 0;   
        vsew_wb = (wb_instr != 0) ? wb_instr [37:36] : 0;
        lmul_wb = (wb_instr != 0) ? wb_instr [35:34] : 0;
        if (wb_instr != 0 && wb_instr_index == 0) begin
            el_wr_en = (wb_instr[29:27] == 3'b101 && wb_instr[39:38]==1) ? 1: 0; 
            v_reg_wr_en = ((wb_instr[29:27] == 3'b011) && ((wb_instr[26:23] == 4'b0111)||(wb_instr[26:23] == 4'b1000)||(wb_instr[26:23] == 4'b1001))) ? 0:(wb_instr[29:27] == 3'b101) ? 0: (wb_instr[39:38]==1) ? 1: 0;
            x_reg_wr_en = (wb_instr[39:38]==2) ? 1: 0;
        end else begin
            el_wr_en = 0;
            v_reg_wr_en = 0;
            x_reg_wr_en = 0;
        end

        case (wb_instr[29:27])
            default: begin 
                reg_wr_data = 0;
                reg_wr_data_2 = 0;
                reg_wr_data_3 = 0;
                reg_wr_data_4 = 0;
            end
            3'b001: begin
                reg_wr_data = result_valu_1;
                reg_wr_data_2 = result_valu_2;
                reg_wr_data_3 = result_valu_3;
                reg_wr_data_4 = result_valu_4;
            end
            3'b010: begin
                reg_wr_data = result_vmul_1;
                reg_wr_data_2 = result_vmul_2;
                reg_wr_data_3 = result_vmul_3;
                reg_wr_data_4 = result_vmul_4; 
            end
            3'b011: begin
                reg_wr_data = result_vlsu[127:0];
                reg_wr_data_2 = result_vlsu[255:128];
                reg_wr_data_3 = result_vlsu[383:256];
                reg_wr_data_4 = result_vlsu[511:384];
            end
            3'b100: begin
                reg_wr_data = result_vsldu[127:0];
                reg_wr_data_2 = result_vsldu[255:128];
                reg_wr_data_3 = result_vsldu[383:256];
                reg_wr_data_4 = result_vsldu[511:384];  
            end
            3'b101: begin
                el_wr_addr = 0;
                reg_wr_data = {{96{1'b0}}, result_vred};
                reg_wr_data_2 = {128{1'b0}};
                reg_wr_data_3 = {128{1'b0}};
                reg_wr_data_4 = {128{1'b0}};   
            end
        endcase     
    end
endmodule

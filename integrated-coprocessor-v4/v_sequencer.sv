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
    // DOUBLE-CHECK
    parameter int IST_ENTRY_BITS = 38,       // For Instruction Status Table: 6 bits (maybe for opcode?) + 3 bits (instr_status)
    parameter int NO_OF_SLOTS = 8
)(
    input logic clk,
    input logic nrst,
    input logic [1:0] sel_op_A, sel_op_B, vsew, lmul,
    input logic [4:0] src_A, src_B, dest, imm,
    input logic [3:0] v_alu_op, v_lsu_op,
    input logic [2:0] v_red_op, v_sldu_op,
    input logic is_mul,
    input logic done_alu, done_mul, done_lsu, done_sldu, done_red,
    input logic [31:0] result_vlsu, result_valu, result_vmul, result_vred,
    input logic [511:0] result_vsldu,
    output logic [2:0] vsew_alu, vsew_mul, vsew_lsu, vsew_sldu, vsew_red,        // Functional unit producing Fj (3) 
    output logic [2:0] lmul_alu, lmul_mul, lmul_lsu, lmul_sldu, lmul_red,       // Functional unit producing Fk(3) (is_type)
    output logic [2:0] Qj_alu, Qj_mul, Qj_lsu, Qj_sldu, Qj_red,        // Functional unit producing Fj (3) 
    output logic [2:0] Qk_alu, Qk_mul, Qk_lsu, Qk_sldu, Qk_red,       // Functional unit producing Fk(3) (is_type)
    output logic [4:0] Fj_alu, Fj_mul, Fj_lsu, Fj_sldu, Fj_red,        // source register 1 (5) (decoder)
    output logic [4:0] Fk_alu, Fk_mul, Fk_lsu, Fk_sldu, Fk_red,        // source register 2 (5) (decoder)
    output logic [4:0] Fi_alu, Fi_mul, Fi_lsu, Fi_sldu, Fi_red,       // destination reg (5) (decoder)
    output logic [4:0] Imm_alu, Imm_mul, Imm_lsu, Imm_sldu, Imm_red,  // scalar operand (5) (decoder)
    output logic reg_wr_en,
    output logic el_wr_en,
    output logic [IST_ENTRY_BITS-1:0] instr_status_table [0:NO_OF_SLOTS-1],         // logic
    output logic [IST_ENTRY_BITS-1:0] instr_1, instr_2, instr_3, instr_4, instr_5, instr_6, instr_7, instr_8, //logic
    output logic [IST_ENTRY_BITS-1:0] alu_read, mul_read, lsu_read, sldu_read, red_read, //logic
    output logic busy_alu, busy_mul, busy_lsu, busy_sldu, busy_red, //logic
    output logic [3:0] fifo_count, // logic
    output logic Rj_alu, Rj_mul, Rj_lsu, Rj_sldu, Rj_red,              // indicates if Fj is available (1),
    output logic Rk_alu, Rk_mul, Rk_lsu, Rk_sldu, Rk_red,              // indicates if Fk is available (1)
    output logic [2:0] raw_alu_1, raw_mul_1, raw_lsu_1, raw_sldu_1, raw_red_1,
    output logic [127:0]  reg_wr_data, reg_wr_data_2, reg_wr_data_3, reg_wr_data_4
);



    //***************************FU Codes Guide***********************************//
    // 000 - VRF
    // 001 = VALU
    // 010 = VMUL
    // 011 = VLSU
    // 100 = VSLDU
    // 101 = VRED
    // 111 = default off

    //Instruction
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
    //logic [IST_ENTRY_BITS-1:0] instr_status_table [0:NO_OF_SLOTS-1];         // instruction status table
    //logic [3:0] fifo_count;                                                  // keeps track of # of instructions currently in the table
    logic [2:0] instr_status;
    logic [2:0] op;
    logic [3:0] op_instr;
    //logic busy_alu, busy_mul, busy_lsu, busy_sldu, busy_red;    // indicates if the fu is available (1),
    //logic Rj_alu, Rj_mul, Rj_lsu, Rj_sldu, Rj_red;              // indicates if Fj is available (1),
    //logic Rk_alu, Rk_mul, Rk_lsu, Rk_sldu, Rk_red;              // indicates if Fk is available (1)
    logic [5:0] op_alu, op_mul, op_lsu, op_sldu, op_red;        // vector operation (6) (decoder)
    //logic [IST_ENTRY_BITS-1:0] instr_1, instr_2, instr_3, instr_4, instr_5, instr_6, instr_7, instr_8; // IST 
    //logic [IST_ENTRY_BITS-1:0] alu_read, mul_read, lsu_read, sldu_read, red_read; 
    logic [IST_ENTRY_BITS-1:0] alu_exec, mul_exec, lsu_exec, sldu_exec, red_exec, wb_instr;
    logic [2:0] alu_read_index, mul_read_index, lsu_read_index, sldu_read_index, red_read_index, wb_instr_index; 
    logic [2:0] alu_exec_index, mul_exec_index, lsu_exec_index, sldu_exec_index, red_exec_index;
    //logic raw_alu_1, raw_mul_1, raw_lsu_1, raw_sldu_1, raw_red_1;
    logic [2:0] raw_alu_2, raw_mul_2, raw_lsu_2, raw_sldu_2, raw_red_2;
    
    assign fifo_full = (fifo_count == NO_OF_SLOTS);
    assign instr_1 = instr_status_table[0];
    assign instr_2 = instr_status_table[1];
    assign instr_3 = instr_status_table[2];
    assign instr_4 = instr_status_table[3];
    assign instr_5 = instr_status_table[4];
    assign instr_6 = instr_status_table[5];
    assign instr_7 = instr_status_table[6];
    assign instr_8 = instr_status_table[7];

    initial begin
        for (int i = 0; i < NO_OF_SLOTS; i++) begin
            fifo_count <= 3'b0000;
            instr_status_table[i] <= {IST_ENTRY_BITS{1'b0}};
        end 
        busy_alu = 0; busy_mul = 0; busy_lsu = 0; busy_sldu = 0; busy_red = 0;
        Fi_alu = 0; Fi_mul = 0; Fi_lsu = 0; Fi_sldu = 0; Fi_red = 0;
    end

    // FIFO Count Condition
    always @(!clk) begin
        op = (v_alu_op != 0) ? 3'b001: (is_mul != 0) ? 3'b010: v_lsu_op != 0 ? 3'b011: (v_sldu_op != 0) ? 3'b100: (v_red_op != 0) ? 3'b101:3'b000;
        op_instr = op == 3'b001 ? v_alu_op: op == 3'b010 ? is_mul: op == 3'b011 ? v_lsu_op: op == 3'b100 ? v_sldu_op: 3'b101 ? v_red_op: 0;
        // Write to Instruction Status Table
        if (!nrst) begin
            for (int i = 0; i < NO_OF_SLOTS + 1; i++) begin
                fifo_count = 3'b000;
                instr_status_table[i] <= {IST_ENTRY_BITS{1'b0}};
            end
        end else begin
            if (!fifo_full) begin
            instr_status_table[fifo_count] = {vsew, lmul, sel_op_A, sel_op_B, op, op_instr, src_A, src_B, dest, imm, 3'b001};
            fifo_count = fifo_count + 1;
            end
        end

        // Issue
        if (instr_1[29:27] != 0 && instr_1[2:0] == 3'b001) begin
            instr_status_table[0][2:0] = 3'b010;
        end
        else if (instr_2[29:27] != 0 && instr_2[2:0] == 3'b001) begin 
            instr_status_table[1][2:0] = 3'b010;
        end
        else if (instr_3[29:27] != 0 && instr_3[2:0] == 3'b001) begin
            instr_status_table[2][2:0] = 3'b010;
        end
        else if (instr_4[29:27] != 0 && instr_4[2:0] == 3'b001) begin
            instr_status_table[3][2:0] = 3'b010;
        end
        else if (instr_5[29:27] != 0 && instr_5[2:0] == 3'b001) begin
            instr_status_table[4][2:0] = 3'b010;
        end
        else if (instr_6[29:27] != 0 && instr_6[2:0] == 3'b001) begin
            instr_status_table[5][2:0] = 3'b010;
        end
        else if (instr_7[29:27] != 0 && instr_7[2:0] == 3'b001) begin
            instr_status_table[6][2:0] = 3'b010;
        end
        else if (instr_8[29:27] != 0 && instr_8[2:0] == 3'b001) begin
            instr_status_table[7][2:0] = 3'b010;
        end
            

    // ******************READ******************
        //alu
        alu_read = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b010) ? instr_1: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b010) ? instr_2: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b010) ? instr_3: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b010) ? instr_4: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b010) ? instr_5: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b010) ? instr_6: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b010) ? instr_7: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b010) ? instr_8: 0);
        alu_read_index = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b010) ? 0: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b010) ? 1: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b010) ? 2: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b010) ? 3: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b010) ? 4: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b010) ? 5: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b010) ? 6: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b010) ? 7: 0);
        if (alu_read != 0) begin
            if(!busy_alu) begin
                vsew_alu = alu_read[37:36];
                lmul_alu = alu_read[35:34];
                op_alu = alu_read[26:23];
                Fi_alu = alu_read[12:8];
                Fj_alu = (alu_read[33:32] != 2'b11 ? alu_read[22:18]: 0);
                Fk_alu = (alu_read[31:30] != 2'b11 ? alu_read[17:13]: 0);
                Imm_alu = ((alu_read[31:30] == 2'b11 || alu_read[33:32] == 2'b11) ? alu_read[7:3]: 0);
                raw_alu_1 = (Fj_alu == Fi_alu ? 3'b001: Fj_alu == Fi_mul ? 3'b010: Fj_alu == Fi_lsu ? 3'b011: Fj_alu == Fi_sldu ? 3'b100: Fj_alu == Fi_red ? 3'b101: 3'b000);
                raw_alu_2 = (Fk_alu == Fi_alu ? 3'b001: Fk_alu == Fi_mul ? 3'b010: Fk_alu == Fi_lsu ? 3'b011: Fk_alu == Fi_sldu ? 3'b100: Fk_alu == Fi_red ? 3'b101: 3'b000);
                Qj_alu = (alu_read[33:32] == 10 ? 3'b110: alu_read[32:31] == 11 ? 3'b111: (raw_alu_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_alu_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_alu_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_alu_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_alu_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_alu = (alu_read[31:30] == 10 ? 3'b110: alu_read[30:29] == 11 ? 3'b111: (raw_alu_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_alu_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_alu_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_alu_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_alu_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_alu = ((Qj_alu == 3'b000 || Qj_alu == 3'b110 || Qj_alu == 3'b111) ? 1: (done_alu == 1 && Qj_alu == 3'b001) ? 1: (done_mul == 1 && Qj_alu == 3'b010) ? 1: (done_lsu == 1 && Qj_alu == 3'b011) ? 1: (done_sldu == 1 && Qj_alu == 3'b100) ? 1: (done_red == 1 && Qj_alu == 3'b101) ? 1: 0);
                Rk_alu = ((Qk_alu == 3'b000 || Qk_alu == 3'b110 || Qk_alu == 3'b111) ? 1: (done_alu == 1 && Qk_alu == 3'b001) ? 1: (done_mul == 1 && Qk_alu == 3'b010) ? 1: (done_lsu == 1 && Qk_alu == 3'b011) ? 1: (done_sldu == 1 && Qk_alu == 3'b100) ? 1: (done_red == 1 && Qk_alu == 3'b101) ? 1: 0);
                busy_alu = ((Rj_alu == 1 && Rk_alu == 1) ? 1: 0); 
                alu_read [2:0] = ((Rj_alu == 1 && Rk_alu == 1) ? 3'b011: 3'b010); 
                instr_status_table[alu_read_index] = alu_read;
            end
        end

        //mul
        mul_read = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b010) ? instr_1: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b010) ? instr_2: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b010) ? instr_3: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b010) ? instr_4: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b010) ? instr_5: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b010) ? instr_6: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b010) ? instr_7: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b010) ? instr_8: 0);
        mul_read_index = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b010) ? 0: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b010) ? 1: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b010) ? 2: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b010) ? 3: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b010) ? 4: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b010) ? 5: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b010) ? 6: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b010) ? 7: 0);
        if (mul_read != 0) begin
            if(!busy_mul) begin
                vsew_mul = mul_read[37:36];
                lmul_mul = mul_read[35:34];
                op_mul = mul_read[26:23];
                Fi_mul = mul_read[12:8];
                Fj_mul = (mul_read[33:32] != 2'b11 ? mul_read[22:18]: 0);
                Fk_mul = (mul_read[31:30] != 2'b11 ? mul_read[17:13]: 0);
                Imm_mul = ((mul_read[31:30] == 2'b11 || mul_read[33:32] == 2'b11) ? mul_read[7:3]: 0);
                raw_mul_1 = (Fj_mul == Fi_alu ? 3'b001: Fj_mul == Fi_mul ? 3'b010: Fj_mul == Fi_lsu ? 3'b011: Fj_mul == Fi_sldu ? 3'b100: Fj_mul == Fi_red ? 3'b101: 3'b000);
                raw_mul_2 = (Fk_mul == Fi_alu ? 3'b001: Fk_mul == Fi_mul ? 3'b010: Fk_mul == Fi_lsu ? 3'b011: Fk_mul == Fi_sldu ? 3'b100: Fk_mul == Fi_red ? 3'b101: 3'b000);
                Qj_mul = (mul_read[33:32] == 10 ? 3'b110: mul_read[32:31] == 11 ? 3'b111: (raw_mul_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_mul_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_mul_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_mul_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_mul_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_mul = (mul_read[31:30] == 10 ? 3'b110: mul_read[30:29] == 11 ? 3'b111: (raw_mul_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_mul_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_mul_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_mul_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_mul_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_mul = ((Qj_mul == 3'b000 || Qj_mul == 3'b110 || Qj_mul == 3'b111) ? 1: (done_alu == 1 && Qj_mul == 3'b001) ? 1: (done_mul == 1 && Qj_mul == 3'b010) ? 1: (done_lsu == 1 && Qj_mul == 3'b011) ? 1: (done_sldu == 1 && Qj_mul == 3'b100) ? 1: (done_red == 1 && Qj_mul == 3'b101) ? 1: 0);
                Rk_mul = ((Qk_mul == 3'b000 || Qk_mul == 3'b110 || Qk_mul == 3'b111) ? 1: (done_alu == 1 && Qk_mul == 3'b001) ? 1: (done_mul == 1 && Qk_mul == 3'b010) ? 1: (done_lsu == 1 && Qk_mul == 3'b011) ? 1: (done_sldu == 1 && Qk_mul == 3'b100) ? 1: (done_red == 1 && Qk_mul == 3'b101) ? 1: 0);
                busy_mul = ((Rj_mul == 1 && Rk_mul == 1) ? 1: 0); 
                mul_read [2:0] = ((Rj_mul == 1 && Rk_mul == 1) ? 3'b011: 3'b010); 
                instr_status_table[mul_read_index] = mul_read;
            end
        end

        //lsu
        lsu_read = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b010) ? instr_1: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b010) ? instr_2: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b010) ? instr_3: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b010) ? instr_4: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b010) ? instr_5: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b010) ? instr_6: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b010) ? instr_7: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b010) ? instr_8: 0);
        lsu_read_index = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b010) ? 0: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b010) ? 1: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b010) ? 2: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b010) ? 3: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b010) ? 4: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b010) ? 5: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b010) ? 6: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b010) ? 7: 0);
        if (lsu_read != 0) begin
            if(!busy_lsu) begin
                vsew_lsu = lsu_read[37:36];
                lmul_lsu = lsu_read[35:34];
                op_lsu = lsu_read[26:23];
                Fi_lsu = lsu_read[12:8];
                Fj_lsu = (lsu_read[33:32] != 2'b11 ? lsu_read[22:18]: 0);
                Fk_lsu = (lsu_read[31:30] != 2'b11 ? lsu_read[17:13]: 0);
                Imm_lsu = ((lsu_read[31:30] == 2'b11 || lsu_read[33:32] == 2'b11) ? lsu_read[7:3]: 0);
                raw_lsu_1 = (Fj_lsu == Fi_alu ? 3'b001: Fj_lsu == Fi_mul ? 3'b010: Fj_lsu == Fi_lsu ? 3'b011: Fj_lsu == Fi_sldu ? 3'b100: Fj_lsu == Fi_red ? 3'b101: 3'b000);
                raw_lsu_2 = (Fk_lsu == Fi_alu ? 3'b001: Fk_lsu == Fi_mul ? 3'b010: Fk_lsu == Fi_lsu ? 3'b011: Fk_lsu == Fi_sldu ? 3'b100: Fk_lsu == Fi_red ? 3'b101: 3'b000);
                Qj_lsu = (lsu_read[33:32] == 10 ? 3'b110: lsu_read[32:31] == 11 ? 3'b111: (raw_lsu_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_lsu_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_lsu_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_lsu_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_lsu_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_lsu = (lsu_read[31:30] == 10 ? 3'b110: lsu_read[30:29] == 11 ? 3'b111: (raw_lsu_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_lsu_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_lsu_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_lsu_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_lsu_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_lsu = ((Qj_lsu == 3'b000 || Qj_lsu == 3'b110 || Qj_lsu == 3'b111) ? 1: (done_alu == 1 && Qj_mul == 3'b001) ? 1: (done_mul == 1 && Qj_lsu == 3'b010) ? 1: (done_lsu == 1 && Qj_lsu == 3'b011) ? 1: (done_sldu == 1 && Qj_lsu == 3'b100) ? 1: (done_red == 1 && Qj_lsu == 3'b101) ? 1: 0);
                Rk_lsu = ((Qk_lsu == 3'b000 || Qk_lsu == 3'b110 || Qk_lsu == 3'b111) ? 1: (done_alu == 1 && Qk_mul == 3'b001) ? 1: (done_mul == 1 && Qk_lsu == 3'b010) ? 1: (done_lsu == 1 && Qk_lsu == 3'b011) ? 1: (done_sldu == 1 && Qk_lsu == 3'b100) ? 1: (done_red == 1 && Qk_lsu == 3'b101) ? 1: 0);
                busy_lsu = ((Rj_lsu == 1 && Rk_lsu == 1) ? 1: 0); 
                lsu_read [2:0] = ((Rj_lsu == 1 && Rk_lsu == 1) ? 3'b011: 3'b010); 
                instr_status_table[lsu_read_index] = lsu_read;
            end
        end

        //sldu
        sldu_read = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b010) ? instr_1: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b010) ? instr_2: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b010) ? instr_3: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b010) ? instr_4: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b010) ? instr_5: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b010) ? instr_6: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b010) ? instr_7: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b010) ? instr_8: 0);
        sldu_read_index = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b010) ? 0: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b010) ? 1: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b010) ? 2: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b010) ? 3: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b010) ? 4: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b010) ? 5: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b010) ? 6: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b010) ? 7: 0);
        if (sldu_read != 0) begin
            if(!busy_sldu) begin
                vsew_sldu = sldu_read[37:36];
                lmul_sldu = sldu_read[35:34];
                op_sldu = sldu_read[26:23];
                Fi_sldu = sldu_read[12:8];
                Fj_sldu = (sldu_read[33:32] != 2'b11 ? sldu_read[22:18]: 0);
                Fk_sldu = (sldu_read[31:30] != 2'b11 ? sldu_read[17:13]: 0);
                Imm_sldu = ((sldu_read[31:30] == 2'b11 || sldu_read[33:32] == 2'b11) ? sldu_read[7:3]: 0);
                raw_sldu_1 = (Fj_sldu == Fi_alu ? 3'b001: Fj_sldu == Fi_mul ? 3'b010: Fj_sldu == Fi_lsu ? 3'b011: Fj_sldu == Fi_sldu ? 3'b100: Fj_sldu == Fi_red ? 3'b101: 3'b000);
                raw_sldu_2 = (Fk_sldu == Fi_alu ? 3'b001: Fk_sldu == Fi_mul ? 3'b010: Fk_sldu == Fi_lsu ? 3'b011: Fk_sldu == Fi_sldu ? 3'b100: Fk_sldu == Fi_red ? 3'b101: 3'b000);
                Qj_sldu = (sldu_read[33:32] == 10 ? 3'b110: sldu_read[32:31] == 11 ? 3'b111: (raw_sldu_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_sldu_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_sldu_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_sldu_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_sldu_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_sldu = (sldu_read[31:30] == 10 ? 3'b110: sldu_read[30:29] == 11 ? 3'b111: (raw_sldu_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_sldu_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_sldu_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_sldu_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_sldu_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_sldu = ((Qj_sldu == 3'b000 || Qj_sldu == 3'b110 || Qj_sldu == 3'b111) ? 1: (done_alu == 1 && Qj_sldu == 3'b001) ? 1: (done_mul == 1 && Qj_sldu == 3'b010) ? 1: (done_lsu == 1 && Qj_sldu == 3'b011) ? 1: (done_sldu == 1 && Qj_sldu == 3'b100) ? 1: (done_red == 1 && Qj_sldu == 3'b101) ? 1: 0);
                Rk_sldu = ((Qk_sldu == 3'b000 || Qk_sldu == 3'b110 || Qk_sldu == 3'b111) ? 1: (done_alu == 1 && Qk_sldu == 3'b001) ? 1: (done_mul == 1 && Qk_sldu == 3'b010) ? 1: (done_lsu == 1 && Qk_sldu == 3'b011) ? 1: (done_sldu == 1 && Qk_sldu == 3'b100) ? 1: (done_red == 1 && Qk_sldu == 3'b101) ? 1: 0);
                busy_sldu = ((Rj_sldu == 1 && Rk_sldu == 1) ? 1: 0); 
                sldu_read [2:0] = ((Rj_sldu == 1 && Rk_sldu == 1) ? 3'b011: 3'b010); 
                instr_status_table[sldu_read_index] = sldu_read;
            end
        end

        //red
        red_read = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b010) ? instr_1: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b010) ? instr_2: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b010) ? instr_3: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b010) ? instr_4: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b010) ? instr_5: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b010) ? instr_6: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b010) ? instr_7: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b010) ? instr_8: 0);
        red_read_index = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b010) ? 0: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b010) ? 1: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b010) ? 2: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b010) ? 3: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b010) ? 4: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b010) ? 5: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b010) ? 6: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b010) ? 7: 0);
        if (red_read != 0) begin
            if(!busy_red) begin
                vsew_red = red_read[37:36];
                lmul_red = red_read[35:34];
                op_red = red_read[26:23];
                Fi_red = red_read[12:8];
                Fj_red = (red_read[33:32] != 2'b11 ? red_read[22:18]: 0);
                Fk_red = (red_read[31:30] != 2'b11 ? red_read[17:13]: 0);
                Imm_red = ((red_read[31:30] == 2'b11 || red_read[33:32] == 2'b11) ? red_read[7:3]: 0);
                raw_red_1 = (Fj_red == Fi_alu ? 3'b001: Fj_red == Fi_mul ? 3'b010: Fj_red == Fi_lsu ? 3'b011: Fj_red == Fi_sldu ? 3'b100: Fj_red == Fi_red ? 3'b101: 3'b000);
                raw_red_2 = (Fk_red == Fi_alu ? 3'b001: Fk_red == Fi_mul ? 3'b010: Fk_red == Fi_lsu ? 3'b011: Fk_red == Fi_sldu ? 3'b100: Fk_red == Fi_red ? 3'b101: 3'b000);
                Qj_red = (red_read[33:32] == 10 ? 3'b110: red_read[32:31] == 11 ? 3'b111: (raw_red_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_red_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_red_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_red_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_red_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_red = (red_read[31:30] == 10 ? 3'b110: red_read[30:29] == 11 ? 3'b111: (raw_red_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_red_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_red_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_red_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_red_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_red = ((Qj_red == 3'b000 || Qj_red == 3'b110 || Qj_red == 3'b111) ? 1: (done_alu == 1 && Qj_red == 3'b001) ? 1: (done_mul == 1 && Qj_red == 3'b010) ? 1: (done_lsu == 1 && Qj_red == 3'b011) ? 1: (done_sldu == 1 && Qj_red == 3'b100) ? 1: (done_red == 1 && Qj_red == 3'b101) ? 1: 0);
                Rk_red = ((Qk_red == 3'b000 || Qk_red == 3'b110 || Qk_red == 3'b111) ? 1: (done_alu == 1 && Qk_red == 3'b001) ? 1: (done_mul == 1 && Qk_red == 3'b010) ? 1: (done_lsu == 1 && Qk_red == 3'b011) ? 1: (done_sldu == 1 && Qk_red == 3'b100) ? 1: (done_red == 1 && Qk_red == 3'b101) ? 1: 0);
                busy_red = ((Rj_red == 1 && Rk_red == 1) ? 1: 0); 
                red_read [2:0] = ((Rj_red == 1 && Rk_red == 1) ? 3'b011: 3'b010); 
                instr_status_table[red_read_index] = red_read;
            end
        end


    // ******************EXECUTE******************
        //alu
        alu_exec = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        alu_exec_index = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b011) ? 7: 0);
        if (done_alu == 1 && alu_exec != 0) begin
            alu_exec[2:0] = 3'b100;
            instr_status_table[alu_exec_index] = alu_exec;
            vsew_alu = 0;
            op_alu = 0;
            Fi_alu = 0;
            Fj_alu = 0;
            Fk_alu = 0;
            Imm_alu = 0;
            raw_alu_1 = 0;
            raw_alu_2 = 0;
            Qj_alu = 0;
            Qk_alu = 0;
            Rj_alu = 0;
            Rk_alu = 0;
            busy_alu = 0;
        end
        
        //mul
        mul_exec = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        mul_exec_index = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b011) ? 7: 0);
        if (done_mul == 1 && mul_exec != 0) begin
            mul_exec[2:0] = 3'b100;
            instr_status_table[mul_exec_index] = mul_exec;
            vsew_mul = 0;
            op_mul = 0;
            Fi_mul = 0;
            Fj_mul = 0;
            Fk_mul = 0;
            Imm_mul = 0;
            raw_mul_1 = 0;
            raw_mul_2 = 0;
            Qj_mul = 0;
            Qk_mul = 0;
            Rj_mul = 0;
            Rk_mul = 0;
            busy_mul = 0;
        end

        //lsu
        lsu_exec = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        lsu_exec_index = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b011) ? 7: 0);
        if (done_lsu == 1 && lsu_exec != 0) begin
            lsu_exec[2:0] = 3'b100;
            instr_status_table[lsu_exec_index] = lsu_exec;
            vsew_lsu = 0;
            op_lsu = 0;
            Fi_lsu = 0;
            Fj_lsu = 0;
            Fk_lsu = 0;
            Imm_lsu = 0;
            raw_lsu_1 = 0;
            raw_lsu_2 = 0;
            Qj_lsu = 0;
            Qk_lsu = 0;
            Rj_lsu = 0;
            Rk_lsu = 0;
            busy_lsu = 0;
        end

        //sldu
        sldu_exec = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        sldu_exec_index = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b011) ? 7: 0);
        if (done_sldu == 1 && sldu_exec != 0) begin
            sldu_exec[2:0] = 3'b100;
            instr_status_table[sldu_exec_index] = sldu_exec;
            vsew_sldu = 0;
            op_sldu = 0;
            Fi_sldu = 0;
            Fj_sldu = 0;
            Fk_sldu = 0;
            Imm_sldu = 0;
            raw_sldu_1 = 0;
            raw_sldu_2 = 0;
            Qj_sldu = 0;
            Qk_sldu = 0;
            Rj_sldu = 0;
            Rk_sldu = 0;
            busy_sldu = 0;
        end

        //red
        red_exec = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        red_exec_index = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b011) ? 7: 0);
        if (done_red == 1 && red_exec != 0) begin
            red_exec[2:0] = 3'b100;
            instr_status_table[red_exec_index] = red_exec;
            vsew_red = 0;
            op_red = 0;
            Fi_red = 0;
            Fj_red = 0;
            Fk_red = 0;
            Imm_red = 0;
            raw_red_1 = 0;
            raw_red_2 = 0;
            Qj_red = 0;
            Qk_red = 0;
            Rj_red = 0;
            Rk_red = 0;
            busy_red = 0;
        end

    // ******************WRITE******************
        wb_instr = ((instr_1[2:0] == 3'b100) ? instr_1: (instr_2[2:0] == 3'b100) ? instr_2: (instr_3[2:0] == 3'b100) ? instr_3: (instr_4[2:0] == 3'b100) ? instr_4: (instr_5[2:0] == 3'b100) ? instr_5: (instr_6[2:0] == 3'b100) ? instr_6: (instr_7[2:0] == 3'b100) ? instr_7: (instr_8[2:0] == 3'b100) ? instr_8: 0);
        wb_instr_index = ((instr_1[2:0] == 3'b100) ? 0: (instr_2[2:0] == 3'b100) ? 1: (instr_3[2:0] == 3'b100) ? 2: (instr_4[2:0] == 3'b100) ? 3: (instr_5[2:0] == 3'b100) ? 4: (instr_6[2:0] == 3'b100) ? 5: (instr_7[2:0] == 3'b100) ? 6: (instr_8[2:0] == 3'b100) ? 7: 0);
        if (wb_instr !=0 ) begin
        case (wb_instr[29:27])
            default: ;
            3'b001: begin
                reg_wr_en <= 1;
                reg_wr_data <= result_valu;
                reg_wr_data_2 <= result_valu;
                reg_wr_data_3 <= result_valu;
                reg_wr_data_4 <= result_valu;
                instr_status_table[wb_instr_index] <= {IST_ENTRY_BITS{1'b0}};                
            end
            3'b010: begin
                reg_wr_en <= 1;
                reg_wr_data <= result_vmul;
                reg_wr_data_2 <= result_vmul;
                reg_wr_data_3 <= result_vmul;
                reg_wr_data_4 <= result_vmul; 
                instr_status_table[wb_instr_index] <= {IST_ENTRY_BITS{1'b0}};        
            end
            3'b011: begin
                reg_wr_en <= 1;
                reg_wr_data <= result_vlsu;
                reg_wr_data_2 <= result_vlsu;
                reg_wr_data_3 <= result_vlsu;
                reg_wr_data_4 <= result_vlsu;
                instr_status_table[wb_instr_index] <= {IST_ENTRY_BITS{1'b0}};       
            end
            3'b100: begin
                reg_wr_en <= 1;
                reg_wr_data <= result_vsldu[127:0];
                reg_wr_data_2 <= result_vsldu[255:128];
                reg_wr_data_3 <= result_vsldu[383:256];
                reg_wr_data_4 <= result_vsldu[511:384];  
                instr_status_table[wb_instr_index] <= {IST_ENTRY_BITS{1'b0}};   
            end
            3'b101: begin
                reg_wr_en <= 0;
                el_wr_en <= 1;
                reg_wr_data <= result_vred;
                reg_wr_data_2 <= {128{1'b0}};
                reg_wr_data_3 <= {128{1'b0}};
                reg_wr_data_4 <= {128{1'b0}};    
                instr_status_table[wb_instr_index] <= {IST_ENTRY_BITS{1'b0}};    
                /*for (int i = wb_instr_index; i < NO_OF_SLOTS; i++) begin
                instr_status_table[i] <= instr_status_table[i+1];
                end
                instr_status_table[7] <= {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;   */
            end
        endcase
        end
    end
endmodule
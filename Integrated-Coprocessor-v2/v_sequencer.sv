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
    input logic is_mul, is_vstype,
    input logic done_alu, done_mul, done_lsu, done_sldu, done_red,
    input logic [127:0] result_valu_1, result_valu_2, result_valu_3, result_valu_4, result_vmul_1, result_vmul_2, result_vmul_3, result_vmul_4, 
    input logic [31:0] result_vred,
    input logic [511:0] result_vsldu, result_vlsu,
    output logic [2:0] optype_read,
    output logic [4:0] dest_wb,
    output logic [3:0] op_alu, op_mul, op_lsu, op_sldu, op_red,        // vector operation (6) (decoder)
    output logic [2:0] vsew_alu, vsew_mul, vsew_lsu, vsew_sldu, vsew_red,        // Functional unit producing Fj (3) 
    output logic [2:0] lmul_alu, lmul_mul, lmul_lsu, lmul_sldu, lmul_red,       // Functional unit producing Fk(3) (is_type)
    output logic [2:0] Qj_alu, Qj_mul, Qj_lsu, Qj_sldu, Qj_red,        // Functional unit producing Fj (3) 
    output logic [2:0] Qk_alu, Qk_mul, Qk_lsu, Qk_sldu, Qk_red,       // Functional unit producing Fk(3) (is_type)
    output logic [4:0] Fj_alu, Fj_mul, Fj_lsu, Fj_sldu, Fj_red,        // source register 1 (5) (decoder)
    output logic [4:0] Fk_alu, Fk_mul, Fk_lsu, Fk_sldu, Fk_red,        // source register 2 (5) (decoder)
    output logic [4:0] Fi_alu, Fi_mul, Fi_lsu, Fi_sldu, Fi_red,       // destination reg (5) (decoder)
    output logic [4:0] Imm_alu, Imm_mul, Imm_lsu, Imm_sldu, Imm_red,  // scalar operand (5) (decoder)
    output logic v_reg_wr_en, x_reg_wr_en, el_wr_en,
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
    logic [2:0] instr_status;
    logic [2:0] op;
    logic [3:0] op_instr;
    //logic [4:0] src_A;
    logic wr_alu = 0;
    logic busy_alu = 0;
    logic busy_mul = 0; 
    logic busy_lsu = 0; 
    logic busy_sldu = 0; 
    logic busy_red = 0;     // indicates if the fu is available (1),
    logic Rj_alu, Rj_mul, Rj_lsu, Rj_sldu, Rj_red;              // indicates if Fj is available (1),
    logic Rk_alu, Rk_mul, Rk_lsu, Rk_sldu, Rk_red;              // indicates if Fk is available (1)
    logic [IST_ENTRY_BITS-1:0] instr_1, instr_2, instr_3, instr_4, instr_5, instr_6, instr_7, instr_8; // IST 
    logic [IST_ENTRY_BITS-1:0] instr_read; 
    logic [IST_ENTRY_BITS-1:0] alu_exec, mul_exec, lsu_exec, sldu_exec, red_exec, wb_instr;
    logic [2:0] instr_read_index; 
    logic [2:0] alu_exec_index, mul_exec_index, lsu_exec_index, sldu_exec_index, red_exec_index, wb_instr_index;
    logic [2:0] raw_alu_1, raw_mul_1, raw_lsu_1, raw_sldu_1, raw_red_1;
    logic [2:0] raw_alu_2, raw_mul_2, raw_lsu_2, raw_sldu_2, raw_red_2;
    logic [2:0] sel_dest_alu, sel_dest_mul, sel_dest_lsu, sel_dest_sldu, sel_dest_red;
    
    logic busy_read = 0;   // indicates if the fu is available (1),
    logic Rj_read;              // indicates if Fj is available (1),
    logic Rk_read;  
    logic [2:0] raw_read_1;
    logic [2:0] raw_read_2;
    logic [2:0] sel_dest_read;
    logic [3:0] op_read;       // vector operation (6) (decoder)
    logic [2:0] vsew_read;       // Functional unit producing Fj (3) 
    logic [2:0] lmul_read;       // Functional unit producing Fk(3) (is_type)
    logic [2:0] Qj_read;        // Functional unit producing Fj (3) 
    logic [2:0] Qk_read;       // Functional unit producing Fk(3) (is_type)
    logic [4:0] Fj_read;        // source register 1 (5) (decoder)
    logic [4:0] Fk_read;        // source register 2 (5) (decoder)
    logic [4:0] Fi_read;    // destination reg (5) (decoder)
    logic [4:0] Imm_read;
    
    assign fifo_full = (fifo_count == NO_OF_SLOTS);
    assign instr_1 = instr_status_table[0];
    assign instr_2 = instr_status_table[1];
    assign instr_3 = instr_status_table[2];
    assign instr_4 = instr_status_table[3];
    assign instr_5 = instr_status_table[4];
    assign instr_6 = instr_status_table[5];
    assign instr_7 = instr_status_table[6];
    assign instr_8 = instr_status_table[7];
    assign Fi_alu = 0;
    assign Fi_mul = 0;
    assign Fi_lsu = 0;
    assign Fi_sldu = 0;
    assign Fi_red = 0;

    initial begin
        for (int i = 0; i < NO_OF_SLOTS; i++) begin
            fifo_count = 3'b0000;
            instr_status_table[i] = {IST_ENTRY_BITS{1'b0}};
        end 
    //    Fi_alu = 0; Fi_mul = 0; Fi_lsu = 0; Fi_sldu = 0; Fi_red = 0;
    end

    // FIFO Count Condition
    always @(posedge clk && base_instr) begin
        //#1
        op = (v_alu_op != 0) ? 3'b001: (is_mul != 0) ? 3'b010: v_lsu_op != 0 ? 3'b011: (v_sldu_op != 0) ? 3'b100: (v_red_op != 0) ? 3'b101:3'b000;
        op_instr = op == 3'b001 ? v_alu_op: op == 3'b010 ? is_mul: op == 3'b011 ? v_lsu_op: op == 3'b100 ? v_sldu_op: 3'b101 ? v_red_op: 0;
        //src_A = (is_vstype) ? src_A_2 : src_A_1;
        // Write to Instruction Status Table
/*        if (!nrst) begin
            signal_c = 0;
            for (int i = 0; i < NO_OF_SLOTS; i++) begin
                fifo_count = 3'b000;
                instr_status_table[i] = {IST_ENTRY_BITS{1'b0}};
            end*/
//        end else begin
            //signal_c = clk;
            //if(pos_edge)begin
            if (fifo_full == 0 && base_instr != 0) begin
            instr_status_table[fifo_count] = {sel_dest, vsew, lmul, sel_op_A, sel_op_B, op, op_instr, src_A, src_B, dest, imm, 3'b001};
            fifo_count = fifo_count + 1;
            end
            //end
        end
//    end

    always @(clk) begin
        if (wb_instr !=0 ) begin
        v_reg_wr_en = (wb_instr[39:38]==1) ? 1: 0;
        x_reg_wr_en = (wb_instr[39:38]==2) ? 1: 0;
        case(wb_instr_index)
            default: ;
            3'b000: begin
                instr_status_table[0] <= instr_status_table[1];
                instr_status_table[1] <= instr_status_table[2];
                instr_status_table[2] <= instr_status_table[3];
                instr_status_table[3] <= instr_status_table[4];
                instr_status_table[4] <= instr_status_table[5];
                instr_status_table[5] <= instr_status_table[6];
                instr_status_table[6] <= instr_status_table[7];
                instr_status_table[7] <= {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b001: begin
                instr_status_table[1] = instr_status_table[2];
                instr_status_table[2] = instr_status_table[3];
                instr_status_table[3] = instr_status_table[4];
                instr_status_table[4] = instr_status_table[5];
                instr_status_table[5] = instr_status_table[6];
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b010: begin
                instr_status_table[2] = instr_status_table[3];
                instr_status_table[3] = instr_status_table[4];
                instr_status_table[4] = instr_status_table[5];
                instr_status_table[5] = instr_status_table[6];
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b011: begin
                instr_status_table[3] = instr_status_table[4];
                instr_status_table[4] = instr_status_table[5];
                instr_status_table[5] = instr_status_table[6];
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b100: begin
                instr_status_table[4] = instr_status_table[5];
                instr_status_table[5] = instr_status_table[6];
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b101: begin
                instr_status_table[5] = instr_status_table[6];
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b110: begin
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b111: begin
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;        
            end     
        endcase
        end
        else begin
            v_reg_wr_en = 0;
            x_reg_wr_en = 0;    
        end
    end

    always @(*) begin
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
        instr_read = ((instr_1[2:0] == 3'b010) ? instr_1: (instr_2[2:0] == 3'b010) ? instr_2: (instr_3[2:0] == 3'b010) ? instr_3: (instr_4[2:0] == 3'b010) ? instr_4: (instr_5[2:0] == 3'b010) ? instr_5: (instr_6[2:0] == 3'b010) ? instr_6: (instr_7[2:0] == 3'b010) ? instr_7: (instr_8[2:0] == 3'b010) ? instr_8: 0);        
        instr_read_index = ((instr_1[2:0] == 3'b010) ? 0: (instr_2[2:0] == 3'b010) ? 1: (instr_3[2:0] == 3'b010) ? 2: (instr_4[2:0] == 3'b010) ? 3: (instr_5[2:0] == 3'b010) ? 4: (instr_6[2:0] == 3'b010) ? 5: (instr_7[2:0] == 3'b010) ? 6: (instr_8[2:0] == 3'b010) ? 7: 0);
/*
        if (instr_read != 0) begin
            optype_read = instr_read[29:27];
            sel_dest_read = instr_read[39:38];
            vsew_read = instr_read[37:36];
            lmul_read = instr_read[35:34];
            Fi_read = instr_read[12:8];
            Fj_read = (instr_read[33:32] != 2'b11 ? instr_read[22:18]: 0);
            Fk_read = (instr_read[31:30] != 2'b11 ? instr_read[17:13]: 0);
            Imm_read = ((instr_read[31:30] == 2'b11 || instr_read[33:32] == 2'b11) ? instr_read[7:3]: 0);
            raw_read_1 = (Fj_read == Fi_alu ? 3'b001: Fj_read == Fi_mul ? 3'b010: Fj_read == Fi_lsu ? 3'b011: Fj_read == Fi_sldu ? 3'b100: Fj_read == Fi_red ? 3'b101: 3'b000);
            raw_read_2 = (Fk_read == Fi_read ? 3'b001: Fk_read == Fi_mul ? 3'b010: Fk_read == Fi_lsu ? 3'b011: Fk_read == Fi_sldu ? 3'b100: Fk_read == Fi_red ? 3'b101: 3'b000);
            Qj_read = (instr_read[33:32] == 2'b10 ? 3'b110: instr_read[33:32] == 2'b11 ? 3'b111: (raw_read_1 == 3'b001) ? 3'b001: (raw_read_1 == 3'b010)  ? 3'b010: (raw_read_1 == 3'b011)  ? 3'b011: (raw_read_1 == 3'b100)  ? 3'b100: (raw_read_1 == 3'b101)  ? 3'b101: 3'b000);
            Qk_read = (instr_read[31:30] == 2'b10 ? 3'b110: instr_read[31:30] == 2'b11 ? 3'b111: (raw_read_2 == 3'b001) ? 3'b001: (raw_read_2 == 3'b010)  ? 3'b010: (raw_read_2 == 3'b011)  ? 3'b011: (raw_read_2 == 3'b100)  ? 3'b100: (raw_read_2 == 3'b101)  ? 3'b101: 3'b000);
            Rj_read = ((Qj_read == 3'b000 || Qj_read == 3'b110 || Qj_read == 3'b111) ? 1: (busy_read == 0 && Qj_read == 3'b001) ? 1: (busy_mul == 0 && Qj_read == 3'b010) ? 1: (busy_lsu == 0 && Qj_read == 3'b011) ? 1: (busy_sldu == 0 && Qj_read == 3'b100) ? 1: (busy_red == 0 && Qj_read == 3'b101) ? 1: 0);
            Rk_read = ((Qk_read == 3'b000 || Qk_read == 3'b110 || Qk_read == 3'b111) ? 1: (busy_read == 0 && Qk_read == 3'b001) ? 1: (busy_mul == 0 && Qk_read == 3'b010) ? 1: (busy_lsu == 0 && Qk_read == 3'b011) ? 1: (busy_sldu == 0 && Qk_read == 3'b100) ? 1: (busy_red == 0 && Qk_read == 3'b101) ? 1: 0);
            busy_read = ((Rj_read == 1 && Rk_read == 1) ? 1: 0); 
            instr_read [2:0] = ((Rj_read == 1 && Rk_read == 1) ? 3'b011: 3'b010); 
            instr_status_table[instr_read_index] = instr_read;
        end

        if (instr_read !=0 && busy_read == 1 && instr_read[29:27] == 3'b001 && busy_alu == 0) begin
            sel_dest_alu = sel_dest_read;
            vsew_alu = vsew_read;
            lmul_alu = lmul_read;
            op_alu = op_read;
            Fj_alu = Fj_read;
            Fk_alu = Fk_read;
            Imm_alu = Imm_read;
            Fi_alu = instr_read[12:8];
            Qj_alu = Qj_read;
            Qk_alu = Qk_read;
            busy_alu = 1;
        end
*/

        if (instr_read != 0 && instr_read[29:27] == 3'b001) begin
            if(!busy_alu) begin
                optype_read = instr_read[29:27];
                sel_dest_alu = instr_read[39:38];
                vsew_alu = instr_read[37:36];
                lmul_alu = instr_read[35:34];
                op_alu = instr_read[26:23];
                Fj_alu = (instr_read[33:32] != 2'b11 ? instr_read[22:18]: 0);
                Fk_alu = (instr_read[31:30] != 2'b11 ? instr_read[17:13]: 0);
                Imm_alu = ((instr_read[31:30] == 2'b11 || instr_read[33:32] == 2'b11) ? instr_read[7:3]: 0);
                raw_alu_1 = (Fj_alu == Fi_alu ? 3'b001: Fj_alu == Fi_mul ? 3'b010: Fj_alu == Fi_lsu ? 3'b011: Fj_alu == Fi_sldu ? 3'b100: Fj_alu == Fi_red ? 3'b101: 3'b000);
                raw_alu_2 = (Fk_alu == Fi_alu ? 3'b001: Fk_alu == Fi_mul ? 3'b010: Fk_alu == Fi_lsu ? 3'b011: Fk_alu == Fi_sldu ? 3'b100: Fk_alu == Fi_red ? 3'b101: 3'b000);
                Fi_alu = instr_read[12:8];
                Qj_alu = (instr_read[33:32] == 2'b10 ? 3'b110: instr_read[33:32] == 2'b11 ? 3'b111: (raw_alu_1 == 3'b001) ? 3'b001: (raw_alu_1 == 3'b010)  ? 3'b010: (raw_alu_1 == 3'b011)  ? 3'b011: (raw_alu_1 == 3'b100)  ? 3'b100: (raw_alu_1 == 3'b101)  ? 3'b101: 3'b000);
                Qk_alu = (instr_read[31:30] == 2'b10 ? 3'b110: instr_read[31:30] == 2'b11 ? 3'b111: (raw_alu_2 == 3'b001) ? 3'b001: (raw_alu_2 == 3'b010)  ? 3'b010: (raw_alu_2 == 3'b011)  ? 3'b011: (raw_alu_2 == 3'b100)  ? 3'b100: (raw_alu_2 == 3'b101)  ? 3'b101: 3'b000);
                Rj_alu = ((Qj_alu == 3'b000 || Qj_alu == 3'b110 || Qj_alu == 3'b111) ? 1: (busy_alu == 0 && Qj_alu == 3'b001) ? 1: (busy_mul == 0 && Qj_alu == 3'b010) ? 1: (busy_lsu == 0 && Qj_alu == 3'b011) ? 1: (busy_sldu == 0 && Qj_alu == 3'b100) ? 1: (busy_red == 0 && Qj_alu == 3'b101) ? 1: 0);
                Rk_alu = ((Qk_alu == 3'b000 || Qk_alu == 3'b110 || Qk_alu == 3'b111) ? 1: (busy_alu == 0 && Qk_alu == 3'b001) ? 1: (busy_mul == 0 && Qk_alu == 3'b010) ? 1: (busy_lsu == 0 && Qk_alu == 3'b011) ? 1: (busy_sldu == 0 && Qk_alu == 3'b100) ? 1: (busy_red == 0 && Qk_alu == 3'b101) ? 1: 0);
                busy_alu = ((Rj_alu == 1 && Rk_alu == 1) ? 1: 0); 
                instr_read [2:0] = ((Rj_alu == 1 && Rk_alu == 1) ? 3'b011: 3'b010); 
                instr_status_table[instr_read_index] = instr_read;
            end
        end

        //mul
        if (instr_read != 0 && instr_read[29:27] == 3'b010) begin
            if(!busy_mul) begin
                optype_read = instr_read[29:27];
                sel_dest_mul = instr_read[39:38];
                vsew_mul = instr_read[37:36];
                lmul_mul = instr_read[35:34];
                op_mul = instr_read[26:23];
                Fj_mul = (instr_read[33:32] != 2'b11 ? instr_read[22:18]: 0);
                Fk_mul = (instr_read[31:30] != 2'b11 ? instr_read[17:13]: 0);
                Imm_mul = ((instr_read[31:30] == 2'b11 || instr_read[33:32] == 2'b11) ? instr_read[7:3]: 0);
                raw_mul_1 = (Fj_mul == Fi_alu ? 3'b001: Fj_mul == Fi_mul ? 3'b010: Fj_mul == Fi_lsu ? 3'b011: Fj_mul == Fi_sldu ? 3'b100: Fj_mul == Fi_red ? 3'b101: 3'b000);
                raw_mul_2 = (Fk_mul == Fi_alu ? 3'b001: Fk_mul == Fi_mul ? 3'b010: Fk_mul == Fi_lsu ? 3'b011: Fk_mul == Fi_sldu ? 3'b100: Fk_mul == Fi_red ? 3'b101: 3'b000);
                Fi_mul = instr_read[12:8];
                Qj_mul = (instr_read[33:32] == 2'b10 ? 3'b110: instr_read[33:32] == 2'b11 ? 3'b111: (raw_mul_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_mul_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_mul_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_mul_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_mul_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_mul = (instr_read[31:30] == 2'b10 ? 3'b110: instr_read[31:30] == 2'b11 ? 3'b111: (raw_mul_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_mul_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_mul_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_mul_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_mul_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_mul = ((Qj_mul == 3'b000 || Qj_mul == 3'b110 || Qj_mul == 3'b111) ? 1: (done_alu == 1 && Qj_mul == 3'b001) ? 1: (done_mul == 1 && Qj_mul == 3'b010) ? 1: (done_lsu == 1 && Qj_mul == 3'b011) ? 1: (done_sldu == 1 && Qj_mul == 3'b100) ? 1: (done_red == 1 && Qj_mul == 3'b101) ? 1: 0);
                Rk_mul = ((Qk_mul == 3'b000 || Qk_mul == 3'b110 || Qk_mul == 3'b111) ? 1: (done_alu == 1 && Qk_mul == 3'b001) ? 1: (done_mul == 1 && Qk_mul == 3'b010) ? 1: (done_lsu == 1 && Qk_mul == 3'b011) ? 1: (done_sldu == 1 && Qk_mul == 3'b100) ? 1: (done_red == 1 && Qk_mul == 3'b101) ? 1: 0);
                busy_mul = ((Rj_mul == 1 && Rk_mul == 1) ? 1: 0); 
                instr_read [2:0] = ((Rj_mul == 1 && Rk_mul == 1) ? 3'b011: 3'b010); 
                instr_status_table[instr_read_index] = instr_read;
            end
        end

        //lsu
        if (instr_read != 0 && instr_read[29:27] == 3'b011) begin
            if(!busy_lsu) begin
                optype_read = instr_read[29:27];
                sel_dest_lsu = instr_read[39:38];
                vsew_lsu = instr_read[37:36];
                lmul_lsu = instr_read[35:34];
                op_lsu = instr_read[26:23];
                Fj_lsu = (instr_read[33:32] != 2'b11 ? instr_read[22:18]: 0);
                Fk_lsu = (instr_read[31:30] != 2'b11 ? instr_read[17:13]: 0);
                Imm_lsu = ((instr_read[31:30] == 2'b11 || instr_read[33:32] == 2'b11) ? instr_read[7:3]: 0);
                raw_lsu_1 = (Fj_lsu == Fi_alu ? 3'b001: Fj_lsu == Fi_mul ? 3'b010: Fj_lsu == Fi_lsu ? 3'b011: Fj_lsu == Fi_sldu ? 3'b100: Fj_lsu == Fi_red ? 3'b101: 3'b000);
                raw_lsu_2 = (Fk_lsu == Fi_alu ? 3'b001: Fk_lsu == Fi_mul ? 3'b010: Fk_lsu == Fi_lsu ? 3'b011: Fk_lsu == Fi_sldu ? 3'b100: Fk_lsu == Fi_red ? 3'b101: 3'b000);
                Fi_lsu = instr_read[12:8];
                Qj_lsu = (instr_read[33:32] == 2'b10 ? 3'b110: instr_read[33:32] == 2'b11 ? 3'b111: (raw_lsu_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_lsu_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_lsu_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_lsu_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_lsu_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_lsu = (instr_read[31:30] == 2'b10 ? 3'b110: instr_read[31:30] == 2'b11 ? 3'b111: (raw_lsu_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_lsu_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_lsu_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_lsu_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_lsu_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_lsu = ((Qj_lsu == 3'b000 || Qj_lsu == 3'b110 || Qj_lsu == 3'b111) ? 1: (done_alu == 1 && Qj_mul == 3'b001) ? 1: (done_mul == 1 && Qj_lsu == 3'b010) ? 1: (done_lsu == 1 && Qj_lsu == 3'b011) ? 1: (done_sldu == 1 && Qj_lsu == 3'b100) ? 1: (done_red == 1 && Qj_lsu == 3'b101) ? 1: 0);
                Rk_lsu = ((Qk_lsu == 3'b000 || Qk_lsu == 3'b110 || Qk_lsu == 3'b111) ? 1: (done_alu == 1 && Qk_mul == 3'b001) ? 1: (done_mul == 1 && Qk_lsu == 3'b010) ? 1: (done_lsu == 1 && Qk_lsu == 3'b011) ? 1: (done_sldu == 1 && Qk_lsu == 3'b100) ? 1: (done_red == 1 && Qk_lsu == 3'b101) ? 1: 0);
                busy_lsu = ((Rj_lsu == 1 && Rk_lsu == 1) ? 1: 0); 
                instr_read [2:0] = ((Rj_lsu == 1 && Rk_lsu == 1) ? 3'b011: 3'b010); 
                instr_status_table[instr_read_index] = instr_read;
            end
        end

        //sldu
        if (instr_read != 0 && instr_read[29:27] == 3'b100) begin
            if(!busy_sldu) begin
                optype_read = instr_read[29:27];
                sel_dest_sldu = instr_read[39:38];
                vsew_sldu = instr_read[37:36];
                lmul_sldu = instr_read[35:34];
                op_sldu = instr_read[26:23];
                Fj_sldu = (instr_read[33:32] != 2'b11 ? instr_read[22:18]: 0);
                Fk_sldu = (instr_read[31:30] != 2'b11 ? instr_read[17:13]: 0);
                Imm_sldu = ((instr_read[31:30] == 2'b11 || instr_read[33:32] == 2'b11) ? instr_read[7:3]: 0);
                raw_sldu_1 = (Fj_sldu == Fi_alu ? 3'b001: Fj_sldu == Fi_mul ? 3'b010: Fj_sldu == Fi_lsu ? 3'b011: Fj_sldu == Fi_sldu ? 3'b100: Fj_sldu == Fi_red ? 3'b101: 3'b000);
                raw_sldu_2 = (Fk_sldu == Fi_alu ? 3'b001: Fk_sldu == Fi_mul ? 3'b010: Fk_sldu == Fi_lsu ? 3'b011: Fk_sldu == Fi_sldu ? 3'b100: Fk_sldu == Fi_red ? 3'b101: 3'b000);
                Fi_sldu = instr_read[12:8];
                Qj_sldu = (instr_read[33:32] == 2'b10 ? 3'b110: instr_read[33:32] == 2'b11 ? 3'b111: (raw_sldu_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_sldu_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_sldu_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_sldu_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_sldu_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_sldu = (instr_read[31:30] == 2'b10 ? 3'b110: instr_read[31:30] == 2'b11 ? 3'b111: (raw_sldu_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_sldu_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_sldu_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_sldu_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_sldu_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_sldu = ((Qj_sldu == 3'b000 || Qj_sldu == 3'b110 || Qj_sldu == 3'b111) ? 1: (done_alu == 1 && Qj_sldu == 3'b001) ? 1: (done_mul == 1 && Qj_sldu == 3'b010) ? 1: (done_lsu == 1 && Qj_sldu == 3'b011) ? 1: (done_sldu == 1 && Qj_sldu == 3'b100) ? 1: (done_red == 1 && Qj_sldu == 3'b101) ? 1: 0);
                Rk_sldu = ((Qk_sldu == 3'b000 || Qk_sldu == 3'b110 || Qk_sldu == 3'b111) ? 1: (done_alu == 1 && Qk_sldu == 3'b001) ? 1: (done_mul == 1 && Qk_sldu == 3'b010) ? 1: (done_lsu == 1 && Qk_sldu == 3'b011) ? 1: (done_sldu == 1 && Qk_sldu == 3'b100) ? 1: (done_red == 1 && Qk_sldu == 3'b101) ? 1: 0);
                busy_sldu = ((Rj_sldu == 1 && Rk_sldu == 1) ? 1: 0); 
                instr_read [2:0] = ((Rj_sldu == 1 && Rk_sldu == 1) ? 3'b011: 3'b010); 
                instr_status_table[instr_read_index] = instr_read;
            end
        end

        //red
       if (instr_read != 0 && instr_read[29:27] == 3'b101) begin
            if(!busy_red) begin
                optype_read = instr_read[29:27];
                sel_dest_red = instr_read[39:38];
                vsew_red = instr_read[37:36];
                lmul_red = instr_read[35:34];
                op_red = instr_read[26:23];
                Fj_red = (instr_read[33:32] != 2'b11 ? instr_read[22:18]: 0);
                Fk_red = (instr_read[31:30] != 2'b11 ? instr_read[17:13]: 0);
                Imm_red = ((instr_read[31:30] == 2'b11 || instr_read[33:32] == 2'b11) ? instr_read[7:3]: 0);
                raw_red_1 = (Fj_red == Fi_alu ? 3'b001: Fj_red == Fi_mul ? 3'b010: Fj_red == Fi_lsu ? 3'b011: Fj_red == Fi_sldu ? 3'b100: Fj_red == Fi_red ? 3'b101: 3'b000);
                raw_red_2 = (Fk_red == Fi_alu ? 3'b001: Fk_red == Fi_mul ? 3'b010: Fk_red == Fi_lsu ? 3'b011: Fk_red == Fi_sldu ? 3'b100: Fk_red == Fi_red ? 3'b101: 3'b000);
                Fi_red = instr_read[12:8];
                Qj_red = (instr_read[33:32] == 2'b10 ? 3'b110: instr_read[33:32] == 2'b11 ? 3'b111:  (raw_red_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_red_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_red_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_red_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_red_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_red = (instr_read[31:30] == 2'b10 ? 3'b110: instr_read[31:30] == 2'b11 ? 3'b111: (raw_red_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_red_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_red_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_red_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_red_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_red = ((Qj_red == 3'b000 || Qj_red == 3'b110 || Qj_red == 3'b111) ? 1: (done_alu == 1 && Qj_red == 3'b001) ? 1: (done_mul == 1 && Qj_red == 3'b010) ? 1: (done_lsu == 1 && Qj_red == 3'b011) ? 1: (done_sldu == 1 && Qj_red == 3'b100) ? 1: (done_red == 1 && Qj_red == 3'b101) ? 1: 0);
                Rk_red = ((Qk_red == 3'b000 || Qk_red == 3'b110 || Qk_red == 3'b111) ? 1: (done_alu == 1 && Qk_red == 3'b001) ? 1: (done_mul == 1 && Qk_red == 3'b010) ? 1: (done_lsu == 1 && Qk_red == 3'b011) ? 1: (done_sldu == 1 && Qk_red == 3'b100) ? 1: (done_red == 1 && Qk_red == 3'b101) ? 1: 0);
                busy_red = ((Rj_red == 1 && Rk_red == 1) ? 1: 0); 
                instr_read [2:0] = ((Rj_red == 1 && Rk_red == 1) ? 3'b011: 3'b010); 
                instr_status_table[instr_read_index] = instr_read;
            end
        end


    // ******************EXECUTE******************
        //alu
        alu_exec = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        alu_exec_index = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b011) ? 7: 0);
        if (done_alu == 1 && alu_exec != 0) begin
            alu_exec[2:0] = 3'b100;
            instr_status_table[alu_exec_index] = alu_exec;
            op_alu = 0;
            busy_alu = 0;
        end
        
        //mul
        mul_exec = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        mul_exec_index = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b011) ? 7: 0);
        if (done_mul == 1 && mul_exec != 0) begin
            mul_exec[2:0] = 3'b100;
            instr_status_table[mul_exec_index] = mul_exec;
            busy_mul = 0;
        end

        //lsu
        lsu_exec = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        lsu_exec_index = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b011) ? 7: 0);
        if (done_lsu == 1 && lsu_exec != 0) begin
            lsu_exec[2:0] = 3'b100;
            instr_status_table[lsu_exec_index] = lsu_exec;
            busy_lsu = 0;
        end

        //sldu
        sldu_exec = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        sldu_exec_index = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b011) ? 7: 0);
        if (done_sldu == 1 && sldu_exec != 0) begin
            sldu_exec[2:0] = 3'b100;
            instr_status_table[sldu_exec_index] = sldu_exec;
            busy_sldu = 0;
        end

        //red
        red_exec = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        red_exec_index = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b011) ? 7: 0);
        if (done_red == 1 && red_exec != 0) begin
            red_exec[2:0] = 3'b100;
            instr_status_table[red_exec_index] = red_exec;
            busy_red = 0;
        end

// Write Back
        wb_instr = ((instr_1[2:0] == 3'b100) ? instr_1: (instr_2[2:0] == 3'b100) ? instr_2: (instr_3[2:0] == 3'b100) ? instr_3: (instr_4[2:0] == 3'b100) ? instr_4: (instr_5[2:0] == 3'b100) ? instr_5: (instr_6[2:0] == 3'b100) ? instr_6: (instr_7[2:0] == 3'b100) ? instr_7: (instr_8[2:0] == 3'b100) ? instr_8: 0);
        wb_instr_index = ((instr_1[2:0] == 3'b100) ? 0: (instr_2[2:0] == 3'b100) ? 1: (instr_3[2:0] == 3'b100) ? 2: (instr_4[2:0] == 3'b100) ? 3: (instr_5[2:0] == 3'b100) ? 4: (instr_6[2:0] == 3'b100) ? 5: (instr_7[2:0] == 3'b100) ? 6: (instr_8[2:0] == 3'b100) ? 7: 0);
        dest_wb = (wb_instr != 0) ? wb_instr[12:8] : dest_wb;   

        case (wb_instr[29:27])
            default: begin
            end
            3'b001: begin
                reg_wr_data <= result_valu_1;
                reg_wr_data_2 <= result_valu_2;
                reg_wr_data_3 <= result_valu_3;
                reg_wr_data_4 <= result_valu_4;
            end
            3'b010: begin
                reg_wr_data <= result_vmul_1;
                reg_wr_data_2 <= result_vmul_2;
                reg_wr_data_3 <= result_vmul_3;
                reg_wr_data_4 <= result_vmul_4; 
            end
            3'b011: begin
                reg_wr_data <= result_vlsu;
                reg_wr_data_2 <= result_vlsu;
                reg_wr_data_3 <= result_vlsu;
                reg_wr_data_4 <= result_vlsu;
            end
            3'b100: begin
                reg_wr_data <= result_vsldu[127:0];
                reg_wr_data_2 <= result_vsldu[255:128];
                reg_wr_data_3 <= result_vsldu[383:256];
                reg_wr_data_4 <= result_vsldu[511:384];  
            end
            3'b101: begin
                el_wr_en <= 1;
                reg_wr_data <= result_vred;
                reg_wr_data_2 <= {128{1'b0}};
                reg_wr_data_3 <= {128{1'b0}};
                reg_wr_data_4 <= {128{1'b0}};    
            end
        endcase     
    end

/*
    initial begin
        for (int i = 0; i < NO_OF_SLOTS; i++) begin
            fifo_count = 3'b0000;
            instr_status_table[i] = {IST_ENTRY_BITS{1'b0}};
        end 
    //    Fi_alu = 0; Fi_mul = 0; Fi_lsu = 0; Fi_sldu = 0; Fi_red = 0;
    end

    // FIFO Count Condition
    always @(clk) begin
        op = (v_alu_op != 0) ? 3'b001: (is_mul != 0) ? 3'b010: v_lsu_op != 0 ? 3'b011: (v_sldu_op != 0) ? 3'b100: (v_red_op != 0) ? 3'b101:3'b000;
        op_instr = op == 3'b001 ? v_alu_op: op == 3'b010 ? is_mul: op == 3'b011 ? v_lsu_op: op == 3'b100 ? v_sldu_op: 3'b101 ? v_red_op: 0;
        // Write to Instruction Status Table
        if (!nrst) begin
            signal_c = 0;
            for (int i = 0; i < NO_OF_SLOTS; i++) begin
                fifo_count = 3'b000;
                instr_status_table[i] = {IST_ENTRY_BITS{1'b0}};
            end
        end else begin
            //signal_c = clk;
            //if(pos_edge)begin
            if (!fifo_full) begin
            instr_status_table[fifo_count] = {sel_dest, vsew, lmul, sel_op_A, sel_op_B, op, op_instr, src_A, src_B, dest, imm, 3'b001};
            fifo_count = fifo_count + 1;
            end
            //end
        end

    // ******************EXECUTE******************
        //alu
        alu_exec = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        alu_exec_index = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b011) ? 7: 0);
        if (done_alu == 1 && alu_exec != 0) begin
            alu_exec[2:0] = 3'b100;
            instr_status_table[alu_exec_index] = alu_exec;
            sel_dest_alu = 0;
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
            sel_dest_mul = 0;
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
            sel_dest_lsu = 0;
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
            sel_dest_sldu = 0;
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
            sel_dest_red = 0;
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

    //WB
        case(wb_instr_index)
            default: ;
            3'b000: begin
                instr_status_table[0] = instr_status_table[1];
                instr_status_table[1] = instr_status_table[2];
                instr_status_table[2] = instr_status_table[3];
                instr_status_table[3] = instr_status_table[4];
                instr_status_table[4] = instr_status_table[5];
                instr_status_table[5] = instr_status_table[6];
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b001: begin
                instr_status_table[1] = instr_status_table[2];
                instr_status_table[2] = instr_status_table[3];
                instr_status_table[3] = instr_status_table[4];
                instr_status_table[4] = instr_status_table[5];
                instr_status_table[5] = instr_status_table[6];
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b010: begin
                instr_status_table[2] = instr_status_table[3];
                instr_status_table[3] = instr_status_table[4];
                instr_status_table[4] = instr_status_table[5];
                instr_status_table[5] = instr_status_table[6];
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b011: begin
                instr_status_table[3] = instr_status_table[4];
                instr_status_table[4] = instr_status_table[5];
                instr_status_table[5] = instr_status_table[6];
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b100: begin
                instr_status_table[4] = instr_status_table[5];
                instr_status_table[5] = instr_status_table[6];
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b101: begin
                instr_status_table[5] = instr_status_table[6];
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b110: begin
                instr_status_table[6] = instr_status_table[7];
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;
            end
            3'b111: begin
                instr_status_table[7] = {IST_ENTRY_BITS{1'b0}};
                fifo_count = fifo_count - 1;        
            end     
        endcase
    end
    always_comb begin
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
        instr_read = ((instr_1[2:0] == 3'b010) ? instr_1: (instr_2[2:0] == 3'b010) ? instr_2: (instr_3[2:0] == 3'b010) ? instr_3: (instr_4[2:0] == 3'b010) ? instr_4: (instr_5[2:0] == 3'b010) ? instr_5: (instr_6[2:0] == 3'b010) ? instr_6: (instr_7[2:0] == 3'b010) ? instr_7: (instr_8[2:0] == 3'b010) ? instr_8: 0);
        optype_read = instr_read[29:27];
        instr_read_index = ((instr_1[2:0] == 3'b010) ? 0: (instr_2[2:0] == 3'b010) ? 1: (instr_3[2:0] == 3'b010) ? 2: (instr_4[2:0] == 3'b010) ? 3: (instr_5[2:0] == 3'b010) ? 4: (instr_6[2:0] == 3'b010) ? 5: (instr_7[2:0] == 3'b010) ? 6: (instr_8[2:0] == 3'b010) ? 7: 0);

//        alu_read = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b010) ? instr_1: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b010) ? instr_2: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b010) ? instr_3: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b010) ? instr_4: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b010) ? instr_5: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b010) ? instr_6: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b010) ? instr_7: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b010) ? instr_8: 0);
//        alu_read_index = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b010) ? 0: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b010) ? 1: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b010) ? 2: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b010) ? 3: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b010) ? 4: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b010) ? 5: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b010) ? 6: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b010) ? 7: 0);
        if (instr_read != 0 && optype_read == 3'b001) begin
            if(!busy_alu) begin
                sel_dest_alu = instr_read[39:38];
                vsew_alu = instr_read[37:36];
                lmul_alu = instr_read[35:34];
                op_alu = instr_read[26:23];
                Fi_alu = instr_read[12:8];
                Fj_alu = (instr_read[33:32] != 2'b11 ? instr_read[22:18]: 0);
                Fk_alu = (instr_read[31:30] != 2'b11 ? instr_read[17:13]: 0);
                Imm_alu = ((instr_read[31:30] == 2'b11 || instr_read[33:32] == 2'b11) ? instr_read[7:3]: 0);
                raw_alu_1 = (Fj_alu == Fi_alu ? 3'b001: Fj_alu == Fi_mul ? 3'b010: Fj_alu == Fi_lsu ? 3'b011: Fj_alu == Fi_sldu ? 3'b100: Fj_alu == Fi_red ? 3'b101: 3'b000);
                raw_alu_2 = (Fk_alu == Fi_alu ? 3'b001: Fk_alu == Fi_mul ? 3'b010: Fk_alu == Fi_lsu ? 3'b011: Fk_alu == Fi_sldu ? 3'b100: Fk_alu == Fi_red ? 3'b101: 3'b000);
                Qj_alu = (instr_read[33:32] == 2'b10 ? 3'b110: instr_read[33:32] == 2'b11 ? 3'b111: (raw_alu_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_alu_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_alu_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_alu_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_alu_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_alu = (instr_read[31:30] == 2'b10 ? 3'b110: instr_read[31:30] == 2'b11 ? 3'b111: (raw_alu_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_alu_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_alu_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_alu_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_alu_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_alu = ((Qj_alu == 3'b000 || Qj_alu == 3'b110 || Qj_alu == 3'b111) ? 1: (done_alu == 1 && Qj_alu == 3'b001) ? 1: (done_mul == 1 && Qj_alu == 3'b010) ? 1: (done_lsu == 1 && Qj_alu == 3'b011) ? 1: (done_sldu == 1 && Qj_alu == 3'b100) ? 1: (done_red == 1 && Qj_alu == 3'b101) ? 1: 0);
                Rk_alu = ((Qk_alu == 3'b000 || Qk_alu == 3'b110 || Qk_alu == 3'b111) ? 1: (done_alu == 1 && Qk_alu == 3'b001) ? 1: (done_mul == 1 && Qk_alu == 3'b010) ? 1: (done_lsu == 1 && Qk_alu == 3'b011) ? 1: (done_sldu == 1 && Qk_alu == 3'b100) ? 1: (done_red == 1 && Qk_alu == 3'b101) ? 1: 0);
                busy_alu = ((Rj_alu == 1 && Rk_alu == 1) ? 1: 0); 
                instr_read [2:0] = ((Rj_alu == 1 && Rk_alu == 1) ? 3'b011: 3'b010); 
                instr_status_table[instr_read_index] = instr_read;
            end
        end

        //mul
//        mul_read = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b010) ? instr_1: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b010) ? instr_2: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b010) ? instr_3: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b010) ? instr_4: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b010) ? instr_5: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b010) ? instr_6: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b010) ? instr_7: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b010) ? instr_8: 0);
//        mul_read_index = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b010) ? 0: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b010) ? 1: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b010) ? 2: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b010) ? 3: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b010) ? 4: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b010) ? 5: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b010) ? 6: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b010) ? 7: 0);
        if (instr_read != 0 && optype_read == 3'b010) begin
            if(!busy_mul) begin
                sel_dest_mul = instr_read[39:38];
                vsew_mul = instr_read[37:36];
                lmul_mul = instr_read[35:34];
                op_mul = instr_read[26:23];
                Fi_mul = instr_read[12:8];
                Fj_mul = (instr_read[33:32] != 2'b11 ? instr_read[22:18]: 0);
                Fk_mul = (instr_read[31:30] != 2'b11 ? instr_read[17:13]: 0);
                Imm_mul = ((instr_read[31:30] == 2'b11 || instr_read[33:32] == 2'b11) ? instr_read[7:3]: 0);
                raw_mul_1 = (Fj_mul == Fi_alu ? 3'b001: Fj_mul == Fi_mul ? 3'b010: Fj_mul == Fi_lsu ? 3'b011: Fj_mul == Fi_sldu ? 3'b100: Fj_mul == Fi_red ? 3'b101: 3'b000);
                raw_mul_2 = (Fk_mul == Fi_alu ? 3'b001: Fk_mul == Fi_mul ? 3'b010: Fk_mul == Fi_lsu ? 3'b011: Fk_mul == Fi_sldu ? 3'b100: Fk_mul == Fi_red ? 3'b101: 3'b000);
                Qj_mul = (instr_read[33:32] == 2'b10 ? 3'b110: instr_read[33:32] == 2'b11 ? 3'b111: (raw_mul_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_mul_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_mul_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_mul_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_mul_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_mul = (instr_read[31:30] == 2'b10 ? 3'b110: instr_read[31:30] == 2'b11 ? 3'b111: (raw_mul_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_mul_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_mul_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_mul_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_mul_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_mul = ((Qj_mul == 3'b000 || Qj_mul == 3'b110 || Qj_mul == 3'b111) ? 1: (done_alu == 1 && Qj_mul == 3'b001) ? 1: (done_mul == 1 && Qj_mul == 3'b010) ? 1: (done_lsu == 1 && Qj_mul == 3'b011) ? 1: (done_sldu == 1 && Qj_mul == 3'b100) ? 1: (done_red == 1 && Qj_mul == 3'b101) ? 1: 0);
                Rk_mul = ((Qk_mul == 3'b000 || Qk_mul == 3'b110 || Qk_mul == 3'b111) ? 1: (done_alu == 1 && Qk_mul == 3'b001) ? 1: (done_mul == 1 && Qk_mul == 3'b010) ? 1: (done_lsu == 1 && Qk_mul == 3'b011) ? 1: (done_sldu == 1 && Qk_mul == 3'b100) ? 1: (done_red == 1 && Qk_mul == 3'b101) ? 1: 0);
                busy_mul = ((Rj_mul == 1 && Rk_mul == 1) ? 1: 0); 
                instr_read [2:0] = ((Rj_mul == 1 && Rk_mul == 1) ? 3'b011: 3'b010); 
                instr_status_table[instr_read_index] = instr_read;
            end
        end

        //lsu
//        lsu_read = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b010) ? instr_1: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b010) ? instr_2: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b010) ? instr_3: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b010) ? instr_4: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b010) ? instr_5: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b010) ? instr_6: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b010) ? instr_7: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b010) ? instr_8: 0);
//        lsu_read_index = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b010) ? 0: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b010) ? 1: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b010) ? 2: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b010) ? 3: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b010) ? 4: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b010) ? 5: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b010) ? 6: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b010) ? 7: 0);
        if (instr_read != 0 && optype_read == 3'b011) begin
            if(!busy_lsu) begin
                sel_dest_lsu = instr_read[39:38];
                vsew_lsu = instr_read[37:36];
                lmul_lsu = instr_read[35:34];
                op_lsu = instr_read[26:23];
                Fi_lsu = instr_read[12:8];
                Fj_lsu = (instr_read[33:32] != 2'b11 ? instr_read[22:18]: 0);
                Fk_lsu = (instr_read[31:30] != 2'b11 ? instr_read[17:13]: 0);
                Imm_lsu = ((instr_read[31:30] == 2'b11 || instr_read[33:32] == 2'b11) ? instr_read[7:3]: 0);
                raw_lsu_1 = (Fj_lsu == Fi_alu ? 3'b001: Fj_lsu == Fi_mul ? 3'b010: Fj_lsu == Fi_lsu ? 3'b011: Fj_lsu == Fi_sldu ? 3'b100: Fj_lsu == Fi_red ? 3'b101: 3'b000);
                raw_lsu_2 = (Fk_lsu == Fi_alu ? 3'b001: Fk_lsu == Fi_mul ? 3'b010: Fk_lsu == Fi_lsu ? 3'b011: Fk_lsu == Fi_sldu ? 3'b100: Fk_lsu == Fi_red ? 3'b101: 3'b000);
                Qj_lsu = (instr_read[33:32] == 2'b10 ? 3'b110: instr_read[33:32] == 2'b11 ? 3'b111: (raw_lsu_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_lsu_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_lsu_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_lsu_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_lsu_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_lsu = (instr_read[31:30] == 2'b10 ? 3'b110: instr_read[31:30] == 2'b11 ? 3'b111: (raw_lsu_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_lsu_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_lsu_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_lsu_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_lsu_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_lsu = ((Qj_lsu == 3'b000 || Qj_lsu == 3'b110 || Qj_lsu == 3'b111) ? 1: (done_alu == 1 && Qj_mul == 3'b001) ? 1: (done_mul == 1 && Qj_lsu == 3'b010) ? 1: (done_lsu == 1 && Qj_lsu == 3'b011) ? 1: (done_sldu == 1 && Qj_lsu == 3'b100) ? 1: (done_red == 1 && Qj_lsu == 3'b101) ? 1: 0);
                Rk_lsu = ((Qk_lsu == 3'b000 || Qk_lsu == 3'b110 || Qk_lsu == 3'b111) ? 1: (done_alu == 1 && Qk_mul == 3'b001) ? 1: (done_mul == 1 && Qk_lsu == 3'b010) ? 1: (done_lsu == 1 && Qk_lsu == 3'b011) ? 1: (done_sldu == 1 && Qk_lsu == 3'b100) ? 1: (done_red == 1 && Qk_lsu == 3'b101) ? 1: 0);
                busy_lsu = ((Rj_lsu == 1 && Rk_lsu == 1) ? 1: 0); 
                instr_read [2:0] = ((Rj_lsu == 1 && Rk_lsu == 1) ? 3'b011: 3'b010); 
                instr_status_table[instr_read_index] = instr_read;
            end
        end

        //sldu
//        sldu_read = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b010) ? instr_1: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b010) ? instr_2: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b010) ? instr_3: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b010) ? instr_4: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b010) ? instr_5: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b010) ? instr_6: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b010) ? instr_7: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b010) ? instr_8: 0);
//        sldu_read_index = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b010) ? 0: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b010) ? 1: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b010) ? 2: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b010) ? 3: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b010) ? 4: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b010) ? 5: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b010) ? 6: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b010) ? 7: 0);
        if (instr_read != 0 && optype_read == 3'b100) begin
            if(!busy_sldu) begin
                sel_dest_sldu = instr_read[39:38];
                vsew_sldu = instr_read[37:36];
                lmul_sldu = instr_read[35:34];
                op_sldu = instr_read[26:23];
                Fi_sldu = instr_read[12:8];
                Fj_sldu = (instr_read[33:32] != 2'b11 ? instr_read[22:18]: 0);
                Fk_sldu = (instr_read[31:30] != 2'b11 ? instr_read[17:13]: 0);
                Imm_sldu = ((instr_read[31:30] == 2'b11 || instr_read[33:32] == 2'b11) ? instr_read[7:3]: 0);
                raw_sldu_1 = (Fj_sldu == Fi_alu ? 3'b001: Fj_sldu == Fi_mul ? 3'b010: Fj_sldu == Fi_lsu ? 3'b011: Fj_sldu == Fi_sldu ? 3'b100: Fj_sldu == Fi_red ? 3'b101: 3'b000);
                raw_sldu_2 = (Fk_sldu == Fi_alu ? 3'b001: Fk_sldu == Fi_mul ? 3'b010: Fk_sldu == Fi_lsu ? 3'b011: Fk_sldu == Fi_sldu ? 3'b100: Fk_sldu == Fi_red ? 3'b101: 3'b000);
                Qj_sldu = (instr_read[33:32] == 2'b10 ? 3'b110: instr_read[33:32] == 2'b11 ? 3'b111: (raw_sldu_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_sldu_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_sldu_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_sldu_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_sldu_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_sldu = (instr_read[31:30] == 2'b10 ? 3'b110: instr_read[31:30] == 2'b11 ? 3'b111: (raw_sldu_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_sldu_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_sldu_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_sldu_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_sldu_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_sldu = ((Qj_sldu == 3'b000 || Qj_sldu == 3'b110 || Qj_sldu == 3'b111) ? 1: (done_alu == 1 && Qj_sldu == 3'b001) ? 1: (done_mul == 1 && Qj_sldu == 3'b010) ? 1: (done_lsu == 1 && Qj_sldu == 3'b011) ? 1: (done_sldu == 1 && Qj_sldu == 3'b100) ? 1: (done_red == 1 && Qj_sldu == 3'b101) ? 1: 0);
                Rk_sldu = ((Qk_sldu == 3'b000 || Qk_sldu == 3'b110 || Qk_sldu == 3'b111) ? 1: (done_alu == 1 && Qk_sldu == 3'b001) ? 1: (done_mul == 1 && Qk_sldu == 3'b010) ? 1: (done_lsu == 1 && Qk_sldu == 3'b011) ? 1: (done_sldu == 1 && Qk_sldu == 3'b100) ? 1: (done_red == 1 && Qk_sldu == 3'b101) ? 1: 0);
                busy_sldu = ((Rj_sldu == 1 && Rk_sldu == 1) ? 1: 0); 
                instr_read [2:0] = ((Rj_sldu == 1 && Rk_sldu == 1) ? 3'b011: 3'b010); 
                instr_status_table[instr_read_index] = instr_read;
            end
        end

        //red
//        red_read = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b010) ? instr_1: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b010) ? instr_2: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b010) ? instr_3: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b010) ? instr_4: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b010) ? instr_5: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b010) ? instr_6: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b010) ? instr_7: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b010) ? instr_8: 0);
//        red_read_index = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b010) ? 0: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b010) ? 1: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b010) ? 2: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b010) ? 3: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b010) ? 4: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b010) ? 5: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b010) ? 6: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b010) ? 7: 0);
        if (instr_read != 0 && optype_read == 3'b101) begin
            if(!busy_red) begin
                sel_dest_red = instr_read[39:38];
                vsew_red = instr_read[37:36];
                lmul_red = instr_read[35:34];
                op_red = instr_read[26:23];
                Fi_red = instr_read[12:8];
                Fj_red = (instr_read[33:32] != 2'b11 ? instr_read[22:18]: 0);
                Fk_red = (instr_read[31:30] != 2'b11 ? instr_read[17:13]: 0);
                Imm_red = ((instr_read[31:30] == 2'b11 || instr_read[33:32] == 2'b11) ? instr_read[7:3]: 0);
                raw_red_1 = (Fj_red == Fi_alu ? 3'b001: Fj_red == Fi_mul ? 3'b010: Fj_red == Fi_lsu ? 3'b011: Fj_red == Fi_sldu ? 3'b100: Fj_red == Fi_red ? 3'b101: 3'b000);
                raw_red_2 = (Fk_red == Fi_alu ? 3'b001: Fk_red == Fi_mul ? 3'b010: Fk_red == Fi_lsu ? 3'b011: Fk_red == Fi_sldu ? 3'b100: Fk_red == Fi_red ? 3'b101: 3'b000);
                Qj_red = (instr_read[33:32] == 2'b10 ? 3'b110: instr_read[33:32] == 2'b11 ? 3'b111: (raw_red_1 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_red_1 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_red_1 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_red_1 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_red_1 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Qk_red = (instr_read[31:30] == 2'b10 ? 3'b110: instr_read[31:30] == 2'b11 ? 3'b111: (raw_red_2 == 3'b001 && busy_alu == 1) ? 3'b001: (raw_red_2 == 3'b010 && busy_mul == 1)  ? 3'b010: (raw_red_2 == 3'b011 && busy_lsu == 1)  ? 3'b011: (raw_red_2 == 3'b100 && busy_sldu == 1)  ? 3'b100: (raw_red_2 == 3'b101 && busy_red == 1)  ? 3'b101: 3'b000);
                Rj_red = ((Qj_red == 3'b000 || Qj_red == 3'b110 || Qj_red == 3'b111) ? 1: (done_alu == 1 && Qj_red == 3'b001) ? 1: (done_mul == 1 && Qj_red == 3'b010) ? 1: (done_lsu == 1 && Qj_red == 3'b011) ? 1: (done_sldu == 1 && Qj_red == 3'b100) ? 1: (done_red == 1 && Qj_red == 3'b101) ? 1: 0);
                Rk_red = ((Qk_red == 3'b000 || Qk_red == 3'b110 || Qk_red == 3'b111) ? 1: (done_alu == 1 && Qk_red == 3'b001) ? 1: (done_mul == 1 && Qk_red == 3'b010) ? 1: (done_lsu == 1 && Qk_red == 3'b011) ? 1: (done_sldu == 1 && Qk_red == 3'b100) ? 1: (done_red == 1 && Qk_red == 3'b101) ? 1: 0);
                busy_red = ((Rj_red == 1 && Rk_red == 1) ? 1: 0); 
                instr_read [2:0] = ((Rj_red == 1 && Rk_red == 1) ? 3'b011: 3'b010); 
                instr_status_table[instr_read_index] = instr_read;
            end
        end
*/
/*
    // ******************EXECUTE******************
        //alu
        alu_exec = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        alu_exec_index = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b011) ? 7: 0);
        if (done_alu == 1 && alu_exec != 0) begin
            alu_exec[2:0] = 3'b100;
            instr_status_table[alu_exec_index] = alu_exec;
            sel_dest_alu = 0;
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
            sel_dest_mul = 0;
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
            sel_dest_lsu = 0;
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
            sel_dest_sldu = 0;
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
            sel_dest_red = 0;
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
*/
        // ******************EXECUTE******************
/*        wb_instr = ((instr_1[2:0] == 3'b100) ? instr_1: (instr_2[2:0] == 3'b100) ? instr_2: (instr_3[2:0] == 3'b100) ? instr_3: (instr_4[2:0] == 3'b100) ? instr_4: (instr_5[2:0] == 3'b100) ? instr_5: (instr_6[2:0] == 3'b100) ? instr_6: (instr_7[2:0] == 3'b100) ? instr_7: (instr_8[2:0] == 3'b100) ? instr_8: 0);
        wb_instr_index = ((instr_1[2:0] == 3'b100) ? 0: (instr_2[2:0] == 3'b100) ? 1: (instr_3[2:0] == 3'b100) ? 2: (instr_4[2:0] == 3'b100) ? 3: (instr_5[2:0] == 3'b100) ? 4: (instr_6[2:0] == 3'b100) ? 5: (instr_7[2:0] == 3'b100) ? 6: (instr_8[2:0] == 3'b100) ? 7: 0);
        if (wb_instr !=0 ) begin
        case (wb_instr[29:27])
            default: begin
                v_reg_wr_en = 0;
                x_reg_wr_en = 0;    
            end
            3'b001: begin
                v_reg_wr_en = (wb_instr[39:38]==1) ? 1: 0;
                x_reg_wr_en = (wb_instr[39:38]==2) ? 1: 0;
                reg_wr_data <= result_valu_1;
                reg_wr_data_2 <= result_valu_2;
                reg_wr_data_3 <= result_valu_3;
                reg_wr_data_4 <= result_valu_4;
                instr_status_table[wb_instr_index] <= {IST_ENTRY_BITS{1'b0}};                
            end
            3'b010: begin
                v_reg_wr_en = (wb_instr[39:38]==1) ? 1: 0;
                x_reg_wr_en = (wb_instr[39:38]==2) ? 1: 0;
                reg_wr_data <= result_vmul_1;
                reg_wr_data_2 <= result_vmul_2;
                reg_wr_data_3 <= result_vmul_3;
                reg_wr_data_4 <= result_vmul_4; 
                instr_status_table[wb_instr_index] <= {IST_ENTRY_BITS{1'b0}};        
            end
            3'b011: begin
                v_reg_wr_en = (wb_instr[39:38]==1) ? 1: 0;
                x_reg_wr_en = (wb_instr[39:38]==2) ? 1: 0;
                reg_wr_data <= result_vlsu;
                reg_wr_data_2 <= result_vlsu;
                reg_wr_data_3 <= result_vlsu;
                reg_wr_data_4 <= result_vlsu;
                instr_status_table[wb_instr_index] <= {IST_ENTRY_BITS{1'b0}};       
            end
            3'b100: begin
                v_reg_wr_en = (wb_instr[39:38]==1) ? 1: 0;
                x_reg_wr_en = (wb_instr[39:38]==2) ? 1: 0;
                reg_wr_data <= result_vsldu[127:0];
                reg_wr_data_2 <= result_vsldu[255:128];
                reg_wr_data_3 <= result_vsldu[383:256];
                reg_wr_data_4 <= result_vsldu[511:384];  
                instr_status_table[wb_instr_index] <= {IST_ENTRY_BITS{1'b0}};   
            end
            3'b101: begin
                v_reg_wr_en = (wb_instr[39:38]==1) ? 1: 0;
                x_reg_wr_en = (wb_instr[39:38]==2) ? 1: 0;
                el_wr_en <= 1;
                reg_wr_data <= result_vred;
                reg_wr_data_2 <= {128{1'b0}};
                reg_wr_data_3 <= {128{1'b0}};
                reg_wr_data_4 <= {128{1'b0}};    
                instr_status_table[wb_instr_index] <= {IST_ENTRY_BITS{1'b0}};    
            end
        endcase
        end

    end
*/
endmodule

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
    input logic is_mul, is_vstype, is_vector,
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
    output logic [127:0]  reg_wr_data, reg_wr_data_2, reg_wr_data_3, reg_wr_data_4,
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
    logic [2:0] instr_status;
    logic [2:0] op;
    logic [3:0] op_instr;
    logic busy_alu = 0;
    logic busy_mul = 0;
    logic busy_lsu = 0;
    logic busy_sldu = 0;
    logic busy_red = 0;
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
    logic wr_alu = 0;
    logic wr_mul = 0; 
    logic wr_lsu = 0; 
    logic wr_sldu = 0; 
    logic wr_red = 0;
/*
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
*/
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
    end

    // FIFO Count Condition
    always @(posedge clk && base_instr) begin
        #1
        op = (v_alu_op != 0) ? 3'b001: (is_mul != 0) ? 3'b010: v_lsu_op != 0 ? 3'b011: (v_sldu_op != 0) ? 3'b100: (v_red_op != 0) ? 3'b101:3'b000;
        op_instr = op == 3'b001 ? v_alu_op: op == 3'b010 ? is_mul: op == 3'b011 ? v_lsu_op: op == 3'b100 ? v_sldu_op: 3'b101 ? v_red_op: 0;
        
        // Write to Instruction Status Table
        if (!nrst) begin
            for (int i = 0; i < NO_OF_SLOTS; i++) begin
                fifo_count = 3'b000;
                instr_status_table[i] = {IST_ENTRY_BITS{1'b0}};
            end
        end else begin
            if (fifo_full == 0 && base_instr != 0 && is_vector == 1) begin
            instr_status_table[fifo_count] = {sel_dest, vsew, lmul, sel_op_A, sel_op_B, op, op_instr, src_A, src_B, dest, imm, 3'b001};
            fifo_count = fifo_count + 1;
            end
        end
    end

    always @(*) begin
    // ******************READ OPERANDS******************
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
        if (instr_read != 0 && instr_read[29:27] == 3'b001) begin
                sel_dest_read = instr_read[39:38];
                vsew_read = instr_read[37:36];
                lmul_read = instr_read[35:34];
                op_read = instr_read[26:23];
                Fi_read = instr_read[12:8];   
                Fj_read =  instr_read[22:18];
                Fk_read = instr_read[17:13];
                Imm_read = instr_read[7:3];
                Qj_read = ((instr_read[33:32] == 2'b10) ? 3'b110: (instr_read[33:32] == 2'b11) ? 3'b111: (Fj_read == Fi_alu && wr_alu == 1) ? 3'b001: (Fj_read == Fi_mul && wr_mul == 1) ? 3'b010: (Fj_read == Fi_lsu && wr_lsu == 1) ? 3'b011: (Fj_read == Fi_sldu && wr_sldu == 1) ? 3'b100: (Fj_read == Fi_red && wr_red == 1) ? 3'b101: 3'b000);
                Qk_read = ((instr_read[31:30] == 2'b10) ? 3'b110: (instr_read[31:30] == 2'b11) ? 3'b111: (Fk_read == Fi_alu && wr_alu == 1) ? 3'b001: (Fk_read == Fi_mul && wr_mul == 1) ? 3'b010: (Fk_read == Fi_lsu && wr_lsu == 1) ? 3'b011: (Fk_read == Fi_sldu && wr_sldu == 1) ? 3'b100: (Fk_read == Fi_red && wr_red == 1) ? 3'b101: 3'b000);                
                Rj_read = ((Qj_read == 3'b000 || Qj_read == 3'b110 || Qj_read == 3'b111) ? 1: (busy_alu == 0 && Qj_read == 3'b001) ? 1: (busy_mul == 0 && Qj_read == 3'b010) ? 1: (busy_lsu == 0 && Qj_read == 3'b011) ? 1: (busy_sldu == 0 && Qj_read == 3'b100) ? 1: (busy_red == 0 && Qj_read == 3'b101) ? 1: 0);
                Rk_read = ((Qk_read == 3'b000 || Qk_read == 3'b110 || Qk_read == 3'b111) ? 1: (busy_alu == 0 && Qk_read == 3'b001) ? 1: (busy_mul == 0 && Qk_read == 3'b010) ? 1: (busy_lsu == 0 && Qk_read == 3'b011) ? 1: (busy_sldu == 0 && Qk_read == 3'b100) ? 1: (busy_red == 0 && Qk_read == 3'b101) ? 1: 0);
                busy_read = ((Rj_read == 1 && Rk_read == 1) ? 1: 0); 
             

        end

        if (instr_read !=0 && busy_read == 1 && instr_read[29:27] == 3'b001 && busy_alu == 0) begin
            optype_read = instr_read[29:27];
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
            instr_read [2:0] =  3'b011;
            instr_status_table[instr_read_index] = instr_read;
        end
*/
 
        if (instr_read != 0 && instr_read[29:27] == 3'b001) begin
            if(!busy_alu) begin
                optype_read = instr_read[29:27];
                sel_dest_alu = instr_read[39:38];
                vsew_alu = instr_read[37:36];
                lmul_alu = instr_read[35:34];
                op_alu = instr_read[26:23];
                Fj_alu =  instr_read[22:18];
                Fk_alu = instr_read[17:13];
                Imm_alu = instr_read[7:3];
                Qj_alu = ((instr_read[33:32] == 2'b10) ? 3'b110: (instr_read[33:32] == 2'b11) ? 3'b111: (Fj_alu == Fi_alu && wr_alu == 1) ? 3'b001: (Fj_alu == Fi_mul && wr_mul == 1) ? 3'b010: (Fj_alu == Fi_lsu && wr_lsu == 1) ? 3'b011: (Fj_alu == Fi_sldu && wr_sldu == 1) ? 3'b100: (Fj_alu == Fi_red && wr_red == 1) ? 3'b101: 3'b000);
                Qk_alu = ((instr_read[31:30] == 2'b10) ? 3'b110: (instr_read[31:30] == 2'b11) ? 3'b111: (Fk_alu == Fi_alu && wr_alu == 1) ? 3'b001: (Fk_alu == Fi_mul && wr_mul == 1) ? 3'b010: (Fk_alu == Fi_lsu && wr_lsu == 1) ? 3'b011: (Fk_alu == Fi_sldu && wr_sldu == 1) ? 3'b100: (Fk_alu == Fi_red && wr_red == 1) ? 3'b101: 3'b000);                
                Rj_alu = ((Qj_alu == 3'b000 || Qj_alu == 3'b110 || Qj_alu == 3'b111) ? 1: (busy_alu == 0 && Qj_alu == 3'b001) ? 1: (busy_mul == 0 && Qj_alu == 3'b010) ? 1: (busy_lsu == 0 && Qj_alu == 3'b011) ? 1: (busy_sldu == 0 && Qj_alu == 3'b100) ? 1: (busy_red == 0 && Qj_alu == 3'b101) ? 1: 0);
                Rk_alu = ((Qk_alu == 3'b000 || Qk_alu == 3'b110 || Qk_alu == 3'b111) ? 1: (busy_alu == 0 && Qk_alu == 3'b001) ? 1: (busy_mul == 0 && Qk_alu == 3'b010) ? 1: (busy_lsu == 0 && Qk_alu == 3'b011) ? 1: (busy_sldu == 0 && Qk_alu == 3'b100) ? 1: (busy_red == 0 && Qk_alu == 3'b101) ? 1: 0);
                busy_alu = ((Rj_alu == 1 && Rk_alu == 1) ? 1: 0); 
                Fi_alu = busy_alu == 1 ? instr_read[12:8]: Fi_alu;                
                instr_read [2:0] = ((Rj_alu == 1 && Rk_alu == 1) ? 3'b011: 3'b010); 
                instr_status_table[instr_read_index] = instr_read;
            end
        end

/* 
        if (instr_read !=0 && busy_read == 1 && instr_read[29:27] == 3'b010 && busy_mul == 0) begin
            optype_read = instr_read[29:27];
            sel_dest_mul = sel_dest_read;
            vsew_mul = vsew_read;
            lmul_mul = lmul_read;
            op_mul = op_read;
            Fj_mul = Fj_read;
            Fk_mul = Fk_read;
            Imm_mul = Imm_read;
            Fi_mul = instr_read[12:8];
            Qj_mul = Qj_read;
            Qk_mul = Qk_read;
            busy_mul = 1;
            instr_read [2:0] =  3'b011;
            instr_status_table[instr_read_index] = instr_read;
        end
  */

        //mul
        if (instr_read != 0 && instr_read[29:27] == 3'b010) begin
            if(!busy_mul) begin
                optype_read = instr_read[29:27];
                sel_dest_mul = instr_read[39:38];
                vsew_mul = instr_read[37:36];
                lmul_mul = instr_read[35:34];
                op_mul = instr_read[26:23];
                Fj_mul =  instr_read[22:18];
                Fk_mul = instr_read[17:13];
                Imm_mul = instr_read[7:3];
                Qj_mul = ((instr_read[33:32] == 2'b10) ? 3'b110: (instr_read[33:32] == 2'b11) ? 3'b111: (Fj_mul == Fi_alu && wr_alu == 1) ? 3'b001: (Fj_mul == Fi_mul && wr_mul == 1) ? 3'b010: (Fj_mul == Fi_lsu && wr_lsu == 1) ? 3'b011: (Fj_mul == Fi_sldu && wr_sldu == 1) ? 3'b100: (Fj_mul == Fi_red && wr_red == 1) ? 3'b101: 3'b000);
                Qk_mul = ((instr_read[31:30] == 2'b10) ? 3'b110: (instr_read[31:30] == 2'b11) ? 3'b111: (Fk_mul == Fi_alu && wr_alu == 1) ? 3'b001: (Fk_mul == Fi_mul && wr_mul == 1) ? 3'b010: (Fk_mul == Fi_lsu && wr_lsu == 1) ? 3'b011: (Fk_mul == Fi_sldu && wr_sldu == 1) ? 3'b100: (Fk_mul == Fi_red && wr_red == 1) ? 3'b101: 3'b000);                
                Rj_mul = ((Qj_mul == 3'b000 || Qj_mul == 3'b110 || Qj_mul == 3'b111) ? 1: (busy_alu == 0 && Qj_mul == 3'b001) ? 1: (busy_mul == 0 && Qj_mul == 3'b010) ? 1: (busy_lsu == 0 && Qj_mul == 3'b011) ? 1: (busy_sldu == 0 && Qj_mul == 3'b100) ? 1: (busy_red == 0 && Qj_mul == 3'b101) ? 1: 0);
                Rk_mul = ((Qk_mul == 3'b000 || Qk_mul == 3'b110 || Qk_mul == 3'b111) ? 1: (busy_alu == 0 && Qk_mul == 3'b001) ? 1: (busy_mul == 0 && Qk_mul == 3'b010) ? 1: (busy_lsu == 0 && Qk_mul == 3'b011) ? 1: (busy_sldu == 0 && Qk_mul == 3'b100) ? 1: (busy_red == 0 && Qk_mul == 3'b101) ? 1: 0);
                busy_mul = ((Rj_mul == 1 && Rk_mul == 1) ? 1: 0); 
                Fi_mul = busy_mul == 1 ? instr_read[12:8]: Fi_mul;                
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
                Fj_lsu =  instr_read[22:18];
                Fk_lsu = instr_read[17:13];
                Imm_lsu = instr_read[7:3];
                Qj_lsu = ((instr_read[33:32] == 2'b10) ? 3'b110: (instr_read[33:32] == 2'b11) ? 3'b111: (Fj_lsu == Fi_alu && wr_alu == 1) ? 3'b001: (Fj_lsu == Fi_mul && wr_mul == 1) ? 3'b010: (Fj_lsu == Fi_lsu && wr_lsu == 1) ? 3'b011: (Fj_lsu == Fi_sldu && wr_sldu == 1) ? 3'b100: (Fj_lsu == Fi_red && wr_red == 1) ? 3'b101: 3'b000);
                Qk_lsu = ((instr_read[31:30] == 2'b10) ? 3'b110: (instr_read[31:30] == 2'b11) ? 3'b111: (Fk_lsu == Fi_alu && wr_alu == 1) ? 3'b001: (Fk_lsu == Fi_mul && wr_mul == 1) ? 3'b010: (Fk_lsu == Fi_lsu && wr_lsu == 1) ? 3'b011: (Fk_lsu == Fi_sldu && wr_sldu == 1) ? 3'b100: (Fk_lsu == Fi_red && wr_red == 1) ? 3'b101: 3'b000);                
                Rj_lsu = ((Qj_lsu == 3'b000 || Qj_lsu == 3'b110 || Qj_lsu == 3'b111) ? 1: (busy_alu == 0 && Qj_alu == 3'b001) ? 1: (busy_mul == 0 && Qj_lsu == 3'b010) ? 1: (busy_lsu == 0 && Qj_lsu == 3'b011) ? 1: (busy_sldu == 0 && Qj_lsu == 3'b100) ? 1: (busy_red == 0 && Qj_lsu == 3'b101) ? 1: 0);
                Rk_lsu = ((Qk_lsu == 3'b000 || Qk_lsu == 3'b110 || Qk_lsu == 3'b111) ? 1: (busy_alu == 0 && Qk_alu == 3'b001) ? 1: (busy_mul == 0 && Qk_lsu == 3'b010) ? 1: (busy_lsu == 0 && Qk_lsu == 3'b011) ? 1: (busy_sldu == 0 && Qk_lsu == 3'b100) ? 1: (busy_red == 0 && Qk_lsu == 3'b101) ? 1: 0);
                busy_lsu = ((Rj_lsu == 1 && Rk_lsu == 1) ? 1: 0); 
                Fi_lsu = busy_lsu == 1 ? instr_read[12:8]: Fi_lsu;                
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
                Fj_sldu =  instr_read[22:18];
                Fk_sldu = instr_read[17:13];
                Imm_sldu = instr_read[7:3];
                Qj_sldu = ((instr_read[33:32] == 2'b10) ? 3'b110: (instr_read[33:32] == 2'b11) ? 3'b111: (Fj_sldu == Fi_alu && wr_alu == 1) ? 3'b001: (Fj_sldu == Fi_mul && wr_mul == 1) ? 3'b010: (Fj_sldu == Fi_lsu && wr_lsu == 1) ? 3'b011: (Fj_sldu == Fi_sldu && wr_sldu == 1) ? 3'b100: (Fj_sldu == Fi_red && wr_red == 1) ? 3'b101: 3'b000);
                Qk_sldu = ((instr_read[31:30] == 2'b10) ? 3'b110: (instr_read[31:30] == 2'b11) ? 3'b111: (Fk_sldu == Fi_alu && wr_alu == 1) ? 3'b001: (Fk_sldu == Fi_mul && wr_mul == 1) ? 3'b010: (Fk_sldu == Fi_lsu && wr_lsu == 1) ? 3'b011: (Fk_sldu == Fi_sldu && wr_sldu == 1) ? 3'b100: (Fk_sldu == Fi_red && wr_red == 1) ? 3'b101: 3'b000);                
                Rj_sldu = ((Qj_sldu == 3'b000 || Qj_sldu == 3'b110 || Qj_sldu == 3'b111) ? 1: (busy_alu == 0 && Qj_sldu == 3'b001) ? 1: (busy_mul == 0 && Qj_sldu == 3'b010) ? 1: (busy_lsu == 0 && Qj_sldu == 3'b011) ? 1: (busy_sldu == 0 && Qj_sldu == 3'b100) ? 1: (busy_red == 0 && Qj_sldu == 3'b101) ? 1: 0);
                Rk_sldu = ((Qk_sldu == 3'b000 || Qk_sldu == 3'b110 || Qk_sldu == 3'b111) ? 1: (busy_alu == 0 && Qk_sldu == 3'b001) ? 1: (busy_mul == 0 && Qk_sldu == 3'b010) ? 1: (busy_lsu == 0 && Qk_sldu == 3'b011) ? 1: (busy_sldu == 0 && Qk_sldu == 3'b100) ? 1: (busy_red == 0 && Qk_sldu == 3'b101) ? 1: 0);
                busy_sldu = ((Rj_sldu == 1 && Rk_sldu == 1) ? 1: 0); 
                Fi_sldu = busy_sldu == 1 ? instr_read[12:8]: Fi_sldu;                
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
                Fj_red =  instr_read[22:18];
                Fk_red = instr_read[17:13];
                Imm_red = instr_read[7:3];
                Qj_red = ((instr_read[33:32] == 2'b10) ? 3'b110: (instr_read[33:32] == 2'b11) ? 3'b111: (Fj_red == Fi_alu && wr_alu == 1) ? 3'b001: (Fj_red == Fi_mul && wr_mul == 1) ? 3'b010: (Fj_red == Fi_lsu && wr_lsu == 1) ? 3'b011: (Fj_red == Fi_sldu && wr_sldu == 1) ? 3'b100: (Fj_red == Fi_red && wr_red == 1) ? 3'b101: 3'b000);
                Qk_red = ((instr_read[31:30] == 2'b10) ? 3'b110: (instr_read[31:30] == 2'b11) ? 3'b111: (Fk_red == Fi_alu && wr_alu == 1) ? 3'b001: (Fk_red == Fi_mul && wr_mul == 1) ? 3'b010: (Fk_red == Fi_lsu && wr_lsu == 1) ? 3'b011: (Fk_red == Fi_sldu && wr_sldu == 1) ? 3'b100: (Fk_red == Fi_red && wr_red == 1) ? 3'b101: 3'b000);                
                Rj_red = ((Qj_red == 3'b000 || Qj_red == 3'b110 || Qj_red == 3'b111) ? 1: (busy_alu == 0 && Qj_red == 3'b001) ? 1: (busy_mul == 0 && Qj_red == 3'b010) ? 1: (busy_lsu == 0 && Qj_red == 3'b011) ? 1: (busy_sldu == 0 && Qj_red == 3'b100) ? 1: (busy_red == 0 && Qj_red == 3'b101) ? 1: 0);
                Rk_red = ((Qk_red == 3'b000 || Qk_red == 3'b110 || Qk_red == 3'b111) ? 1: (busy_alu == 0 && Qk_red == 3'b001) ? 1: (busy_mul == 0 && Qk_red == 3'b010) ? 1: (busy_lsu == 0 && Qk_red == 3'b011) ? 1: (busy_sldu == 0 && Qk_red == 3'b100) ? 1: (busy_red == 0 && Qk_red == 3'b101) ? 1: 0);
                busy_red = ((Rj_red == 1 && Rk_red == 1) ? 1: 0); 
                Fi_red = busy_red == 1 ? instr_read[12:8]: Fi_red;                
                instr_read [2:0] = ((Rj_red == 1 && Rk_red == 1) ? 3'b011: 3'b010); 
                instr_status_table[instr_read_index] = instr_read;
                //instr_status_table[0][2:0] = 3'b011;
            end
        end


    // ******************EXECUTE******************
        //alu
        alu_exec = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        alu_exec_index = ((instr_1[29:27] == 3'b001 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b001 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b001 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b001 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b001 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b001 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b001 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b001 && instr_8[2:0] == 3'b011) ? 7: 0);

        //mul
        mul_exec = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        mul_exec_index = ((instr_1[29:27] == 3'b010 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b010 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b010 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b010 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b010 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b010 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b010 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b010 && instr_8[2:0] == 3'b011) ? 7: 0);

        //lsu
        lsu_exec = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        lsu_exec_index = ((instr_1[29:27] == 3'b011 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b011 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b011 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b011 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b011 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b011 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b011 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b011 && instr_8[2:0] == 3'b011) ? 7: 0);

        //sldu
        sldu_exec = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        sldu_exec_index = ((instr_1[29:27] == 3'b100 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b100 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b100 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b100 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b100 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b100 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b100 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b100 && instr_8[2:0] == 3'b011) ? 7: 0);

        //red
        red_exec = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b011) ? instr_1: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b011) ? instr_2: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b011) ? instr_3: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b011) ? instr_4: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b011) ? instr_5: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b011) ? instr_6: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b011) ? instr_7: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b011) ? instr_8: 0);
        red_exec_index = ((instr_1[29:27] == 3'b101 && instr_1[2:0] == 3'b011) ? 0: (instr_2[29:27] == 3'b101 && instr_2[2:0] == 3'b011) ? 1: (instr_3[29:27] == 3'b101 && instr_3[2:0] == 3'b011) ? 2: (instr_4[29:27] == 3'b101 && instr_4[2:0] == 3'b011) ? 3: (instr_5[29:27] == 3'b101 && instr_5[2:0] == 3'b011) ? 4: (instr_6[29:27] == 3'b101 && instr_6[2:0] == 3'b011) ? 5: (instr_7[29:27] == 3'b101 && instr_7[2:0] == 3'b011) ? 6: (instr_8[29:27] == 3'b101 && instr_8[2:0] == 3'b011) ? 7: 0);


// Write Back
        wb_instr = ((instr_1[2:0] == 3'b100) ? instr_1: (instr_2[2:0] == 3'b100) ? instr_2: (instr_3[2:0] == 3'b100) ? instr_3: (instr_4[2:0] == 3'b100) ? instr_4: (instr_5[2:0] == 3'b100) ? instr_5: (instr_6[2:0] == 3'b100) ? instr_6: (instr_7[2:0] == 3'b100) ? instr_7: (instr_8[2:0] == 3'b100) ? instr_8: 0);
        wb_instr_index = ((instr_1[2:0] == 3'b100) ? 0: (instr_2[2:0] == 3'b100) ? 1: (instr_3[2:0] == 3'b100) ? 2: (instr_4[2:0] == 3'b100) ? 3: (instr_5[2:0] == 3'b100) ? 4: (instr_6[2:0] == 3'b100) ? 5: (instr_7[2:0] == 3'b100) ? 6: (instr_8[2:0] == 3'b100) ? 7: 0);
        dest_wb = (wb_instr != 0) ? wb_instr[12:8] : dest_wb;   

        el_wr_en = (wb_instr[29:27] == 3'b101 && wb_instr[39:38]==1) ? 1: 0; 
        v_reg_wr_en = (wb_instr[29:27] == 3'b101) ? 0: (wb_instr[39:38]==1) ? 1: 0;
        x_reg_wr_en = (wb_instr[39:38]==2) ? 1: 0;
               
        case (wb_instr[29:27])
            default: ;
            3'b001: begin
                reg_wr_data <= result_valu_1;
                reg_wr_data_2 <= result_valu_2;
                reg_wr_data_3 <= result_valu_3;
                reg_wr_data_4 <= result_valu_4;
                busy_alu = alu_exec[29:27 != 0] ? 1: 0;
            end
            3'b010: begin
                reg_wr_data <= result_vmul_1;
                reg_wr_data_2 <= result_vmul_2;
                reg_wr_data_3 <= result_vmul_3;
                reg_wr_data_4 <= result_vmul_4; 
                busy_mul = mul_exec[29:27 != 0] ? 1: 0;
            end
            3'b011: begin
                reg_wr_data <= result_vlsu;
                reg_wr_data_2 <= result_vlsu;
                reg_wr_data_3 <= result_vlsu;
                reg_wr_data_4 <= result_vlsu;
                busy_lsu = lsu_exec[29:27 != 0] ? 1: 0;
            end
            3'b100: begin
                reg_wr_data <= result_vsldu[127:0];
                reg_wr_data_2 <= result_vsldu[255:128];
                reg_wr_data_3 <= result_vsldu[383:256];
                reg_wr_data_4 <= result_vsldu[511:384];  
                busy_sldu = sldu_exec[29:27 != 0] ? 1: 0;
            end
            3'b101: begin
                el_wr_addr = 0;
                reg_wr_data = {{96{1'b0}}, result_vred};
                reg_wr_data_2 = {128{1'b0}};
                reg_wr_data_3 = {128{1'b0}};
                reg_wr_data_4 = {128{1'b0}};   
                busy_red = red_exec[29:27 != 0] ? 1: 0;
            end
        endcase     
    end


    //Execute Stage done, update status to Write Back stage
    always @(done_alu, done_mul, done_lsu, done_sldu, done_red) begin

        #0.5
        if (done_alu == 1 && alu_exec != 0) begin
            alu_exec[2:0] = 3'b100;
            instr_status_table[alu_exec_index] = alu_exec;
            op_alu = 0;
            wr_alu = 1;
        end

        if (done_mul == 1 && mul_exec != 0) begin
            mul_exec[2:0] = 3'b100;
            instr_status_table[mul_exec_index] = mul_exec;
            op_mul = 0;
            wr_mul = 1;
        end

        if (done_lsu == 1 && lsu_exec != 0) begin
            lsu_exec[2:0] = 3'b100;
            instr_status_table[lsu_exec_index] = lsu_exec;
            op_lsu = 0;
            wr_lsu = 1;
        end

        if (done_sldu == 1 && sldu_exec != 0) begin
            sldu_exec[2:0] = 3'b100;
            instr_status_table[sldu_exec_index] = sldu_exec;
            op_sldu = 0;
            wr_sldu = 1;
        end

        if (done_red == 1 && red_exec != 0) begin
            red_exec[2:0] = 3'b100;
            instr_status_table[red_exec_index] = red_exec;
            Rj_red = 0;
            Rk_red = 0;
            op_red = 0;
            wr_red = 1;
        end
    end

    //Write Back stage done, delete instruction from IST
    always @(clk) begin

        case(wb_instr[29:27]) 
        default: ;
        3'b001: wr_alu = 0;
        3'b010: wr_mul = 0;
        3'b011: wr_lsu = 0;
        3'b100: wr_sldu = 0;
        3'b101: wr_red = 0;
        endcase 

        if (wb_instr !=0 ) begin
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
    end

endmodule

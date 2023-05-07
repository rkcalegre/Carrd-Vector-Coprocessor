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
    parameter int IST_ENTRY_BITS = 9;       // For Instruction Status Table: 6 bits (maybe for opcode?) + 3 bits (instr_status)
    parameter int NO_OF_SLOTS = 8;
    parameter int FU_ENTRY_BITS = 5;
)(
    input clk,
    input nrst,
    input [5:0] op_instr,                   // see line 21 regarding issues with the # of bits to be placed in IST
    input [3:0] instr_status
);

    //*************************** INSTRUCTION STATUS BLOCK *************************************//
    // contains 8 slots used for keeping track of instructions
    // executing within the pipeline, specifically the stage each instruction is currently in.
    // Represented by 3 bits to denote each stage:
    // 3'b000 - issue stage (vIS) OR set this as default?
    // 3'b001 - read operands stage
    // 3'b010 - execution stage (vEX)
    // 3'b011 - writes results stage 
    // 3'b100 - ?? default value? or empty slot?
    // Format of Table:
    // 	==============================================
    //  | Instruction[7:0] | Instruction Stage[2:0] | 
    // 	==============================================

    // uses v1 format of table
    logic [IST_ENTRY_BITS-1:0] instr_status_table [0:NO_OF_SLOTS-1];         // instruction status table
    logic [2:0] fifo_count;                                                  // keeps track of # of instructions currently in the table
    logic [11:0] function_unit_status [0:FU_ENTRY_BITS-1];                                 // functional unit status block
    logic [31:0] register_status;                                            // register result status block
    
    assign fifo_full = (fifo_count == NO_OF_SLOTS-1);

    // WRITES TO INSTR_STATUS_TABLE
    // TO BE ADDED: Stall Conditions
    // TO BE ADDED: Updating Instruction stage


    initial begin
        for (int i = 0; i < NO_OF_SLOTS; i++) begin
            fifo_count[i] <= 2'b00;
            instr_status_table[i] <= {IST_ENTRY_BITS{1'b0}};
        end 
    end

    // FIFO Count Condition
    always @(posedge clk) begin
        if (!fifo_full) begin
            fifo_count <= fifo_count + 1;
        end
    end

    // Write to Instruction Status Table
    always @(posedge clk) begin
        if (!nrst) begin
            for (int i = 0; i < NO_OF_SLOTS; i++) begin
                fifo_count[i] <= 2'b00;
                instr_status_table[i] <= {IST_ENTRY_BITS{1'b0}};
            end
        end else begin
            instr_status_table[fifo_count] <= {op_instr, 3'b000};
        end
    end

endmodule

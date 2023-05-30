//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// v_storeunit.sv -- Vector Store Data Unit
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 199 Carrd: RISC-V Vector Coprocessor Group (2SAY2223)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: v_storeunit.sv
// Description: 
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//                        
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps
`include "constants.vh"

module storeunit #(
    parameter int VLEN = 128;
)(
    input logic [3:0] store_op,
    input logic [2:0] lmul,
    input logic [2:0] vsew,
    input logic [4:0] stride,
    input logic [`DATAMEM_BITS-1:0] address,
    input logic [511:0] data,

    // Each Data Address triggers the write enable of their respective memory bank
    output logic [`DATAMEM_BITS-1:0] data_addr0,
    output logic [`DATAMEM_BITS-1:0] data_addr1,
    output logic [`DATAMEM_BITS-1:0] data_addr2,
    output logic [`DATAMEM_BITS-1:0] data_addr3,
    output logic [127:0] data_out0,
    output logic [127:0] data_out1,
    output logic [127:0] data_out2,
    output logic [127:0] data_out3,
    output logic done
);

    import v_pkg::*;

    logic [511:0] storedata;
    logic [4:0] elem_per_vreg = VLEN/vsew;
    logic [2:0] num_reg = (lmul == 3'b000) ? 1 : (lmul == 3'b001) ? 2 : (lmul == 3'b010) ? 4 : 1;   // # of registers to be stored
    int iter = elem_per_vreg / 4;                                                                   // ensures all of the elements in each register are stored
    int exe_cc = (elem_per_vreg / 4) * iter * num_reg;                                              // # of clock cycles per operation
    int cc = 0;                                                                                     // refers to clock cycles

    assign data_addr0 = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? 
                        (address + stride) : (address);
    assign data_addr1 = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? 
                        (address + stride) : (address + 1);
    assign data_addr2 = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? 
                        (address + stride) : (address + 2);
    assign data_addr3 = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? 
                        (address + stride) : (address + 3);
    assign done = (cc == exe_cc);

    logic [127:0] temp_data;
    assign temp_data = (store_op == VLSU_VSE8 || store_op == VLSU_VSSE8) ? data >> 32*cc : 
                       (store_op == VLSU_VSE16 || store_op == VLSU_VSSE16) ? data >> 64*cc : 
                       (store_op == VLSU_VSE32 || store_op == VLSU_VSSE32) ? data >> 128*cc : data >> 128*cc;

    initial begin
        storedata <= 0;
        cc <= 0;
    end

    always_comb begin
        if (!done) begin
           case (store_op)
            VLSU_VSE8: begin
                storedata = { {480{0}} , {data[31:0]} };
                data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                data_out1 = { {24{storedata[15]}} , {storedata[15:8]} };
                data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };
                data_out3 = { {24{storedata[31]}} , {storedata[31:24]} };
                cc = cc + 1;
            end
            VLSU_VSE16: begin
                storedata = { {448{0}} , {data[63:0]} };
                data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                data_out1 = { {16{storedata[31]}} , {storedata[31:16]} };
                data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                data_out3 = { {16{storedata[63]}} , {storedata[63:48]} };
                cc = cc + 1;
            end
            VLSU_VSE32: begin
                storedata = { {384{0}} , {data[127:0]} };
                data_out0 = storedata[31:0];
                data_out1 = storedata[63:32];
                data_out2 = storedata[95:64];
                data_out3 = storedata[127:96];
                cc = cc + 1;
            end
            VLSU_VSSE8: begin
                storedata = { {480{0}} , {data[31:0]} };
                data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                data_out1 = { {24{storedata[15]}} , {storedata[15:8]} };
                data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };
                data_out3 = { {24{storedata[31]}} , {storedata[31:24]} };
                cc = cc + 1;
            end
            VLSU_VSSE16: begin
                storedata = { {448{0}} , {data[63:0]} };
                data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                data_out1 = { {16{storedata[31]}} , {storedata[31:16]} };
                data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                data_out3 = { {16{storedata[63]}} , {storedata[63:48]} };
                cc = cc + 1;
            end
            VLSU_VSSE32: begin
                storedata = { {384{0}} , {data[127:0]} };
                data_out0 = storedata[31:0];
                data_out1 = storedata[63:32];
                data_out2 = storedata[95:64];
                data_out3 = storedata[127:96];
                cc = cc + 1;
            end
            default: begin
                storedata = { {384{0}} , {data[127:0]} };
                data_out0 = storedata[31:0];
                data_out1 = storedata[63:32];
                data_out2 = storedata[95:64];
                data_out3 = storedata[127:96];
                cc = cc + 1;
            end
        endcase 
        end
    end
    
endmodule
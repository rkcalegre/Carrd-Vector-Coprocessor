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

module v_storeunit #(
    parameter int VLEN = 128
)(
    input logic clk,
    input logic nrst,
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
    output logic [`DATAMEM_WIDTH-1:0] data_out0,
    output logic [`DATAMEM_WIDTH-1:0] data_out1,
    output logic [`DATAMEM_WIDTH-1:0] data_out2,
    output logic [`DATAMEM_WIDTH-1:0] data_out3,
    output logic done,
    output logic dm_v_write
);

    import v_pkg::*;

    logic [511:0] storedata;
    logic [4:0] elem_per_vreg;
    logic [2:0] num_reg;                    // # of registers to be stored
    logic [4:0] iter;                       // ensures all of the elements in each register are stored
    logic [4:0] exe_cc;                     // # of clock cycles per operation
    logic [4:0] cc;
    int temp_addr;
    logic [`DATAMEM_BITS-1:0] strided_temp_addr[0:3];
    logic [6:0] strided_cc;
    logic s_tmp_done;

    assign elem_per_vreg = (vsew == 3'b000) ? 5'd16 : (vsew == 3'b001) ? 5'd8 : (vsew == 3'b010) ? 5'd4 : 5'd4; 
    assign num_reg = (lmul == 3'b000) ? 3'd1 : (lmul == 3'b001) ? 3'd2 : (lmul == 3'b010) ? 3'd4 : 3'd1;                                                                                // refers to clock cycles
    assign iter = (elem_per_vreg == 5'd16) ? 5'd4 : (elem_per_vreg == 5'd8) ? 5'd2 : (elem_per_vreg == 5'd4) ? 5'd1 : 5'd1;
    assign strided_cc = (v_lsu_op == 10) ? 4 : (v_lsu_op == 11) ? 2 : (v_lsu_op == 12) ? 1 : 0; 
    //assign exe_cc = (elem_per_vreg / 4) * iter * num_reg;
    assign exe_cc = (v_lsu_op inside {[7:9]}) ? num_reg : (v_lsu_op inside {[10:12]}) ? ((stride inside {2,6,10,14}) ? num_reg*2*strided_cc : (stride inside {3,5,7,9,11,13,15}) ? num_reg*1*strided_cc : (stride inside {4,8,12,16}) ? num_reg*4*strided_cc : 0) : 0;
    assign s_tmp_done = (v_lsu_op inside {[7:12]} && s_cc == exe_cc-1);
    assign dm_v_write = (v_lsu_op inside {[7:12]});
    //assign dm_v_write = ((s_cc > 0 && v_lsu_op inside {[7:12]}));

    logic [511:0] temp_data;

    initial begin
        s_cc <= 1'b0;
        s_done <= 1'b0;
        s_tmp_done <= 1'b0;
    end

    always@(posedge clk) begin
        if (!nrst) begin
            s_cc <= 1'b0;
        end
    end

    always_comb begin
        if (v_lsu_op inside {[7:9]}) begin             
            temp_addr = (s_cc == 0) ? address : temp_addr + 4;
            data_addr0 = (s_cc != exe_cc) ? temp_addr : data_addr0;
            data_addr1 = (s_cc != exe_cc) ? temp_addr + 1 : data_addr1;
            data_addr2 = (s_cc != exe_cc) ? temp_addr + 2 : data_addr2;
            data_addr3 = (s_cc != exe_cc) ? temp_addr + 3 : data_addr3;
        end else if (v_lsu_op inside {[10:12]}) begin
            case (stride)
                2,6,10,14: begin
                    temp_addr = (s_cc == 0) ? address : temp_addr + stride*2;
                    data_addr0 = (s_cc != exe_cc) ? temp_addr : data_addr0;
                    data_addr1 = (s_cc != exe_cc) ? 0 : 0;
                    data_addr2 = (s_cc != exe_cc) ? temp_addr + stride : data_addr2;
                    data_addr3 = (s_cc != exe_cc) ? 0 : 0;
                end
                3,7,11,15: begin
                    temp_addr = (s_cc == 0) ? address : temp_addr + stride*4;
                    data_addr0 = (s_cc != exe_cc) ? temp_addr : data_addr0;
                    data_addr1 = (s_cc != exe_cc) ? temp_addr + stride*3 : data_addr1;
                    data_addr2 = (s_cc != exe_cc) ? temp_addr + stride*2 : data_addr2;
                    data_addr3 = (s_cc != exe_cc) ? temp_addr + stride : data_addr3;  
                end
                4,8,12,16: begin
                    temp_addr = (s_cc == 0) ? address : temp_addr + 4;
                    data_addr0 = (s_cc != exe_cc) ? temp_addr : data_addr0;
                    data_addr1 = (s_cc != exe_cc) ? 0 : 0;
                    data_addr2 = (s_cc != exe_cc) ? 0 : 0;
                    data_addr3 = (s_cc != exe_cc) ? 0 : 0;
                end
                5,9,13: begin
                    temp_addr = (s_cc == 0) ? address : temp_addr + stride*4;
                    data_addr0 = (s_cc != exe_cc) ? temp_addr : data_addr0;
                    data_addr1 = (s_cc != exe_cc) ? temp_addr + stride : data_addr1;
                    data_addr2 = (s_cc != exe_cc) ? temp_addr + stride*2 : data_addr2;
                    data_addr3 = (s_cc != exe_cc) ? temp_addr + stride*3 : data_addr3;
                end
                default: begin
                    //
                end
            endcase
        end
    end

    always_comb begin
        temp_data = (s_cc == 0) ? s_data : (v_lsu_op inside {[7:9]}) ? temp_data >> 128 : temp_data >> 128;
        //temp_data = (v_lsu_op inside {[7:9]}) ? temp_data >> 128 : temp_data >> 128;
        case (v_lsu_op)
            VLSU_VSE8: begin
                storedata = temp_data[127:0];
                data_out0 = storedata[31:0];
                data_out1 = storedata[63:32];
                data_out2 = storedata[95:64];
                data_out3 = storedata[127:96];
            end
            VLSU_VSE16: begin
                storedata = temp_data[127:0];
                data_out0 = storedata[31:0];
                data_out1 = storedata[63:32];
                data_out2 = storedata[95:64];
                data_out3 = storedata[127:96];
            end
            VLSU_VSE32: begin
                storedata = temp_data[127:0];
                data_out0 = storedata[31:0];
                data_out1 = storedata[63:32];
                data_out2 = storedata[95:64];
                data_out3 = storedata[127:96];
            end
            VLSU_VSSE8: begin
                case (stride)
                    2,6,10,14: begin
                        storedata = { {496{1'b0}} , {temp_data[15:0]} };
                        data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                        data_out1 = 0;
                        data_out2 = { {24{storedata[15]}} , {storedata[15:8]} };
                        data_out3 = 0;
                    end
                    3,7,11,15: begin
                        storedata = { {480{1'b0}} , {temp_data[31:0]} };
                        data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                        data_out1 = { {24{storedata[31]}} , {storedata[31:24]} };
                        data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };                            data_out3 = { {24{storedata[15]}} , {storedata[15:8]} };
                    end
                    4,8,12,16: begin
                        storedata = { {504{1'b0}} , {temp_data[7:0]} };
                        data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                    end
                    5,9,13:  begin
                        storedata = { {480{1'b0}} , {temp_data[31:0]} };
                        data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                        data_out1 = { {24{storedata[15]}} , {storedata[15:8]} };
                        data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };
                        data_out3 = { {24{storedata[31]}} , {storedata[31:24]} };
                    end
                    default: begin
                        //
                    end 
                endcase
            end
            VLSU_VSSE16: begin
                case (stride)
                    2,6,10,14: begin
                        storedata = { {480{1'b0}} , {temp_data[31:0]} };
                        data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                        data_out1 = 0;
                        data_out2 = { {16{storedata[31]}} , {storedata[31:16]} };
                        data_out3 = 0;
                    end
                    3,7,11,15: begin
                        storedata = { {448{1'b0}} , {temp_data[63:0]} };
                        data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                        data_out1 = { {16{storedata[63]}} , {storedata[63:48]} };
                        data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                        data_out3 = { {16{storedata[31]}} , {storedata[31:16]} };
                    end
                    4,8,12,16: begin
                        storedata = { {496{1'b0}} , {temp_data[15:0]} };
                        data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                    end
                    5,9,13:  begin
                        storedata = { {448{1'b0}} , {temp_data[63:0]} };
                        data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                        data_out1 = { {16{storedata[31]}} , {storedata[31:16]} };
                        data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                        data_out3 = { {16{storedata[63]}} , {storedata[63:48]} };
                    end
                    default: begin
                        //      
                    end 
                endcase
            end
            VLSU_VSSE32: begin
                case (stride)
                    2,6,10,14: begin
                        storedata = { {448{1'b0}} , {temp_data[63:0]} };
                        data_out0 = storedata[31:0];
                        data_out1 = 0;
                        data_out2 = storedata[63:32];
                        data_out3 = 0;
                    end
                    3,7,11,15: begin
                        storedata = { {384{1'b0}} , {temp_data[127:0]} };
                        data_out0 = storedata[31:0];
                        data_out1 = storedata[127:96];
                        data_out2 = storedata[95:64];
                        data_out3 = storedata[63:32];
                    end
                    4,8,12,16: begin
                        storedata = { {480{1'b0}} , {temp_data[31:0]} };
                        data_out0 = storedata[31:0];
                    end
                    5,9,13: begin
                        storedata = { {384{1'b0}} , {temp_data[127:0]} };
                        data_out0 = storedata[31:0];
                        data_out1 = storedata[63:32];
                        data_out2 = storedata[95:64];
                        data_out3 = storedata[127:96];
                    end
                    default: begin
                        //
                    end  
                endcase
            end
            default: begin
                //
            end
        endcase
    end

    always@(negedge clk) begin
        if (v_lsu_op inside {[7:12]}) begin
            s_cc = s_cc + 1'b1;                 // counter that keeps track of execution time
        end else begin
            s_cc = 0;                           // reset counter when done     
        end

        if (v_lsu_op == 0) s_cc = 0;
    end

    always @(negedge s_tmp_done) begin
        s_done = 1'b1;
        s_cc = 0;
    end

    always @(posedge dm_v_write) begin
        s_done = 0'b0;
    end
    
endmodule
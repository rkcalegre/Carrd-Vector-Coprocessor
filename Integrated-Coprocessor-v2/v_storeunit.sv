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

    assign elem_per_vreg = (vsew == 3'b000) ? 5'd16 : (vsew == 3'b001) ? 5'd8 : (vsew == 3'b010) ? 5'd4 : 5'd4; 
    assign num_reg = (lmul == 3'b000) ? 3'd1 : (lmul == 3'b001) ? 3'd2 : (lmul == 3'b010) ? 3'd4 : 3'd1;                                                                                // refers to clock cycles
    assign iter = (elem_per_vreg == 5'd16) ? 5'd4 : (elem_per_vreg == 5'd8) ? 5'd2 : (elem_per_vreg == 5'd4) ? 5'd1 : 5'd1;
    //assign exe_cc = (elem_per_vreg / 4) * iter * num_reg;
    //assign exe_cc = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? strided_cc : num_reg;
    assign exe_cc = num_reg;

    /*
    assign data_addr0 = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? 
                        (strided_temp_addr[0]) : (temp_addr);
    assign data_addr1 = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? 
                        (strided_temp_addr[1]) : (temp_addr + 14'd1);
    assign data_addr2 = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? 
                        (strided_temp_addr[2]) : (temp_addr + 14'd2);
    assign data_addr3 = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? 
                        (strided_temp_addr[3]) : (temp_addr + 14'd3);
    */
    /*
    assign temp_addr = (cc == 0 || done) ? address : temp_addr + 4;
    assign data_addr0 = (!done) ? temp_addr : data_addr0;
    assign data_addr1 = (!done) ? temp_addr + 1 : data_addr1;
    assign data_addr2 = (!done) ? temp_addr + 2 : data_addr2;
    assign data_addr3 = (!done) ? temp_addr + 3 : data_addr3;
    */
    assign done = (cc == exe_cc+1);
    assign dm_v_write = ((cc > 0 && store_op inside {[7:12]}) || (cc == 0 && !clk && store_op inside {[7:12]}));

    logic [127:0] temp_data;
    /*
    assign temp_data = (store_op == VLSU_VSE8 || store_op == VLSU_VSSE8) ? data >> 32*cc : 
                       (store_op == VLSU_VSE16 || store_op == VLSU_VSSE16) ? data >> 64*cc : 
                       (store_op == VLSU_VSE32 || store_op == VLSU_VSSE32) ? data >> 128*cc : data >> 128*cc;
    */
    assign temp_data = (!done && cc != exe_cc) ? ((store_op == VLSU_VSSE8) ? ((stride == 2) ? data >> 16*cc : (stride == 4) ? data >> 8*cc : data >> 32*cc) : 
                       (store_op == VLSU_VSSE16) ? ((stride == 2) ? data >> 32*cc : (stride == 4) ? data >> 16*cc : data >> 64*cc) : 
                       (store_op == VLSU_VSSE32) ? ((stride == 2) ? data >> 64*cc : (stride == 4) ? data >> 32*cc : data >> 128*cc) :
                       (store_op == VLSU_VSE8 || store_op == VLSU_VSE16 || store_op == VLSU_VSE32) ? data >> 128*cc : data >> 128*cc) : temp_data;

    /*
    assign data_out0 = (store_op inside {[7:9]} && !done) ? temp_data[31:0] : 32'b0; 
    assign data_out1 = (store_op inside {[7:9]} && !done) ? temp_data[63:32] : 32'b0; 
    assign data_out2 = (store_op inside {[7:9]} && !done) ? temp_data[95:64] : 32'b0; 
    assign data_out3 = (store_op inside {[7:9]} && !done) ? temp_data[127:96] : 32'b0; 
    */
    initial begin
        cc <= 1'b0;
        dm_v_write <= 1'b0;
        done <= 1'b0;
    end

    always@(posedge clk) begin
        if (!nrst) begin
            cc <= 1'b0;
            dm_v_write <= 1'b0;
            done <= 1'b0;
        end
    end

    
    always@(negedge clk) begin
        case (store_op)
            VLSU_VSE8: begin
                storedata = { {384{1'b0}} , {temp_data[127:0]} };
                data_out0 = storedata[31:0];
                data_out1 = storedata[63:32];
                data_out2 = storedata[95:64];
                data_out3 = storedata[127:96];
            end
            VLSU_VSE16: begin
                storedata = { {384{1'b0}} , {temp_data[127:0]} };
                data_out0 = storedata[31:0];
                data_out1 = storedata[63:32];
                data_out2 = storedata[95:64];
                data_out3 = storedata[127:96];
            end
            VLSU_VSE32: begin
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

    always@(negedge clk) begin
        if (store_op inside {[7:12]}) begin             
            temp_addr = (cc == 0 || done) ? address : temp_addr + 4;
            data_addr0 = (!done && cc != exe_cc) ? temp_addr : data_addr0;
            data_addr1 = (!done && cc != exe_cc) ? temp_addr + 1 : data_addr1;
            data_addr2 = (!done && cc != exe_cc) ? temp_addr + 2 : data_addr2;
            data_addr3 = (!done && cc != exe_cc) ? temp_addr + 3 : data_addr3;
        end
    end
    
    always @(posedge clk) begin
        if (!done && store_op inside {[7:12]}) begin // note changes
            cc = cc + 1'b1;                 // counter that keeps track of execution time
        end else begin
            cc = 0;                         // reset counter when done     
        end

        if (store_op == 0) cc = 0;
    end

    always @(posedge done) begin
        //temp_addr = address;
        dm_v_write = 0;
    end
    /*
    always@(negedge clk) begin
        if (!done) begin
            case (store_op)
                VLSU_VSE8: begin
                    storedata = { {384{1'b0}} , {temp_data[127:0]} };
                    data_out0 = storedata[31:0];
                    data_out1 = storedata[63:32];
                    data_out2 = storedata[95:64];
                    data_out3 = storedata[127:96];
                    cc = cc + 1'b1;
                end
                VLSU_VSE16: begin
                    storedata = { {384{1'b0}} , {temp_data[127:0]} };
                    data_out0 = storedata[31:0];
                    data_out1 = storedata[63:32];
                    data_out2 = storedata[95:64];
                    data_out3 = storedata[127:96];
                    cc = cc + 1'b1;
                end
                VLSU_VSE32: begin
                    storedata = { {384{1'b0}} , {temp_data[127:0]} };
                    data_out0 = storedata[31:0];
                    data_out1 = storedata[63:32];
                    data_out2 = storedata[95:64];
                    data_out3 = storedata[127:96];
                    cc = cc + 1'b1;
                end
                VLSU_VSSE8: begin
                    //storedata = { {480{1'b0}} , {temp_data[31:0]} };
                    case (stride)
                        2: begin
                            storedata = { {496{1'b0}} , {temp_data[15:0]} };
                            data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                            data_out1 = 0;
                            data_out2 = { {24{storedata[15]}} , {storedata[15:8]} };
                            data_out3 = 0;
                        end
                        3: begin
                            storedata = { {480{1'b0}} , {temp_data[31:0]} };
                            data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                            data_out1 = { {24{storedata[31]}} , {storedata[31:24]} };
                            data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };
                            data_out3 = { {24{storedata[15]}} , {storedata[15:8]} };
                        end
                        4: begin
                            storedata = { {504{1'b0}} , {temp_data[7:0]} };
                            data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                        end
                        5:  begin
                            storedata = { {480{1'b0}} , {temp_data[31:0]} };
                            data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                            data_out1 = { {24{storedata[15]}} , {storedata[15:8]} };
                            data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };
                            data_out3 = { {24{storedata[31]}} , {storedata[31:24]} };
                        end
                        default: begin
                            
                        end
                    endcase
                    cc = cc + 1'b1;
                end
                VLSU_VSSE16: begin
                    //storedata = { {448{1'b0}} , {temp_data[63:0]} };
                    case (stride)
                        2: begin
                            storedata = { {480{1'b0}} , {temp_data[31:0]} };
                            data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                            data_out1 = 0;
                            data_out2 = { {16{storedata[31]}} , {storedata[31:16]} };
                            data_out3 = 0;
                        end
                        3: begin
                            storedata = { {448{1'b0}} , {temp_data[63:0]} };
                            data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                            data_out1 = { {16{storedata[63]}} , {storedata[63:48]} };
                            data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                            data_out3 = { {16{storedata[31]}} , {storedata[31:16]} };
                        end
                        4: begin
                            storedata = { {496{1'b0}} , {temp_data[15:0]} };
                            data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                        end
                        5:  begin
                            storedata = { {448{1'b0}} , {temp_data[63:0]} };
                            data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                            data_out1 = { {16{storedata[31]}} , {storedata[31:16]} };
                            data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                            data_out3 = { {16{storedata[63]}} , {storedata[63:48]} };
                        end
                        default: begin
                            
                        end
                    endcase
                    cc = cc + 1'b1;
                end
                VLSU_VSSE32: begin
                    //storedata = { {384{1'b0}} , {temp_data[127:0]} };
                    case (stride)
                        2: begin
                            storedata = { {448{1'b0}} , {temp_data[63:0]} };
                            data_out0 = storedata[31:0];
                            data_out1 = 0;
                            data_out2 = storedata[63:32];
                            data_out3 = 0;
                        end
                        3: begin
                            storedata = { {384{1'b0}} , {temp_data[127:0]} };
                            data_out0 = storedata[31:0];
                            data_out1 = storedata[127:96];
                            data_out2 = storedata[95:64];
                            data_out3 = storedata[63:32];
                        end
                        4: begin
                            storedata = { {480{1'b0}} , {temp_data[31:0]} };
                            data_out0 = storedata[31:0];
                        end
                        5: begin
                            storedata = { {384{1'b0}} , {temp_data[127:0]} };
                            data_out0 = storedata[31:0];
                            data_out1 = storedata[63:32];
                            data_out2 = storedata[95:64];
                            data_out3 = storedata[127:96];
                        end
                        default: begin
                            
                        end
                    endcase
                    cc = cc + 1'b1;
                end
                default: begin

                end
            endcase
            if (cc > 0) begin
                if (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) begin
                    case (stride)
                        2 : begin
                            strided_temp_addr[0] = temp_addr;
                            strided_temp_addr[1] = 0;
                            strided_temp_addr[2] = temp_addr + stride;
                            strided_temp_addr[3] = 0;
                            temp_addr = temp_addr + stride*2;
                        end
                        3 : begin
                            strided_temp_addr[0] = temp_addr;
                            strided_temp_addr[1] = temp_addr + stride*3;
                            strided_temp_addr[2] = temp_addr + stride*2;
                            strided_temp_addr[3] = temp_addr + stride;
                            temp_addr = temp_addr + stride*4;
                        end
                        4 : begin
                            strided_temp_addr[0] = temp_addr;
                            strided_temp_addr[1] = 0;
                            strided_temp_addr[2] = 0;
                            strided_temp_addr[3] = 0;
                            temp_addr = temp_addr + 4;
                        end
                        5 : begin
                            strided_temp_addr[0] = temp_addr;
                            strided_temp_addr[1] = temp_addr + stride;
                            strided_temp_addr[2] = temp_addr + stride*2;
                            strided_temp_addr[3] = temp_addr + stride*3;
                            temp_addr = temp_addr + stride*4;
                        end
                        default: begin
                            
                        end
                    endcase
                    //temp_addr = temp_addr + stride*4;
                end else
                    temp_addr = temp_addr + 4;
            end else temp_addr = address;
        end else begin
            cc = 0;
        end

        // for computing strided execution time
        case (store_op)
            VLSU_VSSE8: begin
                case ({lmul , stride})
                    // lmul = 1
                    8'b00000010: strided_cc = 8;
                    8'b00000100: strided_cc = 16;
                    8'b00000011: strided_cc = 4;
                    8'b00000101: strided_cc = 4;
                    // lmul = 2
                    8'b00100010: strided_cc = 16;
                    8'b00100100: strided_cc = 32;
                    8'b00100011: strided_cc = 8;
                    8'b00100101: strided_cc = 8;
                    // lmul = 4
                    8'b01000010: strided_cc = 32;
                    8'b01000100: strided_cc = 64;
                    8'b01000011: strided_cc = 16;
                    8'b01000101: strided_cc = 16;
                    default: begin
                        
                    end 
                endcase
            end
            VLSU_VSSE16: begin
                case ({lmul , stride})
                    8'b00000010: strided_cc = 4;
                    8'b00000100: strided_cc = 8;
                    8'b00000011: strided_cc = 2;
                    8'b00000101: strided_cc = 2;

                    8'b00100010: strided_cc = 8;
                    8'b00100100: strided_cc = 16;
                    8'b00100011: strided_cc = 4;
                    8'b00100101: strided_cc = 4;

                    8'b01000010: strided_cc = 16;
                    8'b01000100: strided_cc = 32;
                    8'b01000011: strided_cc = 8;
                    8'b01000101: strided_cc = 8;
                    default: begin
                       // 
                    end
                endcase
            end
            VLSU_VSSE32: begin
                case ({lmul , stride})
                    8'b00000010: strided_cc = 2;
                    8'b00000100: strided_cc = 4;
                    8'b00000011: strided_cc = 1;
                    8'b00000101: strided_cc = 1;

                    8'b00100010: strided_cc = 4;
                    8'b00100100: strided_cc = 8;
                    8'b00100011: strided_cc = 2;
                    8'b00100101: strided_cc = 2;

                    8'b01000010: strided_cc = 8;
                    8'b01000100: strided_cc = 16;
                    8'b01000011: strided_cc = 4;
                    8'b01000101: strided_cc = 4;
                    default: begin
                       // 
                    end
                endcase
            end
            default: begin
                
            end
        endcase
        /*
        case ({ lmul , vsew , stride })
            // lmul = 1 and stride = 2
            11'b00000000010: strided_cc = 8;
            11'b00000100010: strided_cc = 4;
            11'b00001000010: strided_cc = 2;
            // lmul = 1 and stride = 4
            11'b00000000100: strided_cc = 16;
            11'b00000100100: strided_cc = 8;
            11'b00001000100: strided_cc = 4;
            // lmul = 1 and stride = 3 
            11'b00000000011: strided_cc = 4;
            11'b00000100011: strided_cc = 2;
            11'b00001000011: strided_cc = 1;
            // lmul = 1 and stride = 5
            11'b00000000101: strided_cc = 4;
            11'b00000100101: strided_cc = 2;
            11'b00001000101: strided_cc = 1;
            ////////////////////////////////
            // lmul = 2 and stride = 2
            11'b00100000010: strided_cc = 16;
            11'b00100100010: strided_cc = 8;
            11'b00101000010: strided_cc = 4;
            // lmul = 2 and stride = 4
            11'b00100000100: strided_cc = 32;
            11'b00100100100: strided_cc = 16;
            11'b00101000100: strided_cc = 8;
            // lmul = 2 and stride = 3 
            11'b00100000011: strided_cc = 8;
            11'b00100100011: strided_cc = 4;
            11'b00101000011: strided_cc = 2;
            // lmul = 2 and stride = 5
            11'b00100000101: strided_cc = 8;
            11'b00100100101: strided_cc = 4;
            11'b00101000101: strided_cc = 2;
            ////////////////////////////////
            // lmul = 4 and stride = 2
            11'b01000000010: strided_cc = 32;
            11'b01000100010: strided_cc = 16;
            11'b01001000010: strided_cc = 8;
            // lmul = 4 and stride = 4
            11'b01000000100: strided_cc = 64;
            11'b01000100100: strided_cc = 32;
            11'b01001000100: strided_cc = 16;
            // lmul = 4 and stride = 3 
            11'b01000000011: strided_cc = 16;
            11'b01000100011: strided_cc = 8;
            11'b01001000011: strided_cc = 4;
            // lmul = 4 and stride = 5
            11'b01000000101: strided_cc = 16;
            11'b01000100101: strided_cc = 8;
            11'b01001000101: strided_cc = 4;
            default: begin
                
            end
        endcase
        
    end

    always @(negedge done) begin
        temp_addr = address;
        cc = 0;
    end
    */
    
endmodule
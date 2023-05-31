`timescale 1ns / 1ps
`include "constants.vh"

module v_lsu (

    input logic [31:0] l_data_in0, 
    input logic [31:0] l_data_in1,
    input logic [31:0] l_data_in2,
    input logic [31:0] l_data_in3,
    input logic [3:0] vlsu_op,
    input logic [2:0] lmul,
    input logic [31:0] l_addr,  
    output logic [511:0] l_data_out,
    output logic l_done

);

    import v_pkg::*;                    // contains constants

    logic [511:0] loaddata;
    logic [4:0] elem_per_vreg = VLEN/vsew;
    logic [2:0] num_reg = (lmul == 3'b000) ? 1 : (lmul == 3'b001) ? 2 : (lmul == 3'b010) ? 4 : 1;   // # of registers to be stored
    int iter = elem_per_vreg / 4;                                                                   // ensures all of the elements in each register are stored
    int exe_cc = (elem_per_vreg / 4) * iter * num_reg;                                              // # of clock cycles per operation
    //int cc = 0;
    int current_reg = 0;     
                                                                                    // refers to clock cycles
    assign num_reg = (lmul == 3'b000) ? 1 : (lmul == 3'b001) ? 2 : (lmul == 3'b010) ? 4 : 1;   // # of registers to be stored
    //assign iter = elem_per_vreg / 4;                                                                   // ensures all of the elements in each register are stored
    //assign exe_cc = (elem_per_vreg / 4) * iter * num_reg;                                              // # of clock cycles per operation 


    assign done = (current_reg == num_reg);

    logic [127:0] temp_data;

    initial begin
        loaddata <= 0;
        cc <= 0;
    end

    always_comb begin
        if (!done) begin

            case (current_reg)
                0: loaddata[127:0] = 
                default: 
            endcase
            case (store_op)
                VLSU_VLE8: begin
                    storedata = { {480{0}} , {temp_data[31:0]} };
                    data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                    data_out1 = { {24{storedata[15]}} , {storedata[15:8]} };
                    data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };
                    data_out3 = { {24{storedata[31]}} , {storedata[31:24]} };
                    cc = cc + 1;
                end
                VLSU_VLE16: begin
                    storedata = { {448{0}} , {temp_data[63:0]} };
                    data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                    data_out1 = { {16{storedata[31]}} , {storedata[31:16]} };
                    data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                    data_out3 = { {16{storedata[63]}} , {storedata[63:48]} };
                    cc = cc + 1;
                end
                VLSU_VLE32: begin
                    storedata = { {384{0}} , {temp_data[127:0]} };
                    data_out0 = storedata[31:0];
                    data_out1 = storedata[63:32];
                    data_out2 = storedata[95:64];
                    data_out3 = storedata[127:96];
                    cc = cc + 1;
                end
                VLSU_VLSE8: begin
                    storedata = { {480{0}} , {temp_data[31:0]} };
                    data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                    data_out1 = { {24{storedata[15]}} , {storedata[15:8]} };
                    data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };
                    data_out3 = { {24{storedata[31]}} , {storedata[31:24]} };
                    cc = cc + 1;
                end
                VLSU_VLSE16: begin
                    storedata = { {448{0}} , {temp_data[63:0]} };
                    data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                    data_out1 = { {16{storedata[31]}} , {storedata[31:16]} };
                    data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                    data_out3 = { {16{storedata[63]}} , {storedata[63:48]} };
                    cc = cc + 1;
                end
                VLSU_VLSE32: begin
                    storedata = { {384{0}} , {temp_data[127:0]} };
                    data_out0 = storedata[31:0];
                    data_out1 = storedata[63:32];
                    data_out2 = storedata[95:64];
                    data_out3 = storedata[127:96];
                    cc = cc + 1;
                end
                default: begin
                    storedata = { {384{0}} , {temp_data[127:0]} };
                    data_out0 = storedata[31:0];
                    data_out1 = storedata[63:32];
                    data_out2 = storedata[95:64];
                    data_out3 = storedata[127:96];
                    cc = cc + 1;
                end
            endcase 
        end else begin
            cc = 0;
        end
    end
    
endmodule
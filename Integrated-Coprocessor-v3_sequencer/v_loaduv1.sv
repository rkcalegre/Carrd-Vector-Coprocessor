`timescale 1ns / 1ps
`include "constants.vh"

module v_loadu(

    input logic clk,
    input logic [31:0] l_data_in0, 
    input logic [31:0] l_data_in1,
    input logic [31:0] l_data_in2,
    input logic [31:0] l_data_in3,
    input logic [3:0] v_lsu_op,
    input logic [2:0] lmul,
    input logic [2:0] vsew,
    input logic [31:0] l_addr,  
    output logic [`DATAMEM_BITS-1:0] data_addr0,
    output logic [`DATAMEM_BITS-1:0] data_addr1,
    output logic [`DATAMEM_BITS-1:0] data_addr2,
    output logic [`DATAMEM_BITS-1:0] data_addr3,
    output logic [511:0] l_data_out,
    output bit l_done

);

    import v_pkg::*;                    // contains constants

    logic [511:0] loaddata;
    //logic [4:0] elem_per_vreg = `VLEN/vsew;
    logic [2:0] num_reg;   // # of registers to be stored
    //int iter = elem_per_vreg / 4;                                                                   // ensures all of the elements in each register are stored
    //int exe_cc = (elem_per_vreg / 4) * iter * num_reg;                                              // # of clock cycles per operation
    //int cc = 0;
    int current_reg = 0;     
                                                                                    // refers to clock cycles
    assign num_reg = (lmul == 3'b000) ? 1 : (lmul == 3'b001) ? 2 : (lmul == 3'b010) ? 4 : 1;   // # of registers to be stored
    //assign iter = elem_per_vreg / 4;                                                                   // ensures all of the elements in each register are stored
    //assign exe_cc = (elem_per_vreg / 4) * iter * num_reg;                                              // # of clock cycles per operation 


    assign l_done = (current_reg > num_reg);
    assign done = (current_reg == num_reg);

    logic [127:0] temp_data;

    assign data_addr0 = (current_reg == 0)? l_addr : (current_reg == 1)? l_addr + 32'd1 : (current_reg == 2)? l_addr + 32'd2 : l_addr + 32'd3;
    assign data_addr1 = (current_reg == 0)? l_addr : (current_reg == 1)? l_addr + 32'd1 : (current_reg == 2)? l_addr + 32'd2 : l_addr + 32'd3;
    assign data_addr2 = (current_reg == 0)? l_addr : (current_reg == 1)? l_addr + 32'd1 : (current_reg == 2)? l_addr + 32'd2 : l_addr + 32'd3;
    assign data_addr3 = (current_reg == 0)? l_addr : (current_reg == 1)? l_addr + 32'd1 : (current_reg == 2)? l_addr + 32'd2 : l_addr + 32'd3;

    always @(v_lsu_op or lmul) begin
        current_reg <= 0;
    end

    always @(posedge clk) begin
        temp_data = {l_data_in3,l_data_in2, l_data_in1, l_data_in0};
/*         data_addr0 = l_addr;
        data_addr1 = l_addr;
        data_addr2 = l_addr;
        data_addr3 = l_addr; */

        if (!l_done) begin
            case (current_reg)
                0: current_reg <= current_reg + 1;
                1: begin
                    //loaddata = {{384{1'b0}},l_data_in3,l_data_in2, l_data_in1, l_data_in0};
                    loaddata <= {{384{1'b0}},temp_data};
                    current_reg <= current_reg + 1;
                    data_addr0 <= l_addr+32'd1;
                    data_addr1 <= l_addr+32'd1;
                    data_addr2 <= l_addr+32'd1;
                    data_addr3 <= l_addr+32'd1;
                end 
                2: begin
                    //loaddata[255:128] = {l_data_in3,l_data_in2, l_data_in1, l_data_in0};
                    loaddata[255:128] <= {temp_data};
                    current_reg <= current_reg + 1;
                    data_addr0 <= l_addr+32'd2;
                    data_addr1 <= l_addr+32'd2;
                    data_addr2 <= l_addr+32'd2;
                    data_addr3 <= l_addr+32'd2;
                end
                3: begin
                    //loaddata[384:256] = {l_data_in3,l_data_in2, l_data_in1, l_data_in0};
                    loaddata[384:256] = {temp_data};
                    current_reg = current_reg + 1;
                    data_addr0 = l_addr+32'd3;
                    data_addr1 = l_addr+32'd3;
                    data_addr2 = l_addr+32'd3;
                    data_addr3 = l_addr+32'd3;
                end
                4: begin
                    //loaddata[511:385] = {l_data_in3,l_data_in2, l_data_in1, l_data_in0};
                    loaddata[511:385] = {temp_data};
                    current_reg = current_reg + 1;
                    data_addr0 = l_addr+32'd4;
                    data_addr1 = l_addr+32'd4;
                    data_addr2 = l_addr+32'd4;
                    data_addr3 = l_addr+32'd4;
                end

            endcase
        end else begin
            case (v_lsu_op)
                VLSU_VLE8: begin
                    l_data_out = loaddata;    
                    end
                VLSU_VLE16: begin
                    l_data_out = loaddata;    
                end
                VLSU_VLE32: begin
                    l_data_out = loaddata;    
                end
                VLSU_VLSE8: begin
                    current_reg = current_reg + 1;
                end
                VLSU_VLSE16: begin
                    current_reg = current_reg + 1;
                end
                VLSU_VLSE32: begin
                    current_reg = current_reg + 1;
                end
            endcase 
            //done = ~done;
            current_reg = 0;
            //temp_data = 0;
            //temp_data = {l_data_in3,l_data_in2, l_data_in1, l_data_in0};
        end
    end
    
endmodule
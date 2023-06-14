`timescale 1ns / 1ps
`include "constants.vh"

module tb_datamem ();

    logic core_clk;
    logic con_clk;
    logic clk;
    logic nrst;

    logic [3:0] dm_write_0;
    logic [3:0] dm_write_1;
    logic [3:0] dm_write_2;
    logic [3:0] dm_write_3;

    logic [`DATAMEM_BITS-1:0] data_addr;
    logic [`DATAMEM_BITS-1:0] data_addr1;
    logic [`DATAMEM_BITS-1:0] data_addr2;
    logic [`DATAMEM_BITS-1:0] data_addr3;

    logic [`DATAMEM_WIDTH-1:0] data_in_0;
    logic [`DATAMEM_WIDTH-1:0] data_in_1;
    logic [`DATAMEM_WIDTH-1:0] data_in_2;
    logic [`DATAMEM_WIDTH-1:0] data_in_3;

    logic [`DATAMEM_BITS-1:0] con_addr;

    logic [`DATAMEM_WIDTH-1:0] data_out_0;
    logic [`DATAMEM_WIDTH-1:0] data_out_1;
    logic [`DATAMEM_WIDTH-1:0] data_out_2;
    logic [`DATAMEM_WIDTH-1:0] data_out_3;
    logic [`DATAMEM_WIDTH-1:0] con_out;
     
    import v_pkg::*;

    v_datamem UUT (
        .core_clk(clk),
        .con_clk(clk),
        .nrst(nrst),

        .dm_write_0(dm_write_0),
        .dm_write_1(dm_write_1),
        .dm_write_2(dm_write_2),
        .dm_write_3(dm_write_3),

        .data_addr(data_addr),
        .data_addr1(data_addr1),
        .data_addr2(data_addr2),
        .data_addr3(data_addr3),
        
        .data_in_0(data_in_0),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .data_in_3(data_in_3),

        .con_addr(con_addr),

        // Outputs
        .data_out_0(data_out_0),
        .data_out_1(data_out_1),
        .data_out_2(data_out_2),
        .data_out_3(data_out_3),
        .con_out(con_out)
    );

    initial begin
        nrst = 1;

        // clock source
        clk = 0;
        fork
            forever #20 clk = ~clk;
        join_none

        //========= Testing Writes to Datamem =========//
        // Bank 0 Write

        //#20;
        // dm_write set-up time
        dm_write_0 = 4'b1111;
        dm_write_1 = 4'b0000;
        dm_write_2 = 4'b0000;
        dm_write_3 = 4'b0000;

        data_addr = 14'd0;
        data_addr1 = 14'd0;     // should not write regardless of data address
        data_addr2 = 14'd0;
        data_addr3 = 14'd0;

        data_in_0 = 32'hf0f0f0f0;
        data_in_1 = 32'hf0f0f0f0;
        data_in_2 = 32'hf0f0f0f0;
        data_in_3 = 32'hf0f0f0f0;

        //con_addr = 14'd0;

        #40;

        data_addr = 14'd4;
        data_addr1 = 14'd0; 
        data_addr2 = 14'd0;
        data_addr3 = 14'd0;

        //con_addr = 14'd4;

        data_in_0 = 32'ha0a0a0a0;
        data_in_1 = 32'ha0a0a0a0;
        data_in_2 = 32'ha0a0a0a0;
        data_in_3 = 32'ha0a0a0a0;

        #40;

        // Bank 1 Write
        dm_write_0 = 4'b0000;
        dm_write_1 = 4'b1111;
        dm_write_2 = 4'b0000;
        dm_write_3 = 4'b0000;

        data_addr = 14'd1;
        data_addr1 = 14'd1; 
        data_addr2 = 14'd1;
        data_addr3 = 14'd1;

        data_in_0 = 32'hf0f0f0f0;
        data_in_1 = 32'hf0f0f0f0;
        data_in_2 = 32'hf0f0f0f0;
        data_in_3 = 32'hf0f0f0f0;

        //con_addr = 14'd1;

        #40;

        data_addr = 14'd5;
        data_addr1 = 14'd5; 
        data_addr2 = 14'd5;
        data_addr3 = 14'd5;

        //con_addr = 14'd5;

        data_in_0 = 32'ha0a0a0a0;
        data_in_1 = 32'ha0a0a0a0;
        data_in_2 = 32'ha0a0a0a0;
        data_in_3 = 32'ha0a0a0a0;

        #40;

        // Bank 2 Write
        dm_write_0 = 4'b0000;
        dm_write_1 = 4'b0000;
        dm_write_2 = 4'b1111;
        dm_write_3 = 4'b0000;

        data_addr = 14'd2;
        data_addr1 = 14'd2; 
        data_addr2 = 14'd2;
        data_addr3 = 14'd2;

        data_in_0 = 32'hb0b0b0b0;
        data_in_1 = 32'hb0b0b0b0;
        data_in_2 = 32'hb0b0b0b0;
        data_in_3 = 32'hb0b0b0b0;

        //con_addr = 14'd2;

        #40;

        data_addr = 14'd6;
        data_addr1 = 14'd6; 
        data_addr2 = 14'd6;
        data_addr3 = 14'd6;

        //con_addr = 14'd6;

        data_in_0 = 32'hcccccccc;
        data_in_1 = 32'hcccccccc;
        data_in_2 = 32'hcccccccc;
        data_in_3 = 32'hcccccccc;

        #40;

        // Bank 3 Write
        dm_write_0 = 4'b0000;
        dm_write_1 = 4'b0000;
        dm_write_2 = 4'b0000;
        dm_write_3 = 4'b1111;

        data_addr = 14'd3;
        data_addr1 = 14'd3; 
        data_addr2 = 14'd3;
        data_addr3 = 14'd3;

        data_in_0 = 32'hdddddddd;
        data_in_1 = 32'hdddddddd;
        data_in_2 = 32'hdddddddd;
        data_in_3 = 32'hdddddddd;

        //con_addr = 14'd3;

        #40;

        data_addr = 14'd7;
        data_addr1 = 14'd7; 
        data_addr2 = 14'd7;
        data_addr3 = 14'd7;

        //con_addr = 14'd7;

        data_in_0 = 32'heeeeeeee;
        data_in_1 = 32'heeeeeeee;
        data_in_2 = 32'heeeeeeee;
        data_in_3 = 32'heeeeeeee;

        #40;

        // Write to all banks (for Vector Coproc)
        dm_write_0 = 4'b1111;
        dm_write_1 = 4'b1111;
        dm_write_2 = 4'b1111;
        dm_write_3 = 4'b1111;

        data_addr = 14'd8;
        data_addr1 = 14'd9; 
        data_addr2 = 14'd10;
        data_addr3 = 14'd11;

        data_in_0 = 32'h11111111;
        data_in_1 = 32'h22222222;
        data_in_2 = 32'h33333333;
        data_in_3 = 32'h44444444;

        #40;

        data_addr = 14'd12;
        data_addr1 = 14'd13; 
        data_addr2 = 14'd14;
        data_addr3 = 14'd15;

        data_in_0 = 32'h55555555;
        data_in_1 = 32'h66666666;
        data_in_2 = 32'h77777777;
        data_in_3 = 32'h88888888;

        #60;

        dm_write_0 = 4'b0000;
        dm_write_1 = 4'b0000;
        dm_write_2 = 4'b0000;
        dm_write_3 = 4'b0000;

        con_addr = 14'd0;
        #80;
        con_addr = 14'd1;
        #80;
        con_addr = 14'd2;
        #80;
        con_addr = 14'd3;
        #80;
        con_addr = 14'd4;
        #80;
        con_addr = 14'd5;
        #80;
        con_addr = 14'd6;
        #80;
        con_addr = 14'd7;
        #80;
        con_addr = 14'd8;
        #80
        con_addr = 14'd9;
        #80;
        con_addr = 14'd10;
        #80;
        con_addr = 14'd11;
        #80;
        con_addr = 14'd12;
        #80;
        con_addr = 14'd13;
        #80;
        con_addr = 14'd14;
        #80;
        con_addr = 14'd15;


        #40 $finish;

        
    end

endmodule
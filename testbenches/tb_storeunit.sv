`timescale 1ns / 1ps
`include "constants.vh"

module tb_storeunit();

    logic clk;
    logic nrst;
    logic [3:0] store_op;
    logic [2:0] lmul;
    logic [2:0] vsew;
    logic [4:0] stride;
    logic [`DATAMEM_BITS-1:0] address;
    logic [511:0] data;

    logic [`DATAMEM_BITS-1:0] data_addr0;
    logic [`DATAMEM_BITS-1:0] data_addr1;
    logic [`DATAMEM_BITS-1:0] data_addr2;
    logic [`DATAMEM_BITS-1:0] data_addr3;
    logic [`DATAMEM_WIDTH-1:0] data_out0;
    logic [`DATAMEM_WIDTH-1:0] data_out1;
    logic [`DATAMEM_WIDTH-1:0] data_out2;
    logic [`DATAMEM_WIDTH-1:0] data_out3;
    logic done;

    logic [127:0] data_test_0;
    logic [127:0] data_test_1;
    logic [127:0] data_test_2;
    logic [127:0] data_test_3;
    
    import v_pkg::*;

    storeunit UUT (
        .clk(clk),
        .store_op(store_op),
        .lmul(lmul),
        .vsew(vsew),
        .stride(stride),
        .address(address),
        .data(data),

        .data_addr0(data_addr0),
        .data_addr1(data_addr1),
        .data_addr2(data_addr2),
        .data_addr3(data_addr3),
        .data_out0(data_out0),
        .data_out1(data_out1),
        .data_out2(data_out2),
        .data_out3(data_out3),
        .done(done)
    );

    // v_lsu_op
    // 1 - vle8
    // 2 - vle16
    // 3 - vle32
    // 4 - vlse8
    // 5 - vlse16
    // 6 - vlse32
    // 7 - vse8
    // 8 - vse16
    // 9 - vse32
    // 10 - vsse8
    // 11 - vsse16
    // 12 - vsse32

    initial begin

        nrst = 1;

        // clock source
        clk = 0;
        fork
            forever #20 clk = ~clk;
        join_none

        //==== Testing VSE32 instruction ====//
        store_op = 4'd12;
        lmul = 3'd0;            // lmul = 1
        vsew = 3'b010;          // vsew = 32b
        stride = 5'd2;              // unit-strided
        address = 14'd0;
        data_test_0 = {32'h33333333 , 32'h22222222 , 32'h11111111 , 32'h00000000};
        data_test_1 = {32'h77777777 , 32'h66666666 , 32'h55555555 , 32'h44444444};
        data_test_2 = {32'hbbbbbbbb , 32'haaaaaaaa , 32'h99999999 , 32'h88888888};
        data_test_3 = {32'hffffffff , 32'heeeeeeee , 32'hdddddddd , 32'hcccccccc};
        data = { data_test_3 , data_test_2 , data_test_1 , data_test_0};

        $display("TESTING VSE32, LMUL = 1");
        $strobe("data_addr0: %X", data_addr0);
        $strobe("data_addr1: %X", data_addr1);
        $strobe("data_addr2: %X", data_addr2);
        $strobe("data_addr3: %X", data_addr3);
        #30;
        $strobe("data_out0: %X", data_out0);
        $strobe("data_out1: %X", data_out1);
        $strobe("data_out2: %X", data_out2);
        $strobe("data_out3: %X", data_out3);
        
        nrst = 0;
        #20;
        nrst = 1;
        #30;
        lmul = 3'd1;
        $display("TESTING VSE32, LMUL = 2");
        $strobe("data_addr0: %X", data_addr0);
        $strobe("data_addr1: %X", data_addr1);
        $strobe("data_addr2: %X", data_addr2);
        $strobe("data_addr3: %X", data_addr3);
        #30;
        $strobe("data_out0: %X", data_out0);
        $strobe("data_out1: %X", data_out1);
        $strobe("data_out2: %X", data_out2);
        $strobe("data_out3: %X", data_out3);
        /*
        nrst = 0;
        #20;
        nrst = 1;
        #30;
        lmul = 3'd2;
        $display("TESTING VSE32, LMUL = 2");
        $strobe("data_addr0: %X", data_addr0);
        $strobe("data_addr1: %X", data_addr1);
        $strobe("data_addr2: %X", data_addr2);
        $strobe("data_addr3: %X", data_addr3);
        #30;
        $strobe("data_out0: %X", data_out0);
        $strobe("data_out1: %X", data_out1);
        $strobe("data_out2: %X", data_out2);
        $strobe("data_out3: %X", data_out3);
        */
    end


endmodule
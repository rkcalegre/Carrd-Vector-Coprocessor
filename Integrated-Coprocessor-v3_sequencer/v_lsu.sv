//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// v_storeunit.sv -- Vector Load-Store Data Unit
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 199 Carrd: RISC-V Vector Coprocessor Group (2SAY2223)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: v_lsu.sv
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
    //Vector Load Unit
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
    output bit l_done,

    //Vector Store Unit
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
    output logic done
);

    import v_pkg::*;
    
    //Vector Load Unit
    logic [511:0] loaddata;
    logic [2:0] num_reg;   // # of registers to be loaded
    int current_reg = 0;     
	logic [32:0] max_count;	
    logic [13:0] calc_addr;
	logic [31:0] l_count = 0;
	logic [511:0] temp;
	logic [511:0] hold;

    //Vector Store Unit
    logic [511:0] storedata;
    logic [4:0] elem_per_vreg;
    logic [2:0] num_reg;                    // # of registers to be stored
    logic [4:0] iter;                       // ensures all of the elements in each register are stored
    logic [4:0] exe_cc;                     // # of clock cycles per operation
    logic [4:0] cc;
    int temp_addr = address;

    assign num_reg = (lmul == 3'b000) ? 1 : (lmul == 3'b001) ? 2 : (lmul == 3'b010) ? 4 : 1;   // # of registers to be stored
    assign data_addr0 = (l_count == 0)? l_addr : (l_count == 32'd128)? l_addr + 32'd1 : (l_count == 32'd256)? l_addr + 32'd2 : l_addr + 32'd3;
    assign data_addr1 = (l_count == 0)? l_addr : (l_count == 32'd128)? l_addr + 32'd1 : (l_count == 32'd256)? l_addr + 32'd2 : l_addr + 32'd3;
    assign data_addr2 = (l_count == 0)? l_addr : (l_count == 32'd128)? l_addr + 32'd1 : (l_count == 32'd256)? l_addr + 32'd2 : l_addr + 32'd3;
    assign data_addr3 = (l_count == 0)? l_addr : (l_count == 32'd128)? l_addr + 32'd1 : (l_count == 32'd256)? l_addr + 32'd2 : l_addr + 32'd3;

	assign max_count = (lmul ==3'b000) ? 32'd128:
		(lmul ==3'b001) ? 32'd256:
		(lmul ==3'b010) ? 32'd512:
		(lmul ==3'b111) ? 32'd64:
		32'd32;


    assign elem_per_vreg = (vsew == 3'b000) ? 5'd16 : (vsew == 3'b001) ? 5'd8 : (vsew == 3'b010) ? 5'd4 : 5'd4; 
    assign num_reg = (lmul == 3'b000) ? 3'd1 : (lmul == 3'b001) ? 3'd2 : (lmul == 3'b010) ? 3'd4 : 3'd1;                                                                                // refers to clock cycles
    assign iter = (elem_per_vreg == 5'd16) ? 5'd4 : (elem_per_vreg == 5'd8) ? 5'd2 : (elem_per_vreg == 5'd4) ? 5'd1 : 5'd1;
    assign exe_cc = iter * num_reg;

    assign data_addr0 = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? 
                        (temp_addr) : (temp_addr);
    assign data_addr1 = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? 
                        (temp_addr + stride) : (temp_addr + 14'd1);
    assign data_addr2 = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? 
                        (temp_addr + stride*2) : (temp_addr + 14'd2);
    assign data_addr3 = (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32) ? 
                        (temp_addr + stride*3) : (temp_addr + 14'd3);
    assign done = (cc == exe_cc);

    logic [127:0] temp_data;
    assign temp_data = (store_op == VLSU_VSE8 || store_op == VLSU_VSSE8) ? data >> 32*cc : 
                       (store_op == VLSU_VSE16 || store_op == VLSU_VSSE16) ? data >> 64*cc : 
                       (store_op == VLSU_VSE32 || store_op == VLSU_VSSE32) ? data >> 128*cc : data >> 128*cc;

    initial begin
        //storedata <= 0;
        temp_addr <= 0;
        cc <= 1'b0;
        done <= 1'b0;
    end

    always@(posedge clk) begin
        if (!nrst) begin
            cc <= 1'b0;
            done <= 1'b0;
            //temp_addr <= 0;
        end

        if (!done) begin
            case (store_op)
                VLSU_VSE8: begin
                    storedata = { {480{1'b0}} , temp_data[31:0] };
                    data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                    data_out1 = { {24{storedata[15]}} , {storedata[15:8]} };
                    data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };
                    data_out3 = { {24{storedata[31]}} , {storedata[31:24]} };
                    cc = cc + 1'b1;
                end
                VLSU_VSE16: begin
                    storedata = { {448{1'b0}} , {temp_data[63:0]} };
                    data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                    data_out1 = { {16{storedata[31]}} , {storedata[31:16]} };
                    data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                    data_out3 = { {16{storedata[63]}} , {storedata[63:48]} };
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
                    storedata = { {480{1'b0}} , {temp_data[31:0]} };
                    data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                    data_out1 = { {24{storedata[15]}} , {storedata[15:8]} };
                    data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };
                    data_out3 = { {24{storedata[31]}} , {storedata[31:24]} };
                    cc = cc + 1'b1;
                end
                VLSU_VSSE16: begin
                    storedata = { {448{1'b0}} , {temp_data[63:0]} };
                    data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                    data_out1 = { {16{storedata[31]}} , {storedata[31:16]} };
                    data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                    data_out3 = { {16{storedata[63]}} , {storedata[63:48]} };
                    cc = cc + 1'b1;
                end
                VLSU_VSSE32: begin
                    storedata = { {384{1'b0}} , {temp_data[127:0]} };
                    data_out0 = storedata[31:0];
                    data_out1 = storedata[63:32];
                    data_out2 = storedata[95:64];
                    data_out3 = storedata[127:96];
                    cc = cc + 1'b1;
                end
                default: begin
/*                     storedata = { {384{1'b0}} , {temp_data[127:0]} };
                    data_out0 = storedata[31:0];
                    data_out1 = storedata[63:32];
                    data_out2 = storedata[95:64];
                    data_out3 = storedata[127:96];
                    cc = cc + 1; */
                    //cc=0;
                end
            endcase
            if (cc > 1) begin
                if (store_op == VLSU_VSSE8 || store_op == VLSU_VSSE16 || store_op == VLSU_VSSE32)
                    temp_addr = temp_addr + stride*4;
                else
                    temp_addr = temp_addr + 4;
            end else temp_addr = address;
        end else begin
            //temp_addr = address;
            cc = 0;
            //done = 1'b0;
            //temp_addr = address;
            //cc=0;
        end
    end

    always @(negedge done) begin
        temp_addr = address;
        cc = 0;
    end
    
endmodule
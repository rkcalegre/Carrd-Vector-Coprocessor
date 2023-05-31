`timescale 1ns / 1ps
`include "constants.vh"

module v_lsu (

    input logic [31:0] l_data_in0, 
    input logic [31:0] l_data_in1,
    input logic [31:0] l_data_in2,
    input logic [31:0] l_data_in3,
    input logic [3:0] vlsu_op,
    input logic [2:0] lmul,
    input logic [31:0] l_addr, //not used in code
    input is_load,
    input is_store, 
    output logic [1:0] write_en0, write_en1, write_en2, write_en3,
    output logic [31:0] s_data_out0, s_data_out1, s_data_out2, s_data_out3,
    output logic [511:0] l_data_out,
    output logic [511:0] s_data_in,
    output logic l_done, s_done,

    // Mga dinagdag ni Raine (pede pa magbago)
    //============================================================
    input logic [`DATAMEM_BITS-1:0] s_addr,                          // Base Address - from rs1
    output logic [`PC_ADDR_BITS-1:0] data_addr0,
    output logic [`PC_ADDR_BITS-1:0] data_addr1,
    output logic [`PC_ADDR_BITS-1:0] data_addr2,
    output logic [`PC_ADDR_BITS-1:0] data_addr3
    //============================================================

);

    import v_pkg::*;                    // contains constants
	logic [32:0] max_count;	
    logic [13:0] addr;
    logic [13:0] calc_addr;
	logic [31:0] l_count = 0;
    logic [31:0] s_count;
	logic [511:0] temp;
	logic [511:0] hold;
    logic [511:0] load_data;
    //logic [511:0] loaddata;
    logic [511:0] storedata;
    logic [31:0] data_out0;
	logic [31:0] data_out1;
	logic [31:0] data_out2;
	logic [31:0] data_out3;

    // Mga dinagdag ni Raine (pede pa magbago)
    //============================================================
    assign data_addr0 = {s_addr , 2'b00};
    assign data_addr1 = {s_addr , 2'b01};
    assign data_addr2 = {s_addr , 2'b10};
    assign data_addr3 = {s_addr , 2'b11};
    //============================================================


	assign max_count = (lmul ==3'b000) ? 32'd128:
		(lmul ==3'b001) ? 32'd256:
		(lmul ==3'b010) ? 32'd512:
		(lmul ==3'b111) ? 32'd64:
		32'd32;


	always_comb begin
        if (is_load)
        begin
            calc_addr = l_addr;
            calc_addr = calc_addr + 6'b010000;
            case (vlsu_op)
                VLSU_VLE8: 
                begin
                    temp = {{32'd480{32'd0}},l_data_in3[32'd31:32'd24],l_data_in2[32'd31:32'd24],l_data_in1[32'd31:32'd24],l_data_in0[32'd31:32'd24]};
                    load_data = (l_count==0) ? {{(temp[31:0])},{480'd0}}:{{(temp[31:0])},{hold[479:0]}};
                    hold = (l_count==max_count) ? load_data:load_data>>32;
                    l_count = l_count +32'd32;
                end
                VLSU_VLE16: 
                begin
                    temp = {{32'd448{32'd0}},l_data_in3[32'd31:32'd16],l_data_in2[32'd31:32'd16],l_data_in1[32'd31:32'd16],l_data_in0[32'd31:32'd16]};
                    load_data = (l_count==0) ? {{(temp[63:0])},{448'd0}}:{{(temp[63:0])},{hold[447:0]}};
                    hold = (l_count==max_count) ? load_data:load_data>>64;
                    l_count = l_count + 32'd64;
                end
                VLSU_VLE32: 
                begin
                    temp ={{32'd384{32'd0}},{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                    load_data = (l_count==0) ? {{(temp[127:0])},{384'd0}}:{{(temp[127:0])},{hold[383:0]}};
                    hold = (l_count==max_count) ? load_data:load_data>>128;
                    l_count = l_count + 32'd128;
                end
                VLSU_VLSE8: 
                begin
                    temp = {{32'd480{32'd0}},l_data_in3[32'd23:32'd16],l_data_in2[32'd23:32'd16],l_data_in1[32'd23:32'd16],l_data_in0[32'd23:32'd16]};
                    load_data = (l_count==0) ? {{(temp[31:0])},{480'd0}}:{{(temp[31:0])},{hold[479:0]}};
                    hold = (l_count==max_count) ? load_data:load_data>>32;
                    l_count = l_count +32'd32;
                end
                VLSU_VLSE16: 
                begin
                    temp = {{32'd448{32'd0}},l_data_in3[32'd15:32'd0],l_data_in2[32'd15:32'd0],l_data_in1[32'd15:32'd0],l_data_in0[32'd15:32'd0]};
                    load_data = (l_count==0) ? {{(temp[63:0])},{448'd0}}:{{(temp[63:0])},{hold[447:0]}};
                    hold = (l_count==max_count) ? load_data:load_data>>64;
                    l_count = l_count + 32'd64;
                end
                VLSU_VLSE32: 
                begin
                    temp ={{32'd384{32'd0}},{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                    load_data = (l_count==0) ? {{(temp[127:0])},{384'd0}}:{{(temp[127:0])},{hold[383:0]}};
                    hold = (l_count==max_count) ? load_data:load_data>>128;
                    l_count = l_count + 32'd128;
                end
            endcase
            if (l_count>=max_count)
                begin
                    l_done = 1'b1;
                    l_count = 0;
                    l_data_out = (lmul == 3'b010)? load_data: (lmul==3'b001) ? {{256{1'b0}},{load_data[511:256]}}: {{384{1'b0}},{load_data[511:384]}};
                end
	        else
	            l_done =1'b0;
            end 
        if (is_store)
        begin
            case (vlsu_op)
            VLSU_VSE8: 
            begin
                storedata = {{480{32'd0}},{s_data_in[32'd31:32'd0]}};
                data_out0 = {{24{storedata[32'd7]}},{storedata[32'd7:0]}};
                data_out1 = {{24{storedata[32'd15]}},{storedata[32'd15:32'd8]}};
                data_out2 = {{24{storedata[32'd23]}},{storedata[32'd23:32'd16]}};
                data_out3 = {{24{storedata[32'd31]}},{storedata[32'd31:32'd24]}};
                s_count = s_count + 32'd32;
            end
            VLSU_VSE16:
            begin
                storedata = {{448{32'd0}},{s_data_in[32'd63:32'd0]}};
                data_out0 = {{16{storedata[32'd15]}},{storedata[32'd15:0]}};
                data_out1 = {{16{storedata[32'd31]}},{storedata[32'd31:32'd16]}};
                data_out2 = {{16{storedata[32'd47]}},{storedata[32'd47:32'd32]}};
                data_out3 = {{16{storedata[32'd63]}},{storedata[32'd63:32'd48]}};
                s_count = s_count + 32'd64;
            end
            VLSU_VSE32:
            begin
                storedata = {{384{32'd0}},{s_data_in[32'd127:32'd0]}};
                data_out0 = {storedata[32'd31:0]};
                data_out1 = {storedata[32'd63:32'd32]};
                data_out2 = {storedata[32'd95:32'd64]};
                data_out3 = {storedata[32'd127:32'd96]};
                s_count = s_count + 32'd128;
            end
            VLSU_VSSE8:
            begin
                storedata = {{480{32'd0}},{s_data_in[32'd31:32'd0]}};
                data_out0 = {{24{storedata[32'd7]}},{storedata[32'd7:0]}};
                data_out1 = {{24{storedata[32'd15]}},{storedata[32'd15:32'd8]}};
                data_out2 = {{24{storedata[32'd23]}},{storedata[32'd23:32'd16]}};
                data_out3 = {{24{storedata[32'd31]}},{storedata[32'd31:32'd24]}};
                s_count = s_count + 32'd32;
            end
            VLSU_VSSE16:
            begin
                storedata = {{480{32'd0}},{s_data_in[32'd31:32'd0]}};
                data_out0 = {{24{storedata[32'd7]}},{storedata[32'd7:0]}};
                data_out1 = {{24{storedata[32'd15]}},{storedata[32'd15:32'd8]}};
                data_out2 = {{24{storedata[32'd23]}},{storedata[32'd23:32'd16]}};
                data_out3 = {{24{storedata[32'd31]}},{storedata[32'd31:32'd24]}};
                s_count = s_count + 32'd64;
            end
            VLSU_VSSE32:
            begin
                storedata = {{480{32'd0}},{s_data_in[32'd31:32'd0]}};
                data_out0 = {{24{storedata[32'd7]}},{storedata[32'd7:0]}};
                data_out1 = {{24{storedata[32'd15]}},{storedata[32'd15:32'd8]}};
                data_out2 = {{24{storedata[32'd23]}},{storedata[32'd23:32'd16]}};
                data_out3 = {{24{storedata[32'd31]}},{storedata[32'd31:32'd24]}};
                s_count = s_count + 32'd128;
            end
            endcase

        case (s_addr[3:2])
        2'b0:
        begin
            s_data_out0 = data_out0;
            s_data_out1 = data_out1;
            s_data_out2 = data_out2;
            s_data_out3 = data_out3;
            data_addr0 = calc_addr>>2;
            data_addr1 = calc_addr>>2;
            data_addr2 = calc_addr>>2;
            data_addr3 = calc_addr>>2;
            write_en0 = 1'b1;
            write_en1 = 1'b1;
            write_en2 = 1'b1;
            write_en3 = 1'b1;
        end
        2'b01:
        begin
            s_data_out0 = data_out3;
            s_data_out1 = data_out0;
            s_data_out2 = data_out1;
            s_data_out3 = data_out2;
            data_addr0 = (calc_addr>>2) +  4'b0100;
            data_addr1 = calc_addr>>2;
            data_addr2 = calc_addr>>2;
            data_addr3 = calc_addr>>2;
            write_en0 = 1'b1;
            write_en1 = 1'b1;
            write_en2 = 1'b1;
            write_en3 = 1'b1;
        end
        2'b10:
        begin
            s_data_out0 = data_out2;
            s_data_out1 = data_out3;
            s_data_out2 = data_out0;
            s_data_out3 = data_out1;
            data_addr0 = (calc_addr>>2) +  4'b0100;
            data_addr1 = (calc_addr>>2) +  4'b0100;
            data_addr2 = calc_addr>>2;
            data_addr3 = calc_addr>>2;
            write_en0 = 1'b1;
            write_en1 = 1'b1;
            write_en2 = 1'b1;
            write_en3 = 1'b1;
        end
        2'b11:
         begin
            s_data_out0 = data_out1;
            s_data_out1 = data_out2;
            s_data_out2 = data_out3;
            s_data_out3 = data_out0;
            data_addr0 = (calc_addr>>2) +  4'b0100;
            data_addr1 = (calc_addr>>2) +  4'b0100;
            data_addr2 = (calc_addr>>2) +  4'b0100;
            data_addr3 = calc_addr>>2;
            write_en0 = 1'b1;
            write_en1 = 1'b1;
            write_en2 = 1'b1;
            write_en3 = 1'b1;
        end
        endcase
        if (s_count>=max_count)
        begin
            s_done = 1'b1;
            s_count = 32'b0;
            calc_addr = addr;
        end
        else 
        begin 
			calc_addr = calc_addr + 6'b010000;
			s_done = 1'b0;
        end
    end
	end
    
endmodule
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// v_storeunit.sv -- Vector Load Store Data Unit
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

module v_lsu #(
    parameter int VLEN = 128
)(
    //Load Unit
    input logic clk,
    input logic nrst,
    input logic [31:0] l_data_in0, 
    input logic [31:0] l_data_in1,
    input logic [31:0] l_data_in2,
    input logic [31:0] l_data_in3,
    input logic [3:0] v_lsu_op,
    input logic [2:0] lmul,
    input logic [2:0] vsew,
    input logic [5:0] stride,
    input logic [`DATAMEM_BITS-1:0] address,
    output logic [511:0] l_data_out,
    output bit l_done,

    //Store Unit
    input logic [511:0] s_data,

    // Each Data Address triggers the write enable of their respective memory bank
    output logic [`DATAMEM_BITS-1:0] data_addr0,
    output logic [`DATAMEM_BITS-1:0] data_addr1,
    output logic [`DATAMEM_BITS-1:0] data_addr2,
    output logic [`DATAMEM_BITS-1:0] data_addr3,
    output logic [`DATAMEM_WIDTH-1:0] data_out0,
    output logic [`DATAMEM_WIDTH-1:0] data_out1,
    output logic [`DATAMEM_WIDTH-1:0] data_out2,
    output logic [`DATAMEM_WIDTH-1:0] data_out3,
    output logic dm_v_write,
    output logic s_done
);

    import v_pkg::*;

    logic [511:0] storedata;
    logic [4:0] elem_per_vreg;
    logic [2:0] num_reg;                    // # of registers to be stored
    logic [4:0] iter;                       // ensures all of the elements in each register are stored
    logic [4:0] exe_cc;                     // # of clock cycles per operation
    logic [4:0] s_cc;
    int temp_addr;
    logic [`DATAMEM_BITS-1:0] strided_temp_addr[0:3];
    logic [6:0] strided_cc;

    assign elem_per_vreg = (vsew == 3'b000) ? 5'd16 : (vsew == 3'b001) ? 5'd8 : (vsew == 3'b010) ? 5'd4 : 5'd4; 
    assign num_reg = (lmul == 3'b000) ? 3'd1 : (lmul == 3'b001) ? 3'd2 : (lmul == 3'b010) ? 3'd4 : 3'd1;                                                                                // refers to clock cycles
    assign iter = (elem_per_vreg == 5'd16) ? 5'd4 : (elem_per_vreg == 5'd8) ? 5'd2 : (elem_per_vreg == 5'd4) ? 5'd1 : 5'd1;
    //assign exe_cc = (elem_per_vreg / 4) * iter * num_reg;
    assign exe_cc = num_reg;
    assign s_done = (s_cc == exe_cc+1);
    assign dm_v_write = ((s_cc > 0 && v_lsu_op inside {[7:12]}) || (s_cc == 0 && !clk && v_lsu_op inside {[7:12]}));
    //assign dm_v_write = ((s_cc > 0 && v_lsu_op inside {[7:12]}));

    logic [127:0] temp_data;
    /* assign temp_data = (v_lsu_op == VLSU_VSE8 || v_lsu_op == VLSU_VSSE8) ? s_data >> 32*s_cc : 
                       (v_lsu_op == VLSU_VSE16 || v_lsu_op == VLSU_VSSE16) ? s_data >> 64*s_cc : 
                       (v_lsu_op == VLSU_VSE32 || v_lsu_op == VLSU_VSSE32) ? s_data >> 128*s_cc : s_data >> 128*s_cc; */
    assign temp_data = (!s_done && s_cc != exe_cc) ? ((v_lsu_op == VLSU_VSSE8) ? ((stride == 2) ? s_data >> 16*s_cc : (stride == 4) ? s_data >> 8*s_cc : s_data >> 32*s_cc) : 
                       (v_lsu_op == VLSU_VSSE16) ? ((stride == 2) ? s_data >> 32*s_cc : (stride == 4) ? s_data >> 16*s_cc : s_data >> 64*s_cc) : 
                       (v_lsu_op == VLSU_VSSE32) ? ((stride == 2) ? s_data >> 64*s_cc : (stride == 4) ? s_data >> 32*s_cc : s_data >> 128*s_cc) :
                       (v_lsu_op == VLSU_VSE8 || v_lsu_op == VLSU_VSE16 || v_lsu_op == VLSU_VSE32) ? s_data >> 128*s_cc : s_data >> 128*s_cc) : temp_data;

    logic [511:0] loaddata;
	logic [2:0] max_reg;	
	logic [2:0] l_cc = 0;
	logic [127:0] temp;
	logic [511:0] hold;
    logic [5:0] l_stride_cc = 0;
    logic is_vltype;

	assign max_reg = (lmul == 3'b000) ? 3'd1 : (lmul == 3'b001) ? 3'd2 : (lmul == 3'b010) ? 3'd4 : 3'd1;  

    assign is_vltype = (v_lsu_op inside {[1:6]});

/*     assign data_addr0 = (l_cc == 0 && is_vltype)? {address,2'b0} : (l_cc == 3'd1 && is_vltype)? {address + 32'd1, 2'b0} : (l_cc == 3'd2 && is_vltype)? {address + 32'd2, 2'b0} : (l_cc == 3'd3 && is_vltype)? {address + 32'd3, 2'b0} : (v_lsu_op == VLSU_VSSE8 || v_lsu_op == VLSU_VSSE16 || v_lsu_op == VLSU_VSSE32) ? 
                        (temp_addr) : (temp_addr);
    assign data_addr1 = (l_cc == 0 && is_vltype)? {address,2'b0} : (l_cc == 3'd1 && is_vltype)? {address + 32'd1, 2'b0} : (l_cc == 3'd2 && is_vltype)? {address + 32'd2, 2'b0} : (l_cc == 3'd3 && is_vltype)? {address + 32'd3, 2'b0} : (v_lsu_op == VLSU_VSSE8 || v_lsu_op == VLSU_VSSE16 || v_lsu_op == VLSU_VSSE32) ? 
                        (temp_addr + stride) : (temp_addr + 14'd1);
    assign data_addr2 = (l_cc == 0 && is_vltype)? {address,2'b0} : (l_cc == 3'd1 && is_vltype)? {address + 32'd1, 2'b0} : (l_cc == 3'd2 && is_vltype)? {address + 32'd2, 2'b0} : (l_cc == 3'd3 && is_vltype)? {address + 32'd3, 2'b0} : (v_lsu_op == VLSU_VSSE8 || v_lsu_op == VLSU_VSSE16 || v_lsu_op == VLSU_VSSE32) ? 
                        (temp_addr + stride*2) : (temp_addr + 14'd2);
    assign data_addr3 = (l_cc == 0 && is_vltype)? {address,2'b0} : (l_cc == 3'd1 && is_vltype)? {address + 32'd1, 2'b0} : (l_cc == 3'd2 && is_vltype)? {address + 32'd2, 2'b0} : (l_cc == 3'd3 && is_vltype)? {address + 32'd3, 2'b0} : (v_lsu_op == VLSU_VSSE8 || v_lsu_op == VLSU_VSSE16 || v_lsu_op == VLSU_VSSE32) ? 
                        (temp_addr + stride*3) : (temp_addr + 14'd3); */


    initial begin
        //storedata <= 0;
        temp_addr <= 0;
        s_cc <= 1'b0;
        dm_v_write <= 1'b0;
        s_done <= 1'b0;
    end

    always@(posedge clk) begin
        if (!nrst) begin
            s_cc <= 1'b0;
            dm_v_write <= 1'b0;
            s_done <= 1'b0;
            //temp_addr <= 0;
        end

/*         if (!s_done) begin
            case (v_lsu_op)
                VLSU_VSE8: begin
                    storedata = { {384{1'b0}} , {temp_data[127:0]} };
                    data_out0 = storedata[31:0];
                    data_out1 = storedata[63:32];
                    data_out2 = storedata[95:64];
                    data_out3 = storedata[127:96];
                    s_cc = s_cc + 1'b1;
                end
                VLSU_VSE16: begin
                    storedata = { {384{1'b0}} , {temp_data[127:0]} };
                    data_out0 = storedata[31:0];
                    data_out1 = storedata[63:32];
                    data_out2 = storedata[95:64];
                    data_out3 = storedata[127:96];
                    s_cc = s_cc + 1'b1;
                end
                VLSU_VSE32: begin
                    storedata = { {384{1'b0}} , {temp_data[127:0]} };
                    data_out0 = storedata[31:0];
                    data_out1 = storedata[63:32];
                    data_out2 = storedata[95:64];
                    data_out3 = storedata[127:96];
                    s_cc = s_cc + 1'b1;
                end
                VLSU_VSSE8: begin
                    storedata = { {480{1'b0}} , {temp_data[31:0]} };
                    data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                    data_out1 = { {24{storedata[15]}} , {storedata[15:8]} };
                    data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };
                    data_out3 = { {24{storedata[31]}} , {storedata[31:24]} };
                    s_cc = s_cc + 1'b1;
                end
                VLSU_VSSE16: begin
                    storedata = { {448{1'b0}} , {temp_data[63:0]} };
                    data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                    data_out1 = { {16{storedata[31]}} , {storedata[31:16]} };
                    data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                    data_out3 = { {16{storedata[63]}} , {storedata[63:48]} };
                    s_cc = s_cc + 1'b1;
                end
                VLSU_VSSE32: begin
                    storedata = { {384{1'b0}} , {temp_data[127:0]} };
                    data_out0 = storedata[31:0];
                    data_out1 = storedata[63:32];
                    data_out2 = storedata[95:64];
                    data_out3 = storedata[127:96];
                    s_cc = s_cc + 1'b1;
                end
                default: begin
                    //s_cc=0;
                end
            endcase
            if (s_cc > 1) begin
                if (v_lsu_op == VLSU_VSSE8 || v_lsu_op == VLSU_VSSE16 || v_lsu_op == VLSU_VSSE32)
                    temp_addr = temp_addr + stride*4;
                else
                    temp_addr = temp_addr + 4;
            end else temp_addr = address;
        end else begin
            //temp_addr = address;
            s_cc = 0;
            //s_done = 1'b0;
            //temp_addr = address;
            //s_cc=0;
        end */
    end

        always@(negedge clk) begin
            case (v_lsu_op)
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
        if (v_lsu_op inside {[7:12]}) begin             
            temp_addr = (s_cc == 0 || s_done) ? address : temp_addr + 4;
            data_addr0 = (!s_done && s_cc != exe_cc) ? temp_addr : data_addr0;
            data_addr1 = (!s_done && s_cc != exe_cc) ? temp_addr + 1 : data_addr1;
            data_addr2 = (!s_done && s_cc != exe_cc) ? temp_addr + 2 : data_addr2;
            data_addr3 = (!s_done && s_cc != exe_cc) ? temp_addr + 3 : data_addr3;
        end else begin
            data_addr0 = (l_cc == 0 && is_vltype)? {address,2'b0} : (l_cc == 3'd1 && is_vltype)? {address + 32'd1, 2'b0} : (l_cc == 3'd2 && is_vltype)? {address + 32'd2, 2'b0} : (l_cc == 3'd3 && is_vltype)? {address + 32'd3, 2'b0} : {address,2'b0}; 
            data_addr1 = (l_cc == 0 && is_vltype)? {address,2'b0} : (l_cc == 3'd1 && is_vltype)? {address + 32'd1, 2'b0} : (l_cc == 3'd2 && is_vltype)? {address + 32'd2, 2'b0} : (l_cc == 3'd3 && is_vltype)? {address + 32'd3, 2'b0} : {address,2'b0}; 
            data_addr2 = (l_cc == 0 && is_vltype)? {address,2'b0} : (l_cc == 3'd1 && is_vltype)? {address + 32'd1, 2'b0} : (l_cc == 3'd2 && is_vltype)? {address + 32'd2, 2'b0} : (l_cc == 3'd3 && is_vltype)? {address + 32'd3, 2'b0} : {address,2'b0};
            data_addr3 = (l_cc == 0 && is_vltype)? {address,2'b0} : (l_cc == 3'd1 && is_vltype)? {address + 32'd1, 2'b0} : (l_cc == 3'd2 && is_vltype)? {address + 32'd2, 2'b0} : (l_cc == 3'd3 && is_vltype)? {address + 32'd3, 2'b0} : {address,2'b0}; 
        end
    end

    always @(posedge clk) begin
        if (!s_done && v_lsu_op inside {[7:12]}) begin
            s_cc = s_cc + 1'b1;                 // counter that keeps track of execution time
        end else begin
            s_cc = 0;                         // reset counter when done     
        end

        if (v_lsu_op == 0) s_cc = 0;
    end

    always @(posedge s_done) begin
        //temp_addr = address;
        dm_v_write = 0;
    end

    always @(posedge clk) begin
        //temp_data = {l_data_in3,l_data_in2, l_data_in1, l_data_in0};
        if (v_lsu_op inside {[1:6]}) begin
            case (v_lsu_op)
                VLSU_VLE8: begin
                    temp ={{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                    loaddata = (l_cc==0) ? {{temp},{384'd0}}:{{temp},{hold[383:0]}};
                    hold = (l_cc==max_reg) ? loaddata:loaddata>>128;
                    l_cc = l_cc + 3'd1;
                end
                VLSU_VLE16: begin
                    temp ={{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                    loaddata = (l_cc==0) ? {{temp},{384'd0}}:{{temp},{hold[383:0]}};
                    hold = (l_cc==max_reg) ? loaddata:loaddata>>128;
                    l_cc = l_cc + 3'd1;
                end
                VLSU_VLE32: begin
                    temp ={{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                    loaddata = (l_cc==0) ? {{temp},{384'd0}}:{{temp},{hold[383:0]}};
                    hold = (l_cc==max_reg) ? loaddata:loaddata>>128;
                    l_cc = l_cc + 3'd1;
                end
                VLSU_VLSE8: begin

                    if (l_cc==max_reg) begin

                        hold = (lmul == 3'b010)? loaddata: (lmul==3'b001) ? {{256{1'b0}},{loaddata[511:256]}}: {{384{1'b0}},{loaddata[511:384]}};

                        case (stride)
                            6'd0: loaddata = hold;
                            6'd1: loaddata = hold;
                            6'd2: loaddata = {256'd0, hold[503:496],hold[487:480],hold[471:464],hold[455:448],hold[439:432],hold[423:416],hold[407:400],hold[391:384],hold[375:368],hold[359:352],hold[343:336],hold[327:320],hold[311:304],hold[295:288],hold[279:272],hold[263:256],hold[247:240],hold[231:224],hold[215:208],hold[199:192],hold[183:176],hold[167:160],hold[151:144],hold[135:128],hold[119:112],hold[103:96],hold[87:80],hold[71:64],hold[55:48],hold[39:32],hold[23:16],hold[7:0]};
                            6'd3: loaddata = {336'd0, hold[511:504],hold[487:480],hold[463:456],hold[439:432],hold[415:408],hold[391:384],hold[367:360],hold[343:336],hold[319:312],hold[295:288],hold[271:264],hold[247:240],hold[223:216],hold[199:192],hold[175:168],hold[151:144],hold[127:120],hold[103:96],hold[79:72],hold[55:48],hold[31:24],hold[7:0]};
                            6'd4: loaddata = {384'd0, hold[487:480],hold[455:448],hold[423:416],hold[391:384],hold[359:352],hold[327:320],hold[295:288],hold[263:256],hold[231:224],hold[199:192],hold[167:160],hold[135:128],hold[103:96],hold[71:64],hold[39:32],hold[7:0]};
                            6'd5: loaddata = {408'd0, hold[487:480],hold[447:440],hold[407:400],hold[367:360],hold[327:320],hold[287:280],hold[247:240],hold[207:200],hold[167:160],hold[127:120],hold[87:80],hold[47:40],hold[7:0]};
                            6'd6: loaddata = {424'd0, hold[487:480],hold[439:432],hold[391:384],hold[343:336],hold[295:288],hold[247:240],hold[199:192],hold[151:144],hold[103:96],hold[55:48],hold[7:0]};
                            6'd7: loaddata = {432'd0, hold[511:504],hold[455:448],hold[399:392],hold[343:336],hold[287:280],hold[231:224],hold[175:168],hold[119:112],hold[63:56],hold[7:0]};
                            6'd8: loaddata = {448'd0, hold[455:448],hold[391:384],hold[327:320],hold[263:256],hold[199:192],hold[135:128],hold[71:64],hold[7:0]};
                            6'd9: loaddata = {448'd0, hold[511:504],hold[439:432],hold[367:360],hold[295:288],hold[223:216],hold[151:144],hold[79:72],hold[7:0]};
                            6'd10: loaddata = {456'd0, hold[487:480],hold[407:400],hold[327:320],hold[247:240],hold[167:160],hold[87:80],hold[7:0]};
                            6'd11: loaddata = {464'd0, hold[447:440],hold[359:352],hold[271:264],hold[183:176],hold[95:88],hold[7:0]};
                            6'd12: loaddata = {464'd0, hold[487:480],hold[391:384],hold[295:288],hold[199:192],hold[103:96],hold[7:0]};
                            6'd13: loaddata = {472'd0, hold[423:416],hold[319:312],hold[215:208],hold[111:104],hold[7:0]};
                            6'd14: loaddata = {472'd0, hold[455:448],hold[343:336],hold[231:224],hold[119:112],hold[7:0]};
                            6'd15: loaddata = {472'd0, hold[487:480],hold[367:360],hold[247:240],hold[127:120],hold[7:0]};
                            6'd16: loaddata = {480'd0, hold[391:384],hold[263:256],hold[135:128],hold[7:0]};
                            6'd17: loaddata = {480'd0, hold[415:408],hold[279:272],hold[143:136],hold[7:0]};
                            6'd18: loaddata = {480'd0, hold[439:432],hold[295:288],hold[151:144],hold[7:0]};
                            6'd19: loaddata = {480'd0, hold[463:456],hold[311:304],hold[159:152],hold[7:0]};
                            6'd20: loaddata = {480'd0, hold[487:480],hold[327:320],hold[167:160],hold[7:0]};
                            6'd21: loaddata = {480'd0, hold[511:504],hold[343:336],hold[175:168],hold[7:0]};
                            6'd22: loaddata = {488'd0, hold[359:352],hold[183:176],hold[7:0]};
                            6'd23: loaddata = {488'd0, hold[375:368],hold[191:184],hold[7:0]};
                            6'd24: loaddata = {488'd0, hold[391:384],hold[199:192],hold[7:0]};
                            6'd25: loaddata = {488'd0, hold[407:400],hold[207:200],hold[7:0]};
                            6'd26: loaddata = {488'd0, hold[423:416],hold[215:208],hold[7:0]};
                            6'd27: loaddata = {488'd0, hold[439:432],hold[223:216],hold[7:0]};
                            6'd28: loaddata = {488'd0, hold[455:448],hold[231:224],hold[7:0]};
                            6'd29: loaddata = {488'd0, hold[471:464],hold[239:232],hold[7:0]};
                            6'd30: loaddata = {488'd0, hold[487:480],hold[247:240],hold[7:0]};
                            6'd31: loaddata = {488'd0, hold[503:496],hold[255:248],hold[7:0]};
                            6'd32: loaddata = {496'd0, hold[263:256],hold[7:0]};
                            6'd33: loaddata = {496'd0, hold[271:264],hold[7:0]};
                            6'd34: loaddata = {496'd0, hold[279:272],hold[7:0]};
                            6'd35: loaddata = {496'd0, hold[287:280],hold[7:0]};
                            6'd36: loaddata = {496'd0, hold[295:288],hold[7:0]};
                            6'd37: loaddata = {496'd0, hold[303:296],hold[7:0]};
                            6'd38: loaddata = {496'd0, hold[311:304],hold[7:0]};
                            6'd39: loaddata = {496'd0, hold[319:312],hold[7:0]};
                            6'd40: loaddata = {496'd0, hold[327:320],hold[7:0]};
                            6'd41: loaddata = {496'd0, hold[335:328],hold[7:0]};
                            6'd42: loaddata = {496'd0, hold[343:336],hold[7:0]};
                            6'd43: loaddata = {496'd0, hold[351:344],hold[7:0]};
                            6'd44: loaddata = {496'd0, hold[359:352],hold[7:0]};
                            6'd45: loaddata = {496'd0, hold[367:360],hold[7:0]};
                            6'd46: loaddata = {496'd0, hold[375:368],hold[7:0]};
                            6'd47: loaddata = {496'd0, hold[383:376],hold[7:0]};
                            6'd48: loaddata = {496'd0, hold[391:384],hold[7:0]};
                            6'd49: loaddata = {496'd0, hold[399:392],hold[7:0]};
                            6'd50: loaddata = {496'd0, hold[407:400],hold[7:0]};
                            6'd51: loaddata = {496'd0, hold[415:408],hold[7:0]};
                            6'd52: loaddata = {496'd0, hold[423:416],hold[7:0]};
                            6'd53: loaddata = {496'd0, hold[431:424],hold[7:0]};
                            6'd54: loaddata = {496'd0, hold[439:432],hold[7:0]};
                            6'd55: loaddata = {496'd0, hold[447:440],hold[7:0]};
                            6'd56: loaddata = {496'd0, hold[455:448],hold[7:0]};
                            6'd57: loaddata = {496'd0, hold[463:456],hold[7:0]};
                            6'd58: loaddata = {496'd0, hold[471:464],hold[7:0]};
                            6'd59: loaddata = {496'd0, hold[479:472],hold[7:0]};
                            6'd60: loaddata = {496'd0, hold[487:480],hold[7:0]};
                            6'd61: loaddata = {496'd0, hold[495:488],hold[7:0]};
                            6'd62: loaddata = {496'd0, hold[503:496],hold[7:0]};
                            6'd63: loaddata = {496'd0, hold[511:504],hold[7:0]};
                            default: loaddata = {504'd0, hold[7:0]};
                        endcase
                    end else begin
                        temp ={{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        loaddata = (l_cc==0) ? {{temp},{384'd0}}:{{temp},{hold[383:0]}};
                        hold = (l_cc==max_reg) ? loaddata:loaddata>>128;                        
                    end
                    l_cc = l_cc + 3'd1;  

                end
                VLSU_VLSE16: begin

                    if (l_cc==max_reg) begin

                        hold = (lmul == 3'b010)? loaddata: (lmul==3'b001) ? {{256{1'b0}},{loaddata[511:256]}}: {{384{1'b0}},{loaddata[511:384]}};

                        case (stride)
                            6'd0: loaddata = hold;
                            6'd1: loaddata = hold;
                            6'd2: loaddata = {256'd0, hold[495:480],hold[463:448],hold[431:416],hold[399:384],hold[367:352],hold[335:320],hold[303:288],hold[271:256],hold[239:224],hold[207:192],hold[175:160],hold[143:128],hold[111:96],hold[79:64],hold[47:32],hold[15:0]};
                            6'd3: loaddata = {336'd0, hold[495:480],hold[447:432],hold[399:384],hold[351:336],hold[303:288],hold[255:240],hold[207:192],hold[159:144],hold[111:96],hold[63:48],hold[15:0]};
                            6'd4: loaddata = {384'd0, hold[463:448],hold[399:384],hold[335:320],hold[271:256],hold[207:192],hold[143:128],hold[79:64],hold[15:0]};
                            6'd5: loaddata = {400'd0, hold[495:480],hold[415:400],hold[335:320],hold[255:240],hold[175:160],hold[95:80],hold[15:0]};
                            6'd6: loaddata = {416'd0, hold[495:480],hold[399:384],hold[303:288],hold[207:192],hold[111:96],hold[15:0]};
                            6'd7: loaddata = {432'd0, hold[463:448],hold[351:336],hold[239:224],hold[127:112],hold[15:0]};
                            6'd8: loaddata = {448'd0, hold[399:384],hold[271:256],hold[143:128],hold[15:0]};
                            6'd9: loaddata = {448'd0, hold[447:432],hold[303:288],hold[159:144],hold[15:0]};
                            6'd10: loaddata = {448'd0, hold[495:480],hold[335:320],hold[175:160],hold[15:0]};
                            6'd11: loaddata = {464'd0, hold[367:352],hold[191:176],hold[15:0]};
                            6'd12: loaddata = {464'd0, hold[399:384],hold[207:192],hold[15:0]};
                            6'd13: loaddata = {464'd0, hold[431:416],hold[223:208],hold[15:0]};
                            6'd14: loaddata = {464'd0, hold[463:448],hold[239:224],hold[15:0]};
                            6'd15: loaddata = {464'd0, hold[495:480],hold[255:240],hold[15:0]};
                            6'd16: loaddata = {480'd0, hold[271:256],hold[15:0]};
                            6'd17: loaddata = {480'd0, hold[287:272],hold[15:0]};
                            6'd18: loaddata = {480'd0, hold[303:288],hold[15:0]};
                            6'd19: loaddata = {480'd0, hold[319:304],hold[15:0]};
                            6'd20: loaddata = {480'd0, hold[335:320],hold[15:0]};
                            6'd21: loaddata = {480'd0, hold[351:336],hold[15:0]};
                            6'd22: loaddata = {480'd0, hold[367:352],hold[15:0]};
                            6'd23: loaddata = {480'd0, hold[383:368],hold[15:0]};
                            6'd24: loaddata = {480'd0, hold[399:384],hold[15:0]};
                            6'd25: loaddata = {480'd0, hold[415:400],hold[15:0]};
                            6'd26: loaddata = {480'd0, hold[431:416],hold[15:0]};
                            6'd27: loaddata = {480'd0, hold[447:432],hold[15:0]};
                            6'd28: loaddata = {480'd0, hold[463:448],hold[15:0]};
                            6'd29: loaddata = {480'd0, hold[479:464],hold[15:0]};
                            6'd30: loaddata = {480'd0, hold[495:480],hold[15:0]};
                            6'd31: loaddata = {480'd0, hold[511:496],hold[15:0]};
                            default: loaddata = {496'd0, hold[15:0]};
                        endcase
                    end else begin
                        temp ={{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        loaddata = (l_cc==0) ? {{temp},{384'd0}}:{{temp},{hold[383:0]}};
                        hold = (l_cc==max_reg) ? loaddata:loaddata>>128;                        
                    end
                    l_cc = l_cc + 3'd1;  
              
                end
                VLSU_VLSE32: begin

                    if (l_cc==max_reg) begin

                        hold = (lmul == 3'b010)? loaddata: (lmul==3'b001) ? {{256{1'b0}},{loaddata[511:256]}}: {{384{1'b0}},{loaddata[511:384]}};
                        if (l_stride_cc == stride) begin
                            
                        end else begin
                            case (stride)
                                6'd0: loaddata = hold;
                                6'd1: loaddata = hold;
                                6'd2: loaddata = {256'd0, hold[479:448],hold[415:384],hold[351:320],hold[287:256],hold[223:192],hold[159:128],hold[95:64],hold[31:0]};
                                6'd3: loaddata = {320'd0, hold[511:480],hold[415:384],hold[319:288],hold[223:192],hold[127:96],hold[31:0]};
                                6'd4: loaddata = {384'd0, hold[415:384],hold[287:256],hold[159:128],hold[31:0]};
                                6'd5: loaddata = {384'd0, hold[511:480],hold[351:320],hold[191:160],hold[31:0]};
                                6'd6: loaddata = {416'd0, hold[415:384],hold[223:192],hold[31:0]};
                                6'd7: loaddata = {416'd0, hold[479:448],hold[255:224],hold[31:0]};
                                6'd8: loaddata = {448'd0, hold[287:256],hold[31:0]};
                                6'd9: loaddata = {448'd0, hold[319:288],hold[31:0]};
                                6'd10: loaddata = {448'd0, hold[351:320],hold[31:0]};
                                6'd11: loaddata = {448'd0, hold[383:352],hold[31:0]};
                                6'd12: loaddata = {448'd0, hold[415:384],hold[31:0]};
                                6'd13: loaddata = {448'd0, hold[447:416],hold[31:0]};
                                6'd14: loaddata = {448'd0, hold[479:448],hold[31:0]};
                                6'd15: loaddata = {448'd0, hold[511:480],hold[31:0]};
                                default: loaddata = {480'd0, hold[31:0]};
                            endcase

                            l_stride_cc = l_stride_cc + 1;
                        end
                    end else begin
                        temp ={{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        loaddata = (l_cc==0) ? {{temp},{384'd0}}:{{temp},{hold[383:0]}};
                        hold = (l_cc==max_reg) ? loaddata:loaddata>>128;                        
                        l_cc = l_cc + 3'd1;   
                    end

                end 
            endcase 
            if (l_cc>=max_reg && (v_lsu_op inside {[1:3]}) ) begin
                    l_done = 1'b1;
                    l_cc = 0;
                    l_data_out = (lmul == 3'b010)? loaddata: (lmul==3'b001) ? {{256{1'b0}},{loaddata[511:256]}}: {{384{1'b0}},{loaddata[511:384]}};
                end
            else if (l_cc>max_reg && (v_lsu_op inside {[4:6]}) ) begin
                    l_done = 1'b1;
                    l_cc = 0;
                    l_stride_cc = 0;
                    l_data_out = loaddata;
                end
            else l_done =1'b0;
        end else l_done =1'b0;
    end

/*     always @(negedge s_done) begin
        temp_addr = address;
        s_cc = 0;
    end */

    always @(posedge s_done) begin
        //temp_addr = address;
        dm_v_write = 0;
    end
    
endmodule

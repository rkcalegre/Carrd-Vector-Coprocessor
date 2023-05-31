`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2023 04:56:59
// Design Name: 
// Module Name: tb_writeback
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_writeback();
    import v_pkg::*;

	logic clk;
    logic [3:0] v_alu_op;
    logic is_mul;
    logic [3:0] v_lsu_op;
    logic [2:0] v_sldu_op;
    logic [2:0] v_red_op;
    logic done_vlanes;
    logic done_vred;
    logic [1:0] v_sel_dest;
    logic reg_wr_en;
    logic x_reg_wr_en;

    carrd_writeback vwriteback(
        .clk(clk),
        .v_alu_op(v_alu_op),
        .is_mul(is_mul),
        .v_lsu_op(v_lsu_op), 
        .v_sldu_op(v_sldu_op),
        .v_red_op(v_red_op),
        .done_vlanes(done_vlanes),
        .done_vred(done_vred),        
        .v_sel_dest(v_sel_dest), 
        .v_reg_wr_en(reg_wr_en),
        .x_reg_wr_en(x_reg_wr_en)
    );

	initial begin
        // clock source
        clk = 0;
        fork
            forever #20 clk = ~clk;
        join_none  

        #20;
        //TESTING SLDU
        v_sldu_op = 0;
        v_sel_dest= 0;
        #40;
        v_sldu_op = 0;
        v_sel_dest= 1;
        #40;
        v_sldu_op = 1;
        #40;

        #10;	
		$finish;
    end

endmodule


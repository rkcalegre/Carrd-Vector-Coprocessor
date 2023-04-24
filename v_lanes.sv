`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2023 17:32:38
// Design Name: 
// Module Name: v_lanes
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


module v_lanes(
    input logic clk,
    input logic nrst,
    input logic [5:0] op_instr_alu,
    input logic [5:0] op_instr_mul,
    input logic [2:0] vsew,
    output logic [31:0] result_valu,
    output logic [31:0] result_vmul,

	input logic [127:0] op_A_1,
	input logic [127:0] op_A_2,
	input logic [127:0] op_A_3,
	input logic [127:0] op_A_4,

    input logic [127:0] op_B_1,
	input logic [127:0] op_B_2,
	input logic [127:0] op_B_3,
	input logic [127:0] op_B_4

    );

    logic [31:0] op_A;
    logic [31:0] op_B;

    //ALU

    v_alu valu(
        .clk(clk),
        .nrst(nrst),
        .op_instr(op_instr),
        .vsew(vsew),
        .op_A(op_A),
        .op_B(op_B),
        .result(result_valu)

    );

    //MUL

    v_mul vmul(
        .clk(clk),
        .nrst(nrst),
        .op_instr(op_instr),
        .sew(vsew),
        .op_A(op_A),
        .op_B(op_B),
        .result(result_vmul)
    );



endmodule

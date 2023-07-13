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
// Description: Instantiates the lanes for the Arithmetic Logic Unnit and Multiplication unit.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module v_lanes(
    input logic valu_clk,
    input logic vmul_clk,
    input logic nrst,
    input logic [3:0] op_instr_alu,
    input logic is_mul,
    input logic [2:0] vsew,
    input logic [2:0] lmul,
    input logic [1:0] lanes,
    output logic [127:0] result_valu_1,
    output logic [127:0] result_valu_2,
    output logic [127:0] result_valu_3,
    output logic [127:0] result_valu_4,
    output logic [127:0] result_vmul_1,
    output logic [127:0] result_vmul_2,
    output logic [127:0] result_vmul_3,
    output logic [127:0] result_vmul_4,
    output bit done_valu,
    output bit done_vmul,

	input logic [127:0] op_A_1_alu,
	input logic [127:0] op_A_2_alu,
	input logic [127:0] op_A_3_alu,
	input logic [127:0] op_A_4_alu,

    input logic [127:0] op_B_1_alu,
	input logic [127:0] op_B_2_alu,
	input logic [127:0] op_B_3_alu,
	input logic [127:0] op_B_4_alu,

	input logic [127:0] op_A_1_mul,
	input logic [127:0] op_A_2_mul,
	input logic [127:0] op_A_3_mul,
	input logic [127:0] op_A_4_mul,

    input logic [127:0] op_B_1_mul,
	input logic [127:0] op_B_2_mul,
	input logic [127:0] op_B_3_mul,
	input logic [127:0] op_B_4_mul

    );
    import v_pkg::*;

    logic [127:0] result_valu_32b_1, result_valu_32b_2, result_valu_32b_3, result_valu_32b_4;
    logic [127:0] result_vmul_32b_1, result_vmul_32b_2, result_vmul_32b_3, result_vmul_32b_4;

	logic [127:0] alu_op_A_1, alu_op_A_2, alu_op_A_3, alu_op_A_4;
	logic [127:0] alu_op_B_1, alu_op_B_2, alu_op_B_3, alu_op_B_4;
	logic [127:0] mul_op_A_1, mul_op_A_2, mul_op_A_3, mul_op_A_4;
	logic [127:0] mul_op_B_1, mul_op_B_2, mul_op_B_3, mul_op_B_4;

    logic [2:0] step_alu, step_mul;
    logic [2:0] alu_vsew, mul_vsew;
    logic [1:0] alu_lmul, mul_lmul;
    logic nrst_ctr_alu, nrst_ctr_mul;
    
    logic temp_alu, temp_mul, is_alu;
    
//    assign done_valu = (lanes == 0 && alu_lmul == 0 && step_alu == 1)? 1: 
//                        (lanes == 0 && alu_lmul == 1 && step_alu == 2)? 1:
//                        (lanes == 0 && alu_lmul == 2 && step_alu == 4)? 1:
//                        (lanes == 1 && (alu_lmul == 0 || alu_lmul == 1) && step_alu == 1)? 1:
//                        (lanes == 1 && alu_lmul == 2 && step_alu == 2)? 1:
//                        (lanes == 2 && step_alu == 1)? 1 : 0;

    assign nrst_ctr_alu = (nrst && (op_instr_alu inside {[1:15]}))? 1: 0;
    assign nrst_ctr_mul = (nrst && (is_mul == 1))? 1 : 0;

    // instantiate counters
    counter temp_c (
        .clk(valu_clk && op_instr_alu inside {[1:15]}),
        .nrst(nrst_ctr_alu),
        .lanes(lanes),
        .lmul(alu_lmul),
        .out(step_alu)
    );
    
    counter temp2_c (
        .clk(vmul_clk && is_mul == 1),
        .nrst(nrst_ctr_mul),
        .lanes(lanes),
        .lmul(mul_lmul),
        .out(step_mul)
    );    

    
    assign done_valu = ((step_alu == 3'd5) && (op_instr_alu inside {[1:15]}))? 1:0;
    assign done_vmul = ((step_mul == 3'd5) && (is_mul == 1))? 1:0;

    initial begin
        result_valu_1 <= 0 ;
        result_valu_2 <= 0 ;
        result_valu_3 <= 0 ;
        result_valu_4 <= 0 ;
        result_vmul_1 <= 0 ;
        result_vmul_2 <= 0 ;
        result_vmul_3 <= 0 ;
        result_vmul_4 <= 0 ;
        done_valu <= 0 ;
        done_vmul <= 0 ;
    end
   
    //Lane = 0
    v_alu valu0(
        .clk(~valu_clk),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A((step_alu == 3'd1)? alu_op_A_1[31:0] : (step_alu == 3'd2)? alu_op_A_2[31:0] : (step_alu == 3'd3)? alu_op_A_3[31:0] : (step_alu == 3'd4)? alu_op_A_4[31:0] : alu_op_A_1[31:0]),
        .op_B((step_alu == 3'd1)? alu_op_B_1[31:0] : (step_alu == 3'd2)? alu_op_B_2[31:0] : (step_alu == 3'd3)? alu_op_B_3[31:0] : (step_alu == 3'd4)? alu_op_B_4[31:0] : alu_op_B_1[31:0]),
        .result(result_valu_32b_1[31:0])

    );

    v_mul vmul0(
        .clk(~vmul_clk),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A((step_mul == 3'd1)? mul_op_A_1[31:0] : (step_mul == 2'd2)? mul_op_A_2[31:0] : (step_mul == 3'd3)? mul_op_A_3[31:0] : (step_mul == 3'd4)? mul_op_A_4[31:0] : mul_op_A_1[31:0]),
        .op_B((step_mul == 3'd1)? mul_op_B_1[31:0] : (step_mul == 2'd2)? mul_op_B_2[31:0] : (step_mul == 3'd3)? mul_op_B_3[31:0] : (step_mul == 3'd4)? mul_op_B_4[31:0] : mul_op_B_1[31:0]),
        .result(result_vmul_32b_1[31:0])
    );

    v_alu valu1(
        .clk(~valu_clk),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A((step_alu == 3'd1)? alu_op_A_1[63:32] : (step_alu == 3'd2)? alu_op_A_2[63:32] : (step_alu == 3'd3)? alu_op_A_3[63:32] : (step_alu == 3'd4)? alu_op_A_4[63:32] : alu_op_A_1[63:32]),
        .op_B((step_alu == 3'd1)? alu_op_B_1[63:32] : (step_alu == 3'd2)? alu_op_B_2[63:32] : (step_alu == 3'd3)? alu_op_B_3[63:32] : (step_alu == 3'd4)? alu_op_B_4[63:32] : alu_op_B_1[63:32]),
        .result(result_valu_32b_1[63:32])

    );

    v_mul vmul1(
        .clk(~vmul_clk),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A((step_mul == 3'd1)? mul_op_A_1[63:32] : (step_mul == 2'd2)? mul_op_A_2[63:32] : (step_mul == 3'd3)? mul_op_A_3[63:32] : (step_mul == 3'd4)? mul_op_A_4[63:32] : mul_op_A_1[63:32]),
        .op_B((step_mul == 3'd1)? mul_op_B_1[63:32] : (step_mul == 2'd2)? mul_op_B_2[63:32] : (step_mul == 3'd3)? mul_op_B_3[63:32] : (step_mul == 3'd4)? mul_op_B_4[63:32] : mul_op_B_1[63:32]),
        .result(result_vmul_32b_1[63:32])
    );

    v_alu valu2(
        .clk(~valu_clk),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A((step_alu == 3'd1)? alu_op_A_1[95:64] : (step_alu == 3'd2)? alu_op_A_2[95:64] : (step_alu == 3'd3)? alu_op_A_3[95:64] : (step_alu == 3'd4)? alu_op_A_4[95:64] : alu_op_A_1[95:64]),
        .op_B((step_alu == 3'd1)? alu_op_B_1[95:64] : (step_alu == 3'd2)? alu_op_B_2[95:64] : (step_alu == 3'd3)? alu_op_B_3[95:64] : (step_alu == 3'd4)? alu_op_B_4[95:64] : alu_op_B_1[95:64]),
        .result(result_valu_32b_1[95:64])

    );

    v_mul vmul2(
        .clk(~vmul_clk),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A((step_mul == 3'd1)? mul_op_A_1[95:64] : (step_mul == 2'd2)? mul_op_A_2[95:64] : (step_mul == 3'd3)? mul_op_A_3[95:64] : (step_mul == 3'd4)? mul_op_A_4[95:64] : mul_op_A_1[95:64]),
        .op_B((step_mul == 3'd1)? mul_op_B_1[95:64] : (step_mul == 2'd2)? mul_op_B_2[95:64] : (step_mul == 3'd3)? mul_op_B_3[95:64] : (step_mul == 3'd4)? mul_op_B_4[95:64] : mul_op_B_1[95:64]),
        .result(result_vmul_32b_1[95:64])
    );

    v_alu valu3(
        .clk(~valu_clk),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A((step_alu == 3'd1)? alu_op_A_1[127:96] : (step_alu == 3'd2)? alu_op_A_2[127:96] : (step_alu == 3'd3)? alu_op_A_3[127:96] : (step_alu == 3'd4)? alu_op_A_4[127:96] : alu_op_A_1[127:96]),
        .op_B((step_alu == 3'd1)? alu_op_B_1[127:96] : (step_alu == 3'd2)? alu_op_B_2[127:96] : (step_alu == 3'd3)? alu_op_B_3[127:96] : (step_alu == 3'd4)? alu_op_B_4[127:96] : alu_op_B_1[127:96]),
        .result(result_valu_32b_1[127:96])

    );

    v_mul vmul3(
        .clk(~vmul_clk),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A((step_mul == 3'd1)? mul_op_A_1[127:96] : (step_mul == 2'd2)? mul_op_A_2[127:96] : (step_mul == 3'd3)? mul_op_A_3[127:96] : (step_mul == 3'd4)? mul_op_A_4[127:96] : mul_op_A_1[127:96]),
        .op_B((step_mul == 3'd1)? mul_op_B_1[127:96] : (step_mul == 2'd2)? mul_op_B_2[127:96] : (step_mul == 3'd3)? mul_op_B_3[127:96] : (step_mul == 3'd4)? mul_op_B_4[127:96] : mul_op_B_1[127:96]),
        .result(result_vmul_32b_1[127:96])
    );

        //Lanes = 1

    logic valu_clk1, vmul_clk1;
    assign valu_clk1 = (lanes == 0 )? 0 : ~valu_clk;
    assign vmul_clk1 = (lanes == 0 )? 0 : ~vmul_clk;

    v_alu valu4(
        .clk(valu_clk1),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A((step_alu == 3'd3)? alu_op_A_4[31:0] : alu_op_A_2[31:0]),
        .op_B((step_alu == 3'd3)? alu_op_B_4[31:0] : alu_op_B_2[31:0]),
        .result(result_valu_32b_2[31:0])

    );

    v_mul vmul4(
        .clk(vmul_clk1),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A((step_mul == 3'd3)? mul_op_A_4[31:0] : mul_op_A_2[31:0]),
        .op_B((step_mul == 3'd3)? mul_op_B_4[31:0] : mul_op_B_2[31:0]),
        .result(result_vmul_32b_2[31:0])
    );

    v_alu valu5(
        .clk(valu_clk1),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A((step_alu == 3'd3)? alu_op_A_4[63:32] : alu_op_A_2[63:32]),
        .op_B((step_alu == 3'd3)? alu_op_B_4[63:32] : alu_op_B_2[63:32]),
        .result(result_valu_32b_2[63:32])

    );

    v_mul vmul5(
        .clk(vmul_clk1),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A((step_mul == 3'd3)? mul_op_A_4[63:32] : mul_op_A_2[63:32]),
        .op_B((step_mul == 3'd3)? mul_op_B_4[63:32] : mul_op_B_2[63:32]),
        .result(result_vmul_32b_2[63:32])
    );

    v_alu valu6(
        .clk(valu_clk1),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A((step_alu == 3'd3)? alu_op_A_4[95:64] : alu_op_A_2[95:64]),
        .op_B((step_alu == 3'd3)? alu_op_B_4[95:64] : alu_op_B_2[95:64]),
        .result(result_valu_32b_2[95:64])

    );

    v_mul vmul6(
        .clk(vmul_clk1),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A((step_mul == 3'd3)? mul_op_A_4[95:64] : mul_op_A_2[95:64]),
        .op_B((step_mul == 3'd3)? mul_op_B_4[95:64] : mul_op_B_2[95:64]),
        .result(result_vmul_32b_2[95:64])
    );

    v_alu valu7(
        .clk(valu_clk1),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A((step_alu == 3'd3)? alu_op_A_4[127:96] : alu_op_A_2[127:96]),
        .op_B((step_alu == 3'd3)? alu_op_B_4[127:96] : alu_op_B_2[127:96]),
        .result(result_valu_32b_2[127:96])

    );

    v_mul vmul7(
        .clk(vmul_clk1),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A((step_mul == 3'd3)? mul_op_A_4[127:96] : mul_op_A_2[127:96]),
        .op_B((step_mul == 3'd3)? mul_op_B_4[127:96] : mul_op_B_2[127:96]),
        .result(result_vmul_32b_2[127:96])
    );

        //Lanes == 2
    logic valu_clk2, vmul_clk2;
    assign valu_clk2 = (lanes == 0 )? 0 :(lanes == 1 )? 0 : ~valu_clk;
    assign vmul_clk2 = (lanes == 0 )? 0 :(lanes == 1 )? 0 : ~vmul_clk; 

    v_alu valu8(
        .clk(valu_clk2),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A(alu_op_A_3[31:0]),
        .op_B(alu_op_B_3[31:0]),
        .result(result_valu_32b_3[31:0])

    );

    v_mul vmul8(
        .clk(vmul_clk2),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A(mul_op_A_3[31:0]),
        .op_B(mul_op_B_3[31:0]),
        .result(result_vmul_32b_3[31:0])
    );

    v_alu valu9(
        .clk(valu_clk2),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A(alu_op_A_3[63:32]),
        .op_B(alu_op_B_3[63:32]),
        .result(result_valu_32b_3[63:32])

    );

    v_mul vmul9(
        .clk(vmul_clk2),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A(mul_op_A_3[63:32]),
        .op_B(mul_op_B_3[63:32]),
        .result(result_vmul_32b_3[63:32])
    );


    v_alu valu10(
        .clk(valu_clk2),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A(alu_op_A_3[95:64]),
        .op_B(alu_op_B_3[95:64]),
        .result(result_valu_32b_3[95:64])

    );

    v_mul vmul10(
        .clk(vmul_clk2),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A(mul_op_A_3[95:64]),
        .op_B(mul_op_B_3[95:64]),
        .result(result_vmul_32b_3[95:64])
    );

    v_alu valu11(
        .clk(valu_clk2),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A(alu_op_A_3[127:96]),
        .op_B(alu_op_B_3[127:96]),
        .result(result_valu_32b_3[127:96])

    );

    v_mul vmul11(
        .clk(vmul_clk2),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A(mul_op_A_3[127:96]),
        .op_B(mul_op_B_3[127:96]),
        .result(result_vmul_32b_3[127:96])
    );


    v_alu valu12(
        .clk(valu_clk2),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A(alu_op_A_4[31:0]),
        .op_B(alu_op_B_4[31:0]),
        .result(result_valu_32b_4[31:0])

    );

    v_mul vmul12(
        .clk(vmul_clk2),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A(mul_op_A_4[31:0]),
        .op_B(mul_op_B_4[31:0]),
        .result(result_vmul_32b_4[31:0])
    );

    v_alu valu13(
        .clk(valu_clk2),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A(alu_op_A_4[63:32]),
        .op_B(alu_op_B_4[63:32]),
        .result(result_valu_32b_4[63:32])

    );

    v_mul vmul13(
        .clk(vmul_clk2),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A(mul_op_A_4[63:32]),
        .op_B(mul_op_B_4[63:32]),
        .result(result_vmul_32b_4[63:32])
    );


    v_alu valu14(
        .clk(valu_clk2),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A(alu_op_A_4[95:64]),
        .op_B(alu_op_B_4[95:64]),
        .result(result_valu_32b_4[95:64])

    );

    v_mul vmul14(
        .clk(vmul_clk2),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A(mul_op_A_4[95:64]),
        .op_B(mul_op_B_4[95:64]),
        .result(result_vmul_32b_4[95:64])
    );

    v_alu valu15(
        .clk(valu_clk2),
        .nrst(nrst),
        .op_instr(op_instr_alu),
        .vsew(alu_vsew[1:0]),
        .op_A(alu_op_A_4[127:96]),
        .op_B(alu_op_B_4[127:96]),
        .result(result_valu_32b_4[127:96])

    );

    v_mul vmul15(
        .clk(vmul_clk2),
        .nrst(nrst),
        .is_mul(is_mul),
        .sew(mul_vsew),
        .op_A(mul_op_A_4[127:96]),
        .op_B(mul_op_B_4[127:96]),
        .result(result_vmul_32b_4[127:96])
    );

    always @(op_instr_alu, op_A_1_alu,op_A_2_alu,op_A_3_alu,op_A_4_alu,op_B_1_alu,op_B_2_alu,op_B_3_alu,op_B_4_alu) begin
        if (op_instr_alu inside {[1:15]}) begin
            alu_op_A_1 <= op_A_1_alu;
            alu_op_A_2 <= op_A_2_alu;
            alu_op_A_3 <= op_A_3_alu;
            alu_op_A_4 <= op_A_4_alu;
            alu_op_B_1 <= op_B_1_alu;
            alu_op_B_2 <= op_B_2_alu;
            alu_op_B_3 <= op_B_3_alu;
            alu_op_B_4 <= op_B_4_alu;
            alu_vsew <= vsew;
            alu_lmul <= lmul;
          end
    end
    always @(is_mul, op_A_1_mul,op_A_2_mul,op_A_3_mul,op_A_4_mul,op_B_1_mul,op_B_2_mul,op_B_3_mul,op_B_4_mul) begin
        if (is_mul == 1) begin
            mul_op_A_1 <= op_A_1_mul;
            mul_op_A_2 <= op_A_2_mul;
            mul_op_A_3 <= op_A_3_mul;
            mul_op_A_4 <= op_A_4_mul;
            mul_op_B_1 <= op_B_1_mul;
            mul_op_B_2 <= op_B_2_mul;
            mul_op_B_3 <= op_B_3_mul;
            mul_op_B_4 <= op_B_4_mul;  
            mul_vsew <= vsew;
            mul_lmul <= lmul;        
         end
    end

	always @(posedge valu_clk or negedge nrst) begin
        if (!nrst) begin
            result_valu_1 <= 0 ;
            result_valu_2 <= 0 ;
            result_valu_3 <= 0 ;
            result_valu_4 <= 0 ;
        end else begin   
            if (lanes == 0) begin
                case (step_alu)
                    3'd1: begin
                        result_valu_1 <= result_valu_32b_1;
                    end 
                    3'd2: begin
                        result_valu_2 <= result_valu_32b_1;
                    end 
                    3'd3: begin
                        result_valu_3 <= result_valu_32b_1;
                    end 
                    3'd4: begin
                        result_valu_4 <= result_valu_32b_1;
                        end
                    default: begin
                        result_valu_1 <= result_valu_32b_1;
                    end  
                endcase                                  
            end else if (lanes == 2'b01) begin
                case (step_alu)
                    3'd1: begin
                        result_valu_1 <= result_valu_32b_1;
                        result_valu_2 <= result_valu_32b_2;                     
                    end 
                    3'd3: begin
                        result_valu_3 <= result_valu_32b_1;
                        result_valu_4 <= result_valu_32b_2;                      
                    end            
                    default: begin
                        result_valu_1 <= result_valu_32b_1;
                        result_valu_2 <= result_valu_32b_2;  
                    end 
                endcase                        
            end else if (lanes == 2'b10) begin
                result_valu_1 <= result_valu_32b_1;
                result_valu_2 <= result_valu_32b_2;                     
                result_valu_3 <= result_valu_32b_3;
                result_valu_4 <= result_valu_32b_4;                                                        
            end else begin
                case (step_alu)
                    3'd1: begin
                        result_valu_1 <= result_valu_32b_1;
                    end 
                    3'd2: begin
                        result_valu_2 <= result_valu_32b_1;
                    end 
                    3'd3: begin
                        result_valu_3 <= result_valu_32b_1;
                    end 
                    3'd4: begin
                        result_valu_4 <= result_valu_32b_1;
                        end
                    default: begin
                        result_valu_1 <= result_valu_32b_1;
                    end  
                endcase 
            end
        end
    end

	always @(posedge vmul_clk or negedge nrst) begin
       if (!nrst) begin
            result_vmul_1 <= 0 ;
            result_vmul_2 <= 0 ;
            result_vmul_3 <= 0 ;
            result_vmul_4 <= 0 ;
        end else begin 
            if (lanes == 0) begin
                case (step_mul)
                    3'd1: begin
                        result_vmul_1 <= result_vmul_32b_1;
                    end 
                    3'd2: begin
                        result_vmul_2 <= result_vmul_32b_1;
                    end 
                    3'd3: begin
                        result_vmul_3 <= result_vmul_32b_1;  
                    end 
                    3'd4: begin
                        result_vmul_4 <= result_vmul_32b_1;
                    end                 
                    default: begin
                        result_vmul_1 <= result_vmul_32b_1;
                    end 
                endcase                       
            end else if (lanes == 2'b01) begin    
                case (step_mul)
                    2'd1: begin
                    result_vmul_1 <= result_vmul_32b_1;
                    result_vmul_2 <= result_vmul_32b_2;
                    end 
                    2'd3: begin
                        result_vmul_3 <= result_vmul_32b_1;                          
                        result_vmul_4 <= result_vmul_32b_2;
                    end                 
                    default: begin
                    result_vmul_1 <= result_vmul_32b_1;
                    result_vmul_2 <= result_vmul_32b_2;
                    end  
                endcase                   
            end else if ((lanes == 2'b10) && is_mul == 1) begin
                result_vmul_1 <= result_vmul_32b_1;
                result_vmul_2 <= result_vmul_32b_2;
                result_vmul_3 <= result_vmul_32b_3;
                result_vmul_4 <= result_vmul_32b_4;
            end else begin
                case (step_mul)
                    3'd1: begin
                        result_vmul_1 <= result_vmul_32b_1;
                    end 
                    3'd2: begin
                        result_vmul_2 <= result_vmul_32b_1;
                    end 
                    3'd3: begin
                        result_vmul_3 <= result_vmul_32b_1;  
                    end 
                    3'd4: begin
                        result_vmul_4 <= result_vmul_32b_1;
                    end                 
                    default: begin
                        result_vmul_1 <= result_vmul_32b_1;
                    end 
                endcase
            end             
        end
    end

endmodule

//t Counter
module counter (
    input clk, 
    input nrst,
    input [1:0] lmul,
    input [1:0] lanes,
    output reg [2:0] out
);
    initial begin
        out <= 0;
    end
    always @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            out <= 0; 
        end else begin
            case (out)
                3'd0: out <= 1;
                3'd1: out <= (lanes == 2'b00 && lmul==3'b001)? 3'd2: (lanes == 2'b00 && lmul==3'b010)? 3'd2 : (lanes == 2'b01 && lmul==3'b010)? 3'd3: 3'd5;
                3'd2: out <= (lmul==3'b10)? 3'd3 : 3'd5;                             
                3'd3: out <= (lanes == 2'b01 && lmul==3'b010)? 3'd5: 3'd4;       
                3'd4: out <= 3'd5;                           
                3'd5: out <= 3'd0;                                             
                default: out <= 3'd0;                            
            endcase       
        end
    end
    
endmodule

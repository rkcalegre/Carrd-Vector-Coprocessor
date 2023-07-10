//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// v_alu.sv -- Vector Arithmetic Logic Unit
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 199 Carrd: RISC-V Vector Coprocessor Group (2SAY2223)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: v_alu.sv
// Description: The VALU supports 1) integer arithmetic operations, 
//                                2) fixed-width arithmetic operations and, 
//                                3) reduction operations
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Research 8-bit adders to be imported. Use cascaded adders for element widths > 8
//                      **** TO BE SOLVED: Don't customize each lane. Should be able to accept the operand 
//                        
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps
//`include "vstructs.sv"

module v_alu #(
    // CHANGE VECTOR_LENGTH VALUE TO 128
    parameter int VECTOR_LENGTH = 32,           // Vector Register length in bits (# of bits per v_reg)
    parameter int ELEMENT_WIDTH = 8,            // Supported effective element widths (EEW) = 8, 16, 32
    parameter int VALU_OP_W_MAX = 32           // VALU operand width in bits (EEW - effective element width)
)(
    input clk,
    input nrst,
    input logic [3:0] op_instr,
    input logic [1:0] vsew,
    input logic [VALU_OP_W_MAX-1:0] op_A,
    input logic [VALU_OP_W_MAX-1:0] op_B,
    output logic [VALU_OP_W_MAX-1:0] result
);

    import v_pkg::*;

    //logic [VALU_OP_W_MAX-1:0] op_A_tmp [0:3];
    logic [VALU_OP_W_MAX-1:0] op_A_tmp_0;
    logic [VALU_OP_W_MAX-1:0] op_A_tmp_1;
    logic [VALU_OP_W_MAX-1:0] op_A_tmp_2;
    logic [VALU_OP_W_MAX-1:0] op_A_tmp_3;

    //logic [VALU_OP_W_MAX-1:0] op_B_tmp [0:3];
    logic [VALU_OP_W_MAX-1:0] op_B_tmp_0;
    logic [VALU_OP_W_MAX-1:0] op_B_tmp_1;
    logic [VALU_OP_W_MAX-1:0] op_B_tmp_2;
    logic [VALU_OP_W_MAX-1:0] op_B_tmp_3;

    //logic [VALU_OP_W_MAX-1:0] addsub_res [0:3];
    logic [VALU_OP_W_MAX-1:0] addsub_res_0;
    logic [VALU_OP_W_MAX-1:0] addsub_res_1;
    logic [VALU_OP_W_MAX-1:0] addsub_res_2;
    logic [VALU_OP_W_MAX-1:0] addsub_res_3;
    logic [VALU_OP_W_MAX-1:0] res_tmp;
    //logic [VALU_OP_W_MAX-1:0] addsub_res;       // result of adder/subtrctor IP


    // Instantiating Adder/Substractor IPs
    // VALU uses fracturable 8-bit adders for 8, 16, and 32-bit configurations
    // VALU has four 8-bit adders
    logic ADD, CE;
    assign ADD = (op_instr == VALU_VADD) ? 1'b1 : 1'b0; 
    assign CE = (op_instr == VALU_VADD || op_instr == VALU_VSUB)? 1'b1 : 1'b0;
    logic [2:0] carry;

    initial begin
        op_A_tmp_0 = 32'd0;
        op_A_tmp_1 = 32'd0;
        op_A_tmp_2 = 32'd0;
        op_A_tmp_3 = 32'd0;
        op_B_tmp_0 = 32'd0;
        op_B_tmp_1 = 32'd0;
        op_B_tmp_2 = 32'd0;
        op_B_tmp_3 = 32'd0;
    end

    always@(*) begin
        if (op_instr == VALU_VADD || op_instr == VALU_VSUB) begin
            case (vsew)     // SIGN EXTEND
                VSEW_8: begin
                    /*
                    for (int i = 0; i < 4; i++) begin
                        op_A_tmp[i] = (op_A[i*8+7]) ? {{24{1'b1}}, op_A[i*8+7 -: 8]} : op_A[i*8+7 -: 8];
                        op_B_tmp[i] = (op_B[i*8+7]) ? {{24{1'b1}}, op_B[i*8+7 -: 8]} : op_B[i*8+7 -: 8];
                    end
                    */

                    // adder 0 operands
                    op_A_tmp_0 = {{24{op_A[7]}}, op_A[7:0]};
                    op_B_tmp_0 = {{24{op_B[7]}}, op_B[7:0]};

                    // adder 1 operands
                    op_A_tmp_1 = {{24{op_A[15]}}, op_A[15:8]};
                    op_B_tmp_1 = {{24{op_B[15]}}, op_B[15:8]};

                    // adder 2 operands
                    op_A_tmp_2 = {{24{op_A[23]}}, op_A[23:16]};
                    op_B_tmp_2 = {{24{op_B[23]}}, op_B[23:16]};

                    // adder 3 operands
                    op_A_tmp_3 = {{24{op_A[31]}}, op_A[31:24]};
                    op_B_tmp_3 = {{24{op_B[31]}}, op_B[31:24]};

                end
                VSEW_16: begin
                    /*
                    for (int i = 0; i < 2; i++) begin
                        op_A_tmp[i] = (op_A[i*16+15]) ? {{16{1'b1}}, op_A[i*16+15 -: 16]} : op_A[i*16+15 -: 16];
                        op_B_tmp[i] = (op_B[i*16+15]) ? {{16{1'b1}}, op_B[i*16+15 -: 16]} : op_B[i*16+15 -: 16];
                    end
                    */
                    // adder 0 operands
                    op_A_tmp_0 = {{16{op_A[15]}}, op_A[15:0]};
                    op_B_tmp_0 = {{16{op_B[15]}}, op_B[15:0]};

                    // adder 1 operands
                    op_A_tmp_1 = {{16{op_A[31]}}, op_A[31:16]};
                    op_B_tmp_1 = {{16{op_B[31]}}, op_B[31:16]};

                    // adder 2 operands
                    op_A_tmp_2 = 32'b0;
                    op_B_tmp_2 = 32'b0;

                    // adder 3 operands
                    op_A_tmp_3 = 32'b0;
                    op_B_tmp_3 = 32'b0;

                end
                VSEW_32: begin
                    op_A_tmp_0 = op_A;
                    op_B_tmp_0 = op_B;

                    // adder 1 operands
                    op_A_tmp_1 = 32'b0;
                    op_B_tmp_1 = 32'b0;

                    // adder 2 operands
                    op_A_tmp_2 = 32'b0;
                    op_B_tmp_2 = 32'b0;

                    // adder 3 operands
                    op_A_tmp_3 = 32'b0;
                    op_B_tmp_3 = 32'b0;
                end
                default: begin
                    // adder 0 operands
                    op_A_tmp_0 = 32'b0;
                    op_B_tmp_0 = 32'b0;

                    // adder 1 operands
                    op_A_tmp_1 = 32'b0;
                    op_B_tmp_1 = 32'b0;

                    // adder 2 operands
                    op_A_tmp_2 = 32'b0;
                    op_B_tmp_2 = 32'b0;

                    // adder 3 operands
                    op_A_tmp_3 = 32'b0;
                    op_B_tmp_3 = 32'b0;
                end
            endcase
        end else begin
            // adder 0 operands
            op_A_tmp_0 = 32'b0;
            op_B_tmp_0 = 32'b0;

            // adder 1 operands
            op_A_tmp_1 = 32'b0;
            op_B_tmp_1 = 32'b0;

            // adder 2 operands
            op_A_tmp_2 = 32'b0;
            op_B_tmp_2 = 32'b0;

            // adder 3 operands
            op_A_tmp_3 = 32'b0;
            op_B_tmp_3 = 32'b0;
        end
        
    end
    
    // Each Adder/Subtractor operates on specific 8-bit fields of the operands
    /*
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            c_addsub_0 addsub (
                .CLK(clk), 
                .A(op_B_tmp[i]), 
                .B(op_A_tmp[i]), 
                .ADD(ADD), 
                .CE(CE), 
                .S(addsub_res[i])
            );
        end
    endgenerate
    */
    c_addsub_0 addsub_0 (
        .CLK(clk), 
        .A(op_B_tmp_0), 
        .B(op_A_tmp_0), 
        .ADD(ADD), 
        .CE(CE), 
        .S(addsub_res_0)
    );

    c_addsub_0 addsub_1 (
        .CLK(clk), 
        .A(op_B_tmp_1), 
        .B(op_A_tmp_1), 
        .ADD(ADD), 
        .CE(CE), 
        .S(addsub_res_1)
    );

    c_addsub_0 addsub_2 (
        .CLK(clk), 
        .A(op_B_tmp_2), 
        .B(op_A_tmp_2), 
        .ADD(ADD), 
        .CE(CE), 
        .S(addsub_res_2)
    );

    c_addsub_0 addsub_3 (
        .CLK(clk), 
        .A(op_B_tmp_3), 
        .B(op_A_tmp_3), 
        .ADD(ADD), 
        .CE(CE), 
        .S(addsub_res_3)
    );
    
    always@(*) begin
        case (op_instr)
            VALU_VADD: begin
                // VADD
                // result = op_A + op_B
                // if sew = 8, 4 results
                // if sew = 16, 2 results
                // if sew = 32, 1 result
                case (vsew)
                    VSEW_8: res_tmp = {addsub_res_3[7:0], addsub_res_2[7:0], addsub_res_1[7:0], addsub_res_0[7:0]};
                    VSEW_16: res_tmp = {addsub_res_1[15:0], addsub_res_0[15:0]};
                    VSEW_32: res_tmp = addsub_res_0;
                    default: res_tmp = 0;
                endcase
            end
            VALU_VSUB: begin
                // VSUB
                //result = op_A - op_B
                case (vsew)
                    VSEW_8: res_tmp = {addsub_res_3[7:0], addsub_res_2[7:0], addsub_res_1[7:0], addsub_res_0[7:0]};
                    VSEW_16: res_tmp = {addsub_res_1[15:0], addsub_res_0[15:0]};
                    VSEW_32: res_tmp = addsub_res_0;
                    default: res_tmp = 0;
                endcase
            end
            VALU_VAND: begin
                // VAND
                res_tmp = op_A & op_B;
            end 
            VALU_VOR: begin
                // VOR
                res_tmp = op_A | op_B;
            end
            VALU_VXOR: begin
                // VXOR
                res_tmp = op_A ^ op_B;
            end
            VALU_VSLL: begin 
                // VSLL
                // logical shift x[rd] = x[rs1] << x[rs2]
                case (vsew)
                    VSEW_8: res_tmp = {op_B[31:24] << op_A[31:24], op_B[23:16] << op_A[23:16], op_B[15:8] << op_A[15:8], op_B[7:0] << op_A[7:0]};
                    VSEW_16: res_tmp = {op_B[31:16] << op_A[31:16], op_B[15:0] << op_A[15:0]};
                    VSEW_32: res_tmp = op_B << op_A;
                    default: res_tmp = 0;
                endcase
            end
            VALU_VSRL: begin 
                // VSRL
                //x[rd] = x[rs1] >>u x[rs2]
                case (vsew)
                    VSEW_8: res_tmp = {op_B[31:24] >> op_A[31:24], op_B[23:16] >> op_A[23:16], op_B[15:8] >> op_A[15:8], op_B[7:0] >> op_A[7:0]};
                    VSEW_16: res_tmp = {op_B[31:16] >> op_A[31:16], op_B[15:0] >> op_A[15:0]};
                    VSEW_32: res_tmp = op_B >> op_A;
                    default: res_tmp = 0;
                endcase
            end
            VALU_VSRA: begin
                // VSRA 
                //x[rd] = x[rs1] >>s x[rs2]
                case (vsew)
                    VSEW_8: res_tmp = {op_B[31:24] >>> op_A[31:24], op_B[23:16] >>> op_A[23:16], op_B[15:8] >>> op_A[15:8], op_B[7:0] >>> op_A[7:0]};
                    VSEW_16: res_tmp = {op_B[31:16] >>> op_A[31:16], op_B[15:0] >>> op_A[15:0]};
                    VSEW_32: res_tmp = op_B >>> op_A;
                    default: res_tmp = 0;
                endcase
            end
            
            VALU_VMSEQ: begin 
                //Set if equal
                case (vsew) 
                    VSEW_8: res_tmp = {((op_B[31:24] == op_A[31:24]) ? 1 : 0), ((op_B[23:16] == op_A[23:16]) ? 1 : 0), ((op_B[15:8] == op_A[15:8]) ? 1 : 0), ((op_B[7:0] == op_A[7:0]) ? 1 : 0)};
                    VSEW_16: res_tmp = {((op_B[31:16] == op_A[31:16]) ? 1 : 0), ((op_B[15:0] == op_A[15:0]) ? 1 : 0)};
                    VSEW_32: res_tmp = (op_B == op_A) ? 1 : 0;
                    default: res_tmp = 0;
                endcase
            end
            VALU_VMSNE: begin 
                //Set if not equal
                case (vsew) 
                    VSEW_8: res_tmp = {((op_B[31:24] != op_A[31:24]) ? 1 : 0), ((op_B[23:16] != op_A[23:16]) ? 1 : 0), ((op_B[15:8] != op_A[15:8]) ? 1 : 0), ((op_B[7:0] == op_A[7:0]) ? 1 : 0)};
                    VSEW_16: res_tmp = {((op_B[31:16] != op_A[31:16]) ? 1 : 0), ((op_B[15:0] != op_A[15:0]) ? 1 : 0)};
                    VSEW_32: res_tmp = (op_B != op_A) ? 1 : 0;
                    default: res_tmp = 0;
                endcase
            end
            VALU_VMSLT: begin 
                //Set if less than, signed
                case (vsew) 
                    VSEW_8: res_tmp = {((op_B[31:24] < op_A[31:24]) ? 1 : 0), ((op_B[23:16] < op_A[23:16]) ? 1 : 0), ((op_B[15:8] < op_A[15:8]) ? 1 : 0), ((op_B[7:0] == op_A[7:0]) ? 1 : 0)};
                    VSEW_16: res_tmp = {((op_B[31:16] < op_A[31:16]) ? 1 : 0), ((op_B[15:0] < op_A[15:0]) ? 1 : 0)};
                    VSEW_32: res_tmp = (op_B < op_A) ? 1 : 0;
                    default: res_tmp = 0;
                endcase           
            end
            VALU_VMSLE: begin 
                //Set if less than or equal, signed
                case (vsew) 
                    VSEW_8: res_tmp = {((op_B[31:24] <= op_A[31:24]) ? 1 : 0), ((op_B[23:16] <= op_A[23:16]) ? 1 : 0), ((op_B[15:8] <= op_A[15:8]) ? 1 : 0), ((op_B[7:0] == op_A[7:0]) ? 1 : 0)};
                    VSEW_16: res_tmp = {((op_B[31:16] <= op_A[31:16]) ? 1 : 0), ((op_B[15:0] <= op_A[15:0]) ? 1 : 0)};
                    VSEW_32: res_tmp = (op_B <= op_A) ? 1 : 0;
                    default: res_tmp = 0;
                endcase            
            end
            VALU_VMSGT: begin 
                //Set if greater than, signed
                case (vsew) 
                    VSEW_8: res_tmp = {((op_B[31:24] >= op_A[31:24]) ? 1 : 0), ((op_B[23:16] >= op_A[23:16]) ? 1 : 0), ((op_B[15:8] >= op_A[15:8]) ? 1 : 0), ((op_B[7:0] >= op_A[7:0]) ? 1 : 0)};
                    VSEW_16: res_tmp = {((op_B[31:16] >= op_A[31:16]) ? 1 : 0), ((op_B[15:0] >= op_A[15:0]) ? 1 : 0)};
                    VSEW_32: res_tmp = (op_B >= op_A) ? 1 : 0;
                    default: res_tmp = 0;
                endcase
            end 
                                                
            VALU_VMIN: begin
                // VMIN
                res_tmp = (op_A < op_B)? op_A : op_B;
            end
            VALU_VMAX: begin
                // VMAX
                res_tmp = (op_A < op_B)? op_B : op_A;
            end
            default: res_tmp = 0;
        endcase
    end

    assign result = (!nrst) ? 32'b0 : res_tmp;

endmodule
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

    logic [VALU_OP_W_MAX-1:0] op_A_tmp [0:3];
    logic [VALU_OP_W_MAX-1:0] op_B_tmp [0:3];
    logic [VALU_OP_W_MAX-1:0] addsub_res [0:3];
    logic [VALU_OP_W_MAX-1:0] res_tmp;
    //logic [VALU_OP_W_MAX-1:0] addsub_res;       // result of adder/subtrctor IP


    // Instantiating Adder/Substractor IPs
    // VALU uses fracturable 8-bit adders for 8, 16, and 32-bit configurations
    // VALU has four 8-bit adders
    wire ADD = (op_instr == VALU_VADD)? 1'b1 : 1'b0; 
    wire CE = (op_instr == VALU_VADD || op_instr == VALU_VSUB)? 1'b1 : 1'b0;
    wire [2:0] carry;

    initial begin
        op_A_tmp[0] = 0;
        op_A_tmp[1] = 0;
        op_A_tmp[2] = 0;
        op_A_tmp[3] = 0;
        op_B_tmp[0] = 0;
        op_B_tmp[1] = 0;
        op_B_tmp[2] = 0;
        op_B_tmp[3] = 0;
    end

    always_comb begin
        if (op_instr == VALU_VADD || op_instr == VALU_VSUB) begin
            case (vsew)     // SIGN EXTEND
                VSEW_8: begin
                    for (int i = 0; i < 4; i++) begin
                        op_A_tmp[i] = (op_A[i*8+7]) ? {{24{1'b1}}, op_A[i*8+7 -: 8]} : op_A[i*8+7 -: 8];
                        op_B_tmp[i] = (op_B[i*8+7]) ? {{24{1'b1}}, op_B[i*8+7 -: 8]} : op_B[i*8+7 -: 8];
                    end
                end
                VSEW_16: begin
                    for (int i = 0; i < 2; i++) begin
                        op_A_tmp[i] = (op_A[i*16+15]) ? {{16{1'b1}}, op_A[i*16+15 -: 16]} : op_A[i*16+15 -: 16];
                        op_B_tmp[i] = (op_B[i*16+15]) ? {{16{1'b1}}, op_B[i*16+15 -: 16]} : op_B[i*16+15 -: 16];
                    end
                end
                VSEW_32: begin
                    op_A_tmp[0] = op_A;
                    op_B_tmp[0] = op_B;
                end
                default: ;
            endcase
        end

    end
    // Each Adder/Subtractor operates on specific 8-bit fields of the operands
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
    /*
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            c_addsub_0 addsub (
                .CLK(clk), 
                .A(op_A[(i*8)+8-1:i*8]), 
                .B(op_B[(i*8)+8-1:i*8]), 
                .ADD(ADD), 
                .CE(CE),
                .C_OUT((vsew == 0) ? 0: carry[i]),
                .C_IN((vsew == 0) ? 0: (i == 0) ? 0 : carry[i-1]), 
                .S(addsub_res[(i*8)+8-1:i*8])
            );
        end
    endgenerate
    */
    /*
    c_addsub_0 addsub (
        .CLK(clk), 
        .A(op_A), 
        .B(op_B), 
        .ADD(ADD), 
        .CE(CE),
        .S(addsub_res)
    );
    */
    /*
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            c_addsub_0 addsub (
                .CLK(clk), 
                .A(op_A[(i*8)+8-1:i*8]), 
                .B(op_B[(i*8)+8-1:i*8]), 
                .ADD(ADD), 
                .CE(CE), 
                .S(addsub_res[(i*8)+8-1:i*8])
            );
        end
    endgenerate
    */

/*     always @(posedge clk) begin
        if (!nrst) begin
            res_tmp = 0;
        end
    end
 */
    always_comb begin

        if (!nrst) begin
            res_tmp = 0;
        end

        case (op_instr)
            VALU_VADD: begin
                // VADD
                // result = op_A + op_B
                // if sew = 8, 4 results
                // if sew = 16, 2 results
                // if sew = 32, 1 result
                case (vsew)
                    VSEW_8: res_tmp = {addsub_res[3][7:0], addsub_res[2][7:0], addsub_res[1][7:0], addsub_res[0][7:0]};
                    VSEW_16: res_tmp = {addsub_res[1][15:0], addsub_res[0][15:0]};
                    VSEW_32: res_tmp = addsub_res[0];
                    default: ;
                endcase
            end
            VALU_VSUB: begin
                // VSUB
                //result = op_A - op_B
                case (vsew)
                    VSEW_8: res_tmp = {addsub_res[3][7:0], addsub_res[2][7:0], addsub_res[1][7:0], addsub_res[0][7:0]};
                    VSEW_16: res_tmp = {addsub_res[1][15:0], addsub_res[0][15:0]};
                    VSEW_32: res_tmp = addsub_res[0];
                    default: ;
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
                    default: ;
                endcase
            end
            VALU_VSRL: begin 
                // VSRL
                //x[rd] = x[rs1] >>u x[rs2]
                case (vsew)
                    VSEW_8: res_tmp = {op_B[31:24] >> op_A[31:24], op_B[23:16] >> op_A[23:16], op_B[15:8] >> op_A[15:8], op_B[7:0] >> op_A[7:0]};
                    VSEW_16: res_tmp = {op_B[31:16] >> op_A[31:16], op_B[15:0] >> op_A[15:0]};
                    VSEW_32: res_tmp = op_B >> op_A;
                    default: ;
                endcase
            end
            VALU_VSRA: begin
                // VSRA 
                //x[rd] = x[rs1] >>s x[rs2]
                case (vsew)
                    VSEW_8: res_tmp = {op_B[31:24] >>> op_A[31:24], op_B[23:16] >>> op_A[23:16], op_B[15:8] >>> op_A[15:8], op_B[7:0] >>> op_A[7:0]};
                    VSEW_16: res_tmp = {op_B[31:16] >>> op_A[31:16], op_B[15:0] >>> op_A[15:0]};
                    VSEW_32: res_tmp = op_B >>> op_A;
                    default: ;
                endcase
            end
            
            VALU_VMSEQ: begin 
                //Set if equal
                case (vsew) 
                    VSEW_8: res_tmp = {((op_B[31:24] == op_A[31:24]) ? 1 : 0), ((op_B[23:16] == op_A[23:16]) ? 1 : 0), ((op_B[15:8] == op_A[15:8]) ? 1 : 0), ((op_B[7:0] == op_A[7:0]) ? 1 : 0)};
                    VSEW_16: res_tmp = {((op_B[31:16] == op_A[31:16]) ? 1 : 0), ((op_B[15:0] == op_A[15:0]) ? 1 : 0)};
                    VSEW_32: res_tmp = (op_B == op_A) ? 1 : 0;
                    default: ;
                endcase
            end
            VALU_VMSNE: begin 
                //Set if not equal
                case (vsew) 
                    VSEW_8: res_tmp = {((op_B[31:24] != op_A[31:24]) ? 1 : 0), ((op_B[23:16] != op_A[23:16]) ? 1 : 0), ((op_B[15:8] != op_A[15:8]) ? 1 : 0), ((op_B[7:0] == op_A[7:0]) ? 1 : 0)};
                    VSEW_16: res_tmp = {((op_B[31:16] != op_A[31:16]) ? 1 : 0), ((op_B[15:0] != op_A[15:0]) ? 1 : 0)};
                    VSEW_32: res_tmp = (op_B != op_A) ? 1 : 0;
                    default: ;
                endcase
            end
            VALU_VMSLT: begin 
                //Set if less than, signed
                case (vsew) 
                    VSEW_8: res_tmp = {((op_B[31:24] < op_A[31:24]) ? 1 : 0), ((op_B[23:16] < op_A[23:16]) ? 1 : 0), ((op_B[15:8] < op_A[15:8]) ? 1 : 0), ((op_B[7:0] == op_A[7:0]) ? 1 : 0)};
                    VSEW_16: res_tmp = {((op_B[31:16] < op_A[31:16]) ? 1 : 0), ((op_B[15:0] < op_A[15:0]) ? 1 : 0)};
                    VSEW_32: res_tmp = (op_B < op_A) ? 1 : 0;
                    default: ;
                endcase           
            end
            VALU_VMSLE: begin 
                //Set if less than or equal, signed
                case (vsew) 
                    VSEW_8: res_tmp = {((op_B[31:24] <= op_A[31:24]) ? 1 : 0), ((op_B[23:16] <= op_A[23:16]) ? 1 : 0), ((op_B[15:8] <= op_A[15:8]) ? 1 : 0), ((op_B[7:0] == op_A[7:0]) ? 1 : 0)};
                    VSEW_16: res_tmp = {((op_B[31:16] <= op_A[31:16]) ? 1 : 0), ((op_B[15:0] <= op_A[15:0]) ? 1 : 0)};
                    VSEW_32: res_tmp = (op_B <= op_A) ? 1 : 0;
                    default: ;
                endcase            
            end
            VALU_VMSGT: begin 
                //Set if greater than, signed
                case (vsew) 
                    VSEW_8: res_tmp = {((op_B[31:24] >= op_A[31:24]) ? 1 : 0), ((op_B[23:16] >= op_A[23:16]) ? 1 : 0), ((op_B[15:8] >= op_A[15:8]) ? 1 : 0), ((op_B[7:0] >= op_A[7:0]) ? 1 : 0)};
                    VSEW_16: res_tmp = {((op_B[31:16] >= op_A[31:16]) ? 1 : 0), ((op_B[15:0] >= op_A[15:0]) ? 1 : 0)};
                    VSEW_32: res_tmp = (op_B >= op_A) ? 1 : 0;
                    default: ;
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
            /*
            VMERGE: begin
                // vmerge.vvm vd, vs2, vs1, v0 # vd[i] = v0.mask[i] ? vs1[i] : vs2[i]
                // vmerge.vxm vd, vs2, rs1, v0 # vd[i] = v0.mask[i] ? x[rs1] : vs2[i]
                // vmerge.vim vd, vs2, imm, v0 # vd[i] = v0.mask[i] ? imm : vs2[i]
                // result = (vm.mask)? op_A : op_B; // vm.mask still does not exist: TBA  
            end
            */
            default: res_tmp = 0;
        endcase
    end

    assign result = res_tmp;

endmodule
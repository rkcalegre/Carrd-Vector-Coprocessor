//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// csr.sv -- Vector Control and Status Register
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 199 Carrd: RISC-V Vector Coprocessor Group (2SAY2223)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: csr.sv
// Description: The CSR supports configuration instructions: vsetvl, vsetivli, and vsetvli
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments: error occurs after nrst if instr is not changed
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps

module csr (
    input clk,
    input nrst,
    input [31:0] instr,

    output [4:0] vl,        // vector length - # of elements per iteration
    output [2:0] vlmul,     // vector register group
    output [2:0] vsew       // selected element width - size of element in bits
    );

    wire [6:0] opcode = instr[6:0];
    wire [1:0] funct = instr[31:30];
    reg [4:0] rd;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [7:0] uimm;
    reg [10:0] zimm;
    reg [4:0] avl;          // application vector length - total # of elements to be processed
    reg [10:0] vtype;       // encodes vlmul and vsew

    always @(posedge clk or negedge nrst) begin
        if(!nrst) begin
            rd = 0;
            rs1 = 0;
            rs2 = 0;
            uimm = 0;
            zimm = 0;
        end else if (opcode == 7'b1010111) begin
            // Vector Configuration Instructions have a instr[6:0] = 1010111 opcode
            casez (funct)
                // vsetvl rd, rs1, rs2  (rd = new vl, rs1 = AVL, rs2 = new vtype value)
                2'b10: begin
                    rd = instr[11:7];
                    rs1 = instr[19:15];
                    rs2 = instr[24:20];
                end
                // vsetivli rd, uimm, vtypei (rd = new vl, uimm = AVL, vtypei = new vtype setting)
                2'b11: begin
                    rd = instr[11:7];
                    uimm = instr[19:15];
                    zimm = {1'b0, instr[29:20]};
                end
                // vsetvli rd, rs1, vtypei (rd = new vl, rs1 = AVL, vtypei = new vtype setting)
                2'b0?: begin
                    rd = instr[11:7];
                    rs1 = instr[19:15];
                    zimm = instr[30:20];
                end
                default: begin
                    rd = 0;
                    rs1 = 0;
                    rs2 = 0;
                    uimm = 0;
                    zimm = 0;
                end
            endcase
        end
    end

    assign vl = rd;
    assign avl = (funct == 2'b10 || funct == 2'b0x) ? rs1 : uimm;
    assign vtype = (funct == 2'b11 || funct == 2'b0x) ? zimm : {6'b0, rs2};
    assign vlmul = vtype[2:0];
    assign vsew = vtype[5:3];

endmodule

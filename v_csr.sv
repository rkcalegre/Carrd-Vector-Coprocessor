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
    input vconfig_wr_en,
    input [31:0] vl_in,
    input [31:0] vtype_in,

    output [31:0] vl_out,
    output [31:0] vtype_out

);

    logic [31:0] vl;
    logic [31:0] vtype;

    initial begin
        vl <= 0;
        vtype <= 0;
    end

    assign vl_out = vl;
    assign vtype_out = vtype;

    // write to vector control and status registers
    // there are 7 CSRs (vstart, vxsat, vxrm, vcsr, vtype, vl, and vlenb)
    // only vtype and vl are implemented for this project

    // vtype encoding
    // ==================================================================================== 
    // [5:3]  -----  vsew [2:0]   -----   selected element width (SEW) setting
    // [2:0]  -----  vlmul[2:0]   -----   vector register group multiplier (LMUL) setting
    // ====================================================================================
    always @(posedge clk) begin
        if (!nrst) begin
            vl <= 0;
            vtype <= 0;
        end else if (vconfig_wr_en) begin
            vl <= vl_in;
            vtype <= vtype_in;
        end
    end

endmodule
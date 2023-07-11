`timescale 1ns / 1ps

module async (
    input logic clk, async_nrst,
    output logic nrst
    );
    logic q1 = 1;
    logic q2 = 1;
/*     always @(posedge clk)
        if (!async_nrst) q1 <= async_nrst;
        else q1 <= 1'b1;
    always @(posedge clk)
        if (!async_nrst) q2 <= async_nrst;
        else q2 <= q1;
    always @(posedge clk)
        if (!async_nrst) nrst <= async_nrst;
        else nrst <= q2; */

    always @(posedge clk)
        if (!async_nrst) begin
            q1 <= 0;
            q2 <= 0;
            nrst <= 0;
        end else begin
            q1 <= 1'b1;
            q2 <= q1;
            nrst <= q2;
        end
endmodule
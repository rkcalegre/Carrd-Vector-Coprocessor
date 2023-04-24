`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2023 17:51:08
// Design Name: 
// Module Name: carrd_writeback
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


module carrd_writeback(
    input logic [5:0] v_alu_op,
    input logic [5:0] v_mul_op,
    input logic [5:0] v_lsu_op,
    input logic [5:0] v_sldu_op,
    input logic [5:0] v_red_op,
    input logic [31:0] result_vlsu,
    input logic [31:0] result_valu,
    input logic [31:0] result_vmul,
    input logic [511:0] result_vsldu,
    input logic [31:0] result_vred,
    output logic reg_wr_en,
    output logic el_wr_en,
    output logic [127:0]  reg_wr_data,
    output logic [127:0]  reg_wr_data_2,
    output logic [127:0]  reg_wr_data_3,
    output logic [127:0]  reg_wr_data_4

    );

    always @(*) begin

        case (v_alu_op)
            6'd0: ;
            default: begin
                reg_wr_en <= 1;
                reg_wr_data <= result_valu;
                reg_wr_data_2 <= result_valu;
                reg_wr_data_3 <= result_valu;
                reg_wr_data_4 <= result_valu;            
            end
        endcase

        case (v_mul_op)
            6'd0: ;
            default: begin
                reg_wr_en <= 1;
                reg_wr_data <= result_vmul;
                reg_wr_data_2 <= result_vmul;
                reg_wr_data_3 <= result_vmul;
                reg_wr_data_4 <= result_vmul;            
            end
        endcase

        case (v_lsu_op)
            6'd0: ;
            default: begin
                reg_wr_en <= 1;
                reg_wr_data <= result_vlsu;
                reg_wr_data_2 <= result_vlsu;
                reg_wr_data_3 <= result_vlsu;
                reg_wr_data_4 <= result_vlsu;           
            end
        endcase

        case (v_sldu_op)
            6'd0: ;
            default: begin
                reg_wr_en <= 1;
                reg_wr_data <= result_vsldu[127:0];
                reg_wr_data_2 <= result_vsldu[255:128];
                reg_wr_data_3 <= result_vsldu[383:256];
                reg_wr_data_4 <= result_vsldu[511:384];           
            end
        endcase

        case (v_red_op)
            6'd0: ;
            default: begin
                reg_wr_en <= 0;
                el_wr_en <= 1;
                reg_wr_data <= result_vred;
                reg_wr_data_2 <= {128{1'b0}};
                reg_wr_data_3 <= {128{1'b0}};
                reg_wr_data_4 <= {128{1'b0}};           
            end
        endcase

    end
    
endmodule

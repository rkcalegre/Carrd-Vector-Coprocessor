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
// Description: This block mimics the writeback stage of the pipelined processor.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module carrd_writeback(
    input clk,
    input [3:0] v_alu_op,
    input is_mul,
    input [3:0] v_lsu_op,
    input [2:0] v_sldu_op,
    input [2:0] v_red_op,
    input done_vlanes,
    input done_vred,
    input done_vsldu,
    input logic [31:0] result_vlsu,
    input logic [127:0] result_valu_1,
    input logic [127:0] result_valu_2,
    input logic [127:0] result_valu_3,
    input logic [127:0] result_valu_4,
    input logic [127:0] result_vmul_1,
    input logic [127:0] result_vmul_2,
    input logic [127:0] result_vmul_3,
    input logic [127:0] result_vmul_4,
    input logic [511:0] result_vsldu,
    input logic [31:0] result_vred,
    input logic [1:0] v_sel_dest,
    output logic v_reg_wr_en,
    output logic x_reg_wr_en,
    output logic el_wr_en,
    output logic [127:0]  reg_wr_data,
    output logic [127:0]  reg_wr_data_2,
    output logic [127:0]  reg_wr_data_3,
    output logic [127:0]  reg_wr_data_4

    );


    always @(clk) begin

        if (v_alu_op inside {[1:10]}) begin
            v_reg_wr_en = (v_sel_dest==1 && done_vlanes==1) ? 1: 0;
            x_reg_wr_en = (v_sel_dest==2 && done_vlanes==1) ? 1: 0;
            reg_wr_data = result_valu_1;
            reg_wr_data_2 = result_valu_2;
            reg_wr_data_3 = result_valu_3;
            reg_wr_data_4 = result_valu_4;             
        end else if (is_mul == 1) begin
            v_reg_wr_en = (v_sel_dest==1 && done_vlanes==1) ? 1: 0;
            x_reg_wr_en = (v_sel_dest==2 && done_vlanes==1) ? 1: 0;
            reg_wr_data = result_vmul_1;
            reg_wr_data_2 = result_vmul_2;
            reg_wr_data_3 = result_vmul_3;
            reg_wr_data_4 = result_vmul_4;              
        end else if (v_lsu_op inside {[1:12]}) begin
            v_reg_wr_en = (v_sel_dest==1) ? 1: 0;
            x_reg_wr_en = (v_sel_dest==2) ? 1: 0;
            reg_wr_data = result_vlsu;
            reg_wr_data_2 = result_vlsu;
            reg_wr_data_3 = result_vlsu;
            reg_wr_data_4 = result_vlsu;  
        end else if (v_sldu_op inside {[1:5]}) begin
            v_reg_wr_en = (v_sel_dest==1 && done_vsldu==1) ? 1: 0;
            x_reg_wr_en = (v_sel_dest==2 && done_vsldu==1) ? 1: 0;
            reg_wr_data = result_vsldu[127:0];
            reg_wr_data_2 = result_vsldu[255:128];
            reg_wr_data_3 = result_vsldu[383:256];
            reg_wr_data_4 = result_vsldu[511:384];  
        end else if (v_red_op inside {[1:2]}) begin
            v_reg_wr_en = (v_sel_dest==1 && done_vred==1) ? 1: 0;
            x_reg_wr_en = (v_sel_dest==2 && done_vred==1) ? 1: 0;
            //el_wr_en = 1;
            reg_wr_data = result_vred;
            reg_wr_data_2 = {128{1'b0}};
            reg_wr_data_3 = {128{1'b0}};
            reg_wr_data_4 = {128{1'b0}};   
        end else begin
            v_reg_wr_en = 0;
            x_reg_wr_en = 0;            
        end

//The following code were commented out and kept for reference
/*         if (v_alu_op inside {[1:10]}) begin
            v_reg_wr_en <= (v_sel_dest==1 && done_vlanes==1) ? 1: 0;
            x_reg_wr_en <= (v_sel_dest==2 && done_vlanes==1) ? 1: 0;
            reg_wr_data <= result_valu_1;
            reg_wr_data_2 <= result_valu_2;
            reg_wr_data_3 <= result_valu_3;
            reg_wr_data_4 <= result_valu_4;             
        end else if (is_mul == 1) begin
            v_reg_wr_en <= (v_sel_dest==1) ? 1: 0;
            x_reg_wr_en <= (v_sel_dest==2) ? 1: 0;
            reg_wr_data <= result_vmul_1;
            reg_wr_data_2 <= result_vmul_2;
            reg_wr_data_3 <= result_vmul_3;
            reg_wr_data_4 <= result_vmul_4;              
        end else if (v_lsu_op inside {[1:12]}) begin
            v_reg_wr_en <= (v_sel_dest==1) ? 1: 0;
            x_reg_wr_en <= (v_sel_dest==2) ? 1: 0;
            reg_wr_data <= result_vlsu;
            reg_wr_data_2 <= result_vlsu;
            reg_wr_data_3 <= result_vlsu;
            reg_wr_data_4 <= result_vlsu;  
        end else if (v_sldu_op inside {[1:5]}) begin
            v_reg_wr_en <= (v_sel_dest==1) ? 1: 0;
            x_reg_wr_en <= (v_sel_dest==2) ? 1: 0;
            reg_wr_data <= result_vsldu[127:0];
            reg_wr_data_2 <= result_vsldu[255:128];
            reg_wr_data_3 <= result_vsldu[383:256];
            reg_wr_data_4 <= result_vsldu[511:384];  
        end else if (v_red_op inside {1,2}) begin
            v_reg_wr_en <= (v_sel_dest==1 && done_vred==1) ? 1: 0;
            x_reg_wr_en <= (v_sel_dest==2 && done_vred==1) ? 1: 0;
            //el_wr_en <= 1;
            reg_wr_data <= result_vred;
            reg_wr_data_2 <= {128{1'b0}};
            reg_wr_data_3 <= {128{1'b0}};
            reg_wr_data_4 <= {128{1'b0}};   
        end else begin
            v_reg_wr_en <= 0;
            x_reg_wr_en <= 0;            
        end
 */
/*         if (v_alu_op!=0) begin
            v_reg_wr_en <= (v_sel_dest==1 && done_vlanes==1) ? 1: 0;
            x_reg_wr_en <= (v_sel_dest==2 && done_vlanes==1) ? 1: 0;
            reg_wr_data <= result_valu_1;
            reg_wr_data_2 <= result_valu_2;
            reg_wr_data_3 <= result_valu_3;
            reg_wr_data_4 <= result_valu_4;             
        end else if (is_mul == 1) begin
            v_reg_wr_en <= (v_sel_dest==1) ? 1: 0;
            x_reg_wr_en <= (v_sel_dest==2) ? 1: 0;
            reg_wr_data <= result_vmul_1;
            reg_wr_data_2 <= result_vmul_2;
            reg_wr_data_3 <= result_vmul_3;
            reg_wr_data_4 <= result_vmul_4;              
        end else if (v_lsu_op!=0) begin
            v_reg_wr_en <= (v_sel_dest==1) ? 1: 0;
            x_reg_wr_en <= (v_sel_dest==2) ? 1: 0;
            reg_wr_data <= result_vlsu;
            reg_wr_data_2 <= result_vlsu;
            reg_wr_data_3 <= result_vlsu;
            reg_wr_data_4 <= result_vlsu;  
        end else if (v_sldu_op!=0) begin
            v_reg_wr_en <= (v_sel_dest==1) ? 1: 0;
            x_reg_wr_en <= (v_sel_dest==2) ? 1: 0;
            reg_wr_data <= result_vsldu[127:0];
            reg_wr_data_2 <= result_vsldu[255:128];
            reg_wr_data_3 <= result_vsldu[383:256];
            reg_wr_data_4 <= result_vsldu[511:384];  
        end else if (v_red_op!=0) begin
            v_reg_wr_en <= (v_sel_dest==1 && done_vred==1) ? 1: 0;
            x_reg_wr_en <= (v_sel_dest==2 && done_vred==1) ? 1: 0;
            //el_wr_en <= 1;
            reg_wr_data <= result_vred;
            reg_wr_data_2 <= {128{1'b0}};
            reg_wr_data_3 <= {128{1'b0}};
            reg_wr_data_4 <= {128{1'b0}};   
        end else begin
            v_reg_wr_en <= 0;
            x_reg_wr_en <= 0;            
        end */

/*         case (v_alu_op)
            4'd0: ;
            default: begin
                v_reg_wr_en <= (v_sel_dest==1 && done_vlanes==1) ? 1: 0;
                x_reg_wr_en <= (v_sel_dest==2 && done_vlanes==1) ? 1: 0;
                reg_wr_data <= result_valu_1;
                reg_wr_data_2 <= result_valu_2;
                reg_wr_data_3 <= result_valu_3;
                reg_wr_data_4 <= result_valu_4;            
            end
        endcase

        case (is_mul)
            1'd1: begin
                v_reg_wr_en <= (v_sel_dest==1) ? 1: 0;
                x_reg_wr_en <= (v_sel_dest==2) ? 1: 0;
                reg_wr_data <= result_vmul_1;
                reg_wr_data_2 <= result_vmul_2;
                reg_wr_data_3 <= result_vmul_3;
                reg_wr_data_4 <= result_vmul_4;                   
            end
            default: ;
        endcase

        case (v_lsu_op)
            4'd0: ;
            default: begin
                v_reg_wr_en <= (v_sel_dest==1) ? 1: 0;
                x_reg_wr_en <= (v_sel_dest==2) ? 1: 0;
                reg_wr_data <= result_vlsu;
                reg_wr_data_2 <= result_vlsu;
                reg_wr_data_3 <= result_vlsu;
                reg_wr_data_4 <= result_vlsu;           
            end
        endcase

        case (v_sldu_op)
            3'd0: ;
            default: begin
                v_reg_wr_en <= (v_sel_dest==1) ? 1: 0;
                x_reg_wr_en <= (v_sel_dest==2) ? 1: 0;
                reg_wr_data <= result_vsldu[127:0];
                reg_wr_data_2 <= result_vsldu[255:128];
                reg_wr_data_3 <= result_vsldu[383:256];
                reg_wr_data_4 <= result_vsldu[511:384];           
            end
        endcase

        case (v_red_op)
            3'd0: ;

            default: begin
                v_reg_wr_en <= (v_sel_dest==1 && done_vred==1) ? 1: 0;
                x_reg_wr_en <= (v_sel_dest==2 && done_vred==1) ? 1: 0;
                //el_wr_en <= 1;
                reg_wr_data <= result_vred;
                reg_wr_data_2 <= {128{1'b0}};
                reg_wr_data_3 <= {128{1'b0}};
                reg_wr_data_4 <= {128{1'b0}};           
            end
        endcase */

    end
    
endmodule

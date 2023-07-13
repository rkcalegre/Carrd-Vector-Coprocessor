`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2023 11:22:01 PM
// Design Name: 
// Module Name: v_regfile
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
`include "constants.vh"

module v_regfile (

	input logic 				    			clk,
	input logic 				    			nrst,
    input logic [2:0]                           lmul,
    input logic [2:0]                           sew,

    //Element Write Ports
    input logic                 		        el_wr_en,
    input logic  [4:0]      		            el_wr_addr,
    input logic  [4:0]                          el_reg_wr_addr, 
    input logic  [127:0]                        el_wr_data,

    //Register Write Port
    input logic                                 reg_wr_en,
    input logic  [4:0]                          reg_wr_addr,
    input logic  [127:0]                        reg_wr_data,
    input logic  [127:0]                        reg_wr_data_2,
    input logic  [127:0]                        reg_wr_data_3,
    input logic  [127:0]                        reg_wr_data_4,

    //Element Read Ports
    input logic  [4:0]                          el_rd_addr_1,
    input logic  [4:0]                          el_rd_addr_2,
    input logic  [4:0]                          el_addr_1,
    input logic  [4:0]                          el_addr_2,
    input logic  [4:0]                          mask_src,

    output logic [31:0]                         el_data_out_1,
    output logic [31:0]                         el_data_out_2,
    output logic [127:0]                        mask,

    //Register Read Port
    input logic  [4:0]                          reg_rd_addr_v1,
    input logic  [4:0]                          reg_rd_addr_v2,


    output logic [127:0]                   reg_data_out_v1_a,
    output logic [127:0]                   reg_data_out_v1_b,
    output logic [127:0]                   reg_data_out_v1_c,
    output logic [127:0]                   reg_data_out_v1_d,

    
    output logic [127:0]                   reg_data_out_v2_a,
    output logic [127:0]                   reg_data_out_v2_b,
    output logic [127:0]                   reg_data_out_v2_c,
    output logic [127:0]                   reg_data_out_v2_d




);

    logic [`V_REGS-1:0][127:0]              regfile;
    logic [`V_REGS-1:0]                     el_reg_wr_addr_oh;
    logic [`V_REGS-1:0]                     reg_wr_addr_oh;
    logic [15:0]                            el_wr_addr_oh;


    // Convert to one-hot
    assign reg_wr_addr_oh = (1 << reg_wr_addr); // bitshift or convert to 2^reg_wr_addr into 32bits one hot encoding
    assign el_wr_addr_oh   = (1 << el_wr_addr); //  
    assign el_reg_wr_addr_oh   = (1 << el_reg_wr_addr); //
    
    //Store new Data
always_ff @(posedge clk or negedge nrst) begin : memManage
    //always_ff @(clk) begin : memManage

        if(!nrst) begin //reset regfile; set regfile to 0 
            for (int i = 0; i < `V_REGS; i++) begin
                regfile[i] <= 128'h0;
            end
        end else begin
            case (sew)
                3'b000: begin //TO EDIT SEW=8
                    
                    for (int k = 0; k < 5'd16; k++) begin
                        for (int i = 0; i < `V_REGS; i++) begin
                            if(reg_wr_addr_oh[i] && reg_wr_en) begin
                                case (lmul)
                                    default: regfile[i] <= reg_wr_data; //assign an a data on register lmul =1
                                    3'b00: regfile[i] <= reg_wr_data; //assign an a data on register lmul=1
                                    3'b01: begin
                                        regfile[i] <= reg_wr_data; //assign an a data on register lmul=2
                                        regfile[i+1] <= reg_wr_data_2; //assign an a data on register lmul=2 TO EDIT
                                    end
                                    3'b10: begin
                                        regfile[i] <= reg_wr_data; //assign an a data on register lmul=4
                                        regfile[i+1] <= reg_wr_data_2; //assign an a data on register lmul=4
                                        regfile[i+2] <= reg_wr_data_3; //assign an a data on register lmul=4
                                        regfile[i+3] <= reg_wr_data_4; //assign an a data on register lmul=4
                                    end
                                endcase 
                            end else if(el_wr_en && el_reg_wr_addr_oh[i] && el_wr_addr_oh[k]) begin
                                regfile[i][k*6'd8 +: 6'd8] <= el_wr_data[k*6'd8 +: 6'd8]; //assign element data to element
                            end
                        end
                    end

                end
                3'b001:  begin //TO EDIT SEW=16
                    
                    for (int k = 0; k < 5'd8; k++) begin
                        for (int i = 0; i < `V_REGS; i++) begin
                            if(reg_wr_addr_oh[i] && reg_wr_en) begin
                                case (lmul)
                                    default: regfile[i] <= reg_wr_data; //assign an a data on register lmul =1
                                    3'b00: regfile[i] <= reg_wr_data; //assign an a data on register lmul=1
                                    3'b01: begin
                                        regfile[i] <= reg_wr_data; //assign an a data on register lmul=2
                                        regfile[i+1] <= reg_wr_data_2; //assign an a data on register lmul=2 TO EDIT
                                    end
                                    3'b10: begin
                                        regfile[i] <= reg_wr_data; //assign an a data on register lmul=4
                                        regfile[i+1] <= reg_wr_data_2; //assign an a data on register lmul=4
                                        regfile[i+2] <= reg_wr_data_3; //assign an a data on register lmul=4
                                        regfile[i+3] <= reg_wr_data_4; //assign an a data on register lmul=4
                                    end
                                endcase 
                            end else if(el_wr_en && el_reg_wr_addr_oh[i] && el_wr_addr_oh[k]) begin
                                regfile[i][k*6'd16 +: 6'd16] <= el_wr_data[k*6'd16 +: 6'd16]; //assign element data to element
                            end
                        end
                    end

                end
                3'b010:  begin //TO EDIT SEW=32

                    for (int k = 0; k < 5'd4; k++) begin
                        for (int i = 0; i < `V_REGS; i++) begin
                            if(reg_wr_addr_oh[i] && reg_wr_en) begin
                                case (lmul)
                                    default: regfile[i] <= reg_wr_data; //assign an a data on register lmul =1
                                    3'b00: regfile[i] <= reg_wr_data; //assign an a data on register lmul=1
                                    3'b01: begin
                                        regfile[i] <= reg_wr_data; //assign an a data on register lmul=2
                                        regfile[i+1] <= reg_wr_data_2; //assign an a data on register lmul=2 TO EDIT
                                    end
                                    3'b10: begin
                                        regfile[i] <= reg_wr_data; //assign an a data on register lmul=4
                                        regfile[i+1] <= reg_wr_data_2; //assign an a data on register lmul=4
                                        regfile[i+2] <= reg_wr_data_3; //assign an a data on register lmul=4
                                        regfile[i+3] <= reg_wr_data_4; //assign an a data on register lmul=4
                                    end
                                endcase 
                            end else if(el_wr_en && el_reg_wr_addr_oh[i] && el_wr_addr_oh[k]) begin
                                regfile[i][k*6'd32 +: 6'd32] <= el_wr_data[k*6'd32 +: 6'd32]; //assign element data to element
                            end
                        end
                    end

                end
                default:  begin //TO EDIT SEW=8

                    for (int k = 0; k < 5'd16; k++) begin
                        for (int i = 0; i < `V_REGS; i++) begin
                            if(reg_wr_addr_oh[i] && reg_wr_en) begin
                                case (lmul)
                                    default: regfile[i] <= reg_wr_data; //assign an a data on register lmul =1
                                    3'b000: regfile[i] <= reg_wr_data; //assign an a data on register lmul=1
                                    3'b001: begin
                                        regfile[i] <= reg_wr_data; //assign an a data on register lmul=2
                                        regfile[i+1] <= reg_wr_data_2; //assign an a data on register lmul=2 TO EDIT
                                    end
                                    3'b010: begin
                                        regfile[i] <= reg_wr_data; //assign an a data on register lmul=4
                                        regfile[i+1] <= reg_wr_data_2; //assign an a data on register lmul=4
                                        regfile[i+2] <= reg_wr_data_3; //assign an a data on register lmul=4
                                        regfile[i+3] <= reg_wr_data_4; //assign an a data on register lmul=4
                                    end
                                endcase 
                            end else if(el_wr_en && el_reg_wr_addr_oh[i] && el_wr_addr_oh[k]) begin
                                regfile[i][k*6'd8 +: 6'd8] <= el_wr_data[k*6'd8 +: 6'd8]; //assign element data to element
                            end
                        end
                    end

                end
            endcase
        end
    end
    // Pick the Data and push them to the Output
        assign reg_data_out_v1_a = regfile[reg_rd_addr_v1];
        assign reg_data_out_v1_b = regfile[reg_rd_addr_v1 + 5'd1];
        assign reg_data_out_v1_c = regfile[reg_rd_addr_v1 + 5'd2];
        assign reg_data_out_v1_d = regfile[reg_rd_addr_v1 + 5'd3];

        assign reg_data_out_v2_a = regfile[reg_rd_addr_v2];
        assign reg_data_out_v2_b = regfile[reg_rd_addr_v2 + 5'd1];
        assign reg_data_out_v2_c = regfile[reg_rd_addr_v2 + 5'd2];
        assign reg_data_out_v2_d = regfile[reg_rd_addr_v2 + 5'd3];

    // assign reg_data_out_v1 = regfile[reg_rd_addr_v1];
    // assign reg_data_out_v2 = regfile[reg_rd_addr_v2];
    // assign reg_data_out_v3 = regfile[reg_rd_addr_v3];
    // assign reg_data_out_v4 = regfile[reg_rd_addr_v4];
    //assign el_data_out_1 = regfile[el_rd_addr_1][el_addr_1*sew +: sew];
    //assign el_data_out_2 = regfile[el_rd_addr_2][el_addr_2*sew +: sew];

    always_comb begin : DataOut
        case (sew)
            default: begin //TO EDIT SEW=8
                el_data_out_1 = regfile[el_rd_addr_1][el_addr_1*6'd8 +: 6'd8];
                el_data_out_2 = regfile[el_rd_addr_2][el_addr_2*6'd8 +: 6'd8];
            end 
            3'b00:begin //TO EDIT SEW=8
                el_data_out_1 = regfile[el_rd_addr_1][el_addr_1*6'd8 +: 6'd8];
                el_data_out_2 = regfile[el_rd_addr_2][el_addr_2*6'd8 +: 6'd8];                
            end
            3'b001:begin //TO EDIT SEW=16
                el_data_out_1 = regfile[el_rd_addr_1][el_addr_1*6'd16 +: 6'd16];
                el_data_out_2 = regfile[el_rd_addr_2][el_addr_2*6'd16 +: 6'd16];                
            end
            3'b010: begin //TO EDIT SEW=32
                el_data_out_1 = regfile[el_rd_addr_1][el_addr_1*6'd32 +: 6'd32];
                el_data_out_2 = regfile[el_rd_addr_2][el_addr_2*6'd32 +: 6'd32];                
            end
        endcase
    end 

    /**
    always_comb begin : DataOut
        for (int i = 0; i < `VL ; i++) begin // I<elements
            //el_data_out_1[i] <= regfile[el_rd_addr_1][i];
            //el_data_out_2[i] <= regfile[el_rd_addr_2][i];
            el_data_out_1[i*`SEW +: `SEW] <= regfile[el_rd_addr_1][i*`SEW +: `SEW];
            el_data_out_2[i*`SEW +: `SEW] <= regfile[el_rd_addr_2][i*`SEW +: `SEW];
            mask[i]       <= regfile[mask_src][i];
        end
        
        el_data_out_1 <= regfile[el_rd_addr_1][el_addr_1*`SEW +: `SEW];
        el_data_out_2 <= regfile[el_rd_addr_2][el_addr_2*`SEW +: `SEW];
    end 
    **/
endmodule

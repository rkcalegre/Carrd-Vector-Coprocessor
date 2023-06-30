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
    input bit [2:0] lmul,
    input bit [1:0] lanes,
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

    logic [127:0] result_valu_32b_1, result_valu_32b_2, result_valu_32b_3, result_valu_32b_4;
    logic [127:0] result_vmul_32b_1, result_vmul_32b_2, result_vmul_32b_3, result_vmul_32b_4;

	logic [127:0] alu_op_A_1, alu_op_A_2, alu_op_A_3, alu_op_A_4;
	logic [127:0] alu_op_B_1, alu_op_B_2, alu_op_B_3, alu_op_B_4;
	logic [127:0] mul_op_A_1, mul_op_A_2, mul_op_A_3, mul_op_A_4;
	logic [127:0] mul_op_B_1, mul_op_B_2, mul_op_B_3, mul_op_B_4;

    bit [2:0] step_alu, step_mul;

    initial begin
        result_valu_1 = 0 ;
        result_valu_2 = 0 ;
        result_valu_3 = 0 ;
        result_valu_4 = 0 ;
        result_vmul_1 = 0 ;
        result_vmul_2 = 0 ;
        result_vmul_3 = 0 ;
        result_vmul_4 = 0 ;
        done_valu = 0 ;
        done_vmul = 0 ;
    end

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin

            //ALU

            v_alu valu(
                .clk(~valu_clk),
                .nrst(nrst),
                .op_instr(op_instr_alu),
                .vsew(vsew),
                .op_A((step_alu == 3'd0)? alu_op_A_1[(i*32)+32-1:i*32] : (step_alu == 3'd1)? alu_op_A_2[(i*32)+32-1:i*32] : (step_alu == 3'd2)? alu_op_A_3[(i*32)+32-1:i*32] : (step_alu == 3'd3)? alu_op_A_4[(i*32)+32-1:i*32] : alu_op_A_1[(i*32)+32-1:i*32]),
                .op_B((step_alu == 3'd0)? alu_op_B_1[(i*32)+32-1:i*32] : (step_alu == 3'd1)? alu_op_B_2[(i*32)+32-1:i*32] : (step_alu == 3'd2)? alu_op_B_3[(i*32)+32-1:i*32] : (step_alu == 3'd3)? alu_op_B_4[(i*32)+32-1:i*32] : alu_op_B_1[(i*32)+32-1:i*32]),
                .result(result_valu_32b_1[(i*32)+32-1:i*32])

            );
            
            //MUL

            v_mul vmul(
                .clk(~vmul_clk),
                .nrst(nrst),
                .is_mul(is_mul),
                .sew(vsew),
                .op_A((step_mul == 3'd0)? mul_op_A_1[(i*32)+32-1:i*32] : (step_mul == 3'd1)? mul_op_A_2[(i*32)+32-1:i*32] : (step_mul == 3'd2)? mul_op_A_3[(i*32)+32-1:i*32] : (step_mul == 3'd3)? mul_op_A_4[(i*32)+32-1:i*32] : mul_op_A_1[(i*32)+32-1:i*32]),
                .op_B((step_mul == 3'd0)? mul_op_B_1[(i*32)+32-1:i*32] : (step_mul == 3'd1)? mul_op_B_2[(i*32)+32-1:i*32] : (step_mul == 3'd2)? mul_op_B_3[(i*32)+32-1:i*32] : (step_mul == 3'd3)? mul_op_B_4[(i*32)+32-1:i*32] : mul_op_B_1[(i*32)+32-1:i*32]),
                .result(result_vmul_32b_1[(i*32)+32-1:i*32])
            );


            always @(op_instr_alu, op_A_1_alu,op_A_2_alu,op_A_3_alu,op_A_4_alu,op_B_1_alu,op_B_2_alu,op_B_3_alu,op_B_4_alu) begin
                if (op_instr_alu inside {[1:10]}) begin
                    alu_op_A_1 = op_A_1_alu;
                    alu_op_A_2 = op_A_2_alu;
                    alu_op_A_3 = op_A_3_alu;
                    alu_op_A_4 = op_A_4_alu;
                    alu_op_B_1 = op_B_1_alu;
                    alu_op_B_2 = op_B_2_alu;
                    alu_op_B_3 = op_B_3_alu;
                    alu_op_B_4 = op_B_4_alu;
                    step_alu = 0;
                end else begin
                    step_alu = 0;
                    done_valu = 0;                     
                end
            end
            always @(is_mul, op_A_1_mul,op_A_2_mul,op_A_3_mul,op_A_4_mul,op_B_1_mul,op_B_2_mul,op_B_3_mul,op_B_4_mul) begin
                if (is_mul == 1) begin
                    mul_op_A_1 = op_A_1_mul;
                    mul_op_A_2 = op_A_2_mul;
                    mul_op_A_3 = op_A_3_mul;
                    mul_op_A_4 = op_A_4_mul;
                    mul_op_B_1 = op_B_1_mul;
                    mul_op_B_2 = op_B_2_mul;
                    mul_op_B_3 = op_B_3_mul;
                    mul_op_B_4 = op_B_4_mul;  
                    step_mul = 0;               
                end else begin
                    step_mul = 0;
                    done_vmul = 0;                     
                end               
            end
            
            always @(posedge valu_clk) begin 
            //always @(negedge clk) begin 
                case (step_alu)
                        3'd0: begin
                           result_valu_1[(i*32)+32-1:i*32] = result_valu_32b_1[(i*32)+32-1:i*32];
                            if (i == 3 && (op_instr_alu !=0)) begin
                                    // done_valu = (lanes == 2'b00 && lmul==3'b01)? 0: (lanes == 2'b00 && lmul==3'b10)? 0 : (lanes == 2'b01 && lmul==3'b10)? 0: 1; //LMUL==2'b11 returns 1
                                    // step_alu = (lanes == 2'b00 && lmul==3'b01)? 1: (lanes == 2'b00 && lmul==3'b10)? 2'd1 : (lanes == 2'b01 && lmul==3'b10)? 2'd2: 0;                                  
                                    step_alu = (lanes == 2'b00 && lmul==3'b01)? 3'd1: (lanes == 2'b00 && lmul==3'b10)? 3'd1 : (lanes == 2'b01 && lmul==3'b10)? 3'd2: 3'd4;                                  
                            end

                        end 
                        3'd1: begin
                            result_valu_2[(i*32)+32-1:i*32] = result_valu_32b_1[(i*32)+32-1:i*32];
                            if (i == 3 && (op_instr_alu !=0)) begin
                                    // done_valu = (lmul==2'b01)? 1: 0;
                                    // step_alu = (lmul==3'b10)? 2'd2 : 2'd0;                             
                                    step_alu = (lmul==3'b10)? 3'd2 : 3'd4;                             
                            end


                        end 
                        3'd2: begin
                            result_valu_3[(i*32)+32-1:i*32] = result_valu_32b_1[(i*32)+32-1:i*32];
                            if (i == 3 && (op_instr_alu !=0)) begin
                                // done_valu = (lanes == 2'b01 && lmul==3'b10)? 1:0;
                                // step_alu = (lanes == 2'b01 && lmul==3'b10)? 0: 2'd3;       
                                step_alu = (lanes == 2'b01 && lmul==3'b10)? 3'd4: 3'd3;       
                            end

                        end 
                        3'd3: begin
                            result_valu_4[(i*32)+32-1:i*32] = result_valu_32b_1[(i*32)+32-1:i*32];
                            if (i == 3 && (op_instr_alu !=0)) begin
                                // done_valu = (lmul==2'b10)? 1: 0;
                                // step_alu = 2'd0;                           
                                step_alu = 3'd4;                           
                            end

                        end
                        default: begin
                            if (op_instr_alu !=0) begin
                                done_valu = 1;
                                step_alu = 3'd0;
                                result_valu_1[(i*32)+32-1:i*32] = result_valu_32b_1[(i*32)+32-1:i*32];                                
                            end
                        end  
                endcase                                   
            end

            always @(posedge vmul_clk) begin 
            //always @(negedge clk) begin 
                case (step_mul)
                        3'd0: begin
                            if (i == 3 && (is_mul==1)) begin
                                    // done_vmul = (lanes == 2'b00 && lmul==3'b01)? 0: (lanes == 2'b00 && lmul==3'b10)? 0 : (lanes == 2'b01 && lmul==3'b10)? 0: 1; //LMUL==2'b11 returns 1
                                    // step_mul = (lanes == 2'b00 && lmul==3'b01)? 1: (lanes == 2'b00 && lmul==3'b10)? 2'd1 : (lanes == 2'b01 && lmul==3'b10)? 2'd2: 0;
                                    step_mul = (lanes == 2'b00 && lmul==3'b01)? 3'd1: (lanes == 2'b00 && lmul==3'b10)? 3'd1 : (lanes == 2'b01 && lmul==3'b10)? 3'd2: 3'd4;
                            end

                            result_vmul_1[(i*32)+32-1:i*32] = result_vmul_32b_1[(i*32)+32-1:i*32];
                        end 
                        3'd1: begin
                            if (i == 3 && (is_mul==1)) begin
                                    // done_vmul = (lmul==2'b01)? 1: 0;
                                    // step_mul = (lmul==3'b10)? 2'd2 : 2'd0;                             
                                    step_mul = (lmul==3'b10)? 3'd2 : 3'd4;                             
                            end

                            result_vmul_2[(i*32)+32-1:i*32] = result_vmul_32b_1[(i*32)+32-1:i*32];
                        end 
                        3'd2: begin
                            if (i == 3 && (is_mul==1)) begin
                                // done_vmul = (lanes == 2'b01 && lmul==3'b10)? 1:0;
                                // step_mul = (lanes == 2'b01 && lmul==3'b10)? 0: 2'd3;       
                                step_mul = (lanes == 2'b01 && lmul==3'b10)? 3'd4: 3'd3;       
                            end

                            result_vmul_3[(i*32)+32-1:i*32] = result_vmul_32b_1[(i*32)+32-1:i*32];  
                        end 
                        3'd3: begin
                            if (i == 3 && (is_mul==1)) begin
                                // done_vmul = (lmul==2'b10)? 1: 0;
                                // step_mul = 2'd0;                           
                                step_mul = 3'd4;                           
                            end

                            result_vmul_4[(i*32)+32-1:i*32] = result_vmul_32b_1[(i*32)+32-1:i*32];
                        end
                        default: begin
                            if (is_mul==1) begin
                                done_vmul = 1;
                                step_mul = 3'd0;                            
                                result_vmul_1[(i*32)+32-1:i*32] = result_vmul_32b_1[(i*32)+32-1:i*32];
                            end

                        end 
                endcase                                     
            end
        end

        for (i = 4; i < 8; i++) begin

            //ALU

            v_alu valu(
                .clk((lanes == 0 )? 0 : ~valu_clk),
                .nrst(nrst),
                .op_instr(op_instr_alu),
                .vsew(vsew),
                .op_A((step_alu == 3'd2)? alu_op_A_4[((i-4)*32)+32-1:(i-4)*32] : alu_op_A_2[((i-4)*32)+32-1:(i-4)*32]),
                .op_B((step_alu == 3'd2)? alu_op_B_4[((i-4)*32)+32-1:(i-4)*32] : alu_op_B_2[((i-4)*32)+32-1:(i-4)*32]),
                .result(result_valu_32b_2[((i-4)*32)+32-1:(i-4)*32])

            );

            //MUL

            v_mul vmul(
                .clk((lanes == 0 )? 0 : ~vmul_clk),
                .nrst(nrst),
                .is_mul(is_mul),
                .sew(vsew),
                .op_A((step_mul == 3'd2)? mul_op_A_4[((i-4)*32)+32-1:(i-4)*32] : mul_op_A_2[((i-4)*32)+32-1:(i-4)*32]),
                .op_B((step_mul == 3'd2)? mul_op_B_4[((i-4)*32)+32-1:(i-4)*32] : mul_op_B_2[((i-4)*32)+32-1:(i-4)*32]),
                .result(result_vmul_32b_2[((i-4)*32)+32-1:(i-4)*32])
            );

            //always @(result_valu_32b_2, posedge valu_clk) begin
            always @(valu_clk) begin
                if ((lanes == 2'b01) || (lanes == 2'b10)&& (op_instr_alu inside {[1:10]})) begin
                    case (step_alu)
                            3'd0: begin
                                result_valu_2[((i-4)*32)+32-1:(i-4)*32] = result_valu_32b_2[((i-4)*32)+32-1:(i-4)*32]; 
                            end 
                            3'd2: begin
                                result_valu_4[((i-4)*32)+32-1:(i-4)*32] = result_valu_32b_2[((i-4)*32)+32-1:(i-4)*32];                        
                            end
                            default: result_valu_2[((i-4)*32)+32-1:(i-4)*32] = result_valu_32b_2[((i-4)*32)+32-1:(i-4)*32] ;
                    endcase                        
                end else begin
                    //if (op_instr_alu ==0) result_valu_2[((i-4)*32)+32-1:(i-4)*32] = 0;
                end     
            end

            //always @(result_vmul_32b_2, posedge vmul_clk) begin
            always @(vmul_clk) begin
                if ((lanes == 2'b01) || (lanes == 2'b10) && is_mul == 1) begin    
                    case (step_mul)
                            2'd0: begin
                                result_vmul_2[((i-4)*32)+32-1:(i-4)*32] = result_vmul_32b_2[((i-4)*32)+32-1:(i-4)*32];
                            end 
                            2'd2: begin
                                result_vmul_4[((i-4)*32)+32-1:(i-4)*32] = result_vmul_32b_2[((i-4)*32)+32-1:(i-4)*32];
                            end
                            default: result_vmul_2[((i-4)*32)+32-1:(i-4)*32] = result_vmul_32b_2[((i-4)*32)+32-1:(i-4)*32];
                    endcase                    
                end else begin
                    //if (is_mul ==0) result_vmul_2[((i-4)*32)+32-1:(i-4)*32] = 0;
                end 
            end
        end

    endgenerate



    //genvar i;
    generate
        for (i = 8; i < 12; i++) begin

            //ALU

            v_alu valu(
                .clk((lanes == 0 )? 0 :(lanes == 1 )? 0 : ~valu_clk),
                .nrst(nrst),
                .op_instr(op_instr_alu),
                .vsew(vsew),
                .op_A(alu_op_A_3[((i-8)*32)+32-1:(i-8)*32]),
                .op_B(alu_op_B_3[((i-8)*32)+32-1:(i-8)*32]),
                .result(result_valu_32b_3[((i-8)*32)+32-1:(i-8)*32])

            );

            //MUL

            v_mul vmul(
                .clk((lanes == 0 )? 0 :(lanes == 1 )? 0 : ~vmul_clk),
                .nrst(nrst),
                .is_mul(is_mul),
                .sew(vsew),
                .op_A(mul_op_A_3[((i-8)*32)+32-1:(i-8)*32]),
                .op_B(mul_op_B_3[((i-8)*32)+32-1:(i-8)*32]),
                .result(result_vmul_32b_3[((i-8)*32)+32-1:(i-8)*32])
            );
            
            always @(valu_clk) begin
                if ((lanes == 2'b10) && (op_instr_alu inside {[1:10]})) begin
                    result_valu_3[((i-8)*32)+32-1:(i-8)*32] = result_valu_32b_3[((i-8)*32)+32-1:(i-8)*32];                                            
                end
            end

            always @(vmul_clk) begin
                if ((lanes == 2'b10) && is_mul == 1) begin    
                    result_vmul_3[((i-8)*32)+32-1:(i-8)*32] = result_vmul_32b_3[((i-8)*32)+32-1:(i-8)*32];
                end
        end

        end

        for (i = 12; i < 16; i++) begin

            //ALU

            v_alu valu(
                .clk((lanes == 0 )? 0 :(lanes == 1 )? 0 : ~valu_clk),
                .nrst(nrst),
                .op_instr(op_instr_alu),
                .vsew(vsew),
                .op_A(alu_op_A_4[((i-12)*32)+32-1:(i-12)*32]),
                .op_B(alu_op_B_4[((i-12)*32)+32-1:(i-12)*32]),
                .result(result_valu_32b_4[((i-12)*32)+32-1:(i-12)*32])

            );

            //MUL

            v_mul vmul(
                .clk((lanes == 0 )? 0 :(lanes == 1 )? 0 : ~vmul_clk),
                .nrst(nrst),
                .is_mul(is_mul),
                .sew(vsew),
                .op_A(mul_op_A_4[((i-12)*32)+32-1:(i-12)*32]),
                .op_B(mul_op_B_4[((i-12)*32)+32-1:(i-12)*32]),
                .result(result_vmul_32b_4[((i-12)*32)+32-1:(i-12)*32])
            );
            always @(valu_clk) begin
                if ((lanes == 2'b10) && (op_instr_alu inside {[1:10]})) begin
                    result_valu_4[((i-12)*32)+32-1:(i-12)*32] = result_valu_32b_4[((i-12)*32)+32-1:(i-12)*32];                                            
                end
            end

            always @(vmul_clk) begin
                if ((lanes == 2'b10) && is_mul == 1) begin    
                    result_vmul_4[((i-12)*32)+32-1:(i-12)*32] = result_vmul_32b_4[((i-12)*32)+32-1:(i-12)*32];
                end
            end

        end        
    endgenerate


endmodule

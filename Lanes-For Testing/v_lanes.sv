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
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module v_lanes(
    input logic clk,
    input logic nrst,
    input logic [5:0] op_instr_alu,
    input logic [5:0] op_instr_mul,
    input logic [2:0] vsew,
    input logic [2:0] lmul,
    input logic [1:0] lanes,
    // output logic [31:0] result_valu,
    // output logic [31:0] result_vmul,
    output logic [127:0] result_valu_1,
    output logic [127:0] result_vmul_1,
    output logic [127:0] result_valu_2,
    output logic [127:0] result_vmul_2,
    output logic [127:0] result_valu_3,
    output logic [127:0] result_vmul_3,
    output logic [127:0] result_valu_4,
    output logic [127:0] result_vmul_4,
    output logic done,

	input logic [127:0] op_A_1,
	input logic [127:0] op_A_2,
	input logic [127:0] op_A_3,
	input logic [127:0] op_A_4,

    input logic [127:0] op_B_1,
	input logic [127:0] op_B_2,
	input logic [127:0] op_B_3,
	input logic [127:0] op_B_4

    );
    //with name conflict with input
    // logic [31:0] op_A_0;
    // logic [31:0] op_B_0;  
    // logic [31:0] op_A_1;
    // logic [31:0] op_B_1;  
    // logic [31:0] op_A_2;
    // logic [31:0] op_B_2;  
    // logic [31:0] op_A_3;
    // logic [31:0] op_B_3;  
    // logic [31:0] op_A_4;
    // logic [31:0] op_B_4;  
    // logic [31:0] op_A_5;
    // logic [31:0] op_B_5;  
    // logic [31:0] op_A_6;
    // logic [31:0] op_B_6;  
    // logic [31:0] op_A_7;
    // logic [31:0] op_B_7;  
    // logic [31:0] op_A_8;
    // logic [31:0] op_B_8;  
    // logic [31:0] op_A_9;
    // logic [31:0] op_B_9;  
    // logic [31:0] op_A_10;
    // logic [31:0] op_B_10;  
    // logic [31:0] op_A_11;
    // logic [31:0] op_B_11;  
    // logic [31:0] op_A_12;
    // logic [31:0] op_B_12;  
    // logic [31:0] op_A_13;
    // logic [31:0] op_B_13;  
    // logic [31:0] op_A_14;
    // logic [31:0] op_B_14;  
    // logic [31:0] op_A_15;
    // logic [31:0] op_B_15;      


    // logic [31:0] op_A;
    // logic [31:0] op_B;

    logic [31:0] result_valu_32b_1;
    logic [31:0] result_vmul_32b_1;
    logic [31:0] result_valu_32b_2;
    logic [31:0] result_vmul_32b_2;

/*     //Control Unit
    case (lmul)
        default: ;
        3'b00: begin //LMUL = 1 1 clock cycle
            case (lane)
                : 
                default: 
            endcase
        end
        3'b01: begin //LMUL = 2 1 clock cycle
            case (lane)
                3'b00: //Lane = 4 CC = 2
                3'b01: //Lane = 8 CC = 1
                3'b10: //Lane = 16 CC = 1
                default: 
            endcase
        end
        3'b00: begin //LMUL = 1 1 clock cycle
            case (lane)
                3'b00: //Lane = 4 CC = 4
                3'b01: //Lane = 8 CC = 2
                3'b10: //Lane = 16 CC = 1
                default: 
            endcase
        end        
    endcase */

    logic [1:0] step = 0;  



    genvar i;
    generate
        for (i = 0; i < 4; i++) begin

            //ALU

            v_alu valu(
                .clk(clk),
                .nrst(nrst),
                .op_instr(op_instr_alu),
                .vsew(vsew),
                .op_A((step == 2'd0)? op_A_1[(i*32)+32-1:i*32] : (step == 2'd1)? op_A_2[(i*32)+32-1:i*32] : (step == 2'd2)? op_A_3[(i*32)+32-1:i*32] : op_A_4[(i*32)+32-1:i*32]),
                .op_B((step == 2'd0)? op_B_1[(i*32)+32-1:i*32] : (step == 2'd1)? op_B_2[(i*32)+32-1:i*32] : (step == 2'd2)? op_B_3[(i*32)+32-1:i*32] : op_B_4[(i*32)+32-1:i*32]),
                .result(result_valu_32b_1)

            );
            
/*             case (step)
                2'd0: assign result_valu_1[(i*32)+32-1:i*32] = result_valu_32b_1;
                2'd1: assign result_valu_2[(i*32)+32-1:i*32] = result_valu_32b_1;
                2'd2: assign result_valu_3[(i*32)+32-1:i*32] = result_valu_32b_1;
                2'd3: assign result_valu_4[(i*32)+32-1:i*32] = result_valu_32b_1;
            endcase */


            // assign result_valu_1[(i*32)+32-1:i*32] = (step == 2'd0)? result_valu_32b_1 : ;
            // assign result_valu_2[(i*32)+32-1:i*32] = (step == 2'd1)? result_valu_32b_1 : ;
            // assign result_valu_3[(i*32)+32-1:i*32] = (step == 2'd2)? result_valu_32b_1 : ;
            // assign result_valu_4[(i*32)+32-1:i*32] = (step == 2'd3)? result_valu_32b_1 : ;
            //MUL

            v_mul vmul(
                .clk(clk),
                .nrst(nrst),
                .op_instr(op_instr_mul),
                .sew(vsew),
                .op_A((step == 2'd0)? op_A_1[(i*32)+32-1:i*32] : (step == 2'd1)? op_A_2[(i*32)+32-1:i*32] : (step == 2'd2)? op_A_3[(i*32)+32-1:i*32] : op_A_4[(i*32)+32-1:i*32]),
                .op_B((step == 2'd0)? op_B_1[(i*32)+32-1:i*32] : (step == 2'd1)? op_B_2[(i*32)+32-1:i*32] : (step == 2'd2)? op_B_3[(i*32)+32-1:i*32] : op_B_4[(i*32)+32-1:i*32]),
                //.op_B((step == 2'd0)? op_B_1[(i*32)+32-1:i*32] : (step == 2'd1)? op_B_2[(i*32)+32-1:i*32] : (step == 2'd2)? op_B_3[(i*32)+32-1:i*32] : (step == 2'd3)? op_B_3[(i*32)+32-1:i*32]),
                .result(result_vmul_32b_1)
            );


            //always @(step,result_valu_32b_1,result_vmul_32b_1) begin 
            always @(posedge clk) begin 
                case (step)
                        2'd0: begin
                            result_vmul_1[(i*32)+32-1:i*32] = result_vmul_32b_1;
                            result_valu_1[(i*32)+32-1:i*32] = result_valu_32b_1;
                            done = (lanes == 2'b00 && lmul==3'b01)? 0: (lanes == 2'b00 && lmul==3'b10)? 0 : 1; //LMUL==2'b11 returns 1
                            //done = 0;
                            step = (lanes == 2'b00 && lmul==3'b01)? 1: (lanes == 2'b00 && lmul==3'b10)? 1 : 0;
                        end 
                        2'd1: begin
                            result_vmul_2[(i*32)+32-1:i*32] = result_vmul_32b_1;
                            result_valu_2[(i*32)+32-1:i*32] = result_valu_32b_1;
                            done = (lmul==3'b01)? 1: 0;
                            step = (lmul==3'b10)? 2'd2 : 2'd0;
                        end 
                        2'd2: begin
                            result_vmul_3[(i*32)+32-1:i*32] = result_vmul_32b_1;
                            result_valu_3[(i*32)+32-1:i*32] = result_valu_32b_1;
                            done = 0;
                            step = 2'd3;
                        end 
                        2'd3: begin
                            result_vmul_4[(i*32)+32-1:i*32] = result_vmul_32b_1;
                            result_valu_4[(i*32)+32-1:i*32] = result_valu_32b_1;
                            done = (lmul==3'b10)? 1: 0;
                            step = 2'd0;
                        end
                endcase                                  
 
            end

/*             always @(step,result_valu_32b_1,result_vmul_32b_1) begin //WORKING
                case (step)
                        2'd0: result_vmul_1[(i*32)+32-1:i*32] = result_vmul_32b_1;
                        2'd1: result_vmul_2[(i*32)+32-1:i*32] = result_vmul_32b_1;
                        2'd2: result_vmul_3[(i*32)+32-1:i*32] = result_vmul_32b_1;
                        2'd3: result_vmul_4[(i*32)+32-1:i*32] = result_vmul_32b_1;
                    endcase  
                              
                case (step)
                        2'd0: result_valu_1[(i*32)+32-1:i*32] = result_valu_32b_1;
                        2'd1: result_valu_2[(i*32)+32-1:i*32] = result_valu_32b_1;
                        2'd2: result_valu_3[(i*32)+32-1:i*32] = result_valu_32b_1;
                        2'd3: result_valu_4[(i*32)+32-1:i*32] = result_valu_32b_1;
                endcase                               
            end */


/*            case (step)
                2'd0: assign result_vmul_1[(i*32)+32-1:i*32] = result_vmul_32b_1;
                2'd1: assign result_vmul_2[(i*32)+32-1:i*32] = result_vmul_32b_1;
                2'd2: assign result_vmul_3[(i*32)+32-1:i*32] = result_vmul_32b_1;
                2'd3: assign result_vmul_4[(i*32)+32-1:i*32] = result_vmul_32b_1;
            endcase */


            // assign result_vmul_1[(i*32)+32-1:i*32] = (step == 2'd0)? result_vmul_32b_1 : ;
            // assign result_vmul_2[(i*32)+32-1:i*32] = (step == 2'd1)? result_vmul_32b_1 : ;
            // assign result_vmul_3[(i*32)+32-1:i*32] = (step == 2'd2)? result_vmul_32b_1 : ;
            // assign result_vmul_4[(i*32)+32-1:i*32] = (step == 2'd3)? result_vmul_32b_1 : ;           
        end
    endgenerate

    //genvar i;
    generate
        for (i = 4; i < 8; i++) begin

            //ALU

            v_alu valu(
                .clk(clk),
                .nrst(nrst),
                .op_instr(op_instr_alu),
                .vsew(vsew),
                .op_A((step == 2'd0)? op_A_2[((i-4)*32)+32-1:(i-4)*32] : op_A_4[((i-4)*32)+32-1:(i-4)*32]),
                .op_B((step == 2'd0)? op_B_2[((i-4)*32)+32-1:(i-4)*32] : op_B_4[((i-4)*32)+32-1:(i-4)*32]),
                .result(result_valu_32b_2)

            );
            // assign result_valu_2[((i-4)*32)+32-1:(i-4)*32] = (step == 2'd0)? result_valu_32b_2 : ;
            // assign result_valu_4[((i-4)*32)+32-1:(i-4)*32] = (step == 2'd1)? result_valu_32b_2 : ;

            //MUL

            v_mul vmul(
                .clk(clk),
                .nrst(nrst),
                .op_instr(op_instr_mul),
                .sew(vsew),
                .op_A((step == 2'd0)? op_A_2[((i-4)*32)+32-1:(i-4)*32] : op_A_4[((i-4)*32)+32-1:(i-4)*32]),
                .op_B((step == 2'd0)? op_B_2[((i-4)*32)+32-1:(i-4)*32] : op_B_4[((i-4)*32)+32-1:(i-4)*32]),
                .result(result_vmul_32b_2)
            );
            // assign result_vmul_2[((i-4)*32)+32-1:(i-4)*32] = (step == 2'd0)? result_vmul_32b_2 : ;
            // assign result_vmul_4[((i-4)*32)+32-1:(i-4)*32] = (step == 2'd1)? result_vmul_32b_2 : ;

            always @(step,result_valu_32b_2,result_vmul_32b_2) begin
                case (step)
                        2'd0: begin
                            result_vmul_2[((i-4)*32)+32-1:(i-4)*32] = result_vmul_32b_2;
                            result_valu_2[((i-4)*32)+32-1:(i-4)*32] = result_valu_32b_2; 
                        end 
                        2'd1: begin
                            result_vmul_4[((i-4)*32)+32-1:(i-4)*32] = result_vmul_32b_1;
                            result_valu_4[((i-4)*32)+32-1:(i-4)*32] = result_valu_32b_1;
                        end
                        default: ;
                    endcase  
                               
            end

        end
    endgenerate

    //genvar i;
    generate
        for (i = 8; i < 12; i++) begin

            //ALU

            v_alu valu(
                .clk(clk),
                .nrst(nrst),
                .op_instr(op_instr_alu),
                .vsew(vsew),
                .op_A(op_A_3[((i-8)*32)+32-1:(i-8)*32]),
                .op_B(op_B_3[((i-8)*32)+32-1:(i-8)*32]),
                .result(result_valu_3[((i-8)*32)+32-1:(i-8)*32])

            );

            //MUL

            v_mul vmul(
                .clk(clk),
                .nrst(nrst),
                .op_instr(op_instr_mul),
                .sew(vsew),
                .op_A(op_A_3[((i-8)*32)+32-1:(i-8)*32]),
                .op_B(op_B_3[((i-8)*32)+32-1:(i-8)*32]),
                .result(result_vmul_3[((i-8)*32)+32-1:(i-8)*32])
            );
        end
    endgenerate

    //genvar i;
    generate
        for (i = 12; i < 16; i++) begin

            //ALU

            v_alu valu(
                .clk(clk),
                .nrst(nrst),
                .op_instr(op_instr_alu),
                .vsew(vsew),
                .op_A(op_A_4[((i-12)*32)+32-1:(i-12)*32]),
                .op_B(op_B_4[((i-12)*32)+32-1:(i-12)*32]),
                .result(result_valu_4[((i-12)*32)+32-1:(i-12)*32])

            );

            //MUL

            v_mul vmul(
                .clk(clk),
                .nrst(nrst),
                .op_instr(op_instr_mul),
                .sew(vsew),
                .op_A(op_A_4[((i-12)*32)+32-1:(i-12)*32]),
                .op_B(op_B_4[((i-12)*32)+32-1:(i-12)*32]),
                .result(result_vmul_4[((i-12)*32)+32-1:(i-12)*32])
            );
        end
    endgenerate

/*     genvar i;
    generate
        for (i = 0; i < 4; i++) begin

            //ALU

            v_alu valu(
                .clk(clk),
                .nrst(nrst),
                .op_instr(op_instr_alu),
                .vsew(vsew),
                .op_A(op_A_1[(i*32)+32-1:i*32]),
                .op_B(op_B_1[(i*32)+32-1:i*32]),
                .result(result_valu_1[(i*32)+32-1:i*32])

            );

            //MUL

            v_mul vmul(
                .clk(clk),
                .nrst(nrst),
                .op_instr(op_instr_mul),
                .sew(vsew),
                .op_A(op_A_1[(i*32)+32-1:i*32]),
                .op_B(op_B_1[(i*32)+32-1:i*32]),
                .result(result_vmul_1[(i*32)+32-1:i*32])
            );
        end
    endgenerate
 */

/*     //ALU

    v_alu valu(
        .clk(clk),
        .nrst(nrst),
        .op_instr(op_instr),
        .vsew(vsew),
        .op_A(op_A),
        .op_B(op_B),
        .result(result_valu)

    );

    //MUL

    v_mul vmul(
        .clk(clk),
        .nrst(nrst),
        .op_instr(op_instr),
        .sew(vsew),
        .op_A(op_A),
        .op_B(op_B),
        .result(result_vmul)
    ); */



endmodule

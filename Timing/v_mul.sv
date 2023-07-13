`timescale 1ns / 1ps

module v_mul
(
	
	input clk,
	input nrst,
	input is_mul,
    input logic [31:0] op_A,
    input logic [31:0] op_B,
	input logic [1:0] sew,
	input logic [5:0] op_instr,
	output logic [31:0] result //change based on meet
);


	logic [63:0] mult_32_0_out;
	logic [31:0] result2;
	logic [31:0] result1;
	logic [31:0] mult_16_0_out;
	logic [31:0] mult_16_1_out;
	logic [31:0] mult_16_2_out;
	logic [7:0] mult_8_0_out;
	logic [7:0] mult_8_1_out;
	logic [31:0] op_B_u;
	logic [31:0] op_A_u;
	logic sign;

	assign mult_32_0 = 1'b1;
	assign mult_32_2 = sew == 2'b10 ? 1'b1: 1'b0;
	assign mult_8_0 = (sew==2'b00) ? 1'b1:1'b0;
	assign mult_8_1 = (sew==2'b00) ? 1'b1:1'b0;
	assign sign = op_A[31] ^ op_B[31];

	assign op_A_u = ({32{op_A[31]}} ^ op_A) + op_A[31];
	assign op_B_u = ({32{op_B[31]}} ^ op_B) + op_B[31];




	mult_gen_16 mult_gen_16_00(
		.CLK(clk),
		.CE(mult_32_0),
		.A((sew==2'b00) ? {{8{op_A[7]}},{op_A[7:0]}}: (sew == 2'b01) ? op_A[15:0]: op_A_u[15:0]),
		.B((sew==2'b00) ? {{8{op_B[7]}},{op_B[7:0]}}: (sew == 2'b01) ? op_B[15:0]: op_B_u[15:0]),
		.P(mult_16_0_out)
	); 	
	///////
 	mult_gen_16 mult_gen_16_01(
		.CLK(clk),
		.CE(mult_32_0),
		.A((sew==2'b00) ? {{8{op_A[15]}},{op_A[15:8]}}: (sew == 2'b01) ? op_A[31:16]: op_A_u[31:16]),
		.B((sew==2'b00) ? {{8{op_B[15]}},{op_B[15:8]}}: (sew == 2'b01) ? op_B[31:16]: op_B_u[15:0]),
		.P(mult_16_1_out)
	);

	mult_gen_16 mult_gen_16_02(
		.CLK(clk),
		.CE(mult_32_2),
		.A(op_B_u[31:16]),
		.B(op_A_u[15:0]),
		.P(mult_16_2_out)
	);
/* 	
 	mult_gen_32 mult_gen_32_00(
		.CLK(clk),
		.CE(mult_32_0),
		.A((sew==2'b00) ? {{24{op_A[7]}},{op_A[7:0]}}: ((sew==2'b01) ? {{16{op_A[15]}},{op_A[15:0]}}:(op_A[31:0]))),
		.B(((sew==2'b00) ? {{24{op_B[7]}},{op_B[7:0]}}: ((sew==2'b01) ? {{16{op_B[15]}},{op_B[15:0]}}:(op_B[31:0])))),
		.P(mult_32_0_out)
	); 
	mult_gen_16 mult_gen_16_00(
		.CLK(clk),
		.CE(mult_16_0),
		.A((sew==2'b00) ? {{8{op_A[15]}},{op_A[15:8]}}: op_A[31:16]),
		.B((sew==2'b00) ? {{8{op_B[15]}},{op_B[15:8]}}: op_B[31:16]),
		.P(mult_16_0_out)
	); */
	
	/// 
	
	mult_gen_8 mult_gen_8_00(
		.CLK(clk),
		.CE(mult_8_0),
		.A(op_A[23:16]),
		.B(op_B[23:16]),
		.P(mult_8_0_out)
	);
	mult_gen_8 mult_gen_8_01(
		.CLK(clk),
		.CE(mult_8_1),
		.A(op_A[31:24]),
		.B(op_B[31:24]),
		.P(mult_8_1_out)
	);
	
	always_comb begin 
        if (is_mul == 1) begin
            case (sew)
                2'b00:
                    //result = {mult_8_1_out [7:0], mult_8_0_out [7:0], mult_16_0_out [7:0], mult_32_0_out[7:0]};
                    result = {mult_8_1_out [7:0], mult_8_0_out [7:0], mult_16_1_out [7:0], mult_16_0_out[7:0]};
                2'b01:
                    //result = {mult_16_0_out[15:0],mult_32_0_out[15:0]};
                    result = {mult_16_1_out[15:0],mult_16_0_out[15:0]};
                2'b10: begin
                    //result = mult_32_0_out;
                    //result = mult_16_0_out + mult_16_1_out;
                    result1 = mult_16_1_out + mult_16_2_out;
                    result2 = {{result1[15:0]}, {16{1'b0}}}  + mult_16_0_out;
                    //result = result2 + mult_16_0_out;
                    result = ({32{sign}} ^ result2) + sign;
                end
                default:
                    result = 0;
            endcase      
        end else begin
            result = 0;
        end
	end
endmodule
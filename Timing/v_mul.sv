`timescale 1ns / 1ps


module v_mul
(
	
	input clk,
	input nrst,
    input logic [31:0] op_A,
    input logic [31:0] op_B,
	input logic [2:0] sew,
	input logic is_mul,
	output logic [31:0] result //change based on meet
);


	logic [31:0] mult_32_0_out;
	logic [15:0] mult_16_0_out;
	logic [7:0] mult_8_0_out;
	logic [7:0] mult_8_1_out;
    logic [31:0] opA_32;
    logic [31:0] opB_32;

	assign mult_32_0 = 1'b1;
	assign mult_16_0 = (sew == 3'b000 || sew == 2'b001) ? 1'b1:1'b0;
	assign mult_8_0 = (sew == 3'b000) ? 1'b1:1'b0;
	assign mult_8_1 = (sew == 3'b000) ? 1'b1:1'b0;


    always_comb begin
        case (sew)  
            3'b000: begin
                opA_32 = {{24{op_A[7]}},{op_A[7:0]}};
                opB_32 =  {{24{op_B[7]}},{op_B[7:0]}};
            end
            3'b001: begin
                opA_32 = {{16{op_A[15]}},{op_A[15:0]}};
                opB_32 =  {{16{op_B[15]}},{op_B[15:0]}};
            end
            default: begin
                opA_32 = op_A;
                opB_32 = op_B;
            end
        endcase
    end
	mult_gen_32 mult_gen_32_00(
		.CLK(clk),
		.CE(mult_32_0),
		.A(opA_32),
		.B(opB_32),
		.P(mult_32_0_out)
	);
	///////
	mult_gen_16 mult_gen_16_00(
		.CLK(clk),
		.CE(mult_16_0),
		.A((sew==3'b000) ? {{8{op_A[15]}},{op_A[15:8]}}: op_A[31:16]),
		.B(((sew==3'b000) ? {{8{op_B[15]}},{op_B[15:8]}}: op_B[31:16])),
		.P(mult_16_0_out)
	);
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
		case (is_mul)
			1'b1: begin //VMUL
				case (sew)
					3'b000:
						result = {mult_8_1_out [7:0], mult_8_0_out [7:0], mult_16_0_out [7:0], mult_32_0_out[7:0]};
					3'b001:
						result = {mult_16_0_out [15:0],mult_32_0_out[15:0]};
					3'b010:
						result = mult_32_0_out[31:0];
					default:
						result = 0;
				endcase
			end
			default: result = 0;
		endcase
	end


endmodule

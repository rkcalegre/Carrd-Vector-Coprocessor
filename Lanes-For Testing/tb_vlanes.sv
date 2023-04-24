`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2023 15:48:25
// Design Name: 
// Module Name: tb_vlanes
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


module tb_vlanes();
    import v_pkg::*;

    logic clk;
    logic nrst;
    logic [5:0] op_instr_alu;
    logic [5:0] op_instr_mul;
    logic [2:0] vsew;
    logic [2:0] lmul;
    logic [2:0] lanes;
    logic [127:0] result_valu_1;
    logic [127:0] result_vmul_1;
    logic [127:0] result_valu_2;
    logic [127:0] result_vmul_2;
    // logic [127:0] result_valu_3;
    // logic [127:0] result_vmul_3;
    // logic [127:0] result_valu_4;
    // logic [127:0] result_vmul_4;
    logic done;

    logic [127:0] op_A_1;
    logic [127:0] op_A_2;
    // logic [127:0] op_A_3;
    // logic [127:0] op_A_4;

    logic [127:0] op_B_1;
    logic [127:0] op_B_2;
    // logic [127:0] op_B_3;
    // logic [127:0] op_B_4;


    //logic [31:0] op_A, op_B; //op32_A, op32_B;
    logic [7:0] op8_A, op8_B, op8_C, op8_D, op8_E, op8_F, op8_G, op8_H;
    logic [8:0] ans0, ans1, ans2, ans3;
    logic [15:0] ans0_16, ans1_16;
    logic [15:0] op16_A, op16_B, op16_C, op16_D;
    logic [31:0] op32_A, op32_B;
    logic [31:0] ans_32;
    //logic [31:0] result;
    int err;
    int ans;

    v_lanes uut(
        .clk(clk),
        .nrst(nrst),
        .op_instr_alu(op_instr_alu),
        .op_instr_mul(op_instr_mul),
        .vsew(vsew),
        .lmul(lmul),
        .lanes(lanes),
        .result_valu_1(result_valu_1),
        .result_vmul_1(result_vmul_1),
        .result_valu_2(result_valu_2),
        .result_vmul_2(result_vmul_2),
        .result_valu_3(result_valu_3),
        .result_vmul_3(result_vmul_3),
        .result_valu_4(result_valu_4),
        .result_vmul_4(result_vmul_4),
        .done(done),

        .op_A_1(op_A_1),
        .op_A_2(op_A_2),
        .op_A_3(op_A_3),
        .op_A_4(op_A_4),

        .op_B_1(op_B_1),
        .op_B_2(op_B_2),
        .op_B_3(op_B_3),
        .op_B_4(op_B_4)
    );

	initial begin
        // disable reset
        nrst = 1;

        // clock source
        clk = 0;
        fork
            forever #20 clk = ~clk;
        join_none
        
        
        // ---------------------- MUL INSTRUCTION---------------------- //
        // sew = 8 bits
        op_instr_mul = 6'b100101;
        lanes = 0;
        lmul = 2'b00;
        //for (int tb_lmul = 0; tb_lmul< 3; tb_lmul++) begin
        //    lmul = tb_lmul;
            
            #60;

            vsew =3'b00;
            err = 0;
            $display("TESTING MUL: sew = 8 bits...");
            for (int i = 0; i < 10; i++) begin
                op8_A = $urandom_range(-(2^7)+1, (2^7)-1);   op8_B = $urandom_range(-(2^7)+1, (2^7)-1);
                op8_C = $urandom_range(-(2^7)+1, (2^7)-1);   op8_D = $urandom_range(-(2^7)+1, (2^7)-1);
                op8_E = $urandom_range(-(2^7)+1, (2^7)-1);   op8_F = $urandom_range(-(2^7)+1, (2^7)-1);
                op8_G = $urandom_range(-(2^7)+1, (2^7)-1);   op8_H = $urandom_range(-(2^7)+1, (2^7)-1);

                ans0 = op8_A * op8_B;
                ans1 = op8_C * op8_D;
                ans2 = op8_E * op8_F;
                ans3 = op8_G * op8_H;
                
                op_A_1 = {{op8_A, op8_C, op8_E, op8_G},{op8_A, op8_C, op8_E, op8_G},{op8_A, op8_C, op8_E, op8_G},{op8_A, op8_C, op8_E, op8_G}};
                op_B_1 = {{op8_B, op8_D, op8_F, op8_H},{op8_B, op8_D, op8_F, op8_H},{op8_B, op8_D, op8_F, op8_H},{op8_B, op8_D, op8_F, op8_H}};
                op_A_2 = {{op8_A, op8_C, op8_E, op8_G},{op8_A, op8_C, op8_E, op8_G},{op8_A, op8_C, op8_E, op8_G},{op8_A, op8_C, op8_E, op8_G}};
                op_B_2 = {{op8_B, op8_D, op8_F, op8_H},{op8_B, op8_D, op8_F, op8_H},{op8_B, op8_D, op8_F, op8_H},{op8_B, op8_D, op8_F, op8_H}};
 
                ans = {{ans0[7:0], ans1[7:0], ans2[7:0], ans3[7:0]},{ans0[7:0], ans1[7:0], ans2[7:0], ans3[7:0]},{ans0[7:0], ans1[7:0], ans2[7:0], ans3[7:0]},{ans0[7:0], ans1[7:0], ans2[7:0], ans3[7:0]}};
                #60;
                err_chk(ans, result_vmul_1);
                err_chk(ans, result_vmul_2);
            end

            data_err_chk_mul8: assert (err == 0) begin
                $display("PASS: No Errors Found");
                err = 0;        // reset error value
            end else begin
                $display("FAIL: %d Errors Found", err);
                err = 0;
            end 
            
            #60;
    
            // sew = 16 bits        
            vsew = 3'b01;
            err = 0;
            $display("TESTING MUL: sew = 16 bits...");
            for (int j = 0; j < 10; j++) begin
                op16_A = $urandom_range(-(2^15)-1, (2^15)-1);   op16_B = $urandom_range(-(2^15)-1, (2^15)-1);
                op16_C = $urandom_range(-(2^15)-1, (2^15)-1);   op16_D = $urandom_range(-(2^15)-1, (2^15)-1);

                ans0_16 = op16_A * op16_B;
                ans1_16 = op16_C * op16_D;
                
                op_A_1 = {{op16_A, op16_C},{op16_A, op16_C},{op16_A, op16_C},{op16_A, op16_C}};
                op_B_1 = {{op16_B, op16_D},{op16_B, op16_D},{op16_B, op16_D},{op16_B, op16_D}};
                ans = {{ans0_16[15:0], ans1_16[15:0]},{ans0_16[15:0], ans1_16[15:0]},{ans0_16[15:0], ans1_16[15:0]},{ans0_16[15:0], ans1_16[15:0]}};
                #60;
                err_chk(ans, result_vmul_1);
            end

            data_err_chk_mul16: assert (err == 0) begin
                $display("PASS: No Errors Found");
                err = 0;        // reset error value
            end else begin
                $display("FAIL: %d Errors Found", err);
                err = 0;
            end
            
            #60;
            
            //32 bits
            vsew = 3'b10;
            err = 0;
            $display("TESTING MUL: sew = 32 bits...");
            for (int k = 0; k < 10; k++) begin
                op32_A = $urandom_range(-(2^31)+1, (2^31)-1);   op32_B = $urandom_range(-(2^31)+1, (2^31)-1);
                
                ans_32 = op32_A * op32_B; 

                op_A_1 = {{op32_A},{op32_A},{op32_A},{op32_A}};
                op_B_1 = {{op32_B},{op32_B},{op32_B},{op32_B}};
                ans = {{ans_32},{ans_32},{ans_32},{ans_32}};
                #60;
                err_chk(ans, result_vmul_1);
            end

            data_err_chk_mul32: assert (err == 0) begin
                $display("PASS: No Errors Found");
                err = 0;        // reset error value
            end else begin
                $display("FAIL: %d Errors Found", err);
                err = 0;
            end 
        //end
    	
        #10;	

		$finish;
    end



    // checks for errors
    function void err_chk(logic [31:0] exp_result, logic [31:0] actual_result);

        if (exp_result !== actual_result) begin
            err++;
            $display("Error Found. Expected %b. Received %b", exp_result, actual_result);
        end else begin
            $display("No Error. Expected %b. Received %b", exp_result, actual_result);
        end

    endfunction
endmodule

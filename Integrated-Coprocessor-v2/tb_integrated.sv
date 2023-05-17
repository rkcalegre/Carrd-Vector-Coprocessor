`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2023 05:07:43
// Design Name: 
// Module Name: tb_integrated_sldu
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


module tb_integrated();
    import v_pkg::*;

	logic clk;
	logic nrst;
    logic [31:0] op_instr_base;   

carrd_integrated integrated(
    .clk(clk),
	.nrst(nrst),
    .op_instr_base(op_instr_base)
);

/*     //Regfile
	logic reg_wr_en, el_wr_en;
    logic [1:0] lanes;
	logic [2:0] vlmul;
    logic [2:0] vsew;
    logic [4:0] el_wr_addr;
	logic  [4:0] el_addr_1, el_addr_2;
	//logic [3:0][32-1:0] el_wr_data, el_data_out_1, el_data_out_2 ;
	logic [32-1:0] el_data_out_1, el_data_out_2 ;
	logic [127:0] el_wr_data;
	logic [4:0] el_reg_wr_addr, reg_wr_addr,el_rd_addr_1,el_rd_addr_2,mask_src,reg_rd_addr_v1,reg_rd_addr_v2;
    logic [127:0]  reg_wr_data,reg_wr_data_2,reg_wr_data_3,reg_wr_data_4;
	logic [127:0]  mask;
	logic [127:0] reg_data_out_v1_a,reg_data_out_v1_b,reg_data_out_v1_c,reg_data_out_v1_d;
	logic [127:0] reg_data_out_v2_a,reg_data_out_v2_b,reg_data_out_v2_c,reg_data_out_v2_d;

    //csr
    logic [4:0] vl;
    logic [31:0] instr;

    //Decoder
	//logic [31:0] instr;
    logic [5:0] v_alu_op;
    logic [5:0] v_mul_op;
    logic [5:0] v_lsu_op;
    logic [5:0] v_sldu_op;
    logic [5:0] v_red_op;

    logic [4:0] vrs1;
    logic [4:0] vrs2;
    logic [4:0] imm;
    logic [4:0] vd;
    logic [4:0] rs2;

    //SLDU
    logic [511:0] result_vsldu; //vd

    //V_LANES
    // logic [31:0] result_valu;
    // logic [31:0] result_vmul;
    logic [31:0] result_valu_1;
    logic [31:0] result_vmul_1;
    logic [31:0] result_valu_2;
    logic [31:0] result_vmul_2;
    logic [31:0] result_valu_3;
    logic [31:0] result_vmul_3;
    logic [31:0] result_valu_4;
    logic [31:0] result_vmul_4; */

    int err;

/* 	task test_op();
		begin

		end
	endtask */


	initial begin
        // clock source
        clk = 0;
        fork
            forever #20 clk = ~clk;
        join_none  

        nrst = 0;
        #160;

        // disable reset
        nrst = 1;

        //Initialization
        //el_wr_en = 0;

        // ---------------------- SLDU INSTRUCTION---------------------- //
        //Input 512 data to Register A and B
        //Check opcode
        #20;
        force integrated.reg_wr_en = 1;
        force integrated.vd = 5'b0;
        force integrated.reg_wr_data = 128'h012345678901234567890123456789a1;
        #40;
        force integrated.vd = 5'b1;
        force integrated.reg_wr_data = 128'h012345678901234567890123456789a2;
        #40;
        force integrated.vd = 5'd2;
        force integrated.reg_wr_data = 128'h012345678901234567890123456789a3;
        #40;
        force integrated.vd = 5'd3;
        force integrated.reg_wr_data = 128'h012345678901234567890123456789a4;
        #40;
        force integrated.vd = 5'd4;
        force integrated.reg_wr_data = 128'h012345678901234567890123456789a5;
        #40;
        force integrated.vd = 5'd5;
        force integrated.reg_wr_data = 128'h012345678901234567890123456789a6;
        #40;
        force integrated.vd = 5'd6;
        force integrated.reg_wr_data = 128'h012345678901234567890123456789a7;
        #40;
        force integrated.vd = 5'd7;
        force integrated.reg_wr_data = 128'h012345678901234567890123456789a8;
        #40;
        // integrated.reg_wr_en = 0;
        // force integrated.reg_wr_en = 0;
        #20;
        release integrated.reg_wr_en;
        release integrated.vd;
        release integrated.reg_wr_data;
        release integrated.reg_wr_data_2;
        release integrated.reg_wr_data_3;
        release integrated.reg_wr_data_4;

        #20;
        
        $display("===========|| Testing CONFIGURATION INSTRUCTION|| ===========");
        op_instr_base =  32'b00000000001000000111000001010111 ;
        #200;

        //force integrated.op_A = 32'h98765432;


/*          $display("===========|| Testing SLDU|| ==========="); //Tested //Commented for backup
        //Testing VMOVE
        op_instr_base =  32'b01011100000000000100010001010111 ;
        #40;

        //Testing VSLIDEUP
        op_instr_base =  32'b00111000010000000110011001010111 ;
        #80;

        //Testing VSLIDE1UP
        op_instr_base =  32'b00111000000000000100100001010111 ;
        #80;

        //Testing VSLIDEDOWN
        op_instr_base =  32'b00111100010000000110101001010111 ;
        #80;

        //Testing VSLIDE1DOWN
        op_instr_base =  32'b00111100000000000100110001010111 ;
        #80; 

        
        $display("===========|| Testing VRED|| ===========");
        //Testing VREDSUM
        op_instr_base =  32'b00000000000000000010010001010111 ;
        #280;

        //Testing VREDMAX
        op_instr_base =  32'b00011100010000000010011001010111 ;
        #280; 

        $display("===========|| Testing MUL|| ===========");
        //Testing VMUL
        op_instr_base =  32'b10010100000000000010010001010111 ;
        #200;

        //Testing VMUL
        op_instr_base =  32'b10010100010000000110011001010111 ;
        #200;

        //Testing VMUL
        op_instr_base =  32'b10010100000000000010100001010111 ;
        #200;

        //Testing VREDMAX
        op_instr_base =  32'b00011100010000000010011001010111 ;
        #280;  */

        /* $display("===========|| Testing CONFIGURATION INSTRUCTION|| ==========="); // From Python Code
        op_instr_base =  32'b00000000001000000111000001010111 ;
        #200;

        $display("===========|| Testing ARITHMETIC OPERATIONS|| ===========");
        $display("===========|| Testing VRED|| ===========");
        //Testing VREDSUM
        op_instr_base =  32'b00000000000000000010010001010111 ;
        #280;

        //Testing VREDMAX
        op_instr_base =  32'b00011100010000000010011001010111 ;
        #280;

        $display("===========|| Testing SLDU|| ===========");
        //Testing VMOVE
        op_instr_base =  32'b01011100000000000100010001010111 ;
        #80;

        //Testing VSLIDEUP
        op_instr_base =  32'b00111000010000000011011001010111 ;
        #80;

        //Testing VSLIDEUP
        op_instr_base =  32'b00111000000000000011100001010111 ;
        #80;

        //Testing VSLIDEDOWN
        op_instr_base =  32'b00111100010000000011101001010111 ;
        #80;

        //Testing VSLIDEDOWN
        op_instr_base =  32'b00111100000000000011110001010111 ;
        #80;

        //Testing VMOVE
        op_instr_base =  32'b01011100010000000100011001010111 ;
        #80;

        //Testing VSLIDEUP
        op_instr_base =  32'b00111000000000000100100001010111 ;
        #80;

        //Testing VSLIDEUP
        op_instr_base =  32'b00111000010000000100101001010111 ;
        #80;

        //Testing VSLIDEDOWN
        op_instr_base =  32'b00111100000000000100110001010111 ;
        #80;

        //Testing VSLIDEDOWN
        op_instr_base =  32'b00111100010000000100111001010111 ;
        #80;

        $display("===========|| Testing ALU|| ===========");
        //Testing VADD
        op_instr_base =  32'b00000000000000000000010001010111 ;
        #200;

        //Testing VSUB
        op_instr_base =  32'b00001000010000000000011001010111 ;
        #200;

        //Testing VMIN
        op_instr_base =  32'b00010100000000000000100001010111 ;
        #200;

        //Testing VMAX
        op_instr_base =  32'b00011100010000000000101001010111 ;
        #200;

        //Testing VAND
        op_instr_base =  32'b00100100000000000000110001010111 ;
        #200;

        //Testing VOR
        op_instr_base =  32'b00101000010000000000111001010111 ;
        #200;

        //Testing VXOR
        op_instr_base =  32'b00101100000000000000010001010111 ;
        #200;

        //Testing VSLL
        op_instr_base =  32'b10010100010000000000011001010111 ;
        #200;

        //Testing VSRL
        op_instr_base =  32'b10100000000000000000100001010111 ;
        #200;

        //Testing VSRA
        op_instr_base =  32'b10100100010000000000101001010111 ;
        #200;

        $display("===========|| Testing ALU|| ===========");
        //Testing VADD
        op_instr_base =  32'b00000000000000000100010001010111 ;
        #200;

        //Testing VSUB
        op_instr_base =  32'b00001000010000000100011001010111 ;
        #200;

        //Testing VMIN
        op_instr_base =  32'b00010100000000000100100001010111 ;
        #200;

        //Testing VMAX
        op_instr_base =  32'b00011100010000000100101001010111 ;
        #200;

        //Testing VAND
        op_instr_base =  32'b00100100000000000100110001010111 ;
        #200;

        //Testing VOR
        op_instr_base =  32'b00101000010000000100111001010111 ;
        #200;

        //Testing VXOR
        op_instr_base =  32'b00101100000000000100010001010111 ;
        #200;

        //Testing VSLL
        op_instr_base =  32'b10010100010000000100011001010111 ;
        #200;

        //Testing VSRL
        op_instr_base =  32'b10100000000000000100100001010111 ;
        #200;

        //Testing VSRA
        op_instr_base =  32'b10100100010000000100101001010111 ;
        #200;

        $display("===========|| Testing ALU|| ===========");
        //Testing VADD
        op_instr_base =  32'b00000000000000000011010001010111 ;
        #200;

        //Testing VSUB
        op_instr_base =  32'b00001000010000000011011001010111 ;
        #200;

        //Testing VMIN
        op_instr_base =  32'b00010100000000000011100001010111 ;
        #200;

        //Testing VMAX
        op_instr_base =  32'b00011100010000000011101001010111 ;
        #200;

        //Testing VAND
        op_instr_base =  32'b00100100000000000011110001010111 ;
        #200;

        //Testing VOR
        op_instr_base =  32'b00101000010000000011111001010111 ;
        #200;

        //Testing VXOR
        op_instr_base =  32'b00101100000000000011010001010111 ;
        #200;

        //Testing VSLL
        op_instr_base =  32'b10010100010000000011011001010111 ;
        #200;

        //Testing VSRL
        op_instr_base =  32'b10100000000000000011100001010111 ;
        #200;

        //Testing VSRA
        op_instr_base =  32'b10100100010000000011101001010111 ;
        #200;

        $display("===========|| Testing MUL|| ===========");
        //Testing VMUL
        op_instr_base =  32'b10010100000000000010010001010111 ;
        #200;

        //Testing VMUL
        op_instr_base =  32'b10010100010000000110011001010111 ;
        #200;

        //Testing VMUL
        op_instr_base =  32'b10010100000000000010100001010111 ;
        #200; */

        //Instructions are random
        $display("===========|| Testing CONFIGURATION INSTRUCTION|| ===========");
        op_instr_base =  32'b00000000001000000111000001010111 ;
        #200;

        $display("===========|| Testing ARITHMETIC OPERATIONS|| ===========");

        //Testing VMUL
        op_instr_base =  32'b10010100000000000010100001010111 ;
        #200;

        //Testing VSLIDEDOWN
        op_instr_base =  32'b00111100000000000011110001010111 ;
        #80;

        //Testing VADD
        op_instr_base =  32'b00000000000000000000010001010111 ;
        #200;

        //Testing VSUB
        op_instr_base =  32'b00001000010000000000011001010111 ;
        #200;

        //Testing VMIN
        op_instr_base =  32'b00010100000000000000100001010111 ;
        #200;

        //Testing VSLIDEDOWN
        op_instr_base =  32'b00111100010000000100111001010111 ;
        #80;

        //Testing VMAX
        op_instr_base =  32'b00011100010000000000101001010111 ;
        #200;

        //Testing VAND
        op_instr_base =  32'b00100100000000000000110001010111 ;
        #200;

        //Testing VOR
        op_instr_base =  32'b00101000010000000000111001010111 ;
        #200;

        //Testing VXOR
        op_instr_base =  32'b00101100000000000000010001010111 ;
        #200;

        //Testing VSLL
        op_instr_base =  32'b10010100010000000000011001010111 ;
        #200;

        //Testing VSRL
        op_instr_base =  32'b10100000000000000000100001010111 ;
        #200;

        //Testing VSRA
        op_instr_base =  32'b10100100010000000000101001010111 ;
        #200;

        //Testing VADD
        op_instr_base =  32'b00000000000000000100010001010111 ;
        #200;

        //Testing VSUB
        op_instr_base =  32'b00001000010000000100011001010111 ;
        #200;

        //Testing VMIN
        op_instr_base =  32'b00010100000000000100100001010111 ;
        #200;

        //Testing VMAX
        op_instr_base =  32'b00011100010000000100101001010111 ;
        #200;

        //Testing VSLIDEDOWN
        op_instr_base =  32'b00111100000000000100110001010111 ;
        #80;


        //Testing VAND
        op_instr_base =  32'b00100100000000000100110001010111 ;
        #200;

        //Testing VOR
        op_instr_base =  32'b00101000010000000100111001010111 ;
        #200;

        //Testing VXOR
        op_instr_base =  32'b00101100000000000100010001010111 ;
        #200;

        //Testing VMOVE
        op_instr_base =  32'b01011100010000000100011001010111 ;
        #80;

        //Testing VSLL
        op_instr_base =  32'b10010100010000000100011001010111 ;
        #200;

        //Testing VSRL
        op_instr_base =  32'b10100000000000000100100001010111 ;
        #200;

        //Testing VMOVE
        op_instr_base =  32'b01011100000000000100010001010111 ;
        #80;

        //Testing VSRA
        op_instr_base =  32'b10100100010000000100101001010111 ;
        #200;

        //Testing VSLIDEUP
        op_instr_base =  32'b00111000000000000100100001010111 ;
        #80;

        //Testing VADD
        op_instr_base =  32'b00000000000000000011010001010111 ;
        #200;

        //Testing VMUL
        op_instr_base =  32'b10010100010000000110011001010111 ;
        #200;

        //Testing VSUB
        op_instr_base =  32'b00001000010000000011011001010111 ;
        #200;

        //Testing VMIN
        op_instr_base =  32'b00010100000000000011100001010111 ;
        #200;

        //Testing VMAX
        op_instr_base =  32'b00011100010000000011101001010111 ;
        #200;

        //Testing VREDSUM
        op_instr_base =  32'b00000000000000000010010001010111 ;
        #280;

        //Testing VAND
        op_instr_base =  32'b00100100000000000011110001010111 ;
        #200;

        //Testing VOR
        op_instr_base =  32'b00101000010000000011111001010111 ;
        #200;

        //Testing VREDMAX
        op_instr_base =  32'b00011100010000000010011001010111 ;
        #280;
        //Testing VSLIDEUP
        op_instr_base =  32'b00111000010000000011011001010111 ;
        #80;

        //Testing VXOR
        op_instr_base =  32'b00101100000000000011010001010111 ;
        #200;

        //Testing VSLL
        op_instr_base =  32'b10010100010000000011011001010111 ;
        #200;

        //Testing VSLIDEUP
        op_instr_base =  32'b00111000010000000100101001010111 ;
        #80;

        //Testing VSRL
        op_instr_base =  32'b10100000000000000011100001010111 ;
        #200;

        //Testing VSRA
        op_instr_base =  32'b10100100010000000011101001010111 ;
        #200;

        //Testing VSLIDEUP
        op_instr_base =  32'b00111000000000000011100001010111 ;
        #80;

        //Testing VMUL
        op_instr_base =  32'b10010100000000000010010001010111 ;
        #200;
        
        //Testing VSLIDEDOWN
        op_instr_base =  32'b00111100010000000011101001010111 ;
        #80;



        //release integrated.op_A;

        #10;	
		$finish;
    end

    // checks for errors
    function void err_chk(logic [31:0] exp_result, logic [31:0] actual_result);

        if (exp_result !== actual_result) begin
            err++;
            $display("Error Found. Expected %b. Received %b", exp_result, actual_result);
        end

    endfunction

endmodule

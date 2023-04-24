`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2023 18:47:48
// Design Name: 
// Module Name: carrd_integrated
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

`timescale 1ns / 1ps

module carrd_integrated(
	input clk,
	input nrst,
    input logic [31:0] op_instr_base
    );

    import v_pkg::*;

    /*=== INSTANTIATING MODULES ===*/

    //Regfile
	logic clk, nrst, reg_wr_en, el_wr_en;
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

	v_regfile vregfile(
        .clk(clk),
        .nrst(nrst),
        .lmul(vlmul),
        .sew(vsew),
		.el_wr_en(el_wr_en),
        .el_wr_addr(el_wr_addr),
        .el_reg_wr_addr(el_reg_wr_addr),
        .el_wr_data(el_wr_data),
        .reg_wr_en(reg_wr_en),
        .reg_wr_addr(vd),
        .reg_wr_data(reg_wr_data), //from results of blocks
        .reg_wr_data_2(reg_wr_data_2),
        .reg_wr_data_3(reg_wr_data_3),
        .reg_wr_data_4(reg_wr_data_4),
        .el_rd_addr_1(el_rd_addr_1),
        .el_rd_addr_2(el_rd_addr_2),
		.el_addr_1(el_addr_1),
        .el_addr_2(el_addr_2),
        .mask_src(mask_src),
        .el_data_out_1(el_data_out_1),
		.el_data_out_2(el_data_out_2),
        .mask(mask),
        .reg_rd_addr_v1(vrs1),
        .reg_rd_addr_v2(vrs2),
        .reg_data_out_v1_a(reg_data_out_v1_a),
        .reg_data_out_v1_b(reg_data_out_v1_b),
        .reg_data_out_v1_c(reg_data_out_v1_c),
        .reg_data_out_v1_d(reg_data_out_v1_d),
        .reg_data_out_v2_a(reg_data_out_v2_a),
        .reg_data_out_v2_b(reg_data_out_v2_b),
        .reg_data_out_v2_c(reg_data_out_v2_c),
        .reg_data_out_v2_d(reg_data_out_v2_d)
	);

    //csr
    logic [4:0] vl;
    //logic [2:0] vlmul;   
    //logic [2:0] vsew;
    logic [31:0] instr;

    assign instr = op_instr_base; //From Base Processor

	csr vcsr(
    .clk(clk),
    .nrst(nrst),
    .vl(vl),
    .vlmul(vlmul),
    .vsew(vsew),
    .instr(instr)
	);


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


	v_decoder vdecoder(
    .instr(instr),
    .v_alu_op(v_alu_op),
    .v_mul_op(v_mul_op),
    .v_lsu_op(v_lsu_op),
    .v_sldu_op(v_sldu_op),
    .v_red_op(v_red_op),
    .vrs1(vrs1),
    .vrs2(vrs2),
    .imm(imm),
    .vd(vd),
    .rs2(rs2)

	);

    //Reduction
    //logic [5:0] op_instr;
    //logic [1:0] vsew;
    //logic [1:0] lmul;
    logic [31:0] vec_regA;
    logic red_mode;
    logic done_vred;
    logic [31:0] result_vred;


    v_red vred(
        .clk(clk),
        .nrst(nrst),
        .op_instr(v_red_op),
        .sew(vsew),
        .lmul(vlmul),
        .vec_regA(reg_data_out_v1_a),
        .vec_regB_1(reg_data_out_v2_a),
        .vec_regB_2(reg_data_out_v2_b),
        .vec_regB_3(reg_data_out_v2_c),
        .vec_regB_4(reg_data_out_v2_d),
        .red_mode(red_mode),
        .done(done_vred),
        .result(result_vred)
    );

    //SLDU

    //logic [5:0] op_instr;
    //logic [2:0] sew;
    //logic [2:0] lmul;
    // logic [127:0] vs2_1;//vs2
    // logic [127:0] vs2_2;//vs2
    // logic [127:0] vs2_3;//vs3
    // logic [127:0] vs2_4;//vs4 to accomodate lmul=4
    //logic [127:0] rs1;//rs1     redefine limit of range (currently VECTOR_LENGTH)
    logic [511:0] result_vsldu; //vd
    
	v_sldu vsldu(
	.clk(clk),
	.nrst(nrst),
	.op_instr(v_sldu_op),
	.sew(vsew),
	.lmul(vlmul),
	.vs2_1(reg_data_out_v2_a),
	.vs2_2(reg_data_out_v2_b),
	.vs2_3(reg_data_out_v2_c),
	.vs2_4(reg_data_out_v2_d),
	.rs1(vrs1),
	.result(result_vsldu)
	);

    //VLSU
    logic [2:0] ld_store_op;
    //logic [2:0] vsew;
    logic [1:0] stride;
    logic [31:0] addr;
    logic [31:0] data_in; 
    logic [31:0] loaddata;
    //logic [31:0] data_out; 
    logic [31:0] result_vlsu; 

    v_lsu vlsu(
	.clk(clk),
	.nrst(nrst),
    .ld_store_op(ld_store_op),  // v_lsu_op
    .vsew(vsew),
    .addr(addr),
    .data_in(data_in),
    .loaddata(loaddata),
    .data_out(result_vlsu)
    );

    //V_LANES
    logic [31:0] result_valu;
    logic [31:0] result_vmul;

    v_lanes vlanes(
        .clk(clk),
        .nrst(nrst),
        .vsew(vsew),
        .op_instr_alu(v_alu_op),
        .op_instr_mul(v_mul_op),
        .result_valu(result_valu),
        .result_vmul(result_vmul),

        .op_A_1(reg_data_out_v1_a),
        .op_A_2(reg_data_out_v1_b),
        .op_A_3(reg_data_out_v1_c),
        .op_A_4(reg_data_out_v1_d),
        .op_B_1(reg_data_out_v2_a),
        .op_B_2(reg_data_out_v2_b),
        .op_B_3(reg_data_out_v2_c),
        .op_B_4(reg_data_out_v2_d)

    );

    carrd_writeback vwriteback(
        .v_alu_op(v_alu_op),
        .v_mul_op(v_mul_op),
        .v_lsu_op(v_lsu_op), 
        .v_sldu_op(v_sldu_op),
        .v_red_op(v_red_op),        
        .result_vlsu(result_vlsu),
        .result_valu(result_valu),
        .result_vmul(result_vmul), 
        .result_vsldu(result_vsldu),
        .result_vred(result_vred),  
        .reg_wr_en(reg_wr_en),
        .el_wr_en(el_wr_en), 
        .reg_wr_data(reg_wr_data),
        .reg_wr_data_2(reg_wr_data_2), 
        .reg_wr_data_3(reg_wr_data_3), 
        .reg_wr_data_4(reg_wr_data_4) 
    );

    /*
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

        /*case (v_alu_op)
            6'd0: ;
            default: begin
                assign reg_wr_en = 1;
                assign reg_wr_data = result_valu;
                assign reg_wr_data_2 = result_valu;
                assign reg_wr_data_3 = result_valu;
                assign reg_wr_data_4 = result_valu;            
            end
        endcase

        case (v_mul_op)
            6'd0: ;
            default: begin
                assign reg_wr_en = 1;
                assign reg_wr_data = result_vmul;
                assign reg_wr_data_2 = result_vmul;
                assign reg_wr_data_3 = result_vmul;
                assign reg_wr_data_4 = result_vmul;            
            end
        endcase

        case (v_lsu_op)
            6'd0: ;
            default: begin
                assign reg_wr_en = 1;
                assign reg_wr_data = result_vlsu;
                assign reg_wr_data_2 = result_vlsu;
                assign reg_wr_data_3 = result_vlsu;
                assign reg_wr_data_4 = result_vlsu;           
            end
        endcase

        case (v_sldu_op)
            6'd0: ;
            default: begin
                assign reg_wr_en = 1;
                assign reg_wr_data = result_vsldu[127:0];
                assign reg_wr_data_2 = result_vsldu[255:128];
                assign reg_wr_data_3 = result_vsldu[383:256];
                assign reg_wr_data_4 = result_vsldu[511:384];           
            end
        endcase

        case (v_red_op)
            6'd0: ;
            default: begin
                assign reg_wr_en = 0;
                assign el_wr_en = 1;
                assign reg_wr_data = result_vred;
                assign reg_wr_data_2 = {128{1'b0}};
                assign reg_wr_data_3 = {128{1'b0}};
                assign reg_wr_data_4 = {128{1'b0}};           
            end
        endcase 

    end*/


endmodule

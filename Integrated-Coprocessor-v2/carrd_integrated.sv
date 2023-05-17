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

module carrd_integrated#(
    parameter int LANES = 0
)(
	input clk,
	input nrst,
    input logic [31:0] op_instr_base
    );

    import v_pkg::*;

    /*=== INSTANTIATING MODULES ===*/

    //Regfile
	logic clk, nrst, reg_wr_en, el_wr_en;
    logic [1:0] lanes = LANES;
	logic [2:0] vlmul;
    logic [2:0] vsew;
    logic [4:0] el_wr_addr;
	logic  [4:0] el_addr_1, el_addr_2;
	logic [32-1:0] el_data_out_1, el_data_out_2 ;
	logic [127:0] el_wr_data;
	logic [4:0] el_reg_wr_addr, el_rd_addr_1,el_rd_addr_2,mask_src;
    logic [127:0]  reg_wr_data,reg_wr_data_2,reg_wr_data_3,reg_wr_data_4;
	logic [127:0]  mask;
	logic [127:0] reg_data_out_v1_a,reg_data_out_v1_b,reg_data_out_v1_c,reg_data_out_v1_d;
	logic [127:0] reg_data_out_v2_a,reg_data_out_v2_b,reg_data_out_v2_c,reg_data_out_v2_d;

    logic [4:0] vs1, vs2, dest_addr;
    logic [31:0] instr;

    assign instr = op_instr_base; //From Base Processor
    assign vs1 = instr[19:15];
    assign vs2 = instr[24:20];


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
        .reg_wr_addr(dest_addr),
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
        .reg_rd_addr_v1(vs1),
        .reg_rd_addr_v2(vs2),
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
    //logic vconfig_wr_en;
    // logic [31:0] vl_in;
    // logic [31:0] vtype_in;
    logic [31:0] vl_out;
    logic [31:0] vtype_out;

    assign vlmul = vtype_out[2:0]; //RISC-V Defintion
    assign vsew = vtype_out[5:3];  //RISC-V Defintion

    

	vcsr csr(
    .clk(clk),
    .nrst(nrst),
    .vconfig_wr_en(is_vconfig),
    // .vl_in(vl_in),
    // .vtype_in(vtype_in),
    .vl_in(op_instr_base),
    .vtype_in(op_instr_base),
    .vl_out(vl_out),
    .vtype_out(vtype_out)
	);


    //Decoder
	//logic [31:0] instr;
    logic [3:0] v_alu_op;
    logic is_vconfig;
    logic [3:0] v_lsu_op;
    logic is_mul;    
    logic [2:0] v_sldu_op;
    logic [2:0] v_red_op;

    logic [2:0] v_op_sel_A;
    logic [1:0] v_op_sel_B;
    logic [1:0] v_sel_dest;


	v_decoder vdecoder(
    .instr(instr),
    .is_vconfig(is_vconfig),
    .v_alu_op(v_alu_op),
    .is_mul(is_mul),
    .v_lsu_op(v_lsu_op),
    .v_sldu_op(v_sldu_op),
    .v_red_op(v_red_op),
    .v_op_sel_A(v_op_sel_A),
    .v_op_sel_B(v_op_sel_B),
    .v_sel_dest(v_sel_dest)


	);
    logic [511:0] op_A;
    logic [31:0] x_reg_data;

    assign op_A = (v_op_sel_A == 1)? {reg_data_out_v1_d,reg_data_out_v1_c,reg_data_out_v1_b,reg_data_out_v1_a}:  //vs1 data
                  (v_op_sel_A == 2)? {{480{1'b0}}, x_reg_data}:  //rs1 data
                  (v_op_sel_A == 3)? {{507{1'b0}},instr[19:15]} : 0 ;  //immediate data

    logic [511:0] op_B;

    assign op_B = (v_op_sel_B == 1)? {reg_data_out_v2_d,reg_data_out_v2_c,reg_data_out_v2_b,reg_data_out_v2_a}:  //vs2 data
                  (v_op_sel_B == 2)? {{480{1'b0}}, x_reg_data}:  //rs2 data
                  (v_op_sel_B == 3)? {{501{1'b0}},instr[30:20]} : 0 ;  //zimmediate data

    //Reduction
    //logic [5:0] op_instr;
    //logic [1:0] vsew;
    //logic [1:0] lmul;
    //logic [31:0] vec_regA;
    logic done_vred;
    logic [31:0] result_vred;


    v_red vred(
        .clk(clk),
        .nrst(nrst),
        .op_instr(v_red_op),
        .sew(vsew),
        .lmul(vlmul),
        .vec_regA(op_A[31:0]),
        .vec_regB_1(op_B[127:0]),
        .vec_regB_2(op_B[255:128]),
        .vec_regB_3(op_B[383:256]),
        .vec_regB_4(op_B[511:384]),
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
	.vs2_1(op_B[127:0]),
	.vs2_2(op_B[255:128]),
	.vs2_3(op_B[383:256]),
	.vs2_4(op_B[511:384]),
	.rs1(op_A[127:0]),
	.result(result_vsldu)
	);

/*     //VLSU
    logic [2:0] ld_store_op;
    //logic [2:0] vsew;
    logic [1:0] stride;
    logic [31:0] addr;
    logic [31:0] data_in1, data_in2, data_in3, data_in4; 
    logic [31:0] loaddata;
    //logic [31:0] data_out; 
    logic [31:0] result_vlsu; 

    v_lsu vlsu(
	.clk(clk),
	.nrst(nrst),
    .ld_store_op(ld_store_op),  // v_lsu_op
    .vsew(vsew),
    .addr(addr),
    .data_in1(data_in1),
    .data_in2(data_in2),
    .data_in3(data_in3),
    .data_in4(data_in4),
    .loaddata(loaddata),
    .data_out(result_vlsu)
    ); */

    //V_LANES
    logic done_vlanes;
    logic [127:0] result_valu_1;
    logic [127:0] result_valu_2;
    logic [127:0] result_valu_3;
    logic [127:0] result_valu_4;

    logic [127:0] result_vmul_1;
    logic [127:0] result_vmul_2;
    logic [127:0] result_vmul_3;    
    logic [127:0] result_vmul_4;

    v_lanes vlanes(
        .clk(clk),
        .nrst(nrst),
        .op_instr_alu(v_alu_op),
        .is_mul(is_mul),
        .vsew(vsew),
        .lmul(vlmul),
        .lanes(lanes),
        .result_valu_1(result_valu_1),
        .result_vmul_1(result_vmul_1),
        .result_valu_2(result_valu_2),
        .result_vmul_2(result_vmul_2),
        .result_valu_3(result_valu_3),
        .result_vmul_3(result_vmul_3),
        .result_valu_4(result_valu_4),
        .result_vmul_4(result_vmul_4),
        .done(done_vlanes),

        .op_A_1(op_A[127:0]),
        .op_A_2(op_A[255:128]),
        .op_A_3(op_A[383:256]),
        .op_A_4(op_A[511:384]),
        .op_B_1(op_B[127:0]),
        .op_B_2(op_B[255:128]),
        .op_B_3(op_B[383:256]),
        .op_B_4(op_B[511:384])

    );

    logic x_reg_wr_en;

    carrd_writeback vwriteback(
        .clk(clk),
        .v_alu_op(v_alu_op),
        .is_mul(is_mul),
        .v_lsu_op(v_lsu_op), 
        .v_sldu_op(v_sldu_op),
        .v_red_op(v_red_op),
        .done_vlanes(done_vlanes),
        .done_vred(done_vred),        
        .result_vlsu(result_vlsu),
        .result_valu_1(result_valu_1),
        .result_valu_2(result_valu_2),
        .result_valu_3(result_valu_3),
        .result_valu_4(result_valu_4),
        .result_vmul_1(result_vmul_1), 
        .result_vmul_2(result_vmul_2), 
        .result_vmul_3(result_vmul_3), 
        .result_vmul_4(result_vmul_4), 
        .result_vsldu(result_vsldu),
        .result_vred(result_vred),
        .dest_addr_in(instr[11:7]), //can be deleted //vd = instr[11:7]
        .v_sel_dest(v_sel_dest), 
        .v_reg_wr_en(reg_wr_en),
        .x_reg_wr_en(x_reg_wr_en),
        .el_wr_en(el_wr_en), 
        .reg_wr_addr(dest_addr),  
        .reg_wr_data(reg_wr_data),
        .reg_wr_data_2(reg_wr_data_2), 
        .reg_wr_data_3(reg_wr_data_3), 
        .reg_wr_data_4(reg_wr_data_4) 
    );

endmodule

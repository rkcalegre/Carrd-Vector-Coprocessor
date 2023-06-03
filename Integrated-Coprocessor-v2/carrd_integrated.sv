`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2023 18:47:48
// Design Name: 
// Module Name: carrd_integrated
// Project Name: CARRD_Vector Coprocessor
// Target Devices: 
// Tool Versions: 
// Description: The top module of the project instantiating all other vector blocks.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`include "constants.vh"

module carrd_integrated#(
	/**
	LANES Configuration
	0 - 4 lanes
	1 - 8 lanes
	2 - 16 lanes **/
    parameter int LANES = 0                     // To be set before synthesizing the project. 
)(
	input clk,
	input nrst,
	input logic [31:0] op_instr_base,           //The instruction from the base processor
    
    // Memory Data buses from Vector Coprocessor
	output is_vstype,
    output [`DATAMEM_BITS-1:0] data_addr0,
    output [`DATAMEM_BITS-1:0] data_addr1,
    output [`DATAMEM_BITS-1:0] data_addr2,
    output [`DATAMEM_BITS-1:0] data_addr3,

	// For Vector Store Operations
	output [`DATAMEM_WIDTH-1:0] v_store_data_0,
	output [`DATAMEM_WIDTH-1:0] v_store_data_1,
	output [`DATAMEM_WIDTH-1:0] v_store_data_2,
	output [`DATAMEM_WIDTH-1:0] v_store_data_3,

	// For Vector Load Operations
	input [`DATAMEM_WIDTH-1:0] v_load_data_0,
	input [`DATAMEM_WIDTH-1:0] v_load_data_1,
	input [`DATAMEM_WIDTH-1:0] v_load_data_2,
	input [`DATAMEM_WIDTH-1:0] v_load_data_3,

    // For Vector-Scalar Instructions that require reads from the scalar regfile
	output [`REGFILE_BITS-1:0] v_rd_xreg_addr1,
    output [`REGFILE_BITS-1:0] v_rd_xreg_addr2,   
	input [`WORD_WIDTH-1:0] xreg_out1,	        // Data read from scalar register
    input [`WORD_WIDTH-1:0] xreg_out2	        // Data read from scalar register
);

    import v_pkg::*;

    /*=== INSTANTIATING MODULES ===*/

    //Vector Register File
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

    logic [4:0] vs1, vs2, vs3, vd;
    logic [31:0] instr;

    //From Base Processor
    assign instr = op_instr_base; 
    assign x_reg_data1 = xreg_out1;
    assign x_reg_data2 = xreg_out2;
    assign v_rd_xreg_addr1 = vs1;
    assign v_rd_xreg_addr2 = vs2;
    //assign v_data_addr = // address of data mem

    logic [4:0] vsA, vsB;
    assign vsA = (v_lsu_op inside {[7:12]}) ? vs3 : vs1;
    assign vsB = vs2;

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
	    .reg_wr_data(reg_wr_data), //signal from v_writeback
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
        .reg_rd_addr_v1(vsA),
        .reg_rd_addr_v2(vsB),
        .reg_data_out_v1_a(reg_data_out_v1_a),
        .reg_data_out_v1_b(reg_data_out_v1_b),
        .reg_data_out_v1_c(reg_data_out_v1_c),
        .reg_data_out_v1_d(reg_data_out_v1_d),
        .reg_data_out_v2_a(reg_data_out_v2_a),
        .reg_data_out_v2_b(reg_data_out_v2_b),
        .reg_data_out_v2_c(reg_data_out_v2_c),
        .reg_data_out_v2_d(reg_data_out_v2_d)
	);

    //Control Status Register
    logic [31:0] vl_out;
    logic [10:0] vtype_out;

    assign vlmul = vtype_out[2:0]; //RISC-V Defintion
    assign vsew = vtype_out[5:3];  //RISC-V Defintion

    

	vcsr csr(
    .clk(clk),
    .nrst(nrst),
    .vconfig_wr_en(is_vconfig),
    .vl_in(op_instr_base),
    .vtype_in(op_instr_base),
    .vl_out(vl_out),
    .vtype_out(vtype_out)
	);


    //Decoder Block
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
    .v_reg_wr_en(reg_wr_en),
    .x_reg_wr_en(x_reg_wr_en),
    .is_vconfig(is_vconfig),
    .v_alu_op(v_alu_op),
    .is_mul(is_mul),
    .v_lsu_op(v_lsu_op),
    .is_vstype(is_vstype),
    .v_sldu_op(v_sldu_op),
    .v_red_op(v_red_op),
    .v_op_sel_A(v_op_sel_A),
    .v_op_sel_B(v_op_sel_B),
    .v_sel_dest(v_sel_dest),
    .vd(vd),
    .vs1(vs1),
    .vs2(vs2),
    .vs3(vs3),
    .imm(imm),
    .zimm(zimm)


	);
    logic [511:0] op_A;
    logic [31:0] x_reg_data1;
    logic [31:0] x_reg_data2;
    logic [4:0] imm;
    logic [10:0] zimm;

    assign op_A = (v_op_sel_A == 1)? {reg_data_out_v1_d,reg_data_out_v1_c,reg_data_out_v1_b,reg_data_out_v1_a}:  //vs1 data
                  (v_op_sel_A == 2)? {{480{1'b0}}, x_reg_data1}:  //rs1 data
                  (v_op_sel_A == 3)? {{507{1'b0}}, imm} : 0 ;  //immediate data

    logic [511:0] op_B;

    assign op_B = (v_op_sel_B == 1)? {reg_data_out_v2_d,reg_data_out_v2_c,reg_data_out_v2_b,reg_data_out_v2_a}:  //vs2 data
                  (v_op_sel_B == 2)? {{480{1'b0}}, x_reg_data2}:  //rs2 data
                  (v_op_sel_B == 3)? {{501{1'b0}}, zimm} : 0 ;  //zimmediate data

    logic [511:0] op_C;
    
    assign op_C = {reg_data_out_v1_d,reg_data_out_v1_c,reg_data_out_v1_b,reg_data_out_v1_a};
    
    //Vector Reduction Blok
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

    //Vector SLDU
    logic [511:0] result_vsldu; //vd
    logic done_vsldu;
    
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
    .done_vsldu(done_vsldu),
	.result(result_vsldu)
	);

      //VLSU
      /*
    logic is_load, is_store;
    //logic [6:0] v_lsu_op;
    //logic [31:0] l_addr;
    logic [31:0] l_data_in1, l_data_in2, l_data_in3, l_data_in4; 
    logic [1:0] write_en1, write_en2, write_en3, write_en4;
    logic [511:0] l_data_out;
    logic [31:0] s_data_out1, s_data_out2, s_data_out3, s_data_out4; 
    logic [`DATAMEM_BITS-1:0] s_addr;                          // Base Address - from rs1

    assign is_load = (v_lsu_op > 0 && v_lsu_op <7);
    assign is_store = (v_lsu_op > 6 && v_lsu_op <13);

    
    v_lsu vlsu(
    .l_data_in0(v_load_data_0),
    .l_data_in1(v_load_data_1),
    .l_data_in2(v_load_data_2),
    .l_data_in3(v_load_data_3),
    .vlsu_op(v_lsu_op),  // v_lsu_op
    .lmul(vlmul),
    .l_addr(xreg_out1),
    .is_load(is_load),
    .is_store(is_store),
    .l_data_out(l_data_out),
    .s_data_in(op_A),
    .write_en0(write_en0),
    .write_en1(write_en1),
    .write_en2(write_en2),
    .write_en3(write_en3),
    .l_done(l_done),
    .s_done(s_done),
    .s_addr(s_addr), //TO EDIT
    .data_addr0(data_addr0),
    .data_addr1(data_addr1),
    .data_addr2(data_addr2),
    .data_addr3(data_addr3),
    .s_data_out0(v_store_data_0),
    .s_data_out1(v_store_data_1),
    .s_data_out2(v_store_data_2),
    .s_data_out3(v_store_data_3)
    );  
    */
    // Store Unit
    logic done_store;

    v_storeunit vstoreunit (
        .clk(clk),
        .nrst(nrst),
        .store_op(v_lsu_op),
        .lmul(vlmul),
        .vsew(vsew),
        .stride(xreg_out2),          // DOUBLE CHECK
        .address(xreg_out1),         // DOUBLE CHECK
        .data(op_C),                 // DOUBLE CHECK

        .data_addr0(data_addr0),
        .data_addr1(data_addr1),
        .data_addr2(data_addr2),
        .data_addr3(data_addr3),
        .data_out0(v_store_data_0),
        .data_out1(v_store_data_1),
        .data_out2(v_store_data_2),
        .data_out3(v_store_data_3),
        .done(done_store)
    );  */ 

    
    logic [511:0] result_vloadu;
    logic done_vloadu;

    v_loadu vloadu(
    .clk(clk),
    .l_data_in0(v_load_data_0), 
    .l_data_in1(v_load_data_1),
    .l_data_in2(v_load_data_2),
    .l_data_in3(v_load_data_3),
    .v_lsu_op(v_lsu_op),
    .lmul(vlmul),
    .vsew(vsew),
    .l_addr(xreg_out),
    .data_addr0(data_addr0),  
    .data_addr1(data_addr1),  
    .data_addr2(data_addr2),  
    .data_addr3(data_addr3),  
    .l_data_out(result_vloadu),
    .l_done(done_vloadu)
    );

    //V_LANES
    logic done_valu;
    logic done_vmul;
    logic s_done;
    logic l_done;
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
        .done_valu(done_valu),
        .done_vmul(done_vmul),

        .op_A_1(op_A[127:0]),
        .op_A_2(op_A[255:128]),
        .op_A_3(op_A[383:256]),
        .op_A_4(op_A[511:384]),
        .op_B_1(op_B[127:0]),
        .op_B_2(op_B[255:128]),
        .op_B_3(op_B[383:256]),
        .op_B_4(op_B[511:384])

    );

	// Writeback
    logic x_reg_wr_en;

    carrd_writeback vwriteback(
        .clk(clk),
        .v_alu_op(v_alu_op),
        .is_mul(is_mul),
        .v_lsu_op(v_lsu_op), 
        .v_sldu_op(v_sldu_op),
        .v_red_op(v_red_op),
        .done_valu(done_valu),
        .done_vmul(done_vmul),
        .done_vred(done_vred),
        .done_vsldu(done_vsldu),        
        .done_vload(done_vloadu),        
        .result_vload(result_vloadu),
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
        .v_sel_dest(v_sel_dest), 
        .v_reg_wr_en(reg_wr_en),
        .x_reg_wr_en(x_reg_wr_en),
        .el_wr_en(el_wr_en), 
        .reg_wr_data(reg_wr_data),
        .reg_wr_data_2(reg_wr_data_2), 
        .reg_wr_data_3(reg_wr_data_3), 
        .reg_wr_data_4(reg_wr_data_4) 
    );

/*     carrd_writeback vwriteback( //BEFORE CHANGING LSU
        .clk(clk),
        .v_alu_op(v_alu_op),
        .is_mul(is_mul),
        .v_lsu_op(v_lsu_op), 
        .v_sldu_op(v_sldu_op),
        .v_red_op(v_red_op),
        .done_valu(done_valu),
        .done_vmul(done_vmul),
        .done_vred(done_vred),
        .done_vsldu(done_vsldu),        
        .done_vlsu(done_vlsu),        
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
        .v_sel_dest(v_sel_dest), 
        .v_reg_wr_en(reg_wr_en),
        .x_reg_wr_en(x_reg_wr_en),
        .el_wr_en(el_wr_en), 
        .reg_wr_data(reg_wr_data),
        .reg_wr_data_2(reg_wr_data_2), 
        .reg_wr_data_3(reg_wr_data_3), 
        .reg_wr_data_4(reg_wr_data_4) 
    ); */

endmodule

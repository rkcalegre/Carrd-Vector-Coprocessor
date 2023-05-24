//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// datamem.v -- Data memory module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: datamem.v
// Description: This module contains the Block Memory Generator IP Modules needed
//				to implement a ~4kB memory for the RISCV processor.
//				Block Memory Generator IP settings for both modules:
//					- Native Interface, True DUAL PORT RAM
//					- Byte write enabled (8bits per byte)
//					- common clock &  generate address unchecked
//					- minimum area algorithm
//					PORT settings (both port a & b)
//						- 32bit write & read width, 1024 write & read depth
//						- Read First operating mode, Always Enabled
//						- checkboxes left unchecked
//					
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps
`include "constants.vh"

module v_datamem(
	input core_clk,								// Gated clock signal
	input con_clk,								// Un-gated clock signal
	input nrst,

	// Bank Selection
	input [3:0] dm_write_0,
	input [3:0] dm_write_1,
	input [3:0] dm_write_2,
	input [3:0] dm_write_3,

	// Input Data to each Memory Bank
	input [`DATAMEM_BITS-1:0] data_addr,
	input [`DATAMEM_WIDTH-1:0] data_in_0,
	input [`DATAMEM_WIDTH-1:0] data_in_1,
	input [`DATAMEM_WIDTH-1:0] data_in_2,
	input [`DATAMEM_WIDTH-1:0] data_in_3,

	// Inputs from protocol controllers
	// NOTE: protocol controllers cannot read from FPGAIO
	input [3:0] con_write,						// Similar to dm_write
	input [`DATAMEM_BITS-1:0] con_addr,			// Datamem address from protocol controller
	input [`DATAMEM_WIDTH-1:0] con_in,			// Data input from protocol controller

	// Outputs
	// For now, output to Base RISC-V Core is defaulted to Bank 0
	output [`DATAMEM_WIDTH-1:0] data_out_0,		// Data word 0 output to the Vector Coprocessor Core
	output [`DATAMEM_WIDTH-1:0] data_out_1,		// Data word 1 output to the Vector Coprocessor Core
	output [`DATAMEM_WIDTH-1:0] data_out_2,		// Data word 2 output to the Vector Coprocessor Core
	output [`DATAMEM_WIDTH-1:0] data_out_3,		// Data word 3 output to the Vector Coprocessor Core
	output [`DATAMEM_WIDTH-1:0] con_out			// Data output to protocol controller
);
	
	// Block memory outputs
	wire [`DATAMEM_WIDTH-1:0] coremem_douta_0, coremem_doutb_0; 
	wire [`DATAMEM_WIDTH-1:0] coremem_doutb_1, coremem_douta_1;
	wire [`DATAMEM_WIDTH-1:0] coremem_douta_2, coremem_doutb_2;
	wire [`DATAMEM_WIDTH-1:0] coremem_douta_3, coremem_doutb_3;
	wire [`DATAMEM_WIDTH-1:0] protocolmem_douta, protocolmem_doutb;

	// Determine which blockmem output to select
	// If x_sel = 1, select PROTOCOLMEM output, else select COREMEM output
	wire core_sel = data_addr[`DATAMEM_BITS-1];
	wire protocol_sel = con_addr[`DATAMEM_BITS-1];
	
	// Inputs are big-endian words
	// This part converts them to little-endian format
	wire [`DATAMEM_WIDTH-1:0] data_in_little_e_0 = {data_in_0[7:0], data_in_0[15:8], data_in_0[23:16], data_in_0[31:24]};
	wire [`DATAMEM_WIDTH-1:0] data_in_little_e_1 = {data_in_1[7:0], data_in_1[15:8], data_in_1[23:16], data_in_1[31:24]};
	wire [`DATAMEM_WIDTH-1:0] data_in_little_e_2 = {data_in_2[7:0], data_in_2[15:8], data_in_2[23:16], data_in_2[31:24]};
	wire [`DATAMEM_WIDTH-1:0] data_in_little_e_3 = {data_in_3[7:0], data_in_3[15:8], data_in_3[23:16], data_in_3[31:24]};
	wire [`DATAMEM_WIDTH-1:0] con_in_little_e = {con_in[7:0], con_in[15:8], con_in[23:16], con_in[31:24]};

	// Datamem that uses BLOCKMEM from Vivado IP Catalog
	// Blockmem generated as TRUE DUAL PORT RAM
	// Synchronous read
	// Addresses 0x000 - 0xFFF (Word-aligned addresses)
	blk_mem_gen_datamem_bank0 COREMEM0(
		.clka(core_clk),
		.wea(dm_write_0),
		.addra(data_addr[`DATAMEM_BITS-2:0]),
		.dina(data_in_little_e_0),
		.douta(coremem_douta_0),

		.clkb(con_clk),
		.web(4'b0),
		.addrb(con_addr[`DATAMEM_BITS-2:0]),
		.dinb(32'b0),
		.doutb(coremem_doutb_0)
	);

	blk_mem_gen_datamem_bank1 COREMEM1(
		.clka(core_clk),
		.wea(dm_write_1),
		.addra(data_addr[`DATAMEM_BITS-2:0]),
		.dina(data_in_little_e_1),
		.douta(coremem_douta_1),

		.clkb(con_clk),
		.web(4'b0),
		.addrb(con_addr[`DATAMEM_BITS-2:0]),
		.dinb(32'b0),
		.doutb(coremem_doutb_1)
	);

	blk_mem_gen_datamem_bank2 COREMEM2(
		.clka(core_clk),
		.wea(dm_write_2),
		.addra(data_addr[`DATAMEM_BITS-2:0]),
		.dina(data_in_little_e_2),
		.douta(coremem_douta_2),

		.clkb(con_clk),
		.web(4'b0),
		.addrb(con_addr[`DATAMEM_BITS-2:0]),
		.dinb(32'b0),
		.doutb(coremem_doutb_2)
	);

	blk_mem_gen_datamem_bank3 COREMEM3(
		.clka(core_clk),
		.wea(dm_write_3),
		.addra(data_addr[`DATAMEM_BITS-2:0]),
		.dina(data_in_little_e_3),
		.douta(coremem_douta_3),

		.clkb(con_clk),
		.web(4'b0),
		.addrb(con_addr[`DATAMEM_BITS-2:0]),
		.dinb(32'b0),
		.doutb(coremem_doutb_3)
	);

	// Addresses 0x1000 - 0x100F	(Word-aligned addresses)
	blk_mem_gen_protocol PROTOCOLMEM(
		.clka(core_clk),
		.wea(4'b0),
		.addra(data_addr[3:0]),
		.dina(32'b0),
		.douta(protocolmem_douta),

		.clkb(con_clk),
		.web(con_write),
		.addrb(con_addr[3:0]),
		.dinb(con_in_little_e),
		.doutb(protocolmem_doutb)
	);
	
	// Other Peripherals
	reg [`WORD_WIDTH-1:0] num_cycles = `WORD_WIDTH'd0;               // num_cycles """SFR""" (0x410)
	wire [`WORD_WIDTH-1:0] num_cycles_out = {num_cycles[7:0], num_cycles[15:8], num_cycles[23:16], num_cycles[31:24]};
	reg num_cycles_addr_reg = 1'b0;

	// Assigning data_out for the Core
	reg core_sel_reg = 0;
	always@(posedge core_clk) begin
		if(!nrst) begin
		      core_sel_reg <= 0;
		      num_cycles_addr_reg <= 1'b0;
		end
		else begin
		      core_sel_reg <= core_sel;
		      num_cycles_addr_reg <= (data_addr == 14'h2010);
		end
	end
	assign data_out_0 = core_sel_reg ?  
	                  ( num_cycles_addr_reg ? num_cycles_out : protocolmem_douta) 
	                  : coremem_douta_0;

	assign data_out_1 = core_sel_reg ?  
	                  ( num_cycles_addr_reg ? num_cycles_out : protocolmem_douta) 
	                  : coremem_douta_1;

	assign data_out_2 = core_sel_reg ?  
	                  ( num_cycles_addr_reg ? num_cycles_out : protocolmem_douta) 
	                  : coremem_douta_2;
	
	assign data_out_3 = core_sel_reg ?  
	                  ( num_cycles_addr_reg ? num_cycles_out : protocolmem_douta) 
	                  : coremem_douta_3;

	// Assigning con_out
	reg protocol_sel_reg = 0;
	always@(posedge con_clk) begin
		if(!nrst) begin
		      protocol_sel_reg <= 0;
		      num_cycles <= `WORD_WIDTH'd0;
		end
		else begin
		      protocol_sel_reg <= protocol_sel;
		      num_cycles <= num_cycles + `WORD_WIDTH'd1;
	    end
	end
	/*
	wire [`DATAMEM_WIDTH-1:0] con_out_little_e = protocol_sel_reg? protocolmem_doutb : (data_addr[1:0] == 2'b00)? coremem_doutb_0 :
																					   (data_addr[1:0] == 2'b01)? coremem_doutb_1 :
																					   (data_addr[1:0] == 2'b10)? coremem_doutb_2 :
																					   (data_addr[1:0] == 2'b11)? coremem_doutb_3;
	*/
	wire [`DATAMEM_WIDTH-1:0] con_out_little_e = protocol_sel_reg? protocolmem_doutb : coremem_doutb_0;
																					   
	assign con_out = {con_out_little_e[7:0], con_out_little_e[15:8], con_out_little_e[23:16], con_out_little_e[31:24]};
endmodule
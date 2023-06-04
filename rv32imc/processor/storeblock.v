//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// storeblock.v -- Store data module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: storeblock.v
// Description: Generates the data to be stored in the data memory
//				based on the store instruction used. The dm_write write enable
//				signal is also generated
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps
`include "constants.vh"

module storeblock(
    input [31:0] opB,
    input [1:0] byte_offset,
    input [1:0] store_select,
    input is_stype,

	// Vector Coprocessor Datapath Signals //
	input is_vstype,

	// Input Data from VLSU
	input [31:0] data_in_0,
	input [31:0] data_in_1,
	input [31:0] data_in_2,
	input [31:0] data_in_3,

	// Data Addresses from VLSU
	input [`DATAMEM_BITS-1:0] data_addr0,
	input [`DATAMEM_BITS-1:0] data_addr1,
	input [`DATAMEM_BITS-1:0] data_addr2,
	input [`DATAMEM_BITS-1:0] data_addr3,

	// Write Enable Signals for each memory bank
	output reg [3:0] dm_write_0,
	output reg [3:0] dm_write_1,
	output reg [3:0] dm_write_2,
	output reg [3:0] dm_write_3,

	// Stored Data from VLSU
	output [31:0] data0,			// This is also where the scalar data is assigned by default
	output [31:0] data1,
	output [31:0] data2,
	output [31:0] data3
);
    
    parameter sw = 2'd2;
    parameter sh = 2'd1;
    parameter sb = 2'd0;

	parameter bank0 = 2'b00;
	parameter bank1 = 2'b01;
	parameter bank2 = 2'b10;
	parameter bank3 = 2'b11;
    
    wire [31:0] nboff_data;
	wire [1:0] bank_sel = data_addr0[1:0];
	wire [1:0] bank_sel1 = data_addr1[1:0];
	wire [1:0] bank_sel2 = data_addr2[1:0];
	wire [1:0] bank_sel3 = data_addr3[1:0];
    
    assign nboff_data = (store_select == sb) ? {24'd0 , opB[7:0]} : (store_select == sh) ? {16'd0, opB[15:0]} : opB ;
	//assign data0 = (is_vstype) ? data_in_0 : (nboff_data << (8*byte_offset));
	//assign data1 = data_in_1;
	//assign data2 = data_in_2;
	//assign data3 = data_in_3;
    assign data0 = (is_vstype) ? data_in_0 : (bank_sel == bank0) ? (nboff_data << (8*byte_offset)) : 32'd0;
	assign data1 = (is_vstype) ? data_in_1 : (bank_sel == bank1) ? (nboff_data << (8*byte_offset)) : 32'd0;
	assign data2 = (is_vstype) ? data_in_2 : (bank_sel == bank2) ? (nboff_data << (8*byte_offset)) : 32'd0;
	assign data3 = (is_vstype) ? data_in_3 : (bank_sel == bank3) ? (nboff_data << (8*byte_offset)) : 32'd0;
    
    // Original implementation was big-endian [b+3, b+2, b+1, b]
    // Changed to little-endian to accomodate RISC-V GNU Assembler Output [b, b+1, b+2, b+3]

	// Bank Selection is based on bits [1:0] of address
	// =================================================
	// Write to Bank 0 if data_addr[1:0] == 2'b00	  //
	// Write to Bank 1 if data_addr[1:0] == 2'b01	  //
	// Write to Bank 2 if data_addr[1:0] == 2'b10     //
	// Write to Bank 3 if data_addr[1:0] == 2'b11     //
	// =================================================

	always@(*) begin
		case (bank_sel)
			bank0: begin

				// Turn off other Write Enables
				dm_write_1 <= 4'b0000;
				dm_write_2 <= 4'b0000;
				dm_write_3 <= 4'b0000;

				case(store_select)
					sb:
						case({is_stype, byte_offset})
							3'b100: dm_write_0 <= 4'b1000;
							3'b101: dm_write_0 <= 4'b0100;
							3'b110: dm_write_0 <= 4'b0010;
							3'b111: dm_write_0 <= 4'b0001;
							default: dm_write_0 <= 4'b0000;
						endcase
					sh:
						case({is_stype, byte_offset})
							3'b100: dm_write_0 <= 4'b1100;
							3'b110: dm_write_0 <= 4'b0011;
							default: dm_write_0 <= 4'b0000;
						endcase
					sw:
						case({is_stype, byte_offset})
							3'b100: dm_write_0 <= 4'b1111;
							default: dm_write_0 <= 4'b0000;
						endcase

					default: dm_write_0 <= 4'b0000;
				endcase
			end
			bank1: begin

				// Turn off other Write Enables
				dm_write_0 <= 4'b0000;
				dm_write_2 <= 4'b0000;
				dm_write_3 <= 4'b0000;
				
				case(store_select)
					sb:
						case({is_stype, byte_offset})
							3'b100: dm_write_1 <= 4'b1000;
							3'b101: dm_write_1 <= 4'b0100;
							3'b110: dm_write_1 <= 4'b0010;
							3'b111: dm_write_1 <= 4'b0001;
							default: dm_write_1 <= 4'b0000;
						endcase
					sh:
						case({is_stype, byte_offset})
							3'b100: dm_write_1 <= 4'b1100;
							3'b110: dm_write_1 <= 4'b0011;
							default: dm_write_1 <= 4'b0000;
						endcase
					sw:
						case({is_stype, byte_offset})
							3'b100: dm_write_1 <= 4'b1111;
							default: dm_write_1 <= 4'b0000;
						endcase

					default: dm_write_1 <= 4'b0000;
				endcase
			end
			bank2: begin

				// Turn off other Write Enables
				dm_write_0 <= 4'b0000;
				dm_write_1 <= 4'b0000;
				dm_write_3 <= 4'b0000;
				
				case(store_select)
					sb:
						case({is_stype, byte_offset})
							3'b100: dm_write_2 <= 4'b1000;
							3'b101: dm_write_2 <= 4'b0100;
							3'b110: dm_write_2 <= 4'b0010;
							3'b111: dm_write_2 <= 4'b0001;
							default: dm_write_2 <= 4'b0000;
						endcase
					sh:
						case({is_stype, byte_offset})
							3'b100: dm_write_2 <= 4'b1100;
							3'b110: dm_write_2 <= 4'b0011;
							default: dm_write_2 <= 4'b0000;
						endcase
					sw:
						case({is_stype, byte_offset})
							3'b100: dm_write_2 <= 4'b1111;
							default: dm_write_2 <= 4'b0000;
						endcase

					default: dm_write_2 <= 4'b0000;
				endcase
			end
			bank3: begin

				// Turn off other Write Enables
				dm_write_0 <= 4'b0000;
				dm_write_1 <= 4'b0000;
				dm_write_2 <= 4'b0000;
				
				case(store_select)
					sb:
						case({is_stype, byte_offset})
							3'b100: dm_write_3 <= 4'b1000;
							3'b101: dm_write_3 <= 4'b0100;
							3'b110: dm_write_3 <= 4'b0010;
							3'b111: dm_write_3 <= 4'b0001;
							default: dm_write_3 <= 4'b0000;
						endcase
					sh:
						case({is_stype, byte_offset})
							3'b100: dm_write_3 <= 4'b1100;
							3'b110: dm_write_3 <= 4'b0011;
							default: dm_write_3 <= 4'b0000;
						endcase
					sw:
						case({is_stype, byte_offset})
							3'b100: dm_write_3 <= 4'b1111;
							default: dm_write_3 <= 4'b0000;
						endcase

					default: dm_write_3 <= 4'b0000;
				endcase
			end 
			default: begin
				dm_write_0 <= 4'b0000;
				dm_write_1 <= 4'b0000;
				dm_write_2 <= 4'b0000;
				dm_write_3 <= 4'b0000;
			end
		endcase
		
		/*
		case(store_select)
			sb:
				case({is_stype, byte_offset})
					3'b100: dm_write_0 <= 4'b1000;
					3'b101: dm_write_0 <= 4'b0100;
					3'b110: dm_write_0 <= 4'b0010;
					3'b111: dm_write_0 <= 4'b0001;
					default: dm_write_0 <= 4'b0000;
				endcase
			sh:
				case({is_stype, byte_offset})
					3'b100: dm_write_0 <= 4'b1100;
					3'b110: dm_write_0 <= 4'b0011;
					default: dm_write_0 <= 4'b0000;
				endcase
			sw:
				case({is_stype, byte_offset})
					3'b100: dm_write_0 <= 4'b1111;
					default: dm_write_0 <= 4'b0000;
				endcase

			default: dm_write_0 <= 4'b0000;
		endcase
		*/

		if (is_vstype) begin
			dm_write_0 <= (bank_sel == 2'b00) ? 4'b1111 : 4'b0000;
			dm_write_1 <= (bank_sel1 == 2'b01) ? 4'b1111 : 4'b0000;
			dm_write_2 <= (bank_sel2 == 2'b10) ? 4'b1111 : 4'b0000;
			dm_write_3 <= (bank_sel3 == 2'b11) ? 4'b1111 : 4'b0000;
		end
	end
endmodule

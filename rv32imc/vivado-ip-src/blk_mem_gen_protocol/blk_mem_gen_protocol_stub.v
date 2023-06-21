// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Thu Jun  8 09:03:23 2023
// Host        : Celine running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top blk_mem_gen_protocol -prefix
//               blk_mem_gen_protocol_ blk_mem_gen_protocol_stub.v
// Design      : blk_mem_gen_protocol
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.2" *)
module blk_mem_gen_protocol(clka, wea, addra, dina, douta, clkb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[3:0],addra[3:0],dina[31:0],douta[31:0],clkb,web[3:0],addrb[3:0],dinb[31:0],doutb[31:0]" */;
  input clka;
  input [3:0]wea;
  input [3:0]addra;
  input [31:0]dina;
  output [31:0]douta;
  input clkb;
  input [3:0]web;
  input [3:0]addrb;
  input [31:0]dinb;
  output [31:0]doutb;
endmodule

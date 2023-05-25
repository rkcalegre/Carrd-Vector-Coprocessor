// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Thu May 25 03:05:36 2023
// Host        : DESKTOP-RODQRO0 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {d:/Coding
//               Projects/Carrd-Vector-Coprocessor/rv32imc/vivado-ip-src/clk_wiz_0/clk_wiz_0_stub.v}
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clkfb_in, clk_out1, clkfb_out, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clkfb_in,clk_out1,clkfb_out,locked,clk_in1" */;
  input clkfb_in;
  output clk_out1;
  output clkfb_out;
  output locked;
  input clk_in1;
endmodule

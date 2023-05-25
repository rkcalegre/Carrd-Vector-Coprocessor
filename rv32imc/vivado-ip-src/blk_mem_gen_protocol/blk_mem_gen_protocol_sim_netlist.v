// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Thu May 25 17:55:32 2023
// Host        : DESKTOP-RODQRO0 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim {d:/Coding
//               Projects/Carrd-Vector-Coprocessor/rv32imc/vivado-ip-src/blk_mem_gen_protocol/blk_mem_gen_protocol_sim_netlist.v}
// Design      : blk_mem_gen_protocol
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_protocol,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_protocol
   (clka,
    wea,
    addra,
    dina,
    douta,
    clkb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [3:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [3:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [3:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [3:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [31:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;

  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire clkb;
  wire [31:0]dina;
  wire [31:0]dinb;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire [3:0]wea;
  wire [3:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [3:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "4" *) 
  (* C_ADDRB_WIDTH = "4" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "00000000" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     6.2874 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_protocol.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_gen_protocol.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "16" *) 
  (* C_READ_DEPTH_B = "16" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "4" *) 
  (* C_WEB_WIDTH = "4" *) 
  (* C_WRITE_DEPTH_A = "16" *) 
  (* C_WRITE_DEPTH_B = "16" *) 
  (* C_WRITE_MODE_A = "READ_FIRST" *) 
  (* C_WRITE_MODE_B = "READ_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_protocol_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[3:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[3:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
VHPlDkoDlWlBfBMvPBmGYmaek3s9hXXhjF28kllYPnaNm3TSnzzpXHWHc8Ye9/2L2yiQfJ1hTWou
Ia/zeQ8h9/dtr6QB5YkyW4wlb/LbMgXb+DGIXPSllNl0IMsRQIcQDbcQm1bO/nlhb+2pjxiuaQrl
DbvxoDwPs7z3LunRxsg=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lmIhoX8hXuc7tNV1sXY1K2/gXL7Y7Hq73qQF7+x03UWWTRd3uhGmVQtOMVbhIW+66UkWUHiD26zL
fzqGor8bgSNGpSFyS11k4TwLQT4OfAMGO8C9Qmmh4+VENBnpS9TW+wHzCv8oUwht7xYtYRZvOvYK
F3fMppz2sBkUd1lciw98ZE/UmNkhqBuMfIYF43j45DEJ55PBhOZNg91Ls4v3qBHyBAaYPFFoMry3
d5Fw1PZyFQSEOSSpwgyds2aN0g6oIwl7zm0LJrM9VDAOxBUE50hk+oHr4jj8J8UhHQJnlEHm1Idm
rvxKygNKRvfSpa90NYxZJFYgqnrMYg+19+9aZA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
VkyCjO2onoeZWEoYQ/4ue7X5mkHyTYVW9xjdoTsGS4GdP/Q64VaCZL/jr6R8DVDXPMnH7tRMrDpo
jpYBnyzSgOkfgqM+96ioC2fDyAaG4gYgGLmrBR6qK3/mxXwAZZX+GJ9R/eWXkc9h8xN+gsSSX6/M
jIQCgeT6q7PB4dWT6KY=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Iub91V+TnhVlZCSLu6iKmFjix71y6/l83OPTs8uewWvkE7WcqYxEKi9fonXEkzAtWzuKwEUqnOlN
VBsNJqPUdKcd22q523mrdt89mpdosWD+hvZdO7ELhJniY5u9h49FFkubpN2JiUTcIcKEYxVNlds4
wyvaYUqbPVH5v2ooJwDdimS4GVn9HerCOgPwfshvQDNlMTxLcYju4v8BHMc5Rub9Q/ihvpQU74v2
ouZ9XIwA+C6pBLwvaqS8jE7HXOokgqJilaX/W/t+KEgiFry/txRTMU9WMD7tCN7lcfjCydmS3Lq+
3u6Hsr0S8BwNjcaDpZDnBTygUJd4JSqREnk33w==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
U46EWFmKmpZGaWfyL+dokyQtJtaOYsa7HCW/+fdtw9/yHKTWFpmqKBZngBj5rPkNhtTDDCJkqsYj
tUXg1j4tgIBaCQn9B0q/aG+B3gPLrudp9hLL25mVbsfiTzdekiV2hJMmhuMoavKKPJHC6zyW7kZi
80er82OQy8h+Df/fe6TRjH9xEt3/b80tRKUMbxkLfnnkAyyf1KfOhB6/uyI4mwXuQR+DsAbzybKR
YtXpOiW72tGrXTFlzcwbHamWZefqsilVpBw6V5dh33vYKGx50xwWpj76maAkpQrOpB7zufeldJe4
W1UOEN84AZdRTLkVSxamWo/wp8nP9fiGS/ItRw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qczgIJYpE/SzErzK7eWJBGcDFEzDLm8cKbwJbPXuM6YnJxx44W+E60R3war7K2QGFAkOoCDUtDC7
SghJGF32btaDLzeKm0tQ669sBtQmMIaBrlt7I9QBkNM8zN9GL92qxNC9o3UVWMOYy5BmH8nUPgcE
O6lRubeltlrTuDe7UJQ2nEPHcXjpUJJ8dxktyW+LovBy1OxW8g4GRAsmEJsoOEg0HuDdWcc4IshJ
PvwPJ7LblELAKsdkSt65y9VaklaEm7MlH4ImlgIa74TgRmutLUbWxM1QYhGE5rAzFhGU5i3RJOdx
L3N7GGGvLMW2z9NSHbIFX+/eNII9fNJ9nZbgLA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Ti1NUgDv8YPk90APMwfu/mRr38QYwAxZfv0T6zQ89YS55t2EquEGVqrEafYX6rTydLOw8le1Oucv
f2oERpSSSTih/ScZneSZmuPE/Zh2BU1Ajv0j+/+0uEWXU+5lLPbDJjnapTmJXih1MYPf0SHpZZmE
BKj2IEBI9MPZlh6bxpa5BWJnyPdAvHf+UNaMXU9+pmbtrzUVebql4mFJu45Z3+ehmFY4FBW3zXMF
44C4TlHACLwL3vHVMCVfeKhgdVDbpE+/IFhTStz7mZ9h9RKGanQcs6YDVM1R+2RKA1QT1fX4FiQc
1V+FGmrm1ujxmFGXwpfNKByVlfCY0oWhRJCYYQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
HuEXFK0NXt09xU2yxxjng1OLsT+ZEM4EhqBgpr9D2ljw2vDaMBrqEsRQTc2B9soDq3ewDduHJXBd
OGYxkPnoN6LhjULtB2nTgjcH6NxA4puZ1ZNcndDndVBo8rTW5W1OqHq6InAG0CqPpTIkuqz3ECPl
EysI++MCDfH6tIzlekxJFIJ1McJsTq5rFuLzMMcrmkBxgcayDpOcCFuzZzCczxmt/cCCIKmDybwT
OQXmOcLJoYLP4sFu6R9c6xO8i6p++crv2N3eIxZHKbek9xBBZqQM9EYuEtsbkqAs9XZpa16i5njR
BDFxTKcP6r7JgFALJE89AZhBbate5JXWp0v4ECZD18aEL17CipwcWPutNMdG1apzSPP5y59n7rMG
yxBPz1gKHc3Emkl4WcO0hjICxqmO6dMXoY8JvBSf6ry2l0sH9Ihr3Bq5WWmlhPHnoaNr5jl//vNe
KfToWtn97eoVSt1LnmXXnSpdigbHr0UIg8AdkpdkuNRaWdVicDdgSo49

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mokwst2bn6UxD6V9UdIgCIG1QQ/d0FiJqYGOTI2eHPV6YElaLjnJ8DnQmZnGS95o3x93FDOoa58C
RwYsX1fVoVtXkj1LuZq0k7q9vEe4T8xMjpkeYtIHY9k0Xhy1Lq/xRlfzGAf9fvf9e+f4r7aR/Sb/
uCZxxugG5niTwLENY1n3NthYL0jvo8Fmdw4Qg0nTCGWlVCws+09K0g9/lx6I9EcuHHemcHO3fOZG
lMc4NaPNozKwnyDMoWUkwiVxyFEPFaQLNYqzjvR+CqrWfhFLo96JWhL+eaDoNuZoBVYQtNH5ZwBL
BoO27Pw10lgcReGlZBz3BLO7T4ddynCx0+eSnw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PiP7AjOQqqouyQMoBQqgWIDhUSViq94rIvGiIJ/UKMDspM/yXw1caE8AhWHTjYckC4yLpPAz5P6s
1Z6flzDPrzVwg4e59X2cc4IMCHhedna0rDO804njcc6amRDTeLsMLTkWfvomB4xwszm2AgT+PRnB
WHd09ZUDVFjiBXT+Oa9AicgGJHrX3w823yBPuAa704kje/SzgtiDpcTU1eLmLhLW7LpEd9KIHd9s
ER7Uk9Orws0Kq9PMTqMX4hMn5K5mFakOeOURiEbUjdv5RiIJ2g/PlQXSItM8fHsBTQa6fOaJwQTI
vHwK3a8ZBHpfT1YH+n7wNiNUZwD4SFXm1QVx4g==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Ul5ZfTHJwMctaNhYRortUZizYMPYRef7uYqPSuMkxsArnxI/cjGh+KRMwzV86hyp/6TXSJIjm5ec
2wX2UONdPN+DOJ84jYC4JbgJQrPnTj7ioD8uLX/WlyPcQzyF5keqFgj5eR5s13FskVWCuAWf5m9w
mhFEKFjVXDAr7gVgAJh/hL8P6Psrnf+LGfiM8JhnDepsHEYykGlpD3fzru2BGgqHWqPqFMcnyVGl
vysaIXiJz/eYKvO8RGcgd3DJAM/wPm9A0m/DWcmSnczOgTjoqkHcBg2H5uJMLvufzmjImi6LYEqq
v04ESDEN31cSUzqUYcayvMFOnI/WNsWbFIa5+Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 28160)
`pragma protect data_block
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
ls8=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif

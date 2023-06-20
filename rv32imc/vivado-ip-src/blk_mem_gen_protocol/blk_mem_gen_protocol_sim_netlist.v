// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Thu Jun  8 09:03:24 2023
// Host        : Celine running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/63915/Desktop/UP/4th_year/2nd_Sem/ECE199/Carrd-Vector-Coprocessor/rv32imc/vivado-ip-src/blk_mem_gen_protocol/blk_mem_gen_protocol_sim_netlist.v
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
Qxc=
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

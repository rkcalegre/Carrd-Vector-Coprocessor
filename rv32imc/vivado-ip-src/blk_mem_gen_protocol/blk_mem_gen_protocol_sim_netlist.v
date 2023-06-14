// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Thu May 25 17:55:30 2023
// Host        : DESKTOP-RODQRO0 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top blk_mem_gen_protocol -prefix
//               blk_mem_gen_protocol_ blk_mem_gen_protocol_sim_netlist.v
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27872)
`pragma protect data_block
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
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

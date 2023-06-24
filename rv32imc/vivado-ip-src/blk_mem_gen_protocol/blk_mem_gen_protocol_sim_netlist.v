// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Thu Jun  8 09:03:23 2023
// Host        : Celine running 64-bit major release  (build 9200)
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

//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
//Date        : Mon Aug 24 01:46:51 2026
//Host        : omar running 64-bit major release  (build 9200)
//Command     : generate_target design_103_bd_wrapper.bd
//Design      : design_103_bd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_103_bd_wrapper
   (M_AXIS_0_tdata,
    M_AXIS_0_tlast,
    M_AXIS_0_tready,
    M_AXIS_0_tstrb,
    M_AXIS_0_tvalid,
    S_AXIS_0_tdata,
    S_AXIS_0_tready,
    S_AXIS_0_tvalid,
    clk_in1_0,
    clk_in1_1,
    reset_0,
    reset_0_1);
  output [31:0]M_AXIS_0_tdata;
  output M_AXIS_0_tlast;
  input M_AXIS_0_tready;
  output [3:0]M_AXIS_0_tstrb;
  output M_AXIS_0_tvalid;
  input [15:0]S_AXIS_0_tdata;
  output S_AXIS_0_tready;
  input S_AXIS_0_tvalid;
  input clk_in1_0;
  input clk_in1_1;
  input reset_0;
  input reset_0_1;

  wire [31:0]M_AXIS_0_tdata;
  wire M_AXIS_0_tlast;
  wire M_AXIS_0_tready;
  wire [3:0]M_AXIS_0_tstrb;
  wire M_AXIS_0_tvalid;
  wire [15:0]S_AXIS_0_tdata;
  wire S_AXIS_0_tready;
  wire S_AXIS_0_tvalid;
  wire clk_in1_0;
  wire clk_in1_1;
  wire reset_0;
  wire reset_0_1;

  design_103_bd design_103_bd_i
       (.M_AXIS_0_tdata(M_AXIS_0_tdata),
        .M_AXIS_0_tlast(M_AXIS_0_tlast),
        .M_AXIS_0_tready(M_AXIS_0_tready),
        .M_AXIS_0_tstrb(M_AXIS_0_tstrb),
        .M_AXIS_0_tvalid(M_AXIS_0_tvalid),
        .S_AXIS_0_tdata(S_AXIS_0_tdata),
        .S_AXIS_0_tready(S_AXIS_0_tready),
        .S_AXIS_0_tvalid(S_AXIS_0_tvalid),
        .clk_in1_0(clk_in1_0),
        .clk_in1_1(clk_in1_1),
        .reset_0(reset_0),
        .reset_0_1(reset_0_1));
endmodule

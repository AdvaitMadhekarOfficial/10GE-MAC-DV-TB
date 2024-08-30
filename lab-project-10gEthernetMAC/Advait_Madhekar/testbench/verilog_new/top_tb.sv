`timescale 1ps/1ps

`include "reset_if.sv"
`include "tx_if.sv"
`include "wb_if.sv"
`include "rx_if.sv"

module top_tb;

  //CLKS
  reg wb_clk_tb;
  reg clk_156m25_tb;
  
  localparam real CLK_WB_PER = 20; //ns == 50 Mhz
  localparam real CLK_156M25_PER = 6.4; //ns

  wire [7:0]       w_xgmii_txc;
  wire [63:0]      w_xgmii_txd;  

  
  wire [7:0]       w_xgmii_txc_duv;
  wire [63:0]      w_xgmii_txd_duv;  

  //DUT DECLARATIONS
  wire             pkt_rx_err; 
  wire      [63:0] xgmii_txd;
  wire      [7 :0] xgmii_txc;
  wire             wb_int_o;
  wire      [31:0] wb_dat_o;
  wire             wb_ack_o;
  wire             pkt_tx_full;
  wire             pkt_rx_val;
  wire             pkt_rx_sop;
  wire      [2 :0] pkt_rx_mod;
  wire             pkt_rx_eop;
  wire      [63:0] pkt_rx_data; 
  wire             pkt_rx_avail;
  wire      [63:0] xgmii_rxd;
  wire      [7 :0] xgmii_rxc;
  wire 	           wb_we_i;
  wire             wb_stb_i;
  reg              wb_rst_i;
  wire      [31:0] wb_dat_i;
  wire             wb_cyc_i; 
  reg              wb_clk_i;
  wire      [7 :0] wb_adr_i;
  reg              reset_xgmii_tx_n;
  reg              reset_xgmii_rx_n;
  reg              reset_156m25_n;
  wire             pkt_tx_val;
  wire             pkt_tx_sop;
  wire      [2 :0] pkt_tx_mod;
  wire      [63:0] pkt_tx_data;
  wire             pkt_tx_eop;
  wire             pkt_rx_ren;
  reg              clk_xgmii_tx;
  reg              clk_xgmii_rx;
  reg              clk_156m25;      
 
  /* 
  //WB CLK
  initial begin
    wb_clk_tb = 0;
    forever #(CLK_WB_PER / 2.0) wb_clk_tb = ~wb_clk_tb; //toggle wb_clk_tb every half period
  end

  //156M25 CLK
  initial begin
    clk_156m25_tb = 0;
    forever #(CLK_156M25_PER / 2.0) clk_156m25_tb = ~clk_156m25_tb;
  end
  */

  //WB CLK
  initial begin
    wb_clk_i <= 0;
    forever #(CLK_WB_PER / 2.0) wb_clk_i <= ~wb_clk_i;
  end

  //156M25 CLK
  initial begin
    clk_156m25 <= 0;
    forever #(CLK_156M25_PER / 2.0) clk_156m25 <= ~clk_156m25;
  end
 
  //XGMII TX CLK
  initial begin
    clk_xgmii_tx <= 0;
    forever #(CLK_156M25_PER / 2.0) clk_xgmii_tx <= ~clk_xgmii_tx;
  end
  
  //XGMII RX CLK
  initial begin
    clk_xgmii_rx <= 0;
    forever #(CLK_156M25_PER / 2.0) clk_xgmii_rx <= ~clk_xgmii_rx;
  end

  initial begin
    $display("CLOCK GEN START");
    #100;
    $display("HH1 %b", wb_clk_i);
    $display("HH2 %b", clk_156m25);
  end

  //INTERFACES
  reset_if rst_if(.wb_clk_i(wb_clk_i), .clk_156m25(clk_156m25));
  tx_if tx_if_inst(.CLK(clk_156m25));
  wb_if wb_if_inst(.wb_clk_i(wb_clk_i));
  rx_if rx_if_inst(.CLK(clk_156m25));
  
  xge_mac DUV(
    //CLKS
    .wb_clk_i  (wb_clk_i),
    .clk_156m25 (clk_156m25),
    .clk_xgmii_rx (clk_156m25),
    .clk_xgmii_tx (clk_156m25),

    //RESETS
    .wb_rst_i (rst_if.wb_rst_i),
    .reset_156m25_n  (rst_if.reset_156m25_n),
    .reset_xgmii_rx_n   (rst_if.reset_156m25_n),
    .reset_xgmii_tx_n   (rst_if.reset_156m25_n),

    //TX
    .pkt_tx_data (tx_if_inst.pkt_tx_data),
    .pkt_tx_val  (tx_if_inst.pkt_tx_val),
    .pkt_tx_sop  (tx_if_inst.pkt_tx_sop),
    .pkt_tx_eop  (tx_if_inst.pkt_tx_eop),
    .pkt_tx_mod  (tx_if_inst.pkt_tx_mod),
    .pkt_tx_full (tx_if_inst.pkt_tx_full),
   
    //WB
    .wb_dat_i   (wb_if_inst.wb_dat_i),
    .wb_adr_i (wb_if_inst.wb_adr_i),
    

    //RX
    .pkt_rx_ren (rx_if_inst.pkt_rx_ren),
    .pkt_rx_avail (rx_if_inst.pkt_rx_avail),
    .pkt_rx_data  (rx_if_inst.pkt_rx_data),
    .pkt_rx_eop   (rx_if_inst.pkt_rx_eop),
    .pkt_rx_err   (rx_if_inst.pkt_rx_err),
    .pkt_rx_mod   (rx_if_inst.pkt_rx_mod),
    .pkt_rx_sop   (rx_if_inst.pkt_rx_sop),
    .pkt_rx_val   (rx_if_inst.pkt_rx_val),

  
    //XGMII
    `ifdef XGMII_LB
       .xgmii_rxd     (w_xgmii_txd_duv),
       .xgmii_rxc     (w_xgmii_txc_duv)
    `else 
       // TBD - XGMII agents connections in case no loopback
    `endif
     
    `ifdef AAA
      abcdef
    `endif
 
  );
  
     assign  w_xgmii_txd_duv = DUV.xgmii_txd;
     assign  w_xgmii_txc_duv = DUV.xgmii_txc;
  //DUT


  xge_mac DUT(.*);  
  
  /*
  // Outputs
  xgmii_txd, xgmii_txc, wb_int_o, wb_dat_o, wb_ack_o, pkt_tx_full,
  pkt_rx_val, pkt_rx_sop, pkt_rx_mod, pkt_rx_err, pkt_rx_eop,
  pkt_rx_data, pkt_rx_avail,
  // Inputs
  xgmii_rxd, xgmii_rxc, wb_we_i, wb_stb_i, wb_rst_i, wb_dat_i,
  wb_cyc_i, wb_clk_i, wb_adr_i, reset_xgmii_tx_n, reset_xgmii_rx_n,
  reset_156m25_n, pkt_tx_val, pkt_tx_sop, pkt_tx_mod, pkt_tx_eop,
  pkt_tx_data, pkt_rx_ren, clk_xgmii_tx, clk_xgmii_rx, clk_156m25
  */

   // TBD - connect from WB agent 
   assign DUT.wb_we_i = wb_if_inst.wb_we_i; 
   assign DUT.wb_stb_i = wb_if_inst.wb_stb_i;
   assign DUT.wb_dat_i = wb_if_inst.wb_dat_i;
   assign DUT.wb_cyc_i = wb_if_inst.wb_cyc_i;
   assign DUT.wb_clk_i = wb_if_inst.wb_clk_i;
   //assign DUT.wb_adr_i = wb_if_inst.wb_adr_i;

   // TBD - connect from Packet agent 
  assign DUT.pkt_tx_val = tx_if_inst.pkt_tx_val;
  assign DUT.pkt_tx_sop = tx_if_inst.pkt_tx_sop;
  assign DUT.pkt_tx_mod = tx_if_inst.pkt_tx_mod;
  assign DUT.pkt_tx_eop = tx_if_inst.pkt_tx_eop;
  assign DUT.pkt_tx_data = tx_if_inst.pkt_tx_data;
  

  //assign DUT.pkt_rx_ren = 1'b1;
 
  // Resets
  assign DUT.wb_rst_i         = rst_if.wb_rst_i; 
  assign DUT.reset_xgmii_tx_n = rst_if.reset_156m25_n;
  assign DUT.reset_xgmii_rx_n = rst_if.reset_156m25_n;
  assign DUT.reset_156m25_n   = rst_if.reset_156m25_n;
  // Clocks
  assign DUT.clk_xgmii_tx     = clk_156m25;
  assign DUT.clk_xgmii_rx     = clk_156m25; 
  assign DUT.clk_156m25       = clk_156m25;
   assign  w_xgmii_txc        = DUT.xgmii_txc;
   assign  w_xgmii_txd        = DUT.xgmii_txd;

  `ifdef XGMII_LB
     assign  DUT.xgmii_rxd      = w_xgmii_txd;
     assign  DUT.xgmii_rxc      = w_xgmii_txc;
  `else 
     // TBD - XGMII agents connections in case no loopback
  `endif

initial begin 
  $vcdpluson();
end


initial begin 
  $display("H1");
  #10000000;
  $display("H2");
  $finish();
end
initial begin 
  forever begin
   @ (posedge clk_156m25_tb);
   //  $display(" %t txd=%0h txc=%0h \n", $realtime, w_xgmii_txd , w_xgmii_txc);
     $display(" %treg rst=%0b xgmii_rst = %0b \n", $realtime, rst_if.wb_rst_i, rst_if.reset_156m25_n);
     $display(" %t wb_rst_dut=%0b xgmii_rst_dut=%0b \n", $realtime, DUT.wb_rst_i, DUT.reset_156m25_n);
  end

end

endmodule:top_tb

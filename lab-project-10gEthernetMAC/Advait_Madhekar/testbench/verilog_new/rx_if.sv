interface rx_if(input logic CLK);
  logic        pkt_rx_ren;
  logic        pkt_rx_avail;
  logic [63:0] pkt_rx_data;
  logic        pkt_rx_eop;
  logic        pkt_rx_val;
  logic        pkt_rx_sop;
  logic [2 :0] pkt_rx_mod;
  logic        pkt_rx_err; 
endinterface


interface tx_if(input CLK);
  logic [63:0] pkt_tx_data;
  logic        pkt_tx_val;
  logic        pkt_tx_sop;
  logic        pkt_tx_eop;
  logic [2 :0] pkt_tx_mod;
  logic        pkt_tx_full;
endinterface


`uvm_analysis_imp_decl(_ap_rx)
`uvm_analysis_imp_decl(_ap_tx)

class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)
  
  bit error = 0;
  tx_seq_item pkt_tx_agent_q[$];  
  rx_seq_item pkt_rx_agent_q[$];

  uvm_analysis_imp_ap_tx #(tx_seq_item, scoreboard) tx_ag_scb_port;
  uvm_analysis_imp_ap_rx #(rx_seq_item, scoreboard) rx_ag_scb_port;

  uvm_event check_start;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  //uvm_analysis_imp_rx_agent#(rx_seq_item, scoreboard) ap_rx_scb;
  //uvm_analysis_imp_tx_agent#(tx_seq_item, scoreboard) ap_tx_scb;

  virtual function void build_phase(input uvm_phase phase);
    super.build_phase(phase);
    rx_ag_scb_port = new("rx_ag_scb_port", this);
    tx_ag_scb_port = new("tx_ag_scb_port", this);
    check_start = new("check_start");
  endfunction

  virtual function void write_ap_rx(rx_seq_item pkt);
    pkt_rx_agent_q.push_back(pkt);
    check_start.trigger();
  endfunction

  virtual function void write_ap_tx(tx_seq_item pkt);
    pkt_tx_agent_q.push_back(pkt);
  endfunction
 
  virtual task run_phase(uvm_phase phase);
    tx_seq_item tx_seq_item_inst;
    rx_seq_item rx_seq_item_inst;
    forever begin
      check_start.wait_trigger();
      tx_seq_item_inst = pkt_tx_agent_q.pop_front();
      rx_seq_item_inst = pkt_rx_agent_q.pop_front();
      if(tx_seq_item_inst.pkt_tx_data != rx_seq_item_inst.pkt_rx_data) begin
        error = 1;
      end
    end
  endtask

  virtual function void report_phase(uvm_phase phase);
    if(error) begin
      `uvm_fatal("SCB", "An error occured in the DUV!");
    end else begin
      `uvm_info("SCB", "No Errors in SCB!", UVM_MEDIUM);
    end
  endfunction

endclass

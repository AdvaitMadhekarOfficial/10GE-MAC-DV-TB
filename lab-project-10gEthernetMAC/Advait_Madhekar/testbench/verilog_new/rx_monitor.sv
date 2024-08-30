jdhljdnlsjnlsdnlsdnldsn
class rx_monitor extends uvm_monitor;
  `uvm_component_utils(rx_monitor)

  virtual rx_if rx_vif;
  uvm_analysis_port #(rx_seq_item) rx_ap;
  tx_seq_item tx_seq; 

  function new(input string name, input uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rx_ap = new("rx_ap", this);
    
    /*if(!uvm_config_db#(virtual rx_if)::get(this, "", "rx_vif", rx_vif)) begin
      `uvm_fatal("RX_MON", "rx_vif not found!");
    end*/
  endfunction

  virtual task run_phase(uvm_phase phase);
    rx_seq_item rx_seq;
    $display("ENTRY RXMON");
    //rx_vif.pkt_rx_ren <= 1;
    //@(posedge rx_vif.CLK);
      //rx_vif.pkt_rx_ren <= 1;
      forever begin
        @(posedge rx_vif.CLK);
        if(rx_vif.pkt_rx_avail) begin
          rx_vif.pkt_rx_ren = 1;
          tx_seq = tx_seq_item::type_id::create("tx_seq", this);
          rx_seq.pkt_rx_data = tx_seq.pkt_tx_data;
          rx_ap.write(rx_seq);
        end
      end
  endtask

endclass

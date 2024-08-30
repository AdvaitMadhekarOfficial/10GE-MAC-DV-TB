//`include "rx_monitor.sv"

typedef uvm_analysis_port#(rx_seq_item) rx_an_port;  

class rx_agent extends uvm_agent;

  `uvm_component_utils(rx_agent)

  rx_monitor rx_mon;
  rx_an_port rx_ap;

  function new(input string name, input uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rx_mon = rx_monitor::type_id::create("rx_mon", this);
    rx_ap = new("rx_ap", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rx_mon.rx_ap.connect(rx_ap);
  endfunction
endclass

`include "wb_driver.sv"

typedef uvm_sequencer#(wb_seq_item) wb_sequencer;

class wb_agent extends uvm_agent;
  `uvm_component_utils(wb_agent)

  wb_driver wb_drv;
  wb_sequencer wb_seqr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    wb_drv = wb_driver::type_id::create("wb_drv", this);
    wb_seqr = wb_sequencer::type_id::create("wb_seqr", this);  
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    wb_drv.wb_seq_item_port.connect(wb_seqr.seq_item_export);
  endfunction
endclass



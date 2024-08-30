//`include "reset_seqr.sv"
`include "reset_driver.sv"

typedef uvm_sequencer#(reset_seq_item) reset_seqr;

class reset_agent extends uvm_agent;
  `uvm_component_utils(reset_agent)

  reset_driver rst_drv;
  reset_seqr rst_seqr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    rst_drv = reset_driver::type_id::create("rst_drv", this);
    rst_seqr = reset_seqr::type_id::create("rst_seqr", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rst_drv.seq_item_port.connect(rst_seqr.seq_item_export);
  endfunction
endclass

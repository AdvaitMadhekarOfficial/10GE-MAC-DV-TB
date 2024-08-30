class virt_seqr extends uvm_sequencer;
  `uvm_component_utils(virt_seqr)

  reset_seqr  rst_seqr;
  tx_sequencer tx_seqr;
  wb_sequencer wb_seqr;

  function new(input string name, input uvm_component parent);
    super.new(name, parent);
  endfunction 
endclass

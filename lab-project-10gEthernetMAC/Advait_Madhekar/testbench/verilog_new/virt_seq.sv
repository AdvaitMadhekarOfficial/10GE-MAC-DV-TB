class virt_seq extends uvm_sequence;
  `uvm_object_utils(virt_seq)
  `uvm_declare_p_sequencer(virt_seqr)
  
  //sequences
  reset_seq rseq;
  tx_seq    tx_seq_inst;
  wb_seq    wb_seq_inst;  


  function new(input string name = "virt_seq");
    super.new(name);
  endfunction

  virtual task pre_start();
    super.pre_start();
    if((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.raise_objection(this);
    end
  endtask
  
  virtual task body();
    `uvm_do_on(rseq, p_sequencer.rst_seqr);
    `uvm_do_on(tx_seq_inst, p_sequencer.tx_seqr);
    `uvm_do_on(wb_seq_inst, p_sequencer.wb_seqr);
  endtask

  virtual task post_start();
    super.post_start();
    if((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.drop_objection(this);
    end
  endtask

endclass

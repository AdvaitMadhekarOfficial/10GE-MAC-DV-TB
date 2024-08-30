

class reset_seq_item extends uvm_sequence_item;
  `uvm_object_utils(reset_seq_item)
  
  rand bit wb_rst;
  rand bit rst_156m25;
 
  function new(string name = "req_item");
    super.new(name);
  endfunction

endclass

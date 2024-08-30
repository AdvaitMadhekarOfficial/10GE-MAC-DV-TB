
class reset_seq extends uvm_sequence #(reset_seq_item);

  `uvm_object_utils(reset_seq)
  
  virtual task body();
    
    if(starting_phase != null) begin
      starting_phase.raise_objection(this);
    end
    `uvm_do_with(req, {wb_rst == 0; rst_156m25 == 1;});

    #1000ns;
    `uvm_do_with(req, {wb_rst == 1; rst_156m25 == 0;}); 
    #500ns;

    
    if(starting_phase != null) begin
      starting_phase.drop_objection(this);
    end 


 
  endtask

endclass

class wb_seq extends uvm_sequence #(wb_seq_item);
  `uvm_object_utils(wb_seq)

  wb_seq_item req;

  function new(string name="wb_seq");
    super.new(name);
  endfunction 

  virtual task body();
    if(starting_phase != null) begin
      starting_phase.raise_objection(this);
    end

    req = new();
    req.wb_dat_i = 32'b1;
    `uvm_send(req); 

    if(starting_phase != null) begin
      starting_phase.drop_objection(this);
    end
  endtask
endclass

class wb_driver extends uvm_driver #(wb_seq_item);
  `uvm_component_utils(wb_driver)
  
  virtual wb_if wb_vif; 
  uvm_seq_item_pull_port#(wb_seq_item) wb_seq_item_port;
  wb_seq_item req;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //get wb_vif handle
    if(!uvm_config_db#(virtual wb_if)::get(this, "", "wb_vif", wb_vif)) begin
      `uvm_fatal("WB_DRV", "Couldn't find wb_vif inside uvm_config_db");
    end else begin
      `uvm_info("WB_DRV", "wb_vif found successfully!", UVM_MEDIUM);
    end
    wb_seq_item_port = new("wb_seq_item_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge wb_vif.wb_clk_i);
      /*if(!wb_seq_item_port.try_next_item(req)) begin
        $display("Nothing to send on WB");
      end else begin*/
        wb_seq_item_port.get_next_item(req);
        req.print();
        drive_item(req);
        wb_seq_item_port.item_done();
     //end 
   end
  endtask

  virtual task drive_item(wb_seq_item req);
    $display("ENTRY INTO DIT");
    req.print();
    fork
      begin
        @(posedge wb_vif.wb_clk_i);
        //wb_vif.wb_dat_i = req.wb_dat_i;
        wb_vif.wb_dat_i = 32'b1;
      end
    join  
  $display("wb_dat_i: %0b", wb_vif.wb_dat_i[0]);
  endtask
endclass

class reset_driver extends uvm_driver #(reset_seq_item);
  `uvm_component_utils(reset_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //need rst_vif
  virtual reset_if rst_vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual reset_if)::get(this, "", "rst_vif", rst_vif)) begin
      `uvm_fatal("RST_DRV", "Couldn't find rst_vif inside uvm_config_db");
    end else begin
      `uvm_info("RST_DRV", "rst_vif found successfully!", UVM_MEDIUM);
    end
  endfunction 

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    forever begin
      $display("DRIVING ITEM");
      seq_item_port.get_next_item(req);
      $display("REQ RECIEVED %b", req.rst_156m25);
      drive_item(req);
      $display("OUT OF DIT");
      seq_item_port.item_done();
      $display("END DRIVING");
    end
    phase.drop_objection(this);
   /*
   $display(" inside reset driver run phase \n");
   repeat(10) @(posedge rst_vif.wb_clk_i);
   rst_vif.wb_rst_i = 0;
   repeat(10) @(posedge rst_vif.wb_clk_i);
   rst_vif.wb_rst_i = 1;
   
    
   repeat(10) @(posedge rst_vif.clk_156m25);
   rst_vif.reset_156m25_n = 1;
   repeat(10) @(posedge rst_vif.clk_156m25);
   rst_vif.reset_156m25_n = 0;
   */ 
  endtask
  
  virtual task drive_item(reset_seq_item req);
    $display("ENTRY INTO DIT");
    fork
      begin
        $display("DIT1");
        @(posedge rst_vif.wb_clk_i); 
          rst_vif.wb_rst_i <= req.wb_rst;
          `uvm_info("RST_DRV", $sformatf("Driving WB_RST!"), UVM_MEDIUM);
      end
      begin
        $display("DIT2");
        @(posedge rst_vif.clk_156m25);
          rst_vif.reset_156m25_n = req.rst_156m25;
          $display("CURR REQ VALUE: %0b", req.rst_156m25);
          $display("NEW VALUE: %0b", rst_vif.reset_156m25_n);
          //rst_vif.reset_xgmii_rx_n <= req.rst_156m25;
          //rst_vif.reset_xgmii_tx_n <= req.rst_156m25;
          `uvm_info("RST_DRV", $sformatf("Driving RST_156m25! + XGMII_RST (TX + RX)"), UVM_MEDIUM); 
      end
    join
    $display("END DIT");
  endtask
  
endclass

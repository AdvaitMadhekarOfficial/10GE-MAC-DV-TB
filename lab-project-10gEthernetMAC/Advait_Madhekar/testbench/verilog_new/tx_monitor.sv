
class tx_monitor extends uvm_monitor;
  `uvm_component_utils(tx_monitor)

  virtual tx_if tx_vif;
  uvm_analysis_port #(tx_seq_item) tx_mon_ap;

  function new(input string name, input uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    tx_mon_ap = new("tx_mon_ap", this);

    if(!uvm_config_db #(virtual tx_if)::get(this, "", "tx_vif", tx_vif) begin
      `uvm_fatal("TX_MON", $sformatf("tx_vif not found in uvm_config_db");
    end else begin
      `uvm_info("TX_MON", $sformatf("tx_vif successfully found!"), UVM_MEDIUM);
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    //tx_seq_item tx_packet = tx_seq_item::type_id::create("tx_packet", this);
    forever begin  
      @(posedge tx_vif.CLK);
        



    end
  endtask

endclass

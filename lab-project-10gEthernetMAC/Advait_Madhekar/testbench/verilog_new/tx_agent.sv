
`include "tx_driver.sv"
//`include "tx_monitor.sv"

typedef uvm_sequencer#(tx_seq_item) tx_sequencer;
typedef uvm_analysis_port#(tx_seq_item) tx_an_port;

class tx_agent extends uvm_agent;
  `uvm_component_utils(tx_agent)
  
  //agent attributes
  tx_sequencer tx_seqr;
  tx_driver tx_drv;
  tx_an_port tx_ap;
  //tx_monitor tx_mon;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //declarations
    tx_drv = tx_driver::type_id::create("tx_drv", this);
    tx_seqr = tx_sequencer::type_id::create("tx_seqr", this);
    //tx_monitor = tx_mon::type_id::create("tx_monitor", this);
    tx_ap = new("tx_ap", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   
    if(tx_seqr == null)	begin
      `uvm_fatal("TX_AG", "TX_SEQR STILL NULL!");
    end else
      `uvm_info("TX_AG", "TX_SEQR created successfully!", UVM_MEDIUM);
 
    if(tx_drv == null) begin
      `uvm_fatal("TX_AG", "TX_DRV STILL NULL!");
    end else
      `uvm_info("TX_AG", "TX_DRV created successfully!", UVM_MEDIUM);    
    //factory.print(); 
    //tx_drv.tx_seq_item_port.connect(tx_seqr.seq_item_export);
    tx_drv.tx_seq_item_port.connect(tx_seqr.seq_item_export);
  endfunction
endclass

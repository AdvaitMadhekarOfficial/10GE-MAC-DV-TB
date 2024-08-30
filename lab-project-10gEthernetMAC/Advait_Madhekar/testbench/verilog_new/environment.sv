//UVM_PKG
`include "uvm_macros.svh"
import uvm_pkg::*;


//TX
`include "tx_seq_item.sv"
`include "tx_agent.sv"

//RESET
`include "reset_seq_item.sv"
`include "reset_agent.sv"

//WB
`include "wb_seq_item.sv"
`include "wb_agent.sv"

//RX
//`include "rx_seq_item.sv"
//`include "rx_agent.sv"

//SCOREBOARD
//`include "scoreboard.sv"

class environment extends uvm_env;
  `uvm_component_utils(environment)
  
  //tx
  tx_agent tx_ag;
  
  //reset
  reset_agent rst_ag;

  //wb
  wb_agent wb_ag;

  //rx
  //rx_agent rx_ag;

  //scoreboard
  //scoreboard scb;

  function new(input string name, input uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV", $sformatf("Hello World!"), UVM_MEDIUM); 
    //tx dec
    tx_ag = tx_agent::type_id::create("tx_ag", this);
    
    //rx dec
    rst_ag = reset_agent::type_id::create("rst_ag", this);

    //wb dec
    wb_ag = wb_agent::type_id::create("wb_ag", this);

    //scb dec
    //scb = scoreboard::type_id::create("scb", this);
    
    //rx dec
    //rx_ag = rx_agent::type_id::create("rx_ag", this);

    //uvm_config_db#(reset_agent)::set(this, "*", "rst_ag", rst_ag);
    //virt_seqr dec
    //v_seqr = virt_seqr::type_id::create("v_seqr", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    //tx_ag.tx_ap.connect(scb.tx_ag_scb_port);
    //rx_ag.rx_ap.connect(scb.rx_ag_scb_port);
  endfunction

endclass


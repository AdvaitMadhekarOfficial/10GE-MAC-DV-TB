//ENVIRONMENT
`include "environment.sv"

//VIRTUAL SEQUENCER
`include "virt_seqr.sv"
//`include "virt_seq.sv"

//RESET TEST CASES
`include "reset_seq.sv"

//TX TEST CASES
`include "tx_seq.sv"

//WB TEST CASES
`include "wb_seq.sv"

class uvm_test_top extends uvm_test;
  `uvm_component_utils(uvm_test_top)
  
  //ENVIRONMENT
  environment env;
  
  //VIRTUAL SEQUENCER
  virt_seqr v_seqr;

  //SEQUENCES
  reset_seq rst_seq;
  tx_seq tx_seq_inst; 
  wb_seq wb_seq_inst;
  
  function new(input string name, input uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(input uvm_phase phase);
    super.build_phase(phase);
    
    rst_seq = reset_seq::type_id::create("rst_seq");
    tx_seq_inst = tx_seq::type_id::create("tx_seq_inst");
    wb_seq_inst = wb_seq::type_id::create("wb_seq_inst");

    `uvm_info("UVM_TOP", $sformatf("In UVM_TOP BUILD PHASE"), UVM_MEDIUM); 
  
    //environment creation
    env = environment::type_id::create("env", this);
    
    //setup vif
    uvm_config_db#(virtual reset_if)::set(this, "env.rst_ag.rst_drv", "rst_vif", top_tb.rst_if);  
    uvm_config_db#(virtual tx_if)::set(this, "env.tx_ag.tx_drv", "tx_vif", top_tb.tx_if_inst);  
    uvm_config_db#(virtual wb_if)::set(this, "env.wb_ag.wb_drv", "wb_vif", top_tb.wb_if_inst); 
    //uvm_config_db#(virtual rx_if)::set(this, "env.rx_ag.rx_mon", "rx_vif", top_tb.rx_if_inst);
    //setup v_seqr
    v_seqr = virt_seqr::type_id::create("v_seqr", this);

    `uvm_info("UVM_TOP", $sformatf("END UVM_TOP BUILD PHASE"), UVM_MEDIUM); 
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info("UVM_TOP", $sformatf("START UVM_TOP CONNECT PHASE"), UVM_MEDIUM);  
    v_seqr.rst_seqr = env.rst_ag.rst_seqr;
    v_seqr.tx_seqr = env.tx_ag.tx_seqr; 
    v_seqr.wb_seqr = env.wb_ag.wb_seqr;
     
    `uvm_info("UVM_TOP", $sformatf("END UVM_TOP CONNECT PHASE"), UVM_MEDIUM);  
  endfunction

  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
    factory.print();
  endfunction
 
  virtual task main_phase(uvm_phase phase);
    uvm_objection objection;
    super.main_phase(phase);
  endtask

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    rst_seq.start(env.rst_ag.rst_seqr);
    wb_seq_inst.start(env.wb_ag.wb_seqr);
    tx_seq_inst.start(env.tx_ag.tx_seqr);
  
    wb_seq_inst.start(env.wb_ag.wb_seqr);
    phase.drop_objection(this);
  endtask
endclass

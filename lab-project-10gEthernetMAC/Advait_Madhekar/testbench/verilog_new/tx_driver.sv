
class tx_driver extends uvm_driver;
  `uvm_component_utils(tx_driver)

  virtual tx_if tx_vif;
  //uvm_analysis_port #(tx_seq_item) tx_drv_ap;
  uvm_seq_item_pull_port#(tx_seq_item) tx_seq_item_port;
  tx_seq_item req;
  int num_clk_full_data, num_partial_data;
  bit sop_flag;
 
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual tx_if)::get(this, "", "tx_vif", tx_vif)) begin
      `uvm_fatal("TX_DRV", "Couldn't find tx_vif inside uvm_config_db");
    end else begin
      `uvm_info("TX_DRV", "tx_vif found successfully!", UVM_MEDIUM);
    end

    //does seq_item_port need to be constructed?
    //seq_item_port = uvm_seq_item_pull_port#(tx_seq_item)::type_id::create("seq_item_port", this);

    tx_seq_item_port = new("tx_seq_item_port", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin  // {
      tx_seq_item_port.get_next_item(req);
      req.print();

      $display("START DRIVING"); 
      num_clk_full_data = req.pkt_len/8;
      num_partial_data = req.pkt_len%8;
      sop_flag = 1; 
      @(posedge tx_vif.CLK);

      for (int i=0; i <num_clk_full_data; i++)  begin // {
        tx_vif.pkt_tx_val = 1'b1;
        tx_vif.pkt_tx_sop = sop_flag;
        tx_vif.pkt_tx_mod = 3'h0;
        if (num_partial_data == 0 && i+1 == num_clk_full_data) begin  
          tx_vif.pkt_tx_eop = 1;
        end else begin 
          tx_vif.pkt_tx_eop = 0;
        end

        tx_vif.pkt_tx_data = { req.pkt_tx_data[i*8+7],
                               req.pkt_tx_data[i*8+6],
                               req.pkt_tx_data[i*8+5],
                               req.pkt_tx_data[i*8+4],
                               req.pkt_tx_data[i*8+3],
                               req.pkt_tx_data[i*8+2],
                               req.pkt_tx_data[i*8+1],
                               req.pkt_tx_data[i*8]
                              };
        
        sop_flag = 0;
        @(posedge tx_vif.CLK);
      end // }

     // TBD - last clock drive for pkt data % 8 = nonzero value 
     if (num_partial_data > 0) begin 
        case (num_partial_data) 
          1 : begin 
                tx_vif.pkt_tx_data = { 8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,req.pkt_tx_data[req.pkt_len-1]}; 
                tx_vif.pkt_tx_mod = 3'h1; 
              end
          2 : begin tx_vif.pkt_tx_data = { 8'h00,8'h00,8'h00,8'h00,8'h00,8'h00, req.pkt_tx_data[req.pkt_len-2],req.pkt_tx_data[req.pkt_len-1]}; tx_vif.pkt_tx_mod = 3'h2; end
          3 : begin tx_vif.pkt_tx_data = { 8'h00,8'h00,8'h00,8'h00,8'h00, req.pkt_tx_data[req.pkt_len-3], req.pkt_tx_data[req.pkt_len-2], req.pkt_tx_data[req.pkt_len-1]}; tx_vif.pkt_tx_mod = 3'h3; end
          4 : begin tx_vif.pkt_tx_data = { 8'h00,8'h00,8'h00,8'h00,  req.pkt_tx_data[req.pkt_len-4],  req.pkt_tx_data[req.pkt_len-3], req.pkt_tx_data[req.pkt_len-2],req.pkt_tx_data[req.pkt_len-1]}; tx_vif.pkt_tx_mod = 3'h4; end
          5 : begin tx_vif.pkt_tx_data = { 8'h00,8'h00,8'h00, req.pkt_tx_data[req.pkt_len-5],  req.pkt_tx_data[req.pkt_len-4],  req.pkt_tx_data[req.pkt_len-3], req.pkt_tx_data[req.pkt_len-2],req.pkt_tx_data[req.pkt_len-1]}; tx_vif.pkt_tx_mod = 3'h5; end
          6 : begin tx_vif.pkt_tx_data = { 8'h00,8'h00, req.pkt_tx_data[req.pkt_len-6] , req.pkt_tx_data[req.pkt_len-5],  req.pkt_tx_data[req.pkt_len-4],  req.pkt_tx_data[req.pkt_len-3], req.pkt_tx_data[req.pkt_len-2],req.pkt_tx_data[req.pkt_len-1]}; tx_vif.pkt_tx_mod = 3'h6; end
          7 : begin tx_vif.pkt_tx_data = { 8'h00, req.pkt_tx_data[req.pkt_len-7] , req.pkt_tx_data[req.pkt_len-6] , req.pkt_tx_data[req.pkt_len-5],  req.pkt_tx_data[req.pkt_len-4],  req.pkt_tx_data[req.pkt_len-3], req.pkt_tx_data[req.pkt_len-2],req.pkt_tx_data[req.pkt_len-1]}; tx_vif.pkt_tx_mod = 3'h7; end
             
        endcase
        tx_vif.pkt_tx_eop = 1'b1;
        @(posedge tx_vif.CLK);
     end
     
     tx_vif.pkt_tx_val = 1'b0;
     tx_vif.pkt_tx_sop = 1'b0;
     tx_vif.pkt_tx_eop = 1'b0;
     tx_vif.pkt_tx_mod = 3'h0;





      //@(posedge tx_vif.CLK);
      // for(int i = 0; i < req.pkt_len / 8; i += 8) begin
      //   tx_vif.pkt_tx_val = 1'b1;
      //   if(i == 0) begin
      //     tx_vif.pkt_tx_sop = 1'b1;
      //     tx_vif.pkt_tx_eop = 1'b0;
      //   end else if(i + 8 >= req.pkt_len) begin
      //     tx_vif.pkt_tx_eop = 1'b1;
      //     tx_vif.pkt_tx_mod = req.pkt_len % 8;
      //   end else begin
      //     tx_vif.pkt_tx_sop = 1'b0;
      //   end

      //   tx_vif.pkt_tx_data = {
      //                           req.pkt_tx_data[i+7],
      //                           req.pkt_tx_data[i+6],
      //                           req.pkt_tx_data[i+5],
      //                           req.pkt_tx_data[i+4],
      //                           req.pkt_tx_data[i+3],
      //                           req.pkt_tx_data[i+2],
      //                           req.pkt_tx_data[i+1],
      //                           req.pkt_tx_data[i]
      //                         };
      //   //$display("SOP: %0b", tx_vif.pkt_tx_sop); 
      //   //$display("DATA: %h", tx_vif.pkt_tx_data);
      // end
      //tx_vif.pkt_tx_val = 1'b0;
      //tx_vif.pkt_tx_eop = 1'b1;
      //tx_vif.pkt_tx_mod = 3'b0;  
      


      tx_seq_item_port.item_done();
    end // } forever
  endtask

  /*
  virtual task drive_item(tx_seq_item req);
    fork
      begin
        @(posedge tx_vif.CLK);
          if(!tx_vif.pkt_tx_full) begin
            //tx_vif.pkt_tx_data <= req.pkt_tx_data;
            tx_vif.pkt_tx_data <= 0; //TBD
            tx_vif.pkt_tx_val  <= req.pkt_tx_val;
            tx_vif.pkt_tx_sop  <= req.pkt_tx_sop;
            tx_vif.pkt_tx_eop  <= req.pkt_tx_eop;
            tx_vif.pkt_tx_mod  <= req.pkt_tx_mod;
          end
      end
    join 
  endtask
  */
endclass

class tx_seq extends uvm_sequence #(tx_seq_item);
  `uvm_object_utils(tx_seq)

  tx_seq_item req;

  function new(string name = "tx_seq");
    super.new(name);
  endfunction

  virtual task body();
   int num_pkts;
    if(starting_phase != null) begin
      starting_phase.raise_objection(this);
    end    
 
   num_pkts = 100;
   for (int i=0; i < num_pkts; i++) begin  //
        req = new();

        //req.pkt_len = 65 + i*8;
        req.pkt_len = (64 + i) % 1518;
        //req.pkt_tx_data = new[req.pkt_len];
        for(int i = 0; i < req.pkt_len; i++) begin
          req.pkt_tx_data[i] = $urandom();
        end

        req.print();
        
        `uvm_send(req);
   end // }

    if(starting_phase != null) begin
      starting_phase.drop_objection(this);
    end

  endtask

endclass

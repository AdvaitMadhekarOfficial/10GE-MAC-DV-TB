

class tx_seq_item extends uvm_sequence_item;
  `uvm_object_utils(tx_seq_item)
  
  rand bit [7 :0] pkt_tx_data[2000];
  bit err_recv; 
  int pkt_len;

  function new(string name = "req");
    super.new(name);
    this.err_recv = 0;
    //this.pkt_len = 64;
    //for(int i = 0; i < this.pkt_len; i++) begin
    //  this.pkt_tx_data[i] = $urandom();
    //end
  endfunction

  function print();
    $display("PRINTING FROM PACKET OBJECT. LEN = %0d", this.pkt_len);
    for(int i = 0; i < this.pkt_len; i++) begin
      $display("pkt[%0d] = 0x%0h", i, this.pkt_tx_data[i]);
    end
  endfunction
endclass

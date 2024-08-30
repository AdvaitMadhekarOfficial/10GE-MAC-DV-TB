

class rx_seq_item extends uvm_sequence_item;
  `uvm_object_utils(rx_seq_item)

  bit [7:0] pkt_rx_data[2000];
  bit err_recv;
  int pkt_len;

  function new(string name = "req");
    super.new(name);
    this.err_recv = 0;
  endfunction


endclass

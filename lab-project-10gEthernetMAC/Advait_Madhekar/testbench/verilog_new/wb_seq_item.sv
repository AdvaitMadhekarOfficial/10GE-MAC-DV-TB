
class wb_seq_item extends uvm_sequence_item;
  `uvm_object_utils(wb_seq_item)

  bit [7 :0] wb_adr_i;
  //bit        wb_cyc_i;
  bit [31:0] wb_dat_i;
  //bit        wb_stb_i;
  //bit        wb_we_i; 
  
  function new(string name = "req");
    super.new(name);
  endfunction
 
  function print();
    $display("PRINTING WB PACKET: ");
  endfunction
endclass

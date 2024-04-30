
typedef enum {READ_DATA, WRITE_DATA} i2c_seq_action;
class i2c_req_transfer extends uvm_sequence_item;
	rand i2c_seq_action seq_action;
  	rand bit [DATA_WIDTH-1:0] data;
  rand bit [ADDRESS_WIDTH-1:0] address;
  
  constraint data_con {
  	solve seq_action before data;
    (seq_action == READ_DATA) -> data == 0;
    address inside {[0:3]};
  }
  
 // extern constraint i2c_test_constraint;
  
  `uvm_object_utils_begin(i2c_req_transfer)
  `uvm_field_int(data, UVM_DEFAULT)
  `uvm_field_int(address, UVM_DEFAULT)
  `uvm_field_enum(i2c_seq_action, seq_action, UVM_DEFAULT)
  `uvm_object_utils_end
  
  function new (string name="i2c_req_transfer");
    super.new(name);
  endfunction
endclass : i2c_req_transfer
/*
class i2c_req_transfer_read extends i2c_req_transfer;
  `uvm_object_utils(i2c_req_transfer_read)
  
  function new (string name="i2c_req_transfer_read");
    super.new(name);
  endfunction
  
  constraint just_read {seq_action == READ_DATA;}
endclass

class i2c_req_transfer_write extends i2c_req_transfer;
  `uvm_object_utils(i2c_req_transfer_write)
  
  function new (string name="i2c_req_transfer_write");
    super.new(name);
  endfunction
  
  constraint just_write {seq_action == WRITE_DATA;}
endclass
*/
class uvm_i2c_sequencer extends uvm_sequencer #(i2c_req_transfer);
  `uvm_component_utils(uvm_i2c_sequencer);
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass : uvm_i2c_sequencer
class uvm_i2c_sequence extends uvm_sequence #(i2c_req_transfer);
  `uvm_object_utils(uvm_i2c_sequence)
  rand logic [2:0] run_num_actions;
//  logic [3:0] run_num_actions = 1;
  function new (string name="uvm_i2c_sequence");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(this.get_name(), "Running I2C sequence body", UVM_NONE)
    this.randomize();
    
    `uvm_info(this.get_name(), $sformatf("Running %0d xactions",run_num_actions), UVM_NONE)
    for (int action_n=0; action_n<run_num_actions; action_n++) begin
      `uvm_do_with(req,{device_address == 7'b001_0001;})
    end
  endtask
endclass : uvm_i2c_sequence

class uvm_i2c_sequence_single_read extends uvm_i2c_sequence #(i2c_req_transfer);
  `uvm_object_utils(uvm_i2c_sequence_single_read)
  function new (string name="uvm_i2c_sequence_single_read");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(this.get_name(), "Running I2C SINGLE READ sequence body", UVM_NONE)
    this.randomize();    
    `uvm_do_with(req, {seq_action == READ_DATA;device_address == 7'b001_0001;})
  endtask
endclass : uvm_i2c_sequence_single_read

class uvm_i2c_sequence_single_write extends uvm_i2c_sequence #(i2c_req_transfer);
  `uvm_object_utils(uvm_i2c_sequence_single_write)
  function new (string name="uvm_i2c_sequence_single_write");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(this.get_name(), "Running I2C SINGLE WRITE sequence body", UVM_NONE)
    this.randomize();    
    `uvm_do_with(req, {seq_action == WRITE_DATA;device_address == 7'b001_0001;})
  endtask
endclass : uvm_i2c_sequence_single_write

class uvm_i2c_sequence_multiple_read extends uvm_i2c_sequence #(i2c_req_transfer);
  `uvm_object_utils(uvm_i2c_sequence_multiple_read)
  rand logic [2:0] run_num_actions;
  
  function new (string name="uvm_i2c_sequence_multiple_read");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(this.get_name(), "Running I2C MULTIPLE READ sequence body", UVM_NONE)
    this.randomize();    
    `uvm_info(this.get_name(), $sformatf("Running %0d xactions",run_num_actions), UVM_NONE)
    for (int action_n=0; action_n<run_num_actions; action_n++) begin
	    `uvm_do_with(req, {seq_action == READ_DATA;device_address == 7'b001_0001;})
    end
  endtask
endclass : uvm_i2c_sequence_multiple_read

class uvm_i2c_sequence_multiple_write extends uvm_i2c_sequence #(i2c_req_transfer);
  `uvm_object_utils(uvm_i2c_sequence_multiple_write)
  rand logic [2:0] run_num_actions;
  
  function new (string name="uvm_i2c_sequence_multiple_write");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(this.get_name(), "Running I2C MULTIPLE WRITE sequence body", UVM_NONE)
    this.randomize();    
    `uvm_info(this.get_name(), $sformatf("Running %0d xactions",run_num_actions), UVM_NONE)
    for (int action_n=0; action_n<run_num_actions; action_n++) begin
      `uvm_do_with(req, {seq_action == WRITE_DATA;device_address == 7'b001_0001;})
    end
  endtask
endclass : uvm_i2c_sequence_multiple_write

class uvm_i2c_sequence_general_call extends uvm_i2c_sequence #(i2c_req_transfer);
  `uvm_object_utils(uvm_i2c_sequence_general_call)
  
  function new (string name="uvm_i2c_sequence_general_call");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(this.get_name(), "Running I2C GENERAL CALL ADDRESS sequence body", UVM_NONE)
    this.randomize();    
    `uvm_do_with(req, {
      seq_action == WRITE_DATA;
      device_address == 0;
      address == 8'b0000_0100;
    })
  endtask
endclass : uvm_i2c_sequence_general_call

class uvm_i2c_sequence_software_reset extends uvm_i2c_sequence #(i2c_req_transfer);
  `uvm_object_utils(uvm_i2c_sequence_software_reset)
  
  function new (string name="uvm_i2c_sequence_software_reset");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(this.get_name(), "Running I2C SOFTWARE RESET sequence body", UVM_NONE)
    this.randomize();    
    `uvm_do_with(req, {
      seq_action == WRITE_DATA;
      device_address == 0;
      address == 8'b0000_0110;
    })
  endtask
endclass : uvm_i2c_sequence_software_reset


class uvm_i2c_sequence_system_coherency extends uvm_i2c_sequence #(i2c_req_transfer);
  `uvm_object_utils(uvm_i2c_sequence_system_coherency)
  rand bit [REGISTER_WIDTH-1:0] reg_address;  
  function new (string name="uvm_i2c_sequence_system_coherency");
    super.new(name);
  endfunction
  
  constraint reg_address_con {
    reg_address inside {[0:MEM_SIZE-1]};
  }
  
  
  task body();
    `uvm_info(this.get_name(), "Running I2C SYTEM COHERENCY sequence body", UVM_NONE)
    this.randomize();    
    `uvm_do_with(req, {
      seq_action == WRITE_DATA;
      device_address == 7'b001_0001;
      address == reg_address;
    })
    `uvm_do_with(req, {
      seq_action == READ_DATA;
      device_address == 7'b001_0001;
      address == reg_address;
    })
  endtask
endclass : uvm_i2c_sequence_system_coherency

class uvm_i2c_sequence_system_multiple_clients extends uvm_i2c_sequence #(i2c_req_transfer);
  
  `uvm_object_utils(uvm_i2c_sequence_system_multiple_clients)
  rand bit [REGISTER_WIDTH-1:0] reg_address[4]; 
  rand bit [1:0] client_device_select[4];
  rand bit [1:0] run_num_actions;

  function new (string name="uvm_i2c_sequence_system_multiple_clients");
    super.new(name);
  endfunction
  
  constraint reg_address_con {
//    reg_address inside {[0:MEM_SIZE-1]};
//    client_device_select < CLIENT_DEVICES;
    run_num_actions > 1;
  }
  constraint array_c { foreach(reg_address[i]) reg_address[i] inside {[0:MEM_SIZE-1]};}
  constraint array_c2 { foreach(client_device_select[i]) client_device_select[i] < CLIENT_DEVICES;}

  task body();
    
    this.randomize(); 

    `uvm_info(this.get_name(), "Running I2C SYTEM MULTIPLE CLIENTS sequence body", UVM_NONE)
    `uvm_info(this.get_name(), $sformatf("Running %0d xactions",run_num_actions), UVM_NONE)
    
    for (int action_n=0; action_n<run_num_actions; action_n++) begin
      `uvm_info(this.get_name(), $sformatf("Client device selected %0b",client_device_select[action_n]), UVM_NONE)
      `uvm_info(this.get_name(), $sformatf("Register address selected %0b",reg_address[action_n]), UVM_NONE)
      `uvm_do_with(req, {
        seq_action == WRITE_DATA;
        device_address == DEVICE_ADDRESSES[client_device_select[action_n]];//[action_n];
        address == reg_address[action_n];
      })
    end
    
    for (int action_n=0; action_n<run_num_actions; action_n++) begin
      `uvm_info(this.get_name(), $sformatf("Client device selected %0b",client_device_select[action_n]), UVM_NONE)
      `uvm_info(this.get_name(), $sformatf("Register address selected %0b",reg_address[action_n]), UVM_NONE)
      `uvm_do_with(req, {
        seq_action == READ_DATA;
        device_address == DEVICE_ADDRESSES[client_device_select[action_n]];
        address == reg_address[action_n];
      })
    end

  endtask
endclass : uvm_i2c_sequence_system_multiple_clients

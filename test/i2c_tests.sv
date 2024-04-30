class uvm_i2c_single_read_test extends uvm_i2c_base_test;
  `uvm_component_utils(uvm_i2c_single_read_test)
    
  uvm_i2c_sequence_single_read uvm_i2c_seq0;
  uvm_i2c_sequence_single_read uvm_i2c_seq1;
  
  function new(string name = "single_read_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(this.get_name(), "UVM Constructing I2C single read test", UVM_NONE)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(this.get_name(), "UVM I2C Single Read Test Alive", UVM_NONE)
   // set_type_override_by_type(i2c_req_transfer::get_type(), i2c_req_transfer_read::get_type());
  endfunction
  
  virtual task main_phase(uvm_phase phase);
   // super.main_phase(phase);
    phase.raise_objection(this);
    `uvm_info(this.get_name(), "Running run-main phase", UVM_NONE)
    #1000;
    
    `uvm_info(this.get_name(), "Creating uvm_i2c_seq0", UVM_NONE)
    uvm_i2c_seq0 =  uvm_i2c_sequence_single_read::type_id::create("uvm_i2c_seq0");
    uvm_i2c_seq1 =  uvm_i2c_sequence_single_read::type_id::create("uvm_i2c_seq1");

    //uvm_i2c_seq1 =  uvm_i2c_sequence::type_id::create("uvm_i2c_seq1");
    
    uvm_i2c_seq0.start(uvm_i2c_env0.uvm_i2c_agent0.uvm_i2c_sequencer0);
   // uvm_i2c_seq1.start(uvm_i2c_client_env0.uvm_i2c_agent1.uvm_i2c_sequencer1);
    
    `uvm_info(this.get_name(), "Ending run-main phase", UVM_NONE)
    phase.drop_objection(this);
  endtask
  
endclass : uvm_i2c_single_read_test


class uvm_i2c_single_write_test extends uvm_i2c_base_test;
  `uvm_component_utils(uvm_i2c_single_write_test)
    
  uvm_i2c_sequence_single_write uvm_i2c_seq0;
  uvm_i2c_sequence_single_write uvm_i2c_seq1;
  
  function new(string name = "single_write_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(this.get_name(), "UVM Constructing I2C single Write test", UVM_NONE)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(this.get_name(), "UVM I2C Single Write Test Alive", UVM_NONE)
   // set_type_override_by_type(i2c_req_transfer::get_type(), i2c_req_transfer_read::get_type());
  endfunction
  
  virtual task main_phase(uvm_phase phase);
   // super.main_phase(phase);
    phase.raise_objection(this);
    `uvm_info(this.get_name(), "Running run-main phase", UVM_NONE)
    #1000;
    
    `uvm_info(this.get_name(), "Creating uvm_i2c_seq0", UVM_NONE)
    uvm_i2c_seq0 =  uvm_i2c_sequence_single_write::type_id::create("uvm_i2c_seq0");
    uvm_i2c_seq1 =  uvm_i2c_sequence_single_write::type_id::create("uvm_i2c_seq1");

    //uvm_i2c_seq1 =  uvm_i2c_sequence::type_id::create("uvm_i2c_seq1");
    
    uvm_i2c_seq0.start(uvm_i2c_env0.uvm_i2c_agent0.uvm_i2c_sequencer0);
   // uvm_i2c_seq1.start(uvm_i2c_client_env0.uvm_i2c_agent1.uvm_i2c_sequencer1);
    
    `uvm_info(this.get_name(), "Ending run-main phase", UVM_NONE)
    phase.drop_objection(this);
  endtask
  
endclass : uvm_i2c_single_write_test

class uvm_i2c_multiple_read_test extends uvm_i2c_base_test;

    `uvm_component_utils(uvm_i2c_multiple_read_test)
    
  uvm_i2c_sequence_multiple_read uvm_i2c_seq0;
  uvm_i2c_sequence_multiple_read uvm_i2c_seq1;
  
  function new(string name = "uvm_i2c_multiple_read_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(this.get_name(), "UVM Constructing I2C Multiple READ test", UVM_NONE)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(this.get_name(), "UVM I2C Multiple READ Test Alive", UVM_NONE)
   // set_type_override_by_type(i2c_req_transfer::get_type(), i2c_req_transfer_read::get_type());
  endfunction
  
  virtual task main_phase(uvm_phase phase);
   // super.main_phase(phase);
    phase.raise_objection(this);
    `uvm_info(this.get_name(), "Running run-main phase", UVM_NONE)
    #1000;
    
    `uvm_info(this.get_name(), "Creating uvm_i2c_seq0", UVM_NONE)
    uvm_i2c_seq0 =  uvm_i2c_sequence_multiple_read::type_id::create("uvm_i2c_seq0");
    uvm_i2c_seq1 =  uvm_i2c_sequence_multiple_read::type_id::create("uvm_i2c_seq1");

    //uvm_i2c_seq1 =  uvm_i2c_sequence::type_id::create("uvm_i2c_seq1");
    
    uvm_i2c_seq0.start(uvm_i2c_env0.uvm_i2c_agent0.uvm_i2c_sequencer0);
   // uvm_i2c_seq1.start(uvm_i2c_client_env0.uvm_i2c_agent1.uvm_i2c_sequencer1);
    
    `uvm_info(this.get_name(), "Ending run-main phase", UVM_NONE)
    phase.drop_objection(this);
  endtask

endclass : uvm_i2c_multiple_read_test

class uvm_i2c_multiple_write_test extends uvm_i2c_base_test;

    `uvm_component_utils(uvm_i2c_multiple_write_test)
    
  uvm_i2c_sequence_multiple_write uvm_i2c_seq0;
  //uvm_i2c_sequence_multiple_write uvm_i2c_seq1;
  
  function new(string name = "uvm_i2c_multiple_write_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(this.get_name(), "UVM Constructing I2C Multiple WRITE test", UVM_NONE)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(this.get_name(), "UVM I2C Multiple WRITE Test Alive", UVM_NONE)
   // set_type_override_by_type(i2c_req_transfer::get_type(), i2c_req_transfer_read::get_type());
  endfunction
  
  virtual task main_phase(uvm_phase phase);
   // super.main_phase(phase);
    phase.raise_objection(this);
    `uvm_info(this.get_name(), "Running run-main phase", UVM_NONE)
    #1000;
    
    `uvm_info(this.get_name(), "Creating uvm_i2c_seq0", UVM_NONE)
    uvm_i2c_seq0 =  uvm_i2c_sequence_multiple_write::type_id::create("uvm_i2c_seq0");
//    uvm_i2c_seq1 =  uvm_i2c_sequence_multiple_write::type_id::create("uvm_i2c_seq1");

    //uvm_i2c_seq1 =  uvm_i2c_sequence::type_id::create("uvm_i2c_seq1");
    
    uvm_i2c_seq0.start(uvm_i2c_env0.uvm_i2c_agent0.uvm_i2c_sequencer0);
   // uvm_i2c_seq1.start(uvm_i2c_client_env0.uvm_i2c_agent1.uvm_i2c_sequencer1);
    
    `uvm_info(this.get_name(), "Ending run-main phase", UVM_NONE)
    phase.drop_objection(this);
  endtask

endclass : uvm_i2c_multiple_write_test

class uvm_i2c_general_call_address_test extends uvm_i2c_base_test;
  
    `uvm_component_utils(uvm_i2c_general_call_address_test)
    
  uvm_i2c_sequence_general_call uvm_i2c_seq0;
  //uvm_i2c_sequence_multiple_write uvm_i2c_seq1;
  
  function new(string name = "uvm_i2c_general_call_address_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(this.get_name(), "UVM Constructing I2C GENERAL CALL ADDRESS test", UVM_NONE)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(this.get_name(), "UVM I2C GENERAL CALL ADDRESS Test Alive", UVM_NONE)
    set_type_override_by_type(uvm_i2c_scoreboard::get_type(), uvm_i2c_scoreboard_general_call::get_type());
  endfunction
  
  virtual task main_phase(uvm_phase phase);
   // super.main_phase(phase);
    phase.raise_objection(this);
    `uvm_info(this.get_name(), "Running run-main phase", UVM_NONE)
    #1000;
    
    `uvm_info(this.get_name(), "Creating uvm_i2c_seq0", UVM_NONE)
    uvm_i2c_seq0 =  uvm_i2c_sequence_general_call::type_id::create("uvm_i2c_seq0");
//    uvm_i2c_seq1 =  uvm_i2c_sequence_multiple_write::type_id::create("uvm_i2c_seq1");

    //uvm_i2c_seq1 =  uvm_i2c_sequence::type_id::create("uvm_i2c_seq1");
    
    uvm_i2c_seq0.start(uvm_i2c_env0.uvm_i2c_agent0.uvm_i2c_sequencer0);
   // uvm_i2c_seq1.start(uvm_i2c_client_env0.uvm_i2c_agent1.uvm_i2c_sequencer1);
    
    `uvm_info(this.get_name(), "Ending run-main phase", UVM_NONE)
    phase.drop_objection(this);
  endtask
  
endclass : uvm_i2c_general_call_address_test

class uvm_i2c_software_reset_test extends uvm_i2c_base_test;
  
    `uvm_component_utils(uvm_i2c_software_reset_test)
    
  uvm_i2c_sequence_software_reset uvm_i2c_seq0;
  //uvm_i2c_sequence_multiple_write uvm_i2c_seq1;
  
  function new(string name = "uvm_i2c_software_reset_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(this.get_name(), "UVM Constructing I2C SOFTWARE RESET test", UVM_NONE)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(this.get_name(), "UVM I2C SOFTWARE RESET Test Alive", UVM_NONE)
    set_type_override_by_type(uvm_i2c_scoreboard::get_type(), uvm_i2c_scoreboard_software_reset::get_type());
  endfunction
  
  virtual task main_phase(uvm_phase phase);
   // super.main_phase(phase);
    phase.raise_objection(this);
    `uvm_info(this.get_name(), "Running run-main phase", UVM_NONE)
    #1000;
    
    `uvm_info(this.get_name(), "Creating uvm_i2c_seq0", UVM_NONE)
    uvm_i2c_seq0 =  uvm_i2c_sequence_software_reset::type_id::create("uvm_i2c_seq0");
//    uvm_i2c_seq1 =  uvm_i2c_sequence_multiple_write::type_id::create("uvm_i2c_seq1");

    //uvm_i2c_seq1 =  uvm_i2c_sequence::type_id::create("uvm_i2c_seq1");
    
    uvm_i2c_seq0.start(uvm_i2c_env0.uvm_i2c_agent0.uvm_i2c_sequencer0);
   // uvm_i2c_seq1.start(uvm_i2c_client_env0.uvm_i2c_agent1.uvm_i2c_sequencer1);
    
    `uvm_info(this.get_name(), "Ending run-main phase", UVM_NONE)
    phase.drop_objection(this);
  endtask
  
endclass : uvm_i2c_software_reset_test

/*class i2c_rand_tests extends i2c_base_test;
  function new(virtual i2c_if i2c_if);
    super.new(i2c_if);
    $display("Constructing data_rand test");
  endfunction
  virtual task run_test();
    int scenarios = $urandom_range(0,3);
    for(int i=0; i<scenarios; i++) begin
      rand_write_data = $urandom_range(0,(2**DATA_WIDTH)-1);
      rand_register_address = $urandom_range(0,3);
      i2c_tb_env0.env_run();
      write_data(rand_write_data,rand_register_address);
      read_data(rand_register_address);
    end
    #500;
  endtask
endclass

class i2c_serial_test extends i2c_base_test;
  function new(virtual i2c_if i2c_if);
    super.new(i2c_if);
    $display("Constructing data_serial test");
  endfunction
  virtual task run_test();

    for(int i=0; i<4; i++) begin
      rand_write_data = $urandom_range(0,(2**DATA_WIDTH)-1);
      i2c_tb_env0.env_run();
      write_data(rand_write_data,i);
      read_data(i);
    end
    #500;
  endtask
endclass

class i2c_single_test extends i2c_base_test;
  function new(virtual i2c_if i2c_if);
    super.new(i2c_if);
    $display("Constructing data_single test");
  endfunction
  virtual task run_test();
      i2c_tb_env0.env_run();
    write_data(8'hCA,8'h00);
    read_data(8'h00);
    #500;
  endtask
endclass
*/
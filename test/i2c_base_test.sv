class uvm_i2c_base_test extends uvm_test;
  `uvm_component_utils(uvm_i2c_base_test)
  uvm_i2c_env uvm_i2c_env0;
  uvm_i2c_sequence uvm_i2c_seq0;
  uvm_i2c_sequence uvm_i2c_seq1;

  uvm_i2_client_env uvm_i2c_client_env0;
  uvm_i2c_client_agent_configuration client_cfg;

  function new (string name = "uvm_i2c_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    client_cfg = uvm_i2c_client_agent_configuration::type_id::create("client_cfg", this);
    uvm_config_db#(uvm_i2c_client_agent_configuration)::set(this, "*", "uvm_i2c_client_agent_configuration", client_cfg);
    
    `uvm_info(this.get_name(), "UVM I2C Base Test Alive", UVM_NONE)
    
    uvm_i2c_env0 = uvm_i2c_env::type_id::create("uvm_i2c_env0", this);
    uvm_i2c_client_env0 = uvm_i2_client_env::type_id::create("uvm_i2c_client_env0", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    `uvm_info(this.get_name(), "Running connect phase", UVM_NONE)
  endfunction
  
  function void end_of_elaboration_phase (uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    
    uvm_top.print_topology();
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    
    `uvm_info(this.get_name(), "Running start of simulation phase", UVM_NONE)
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info(this.get_name(),"Running run phase",UVM_NONE)
    #1000;
    `uvm_info(this.get_name(),"Ending run phase",UVM_NONE)
    phase.drop_objection(this);
  endtask
  
  task pre_reset_phase(uvm_phase phase);
    super.pre_reset_phase(phase);
    phase.raise_objection(this);
    `uvm_info(this.get_name(), "Running run-prereset phase", UVM_NONE)
    #10;
    `uvm_info(this.get_name(), "Ending run-prereset phase", UVM_NONE)
    phase.drop_objection(this);
  endtask
  
  task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this);
    
    `uvm_info(this.get_name(), "Running run-reset phase", UVM_NONE)
    #10;
    uvm_i2c_env0.uvm_i2c_agent0.uvm_i2c_drv0.reset();
    if(!uvm_config_db#(uvm_i2c_client_agent_configuration)::get(this,"*","uvm_i2c_client_agent_configuration",client_cfg))
	begin
      `uvm_fatal(this.get_name(),"Configuration object is not set properly")
    end
    
    if(client_cfg.active_or_passive == UVM_ACTIVE)begin
	    uvm_i2c_client_env0.uvm_i2c_agent1.uvm_i2c_drv1.reset();
    end
    `uvm_info(this.get_name(), "Ending run-reset phase", UVM_NONE)
    phase.drop_objection(this);    
  endtask
  
  task post_reset_phase(uvm_phase phase);
    super.post_reset_phase(phase);
    phase.raise_objection(this);
    `uvm_info(this.get_name(), "Running run-postreset phase", UVM_NONE)
    #10;
    `uvm_info(this.get_name(), "Ending run-postreset phase", UVM_NONE)
    phase.drop_objection(this);
  endtask
  
  task configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    phase.raise_objection(this);
    `uvm_info(this.get_name(),  "Running run-configure phase", UVM_NONE)
    #10;
    `uvm_info(this.get_name(), "Ending run-configure phase", UVM_NONE)
    phase.drop_objection(this);
  endtask
  
  task main_phase(uvm_phase phase);
    super.main_phase(phase);
    phase.raise_objection(this);
    `uvm_info(this.get_name(), "Running run-main phase", UVM_NONE)
    #1000;
    
    `uvm_info(this.get_name(), "Creating uvm_i2c_seq0", UVM_NONE)
    uvm_i2c_seq0 =  uvm_i2c_sequence::type_id::create("uvm_i2c_seq0");
    uvm_i2c_seq1 =  uvm_i2c_sequence::type_id::create("uvm_i2c_seq1");

    
    uvm_i2c_seq0.start(uvm_i2c_env0.uvm_i2c_agent0.uvm_i2c_sequencer0);
   // uvm_i2c_seq1.start(uvm_i2c_client_env0.uvm_i2c_agent1.uvm_i2c_sequencer1);
    
    `uvm_info(this.get_name(), "Ending run-main phase", UVM_NONE)
    phase.drop_objection(this);
  endtask
  
  task shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    phase.raise_objection(this);
    `uvm_info(this.get_name(), "Running run-shutdown phase", UVM_NONE)
    #10;
    `uvm_info(this.get_name(), "Ending run-shutdown phase", UVM_NONE)
    phase.drop_objection(this);
  endtask
    
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(this.get_name(), "Running extract phase", UVM_NONE)
  endfunction
  
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info(this.get_name(), "Running check phase", UVM_NONE)
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(this.get_name(), "Running report phase", UVM_NONE)
  endfunction
  
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info(this.get_name(), "Running final phase", UVM_NONE)
  endfunction
endclass

/*
class i2c_base_test;
  i2c_tb_env i2c_tb_env0;
  
  rand logic [DATA_WIDTH-1:0] rand_write_data;
  rand logic [REGISTER_WIDTH-1:0]    rand_register_address;
  
  function new(virtual i2c_if i2c_if);
    $display("Constructing base test");
    i2c_tb_env0 = new(i2c_if);
  endfunction
  
  virtual task run_test();

    rand_write_data = $urandom_range(0,(2**DATA_WIDTH)-1);
    rand_register_address = $urandom_range(0,3);
    i2c_tb_env0.env_run();
    write_data(rand_write_data,rand_register_address);
    read_data(rand_register_address);

    #500;
  endtask
  
  task write_data(logic [DATA_WIDTH-1:0] write_data,logic [REGISTER_WIDTH-1:0]    register_address);
    $display(" Writing value 0x%0h to address 0x%1h",write_data,register_address);
    $display("Configuring master");
    i2c_tb_env0.i2c_drv0.wait_tb_clock();
    i2c_tb_env0.i2c_drv0.set_write();
    i2c_tb_env0.i2c_drv0.set_reg_address(register_address);//8'h00);
    i2c_tb_env0.i2c_drv0.set_write_data(write_data);//8'hAC);
    i2c_tb_env0.i2c_drv0.set_device_address(7'b001_0001);
    i2c_tb_env0.i2c_drv0.set_divider();
    i2c_tb_env0.i2c_drv0.wait_tb_clock();
    $display("Enabling master");
    i2c_tb_env0.i2c_drv0.master_enable();
    i2c_tb_env0.i2c_drv0.wait_posedge_busy();
    $display("Master has started writing");
    i2c_tb_env0.i2c_drv0.master_disable();
    i2c_tb_env0.i2c_drv0.wait_negedge_busy();
    $display("Master has finsihed writing");
  endtask
  
  task read_data(logic [REGISTER_WIDTH-1:0] register_address);
    $display("Reading from address 0x%0h",register_address);
    $display("Configuring master");
    i2c_tb_env0.i2c_drv0.wait_tb_clock();
    i2c_tb_env0.i2c_drv0.set_read();
    i2c_tb_env0.i2c_drv0.set_reg_address(register_address);//8'h00);
    i2c_tb_env0.i2c_drv0.set_write_data(8'h00);
    i2c_tb_env0.i2c_drv0.set_device_address(7'b001_0001);
    i2c_tb_env0.i2c_drv0.wait_tb_clock();
    $display("Enabling master");
    i2c_tb_env0.i2c_drv0.master_enable();
    i2c_tb_env0.i2c_drv0.wait_posedge_busy();
    $display("Master has started reading");
    i2c_tb_env0.i2c_drv0.master_disable();
    i2c_tb_env0.i2c_drv0.wait_negedge_busy();
    $display("Master has finsihed reading");
  	$display("data read 0x%0h",i2c_tb_env0.i2c_vif.miso_data);
  endtask
endclass
*/
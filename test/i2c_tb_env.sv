class uvm_i2c_env extends uvm_env;
  `uvm_component_utils(uvm_i2c_env)
  
  uvm_i2c_agent uvm_i2c_agent0;
  uvm_i2c_scoreboard uvm_i2c_scoreboard0;
  
  
  virtual i2c_if i2c_vif;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    `uvm_info(this.get_name(),"UVM env alive", UVM_NONE)
    
    uvm_i2c_agent0 = uvm_i2c_agent::type_id::create("uvm_i2c_agent0", this);
    uvm_i2c_scoreboard0 = uvm_i2c_scoreboard::type_id::create("uvm_i2c_scoreboard0", this);
    
    if (!uvm_config_db #(virtual i2c_if)::get(this,"","i2c_vif",i2c_vif))
      `uvm_fatal(get_name(), "Failed to get i2c_if from config_db")
   endfunction
      
      function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    uvm_i2c_agent0.i2c_agent_mon_put_port.connect(uvm_i2c_scoreboard0.i2c_scbd_put_export);
  endfunction
endclass


/*
typedef struct{
    logic reset_n;
    logic enable;
    logic read_write;
	logic [DATA_WIDTH-1:0] mosi_data;
  	logic [REGISTER_WIDTH-1:0] register_address;
  	logic [ADDRESS_WIDTH-1:0] device_address;
  	logic [15:0] divider;

  	logic [DATA_WIDTH-1:0] miso_data;
    logic busy;

    logic sda;//external_serial_data;
    logic scl;//external_serial_clock;
} i2c_pkt;

typedef class i2c_monitor;
typedef class i2c_driver;
typedef class i2c_checker;
  
class i2c_tb_env;
	virtual i2c_if i2c_vif;
  	i2c_monitor i2c_mon0;
  	i2c_driver i2c_drv0;
	i2c_checker i2c_check0;
  
  mailbox #(i2c_pkt) mbox_i2c_env;
  function new(virtual i2c_if i2c_if);
    $display("[I2C-ENV] %0t - created sr_tb_env", $time);
    mbox_i2c_env = new();
    i2c_vif = i2c_if;
    i2c_mon0 = new(i2c_if, mbox_i2c_env);

    i2c_drv0 = new(i2c_if);
    i2c_check0 = new(mbox_i2c_env);
  endfunction
  
  task env_run();
  	fork
      i2c_mon0.monitor_run();
      i2c_check0.run_checker();
    join_none
    $display("[I2C-ENV] %0t - sr_tb_env running", $time);
  endtask
endclass
*/
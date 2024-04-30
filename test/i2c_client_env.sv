class uvm_i2_client_env extends uvm_env;
  `uvm_component_utils(uvm_i2_client_env)
  
  uvm_i2c_client_agent uvm_i2c_agent1;
  uvm_i2c_scoreboard uvm_i2c_scoreboard1;
  virtual i2c_if i2c_vif;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    `uvm_info(this.get_name(),"UVM Client env alive", UVM_NONE)
    
    uvm_i2c_agent1 = uvm_i2c_client_agent::type_id::create("uvm_i2c_agent1", this);
    uvm_i2c_scoreboard1 = uvm_i2c_scoreboard::type_id::create("uvm_i2c_scoreboard1", this);
    
    if (!uvm_config_db #(virtual i2c_if)::get(this,"","i2c_vif",i2c_vif))
      `uvm_fatal(get_name(), "Failed to get i2c_if from config_db")
   endfunction
      
      function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    uvm_i2c_agent1.i2c_agent_client_mon_put_port.connect(uvm_i2c_scoreboard1.i2c_scbd_put_export);
  endfunction
endclass
class uvm_i2c_client_agent extends uvm_agent;
  uvm_blocking_put_port #(i2c_txn) i2c_agent_client_mon_put_port;
  
  `uvm_component_utils(uvm_i2c_client_agent)
  
  uvm_i2c_client_agent_configuration my_config;
  
  uvm_i2c_client_monitor uvm_i2c_mon1;
  uvm_i2c_client uvm_i2c_drv1;
  //uvm_i2c_client_sequencer uvm_i2c_sequencer1;
  uvm_i2c_sequencer uvm_i2c_sequencer1;
  int log_descriptor;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    i2c_agent_client_mon_put_port = new("i2c_agent_client_mon_put_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(uvm_i2c_client_agent_configuration)::get(this,"*","uvm_i2c_client_agent_configuration",my_config))
	begin
      `uvm_fatal(this.get_name(),"Configuration object is not set properly")
    end
    `uvm_info(this.get_name(),"UVM I2C Client Agent Alive", UVM_NONE)
    
    uvm_i2c_mon1 = uvm_i2c_client_monitor::type_id::create("uvm_i2c_mon1", this);
    
    if(my_config.active_or_passive == UVM_ACTIVE) begin
    	`uvm_info(this.get_name(),"UVM I2C Client Agent creating driver and seq", UVM_NONE)
	    uvm_i2c_drv1 = uvm_i2c_client::type_id::create("uvm_i2c_drv1", this);
	    uvm_i2c_sequencer1 = uvm_i2c_sequencer::type_id::create("uvm_i2c_sequencer1", this);
    end 
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(this.get_name(), "UVM CLIENT AGENT CONNECTION MON PUT PORT", UVM_NONE)
 	 uvm_i2c_mon1.i2c_client_mon_put_port.connect(i2c_agent_client_mon_put_port);
    if(my_config.active_or_passive == UVM_ACTIVE)begin
	    uvm_i2c_drv1.seq_item_port.connect(uvm_i2c_sequencer1.seq_item_export);
    end
  endfunction
endclass
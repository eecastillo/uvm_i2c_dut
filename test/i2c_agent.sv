class uvm_i2c_agent extends uvm_agent;
  uvm_blocking_put_port #(i2c_txn) i2c_agent_mon_put_port;
  
  `uvm_component_utils(uvm_i2c_agent)
  
  uvm_i2c_monitor uvm_i2c_mon0;
  uvm_i2c_driver uvm_i2c_drv0;
  uvm_i2c_sequencer uvm_i2c_sequencer0;
  
  //uvm_i2c_client uvm_i2c_drv1;
  //uvm_i2c_sequencer uvm_i2c_sequencer1;
  
  int log_descriptor;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    i2c_agent_mon_put_port = new("i2c_agent_mon_put_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    `uvm_info(this.get_name(),"UVM I2C Agent Alive", UVM_NONE)
    
    uvm_i2c_mon0 = uvm_i2c_monitor::type_id::create("uvm_i2c_mon0", this);
    uvm_i2c_drv0 = uvm_i2c_driver::type_id::create("uvm_i2c_drv0", this);
    uvm_i2c_sequencer0 = uvm_i2c_sequencer::type_id::create("uvm_i2c_sequencer0", this);
    
    //uvm_i2c_drv1 = uvm_i2c_client::type_id::create("uvm_i2c_drv1", this);
    //uvm_i2c_sequencer1 = uvm_i2c_sequencer::type_id::create("uvm_i2c_sequencer1", this);
    
    log_descriptor = $fopen("i2c_trk.log","w");
    set_report_default_file(log_descriptor);
    
    uvm_i2c_mon0.set_report_severity_id_action(UVM_INFO, "I2C_TRK", UVM_LOG | UVM_DISPLAY);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
 	 uvm_i2c_mon0.i2c_mon_put_port.connect(i2c_agent_mon_put_port);
    uvm_i2c_drv0.seq_item_port.connect(uvm_i2c_sequencer0.seq_item_export);
   // uvm_i2c_drv1.seq_item_port.connect(uvm_i2c_sequencer0.seq_item_export);
  endfunction
endclass
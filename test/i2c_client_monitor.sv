class uvm_i2c_client_monitor extends uvm_monitor;
  uvm_blocking_put_port #(i2c_client_txn) i2c_client_mon_put_port;
  
  i2c_client_txn mon_i2c_client_txn;
  virtual i2c_if i2c_vif;
  bit started;
  
  `uvm_component_utils(uvm_i2c_client_monitor);
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    i2c_client_mon_put_port = new("i2c_client_mon_put_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    `uvm_info(this.get_name(), "UVM I2C Client Monitor Alive", UVM_NONE)
    
    if (!uvm_config_db #(virtual i2c_if)::get(this,"","i2c_vif",i2c_vif))
      `uvm_fatal(get_name(), "Failed to get i2c_if from config_db")
  endfunction
  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(this.get_name, "UVM MONITOR CLIENT RUNNING RUN PHASE", UVM_NONE)
    forever begin
      fork
        wait_for_start_condition();
        wait_for_stop_condition();
      join
    end
  endtask

    task update_pkt();
  	fork
      begin
        mon_i2c_client_txn = i2c_client_txn::type_id::create("mon_i2c_client_txn");
        
        mon_i2c_client_txn.read_write = i2c_vif.read_write;
        mon_i2c_client_txn.mosi_data = i2c_vif.mosi_data;
        mon_i2c_client_txn.register_address = i2c_vif.register_address;
        mon_i2c_client_txn.device_address = i2c_vif.device_address;
        //@(negedge i2c_vif.clock);
        mon_i2c_client_txn.miso_data = i2c_vif.miso_data;
        //`uvm_info(this.get_name(), $sformatf("Data read from client 0%h",i2c_vif.miso_data), UVM_NONE)
        i2c_client_mon_put_port.put(mon_i2c_client_txn);
        
      end
    join_none
  endtask
    
    task wait_for_start_condition();
      if(!started)begin
        @(negedge i2c_vif.sda)
        if(i2c_vif.scl)begin
          `uvm_info(this.get_name(), "Start Condition detected by client monitor", UVM_NONE) 
          uvm_report_info("i2c-trk","Start Condition detected by clientmonitor",UVM_MEDIUM,"i2c_trk.log");
          started = 1'b1;
        end
      end
    endtask
    
    task wait_for_stop_condition();
      @(posedge started)
      while(started)begin
        @(posedge i2c_vif.sda)
        if(i2c_vif.scl)begin
          started=1'b0;
          `uvm_info(this.get_name(), "STOP condition detected by client monitor", UVM_NONE);
          update_pkt();
        end
      end
    endtask
endclass
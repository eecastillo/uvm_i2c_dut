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
      fork
        wait_for_start_condition();
        wait_for_stop_condition();
      join
  endtask

    task update_pkt();
  	fork
      begin
        mon_i2c_client_txn = i2c_client_txn::type_id::create("mon_i2c_client_txn");
        
        mon_i2c_client_txn.read_write = i2c_vif.read_write;
        mon_i2c_client_txn.mosi_data = i2c_vif.mosi_data;
        mon_i2c_client_txn.register_address = i2c_vif.register_address;
        mon_i2c_client_txn.device_address = i2c_vif.device_address;
        mon_i2c_client_txn.miso_data = i2c_vif.miso_data;
        i2c_client_mon_put_port.put(mon_i2c_client_txn);
        
      end
    join_none
  endtask
    
    task wait_for_start_condition();
     forever begin
      	@(negedge i2c_vif.sda)
         if(i2c_vif.scl)begin
          `uvm_info(this.get_name(),$sformatf("START condition detected by CLIENT monitor enable: %0b busy:%0b read_write: %0b",i2c_vif.enable, i2c_vif.busy, i2c_vif.read_write), UVM_HIGH);

          uvm_report_info("i2c-trk","Start Condition detected by CLIENT monitor",UVM_NONE,"i2c_trk.log");
          started = 1'b1;
        end
      end
    endtask
    
    task wait_for_stop_condition();
      forever begin
        @(posedge i2c_vif.sda)
        if(i2c_vif.scl)begin
          started=1'b0;
          `uvm_info(this.get_name(),$sformatf("STOP condition detected by monitor enable: %0b busy:%0b",i2c_vif.enable, i2c_vif.busy), UVM_HIGH);
            update_pkt();
        end
      end
    endtask
    
endclass
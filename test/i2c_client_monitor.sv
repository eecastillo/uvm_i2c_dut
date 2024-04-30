class uvm_i2c_client_monitor extends uvm_monitor;
  uvm_blocking_put_port #(i2c_txn) i2c_client_mon_put_port;
  
  i2c_txn mon_i2c_txn;
  virtual i2c_if i2c_vif;
  bit started;
  logic [34:0] sr=0;
  
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
   // forever begin
     // fork
      //  wait_for_reset();
       //wait_for_master_enable();
	//  wait_for_start_condition();
     // shift_register();
      //wait_for_stop_condition();
       // wait_for_master_busy();
      //join
 //   end
  endtask
/*
    task update_pkt();
  	fork
      begin
        mon_i2c_txn = i2c_txn::type_id::create("mon_i2c_txn");
        
        //mon_i2c_txn.reset_n = i2c_vif.reset_n;
        //mon_i2c_txn.enable = i2c_vif.enable;
        mon_i2c_txn.read_write = i2c_vif.read_write;
        mon_i2c_txn.mosi_data = i2c_vif.mosi_data;
        mon_i2c_txn.register_address = i2c_vif.register_address;
        mon_i2c_txn.device_address = i2c_vif.device_address;
        mon_i2c_txn.send_stream = {1'b0, sr[34:1]};
        //mon_i2c_txn.divider = i2c_vif.divider;
        //mon_i2c_txn.busy = i2c_vif.busy;
        //mon_i2c_txn.sda = i2c_vif.sda;
        //mon_i2c_txn.scl = i2c_vif.scl;

        //@(negedge i2c_vif.clock);
        mon_i2c_txn.miso_data = i2c_vif.miso_data;
        `uvm_info(this.get_name(), $sformatf("Data read from client 0%h",i2c_vif.miso_data), UVM_NONE)
        i2c_mon_put_port.put(mon_i2c_txn);
        
      end
    join_none
  endtask
  
  task wait_for_reset();
    @(posedge i2c_vif.clock);
    if (i2c_vif.reset_n==0) begin
      `uvm_info(this.get_name(),"RESET DETECTED BY MONITOR", UVM_NONE)
      //update_pkt();
    end
  endtask
    
    task wait_for_start_condition();
      if(!started)begin
        @(negedge i2c_vif.sda)
        sr=0;
        //`uvm_info(this.get_name(), "SDA NEGEDGE DETECTED", UVM_LOW)
        if(i2c_vif.scl)begin
          `uvm_info(this.get_name(), "Start Condition detected by monitor", UVM_NONE) 
          uvm_report_info("i2c-trk","Start Condition detected by monitor",UVM_MEDIUM,"i2c_trk.log");
          started = 1'b1;
        end
      end
    endtask
    
    task shift_register();
        // generate shift register
      @(posedge started)
      while(started)begin
        //`uvm_info(this.get_name(),"Waitin for posedge", UVM_LOG);
          @(posedge i2c_vif.scl)
        sr <= {sr[33:0],i2c_vif.sda};
          `uvm_info(this.get_name(), $sformatf("Data read from SDA %0b",sr), UVM_LOG);      
        end
    endtask
    
    task wait_for_stop_condition();
      @(posedge started)
      //`uvm_info(this.get_name(), "STARTED POSEDGE DETECTED", UVM_LOW)
      while(started)begin
        @(posedge i2c_vif.sda)
        //`uvm_info(this.get_name(), "SDA POSEDGE DETECTED", UVM_LOW)
        if(i2c_vif.scl)begin
          started=1'b0;
          `uvm_info(this.get_name(), "STOP condition detected by monitor", UVM_NONE);
          //uvm_report_info("i2c-trk","STOP Condition detected by monitor",UVM_MEDIUM,"i2c_trk.log");
          //$fdisplay(log_descriptor, "STOP Condition detected by monitor");
          `uvm_info(this.get_name(), $sformatf("Data read from SDA %0b",sr), UVM_NONE);
          update_pkt();
        end
      end
    endtask
  
  task wait_for_master_enable();
    @(negedge i2c_vif.clock);
    if (i2c_vif.enable==1) begin
      `uvm_info(this.get_name(), "MASTER ENABLE detected by monitor", UVM_NONE);
      //update_pkt();    
    end
  endtask
  
  task wait_for_master_busy();
    @(negedge i2c_vif.busy);
    if (i2c_vif.read_write==1) begin
      //update_pkt();
      `uvm_info(this.get_name(),"Master Read", UVM_NONE)
      `uvm_info(this.get_name(), $sformatf("Data read monitor 0x%0h",i2c_vif.miso_data), UVM_NONE);
    end
    
    if (i2c_vif.read_write==0) begin
     // update_pkt();
      `uvm_info(this.get_name(),"Master Write", UVM_NONE);
      `uvm_info(this.get_name(),$sformatf("Data read monitor 0x%0h",i2c_vif.mosi_data),UVM_NONE);
      `uvm_info(this.get_name, $sformatf("Direction read monitor 0x%0h",i2c_vif.register_address), UVM_NONE);

    end
  endtask    
    */
endclass
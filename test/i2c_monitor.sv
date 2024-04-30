class uvm_i2c_monitor extends uvm_monitor;
  uvm_blocking_put_port #(i2c_txn) i2c_mon_put_port;
  
  i2c_txn mon_i2c_txn;
  virtual i2c_if i2c_vif;
  bit started;
  logic [STREAM_WIDTH-1:0] sr=0;
  
  `uvm_component_utils(uvm_i2c_monitor);
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    i2c_mon_put_port = new("i2c_mon_put_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    `uvm_info(this.get_name(), "UVM I2C Monitor Alive", UVM_NONE)
    
    if (!uvm_config_db #(virtual i2c_if)::get(this,"","i2c_vif",i2c_vif))
      `uvm_fatal(get_name(), "Failed to get i2c_if from config_db")
  endfunction
  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
      fork
      //  wait_for_reset();
       //wait_for_master_enable();
	  wait_for_start_condition();
      //shift_register();
      sniff_i2c_frame();
      wait_for_stop_condition();
       // wait_for_master_busy();
      join
    end
  endtask

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
        mon_i2c_txn.send_stream = sr;
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
    
    task wait_for_second_start_condition();
      bit second_start = 0;
      while (!second_start)begin
        @(negedge i2c_vif.sda)
        if(i2c_vif.scl)begin
          `uvm_info(this.get_name(), "Second start condition detected by monitor", UVM_NONE);
          second_start = 1;
        end
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
    
    task sniff_i2c_frame();
      int i_frame=0;
     // int j_frame=0;
      
      @(posedge started)
      
      if(!i2c_vif.read_write)begin
        if(DATA_WIDTH == 8)begin
          i_frame=27;
        end
        else if(DATA_WIDTH == 16)begin
          i_frame=36;
        end
      end
      
      else if(i2c_vif.read_write)begin
        if(DATA_WIDTH == 8)begin
          i_frame=36;
        end
        else if(DATA_WIDTH == 16)begin
        	i_frame=45;
        end
      end
      
      for (int i = 0; i<i_frame;i++)begin
        @(posedge i2c_vif.scl)
        sr = #1 {sr[STREAM_WIDTH-2:0],i2c_vif.sda};
        `uvm_info(this.get_name(), $sformatf("Data read from SDA %0b",sr), UVM_LOG); 
      end
      /*
      if(i2c_vif.read_write)
        wait_for_second_start_condition();
      
      for (int j = 0; j<j_frame;j++)begin
        @(posedge i2c_vif.scl)
        sr = #1 {sr[33:0],i2c_vif.sda};
        `uvm_info(this.get_name(), $sformatf("Data read from SDA %0b",sr), UVM_LOG); 
      end*/
    endtask
    
    task shift_register();
        // generate shift register
      @(posedge started)
      while(started)begin
        //`uvm_info(this.get_name(),"Waitin for posedge", UVM_LOG);
          @(posedge i2c_vif.scl)
        sr = #1 {sr[33:0],i2c_vif.sda};
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
    
endclass : uvm_i2c_monitor
  
/*  
class i2c_monitor;
  virtual i2c_if i2c_vif;
  mailbox #(i2c_pkt) mbox_i2c;
  
  i2c_pkt i2c_pkt_mon;
  
  function new(virtual i2c_if i2c_if, mailbox #(i2c_pkt) mbox_i2c);
    $display("[I2C-MON] %0t - created sr_monitor", $time);
	i2c_vif = i2c_if;
    this.mbox_i2c = mbox_i2c;
  endfunction
  
  task monitor_run();
    forever begin
      fork
        wait_for_reset();
        wait_for_master_enable();
        wait_for_master_busy();
      join
    end
  endtask
  
  task update_pkt();
  	fork
      begin
        i2c_pkt_mon.reset_n = i2c_vif.reset_n;
        i2c_pkt_mon.enable = i2c_vif.enable;
        i2c_pkt_mon.read_write = i2c_vif.read_write;
        i2c_pkt_mon.mosi_data = i2c_vif.mosi_data;
        i2c_pkt_mon.register_address = i2c_vif.register_address;
        i2c_pkt_mon.divider = i2c_vif.divider;
        i2c_pkt_mon.busy = i2c_vif.busy;
        i2c_pkt_mon.sda = i2c_vif.sda;
        i2c_pkt_mon.scl = i2c_vif.scl;
        
        @(negedge i2c_vif.clock);
        i2c_pkt_mon.miso_data = i2c_vif.miso_data;

        mbox_i2c.put(i2c_pkt_mon);
      end
    join_none
  endtask
  
  task wait_for_reset();
    @(negedge i2c_vif.clock);
    if (i2c_vif.reset_n==0) begin
      update_pkt();
    end
  endtask
  
  task wait_for_master_enable();
    @(negedge i2c_vif.clock);
    if (i2c_vif.enable==1) begin
      update_pkt();    
    end
  endtask
  
  task wait_for_master_busy();
    @(negedge i2c_vif.busy);
    if (i2c_vif.read_write==1) begin
      update_pkt();
      $display("***************** Master Read *********");
      $display("data read monitor 0x%0h",i2c_vif.miso_data);
    end
    
    if (i2c_vif.read_write==0) begin
      update_pkt();
      $display("***************** Master Write *********");
      $display("data read monitor 0x%0h",i2c_vif.mosi_data);
      $display("direction read monitor 0x%0h",i2c_vif.register_address);

    end
  endtask
endclass
*/
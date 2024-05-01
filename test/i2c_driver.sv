class uvm_i2c_driver extends uvm_driver #(i2c_req_transfer);
  `uvm_component_utils(uvm_i2c_driver)
  
  virtual i2c_if i2c_vif;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(this.get_name(), "UVM I2C Driver is Alive", UVM_NONE)
    
    if (!uvm_config_db #(virtual i2c_if)::get(this,"","i2c_vif",i2c_vif))
      `uvm_fatal(get_name(), "Failed to get i2c from config_db")
  endfunction : build_phase
  
  
  task main_phase(uvm_phase phase);
    super.main_phase(phase);
    
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(this.get_name(),"Getting sequence item", UVM_NONE)
      req.print();
      
      case(req.seq_action)
        READ_DATA			: read_data(req.device_address, req.address, req.data);
        WRITE_DATA			: write_data(req.device_address, req.address, req.data);
      endcase
      
      seq_item_port.item_done();
    end
  endtask : main_phase
    
  task reset();
    `uvm_info(this.get_name(), "Reseting I2C module", UVM_NONE)
    @(posedge i2c_vif.clock)
    i2c_vif.reset_n = 1;
    #100;
    @(posedge i2c_vif.clock)
    i2c_vif.reset_n = 0;
    #100;
    @(posedge i2c_vif.clock)
    i2c_vif.reset_n = 1;
    #100;
  endtask
  
  task set_read();
    `uvm_info(this.get_name(), "Setting I2C module read", UVM_HIGH)
     i2c_vif.read_write = 1;            //read operation
  endtask
  
  task set_write();
    `uvm_info(this.get_name(), "Setting I2C module write", UVM_HIGH)
     i2c_vif.read_write = 0;            //write operation
  endtask
  
  task set_reg_address(int address);
    `uvm_info(this.get_name(), "Setting I2C module reg address", UVM_HIGH)
    i2c_vif.register_address = address; //8'h00; //set client register address
  endtask
  
  task set_write_data(int data);
    `uvm_info(this.get_name(), "Setting I2C module write data", UVM_HIGH)
    i2c_vif.mosi_data = data;//8'hAC;
  endtask
  
  task set_device_address(int address);
    `uvm_info(this.get_name(), "Setting I2C module device address", UVM_HIGH)
     i2c_vif.device_address = address;//7'b001_0001;  //slave address
  endtask
  
  task set_divider();
    `uvm_info(this.get_name(), "Setting I2C module set divider", UVM_HIGH)
    i2c_vif.divider = 16'h00EA;//16'hFFFF;     //divider value for i2c serial clock
  endtask
  
  task master_enable();
    `uvm_info(this.get_name(), "Setting I2C module master enable", UVM_HIGH)
    i2c_vif.enable= 1;
  endtask
  
  task master_disable();
    `uvm_info(this.get_name(), "Setting I2C module master disable", UVM_HIGH)
    i2c_vif.enable= 0;
  endtask
  
  task wait_tb_clock();
    @(posedge i2c_vif.clock);
  endtask
  
  task wait_posedge_busy();
    @(posedge i2c_vif.busy);
  endtask
  
  task wait_negedge_busy();
    @(negedge i2c_vif.busy);
  endtask
        
    task write_data(bit [ADDRESS_WIDTH-1:0] device_address, bit [REGISTER_WIDTH-1:0] address,bit [DATA_WIDTH-1:0]    data);
      `uvm_info(this.get_name(), $sformatf(" Writing value 0x%0h to address 0x%1h",data,address), UVM_NONE);
      `uvm_info(this.get_name(),"Configuring master",UVM_NONE);
    wait_tb_clock();
    set_write();
    set_reg_address(address);//8'h00);
    set_write_data(data);//8'hAC);
    if(ADDRESS_WIDTH == 7)begin
      set_device_address(device_address);//7'b001_0001);
    end
    else if (ADDRESS_WIDTH == 10)begin
      set_device_address(10'b101001_0001);
    end
    set_divider();
    wait_tb_clock();
      `uvm_info(this.get_name(),"Enabling master",UVM_NONE);
    master_enable();
    wait_posedge_busy();
      `uvm_info(this.get_name(),"Master has started writing",UVM_NONE);
    master_disable();
    wait_negedge_busy();
      `uvm_info(this.get_name(),"Master has finsihed writing",UVM_NONE);
  endtask
  
    task read_data(bit [ADDRESS_WIDTH-1:0] device_address, bit [REGISTER_WIDTH-1:0] address,bit [DATA_WIDTH-1:0]    data);
    `uvm_info(this.get_name(), $sformatf("Reading from address 0x%0h",address), UVM_NONE);
      `uvm_info(this.get_name(),"Configuring master",UVM_NONE);
    wait_tb_clock();
    set_read();
    set_reg_address(address);//8'h00);
    set_write_data(data);
    if(ADDRESS_WIDTH == 7)begin
      set_device_address(device_address);//7'b001_0001);
    end
    else if (ADDRESS_WIDTH == 10)begin
      set_device_address(10'b101001_0001);
    end
    set_divider();
    wait_tb_clock();
      `uvm_info(this.get_name(),"Enabling master",UVM_NONE);
    master_enable();
    wait_posedge_busy();
      `uvm_info(this.get_name(),"Master has started reading",UVM_NONE);
    master_disable();
    wait_negedge_busy();
      `uvm_info(this.get_name(),"Master has finsihed reading",UVM_NONE);
  	//$display("data read 0x%0h",i2c_tb_env0.i2c_vif.miso_data);
  endtask
    
endclass : uvm_i2c_driver

/*class i2c_driver;
  virtual i2c_if i2c_vif;
  
  function new(virtual i2c_if i2c_if);
    $display("[SR-DRV] %0t - created sr_driver", $time);
	i2c_vif = i2c_if;
  endfunction
  
  task reset();
  endtask
  
  task set_read();
     i2c_vif.read_write = 1;            //read operation
  endtask
  
  task set_write();
     i2c_vif.read_write = 0;            //write operation
  endtask
  
  task set_reg_address(int address);
    i2c_vif.register_address = address; //8'h00; //set client register address
  endtask
  
  task set_write_data(int data);
    i2c_vif.mosi_data = data;//8'hAC;
  endtask
  
  task set_device_address(int address);
     i2c_vif.device_address = address;//7'b001_0001;  //slave address
  endtask
  
  task set_divider();
      i2c_vif.divider = 16'hFFFF;     //divider value for i2c serial clock
  endtask
  
  task master_enable();
        i2c_vif.enable= 1;
  endtask
  
  task master_disable();
        i2c_vif.enable= 0;
  endtask
  
  task wait_tb_clock();
    @(posedge i2c_vif.clock);
  endtask
  
  task wait_posedge_busy();
    @(posedge i2c_vif.busy);
  endtask
  
  task wait_negedge_busy();
    @(negedge i2c_vif.busy);
  endtask
endclass
*/
    
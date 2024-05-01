class i2c_txn extends uvm_object;
  
    //logic reset_n;
    //logic enable;
    logic read_write;
	logic [DATA_WIDTH-1:0] mosi_data;
  	logic [REGISTER_WIDTH-1:0] register_address;
  	logic [ADDRESS_WIDTH-1:0] device_address;
  logic [STREAM_WIDTH-1:0] send_stream;
  	//logic [15:0] divider;

  	logic [DATA_WIDTH-1:0] miso_data;
    //logic busy;

    //logic sda;//external_serial_data;
    //logic scl;//external_serial_clock;
  `uvm_object_utils_begin(i2c_txn)
    //`uvm_field_int(reset_n, UVM_FLAGS_OFF | UVM_PRINT)
    //`uvm_field_int(enable, UVM_FLAGS_OFF | UVM_PRINT)
  `uvm_field_int(read_write, UVM_FLAGS_OFF | UVM_PRINT | UVM_NOCOMPARE)
  `uvm_field_int(mosi_data, UVM_FLAGS_OFF | UVM_PRINT | UVM_NOCOMPARE)
  `uvm_field_int(register_address, UVM_FLAGS_OFF | UVM_PRINT | UVM_NOCOMPARE)
  `uvm_field_int(device_address, UVM_FLAGS_OFF | UVM_PRINT | UVM_NOCOMPARE)
  `uvm_field_int(send_stream, UVM_FLAGS_OFF | UVM_PRINT | UVM_COMPARE)
  	//`uvm_field_int(divider, UVM_ALL_ON)
    //`uvm_field_int(miso_data, UVM_ALL_ON)
    //`uvm_field_int(busy, UVM_ALL_ON)
    //`uvm_field_int(sda, UVM_ALL_ON)
    //`uvm_field_int(scl, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new (string name = "");
    super.new(name);
    `uvm_info(this.get_name(),$sformatf("Setting UVM TXN STREAM WIDTH to %0d for %0d BIT transaction",STREAM_WIDTH, ADDRESS_WIDTH),UVM_HIGH)

  endfunction
endclass

class i2c_client_txn extends uvm_object;
  
    logic read_write;
	logic [DATA_WIDTH-1:0] mosi_data;
  	logic [REGISTER_WIDTH-1:0] register_address;
  	logic [ADDRESS_WIDTH-1:0] device_address;

  	logic [DATA_WIDTH-1:0] miso_data;

  `uvm_object_utils_begin(i2c_client_txn)
 /* `uvm_field_int(read_write, UVM_FLAGS_OFF | UVM_PRINT | UVM_NOCOMPARE)
  `uvm_field_int(mosi_data, UVM_FLAGS_OFF | UVM_PRINT | UVM_COMPARE)
  `uvm_field_int(register_address, UVM_FLAGS_OFF | UVM_PRINT | UVM_COMPARE)
  `uvm_field_int(device_address, UVM_FLAGS_OFF | UVM_PRINT | UVM_COMPARE)
  `uvm_field_int(miso_data, UVM_FLAGS_OFF | UVM_PRINT | UVM_COMPARE)
*/
  `uvm_object_utils_end
  
  function new (string name = "");
    super.new(name);
    `uvm_info(this.get_name(),$sformatf("Setting UVM I2C_CLIENT TXN STREAM WIDTH to %0d for %0d BIT transaction",STREAM_WIDTH, ADDRESS_WIDTH),UVM_HIGH)    
  endfunction
  
  virtual function void do_copy(uvm_object rhs);
    i2c_client_txn _i2c_txn;
    super.do_copy(rhs);
    $cast(_i2c_txn,rhs);
    read_write = _i2c_txn.read_write;
    mosi_data = _i2c_txn.mosi_data;
    register_address = _i2c_txn.register_address;
    device_address = _i2c_txn.device_address;
    miso_data = _i2c_txn.miso_data;
    `uvm_info(get_name(), "I2C_CLIENT_TXN do_copy() performed",UVM_HIGH)
  endfunction
    
  
  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  	i2c_client_txn tmp_h;
    `uvm_info(this.get_name(),"RUNNING DO_COMPARE",UVM_HIGH)
    $cast(tmp_h,rhs);
    return(super.do_compare(tmp_h, comparer) &
           compare_data(miso_data, tmp_h.mosi_data) &
           compare_devices(device_address, tmp_h.device_address) &
           compare_register_address(register_address, tmp_h.register_address)
          );
  endfunction
  function bit compare_data(logic [DATA_WIDTH-1:0] data_1, logic [DATA_WIDTH-1:0] data_2);
    bit result = 1'b0;
    if(data_1==data_2)begin
    	result = 1'b1;
    end
    else begin
      result = 1'b0;
      `uvm_error(this.get_name(),$sformatf("DATA READ FROM RTL CLIENT: 0x%0h IS NOT THE SAME THAT WAS WRITTEN: 0x%0h",data_1,data_2))
    end
    return result;
  endfunction
  
  function bit compare_devices(logic [ADDRESS_WIDTH-1:0] device_address_1, logic [ADDRESS_WIDTH-1:0] device_address_2);
  	bit result = 1'b0;
    if(device_address_1==device_address_2)begin
    	result=1'b1;
    end
    else begin
      result=1'b0;
      `uvm_error(this.get_name(),$sformatf("I2C CLIENT TO READ: %0b IS NOT THE SAME WHERE WAS WRITTEN: %0b",device_address_1,device_address_2))

    end
    return result;
  endfunction
  
  function bit compare_register_address(logic [REGISTER_WIDTH-1:0] register_address_1, logic [REGISTER_WIDTH-1:0] register_address_2);
    bit result = 1'b0;
    if(register_address_1==register_address_2)begin
    	result=1'b1;
    end
    else begin
      result=1'b0;
      `uvm_error(this.get_name(),$sformatf("I2C CLIENT ADDRESS TO READ: 0x%0h IS NOT THE SAME WHERE WAS WRITTEN: 0x%0h", register_address_1, register_address_2))
    end
    return result;
  endfunction
endclass
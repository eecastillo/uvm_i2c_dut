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
class uvm_i2c_scoreboard extends uvm_scoreboard;
  uvm_blocking_put_imp #(i2c_txn, uvm_i2c_scoreboard) i2c_scbd_put_export;
  //logic [DATA_WIDTH-1:0] mem_ref [(2**REGISTER_WIDTH)-1:0];
  bit ACK_VALUE = 1'b0;
  bit NACK_VALUE = 1'b1;
  parameter TEN_BIT_HIGH = 5'b11110;
  i2c_txn i2c_txn_ref;
  
  `uvm_component_utils(uvm_i2c_scoreboard)
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    i2c_scbd_put_export = new("i2c_scbd_put_export",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    `uvm_info(this.get_name(), "UVM I2C Scoreboard Alive", UVM_NONE)
  endfunction
  
  function void put(i2c_txn txn);
    txn.print(uvm_default_line_printer);
    gen_i2c_ref(txn.device_address,txn.read_write,txn.register_address,txn.mosi_data, txn.miso_data);
    check_i2c(txn);
  endfunction
  
    logic read_write;
	logic [DATA_WIDTH-1:0] mosi_data;
  	logic [REGISTER_WIDTH-1:0] register_address;
  	logic [ADDRESS_WIDTH-1:0] device_address;
  
    virtual function void gen_i2c_ref(logic [ADDRESS_WIDTH-1:0] device_address, logic read_write, logic [REGISTER_WIDTH-1:0] register_address, logic [DATA_WIDTH-1:0] mosi_data, logic [DATA_WIDTH-1:0] miso_data);
      i2c_txn_ref = i2c_txn::type_id::create("i2c_txn_ref");
    //WRITE REFERENCE SEQUENCE
    if (read_write==0) begin
      //SEVEN BIT ADDRESSING WRITE SEQUENCE
      if(ADDRESS_WIDTH == 7)begin
        //SEVEN BIT ADDRESSING, DATA_WIDTH 8 WRITE SEQUENCE
        if(DATA_WIDTH == 8)begin
          `uvm_info(this.get_name(),"Generating reference for writing operation", UVM_NONE);
          i2c_txn_ref.send_stream = {device_address, read_write, ACK_VALUE, register_address, ACK_VALUE, mosi_data,ACK_VALUE};
        end
        //SEVEN BIT ADDRESSING, DATA_WIDTH 16 WRITE SEQUENCE
        else if(DATA_WIDTH == 16)begin
          `uvm_info(this.get_name(),"Generating reference for writing 16b data operation", UVM_NONE);
          i2c_txn_ref.send_stream = {device_address, read_write, ACK_VALUE, register_address, ACK_VALUE, mosi_data[15:8],ACK_VALUE,mosi_data[7:0],ACK_VALUE};
        end
      end
      //TEN BIT ADDRESSING WRITE SEQUENCE
      else if (ADDRESS_WIDTH == 10)begin
        `uvm_info(this.get_name(),"Generating reference for 10b writing operation", UVM_NONE);
        i2c_txn_ref.send_stream = {TEN_BIT_HIGH,device_address[9:8], read_write, ACK_VALUE,device_address[7:0],ACK_VALUE,register_address,ACK_VALUE,mosi_data,ACK_VALUE};
      end
    end
      //READ REFERENCE SEQUENCE
    if (read_write==1) begin
      //SEVEN BIT ADDRESSING READ SEQUENCE
      if(ADDRESS_WIDTH == 7)begin
        //SEVEN BIT ADDRESSING, 8 BIT DATA READ SEQUENCE
        if(DATA_WIDTH == 8)begin
          `uvm_info(this.get_name(),"Generating reference for reading operation", UVM_NONE);
          i2c_txn_ref.send_stream = {device_address,1'b0,ACK_VALUE,register_address,ACK_VALUE,NACK_VALUE,device_address,read_write, ACK_VALUE,miso_data};
        end
        //SEVEN BIT ADDRESSING, 16 BIT DATA READ SEQUENCE
        else if(DATA_WIDTH == 16)begin
          `uvm_info(this.get_name(),"Generating reference for 16b data reading operation", UVM_NONE);
          i2c_txn_ref.send_stream = {device_address,1'b0,ACK_VALUE,register_address,ACK_VALUE,NACK_VALUE,device_address,read_write, ACK_VALUE,miso_data[15:8],ACK_VALUE,miso_data[7:0]};
        end
      end
      //TEN BIT ADDRESSING READ SEQUENCE
      else if (ADDRESS_WIDTH == 10) begin
        `uvm_info(this.get_name(),"Generating reference for 10b reading operation", UVM_NONE);
        i2c_txn_ref.send_stream = {TEN_BIT_HIGH,device_address[9:8], 1'b0, ACK_VALUE,device_address[7:0],ACK_VALUE,register_address,ACK_VALUE,NACK_VALUE,device_address,read_write, ACK_VALUE,miso_data};
      end
    end
  endfunction
  
  function void check_i2c(i2c_txn real_i2c_txn);
    if(real_i2c_txn.compare(i2c_txn_ref))
      `uvm_info(this.get_name(), $sformatf("reference=%0b match actual=%0b",i2c_txn_ref.send_stream, real_i2c_txn.send_stream), UVM_NONE)
      else
        `uvm_error(this.get_name(), $sformatf("reference=%0b does not match actual=%0b",i2c_txn_ref.send_stream, real_i2c_txn.send_stream))

    //end
    
    /*if (read_write==1) begin
      if (mem_ref[register_address] != miso_data_real) begin
        $display("ERROR @(%0t): miso_data_ref=%0h does not match miso_data_real=0x%1h", $time, mem_ref[register_address], miso_data_real);
      end
      if (mem_ref[register_address] == miso_data_real) begin
        $display("[I1C-CHK]: miso_data_ref=0x%0h match miso_data_real=0x%1h", mem_ref[register_address], miso_data_real);
      end
    end*/
  endfunction
endclass
        
class uvm_i2c_scoreboard_general_call extends uvm_i2c_scoreboard;
  `uvm_component_utils(uvm_i2c_scoreboard_general_call)
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    `uvm_info(this.get_name(), "UVM I2C Scoreboard GENERAL CALL Alive", UVM_NONE)
  endfunction
  
  virtual function void gen_i2c_ref(logic [ADDRESS_WIDTH-1:0] device_address, logic read_write, logic [REGISTER_WIDTH-1:0] register_address, logic [DATA_WIDTH-1:0] mosi_data, logic [DATA_WIDTH-1:0] miso_data);
    i2c_txn_ref = i2c_txn::type_id::create("i2c_txn_ref");
    i2c_txn_ref.send_stream = {8'b0,ACK_VALUE, 8'b00000100,ACK_VALUE};
  endfunction
endclass

class uvm_i2c_scoreboard_software_reset extends uvm_i2c_scoreboard;
  `uvm_component_utils(uvm_i2c_scoreboard_software_reset)
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    `uvm_info(this.get_name(), "UVM I2C Scoreboard SOFTWARE RESET Alive", UVM_NONE)
  endfunction
  
  virtual function void gen_i2c_ref(logic [ADDRESS_WIDTH-1:0] device_address, logic read_write, logic [REGISTER_WIDTH-1:0] register_address, logic [DATA_WIDTH-1:0] mosi_data, logic [DATA_WIDTH-1:0] miso_data);
    i2c_txn_ref = i2c_txn::type_id::create("i2c_txn_ref");
    i2c_txn_ref.send_stream = {8'b0,ACK_VALUE, 8'b00000110,ACK_VALUE};
  endfunction
endclass

//para el checker vamos a suponer que al inicio todas las localidades de memoria se encuentran en 0
/*
class i2c_checker;
  logic [DATA_WIDTH-1:0] mem_ref [(2**REGISTER_WIDTH)-1:0];
  mailbox #(i2c_pkt) mbox_i2c_ptr;
  
  i2c_pkt i2c_pkt_chk;
  
  function new(mailbox #(i2c_pkt) mbox_i2c_env);
    $display("[I2C-CHK] %0t - created sr_check", $time);
    this.mbox_i2c_ptr = mbox_i2c_env;
  endfunction
  
  task run_checker();
  	forever begin
      mbox_i2c_ptr.get(i2c_pkt_chk);
      gen_i2c_ref(i2c_pkt_chk.mosi_data,i2c_pkt_chk.register_address,i2c_pkt_chk.read_write);
      check_i2c(i2c_pkt_chk.miso_data,i2c_pkt_chk.register_address,i2c_pkt_chk.read_write);
    end
  endtask
  
  function gen_i2c_ref(logic [DATA_WIDTH-1:0] data_to_write, logic [REGISTER_WIDTH-1:0]    register_address, logic read_write);
    if (read_write==0) begin
    	$display("Generating reference");
    	mem_ref[register_address] = data_to_write;
      $display("[I2C_CHEK]: data=%0h address=0x%1h",data_to_write, register_address);
      $display("[I2C_CHEK]: data mem=%0h",mem_ref[register_address]);
    end
  endfunction
  
  function check_i2c(logic [DATA_WIDTH-1:0] miso_data_real ,logic [REGISTER_WIDTH-1:0]    register_address, logic read_write);
    if (read_write==1) begin
      if (mem_ref[register_address] != miso_data_real) begin
        $display("ERROR @(%0t): miso_data_ref=%0h does not match miso_data_real=0x%1h", $time, mem_ref[register_address], miso_data_real);
      end
      if (mem_ref[register_address] == miso_data_real) begin
        $display("[I1C-CHK]: miso_data_ref=0x%0h match miso_data_real=0x%1h", mem_ref[register_address], miso_data_real);
      end
    end
  endfunction
  
endclass
*/
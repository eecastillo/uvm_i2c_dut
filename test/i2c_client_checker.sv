class uvm_i2c_client_scoreboard extends uvm_scoreboard;
  uvm_blocking_put_imp #(i2c_client_txn, uvm_i2c_client_scoreboard) i2c_client_scbd_put_export;

  i2c_client_txn i2c_txn_written;
  
  `uvm_component_utils(uvm_i2c_client_scoreboard)
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    i2c_client_scbd_put_export = new("i2c_client_scbd_put_export",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    `uvm_info(this.get_name(), "UVM I2C Client Scoreboard Alive", UVM_NONE)
  endfunction
  
  function void put(i2c_client_txn txn);
    txn.print(uvm_default_line_printer);
    if(txn.read_write)begin
    	check_i2c(txn);
    end
    else begin
    	gen_i2c_ref(txn);
    end
  endfunction
  
  virtual function void gen_i2c_ref(i2c_client_txn txn);
    `uvm_info(this.get_name(), "I2C CLIENT SCOREBOARD GENERATING REFERENCE", UVM_NONE)
      i2c_txn_written = i2c_client_txn::type_id::create("i2c_txn_written");
    //$cast(i2c_txn_written, txn.clone());
    i2c_txn_written.copy(txn);
  endfunction
  
  function void check_i2c(i2c_client_txn read_i2c_txn);
    if(i2c_txn_written!=null)begin
      if(read_i2c_txn.compare(i2c_txn_written))
        `uvm_info(this.get_name(), "I2C MEMORY READ/WRITE IS COHERENT", UVM_NONE)
      else
        `uvm_error(this.get_name(), "I2C MEMORY READ/WRITE IS NOT COHERENT")
      i2c_txn_written=null;
    end
  endfunction
endclass
class uvm_i2c_client_agent_configuration extends uvm_object;
  `uvm_object_utils(uvm_i2c_client_agent_configuration)
  
  uvm_active_passive_enum active_or_passive = UVM_ACTIVE;
  
  function new(string name ="uvm_i2c_client_agent_configuration");
    super.new(name);
  endfunction
  
endclass: uvm_i2c_client_agent_configuration
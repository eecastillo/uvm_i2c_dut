class uvm_i2c_client extends uvm_driver #(i2c_req_transfer);
  `uvm_component_utils(uvm_i2c_client)

  	
  	bit [ADDRESS_WIDTH-1:0] I2C_ADR;


  
  	logic [DATA_WIDTH-1:0] mem [MEM_SIZE-1:0]; //memory initialization

    logic [7:0] mem_adr;   // memory address
    logic [7:0] mem_do;    // memory data output

    logic sta, d_sta;
    logic sto, d_sto;

  	logic [15:0] sr;        // 8bit shift register
    logic       rw;        // read/write direction

    bit      my_adr;    // my address called ??
    bit      i2c_reset; // i2c-statemachine reset
    bit [2:0] bit_cnt;   // 3bit downcounter
    bit      acc_done;  // 8bits transfered
    logic       ld;        // load downcounter

    logic       sda_o;     // sda-drive level
    bit      sda_dly;   // delayed version of sda
  
  	logic [2:0] state;
  	bit debug =1'b1;
  
  // statemachine declaration
  parameter idle        = 3'b000;
  parameter slave_ack   = 3'b001;
  parameter get_mem_adr = 3'b010;
  parameter gma_ack     = 3'b011;
  parameter data        = 3'b100;
  parameter data_ack    = 3'b101;
  
  virtual i2c_if i2c_vif;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(this.get_name(), "UVM I2C BFM client is Alive", UVM_NONE)
    
    if (!uvm_config_db #(virtual i2c_if)::get(this,"","i2c_vif",i2c_vif))
      `uvm_fatal(get_name(), "Failed to get i2c from config_db")
      reset();
    define_device_address();
    `uvm_info(this.get_name(), "UVM I2C BFM memory is initialized", UVM_HIGH)
  endfunction
  
  task define_device_address();
    if(ADDRESS_WIDTH == 7)begin
      I2C_ADR=7'b001_0001;
    end
    else if (ADDRESS_WIDTH == 10)begin
      I2C_ADR = 10'b101001_0001;
    end
  endtask
      
  task main_phase(uvm_phase phase);
    super.main_phase(phase);
   // forever begin
      //seq_item_port.get_next_item(req);
    `uvm_info(this.get_name(), "UVM CLIENT I2C BFM MAIN PHASE", UVM_HIGH)
      fork
          shift_register();
          compare_address();
          bit_counter();
          access_done();
          sda_delay_assign();
          detect_start();
          d_sta_assign();
          detect_stop();
          generate_rst_signal();
          state_machine();
          data_memory_read();
          //tri_state_generation();
          tri_state_generation_n();
      join
     // seq_item_port.item_done();
    //end
  endtask
  
  task reset();
    sda_o = 1'b1;
    state = idle;
    //sta = 1'b0;
    mem[0] = 8'd05;
    mem[1] = 8'd06;
    mem[2] = 8'd07;
    mem[3] = 8'd08;
    mem[4] = 8'd09;
    mem[5] = 8'd10;
    mem[6] = 8'd11;
    mem[7] = 8'd12;
  endtask
  
  task shift_register();
    //while(client_init)begin
      //`uvm_info(this.get_name(),"Waitin for posedge", UVM_LOG);
    forever begin
      @(posedge i2c_vif.scl)
      sr = #1 {sr[6:0],i2c_vif.sda};
      //`uvm_info(this.get_name(), $sformatf("Data read from SDA by client %0b",sr), UVM_LOG);     
      //compare_address();
    //end
    end
  endtask
  
  task compare_address();
    forever begin
      @(negedge i2c_vif.clock)
      my_adr = (sr[10:1] == I2C_ADR);
     // if(my_adr)
       // `uvm_info(this.get_name(), "Address COINCIDE CON EL VALOR DEL CLIENTE", UVM_NONE)
    end
  endtask
  
  task bit_counter();
    forever begin
    @(posedge i2c_vif.scl)
    if(ld)begin
      bit_cnt = #1 3'b111;
    
    end
    else begin
      bit_cnt = #1 bit_cnt - 3'h1;
    
    end
      //`uvm_info(this.get_name(),$sformatf("BIT COUNT %0b",bit_cnt), UVM_NONE);
    end
  endtask
  
  task access_done();
 	forever begin
      @(negedge i2c_vif.clock)
  		acc_done = !(|bit_cnt);
    end
  endtask
  
  task sda_delay_assign();
    forever begin
      @(negedge i2c_vif.clock)
     #1 sda_dly = i2c_vif.sda;
    end
  endtask
  
  task detect_start();
    forever begin
    @(negedge i2c_vif.sda)
    //`uvm_info(this.get_name, "UVM CLIENT BFM NEGEDGE START DETECTED", UVM_NONE)
    if(i2c_vif.scl)
        begin
        sta   = #1 1'b1;
        d_sta = #1 1'b0;
        sto   = #1 1'b0;
          `uvm_info(this.get_name(),"Start condition detected by I2C Client", UVM_HIGH)
        end
      else
        sta = #1 1'b0;
      //`uvm_info(this.get_name(), $sformatf("SETTING STA VALUE TO %0b",sta),UVM_NONE)
    end
  endtask
  
  task d_sta_assign();
    forever begin
    @(posedge i2c_vif.scl)
      d_sta = #1 sta;
    end
  endtask
  
  task detect_stop();
    forever begin
    @(posedge i2c_vif.sda)
    if(i2c_vif.scl)
        begin
           sta = #1 1'b0;
           sto = #1 1'b1;
          `uvm_info(this.get_name(), "Stop condition detected by I2C Client", UVM_HIGH)
        end
      else
        sto = #1 1'b0;
    end
  endtask
  
  task generate_rst_signal();
    forever begin
      @(negedge i2c_vif.clock)
  	i2c_reset = sta || sto;
    end
  endtask
  
  task state_machine();
    forever begin
      @(negedge i2c_vif.scl or posedge sto)
      if (sto || (sta && !d_sta) )
        begin
            state = #1 idle; // reset statemachine

            sda_o = #1 1'b1;
            ld    = #1 1'b1;
        end
      else
        begin
            // initial settings
            sda_o = #1 1'b1;
            ld    = #1 1'b0;

            case(state) // synopsys full_case parallel_case
                idle: // idle state
                  if (acc_done && my_adr)
                    begin
                        state = #1 slave_ack;
                        rw = #1 sr[0];
                        sda_o = #1 1'b0; // generate i2c_ack

                        #2;
                        if(rw)
                          `uvm_info(this.get_name(),$sformatf("DEBUG i2c_slave; command byte received (read) at %t", $time),UVM_HIGH);
                        if(!rw)
                          `uvm_info(this.get_name(),$sformatf("DEBUG i2c_slave; command byte received (write) at %t", $time),UVM_HIGH);

                        if(rw)
                          begin
                              mem_do = #1 mem[mem_adr];

                            #2 `uvm_info(this.get_name(),$sformatf("DEBUG i2c_slave; 1 data block read %x from address %x (1)", mem_do, mem_adr),UVM_HIGH);
                            #2 `uvm_info(this.get_name(),$sformatf("DEBUG i2c_slave; memcheck [0]=%x, [1]=%x, [2]=%x", mem[4'h0], mem[4'h1], mem[4'h2]),UVM_HIGH);
                          end
                    end

                slave_ack:
                  begin
                      if(rw)
                        begin
                            state = #1 data;
                            sda_o = #1 mem_do[7];
                        end
                      else
                        state = #1 get_mem_adr;

                      ld    = #1 1'b1;
                  end

                get_mem_adr: // wait for memory address
                  if(acc_done)
                    begin
                        state = #1 gma_ack;
                        mem_adr = #1 sr; // store memory address
                        sda_o =  #1 !(sr <= 15); // generate i2c_ack, for valid address

                      #1 `uvm_info(this.get_name(),$sformatf("DEBUG i2c_slave; address received. adr=%x, ack=%b", sr, sda_o),UVM_HIGH);
                    end

                gma_ack:
                  begin
                      state = #1 data;
                      ld    = #1 1'b1;
                  end

                data: // receive or drive data
                  begin
                      if(rw)
                        sda_o = #1 mem_do[7];

                      if(acc_done)
                        begin
                            state = #1 data_ack;
                            mem_adr = #2 mem_adr;// + 8'h1;
                            sda_o = #1 (rw && (mem_adr <= 15) ); // send ack on write, receive ack on read

                            if(rw)
                              begin
                                  #3 mem_do = mem[mem_adr];

                                #5 `uvm_info(this.get_name(),$sformatf("i2c_slave; 2 data block read %x from address %x (2)", mem_do, mem_adr),UVM_NONE);
                              end

                            if(!rw)
                              begin
                                  mem[ mem_adr[3:0] ] = #1 sr; // store data in memory

                                #2 `uvm_info(this.get_name(),$sformatf("i2c_slave; data block write %x to address %x", sr, mem_adr),UVM_NONE);
                              end
                        end
                  end

                data_ack:
                  begin
                      ld = #1 1'b1;

                      if(rw)
                        if(sr[0]) // read operation && master send NACK
                          begin
                              state = #1 idle;
                              sda_o = #1 1'b1;
                          end
                        else
                          begin
                              state = #1 data;
                              sda_o = #1 mem_do[7];
                          end
                      else
                        begin
                            state = #1 data;
                            sda_o = #1 1'b1;
                        end
                  end

            endcase
        end
    end
    // read
  endtask
  
  task data_memory_read();
  	    // read data from memory
    forever begin
    @(posedge i2c_vif.scl)
      if(!acc_done && rw)
        mem_do = #1 {mem_do[6:0], 1'b1}; // insert 1'b1 for host ack generation
    end
  endtask
 /* 
  task tri_state_generation();
    forever begin
      @(posedge i2c_vif.clock)
  	i2c_vif.sda = sda_o ? 1'bz : 1'b0;
    end
  endtask*/
  task tri_state_generation_n();
    forever begin
      @(negedge i2c_vif.clock)
  		i2c_vif.sda = sda_o ? 1'bz : 1'b0;
    end
  endtask
endclass
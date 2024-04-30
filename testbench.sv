`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       www.circuitden.com
// Engineer:      Artin Isagholian
//                artinisagholian@gmail.com
// 
// Create Date:    15:43:35 10/22/2020 
// Design Name: 
// Module Name:    testbench
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

parameter  DATA_WIDTH          =   `MY_DATA_WIDTH;
parameter  REGISTER_WIDTH      =   8;
parameter  ADDRESS_WIDTH       =   `MY_ADDRESS_WIDTH;
parameter STREAM_WIDTH = (ADDRESS_WIDTH == 10 || DATA_WIDTH == 16) ? 54:(ADDRESS_WIDTH == 7) ? 35:  0;
parameter  MEM_SIZE			   =   4;

`include "case_000.svh"
`include "i2c_client.sv"
`include "i2c_if.sv"
`include "i2c_txn.sv"
`include "i2c_monitor.sv"
`include "i2c_sequencer.sv"
`include "i2c_driver.sv"
`include "i2c_client_bfm.sv"
`include "i2c_agent.sv"
//`include "i2c_client_sequencer.sv"
`include "i2c_checker.sv"
`include "i2c_sequences.sv"
`include "i2c_client_monitor.sv"
//`include "i2c_client_sequencer.sv"
`include "i2c_client_agent.sv"
`include "i2c_tb_env.sv"
`include "i2c_client_env.sv"
`include "i2c_base_test.sv"
`include "i2c_tests.sv"

module testbench();

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
localparam  CLOCK_FREQUENCY     =   50_000_000;
localparam  CLOCK_PERIOD        =   1e9/CLOCK_FREQUENCY;

reg             clock           =   0;


  i2c_if #(.DATA_WIDTH(DATA_WIDTH), .REGISTER_WIDTH(REGISTER_WIDTH), .ADDRESS_WIDTH(ADDRESS_WIDTH)) i2c_if0 (clock);
  
i2c_master #(.DATA_WIDTH(DATA_WIDTH),.REGISTER_WIDTH(REGISTER_WIDTH),.ADDRESS_WIDTH(ADDRESS_WIDTH))
i2c_master(
  .clock                  (clock),
  .reset_n                (i2c_if0.reset_n),
  .enable                 (i2c_if0.enable),
  .read_write             (i2c_if0.read_write),
  .mosi_data              (i2c_if0.mosi_data),
  .register_address       (i2c_if0.register_address),
  .device_address         (i2c_if0.device_address),

  .divider                (i2c_if0.divider),
  .miso_data              (i2c_if0.miso_data),
  .busy                   (i2c_if0.busy),

  .external_serial_data   (i2c_if0.sda),
  .external_serial_clock  (i2c_if0.scl)
);

  //i2c_base_test i2c_base_test0;

  pullup pullup_scl(i2c_if0.scl); // pullup scl line

  pullup pullup_sda(i2c_if0.sda); // pullup sda line

 /*
i2c_client i2c_client(
  .scl(i2c_if0.scl),
  .sda(i2c_if0.sda)
);
*/

  initial begin
    `uvm_info("TB-top", $sformatf("Running TB with parameter ADDRESS_WIDTH = %0d",ADDRESS_WIDTH),UVM_NONE)
    `uvm_info("TB-top", $sformatf("Running TB with parameter DATA_WIDTH = %0d",DATA_WIDTH),UVM_NONE)
    `uvm_info("TB-top", "setting i2v_vif in config_db", UVM_NONE)
    
    uvm_config_db #(virtual i2c_if)::set(null, "uvm_test_top.uvm_i2c_env0*", "i2c_vif", i2c_if0);
    uvm_config_db #(virtual i2c_if)::set(null, "uvm_test_top.uvm_i2c_client_env0*", "i2c_vif", i2c_if0);

    
    run_test();
    #2000 $stop();
  end
  
  
//clock generation
initial begin
    clock   =   0;
    
    forever begin
        #(CLOCK_PERIOD/2);
        clock   =   ~clock;
    end
end


initial begin
  	string test_name;
 // i2c_base_test0 = new(i2c_if0);
  $dumpfile("dump.vcd"); $dumpvars;
  
  	$value$plusargs("TEST_NAME=%s",test_name);
  
/*    @(posedge clock)
    i2c_if0.reset_n = 1;
    #100;
    @(posedge clock)
    i2c_if0.reset_n = 0;
    #100;
    @(posedge clock)
    i2c_if0.reset_n = 1;
    #100;
 */
 /*   case(test_name)
      "i2c_rand_tests" : i2c_base_test0 = i2c_rand_tests::new(i2c_if0);
      "i2c_serial_test"          : i2c_base_test0 = i2c_serial_test::new(i2c_if0);
      "i2c_single_test"        : i2c_base_test0 = i2c_single_test::new(i2c_if0);
      default                   : i2c_base_test0 = new(i2c_if0);
    endcase
      
	$display("Running  test");
  	i2c_base_test0.run_test();
  	$display("Tests have finsihed");
    $stop();*/
end


endmodule
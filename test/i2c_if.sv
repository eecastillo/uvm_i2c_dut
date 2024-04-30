interface i2c_if #(
    parameter DATA_WIDTH      = 8,
    parameter REGISTER_WIDTH  = 8,
    parameter ADDRESS_WIDTH   = 7
)(
  input clock
);
    logic reset_n;
    logic enable;
    logic read_write;
	logic [DATA_WIDTH-1:0] mosi_data;
  	logic [REGISTER_WIDTH-1:0] register_address;
  	logic [ADDRESS_WIDTH-1:0] device_address;
  	logic [15:0] divider;

  	logic [DATA_WIDTH-1:0] miso_data;
    logic busy;

    wire sda;//external_serial_data;
    wire scl;//external_serial_clock;

endinterface
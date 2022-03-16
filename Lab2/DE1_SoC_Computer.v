

module DE1_SoC_Computer (
	////////////////////////////////////
	// FPGA Pins
	////////////////////////////////////

	// Clock pins
	CLOCK_50,
	CLOCK2_50,
	CLOCK3_50,
	CLOCK4_50,

	// ADC
	ADC_CS_N,
	ADC_DIN,
	ADC_DOUT,
	ADC_SCLK,

	// Audio
	AUD_ADCDAT,
	AUD_ADCLRCK,
	AUD_BCLK,
	AUD_DACDAT,
	AUD_DACLRCK,
	AUD_XCK,

	// SDRAM
	DRAM_ADDR,
	DRAM_BA,
	DRAM_CAS_N,
	DRAM_CKE,
	DRAM_CLK,
	DRAM_CS_N,
	DRAM_DQ,
	DRAM_LDQM,
	DRAM_RAS_N,
	DRAM_UDQM,
	DRAM_WE_N,

	// I2C Bus for Configuration of the Audio and Video-In Chips
	FPGA_I2C_SCLK,
	FPGA_I2C_SDAT,

	// 40-Pin Headers
	GPIO_0,
	GPIO_1,
	
	// Seven Segment Displays
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,

	// IR
	IRDA_RXD,
	IRDA_TXD,

	// Pushbuttons
	KEY,

	// LEDs
	LEDR,

	// PS2 Ports
	PS2_CLK,
	PS2_DAT,
	
	PS2_CLK2,
	PS2_DAT2,

	// Slider Switches
	SW,

	// Video-In
	TD_CLK27,
	TD_DATA,
	TD_HS,
	TD_RESET_N,
	TD_VS,

	// VGA
	VGA_B,
	VGA_BLANK_N,
	VGA_CLK,
	VGA_G,
	VGA_HS,
	VGA_R,
	VGA_SYNC_N,
	VGA_VS,

	////////////////////////////////////
	// HPS Pins
	////////////////////////////////////
	
	// DDR3 SDRAM
	HPS_DDR3_ADDR,
	HPS_DDR3_BA,
	HPS_DDR3_CAS_N,
	HPS_DDR3_CKE,
	HPS_DDR3_CK_N,
	HPS_DDR3_CK_P,
	HPS_DDR3_CS_N,
	HPS_DDR3_DM,
	HPS_DDR3_DQ,
	HPS_DDR3_DQS_N,
	HPS_DDR3_DQS_P,
	HPS_DDR3_ODT,
	HPS_DDR3_RAS_N,
	HPS_DDR3_RESET_N,
	HPS_DDR3_RZQ,
	HPS_DDR3_WE_N,

	// Ethernet
	HPS_ENET_GTX_CLK,
	HPS_ENET_INT_N,
	HPS_ENET_MDC,
	HPS_ENET_MDIO,
	HPS_ENET_RX_CLK,
	HPS_ENET_RX_DATA,
	HPS_ENET_RX_DV,
	HPS_ENET_TX_DATA,
	HPS_ENET_TX_EN,

	// Flash
	HPS_FLASH_DATA,
	HPS_FLASH_DCLK,
	HPS_FLASH_NCSO,

	// Accelerometer
	HPS_GSENSOR_INT,
		
	// General Purpose I/O
	HPS_GPIO,
		
	// I2C
	HPS_I2C_CONTROL,
	HPS_I2C1_SCLK,
	HPS_I2C1_SDAT,
	HPS_I2C2_SCLK,
	HPS_I2C2_SDAT,

	// Pushbutton
	HPS_KEY,

	// LED
	HPS_LED,
		
	// SD Card
	HPS_SD_CLK,
	HPS_SD_CMD,
	HPS_SD_DATA,

	// SPI
	HPS_SPIM_CLK,
	HPS_SPIM_MISO,
	HPS_SPIM_MOSI,
	HPS_SPIM_SS,

	// UART
	HPS_UART_RX,
	HPS_UART_TX,

	// USB
	HPS_CONV_USB_N,
	HPS_USB_CLKOUT,
	HPS_USB_DATA,
	HPS_USB_DIR,
	HPS_USB_NXT,
	HPS_USB_STP
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

////////////////////////////////////
// FPGA Pins
////////////////////////////////////

// Clock pins
input						CLOCK_50;
input						CLOCK2_50;
input						CLOCK3_50;
input						CLOCK4_50;

// ADC
inout						ADC_CS_N;
output					ADC_DIN;
input						ADC_DOUT;
output					ADC_SCLK;

// Audio
input						AUD_ADCDAT;
inout						AUD_ADCLRCK;
inout						AUD_BCLK;
output					AUD_DACDAT;
inout						AUD_DACLRCK;
output					AUD_XCK;

// SDRAM
output 		[12: 0]	DRAM_ADDR;
output		[ 1: 0]	DRAM_BA;
output					DRAM_CAS_N;
output					DRAM_CKE;
output					DRAM_CLK;
output					DRAM_CS_N;
inout			[15: 0]	DRAM_DQ;
output					DRAM_LDQM;
output					DRAM_RAS_N;
output					DRAM_UDQM;
output					DRAM_WE_N;

// I2C Bus for Configuration of the Audio and Video-In Chips
output					FPGA_I2C_SCLK;
inout						FPGA_I2C_SDAT;

// 40-pin headers
inout			[35: 0]	GPIO_0;
inout			[35: 0]	GPIO_1;

// Seven Segment Displays
output		[ 6: 0]	HEX0;
output		[ 6: 0]	HEX1;
output		[ 6: 0]	HEX2;
output		[ 6: 0]	HEX3;
output		[ 6: 0]	HEX4;
output		[ 6: 0]	HEX5;

// IR
input						IRDA_RXD;
output					IRDA_TXD;

// Pushbuttons
input			[ 3: 0]	KEY;

// LEDs
output		[ 9: 0]	LEDR;

// PS2 Ports
inout						PS2_CLK;
inout						PS2_DAT;

inout						PS2_CLK2;
inout						PS2_DAT2;

// Slider Switches
input			[ 9: 0]	SW;

// Video-In
input						TD_CLK27;
input			[ 7: 0]	TD_DATA;
input						TD_HS;
output					TD_RESET_N;
input						TD_VS;

// VGA
output		[ 7: 0]	VGA_B;
output					VGA_BLANK_N;
output					VGA_CLK;
output		[ 7: 0]	VGA_G;
output					VGA_HS;
output		[ 7: 0]	VGA_R;
output					VGA_SYNC_N;
output					VGA_VS;



////////////////////////////////////
// HPS Pins
////////////////////////////////////
	
// DDR3 SDRAM
output		[14: 0]	HPS_DDR3_ADDR;
output		[ 2: 0]  HPS_DDR3_BA;
output					HPS_DDR3_CAS_N;
output					HPS_DDR3_CKE;
output					HPS_DDR3_CK_N;
output					HPS_DDR3_CK_P;
output					HPS_DDR3_CS_N;
output		[ 3: 0]	HPS_DDR3_DM;
inout			[31: 0]	HPS_DDR3_DQ;
inout			[ 3: 0]	HPS_DDR3_DQS_N;
inout			[ 3: 0]	HPS_DDR3_DQS_P;
output					HPS_DDR3_ODT;
output					HPS_DDR3_RAS_N;
output					HPS_DDR3_RESET_N;
input						HPS_DDR3_RZQ;
output					HPS_DDR3_WE_N;

// Ethernet
output					HPS_ENET_GTX_CLK;
inout						HPS_ENET_INT_N;
output					HPS_ENET_MDC;
inout						HPS_ENET_MDIO;
input						HPS_ENET_RX_CLK;
input			[ 3: 0]	HPS_ENET_RX_DATA;
input						HPS_ENET_RX_DV;
output		[ 3: 0]	HPS_ENET_TX_DATA;
output					HPS_ENET_TX_EN;

// Flash
inout			[ 3: 0]	HPS_FLASH_DATA;
output					HPS_FLASH_DCLK;
output					HPS_FLASH_NCSO;

// Accelerometer
inout						HPS_GSENSOR_INT;

// General Purpose I/O
inout			[ 1: 0]	HPS_GPIO;

// I2C
inout						HPS_I2C_CONTROL;
inout						HPS_I2C1_SCLK;
inout						HPS_I2C1_SDAT;
inout						HPS_I2C2_SCLK;
inout						HPS_I2C2_SDAT;

// Pushbutton
inout						HPS_KEY;

// LED
inout						HPS_LED;

// SD Card
output					HPS_SD_CLK;
inout						HPS_SD_CMD;
inout			[ 3: 0]	HPS_SD_DATA;

// SPI
output					HPS_SPIM_CLK;
input						HPS_SPIM_MISO;
output					HPS_SPIM_MOSI;
inout						HPS_SPIM_SS;

// UART
input						HPS_UART_RX;
output					HPS_UART_TX;

// USB
inout						HPS_CONV_USB_N;
input						HPS_USB_CLKOUT;
inout			[ 7: 0]	HPS_USB_DATA;
input						HPS_USB_DIR;
input						HPS_USB_NXT;
output					HPS_USB_STP;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg iteration_enable;
wire signed [17:0] center_node_out;
wire [12:0] cycle_time_out;

wire [17:0] init_node;
wire [17:0] incr_value_col;
wire [17:0] incr_value_row;
wire [17:0] init_center_node;
wire [10:0] number_of_rows;
wire [17:0] init_rho;
wire [31:0] test_test;


// current free words in audio interface
reg [7:0] fifo_space;
// debug check of space
assign LEDR = fifo_space;

wire			[15: 0]	hex3_hex0;
//wire			[15: 0]	hex5_hex4;

// assign HEX0 = ~hex3_hex0[ 6: 0]; // hex3_hex0[ 6: 0]; 
// assign HEX1 = ~hex3_hex0[14: 8];
// assign HEX2 = ~hex3_hex0[22:16];
// assign HEX3 = ~hex3_hex0[30:24];
//assign HEX4 = 7'b1111111;
//assign HEX5 = 7'b1111111;
//assign HEX3 = 7'b1111111;
// assign HEX2 = 7'b1111111;
// assign HEX1 = 7'b1111111;
// assign HEX0 = 7'b1111111;
HexDigit Digit0(HEX0, cycle_time_out[3:0]);
HexDigit Digit1(HEX1, cycle_time_out[7:4]);
HexDigit Digit2(HEX2, cycle_time_out[11:8]);
HexDigit Digit3(HEX3, fifo_space[3:0]);
HexDigit Digit4(HEX4, fifo_space[7:4]);
//HexDigit Digit5(HEX5, cycle_time_out[11:8]);
HexDigit Digit5(HEX5, test_test[3:0]);
// HexDigit Digit3(HEX3, hex3_hex0[15:12]);

//=======================================================
// Bus controller for AVALON bus-master
//=======================================================
// computes DDS for sine wave and fills audio FIFO

reg [31:0] bus_addr; // Avalon address
// see 
// ftp://ftp.altera.com/up/pub/Altera_Material/15.1/University_Program_IP_Cores/Audio_Video/Audio.pdf
// for addresses
wire [31:0] audio_base_address = 32'h00003040;  // Avalon address
wire [31:0] audio_fifo_address = 32'h00003044;  // Avalon address +4 offset
wire [31:0] audio_left_address = 32'h00003048;  // Avalon address +8
wire [31:0] audio_right_address = 32'h0000304c;  // Avalon address +12
reg [3:0] bus_byte_enable; // four bit byte read/write mask
reg bus_read ;       // high when requesting data
reg bus_write;      //  high when writing data
reg [31:0] bus_write_data; //  data to send to Avalog bus
wire bus_ack ;       //  Avalon bus raises this when done
wire [31:0] bus_read_data; // data from Avalon bus
reg [30:0] timer;
reg [3:0] state;
wire state_clock;

// use 4-byte-wide bus-master	 
//assign bus_byte_enable = 4'b1111;

// get some signals exposed
// connect bus master signals to i/o for probes
assign GPIO_0[0] = bus_write;
assign GPIO_0[1] = bus_read;
assign GPIO_0[2] = bus_ack;

always @(posedge CLOCK_50) begin //CLOCK_50

	// reset state machine and read/write controls
	if (~KEY[0]) begin
		state <= 0;
		bus_read <= 0; // set to one if a read opeation from bus
		bus_write <= 0; // set to one if a write operation to bus
		timer <= 0;
		iteration_enable <= 1'b0;
	end
	else begin
		// timer just for deubgging
		timer <= timer + 1;
	end
	
	// set up read FIFO available space
	if (state==4'd0) begin
		bus_addr <= audio_fifo_address;
		bus_read <= 1'b1;
		bus_byte_enable <= 4'b1111;
		state <= 4'd1; // wait for read ACK
	end
	
	// wait for read ACK and read the fifo available
	// bus ACK is high when data is available
	if (state==4'd1 && bus_ack==1) begin
		state <= 4'd2; //4'd2
		// FIFO space is in high byte
		fifo_space <= (bus_read_data>>24);
		// end the read
		bus_read <= 1'b0;
	end
	
	// When there is room in the FIFO
	// -- compute next DDS sine sample
	// -- start write to fifo for each channel
	// -- first the left channel
	if (state==4'd2 && fifo_space>8'd2) begin // 
		state <= 4'd3;
		iteration_enable <= 1'b1;
		// convert 18-bit table to 32-bit format
		bus_write_data <= (center_node_out << 14);
		bus_addr <= audio_left_address;
		bus_byte_enable <= 4'b1111;
		bus_write <= 1'b1;
	end	
	// if no space, try again later
	else if (state==4'd2 && fifo_space<=8'd2) begin
		state <= 4'b0;
	end
	
	// detect bus-transaction-complete ACK 
	// for left channel write
	// You MUST do this check
	if (state==4'd3 && bus_ack==1) begin
		iteration_enable <= 1'b0;
		state <= 4'd4;
		bus_write <= 0;
	end
	
	// -- now the right channel
	if (state==4'd4) begin
		state <= 4'd5;	
		bus_write_data <= (center_node_out << 14);
		bus_addr <= audio_right_address;
		bus_write <= 1'b1;
	end	
	
	// detect bus-transaction-complete ACK
	// for right channel write
	// You MUST do this check
	if (state==4'd5 && bus_ack==1) begin
		state <= 4'd0;
		bus_write <= 0;
	end
	
end


//=======================================================
//  Drum Instantiation
//=======================================================
//drum #(13, 5, 31) DUT (
//  .clk(CLOCK_50),
//  .reset(test_test[0]),
//  .number_of_rows(10'd31),
//  .init_node(18'h00000),
//  .incr_value_col(18'h00091), //31x31--(0.25/15/15)=00091 02AAA for 7 nodes, 01249 for 15 nodes, 00888 for 31 nodes
//  .incr_value_row(18'h00888), // 02AAA for 7 nodes, 01249 for 15 nodes, 00888 for 31 nodes
//  .init_center_node(18'h08000),
//  .init_rho(18'h00800), 
//  .iteration_enable(iteration_enable),
//  .center_node_out(center_node_out),
//	.cycle_time_out(cycle_time_out)
//);
drum #(13, 5, 100) DUT (
  .clk(CLOCK_50),
  .reset(test_test[0]),
  .number_of_rows(number_of_rows),
  .init_node(init_node),
  .incr_value_col(incr_value_col), //31x31--(0.25/15/15)=00091 02AAA for 31 nodes
  .incr_value_row(incr_value_row), // 02AAA for 7 nodes, 01249 for 15 nodes, 00888 for 31 nodes
  .init_center_node(init_center_node),
  .init_rho(init_rho), 
  .iteration_enable(iteration_enable),
  .center_node_out(center_node_out),
	.cycle_time_out(cycle_time_out)
);

//=======================================================
//  Structural coding
//=======================================================

Computer_System The_System (
	////////////////////////////////////
	// FPGA Side
	////////////////////////////////////

	// Global signals
	.system_pll_ref_clk_clk					(CLOCK_50),
	.system_pll_ref_reset_reset			(1'b0),
	.sdram_clk_clk								(state_clock),
	
	// PIO ports
	.incr_value_col_external_connection_export     ({{14{1'b0}}, incr_value_col}),    
	.incr_value_row_external_connection_export     ({{14{1'b0}}, incr_value_row}),     
	.init_center_node_external_connection_export ({{14{1'b0}}, init_center_node}),  
	.init_node_external_connection_export               ({{14{1'b0}}, init_node}),         
	.init_rho_external_connection_export                 ({{14{1'b0}}, init_rho}),  
	.number_of_rows_external_connection_export     ({{20{1'b0}}, number_of_rows}), 	
	.test_test_external_connection_export               (test_test),         	

	// AV Config
	.av_config_SCLK							(FPGA_I2C_SCLK),
	.av_config_SDAT							(FPGA_I2C_SDAT),

	// Audio Subsystem
	.audio_pll_ref_clk_clk					(CLOCK3_50),
	.audio_pll_ref_reset_reset				(1'b0),
	.audio_clk_clk								(AUD_XCK),
	.audio_ADCDAT								(AUD_ADCDAT),
	.audio_ADCLRCK								(AUD_ADCLRCK),
	.audio_BCLK									(AUD_BCLK),
	.audio_DACDAT								(AUD_DACDAT),
	.audio_DACLRCK								(AUD_DACLRCK),

	// bus-master state machine interface
	.bus_master_audio_external_interface_address     (bus_addr),     
	.bus_master_audio_external_interface_byte_enable (bus_byte_enable), 
	.bus_master_audio_external_interface_read        (bus_read),        
	.bus_master_audio_external_interface_write       (bus_write),       
	.bus_master_audio_external_interface_write_data  (bus_write_data),  
	.bus_master_audio_external_interface_acknowledge (bus_ack),                                  
	.bus_master_audio_external_interface_read_data   (bus_read_data),   
	
	
	////////////////////////////////////
	// HPS Side
	////////////////////////////////////
	// DDR3 SDRAM
	.memory_mem_a			(HPS_DDR3_ADDR),
	.memory_mem_ba			(HPS_DDR3_BA),
	.memory_mem_ck			(HPS_DDR3_CK_P),
	.memory_mem_ck_n		(HPS_DDR3_CK_N),
	.memory_mem_cke		(HPS_DDR3_CKE),
	.memory_mem_cs_n		(HPS_DDR3_CS_N),
	.memory_mem_ras_n		(HPS_DDR3_RAS_N),
	.memory_mem_cas_n		(HPS_DDR3_CAS_N),
	.memory_mem_we_n		(HPS_DDR3_WE_N),
	.memory_mem_reset_n	(HPS_DDR3_RESET_N),
	.memory_mem_dq			(HPS_DDR3_DQ),
	.memory_mem_dqs		(HPS_DDR3_DQS_P),
	.memory_mem_dqs_n		(HPS_DDR3_DQS_N),
	.memory_mem_odt		(HPS_DDR3_ODT),
	.memory_mem_dm			(HPS_DDR3_DM),
	.memory_oct_rzqin		(HPS_DDR3_RZQ),
		  
	// Ethernet
	.hps_io_hps_io_gpio_inst_GPIO35	(HPS_ENET_INT_N),
	.hps_io_hps_io_emac1_inst_TX_CLK	(HPS_ENET_GTX_CLK),
	.hps_io_hps_io_emac1_inst_TXD0	(HPS_ENET_TX_DATA[0]),
	.hps_io_hps_io_emac1_inst_TXD1	(HPS_ENET_TX_DATA[1]),
	.hps_io_hps_io_emac1_inst_TXD2	(HPS_ENET_TX_DATA[2]),
	.hps_io_hps_io_emac1_inst_TXD3	(HPS_ENET_TX_DATA[3]),
	.hps_io_hps_io_emac1_inst_RXD0	(HPS_ENET_RX_DATA[0]),
	.hps_io_hps_io_emac1_inst_MDIO	(HPS_ENET_MDIO),
	.hps_io_hps_io_emac1_inst_MDC		(HPS_ENET_MDC),
	.hps_io_hps_io_emac1_inst_RX_CTL	(HPS_ENET_RX_DV),
	.hps_io_hps_io_emac1_inst_TX_CTL	(HPS_ENET_TX_EN),
	.hps_io_hps_io_emac1_inst_RX_CLK	(HPS_ENET_RX_CLK),
	.hps_io_hps_io_emac1_inst_RXD1	(HPS_ENET_RX_DATA[1]),
	.hps_io_hps_io_emac1_inst_RXD2	(HPS_ENET_RX_DATA[2]),
	.hps_io_hps_io_emac1_inst_RXD3	(HPS_ENET_RX_DATA[3]),

	// Flash
	.hps_io_hps_io_qspi_inst_IO0	(HPS_FLASH_DATA[0]),
	.hps_io_hps_io_qspi_inst_IO1	(HPS_FLASH_DATA[1]),
	.hps_io_hps_io_qspi_inst_IO2	(HPS_FLASH_DATA[2]),
	.hps_io_hps_io_qspi_inst_IO3	(HPS_FLASH_DATA[3]),
	.hps_io_hps_io_qspi_inst_SS0	(HPS_FLASH_NCSO),
	.hps_io_hps_io_qspi_inst_CLK	(HPS_FLASH_DCLK),

	// Accelerometer
	.hps_io_hps_io_gpio_inst_GPIO61	(HPS_GSENSOR_INT),

	//.adc_sclk                        (ADC_SCLK),
	//.adc_cs_n                        (ADC_CS_N),
	//.adc_dout                        (ADC_DOUT),
	//.adc_din                         (ADC_DIN),

	// General Purpose I/O
	.hps_io_hps_io_gpio_inst_GPIO40	(HPS_GPIO[0]),
	.hps_io_hps_io_gpio_inst_GPIO41	(HPS_GPIO[1]),

	// I2C
	.hps_io_hps_io_gpio_inst_GPIO48	(HPS_I2C_CONTROL),
	.hps_io_hps_io_i2c0_inst_SDA		(HPS_I2C1_SDAT),
	.hps_io_hps_io_i2c0_inst_SCL		(HPS_I2C1_SCLK),
	.hps_io_hps_io_i2c1_inst_SDA		(HPS_I2C2_SDAT),
	.hps_io_hps_io_i2c1_inst_SCL		(HPS_I2C2_SCLK),

	// Pushbutton
	.hps_io_hps_io_gpio_inst_GPIO54	(HPS_KEY),

	// LED
	.hps_io_hps_io_gpio_inst_GPIO53	(HPS_LED),

	// SD Card
	.hps_io_hps_io_sdio_inst_CMD	(HPS_SD_CMD),
	.hps_io_hps_io_sdio_inst_D0	(HPS_SD_DATA[0]),
	.hps_io_hps_io_sdio_inst_D1	(HPS_SD_DATA[1]),
	.hps_io_hps_io_sdio_inst_CLK	(HPS_SD_CLK),
	.hps_io_hps_io_sdio_inst_D2	(HPS_SD_DATA[2]),
	.hps_io_hps_io_sdio_inst_D3	(HPS_SD_DATA[3]),

	// SPI
	.hps_io_hps_io_spim1_inst_CLK		(HPS_SPIM_CLK),
	.hps_io_hps_io_spim1_inst_MOSI	(HPS_SPIM_MOSI),
	.hps_io_hps_io_spim1_inst_MISO	(HPS_SPIM_MISO),
	.hps_io_hps_io_spim1_inst_SS0		(HPS_SPIM_SS),

	// UART
	.hps_io_hps_io_uart0_inst_RX	(HPS_UART_RX),
	.hps_io_hps_io_uart0_inst_TX	(HPS_UART_TX),

	// USB
	.hps_io_hps_io_gpio_inst_GPIO09	(HPS_CONV_USB_N),
	.hps_io_hps_io_usb1_inst_D0		(HPS_USB_DATA[0]),
	.hps_io_hps_io_usb1_inst_D1		(HPS_USB_DATA[1]),
	.hps_io_hps_io_usb1_inst_D2		(HPS_USB_DATA[2]),
	.hps_io_hps_io_usb1_inst_D3		(HPS_USB_DATA[3]),
	.hps_io_hps_io_usb1_inst_D4		(HPS_USB_DATA[4]),
	.hps_io_hps_io_usb1_inst_D5		(HPS_USB_DATA[5]),
	.hps_io_hps_io_usb1_inst_D6		(HPS_USB_DATA[6]),
	.hps_io_hps_io_usb1_inst_D7		(HPS_USB_DATA[7]),
	.hps_io_hps_io_usb1_inst_CLK		(HPS_USB_CLKOUT),
	.hps_io_hps_io_usb1_inst_STP		(HPS_USB_STP),
	.hps_io_hps_io_usb1_inst_DIR		(HPS_USB_DIR),
	.hps_io_hps_io_usb1_inst_NXT		(HPS_USB_NXT)
);


endmodule

// ------------------------------------------------------------
// the drum
// ------------------------------------------------------------
module drum #(
  parameter eta_width=9,
  parameter g_tension_width=5,
  parameter number_of_columns=31
) (
  input clk,
  input reset,
  input [9:0] number_of_rows,
  // input [9:0] number_of_columns,
  input signed [17:0] init_node,
  input signed [17:0] incr_value_col,
  input signed [17:0] incr_value_row,
  input signed [17:0] init_center_node,
  input signed [17:0] init_rho,
  input iteration_enable,
  output signed [17:0] center_node_out,
  output        [12:0] cycle_time_out
);
  wire signed [17:0] rho;
  reg signed [17:0] init_center_node_array [number_of_columns-1:0];
  reg signed [17:0] init_center_node_value;
  reg signed [17:0] col_incr_array [number_of_columns-1:0];
  reg signed [17:0] col_incr_value;
  wire enable_signal;

  rho_update #(g_tension_width) rho_inst
  (
    .init_rho(init_rho),
    .center_node(center_node_out),
    .rho_value(rho)
  );

  // TODO: same rho for the drum or for columns?
  // TODO: initialization
  wire signed [17:0] curr_node_out [number_of_columns-1:0];
  wire signed [17:0] center_node [number_of_columns-1:0];
  wire [12:0] cycle_time [number_of_columns-1:0];
  assign cycle_time_out = cycle_time[number_of_columns>>1];
  genvar col;
  generate
    for (col = 0; col < number_of_columns; col = col + 1) begin: DRUM_COL
      if (col==0) begin
        one_column #(eta_width, g_tension_width) inst_col (
          .clk(clk),
          .reset(enable_signal),
          .column_size(number_of_rows),
          .init_node(init_node),
          .incr_value(col_incr_array[col]),//(incr_value_col),
          .init_center_node(init_center_node_array[col]),
          .init_rho(rho),
          .left_node_in(18'd0),
          .right_node_in(curr_node_out[col+1]),
          .iteration_enable(iteration_enable),
          .center_node(center_node[col]),
          .curr_node_out(curr_node_out[col]),
          .cycle_time(cycle_time[col])
        );
      end else if (col==(number_of_columns-1)) begin
        one_column #(eta_width, g_tension_width) inst_col (
          .clk(clk),
          .reset(enable_signal),
          .column_size(number_of_rows),
          .init_node(init_node),
          .incr_value(col_incr_array[col]),//(incr_value_col),
          .init_center_node(init_center_node_array[col]),
          .init_rho(rho),
          .left_node_in(curr_node_out[col-1]),
          .right_node_in(18'd0),
          .iteration_enable(iteration_enable),
          .center_node(center_node[col]),
          .curr_node_out(curr_node_out[col]),
          .cycle_time(cycle_time[col])
        );
      end else begin
        one_column #(eta_width, g_tension_width) inst_col (
          .clk(clk),
          .reset(enable_signal),
          .column_size(number_of_rows),
          .init_node(init_node),
          .incr_value(col_incr_array[col]),//(incr_value_col),
          .init_center_node(init_center_node_array[col]),
          .init_rho(rho),
          .left_node_in(curr_node_out[col-1]),
          .right_node_in(curr_node_out[col+1]),
          .iteration_enable(iteration_enable),
          .center_node(center_node[col]),
          .curr_node_out(curr_node_out[col]),
          .cycle_time(cycle_time[col])
        );
      end
    end
  endgenerate

  assign center_node_out = center_node[number_of_columns>>1];

  localparam INIT = 2'd0;
  localparam START_SIGNAL = 2'd1;
  localparam CALC = 2'd2;
  reg [9:0] counter;
  reg [1:0] state_reg, state_next;
  assign enable_signal = (state_reg == START_SIGNAL);

  always @ (posedge clk) begin
    if (reset) begin
      state_reg <= INIT;
      // counter <= 10'd0;
      // init_center_node_value <= init_node;
      // col_incr_value <= init_node;
    end else begin
      state_reg <= state_next;
    end
  end

  always@(*) begin
    if ((state_reg == INIT) && (counter ==(number_of_columns-1))) state_next = START_SIGNAL;
    else if (state_reg == START_SIGNAL) state_next = CALC;
    else state_next = state_reg;
  end

  always@(posedge clk) begin
    if (reset) begin
      counter <= 10'd0;
      init_center_node_value <= init_node;
      col_incr_value <= init_node;
    end
    else if (state_reg == INIT) begin
      counter <= counter + 1'b1;
      init_center_node_value <= (counter < (number_of_columns>>1))? init_center_node_value + incr_value_row : init_center_node_value - incr_value_row;
      init_center_node_array[counter] <= init_center_node_value; // TODO: sequentiality
      col_incr_value <= (counter < (number_of_columns>>1))? col_incr_value + incr_value_col : col_incr_value - incr_value_col;
      col_incr_array[counter] <= col_incr_value; // TODO: sequentiality
    end
    // else begin
    //   counter <= counter;
    //   init_center_node_value <= init_center_node_value;
    // end
    // if (state_reg == START_SIGNAL) begin
    //   enable_signal = 1'b1;
    // end else begin
    //   enable_signal = 1'b0;
    // end
  end

endmodule

module rho_update
#(parameter g_tension_width)
(
  input signed [17:0] init_rho,
  input signed [17:0] center_node,
  output signed [17:0] rho_value
);
  wire signed [17:0] rho_term1, rho_term2;
  assign rho_term1 = center_node >>> g_tension_width;
  signed_mult inst2 (
    .out(rho_term2),
    .a(rho_term1),
    .b(rho_term1)
  );
  assign rho_value = (18'h0FAE1 < (init_rho + rho_term2)) ? 18'h0FAE1 : (init_rho + rho_term2);
endmodule

// ------------------------------------------------------------
// one column of the drum
// ------------------------------------------------------------
module one_column
#(parameter eta_width=9, parameter g_tension_width=5)
(
  input clk,
  input reset,
  input [9:0] column_size,
  input signed [17:0] init_node,
  input signed [17:0] incr_value,
  input signed [17:0] init_center_node,
  input signed [17:0] init_rho,
  input signed [17:0] left_node_in,
  input signed [17:0] right_node_in,
  input iteration_enable,
  output signed [17:0] center_node,
  output signed [17:0] curr_node_out,
  output reg [12:0] cycle_time
);

  reg signed [17:0] center_node_reg;
  reg [17:0] curr_write_data, prev_write_data;
  reg [8:0] curr_write_address, curr_read_address, prev_write_address, prev_read_address;
  reg curr_write_enable, prev_write_enable;
  wire [17:0] curr_read_data, prev_read_data;
  assign center_node = center_node_reg;
  // reg [12:0] cycle_time;

  M10K #(18) mem_curr_node (
    .clk(clk),
    .write_enable(curr_write_enable),
    .write_address(curr_write_address),
    .read_address(curr_read_address),
    .d(curr_write_data),
    .q(curr_read_data)
  );

  M10K #(18) mem_prev_node (
    .clk(clk),
    .write_enable(prev_write_enable),
    .write_address(prev_write_address),
    .read_address(prev_read_address),
    .d(prev_write_data),
    .q(prev_read_data)
  );

  reg [3:0] state_reg, state_next;
  reg [9:0] counter;

  // state parameters
  localparam INIT = 4'd0;
  localparam INIT_LOAD = 4'd1;
  localparam BASE_LOAD_1 = 4'd2;
  localparam BASE_LOAD_2 = 4'd3;
	localparam BASE_WAIT = 4'd7;
  localparam CALC = 4'd4;
  localparam UPDATE = 4'd5;
	localparam WAIT = 4'd8;
  localparam ITERATION_DONE = 4'd6;

  // ------------- next state update -------------------
  always@(posedge clk) begin
    if (reset) begin
      state_reg <= INIT;
      // counter <= 0;
      // center_node_reg <= init_center_node;
    end else begin
      state_reg <= state_next;
    end
  end

  // --------------- state transition -------------------
  always@(*) begin
    case (state_reg)
      INIT: state_next = INIT_LOAD;
      INIT_LOAD: begin
        if (counter==(column_size-1)) state_next = BASE_LOAD_1;
        else state_next = INIT_LOAD;
      end
      BASE_LOAD_1: state_next = BASE_LOAD_2;
      BASE_LOAD_2: state_next = CALC;
			// BASE_WAIT: state_next = CALC;
      CALC: state_next = UPDATE;
      UPDATE: begin
        if (counter != (column_size-1)) state_next = CALC;
        else state_next = ITERATION_DONE;
      end
			// WAIT: state_next = CALC;
      ITERATION_DONE: begin
        if (iteration_enable) state_next = CALC;
        else state_next = ITERATION_DONE;
      end
      default: state_next = state_reg;
    endcase
  end

  // ---------------- state output ----------------------
  reg [17:0] curr_node, prev_node, top_node, bottom_node;
  wire [17:0] next_node;
  reg signed [17:0] init_node_value, init_node_value_term1;

  assign curr_node_out = curr_node;

  always @ (posedge clk) begin
    if (reset) begin
      counter <= 0;
      center_node_reg <= init_center_node;
    end else begin
      case (state_reg)
      INIT: begin
        counter <= 0;
        cycle_time <= 0;
        init_node_value <= init_node;
        init_node_value_term1 <= init_node;
      end
      INIT_LOAD: begin
        counter <= counter + 1'b1;
        init_node_value_term1 = (counter < (column_size>>1))? init_node_value_term1 + incr_value : init_node_value_term1 - incr_value;
        init_node_value = (init_node_value_term1 < init_center_node) ? init_node_value_term1 : init_center_node;
      end
      BASE_LOAD_2: begin
        counter <= 0;
        curr_node <= curr_read_data;
      end
      // BASE_WAIT: begin
      //   curr_node <= curr_read_data;
      // end
      CALC: begin
        cycle_time <= cycle_time + 1;
        top_node <= curr_read_data;
        prev_node <= prev_read_data;
        center_node_reg <= (counter == (column_size>>1)) ? next_node : center_node_reg;
      end
      UPDATE: begin
        cycle_time <= cycle_time + 1;
        curr_node <= top_node;
        bottom_node <= curr_node;
        top_node <= curr_read_data;
        prev_node <= prev_read_data;
        // counter <= (counter==(column_size-1)) ? 0 : counter + 1;
        counter <= counter + 1;
      end
      // WAIT: cycle_time <= cycle_time + 1;
      ITERATION_DONE: begin
        if (iteration_enable) begin
          counter <= 0;
          cycle_time <= 0;
        end
      end
      endcase
    end
  end

  always@(*) begin
    case(state_reg)
      INIT_LOAD: begin
        curr_write_enable = 1'b1;
        curr_write_data = init_node_value; //(counter == (column_size>>1)) ? init_center_node : init_node;
        curr_write_address = counter;
        prev_write_enable = 1'b1;
        prev_write_data = init_node_value; //(counter == (column_size>>1)) ? init_center_node : init_node;
        prev_write_address = counter;
        // latch prevention
        curr_read_address = curr_read_address;
        prev_read_address = prev_read_address;
      end
      BASE_LOAD_1: begin
        curr_read_address = 18'd0;
        curr_write_enable = 1'b0;
        prev_write_enable = 1'b0;
        // latch prevention
        prev_read_address = prev_read_address;
        curr_write_data = curr_write_data;
        prev_write_data = prev_write_data;
        curr_write_address = curr_write_address;
        prev_write_address = prev_write_address;
      end
      BASE_LOAD_2: begin
        // curr_node <= curr_read_data;
        curr_read_address = 18'd1;
        prev_read_address = 18'd0;
        // latch prevention
        curr_write_enable = 1'b0;
        prev_write_enable = 1'b0;
        curr_write_data = curr_write_data;
        prev_write_data = prev_write_data;
        curr_write_address = curr_write_address;
        prev_write_address = prev_write_address;
      end
      CALC: begin 
        // latch prevention
        curr_write_enable = 1'b0;
        prev_write_enable = 1'b0;
        curr_write_data = curr_write_data;
        prev_write_data = prev_write_data;
        curr_write_address = curr_write_address;
        prev_write_address = prev_write_address;
        curr_read_address = curr_read_address;
        prev_read_address = prev_read_address;
        // TODO: disable M10K write?
        // top_node <= curr_read_data;
        // prev_node <= prev_read_data;
        // TODO: center node update
        // if (counter == (column_size>>1)) center_node <= next_node;
      end
      UPDATE: begin
        curr_write_enable = 1'b1;
        prev_write_enable = 1'b1;
        curr_write_address = counter;
        curr_write_data = next_node;
        prev_write_address = counter;
        prev_write_data = curr_node;
        curr_read_address = (counter==(column_size-2)) ? 0 :
                             ((counter==(column_size-1)) ? 1 : counter + 2);
        prev_read_address = (counter==(column_size-1)) ? 0 : counter + 1;
        // curr_node <= top_node;
        // bottom_node <= curr_node;
        // TODO: wrap around and overflow handling
        // counter <= (counter==(column_size-1)) ? 0 : counter + 1;
      end
      default: begin
        // latch prevention
        curr_write_enable = 1'b0;
        prev_write_enable = 1'b0;
        curr_write_data = curr_write_data;
        prev_write_data = prev_write_data;
        curr_write_address = curr_write_address;
        prev_write_address = prev_write_address;
        curr_read_address = curr_read_address;
        prev_read_address = prev_read_address;
      end
    endcase
  end

  // TODO: edge handling
  // wire signed [17:0] rho;
  node_compute #(eta_width) compute_inst 
  (
    .curr_node(curr_node),
    .left_node(left_node_in),
    .right_node(right_node_in),
    .top_node((counter==(column_size-1))?18'd0:top_node),
    .bottom_node((counter==0)?18'd0:bottom_node),
    .prev_node(prev_node),
    .rho(init_rho), //rho),
    .next_node(next_node)
  );

endmodule

module node_compute 
#(parameter eta_width)
(
  input signed [17:0] curr_node,
  input signed [17:0] left_node,
  input signed [17:0] right_node,
  input signed [17:0] top_node,
  input signed [17:0] bottom_node,
  input signed [17:0] prev_node,
  input signed [17:0] rho,
  output signed [17:0] next_node
);
  wire signed [17:0] node_sum, current_term, undamped_sum, damped_prev_node;
  assign node_sum = left_node+right_node+top_node+bottom_node-(curr_node<<2);
  signed_mult inst1 (
    .out(current_term),
    .a(node_sum),
    .b(rho)
  );
  assign damped_prev_node = prev_node - (prev_node>>>eta_width); 
  assign undamped_sum = current_term + (curr_node<<1) - damped_prev_node;
  assign next_node = undamped_sum - (undamped_sum>>>eta_width);
endmodule

// module rho_update
// #(parameter g_tension_width)
// (
//   input signed [17:0] init_rho,
//   input signed [17:0] center_node,
//   output signed [17:0] rho_value
// );
//   wire signed [17:0] rho_term1, rho_term2;
//   assign rho_term1 = center_node >>> g_tension_width;
//   signed_mult inst2 (
//     .out(rho_term2),
//     .a(rho_term1),
//     .b(rho_term1)
//   );
//   assign rho_value = (18'h0FAE1 < (init_rho + rho_term2)) ? 18'h0FAE1 : (init_rho + rho_term2);
// endmodule

module signed_mult (out, a, b);
  output  signed  [17:0]  out;
  input   signed  [17:0]  a;
  input   signed  [17:0]  b;
  // intermediate full bit length
  wire  signed  [35:0]  mult_out;
  assign mult_out = a * b;
  // select bits for 7.20 fixed point
  assign out = {mult_out[35], mult_out[33:17]};
endmodule

module M10K #(parameter data_width) (
  input clk,
  input write_enable,
  input [8:0] write_address,
  input [8:0] read_address,
  input [data_width-1:0] d,
  output reg [data_width-1:0] q
);
  reg [19:0] mem [511:0];
  reg [data_width-1:0] buffer;
  always @ (posedge clk) begin
    if (write_enable) begin
      mem[write_address] <= d;
    end
    q <= mem[read_address][data_width-1:0];
		// q <= buffer;
  end
endmodule

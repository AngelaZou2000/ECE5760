

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

wire			[23: 0]	hex3_hex0;
//wire			[15: 0]	hex5_hex4;

//assign HEX0 = ~hex3_hex0[ 6: 0]; // hex3_hex0[ 6: 0]; 
//assign HEX1 = ~hex3_hex0[14: 8];
//assign HEX2 = ~hex3_hex0[22:16];
//assign HEX3 = ~hex3_hex0[30:24];
//assign HEX4 = 7'b1111111;
//assign HEX5 = 7'b1111111;

HexDigit Digit0(HEX0, hex3_hex0[3:0]);
HexDigit Digit1(HEX1, hex3_hex0[7:4]);
HexDigit Digit2(HEX2, hex3_hex0[11:8]);
HexDigit Digit3(HEX3, hex3_hex0[15:12]);
HexDigit Digit4(HEX4, hex3_hex0[19:16]);
HexDigit Digit5(HEX5, hex3_hex0[23:20]);
// VGA clock and reset lines
wire vga_pll_lock ;
wire vga_pll ;
reg  vga_reset ;

// M10k memory control and data
wire 		[7:0] 	M10k_out ;
reg 		[7:0] 	write_data ;
reg 		[18:0] 	write_address ;
reg 		[18:0] 	read_address ;
reg 					write_enable ;

// M10k memory clock
wire 					M10k_pll ;
wire 					M10k_pll_locked ;

wire [31:0] init_x, init_y, x_partition_incr, y_partition_incr, x_incr, y_incr, x_limit, y_limit, external_reset;
wire iterator_done;
wire [31:0] MAX_ITERATIONS;
wire iterator_reset;

assign iterator_reset = (~KEY[0]) ? 1 : (external_reset[0] ? 1 : 0);

mandelbrot_vga #(4, 76800, 160, 480) inst (
	.iterator_clk(CLOCK_50),
	.vga_driver_clk(vga_pll),
	.iterator_reset(iterator_reset),
	.vga_reset(vga_reset),
	// iterator signals
  .init_x     (init_x),
  .init_y     (init_y),
  .x_partition_incr (x_partition_incr), // 3/640
  .y_partition_incr (y_partition_incr),
  .x_incr     (x_incr), 
  .y_incr     (y_incr),
  .x_limit    (x_limit),
  .y_limit    (y_limit),
	.MAX_ITERATIONS (MAX_ITERATIONS),
	.iterator_done (iterator_done),
	// VGA driver signals
	.hsync(VGA_HS),
	.vsync(VGA_VS),
	.red(VGA_R),
	.green(VGA_G),
	.blue(VGA_B),
	.sync(VGA_SYNC_N),
	.clk(VGA_CLK),
	.blank(VGA_BLANK_N)
);
wire [31:0] cycle_count_pio;
reg [31:0] cycle_counter;
reg counting_signal;
assign cycle_count_pio = cycle_counter;
assign hex3_hex0 = cycle_counter;
assign LEDR[0] = external_reset;
assign LEDR[1] = iterator_done;
always@(posedge CLOCK_50) begin
	if (external_reset) begin
		cycle_counter <= 32'b0;
		counting_signal <= 1'b0;
	end
	else if (iterator_done) begin
		cycle_counter <= cycle_counter;
		counting_signal <= 1'b0;
	end
	else begin
		cycle_counter <= cycle_counter + 1'b1;
		counting_signal <= 1'b1;
	end
end

//=======================================================
//  Structural coding
//=======================================================
// From Qsys

Computer_System The_System (
	////////////////////////////////////
	// FPGA Side
	////////////////////////////////////
	.vga_pio_locked_export			(vga_pll_lock),           //       vga_pio_locked.export
	.vga_pio_outclk0_clk				(vga_pll),              //      vga_pio_outclk0.clk
	.m10k_pll_locked_export			(M10k_pll_locked),          //      m10k_pll_locked.export
	.m10k_pll_outclk0_clk			(M10k_pll),            //     m10k_pll_outclk0.clk

	// Global signals
	.system_pll_ref_clk_clk					(CLOCK_50),
	.system_pll_ref_reset_reset			(1'b0),
	
	// PIO ports
	.init_x_external_connection_export 	(init_x),
	.init_y_external_connection_export	(init_y),
	.x_partition_incr_external_connection_export	(x_partition_incr),
	.y_partition_incr_external_connection_export (y_partition_incr),
	.x_incr_external_connection_export	(x_incr),        
	.y_incr_external_connection_export	(y_incr),           
	.x_limit_external_connection_export	(x_limit),          
	.y_limit_external_connection_export	(y_limit),
	.external_reset_external_connection_export	(external_reset),
	.cycle_count_external_connection_export (cycle_count_pio),
	.max_iteration_external_connection_export (MAX_ITERATIONS),
	

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
endmodule // end top level


//============================================================
// VGA Driver
//============================================================
module vga_driver (
	input wire clock,
	input wire reset,
	input [7:0] color_in,
	output [9:0] next_x,
	output [9:0] next_y,
	output wire hsync,
	output wire vsync,
	output [7:0] red,
	output [7:0] green,
	output [7:0] blue,
	output sync,
	output clk,
	output blank
);
	
	// Horizontal parameters (measured in clock cycles)
	parameter [9:0] H_ACTIVE  	=  10'd_639 ;
	parameter [9:0] H_FRONT 	=  10'd_15 ;
	parameter [9:0] H_PULSE		=  10'd_95 ;
	parameter [9:0] H_BACK 		=  10'd_47 ;

	// Vertical parameters (measured in lines)
	parameter [9:0] V_ACTIVE  	=  10'd_479 ;
	parameter [9:0] V_FRONT 	=  10'd_9 ;
	parameter [9:0] V_PULSE		=  10'd_1 ;
	parameter [9:0] V_BACK 		=  10'd_32 ;
	
	// Parameters for readability
	parameter 	LOW 	= 1'b_0 ;
	parameter 	HIGH	= 1'b_1 ;

	// States (more readable)
	parameter 	[7:0]	H_ACTIVE_STATE 		= 8'd_0 ;
	parameter 	[7:0] 	H_FRONT_STATE		= 8'd_1 ;
	parameter 	[7:0] 	H_PULSE_STATE 		= 8'd_2 ;
	parameter 	[7:0] 	H_BACK_STATE 		= 8'd_3 ;

	parameter 	[7:0]	V_ACTIVE_STATE 		= 8'd_0 ;
	parameter 	[7:0] 	V_FRONT_STATE		= 8'd_1 ;
	parameter 	[7:0] 	V_PULSE_STATE 		= 8'd_2 ;
	parameter 	[7:0] 	V_BACK_STATE 		= 8'd_3 ;

	// Clocked registers
	reg 		hysnc_reg ;
	reg 		vsync_reg ;
	reg 	[7:0]	red_reg ;
	reg 	[7:0]	green_reg ;
	reg 	[7:0]	blue_reg ;
	reg 		line_done ;

	// Control registers
	reg 	[9:0] 	h_counter ;
	reg 	[9:0] 	v_counter ;

	reg 	[7:0]	h_state ;
	reg 	[7:0]	v_state ;

	// State machine
	always@(posedge clock) begin
		// At reset . . .
  		if (reset) begin
			// Zero the counters
			h_counter 	<= 10'd_0 ;
			v_counter 	<= 10'd_0 ;
			// States to ACTIVE
			h_state 	<= H_ACTIVE_STATE  ;
			v_state 	<= V_ACTIVE_STATE  ;
			// Deassert line done
			line_done 	<= LOW ;
  		end
  		else begin
			//////////////////////////////////////////////////////////////////////////
			///////////////////////// HORIZONTAL /////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////
			if (h_state == H_ACTIVE_STATE) begin
				// Iterate horizontal counter, zero at end of ACTIVE mode
				h_counter <= (h_counter==H_ACTIVE)?10'd_0:(h_counter + 10'd_1) ;
				// Set hsync
				hysnc_reg <= HIGH ;
				// Deassert line done
				line_done <= LOW ;
				// State transition
				h_state <= (h_counter == H_ACTIVE)?H_FRONT_STATE:H_ACTIVE_STATE ;
			end
			// Assert done flag, wait here for reset
			if (h_state == H_FRONT_STATE) begin
				// Iterate horizontal counter, zero at end of H_FRONT mode
				h_counter <= (h_counter==H_FRONT)?10'd_0:(h_counter + 10'd_1) ;
				// Set hsync
				hysnc_reg <= HIGH ;
				// State transition
				h_state <= (h_counter == H_FRONT)?H_PULSE_STATE:H_FRONT_STATE ;
			end
			if (h_state == H_PULSE_STATE) begin
				// Iterate horizontal counter, zero at end of H_FRONT mode
				h_counter <= (h_counter==H_PULSE)?10'd_0:(h_counter + 10'd_1) ;
				// Set hsync
				hysnc_reg <= LOW ;
				// State transition
				h_state <= (h_counter == H_PULSE)?H_BACK_STATE:H_PULSE_STATE ;
			end
			if (h_state == H_BACK_STATE) begin
				// Iterate horizontal counter, zero at end of H_FRONT mode
				h_counter <= (h_counter==H_BACK)?10'd_0:(h_counter + 10'd_1) ;
				// Set hsync
				hysnc_reg <= HIGH ;
				// State transition
				h_state <= (h_counter == H_BACK)?H_ACTIVE_STATE:H_BACK_STATE ;
				// Signal line complete at state transition (offset by 1 for synchronous state transition)
				line_done <= (h_counter == (H_BACK-1))?HIGH:LOW ;
			end
			//////////////////////////////////////////////////////////////////////////
			///////////////////////// VERTICAL ///////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////
			if (v_state == V_ACTIVE_STATE) begin
				// increment vertical counter at end of line, zero on state transition
				v_counter <= (line_done==HIGH)?((v_counter==V_ACTIVE)?10'd_0:(v_counter + 10'd_1)):v_counter ;
				// set vsync in active mode
				vsync_reg <= HIGH ;
				// state transition - only on end of lines
				v_state <= (line_done==HIGH)?((v_counter==V_ACTIVE)?V_FRONT_STATE:V_ACTIVE_STATE):V_ACTIVE_STATE ;
			end
			if (v_state == V_FRONT_STATE) begin
				// increment vertical counter at end of line, zero on state transition
				v_counter <= (line_done==HIGH)?((v_counter==V_FRONT)?10'd_0:(v_counter + 10'd_1)):v_counter ;
				// set vsync in front porch
				vsync_reg <= HIGH ;
				// state transition
				v_state <= (line_done==HIGH)?((v_counter==V_FRONT)?V_PULSE_STATE:V_FRONT_STATE):V_FRONT_STATE ;
			end
			if (v_state == V_PULSE_STATE) begin
				// increment vertical counter at end of line, zero on state transition
				v_counter <= (line_done==HIGH)?((v_counter==V_PULSE)?10'd_0:(v_counter + 10'd_1)):v_counter ;
				// clear vsync in pulse
				vsync_reg <= LOW ;
				// state transition
				v_state <= (line_done==HIGH)?((v_counter==V_PULSE)?V_BACK_STATE:V_PULSE_STATE):V_PULSE_STATE ;
			end
			if (v_state == V_BACK_STATE) begin
				// increment vertical counter at end of line, zero on state transition
				v_counter <= (line_done==HIGH)?((v_counter==V_BACK)?10'd_0:(v_counter + 10'd_1)):v_counter ;
				// set vsync in back porch
				vsync_reg <= HIGH ;
				// state transition
				v_state <= (line_done==HIGH)?((v_counter==V_BACK)?V_ACTIVE_STATE:V_BACK_STATE):V_BACK_STATE ;
			end

			//////////////////////////////////////////////////////////////////////////
			//////////////////////////////// COLOR OUT ///////////////////////////////
			//////////////////////////////////////////////////////////////////////////
			red_reg 		<= (h_state==H_ACTIVE_STATE)?((v_state==V_ACTIVE_STATE)?{color_in[7:5],5'd_0}:8'd_0):8'd_0 ;
			green_reg 	<= (h_state==H_ACTIVE_STATE)?((v_state==V_ACTIVE_STATE)?{color_in[4:2],5'd_0}:8'd_0):8'd_0 ;
			blue_reg 	<= (h_state==H_ACTIVE_STATE)?((v_state==V_ACTIVE_STATE)?{color_in[1:0],6'd_0}:8'd_0):8'd_0 ;
			
 	 	end
	end
	// Assign output values
	assign hsync = hysnc_reg ;
	assign vsync = vsync_reg ;
	assign red = red_reg ;
	assign green = green_reg ;
	assign blue = blue_reg ;
	assign clk = clock ;
	assign sync = 1'b_0 ;
	assign blank = hysnc_reg & vsync_reg ;
	// The x/y coordinates that should be available on the NEXT cycle
	assign next_x = (h_state==H_ACTIVE_STATE)?h_counter:10'd_0 ;
	assign next_y = (v_state==V_ACTIVE_STATE)?v_counter:10'd_0 ;

endmodule

//============================================================
// Iterator Top
//============================================================
module iterator_top #(
  parameter PARTITION = 2,
  parameter PARTITION_SIZE = 100000,
  parameter PARTITION_ROW_SIZE = 320,
  parameter PARTITION_COL_SIZE = 480
)
(
  input clk,
  input reset,
  input signed [26:0] init_x,
  input signed [26:0] init_y,
  input signed [26:0] x_partition_incr,
  input signed [26:0] y_partition_incr,
  input signed [26:0] x_incr, // TODO: process on the HPS side
  input signed [26:0] y_incr,
  input signed [26:0] x_limit, 
  input signed [26:0] y_limit,
  // output [10:0] output_counter,
  output wire done,
  input [$clog2(PARTITION_SIZE)-1:0] m10k_read_address,
  input [$clog2(PARTITION)-1:0] partition_index,
  input [31:0] MAX_ITERATIONS,
  output [7:0] vga_data
);

  wire iterator_reset;
  reg signed [26:0] init_x_value, init_y_value;
  reg signed [26:0] init_x_arr [PARTITION-1:0];
  reg signed [26:0] init_y_arr [PARTITION-1:0];
  reg signed [26:0] x_limit_arr [PARTITION-1:0];
  reg signed [26:0] y_limit_arr [PARTITION-1:0];
  wire signed [$clog2(PARTITION_SIZE)-1:0] output_counter_arr [PARTITION-1:0];
  wire [7:0] m10k_read_data_arr [PARTITION-1:0];
  wire [PARTITION-1:0] iterator_done;

  assign done = &iterator_done;
  assign vga_data = m10k_read_data_arr[partition_index];

  genvar partition;
  generate
    for (partition = 0; partition < PARTITION; partition = partition + 1) begin: PART
      iterator_loop #(PARTITION, PARTITION_SIZE, PARTITION_ROW_SIZE, PARTITION_COL_SIZE) iterator1 (
        .clk(clk),
        .reset(iterator_reset),
        .init_x(init_x_arr[partition]),
        .init_y(init_y_arr[partition]),
        .x_incr(x_incr),
        .y_incr(y_incr),
        .x_limit(x_limit_arr[partition]),
        .y_limit(y_limit_arr[partition]),
        .output_counter(output_counter_arr[partition]),
        .done(iterator_done[partition]),
        .m10k_read_address(m10k_read_address),
        .MAX_ITERATIONS(MAX_ITERATIONS),
        .m10k_read_data(m10k_read_data_arr[partition])
      );
    end
  endgenerate

  localparam INIT = 2'd0;
  localparam START_SIGNAL = 2'd1;
  localparam CALC = 2'd2;
  reg [31:0] counter;
  reg [1:0] state_reg, state_next;
  assign iterator_reset = (state_reg == START_SIGNAL);

  always @ (posedge clk) begin
    if (reset) begin
      state_reg <= INIT;
    end else begin
      state_reg <= state_next;
    end
  end

  always@(*) begin
    // if finished initialization all columns, move on to next state
    if ((state_reg == INIT) && (counter == (PARTITION-1))) state_next = START_SIGNAL;
    // move to calculation stage after sends out the enable signal
    else if (state_reg == START_SIGNAL) state_next = CALC;
    else state_next = state_reg;
  end

  always@(posedge clk) begin
    if (reset) begin
      counter <= 32'd0;
      init_x_value <= init_x;
      init_y_value <= init_y;
    end
    else if (state_reg == INIT) begin
      // increse the initialization counter
      counter <= counter + 1'b1;
      init_x_value <= init_x_value + x_partition_incr;
      init_x_arr[counter] <= init_x_value;
      init_y_value <= init_y_value + y_partition_incr;
      init_y_arr[counter] <= init_y_value;
      x_limit_arr[counter] <= x_limit - x_incr;
      y_limit_arr[counter] <= y_limit - y_incr;
    end
    else if (state_reg == START_SIGNAL) 
      counter <= 32'd0;
    else if (state_reg == CALC & ~done) 
      counter <= counter + 1'b1;
  end

endmodule

//============================================================
// Iterator Loop
//============================================================
module iterator_loop #(
  parameter PARTITION = 2,
  parameter PARTITION_SIZE = 100000,
  parameter PARTITION_ROW_SIZE = 320,
  parameter PARTITION_COL_SIZE = 480
  ) (
  input clk,
  input reset,
  input signed [26:0] init_x,
  input signed [26:0] init_y,
  input signed [26:0] x_incr,
  input signed [26:0] y_incr,
  input signed [26:0] x_limit,
  input signed [26:0] y_limit,
  output [$clog2(PARTITION_SIZE)-1:0] output_counter,
  output wire done,
  // VGA handling
  input [$clog2(PARTITION_SIZE)-1:0] m10k_read_address,
  input [31:0] MAX_ITERATIONS,
  output [7:0] m10k_read_data
);
  
  reg signed [26:0] current_x, current_y;
  reg [31:0] total_counter;
  reg iterator_done, node_reset, node_reset_signal;
  reg [$clog2(PARTITION_SIZE)-1:0] node_address, node_row_address, node_col_address;
  wire node_done;
  
  assign done       = iterator_done;
  
  always@(posedge clk) begin
    if (reset) begin
      current_x     <= init_x;
      current_y     <= init_y;
      total_counter <= 32'd0;
      node_reset    <= 1'd1;
      iterator_done <= 1'd0;
      node_address <= 0;
      node_row_address <= 0;
      node_col_address <= 0;
      if (node_reset) node_reset <= 1'd0;
    end else begin
      if (node_done & ~iterator_done & ~node_reset) begin
        node_address <= node_address + 1'b1;
        node_reset    <= 1'd1;
        total_counter <= total_counter + output_counter;
        current_x     <= current_x + x_incr;
        node_row_address <= node_row_address + 1'b1;
        if (node_row_address>=PARTITION_ROW_SIZE-1) begin
          current_y <= current_y + y_incr;
          current_x <= init_x;
          node_row_address <= 0;
          node_col_address <= node_col_address + 1'b1;
          if (node_col_address>=PARTITION_COL_SIZE-1) begin
            iterator_done <= 1'd1;
          end
        end
      end
      if (node_reset) begin
        node_reset <= 1'd0;
      end
    end
  end
      
  iterator #(PARTITION_SIZE) node_inst (
  .clk                (clk),
  .reset              (node_reset),
  .cr                 (current_x),
  .ci                 (current_y),
  .counter            (output_counter),
  .done               (node_done),
  .m10k_read_address  (m10k_read_address),
  .m10k_write_address (node_address),
  .MAX_ITERATIONS     (MAX_ITERATIONS),
  .m10k_read_data     (m10k_read_data)
  );

endmodule



//============================================================
// Iterator
//============================================================
module iterator #(parameter PARTITION_SIZE = 100000) (
  input               clk,
  input               reset,
  input signed [26:0] cr,
  input signed [26:0] ci,
  output [$clog2(PARTITION_SIZE)-1:0]       counter,
  output              done,
  // VGA handling
  input [$clog2(PARTITION_SIZE)-1:0] m10k_read_address,
  input [$clog2(PARTITION_SIZE)-1:0] m10k_write_address,
  input [31:0] MAX_ITERATIONS,
  output [7:0] m10k_read_data
);
  reg signed [26:0] curr_zr, curr_zi, curr_zr_pow2, curr_zi_pow2;
  wire signed [26:0] next_zr, next_zi, next_zr_pow2, next_zi_pow2, zizr;
  reg [$clog2(PARTITION_SIZE)-1:0] local_counter;
  reg done_signal;
  assign counter = local_counter;
  assign done = done_signal;

  localparam signed TWO = 27'h1000000;
  localparam signed FOUR = 27'h2000000;
  localparam signed NEGTWO = 27'h7000000;

  always@(posedge clk) begin
    if (reset) begin
      curr_zr <= 27'd0;
      curr_zr_pow2 <= 27'd0;
      curr_zi <= 27'd0;
      curr_zi_pow2 <= 27'd0;
      local_counter <= 'd0;
      done_signal <= 1'b0;
    end else begin
      if (local_counter >= MAX_ITERATIONS) begin
        local_counter <= local_counter;
        done_signal <= 1'b1;
      end else if (($signed(curr_zr)>=$signed(TWO))|($signed(curr_zi)>=$signed(TWO))|
                  ($signed(curr_zr)<=$signed(NEGTWO))|($signed(curr_zi)<=$signed(NEGTWO))|
                  ($signed(curr_zr_pow2+curr_zi_pow2)>=$signed(FOUR))) begin
        local_counter <= local_counter;
        done_signal <= 1'b1;
      end else begin
        local_counter <= local_counter + 1'd1;
        curr_zr <= next_zr;
        curr_zi <= next_zi;
        curr_zr_pow2 <= next_zr_pow2;
        curr_zi_pow2 <= next_zi_pow2; 
      end
    end
  end

  assign next_zr = curr_zr_pow2 - curr_zi_pow2 + cr;
  signed_mult zizrmult (zizr, curr_zr, curr_zi);
  assign next_zi = (zizr <<< 1) + ci;
  signed_mult zr_sq (next_zr_pow2, next_zr, next_zr);
  signed_mult zi_sq (next_zi_pow2, next_zi, next_zi);

  wire [7:0] color_reg;
  assign color_reg = (counter >= MAX_ITERATIONS)         ? 8'b00000000 : 
                     (counter >= (MAX_ITERATIONS >>> 1)) ? 8'b01100100 :
                     (counter >= (MAX_ITERATIONS >>> 2)) ? 8'b01100100 :
                     (counter >= (MAX_ITERATIONS >>> 3)) ? 8'b10101001 :
                     (counter >= (MAX_ITERATIONS >>> 4)) ? 8'b01100101 :
                     (counter >= (MAX_ITERATIONS >>> 5)) ? 8'b00100101 :
                     (counter >= (MAX_ITERATIONS >>> 6)) ? 8'b01101010 :
                     (counter >= (MAX_ITERATIONS >>> 7)) ? 8'b01010010 :
                     (counter >= (MAX_ITERATIONS >>> 8)) ? 8'b01010010 : 8'b01010010;

  M10K #(8, PARTITION_SIZE) mem (
  .clk(clk),
  .write_enable(done_signal),
  .write_address(m10k_write_address),
  .read_address(m10k_read_address),
  .d(color_reg),
  .q(m10k_read_data)
);

endmodule

// 4.23 notation
module signed_mult (out, a, b);
  output  signed  [26:0]  out;
  input   signed  [26:0]  a;
  input   signed  [26:0]  b;
  // intermediate full bit length
  wire  signed  [53:0]  mult_out;
  assign mult_out = a * b;
  // select bits for 4.23 fixed point
  assign out = {mult_out[53], mult_out[48:23]};
endmodule


module M10K #(parameter DATA_WIDTH = 8, parameter PARTITION_SIZE = 100000) (
  input clk,
  input write_enable,
  input [$clog2(PARTITION_SIZE)-1:0] write_address,
  input [$clog2(PARTITION_SIZE)-1:0] read_address,
  input [DATA_WIDTH-1:0] d,
  output reg [DATA_WIDTH-1:0] q
);
  reg [DATA_WIDTH-1:0] mem [PARTITION_SIZE-1:0];
  always @ (posedge clk) begin
    if (write_enable) begin
      mem[write_address] <= d;
    end
    q <= mem[read_address][DATA_WIDTH-1:0];
  end
endmodule


//============================================================
// Mapper
//============================================================
module mapper #(
  parameter PARTITION = 2,
  parameter PARTITION_SIZE = 153600,
  parameter PARTITION_ROW_SIZE = 320,
  parameter PARTITION_COL_SIZE = 480
  ) (
  input [9:0] next_x,
  input [9:0] next_y,
  output [$clog2(PARTITION_SIZE)-1:0] m10k_read_address,
  output [$clog2(PARTITION)-1:0] partition_index
);

wire [$clog2(PARTITION_SIZE)-1:0] mult;

assign partition_index = next_x[$clog2(PARTITION)-1:0];
assign mult = next_y * PARTITION_ROW_SIZE;
assign m10k_read_address = mult + (next_x >> $clog2(PARTITION));


endmodule


//============================================================
// mandelbrot_vga
//============================================================
module mandelbrot_vga #(
  parameter PARTITION = 2,
  parameter PARTITION_SIZE = 100000,
  parameter PARTITION_ROW_SIZE = 320,
  parameter PARTITION_COL_SIZE = 480
) (
  input iterator_clk,
  input vga_driver_clk,
  input iterator_reset,
  input vga_reset,
  // iterator signals
  input signed [26:0] init_x,
  input signed [26:0] init_y,
  input signed [26:0] x_partition_incr,
  input signed [26:0] y_partition_incr,
  input signed [26:0] x_incr, // TODO: process on the HPS side
  input signed [26:0] y_incr,
  input signed [26:0] x_limit, 
  input signed [26:0] y_limit,
  input [31:0] MAX_ITERATIONS,
  output wire iterator_done,
  // VGA driver signals
  output wire hsync,    // HSYNC (to VGA connector)
  output wire vsync,    // VSYNC (to VGA connctor)
  output [7:0] red,     // RED (to resistor DAC VGA connector)
  output [7:0] green,   // GREEN (to resistor DAC to VGA connector)
  output [7:0] blue,    // BLUE (to resistor DAC to VGA connector)
  output sync,          // SYNC to VGA connector
  output clk,           // CLK to VGA connector
  output blank          // BLANK to VGA connector
);

  wire [7:0] vga_data;
  wire [$clog2(PARTITION_SIZE)-1:0] m10k_read_address;
  wire [$clog2(PARTITION)-1:0] partition_index;
  wire [9:0] next_x, next_y;

  iterator_top #(PARTITION, PARTITION_SIZE, PARTITION_ROW_SIZE, PARTITION_COL_SIZE) iterator_inst (
    .clk(iterator_clk),
    .reset(iterator_reset),
    .init_x(init_x),
    .init_y(init_y),
    .x_partition_incr(x_partition_incr),
    .y_partition_incr(y_partition_incr),
    .x_incr(x_incr),
    .y_incr(y_incr),
    .x_limit(x_limit), 
    .y_limit(y_limit),
    .done(iterator_done),
    .m10k_read_address(m10k_read_address),
    .partition_index(partition_index),
    .MAX_ITERATIONS(MAX_ITERATIONS),
    .vga_data(vga_data)
  );

  mapper #(PARTITION, PARTITION_SIZE, PARTITION_ROW_SIZE, PARTITION_COL_SIZE) mapper_inst (
    .next_x(next_x),
    .next_y(next_y),
    .m10k_read_address(m10k_read_address),
    .partition_index(partition_index)
  );

  vga_driver driver_inst (
    .clock(vga_driver_clk),     
    .reset(vga_reset),     
    .color_in(vga_data), 
    .next_x(next_x),  
    .next_y(next_y),  
    .hsync(hsync),    
    .vsync(vsync),    
    .red(red),     
    .green(green),   
    .blue(blue),    
    .sync(sync),          
    .clk(clk),           
    .blank(blank)     
);

endmodule

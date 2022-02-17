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
// PIO state machine
//=======================================================
// OUTPUTs from the FPGA, INPUT to HPS
wire [31:0] pp_in_lw_axi ;
// INPUTS to the FPGA, OUTPUT from HPS
wire [31:0] pp_out_lw_axi ;

//=======================================================
// Functioning Kernel
//=======================================================
wire [26:0] x_result, y_result, z_result;
wire [31:0] x_out, y_out, z_out;
wire [31:0] init_x, init_y, init_z, sigma, beta, rho, dt;
assign x_out = {{5{x_result[26]}}, x_result};
assign y_out = {{5{y_result[26]}}, y_result};
assign z_out = {{5{z_result[26]}}, z_result};
 ODEsolver inst (
  .clk(pp_out_lw_axi[0]),
  .reset(pp_out_lw_axi[1]),
  .dt(dt[26:0]),
  .init_x(init_x[26:0]),
  .init_y(init_y[26:0]),
  .init_z(init_z[26:0]),
  .beta(beta[26:0]),
  .sigma(sigma[26:0]),
  .rho(rho[26:0]),
  .x(x_result),
  .y(y_result),
  .z(z_result)
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
	// PIO ports 
	.pio_x_lw_input_external_connection_export (x_out),
	.pio_y_lw_input_external_connection_export (y_out),
	.pio_z_lw_input_external_connection_export (z_out),     
	.init_x_output_external_connection_export  (init_x),
	.init_y_output_external_connection_export  (init_y),
	.init_z_output_external_connection_export  (init_z),
	.sigma_output_external_connection_export   (sigma),
	.beta_output_external_connection_export    (beta),
	.rho_output_external_connection_export     (rho), 
	.dt_output_external_connection_export      (dt), 
	.pp_in_lw_axi_export                       (pp_in_lw_axi),                      
	.pp_out_lw_axi_export                      (pp_out_lw_axi),                     
	// AV Config
	.av_config_SCLK							(FPGA_I2C_SCLK),
	.av_config_SDAT							(FPGA_I2C_SDAT),
	// VGA Subsystem
	.vga_pll_ref_clk_clk 					(CLOCK2_50),
	.vga_pll_ref_reset_reset				(1'b0),
	.vga_CLK										(VGA_CLK),
	.vga_BLANK									(VGA_BLANK_N),
	.vga_SYNC									(VGA_SYNC_N),
	.vga_HS										(VGA_HS),
	.vga_VS										(VGA_VS),
	.vga_R										(VGA_R),
	.vga_G										(VGA_G),
	.vga_B										(VGA_B),
	// SDRAM
	.sdram_clk_clk								(DRAM_CLK),
   .sdram_addr									(DRAM_ADDR),
	.sdram_ba									(DRAM_BA),
	.sdram_cas_n								(DRAM_CAS_N),
	.sdram_cke									(DRAM_CKE),
	.sdram_cs_n									(DRAM_CS_N),
	.sdram_dq									(DRAM_DQ),
	.sdram_dqm									({DRAM_UDQM,DRAM_LDQM}),
	.sdram_ras_n								(DRAM_RAS_N),
	.sdram_we_n									(DRAM_WE_N),
	
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

//============================================================
// ODE Solver
//============================================================
// Inputs: clk, reset, dt, init x/y/z, beta, sigma, rho
// Outputs: x, y, z
module ODEsolver (
  input clk,
  input reset,
  input signed [26:0] dt,
  input signed [26:0] init_x,
  input signed [26:0] init_y,
  input signed [26:0] init_z,
  input signed [26:0] beta,
  input signed [26:0] sigma,
  input signed [26:0] rho,
  output signed [26:0] x,
  output signed [26:0] y,
  output signed [26:0] z
);

  reg signed [26:0] x_reg, y_reg, z_reg;
  wire signed [26:0] x_calc, y_calc, z_calc;
  wire signed [26:0] x_inter, y_inter1, y_inter2, y_inter3;
  wire signed [26:0] z_inter1, z_inter2, x_mult_y, beta_mult_z;
  assign x = x_reg; 
  assign y = y_reg;
  assign z = z_reg;


  always @ (posedge clk) begin
    // If reset, initialize variables
    if (reset) begin
      x_reg <= init_x;
      y_reg <= init_y;
      z_reg <= init_z;
    // Else, add calculated accumulation (integrate)
    end else begin
      // x <= dx*dt + x;
      x_reg <= x_calc+x;
      // y <= dy*dt + y;
      y_reg <= y_calc+y;
      // z <= dz*dt + z;
      z_reg <= z_calc+z;
    end
  end

  // x_calc = dx*dt = sigma*(y-x)*dt 
  signed_mult x_mult_1 (
    .a(y-x),
    .b(dt),
    .out(x_inter)
  );
  signed_mult x_mult_2 (
    .a(x_inter),
    .b(sigma),
    .out(x_calc)
  );

  // y_calc = dy*dt = (x*(rho-z)-y)*dt
  signed_mult y_mult_1 (
    .a(x),
    .b(dt),
    .out(y_inter1)
  );
  signed_mult y_mult_2 (
    .a(y_inter1),
    .b(rho-z),
    .out(y_inter2)
  );
  signed_mult y_mult_3 (
    .a(y),
    .b(dt),
    .out(y_inter3)
  );
  assign y_calc = y_inter2 - y_inter3;

  // z_calc = dz*dt = (x*y-beta*z)*dt
  signed_mult z_mult_1 (
    .a(x),
    .b(dt),
    .out(z_inter1)
  );
  signed_mult z_mult_2 (
    .a(z_inter1),
    .b(y),
    .out(x_mult_y)
  );
  signed_mult z_mult_3 (
    .a(z),
    .b(dt),
    .out(z_inter2)
  );
  signed_mult z_mult_4 (
    .a(beta),
    .b(z_inter2),
    .out(beta_mult_z)
  );
  assign z_calc = x_mult_y - beta_mult_z;
endmodule

//============================================================
// Fixed-Point Multiplier
//============================================================
module signed_mult (out, a, b);
	output 	signed  [26:0]	out;
	input 	signed	[26:0] 	a;
	input 	signed	[26:0] 	b;
	// intermediate full bit length
	wire 	signed	[53:0]	mult_out;
	assign mult_out = a * b;
	// select bits for 7.20 fixed point
	assign out = {mult_out[53], mult_out[45:20]};
endmodule

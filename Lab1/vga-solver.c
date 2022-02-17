///////////////////////////////////////
/// 640x480 version! 16-bit color
/// This code will segfault the original
/// DE1 computer
/// compile with
/// gcc graphics_video_16bit.c -o gr -O2 -lm
///
///////////////////////////////////////
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <math.h>
#include <pthread.h>

// graphics primitives
void VGA_text(int, int, char *);
void VGA_text_clear();
void VGA_box(int, int, int, int, short);
void VGA_rect(int, int, int, int, short);
void VGA_line(int, int, int, int, short);

// 16-bit primary colors
#define red (0 + (0 << 5) + (31 << 11))
#define dark_red (0 + (0 << 5) + (15 << 11))
#define green (0 + (63 << 5) + (0 << 11))
#define dark_green (0 + (31 << 5) + (0 << 11))
#define blue (31 + (0 << 5) + (0 << 11))
#define dark_blue (15 + (0 << 5) + (0 << 11))
#define yellow (0 + (63 << 5) + (31 << 11))
#define cyan (31 + (63 << 5) + (0 << 11))
#define magenta (31 + (0 << 5) + (31 << 11))
#define black (0x0000)
#define gray (15 + (31 << 5) + (51 << 11))
#define white (0xffff)
int colors[] = {red, dark_red, green, dark_green, blue, dark_blue,
                yellow, cyan, magenta, gray, black, white};

// pixel macro
#define VGA_PIXEL(x, y, color)                                           \
  do                                                                     \
  {                                                                      \
    int *pixel_ptr;                                                      \
    pixel_ptr = (int *)((char *)vga_pixel_ptr + (((y)*640 + (x)) << 1)); \
    *(short *)pixel_ptr = (color);                                       \
  } while (0)

// video display
#define SDRAM_BASE 0xC0000000
#define SDRAM_END 0xC3FFFFFF
#define SDRAM_SPAN 0x04000000
// characters
#define FPGA_CHAR_BASE 0xC9000000
#define FPGA_CHAR_END 0xC9001FFF
#define FPGA_CHAR_SPAN 0x00002000
/* Cyclone V FPGA devices */
#define HW_REGS_BASE 0xff200000
//#define HW_REGS_SPAN        0x00200000
#define HW_REGS_SPAN 0x00005000

// the light weight bus base
void *h2p_lw_virtual_base;
// HPS_to_FPGA FIFO status address = 0
volatile unsigned int *lw_pio_ptr = NULL;
volatile unsigned int *lw_pio_read_ptr = NULL;
volatile signed int *lw_pio_read_x_ptr = NULL;
volatile signed int *lw_pio_read_y_ptr = NULL;
volatile signed int *lw_pio_read_z_ptr = NULL;
volatile signed int *lw_pio_init_x_ptr = NULL;
volatile signed int *lw_pio_init_y_ptr = NULL;
volatile signed int *lw_pio_init_z_ptr = NULL;
volatile signed int *lw_pio_sigma_ptr = NULL;
volatile signed int *lw_pio_beta_ptr = NULL;
volatile signed int *lw_pio_rho_ptr = NULL;
volatile signed int *lw_pio_dt_ptr = NULL;

// Eaxh PIO port has its own address offset
#define FPGA_PIO_LW_WRITE 0x00
#define FPGA_PIO_LW_READ 0x10
#define FPGA_PIO_READ_x 0x20
#define FPGA_PIO_READ_y 0x30
#define FPGA_PIO_READ_z 0x40
#define FPGA_PIO_INIT_x 0x50
#define FPGA_PIO_INIT_y 0x60
#define FPGA_PIO_INIT_z 0x70
#define FPGA_PIO_sigma 0x80
#define FPGA_PIO_beta 0x90
#define FPGA_PIO_rho 0xA0
#define FPGA_PIO_dt 0xB0

// pixel buffer
volatile unsigned int *vga_pixel_ptr = NULL;
void *vga_pixel_virtual_base;
// character buffer
volatile unsigned int *vga_char_ptr = NULL;
void *vga_char_virtual_base;

// /dev/mem file id
int fd;

// used for graphing curves using VGA_line()
signed int x_loc;
signed int y_loc;
signed int z_loc;
signed int prev_x_loc;
signed int prev_y_loc;
signed int prev_z_loc;

#define TRUE 1
#define FALSE 0

// input buffer for keyboard input
char input_buffer[64];
// control signals
volatile int restart_flag = 0;
volatile int reset_flag = 0;
volatile int time_interval = 3000;
volatile int pause_signal = 0;

// Printing labels and parameter values 
char text_top_row[40] = "DE1-SoC ARM/FPGA\0";
char text_next[40] = "Lab1 ODE Solver\0";
char sigma[40] = "sigma: 10.0";
char beta[40] = "beta: 2.667";
char rho[40] = "rho: 28.0";
char xz[40] = "XZ Projection";
char yz[40] = "YZ Projection";
char xy[40] = "XY Projection";
// Used to iterate through colors array
char color_index = 0;

// Converts float to fixed point number
int to_fixed(float f, int e)
{
  double a = f * pow(2, e);
  int b = (int)(round(a));
  if (a < 0)
  {
    // next three lines turns b into it's 2's complement.
    b = abs(b);
    b = ~b;
    b = b + 1;
  }
  return b;
}

/******** Display Thread *******/
void *display()
{
  // Convert floats to fixed point (7.20)  
  *lw_pio_init_x_ptr = to_fixed(-1.0, 20);
  *lw_pio_init_y_ptr = to_fixed(0.1, 20);
  *lw_pio_init_z_ptr = to_fixed(25.0, 20);
  *lw_pio_sigma_ptr = to_fixed(10.0, 20);
  *lw_pio_beta_ptr = to_fixed(8. / 3., 20);
  *lw_pio_rho_ptr = to_fixed(28.0, 20);
  *lw_pio_dt_ptr = to_fixed(1. / 256, 20);

  // Reset kernel
  *(lw_pio_ptr) = 3;
  *(lw_pio_ptr) = 2;
  *(lw_pio_ptr) = 1;
  *(lw_pio_ptr) = 0;

  // Update locations of current point and previous point (for graphing)
  x_loc = *(lw_pio_read_x_ptr);
  y_loc = *(lw_pio_read_y_ptr);
  z_loc = *(lw_pio_read_z_ptr);
  prev_x_loc = x_loc;
  prev_y_loc = y_loc;
  prev_z_loc = z_loc;

  while (1)
  {
    // If reset
    while (reset_flag == 1)
    {
      // clear screen and reset the kernel
      VGA_box(0, 0, 639, 479, 0x0000);
      color_index = 10;
      *(lw_pio_ptr) = 3;
      *(lw_pio_ptr) = 2;
      *(lw_pio_ptr) = 1;
      *(lw_pio_ptr) = 0;
      // If restart, clear screen and update the point locations
      if (restart_flag == 1)
      {
        VGA_box(0, 0, 639, 479, 0x0000);
        x_loc = *(lw_pio_read_x_ptr);
        y_loc = *(lw_pio_read_y_ptr);
        z_loc = *(lw_pio_read_z_ptr);
        prev_x_loc = x_loc;
        prev_y_loc = y_loc;
        prev_z_loc = z_loc;
        restart_flag = 0;
        reset_flag = 0;
        break;
      }
    }
    // If not reset or paused
    if ((reset_flag == 0) & (pause_signal == 0))
    {
      *(lw_pio_ptr) = 1;
      *(lw_pio_ptr) = 0;
      x_loc = *(lw_pio_read_x_ptr);
      y_loc = *(lw_pio_read_y_ptr);
      z_loc = *(lw_pio_read_z_ptr);

      // Go back to beginning of color array if at the end
      if (color_index++ == 11)
        color_index = 0;

      // Graph line between previous and current point, resize/scale within screen 
      VGA_line(160 + (int)(x_loc / 150000000.0 * 640), 100 + (int)(z_loc / 150000000.0 * 480), 160 + (int)(prev_x_loc / 150000000.0 * 640),
               100 + (int)(prev_z_loc / 150000000.0 * 480), colors[color_index]);
      VGA_line(480 + (int)(x_loc / 150000000.0 * 640), 150 + (int)(y_loc / 150000000.0 * 480), 480 + (int)(prev_x_loc / 150000000.0 * 640),
               150 + (int)(prev_y_loc / 150000000.0 * 480), colors[color_index]);
      VGA_line(320 + (int)(y_loc / 150000000.0 * 640), 275 + (int)(z_loc / 150000000.0 * 480), 320 + (int)(prev_y_loc / 150000000.0 * 640),
               275 + (int)(prev_z_loc / 150000000.0 * 480), colors[color_index]);
      // Update previous location with current location
      prev_x_loc = x_loc;
      prev_y_loc = y_loc;
      prev_z_loc = z_loc;
      
      // Delay (controls how fast we're sending clock signal to FPGA)
      usleep(time_interval);
    }

    // If paused, stay in while loop until unpaused 
    while (pause_signal == 1)
    {
      if (pause_signal == 0)
        break;
    }
  }
}

/******** Input Thread *******/
void *input()
{
  while (1)
  {
    // Display command and received value
    printf("Display Command: ");
    scanf("%s", input_buffer);
    printf("received value: %s\n", input_buffer);

    // "s" = slow (add 500 us to clock cycle time)
    if (strcmp(input_buffer, "s") == 0)
      time_interval = time_interval + 500;
    // "f" = slow (subtract 500 us to clock cycle time)
    else if (strcmp(input_buffer, "f") == 0)
      time_interval = time_interval - 500;
    // "p" = pause
    else if (strcmp(input_buffer, "p") == 0)
      pause_signal = 1;
    // "p" = unpause / resume
    else if (strcmp(input_buffer, "u") == 0)
      pause_signal = 0;
    // "p" = reset
    else if (strcmp(input_buffer, "r") == 0)
    {
      reset_flag = 1;
      restart_flag = 0;
      printf("Default Condition (y/n): ");
      scanf("%s", input_buffer);
      // Set to default initial values/parameters
      if (strcmp(input_buffer, "y") == 0)
      {
        *lw_pio_init_x_ptr = to_fixed(-1.0, 20);
        *lw_pio_init_y_ptr = to_fixed(0.1, 20);
        *lw_pio_init_z_ptr = to_fixed(25.0, 20);
        *lw_pio_sigma_ptr = to_fixed(10.0, 20);
        *lw_pio_beta_ptr = to_fixed(8. / 3., 20);
        *lw_pio_rho_ptr = to_fixed(28.0, 20);
        *lw_pio_dt_ptr = to_fixed(1. / 256, 20);
        restart_flag = 1;
      }
      // User inputs custom values for init positions, parameters, & dt
      else
      {
        printf("initial x position: ");
        scanf("%s", input_buffer);
        *lw_pio_init_x_ptr = to_fixed(strtof(input_buffer, NULL), 20);
        printf("initial y position: ");
        scanf("%s", input_buffer);
        *lw_pio_init_y_ptr = to_fixed(strtof(input_buffer, NULL), 20);
        printf("initial z position: ");
        scanf("%s", input_buffer);
        *lw_pio_init_z_ptr = to_fixed(strtof(input_buffer, NULL), 20);
        printf("sigma value: ");
        scanf("%s", input_buffer);
        sprintf(sigma, "sigma: %s", input_buffer);
        *lw_pio_sigma_ptr = to_fixed(strtof(input_buffer, NULL), 20);
        printf("beta value: ");
        scanf("%s", input_buffer);
        sprintf(beta, "beta: %s", input_buffer);
        *lw_pio_beta_ptr = to_fixed(strtof(input_buffer, NULL), 20);
        printf("rho value: ");
        scanf("%s", input_buffer);
        sprintf(rho, "rho: %s", input_buffer);
        *lw_pio_rho_ptr = to_fixed(strtof(input_buffer, NULL), 20);
        printf("time interval step: ");
        scanf("%s", input_buffer);
        *lw_pio_dt_ptr = to_fixed(strtof(input_buffer, NULL), 20);

        // Rewrite text with updated parameters
        VGA_text_clear();
        VGA_text(10, 1, text_top_row);
        VGA_text(10, 2, text_next);
        VGA_text(10, 3, sigma);
        VGA_text(10, 4, beta);
        VGA_text(10, 5, rho);
        VGA_text(15, 33, xz);
        VGA_text(50, 33, xy);
        VGA_text(30, 55, yz);
        restart_flag = 1;
      }
    }
  }
}

int main(void)
{
  // === need to mmap: =======================
  // FPGA_CHAR_BASE
  // FPGA_ONCHIP_BASE
  // HW_REGS_BASE

  // === get FPGA addresses ==================
  // Open /dev/mem
  if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1)
  {
    printf("ERROR: could not open \"/dev/mem\"...\n");
    return (1);
  }

  // Get virtual addr that maps to physical
  h2p_lw_virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);
  if (h2p_lw_virtual_base == MAP_FAILED)
  {
    printf("ERROR: mmap1() failed...\n");
    close(fd);
    return (1);
  }
  // Get the addresses that map to all the parallel ports on the light-weight bus
  lw_pio_ptr = (unsigned int *)(h2p_lw_virtual_base + FPGA_PIO_LW_WRITE);
  lw_pio_read_ptr = (unsigned int *)(h2p_lw_virtual_base + FPGA_PIO_LW_READ);
  lw_pio_read_x_ptr = (signed int *)(h2p_lw_virtual_base + FPGA_PIO_READ_x);
  lw_pio_read_y_ptr = (signed int *)(h2p_lw_virtual_base + FPGA_PIO_READ_y);
  lw_pio_read_z_ptr = (signed int *)(h2p_lw_virtual_base + FPGA_PIO_READ_z);
  lw_pio_init_x_ptr = (signed int *)(h2p_lw_virtual_base + FPGA_PIO_INIT_x);
  lw_pio_init_y_ptr = (signed int *)(h2p_lw_virtual_base + FPGA_PIO_INIT_y);
  lw_pio_init_z_ptr = (signed int *)(h2p_lw_virtual_base + FPGA_PIO_INIT_z);
  lw_pio_sigma_ptr = (signed int *)(h2p_lw_virtual_base + FPGA_PIO_sigma);
  lw_pio_beta_ptr = (signed int *)(h2p_lw_virtual_base + FPGA_PIO_beta);
  lw_pio_rho_ptr = (signed int *)(h2p_lw_virtual_base + FPGA_PIO_rho);
  lw_pio_dt_ptr = (signed int *)(h2p_lw_virtual_base + FPGA_PIO_dt);

  // === get VGA char addr =====================
  // get virtual addr that maps to physical
  vga_char_virtual_base = mmap(NULL, FPGA_CHAR_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, FPGA_CHAR_BASE);
  if (vga_char_virtual_base == MAP_FAILED)
  {
    printf("ERROR: mmap2() failed...\n");
    close(fd);
    return (1);
  }
  // Get the address that maps to the FPGA LED control
  vga_char_ptr = (unsigned int *)(vga_char_virtual_base);
  // === get VGA pixel addr ====================
  // get virtual addr that maps to physical
  vga_pixel_virtual_base = mmap(NULL, SDRAM_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, SDRAM_BASE);
  if (vga_pixel_virtual_base == MAP_FAILED)
  {
    printf("ERROR: mmap3() failed...\n");
    close(fd);
    return (1);
  }
  // Get the address that maps to the FPGA pixel buffer
  vga_pixel_ptr = (unsigned int *)(vga_pixel_virtual_base);

  // Clear the screen
  VGA_box(0, 0, 639, 479, 0x0000);
  // Clear the text
  VGA_text_clear();
  // Write text for title, parameters, and graph labels
  VGA_text(10, 1, text_top_row);
  VGA_text(10, 2, text_next);
  VGA_text(10, 3, sigma);
  VGA_text(10, 4, beta);
  VGA_text(10, 5, rho);
  VGA_text(15, 33, xz);
  VGA_text(50, 33, xy);
  VGA_text(30, 55, yz);

  // the thread identifiers
  pthread_t thread_display, thread_input;

  // For portability, explicitly create threads in a joinable state
  //  thread attribute used here to allow JOIN
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

  // now the threads
  pthread_create(&thread_display, NULL, display, NULL);
  pthread_create(&thread_input, NULL, input, NULL);

  pthread_join(thread_display, NULL);
  pthread_join(thread_input, NULL);
  return 0;
} // end main

/****************************************************************************************
 * Subroutine to send a string of text to the VGA monitor
 ****************************************************************************************/
void VGA_text(int x, int y, char *text_ptr)
{
  volatile char *character_buffer = (char *)vga_char_ptr; // VGA character buffer
  int offset;
  /* assume that the text string fits on one line */
  offset = (y << 7) + x;
  while (*(text_ptr))
  {
    // write to the character buffer
    *(character_buffer + offset) = *(text_ptr);
    ++text_ptr;
    ++offset;
  }
}

/****************************************************************************************
 * Subroutine to clear text to the VGA monitor
 ****************************************************************************************/
void VGA_text_clear()
{
  volatile char *character_buffer = (char *)vga_char_ptr; // VGA character buffer
  int offset, x, y;
  for (x = 0; x < 79; x++)
  {
    for (y = 0; y < 59; y++)
    {
      /* assume that the text string fits on one line */
      offset = (y << 7) + x;
      // write to the character buffer
      *(character_buffer + offset) = ' ';
    }
  }
}

/****************************************************************************************
 * Draw a filled rectangle on the VGA monitor
 ****************************************************************************************/
#define SWAP(X, Y) \
  do               \
  {                \
    int temp = X;  \
    X = Y;         \
    Y = temp;      \
  } while (0)

void VGA_box(int x1, int y1, int x2, int y2, short pixel_color)
{
  char *pixel_ptr;
  int row, col;

  /* check and fix box coordinates to be valid */
  if (x1 > 639)
    x1 = 639;
  if (y1 > 479)
    y1 = 479;
  if (x2 > 639)
    x2 = 639;
  if (y2 > 479)
    y2 = 479;
  if (x1 < 0)
    x1 = 0;
  if (y1 < 0)
    y1 = 0;
  if (x2 < 0)
    x2 = 0;
  if (y2 < 0)
    y2 = 0;
  if (x1 > x2)
    SWAP(x1, x2);
  if (y1 > y2)
    SWAP(y1, y2);
  for (row = y1; row <= y2; row++)
    for (col = x1; col <= x2; ++col)
    {
      VGA_PIXEL(col, row, pixel_color);
    }
}

/****************************************************************************************
 * Draw a outline rectangle on the VGA monitor
 ****************************************************************************************/
#define SWAP(X, Y) \
  do               \
  {                \
    int temp = X;  \
    X = Y;         \
    Y = temp;      \
  } while (0)

void VGA_rect(int x1, int y1, int x2, int y2, short pixel_color)
{
  char *pixel_ptr;
  int row, col;

  /* check and fix box coordinates to be valid */
  if (x1 > 639)
    x1 = 639;
  if (y1 > 479)
    y1 = 479;
  if (x2 > 639)
    x2 = 639;
  if (y2 > 479)
    y2 = 479;
  if (x1 < 0)
    x1 = 0;
  if (y1 < 0)
    y1 = 0;
  if (x2 < 0)
    x2 = 0;
  if (y2 < 0)
    y2 = 0;
  if (x1 > x2)
    SWAP(x1, x2);
  if (y1 > y2)
    SWAP(y1, y2);
  // left edge
  col = x1;
  for (row = y1; row <= y2; row++)
  {
    VGA_PIXEL(col, row, pixel_color);
  }

  // right edge
  col = x2;
  for (row = y1; row <= y2; row++)
  {
    VGA_PIXEL(col, row, pixel_color);
  }

  // top edge
  row = y1;
  for (col = x1; col <= x2; ++col)
  {
    VGA_PIXEL(col, row, pixel_color);
  }

  // bottom edge
  row = y2;
  for (col = x1; col <= x2; ++col)
  {
    VGA_PIXEL(col, row, pixel_color);
  }
}

// =============================================
// === Draw a line
// =============================================
// plot a line
// at x1,y1 to x2,y2 with color
// Code is from David Rodgers,
//"Procedural Elements of Computer Graphics",1985
void VGA_line(int x1, int y1, int x2, int y2, short c)
{
  int e;
  signed int dx, dy, j, temp;
  signed int s1, s2, xchange;
  signed int x, y;
  char *pixel_ptr;

  /* check and fix line coordinates to be valid */
  if (x1 > 639)
    x1 = 639;
  if (y1 > 479)
    y1 = 479;
  if (x2 > 639)
    x2 = 639;
  if (y2 > 479)
    y2 = 479;
  if (x1 < 0)
    x1 = 0;
  if (y1 < 0)
    y1 = 0;
  if (x2 < 0)
    x2 = 0;
  if (y2 < 0)
    y2 = 0;

  x = x1;
  y = y1;

  // take absolute value
  if (x2 < x1)
  {
    dx = x1 - x2;
    s1 = -1;
  }

  else if (x2 == x1)
  {
    dx = 0;
    s1 = 0;
  }

  else
  {
    dx = x2 - x1;
    s1 = 1;
  }

  if (y2 < y1)
  {
    dy = y1 - y2;
    s2 = -1;
  }

  else if (y2 == y1)
  {
    dy = 0;
    s2 = 0;
  }

  else
  {
    dy = y2 - y1;
    s2 = 1;
  }

  xchange = 0;

  if (dy > dx)
  {
    temp = dx;
    dx = dy;
    dy = temp;
    xchange = 1;
  }

  e = ((int)dy << 1) - dx;

  for (j = 0; j <= dx; j++)
  {
    VGA_PIXEL(x, y, c);

    if (e >= 0)
    {
      if (xchange == 1)
        x = x + s1;
      else
        y = y + s2;
      e = e - ((int)dx << 1);
    }

    if (xchange == 1)
      y = y + s2;
    else
      x = x + s1;

    e = e + ((int)dy << 1);
  }
}
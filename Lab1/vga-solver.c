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
//#include "address_map_arm_brl4.h"

// graphics primitives
void VGA_text(int, int, char *);
void VGA_text_clear();
void VGA_box(int, int, int, int, short);
void VGA_rect(int, int, int, int, short);
void VGA_line(int, int, int, int, short);
void VGA_Vline(int, int, int, short);
void VGA_Hline(int, int, int, short);
void VGA_disc(int, int, int, short);
void VGA_circle(int, int, int, int);
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

// the light weight buss base
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

// read offset is 0x10 for both busses
// remember that eaxh axi master bus needs unique address
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

signed int x_loc;
signed int y_loc;
signed int z_loc;
signed int prev_x_loc;
signed int prev_y_loc;
signed int prev_z_loc;

#define TRUE 1
#define FALSE 0

char input_buffer[64];
// access to enter condition
// -- for signalling enter done
pthread_mutex_t display_lock = PTHREAD_MUTEX_INITIALIZER;
// access to print condition
// -- for signalling print done
pthread_mutex_t input_lock = PTHREAD_MUTEX_INITIALIZER;
// the two condition variables related to the mutex above
pthread_cond_t display_cond;
pthread_cond_t input_cond;
// control signals
volatile int restart_flag = 0;
volatile int reset_flag = 0;
volatile int time_interval = 3000;
volatile int pause_signal = 0;

/* create a message to be displayed on the VGA
        and LCD displays */
char text_top_row[40] = "DE1-SoC ARM/FPGA\0";
// char text_bottom_row[40] = "Cornell ece5760\0";
char text_next[40] = "Lab1 ODE Solver\0";
char sigma[40] = "sigma: 10.0";
char beta[40] = "beta: 2.667";
char rho[40] = "rho: 28.0";
char xz[40] = "XZ Projection";
char yz[40] = "YZ Projection";
char xy[40] = "XY Projection";
char color_index = 0;
int color_counter = 0;

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

void *display()
{
  // reset the kernel
  // *(lw_pio_ptr) = 3;
  // *(lw_pio_ptr) = 2;
  // *(lw_pio_ptr) = 1;
  // *(lw_pio_ptr) = 0;

  // *(lw_pio_ptr) = 1;
  // *(lw_pio_ptr) = 0;
  // *(lw_pio_ptr) = 1;
  // *(lw_pio_ptr) = 0;

  // signed int x_loc = *(lw_pio_read_x_ptr);
  // signed int y_loc = *(lw_pio_read_y_ptr);
  // signed int z_loc = *(lw_pio_read_z_ptr);
  // signed int prev_x_loc, prev_y_loc, prev_z_loc;

  // *(lw_pio_ptr) = 1;
  // *(lw_pio_ptr) = 0;
  // prev_x_loc = x_loc;
  // prev_y_loc = y_loc;
  // prev_z_loc = z_loc;

  // ---------------
  *lw_pio_init_x_ptr = to_fixed(-1.0, 20);
  *lw_pio_init_y_ptr = to_fixed(0.1, 20);
  *lw_pio_init_z_ptr = to_fixed(25.0, 20);
  *lw_pio_sigma_ptr = to_fixed(10.0, 20);
  *lw_pio_beta_ptr = to_fixed(8. / 3., 20);
  *lw_pio_rho_ptr = to_fixed(28.0, 20);
  *lw_pio_dt_ptr = to_fixed(1. / 256, 20);

  *(lw_pio_ptr) = 3;
  *(lw_pio_ptr) = 2;
  *(lw_pio_ptr) = 1;
  *(lw_pio_ptr) = 0;

  x_loc = *(lw_pio_read_x_ptr);
  y_loc = *(lw_pio_read_y_ptr);
  z_loc = *(lw_pio_read_z_ptr);
  prev_x_loc = x_loc;
  prev_y_loc = y_loc;
  prev_z_loc = z_loc;

  // printf("display thread before cv\n");
  // sleep(1);
  // pthread_cond_signal(&input_cond);

  while (1)
  {

    // // wait for input done
    // pthread_mutex_lock(&display_lock);
    // printf("here1\n");
    // pthread_cond_wait(&display_cond, &display_lock);
    // printf("here2\n");

    while (reset_flag == 1)
    {
      // reset the kernel
      VGA_box(0, 0, 639, 479, 0x0000);
      color_index = 10;
      *(lw_pio_ptr) = 3;
      *(lw_pio_ptr) = 2;
      *(lw_pio_ptr) = 1;
      *(lw_pio_ptr) = 0;
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

    if ((reset_flag == 0) & (pause_signal == 0))
    {
      *(lw_pio_ptr) = 1;
      *(lw_pio_ptr) = 0;
      x_loc = *(lw_pio_read_x_ptr);
      y_loc = *(lw_pio_read_y_ptr);
      z_loc = *(lw_pio_read_z_ptr);

      if (color_index++ == 11)
        color_index = 0;

      VGA_line(160 + (int)(x_loc / 150000000.0 * 640), 100 + (int)(z_loc / 150000000.0 * 480), 160 + (int)(prev_x_loc / 150000000.0 * 640),
               100 + (int)(prev_z_loc / 150000000.0 * 480), colors[color_index]);
      VGA_line(480 + (int)(x_loc / 150000000.0 * 640), 150 + (int)(y_loc / 150000000.0 * 480), 480 + (int)(prev_x_loc / 150000000.0 * 640),
               150 + (int)(prev_y_loc / 150000000.0 * 480), colors[color_index]);
      VGA_line(320 + (int)(y_loc / 150000000.0 * 640), 275 + (int)(z_loc / 150000000.0 * 480), 320 + (int)(prev_y_loc / 150000000.0 * 640),
               275 + (int)(prev_z_loc / 150000000.0 * 480), colors[color_index]);
      prev_x_loc = x_loc;
      prev_y_loc = y_loc;
      prev_z_loc = z_loc;
      // printf("display thread before mutex unlock\n");
      // // unlock the input_buffer
      // pthread_mutex_unlock(&display_lock);
      // printf("display thread after mutex unlock\n");
      // // and tell read1 thread that print is done
      // pthread_cond_signal(&input_cond);
      // printf("display thread after cv\n");

      usleep(time_interval);
    }

    while (pause_signal == 1)
    {
      if (pause_signal == 0)
        break;
    }
  }
}

void *input()
{
  while (1)
  {
    // // wait for print done
    // pthread_mutex_lock(&input_lock);
    // printf("here3\n");
    // pthread_cond_wait(&input_cond, &input_lock);
    // printf("here4\n");
    // the actual enter
    printf("Display Command: ");
    scanf("%s", input_buffer);
    printf("received value: %s\n", input_buffer);

    if (strcmp(input_buffer, "s") == 0)
      time_interval = time_interval + 500;
    else if (strcmp(input_buffer, "f") == 0)
      time_interval = time_interval - 500;
    else if (strcmp(input_buffer, "p") == 0)
      pause_signal = 1;
    else if (strcmp(input_buffer, "u") == 0)
      pause_signal = 0;
    else if (strcmp(input_buffer, "r") == 0)
    {
      reset_flag = 1;
      restart_flag = 0;
      printf("Default Condition (y/n): ");
      scanf("%s", input_buffer);
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

        VGA_text_clear();
        // write text
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
    // printf("input thread before mutex unlock\n");
    // // unlock the input_buffer
    // pthread_mutex_unlock(&input_lock);
    // printf("input thread after mutex unlock\n");
    // // and tell write1 thread that enter is complete
    // pthread_cond_signal(&display_cond);
    // printf("input thread after cv\n");
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

  // get virtual addr that maps to physical
  h2p_lw_virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);
  if (h2p_lw_virtual_base == MAP_FAILED)
  {
    printf("ERROR: mmap1() failed...\n");
    close(fd);
    return (1);
  }
  // Get the addresses that map to the two parallel ports on the light-weight bus
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

  //  clear the screen
  VGA_box(0, 0, 639, 479, 0x0000);
  // clear the text
  VGA_text_clear();
  // write text
  VGA_text(10, 1, text_top_row);
  // VGA_text(10, 2, text_bottom_row);
  VGA_text(10, 2, text_next);
  VGA_text(10, 3, sigma);
  VGA_text(10, 4, beta);
  VGA_text(10, 5, rho);
  VGA_text(15, 33, xz);
  VGA_text(50, 33, xy);
  VGA_text(30, 55, yz);

  int status;
  // the thread identifiers
  pthread_t thread_display, thread_input;

  // the condition variables
  pthread_cond_init(&display_cond, NULL);
  pthread_cond_init(&input_cond, NULL);

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
      // 640x480
      // pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
      //  set pixel color
      //*(char *)pixel_ptr = pixel_color;
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
    // 640x480
    // pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
    //  set pixel color
    //*(char *)pixel_ptr = pixel_color;
    VGA_PIXEL(col, row, pixel_color);
  }

  // right edge
  col = x2;
  for (row = y1; row <= y2; row++)
  {
    // 640x480
    // pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
    //  set pixel color
    //*(char *)pixel_ptr = pixel_color;
    VGA_PIXEL(col, row, pixel_color);
  }

  // top edge
  row = y1;
  for (col = x1; col <= x2; ++col)
  {
    // 640x480
    // pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
    //  set pixel color
    //*(char *)pixel_ptr = pixel_color;
    VGA_PIXEL(col, row, pixel_color);
  }

  // bottom edge
  row = y2;
  for (col = x1; col <= x2; ++col)
  {
    // 640x480
    // pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
    //  set pixel color
    //*(char *)pixel_ptr = pixel_color;
    VGA_PIXEL(col, row, pixel_color);
  }
}

/****************************************************************************************
 * Draw a horixontal line on the VGA monitor
 ****************************************************************************************/
#define SWAP(X, Y) \
  do               \
  {                \
    int temp = X;  \
    X = Y;         \
    Y = temp;      \
  } while (0)

void VGA_Hline(int x1, int y1, int x2, short pixel_color)
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
  if (x1 < 0)
    x1 = 0;
  if (y1 < 0)
    y1 = 0;
  if (x2 < 0)
    x2 = 0;
  if (x1 > x2)
    SWAP(x1, x2);
  // line
  row = y1;
  for (col = x1; col <= x2; ++col)
  {
    // 640x480
    // pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
    //  set pixel color
    //*(char *)pixel_ptr = pixel_color;
    VGA_PIXEL(col, row, pixel_color);
  }
}

/****************************************************************************************
 * Draw a vertical line on the VGA monitor
 ****************************************************************************************/
#define SWAP(X, Y) \
  do               \
  {                \
    int temp = X;  \
    X = Y;         \
    Y = temp;      \
  } while (0)

void VGA_Vline(int x1, int y1, int y2, short pixel_color)
{
  char *pixel_ptr;
  int row, col;

  /* check and fix box coordinates to be valid */
  if (x1 > 639)
    x1 = 639;
  if (y1 > 479)
    y1 = 479;
  if (y2 > 479)
    y2 = 479;
  if (x1 < 0)
    x1 = 0;
  if (y1 < 0)
    y1 = 0;
  if (y2 < 0)
    y2 = 0;
  if (y1 > y2)
    SWAP(y1, y2);
  // line
  col = x1;
  for (row = y1; row <= y2; row++)
  {
    // 640x480
    // pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
    //  set pixel color
    //*(char *)pixel_ptr = pixel_color;
    VGA_PIXEL(col, row, pixel_color);
  }
}

/****************************************************************************************
 * Draw a filled circle on the VGA monitor
 ****************************************************************************************/

void VGA_disc(int x, int y, int r, short pixel_color)
{
  char *pixel_ptr;
  int row, col, rsqr, xc, yc;

  rsqr = r * r;

  for (yc = -r; yc <= r; yc++)
    for (xc = -r; xc <= r; xc++)
    {
      col = xc;
      row = yc;
      // add the r to make the edge smoother
      if (col * col + row * row <= rsqr + r)
      {
        col += x; // add the center point
        row += y; // add the center point
        // check for valid 640x480
        if (col > 639)
          col = 639;
        if (row > 479)
          row = 479;
        if (col < 0)
          col = 0;
        if (row < 0)
          row = 0;
        // pixel_ptr = (char *)vga_pixel_ptr + (row<<10) + col ;
        //  set pixel color
        //*(char *)pixel_ptr = pixel_color;
        VGA_PIXEL(col, row, pixel_color);
      }
    }
}

/****************************************************************************************
 * Draw a  circle on the VGA monitor
 ****************************************************************************************/

void VGA_circle(int x, int y, int r, int pixel_color)
{
  char *pixel_ptr;
  int row, col, rsqr, xc, yc;
  int col1, row1;
  rsqr = r * r;

  for (yc = -r; yc <= r; yc++)
  {
    // row = yc;
    col1 = (int)sqrt((float)(rsqr + r - yc * yc));
    // right edge
    col = col1 + x; // add the center point
    row = yc + y;   // add the center point
    // check for valid 640x480
    if (col > 639)
      col = 639;
    if (row > 479)
      row = 479;
    if (col < 0)
      col = 0;
    if (row < 0)
      row = 0;
    // pixel_ptr = (char *)vga_pixel_ptr + (row<<10) + col ;
    //  set pixel color
    //*(char *)pixel_ptr = pixel_color;
    VGA_PIXEL(col, row, pixel_color);
    // left edge
    col = -col1 + x; // add the center point
    // check for valid 640x480
    if (col > 639)
      col = 639;
    if (row > 479)
      row = 479;
    if (col < 0)
      col = 0;
    if (row < 0)
      row = 0;
    // pixel_ptr = (char *)vga_pixel_ptr + (row<<10) + col ;
    //  set pixel color
    //*(char *)pixel_ptr = pixel_color;
    VGA_PIXEL(col, row, pixel_color);
  }
  for (xc = -r; xc <= r; xc++)
  {
    // row = yc;
    row1 = (int)sqrt((float)(rsqr + r - xc * xc));
    // right edge
    col = xc + x;   // add the center point
    row = row1 + y; // add the center point
    // check for valid 640x480
    if (col > 639)
      col = 639;
    if (row > 479)
      row = 479;
    if (col < 0)
      col = 0;
    if (row < 0)
      row = 0;
    // pixel_ptr = (char *)vga_pixel_ptr + (row<<10) + col ;
    //  set pixel color
    //*(char *)pixel_ptr = pixel_color;
    VGA_PIXEL(col, row, pixel_color);
    // left edge
    row = -row1 + y; // add the center point
    // check for valid 640x480
    if (col > 639)
      col = 639;
    if (row > 479)
      row = 479;
    if (col < 0)
      col = 0;
    if (row < 0)
      row = 0;
    // pixel_ptr = (char *)vga_pixel_ptr + (row<<10) + col ;
    //  set pixel color
    //*(char *)pixel_ptr = pixel_color;
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
    // video_pt(x,y,c); //640x480
    // pixel_ptr = (char *)vga_pixel_ptr + (y<<10)+ x;
    //  set pixel color
    //*(char *)pixel_ptr = c;
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
///////////////////////////////////////
/// 640x480 version!
/// test VGA with hardware video input copy to VGA
// compile with
// gcc pio_test_1.c -o pio
///////////////////////////////////////
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <math.h>

// Main bus; PIO
#define FPGA_AXI_BASE 0xC0000000
#define FPGA_AXI_SPAN 0x00001000
// Main axi bus base
void *h2p_virtual_base;
// Initialize addresses for parameters
volatile signed int *h2p_init_x = NULL;
volatile signed int *h2p_init_y = NULL;
volatile signed int *h2p_x_partition_incr = NULL;
volatile signed int *h2p_y_partition_incr = NULL;
volatile signed int *h2p_x_incr = NULL;
volatile signed int *h2p_y_incr = NULL;
volatile signed int *h2p_x_limit = NULL;
volatile signed int *h2p_y_limit = NULL;
volatile signed int *h2p_external_reset = NULL;
volatile signed int *h2p_cycle_count = NULL;
volatile signed int *h2p_MAX_ITERATION = NULL;

// LW bus; PIO
#define FPGA_LW_BASE 0xff200000
#define FPGA_LW_SPAN 0x00001000
// The light weight bus base
void *h2p_lw_virtual_base;

// Read offsets for each parameter (matches QSys configuration)
#define INIT_X_OFFSET 0x00
#define INIT_Y_OFFSET 0x10
#define X_PARTITION_INCR_OFFSET 0x20
#define Y_PARTITION_INCR_OFFSET 0x30
#define X_INCR_OFFSET 0x40
#define Y_INCR_OFFSET 0x50
#define X_LIMIT_OFFSET 0x60
#define Y_LIMIT_OFFSET 0x70
#define EXTERNAL_RESET_OFFSET 0x80
#define CYCLE_COUNT_OFFSET 0x90
#define MAX_ITERATION_OFFSET 0xA0

// /dev/mem file id
int fd;

// Helper function - converts float to fixed point number
int to_fixed(float f, int e)
{
  double a = f * pow(2, e);
  int b = (int)(round(a));
  if (a < 0)
  {
    // Next three lines turns b into it's 2's complement.
    b = abs(b);
    b = ~b;
    b = b + 1;
  }
  return b;
}

#define ROW_SIZE 640
#define COL_SIZE 480

////////////////////////
// Main function
////////////////////////
int main(void)
{

  // === get FPGA addresses ==================
  // Open /dev/mem
  if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1)
  {
    printf("ERROR: could not open \"/dev/mem\"...\n");
    return (1);
  }
  // Get virtual addr that maps to physical for light weight AXI bus
  h2p_lw_virtual_base = mmap(NULL, FPGA_LW_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, FPGA_LW_BASE);
  if (h2p_lw_virtual_base == MAP_FAILED)
  {
    printf("ERROR: mmap1() failed...\n");
    close(fd);
    return (1);
  }
  // Get virtual address for AXI bus addr
  h2p_virtual_base = mmap(NULL, FPGA_AXI_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, FPGA_AXI_BASE);
  if (h2p_virtual_base == MAP_FAILED)
  {
    printf("ERROR: mmap3() failed...\n");
    close(fd);
    return (1);
  }
  // Get the addresses for parameter PIO ports (main axi bus base + the offsets initialized above)
  h2p_init_x = (signed int *)(h2p_virtual_base + INIT_X_OFFSET);
  h2p_init_y = (signed int *)(h2p_virtual_base + INIT_Y_OFFSET);
  h2p_x_partition_incr = (signed int *)(h2p_virtual_base + X_PARTITION_INCR_OFFSET);
  h2p_y_partition_incr = (signed int *)(h2p_virtual_base + Y_PARTITION_INCR_OFFSET);
  h2p_x_incr = (signed int *)(h2p_virtual_base + X_INCR_OFFSET);
  h2p_y_incr = (signed int *)(h2p_virtual_base + Y_INCR_OFFSET);
  h2p_x_limit = (signed int *)(h2p_virtual_base + X_LIMIT_OFFSET);
  h2p_y_limit = (signed int *)(h2p_virtual_base + Y_LIMIT_OFFSET);
  h2p_external_reset = (signed int *)(h2p_virtual_base + EXTERNAL_RESET_OFFSET);
  h2p_cycle_count = (signed int *)(h2p_virtual_base + CYCLE_COUNT_OFFSET);
  h2p_MAX_ITERATION = (signed int *)(h2p_virtual_base + MAX_ITERATION_OFFSET);

  // ============================================

  // Input buffer
  char input_buffer[64];

  int partition = 40;
  int partition_row_size = ROW_SIZE / partition;
  int partition_col_size = COL_SIZE;
  float init_x = -2.0;
  float init_y = -1.0;
  float range_x = 3.0;
  float range_y = 2.0;
  float limit_x = 1.0;
  float limit_y = 1.0;
  float x_incr = range_x / partition_row_size;
  float y_incr = range_y / partition_col_size;
  float x_partition_incr = x_incr / partition;
  float y_partition_incr = 0;
  int reset_signal = 0;
  int max_iteration = 1000;

  *h2p_init_x = to_fixed(init_x, 23);
  *h2p_init_y = to_fixed(init_y, 23);
  *h2p_x_partition_incr = to_fixed(x_partition_incr, 23);
  *h2p_y_partition_incr = to_fixed(y_partition_incr, 23);
  *h2p_x_incr = to_fixed(x_incr, 23);
  *h2p_y_incr = to_fixed(y_incr, 23);
  *h2p_x_limit = to_fixed(limit_x, 23);
  *h2p_y_limit = to_fixed(limit_y, 23);
  *h2p_MAX_ITERATION = 1000;

  while (1)
  {
    // Display command and received value
    printf("Display Command: ");
    scanf("%s", input_buffer);
    printf("received value: %s\n", input_buffer);

    if (strcmp(input_buffer, "r") == 0)
    {
      partition_row_size = ROW_SIZE / partition;
      partition_col_size = COL_SIZE;
      init_x = -2.0;
      init_y = -1.0;
      range_x = 3.0;
      range_y = 2.0;
      limit_x = 1.0;
      limit_y = 1.0;
      x_incr = range_x / partition_row_size;
      y_incr = range_y / partition_col_size;
      x_partition_incr = x_incr / partition;
      y_partition_incr = 0;
      max_iteration = 1000;
      printf("%d, %d, %f, %f, %f\n", partition_row_size, partition_col_size, x_incr, y_incr, x_partition_incr);
      reset_signal = 1;
    }
    // "a" = left
    else if (strcmp(input_buffer, "a") == 0)
    {
      init_x -= range_x / 6;
      limit_x = init_x + range_x;
      reset_signal = 1;
    }
    // "d" = right
    else if (strcmp(input_buffer, "d") == 0)
    {
      init_x += range_x / 6;
      limit_x = init_x + range_x;
      reset_signal = 1;
    }
    // "w" = up
    else if (strcmp(input_buffer, "w") == 0)
    {
      init_y -= range_y / 6;
      limit_y = init_y + range_y;
      reset_signal = 1;
    }
    // "s" = down
    else if (strcmp(input_buffer, "s") == 0)
    {
      init_y += range_y / 6;
      limit_y = init_y + range_y;
      reset_signal = 1;
    }
    // "i" = zoom in
    else if (strcmp(input_buffer, "i") == 0)
    {
      range_x -= range_x / 4;
      range_y -= range_y / 4;
      x_incr = range_x / partition_row_size;
      y_incr = range_y / partition_col_size;
      x_partition_incr = x_incr / partition;
      y_partition_incr = 0;
      float middle_x = (init_x + limit_x) / 2;
      float middle_y = (init_y + limit_y) / 2;
      init_x = middle_x - range_x / 2;
      init_y = middle_y - range_y / 2;
      limit_x = middle_x + range_x / 2;
      limit_y = middle_y + range_y / 2;
      reset_signal = 1;
    }
    // "o" = zoom out
    else if (strcmp(input_buffer, "o") == 0)
    {
      range_x += range_x / 4;
      range_y += range_y / 4;
      x_incr = range_x / partition_row_size;
      y_incr = range_y / partition_col_size;
      x_partition_incr = x_incr / partition;
      y_partition_incr = 0;
      float middle_x = (init_x + limit_x) / 2;
      float middle_y = (init_y + limit_y) / 2;
      init_x = middle_x - range_x / 2;
      init_y = middle_y - range_y / 2;
      limit_x = middle_x + range_x / 2;
      limit_y = middle_y + range_y / 2;
      // TODO: change others
      reset_signal = 1;
    }
    // "m" = max iteration
    else if (strcmp(input_buffer, "m") == 0)
    {
      printf("max iteration input: ");
      scanf("%s", input_buffer);
      max_iteration = atoi(input_buffer);
      // printf("received max iteration value: %s, %d\n", input_buffer, max_iteration);
      reset_signal = 1;
    }
    // "p" = performance
    else if (strcmp(input_buffer, "p") == 0)
    {
      int cycle_count = *h2p_cycle_count;
      float compute_time = cycle_count / 50000.0; // unit: ms
      printf("x boundary: [%f, %f]\n", init_x, limit_x);
      printf("y boundary: [%f, %f]\n", init_y, limit_y);
      printf("calculation range: x: %f, y: %f\n", range_x, range_y);
      printf("max iteration: %d\n", max_iteration);
      printf("cycle count: %d\n", cycle_count);
      printf("computation time: %f ms\n", compute_time);
    }
    if (reset_signal == 1)
    {
      *h2p_init_x = to_fixed(init_x, 23);
      *h2p_init_y = to_fixed(init_y, 23);
      *h2p_x_partition_incr = to_fixed(x_partition_incr, 23);
      *h2p_y_partition_incr = to_fixed(y_partition_incr, 23);
      *h2p_x_incr = to_fixed(x_incr, 23);
      *h2p_y_incr = to_fixed(y_incr, 23);
      *h2p_x_limit = to_fixed(limit_x, 23);
      *h2p_y_limit = to_fixed(limit_y, 23);
      *h2p_MAX_ITERATION = max_iteration;
      *h2p_external_reset = 1;
      *h2p_external_reset = 0;
      reset_signal = 0;
    }
  } // end while(1)
} // end main
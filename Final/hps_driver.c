///////////////////////////////////////
/// 640x480 version! 16-bit color
/// This code will segfault the original
/// DE1 computer
/// compile with
/// gcc graphics_video_16bit.c -o gr -O2 -lm
///
///////////////////////////////////////
#include <fcntl.h>
#include <math.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/mman.h>
#include <sys/shm.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

// // graphics primitives
// void VGA_text(int, int, char *);
// void VGA_text_clear();
// void VGA_box(int, int, int, int, short);
// void VGA_rect(int, int, int, int, short);
// void VGA_line(int, int, int, int, short);

// // 16-bit primary colors
// #define red (0 + (0 << 5) + (31 << 11))
// #define dark_red (0 + (0 << 5) + (15 << 11))
// #define green (0 + (63 << 5) + (0 << 11))
// #define dark_green (0 + (31 << 5) + (0 << 11))
// #define blue (31 + (0 << 5) + (0 << 11))
// #define dark_blue (15 + (0 << 5) + (0 << 11))
// #define yellow (0 + (63 << 5) + (31 << 11))
// #define cyan (31 + (63 << 5) + (0 << 11))
// #define magenta (31 + (0 << 5) + (31 << 11))
// #define black (0x0000)
// #define gray (15 + (31 << 5) + (51 << 11))
// #define white (0xffff)
// int colors[] = {red, dark_red, green, dark_green, blue, dark_blue,
//                 yellow, cyan, magenta, gray, black, white};

// // pixel macro
// #define VGA_PIXEL(x, y, color)                                           \
//   do {                                                                   \
//     int *pixel_ptr;                                                      \
//     pixel_ptr = (int *)((char *)vga_pixel_ptr + (((y)*640 + (x)) << 1)); \
//     *(short *)pixel_ptr = (color);                                       \
//   } while (0)

// // pixel buffer
// volatile unsigned int *vga_pixel_ptr = NULL;
// void *vga_pixel_virtual_base;
// // character buffer
// volatile unsigned int *vga_char_ptr = NULL;
// void *vga_char_virtual_base;

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
volatile unsigned int *hps_out_init_rotor_position_ptr = NULL;
volatile unsigned int *hps_out_rotor_turnover_ptr = NULL;
volatile unsigned int *hps_out_msg_input_lo = NULL;
volatile unsigned int *hps_out_msg_input_hi = NULL;
volatile unsigned int *hps_out_msg_output_lo = NULL;
volatile unsigned int *hps_out_msg_output_hi = NULL;
volatile unsigned int *hps_out_msg_position_lo = NULL;
volatile unsigned int *hps_out_msg_position_hi = NULL;
volatile unsigned int *hps_in_msg_mapping_lo = NULL;
volatile unsigned int *hps_in_msg_mapping_hi = NULL;
volatile unsigned int *hps_in_ctrl_signals = NULL;
volatile unsigned int *hps_out_reset = NULL;

// Eaxh PIO port has its own address offset
#define HPS_OUT_INIT_ROTOR_POSITION 0x00
#define HPS_OUT_ROTOR_TURNOVER 0x10
#define HPS_OUT_MSG_INPUT_LO 0x20
#define HPS_OUT_MSG_INPUT_HI 0x30
#define HPS_OUT_MSG_OUTPUT_LO 0x40
#define HPS_OUT_MSG_OUTPUT_HI 0x50
#define HPS_OUT_MSG_POSITION_LO 0x60
#define HPS_OUT_MSG_POSITION_HI 0x70
#define HPS_IN_MSG_MAPPING_LO 0x80
#define HPS_IN_MSG_MAPPING_HI 0x90
#define HPS_IN_CTRL_SIGNALS 0xA0
#define HPS_OUT_RESET 0xB0

// /dev/mem file id
int fd;

// input buffer for keyboard input
char input_buffer[64];

int init_rotor_position, rotor_turnover;
int msg_input_lo, msg_input_hi;
int msg_output_lo, msg_output_hi;
int msg_position_lo, msg_position_hi;
int reset;
int msg_mapping_lo, msg_mapping_hi, ctrl_signals;

char *itoa(int val, int base) {
  static char buf[32] = {0};
  int i = 30;
  for (; val && i; --i, val /= base)
    buf[i] = "0123456789abcdef"[val % base];
  return &buf[i + 1];
}

void print2(int value) {
  char *buffer;
  buffer = itoa(value, 2);
  printf("binary: %s\n", buffer);
}

int set_init_rotor_position(char position0, char position1, char position2) {
  int return_msg = 0;
  return_msg = return_msg | ((position2 - 'A') & 0x001F) << 10;
  return_msg = return_msg | ((position1 - 'A') & 0x001F) << 5;
  return_msg = return_msg | ((position0 - 'A') & 0x001F);
  return return_msg;
}
int set_rotor_turnover(char position0, char position1, char position2) {
  int return_msg = 0;
  return_msg = return_msg | ((position2 - 'A') & 0x001F) << 10;
  return_msg = return_msg | ((position1 - 'A') & 0x001F) << 5;
  return_msg = return_msg | ((position0 - 'A') & 0x001F);
  return return_msg;
}
int set_msg_6(char *msg) {
  unsigned int return_msg = 0;
  int i;
  for (i = 0; i < 6; i++) {
    return_msg = return_msg | ((msg[i] - 'A') & 0x001F) << (5 * i);
  }
  return return_msg;
}
int set_position_6(int *position) {
  unsigned int return_msg = 0;
  int i;
  for (i = 0; i < 6; i++) {
    return_msg = return_msg | (position[i] & 0x001F) << (5 * i);
  }
  return return_msg;
}
void read_msg_6(int msg, char *return_char) {
  int i;
  for (i = 0; i < 6; i++) {
    return_char[i] = (msg & 0x001F) + 'A';
    msg = msg >> 5;
  }
}

int main(void) {

  // === get FPGA addresses ==================
  // Open /dev/mem
  if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1) {
    printf("ERROR: could not open \"/dev/mem\"...\n");
    return (1);
  }

  // Get virtual addr that maps to physical
  h2p_lw_virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);
  if (h2p_lw_virtual_base == MAP_FAILED) {
    printf("ERROR: mmap1() failed...\n");
    close(fd);
    return (1);
  }

  // Get the addresses that map to all the parallel ports on the light-weight bus
  hps_out_init_rotor_position_ptr = (unsigned int *)(h2p_lw_virtual_base + HPS_OUT_INIT_ROTOR_POSITION);
  hps_out_rotor_turnover_ptr = (unsigned int *)(h2p_lw_virtual_base + HPS_OUT_ROTOR_TURNOVER);
  hps_out_msg_input_lo = (unsigned int *)(h2p_lw_virtual_base + HPS_OUT_MSG_INPUT_LO);
  hps_out_msg_input_hi = (unsigned int *)(h2p_lw_virtual_base + HPS_OUT_MSG_INPUT_HI);
  hps_out_msg_output_lo = (unsigned int *)(h2p_lw_virtual_base + HPS_OUT_MSG_OUTPUT_LO);
  hps_out_msg_output_hi = (unsigned int *)(h2p_lw_virtual_base + HPS_OUT_MSG_OUTPUT_HI);
  hps_out_msg_position_lo = (unsigned int *)(h2p_lw_virtual_base + HPS_OUT_MSG_POSITION_LO);
  hps_out_msg_position_hi = (unsigned int *)(h2p_lw_virtual_base + HPS_OUT_MSG_POSITION_HI);
  hps_in_msg_mapping_lo = (unsigned int *)(h2p_lw_virtual_base + HPS_IN_MSG_MAPPING_LO);
  hps_in_msg_mapping_hi = (unsigned int *)(h2p_lw_virtual_base + HPS_IN_MSG_MAPPING_HI);
  hps_in_ctrl_signals = (unsigned int *)(h2p_lw_virtual_base + HPS_IN_CTRL_SIGNALS);
  hps_out_reset = (unsigned int *)(h2p_lw_virtual_base + HPS_OUT_RESET);

  int init_rotor_position, rotor_turnover;
  int msg_input_lo, msg_input_hi;
  int msg_output_lo, msg_output_hi;
  int msg_position_lo, msg_position_hi;
  int reset, ctrl_signals;
  char msg_mapping_lo[7];
  char msg_mapping_hi[7];

  char default_init_rotor_position[4] = "VEQ\0";
  char default_rotor_turnover[4] = "KDO\0";
  char default_input_msg_lo[13] = "GOCMRF\0";
  char default_input_msg_hi[13] = "YATNKL\0";
  char default_output_msg_lo[13] = "OCMRFY\0";
  char default_output_msg_hi[13] = "ATNKLB\0";
  int default_msg_position_lo[6] = {1, 0, 11, 2, 18, 16};
  int default_msg_position_hi[6] = {10, 12, 8, 3, 6, 5};
  char user_init_rotor_position[4];
  char user_rotor_turnover[4];
  char user_input_msg_lo[13];
  char user_input_msg_hi[13];
  char user_output_msg_lo[13];
  char user_output_msg_hi[13];
  int user_msg_position_lo[6];
  int user_msg_position_hi[6];
  int user_input = 0;
  int i;
  while (1) {
    // Display command and received value
    printf("Command Input: ");
    scanf("%s", input_buffer);
    printf("received value: %s\n", input_buffer);
    if (strcmp(input_buffer, "reset") == 0) {
      printf("Default?(Y/N): ");
      scanf("%s", input_buffer);
      if (strcmp(input_buffer, "Y") == 0) {
        user_input = 0;
        printf("DEFAULT init rotor position: %s\n", default_init_rotor_position);
        printf("DEFAULT init rotor position: %s\n", default_rotor_turnover);
        printf("DEFAULT input msg: %s%s\n", default_input_msg_lo, default_input_msg_hi);
        printf("DEFAULT output msg: %s%s\n", default_output_msg_lo, default_output_msg_hi);
        printf("DEFAULT msg position: ");
        for (i = 0; i < 6; i++) {
          printf("%d ", default_msg_position_lo[i]);
        }
        for (i = 0; i < 6; i++) {
          printf("%d ", default_msg_position_hi[i]);
        }
        printf("\n");
        init_rotor_position = set_init_rotor_position(default_init_rotor_position[0], default_init_rotor_position[1], default_init_rotor_position[2]);
        rotor_turnover = set_rotor_turnover(default_rotor_turnover[0], default_rotor_turnover[1], default_rotor_turnover[2]);
        msg_input_lo = set_msg_6(default_input_msg_lo);
        msg_input_hi = set_msg_6(default_input_msg_hi);
        msg_output_lo = set_msg_6(default_output_msg_lo);
        msg_output_hi = set_msg_6(default_output_msg_hi);
        msg_position_lo = set_position_6(default_msg_position_lo);
        msg_position_hi = set_position_6(default_msg_position_hi);

      } else if (strcmp(input_buffer, "N") == 0) {
        user_input = 1;
        printf("SET init rotor position: ");
        scanf("%s", input_buffer);
        strncpy(user_init_rotor_position, input_buffer, 3);
        user_init_rotor_position[3] = '\0';
        // printf("user_init_rotor_position: %s\n", user_init_rotor_position);

        printf("SET rotor turnover: ");
        scanf("%s", input_buffer);
        strncpy(user_rotor_turnover, input_buffer, 3);
        user_rotor_turnover[3] = '\0';
        // printf("user_rotor_turnover: %s\n", user_rotor_turnover);

        printf("SET input msg: ");
        scanf("%s", input_buffer);
        strncpy(user_input_msg_lo, input_buffer, 6);
        strncpy(user_input_msg_hi, input_buffer + 6, 6);
        user_input_msg_lo[6] = '\0';
        user_input_msg_hi[6] = '\0';
        // printf("user_input_msg: %s, %s\n", user_input_msg_lo, user_input_msg_hi);

        printf("SET output msg: ");
        scanf("%s", input_buffer);
        strncpy(user_output_msg_lo, input_buffer, 6);
        strncpy(user_output_msg_hi, input_buffer + 6, 6);
        user_output_msg_lo[6] = '\0';
        user_output_msg_hi[6] = '\0';
        // printf("user_output_msg: %s, %s\n", user_output_msg_lo, user_output_msg_hi);

        for (i = 0; i < 6; i++) {
          printf("SET msg[%d] position: ", i);
          scanf("%s", input_buffer);
          user_msg_position_lo[i] = atoi(input_buffer);
        }
        for (i = 0; i < 6; i++) {
          printf("SET msg[%d] position: ", i + 6);
          scanf("%s", input_buffer);
          user_msg_position_hi[i] = atoi(input_buffer);
        }
        init_rotor_position = set_init_rotor_position(user_init_rotor_position[0], user_init_rotor_position[1], user_init_rotor_position[2]);
        rotor_turnover = set_rotor_turnover(user_rotor_turnover[0], user_rotor_turnover[1], user_rotor_turnover[2]);
        msg_input_lo = set_msg_6(user_input_msg_lo);
        msg_input_hi = set_msg_6(user_input_msg_hi);
        msg_output_lo = set_msg_6(user_output_msg_lo);
        msg_output_hi = set_msg_6(user_output_msg_hi);
        msg_position_lo = set_position_6(user_msg_position_lo);
        msg_position_hi = set_position_6(user_msg_position_hi);
      }
      *hps_out_init_rotor_position_ptr = init_rotor_position;
      *hps_out_rotor_turnover_ptr = rotor_turnover;
      *hps_out_msg_input_lo = msg_input_lo;
      *hps_out_msg_input_hi = msg_input_hi;
      *hps_out_msg_output_lo = msg_output_lo;
      *hps_out_msg_output_hi = msg_output_hi;
      *hps_out_msg_position_lo = msg_position_lo;
      *hps_out_msg_position_hi = msg_position_hi;
      *hps_out_reset = 1;
      *hps_out_reset = 0;
    } else if (strcmp(input_buffer, "read") == 0) {
      ctrl_signals = *hps_in_ctrl_signals;
      printf("Find valid mapping: %d\n", ctrl_signals & 0x00001);
      printf("Done with computation: %d\n", ctrl_signals & 0x00002);
      read_msg_6(*hps_in_msg_mapping_lo, msg_mapping_lo);
      read_msg_6(*hps_in_msg_mapping_hi, msg_mapping_hi);
      msg_mapping_lo[6] = '\0';
      msg_mapping_hi[6] = '\0';
      if (user_input) {
        printf("init rotor position: %s\n", user_init_rotor_position);
        printf("init rotor position: %s\n", user_rotor_turnover);
        printf("msg position: ");
        for (i = 0; i < 6; i++) {
          printf("%d ", user_msg_position_lo[i]);
        }
        for (i = 0; i < 6; i++) {
          printf("%d ", user_msg_position_hi[i]);
        }
        printf("\n");
        printf("input msg: %s%s\n", user_input_msg_lo, user_input_msg_hi);
        printf("output msg: %s%s\n", user_output_msg_lo, user_output_msg_hi);
        if (ctrl_signals & 0x00001) {
          printf("discovered plugboard mappings: \n");
          for (i = 0; i < 6; i++) {
            printf("%c-%c ", user_output_msg_lo[i], msg_mapping_lo[i]);
          }
          printf("\n");
          for (i = 0; i < 6; i++) {
            printf("%c-%c ", user_output_msg_hi[i], msg_mapping_hi[i]);
          }
          printf("\n");
        }
      } else {
        printf("init rotor position: %s\n", default_init_rotor_position);
        printf("init rotor position: %s\n", default_rotor_turnover);
        printf("msg position: ");
        for (i = 0; i < 6; i++) {
          printf("%d ", default_msg_position_lo[i]);
        }
        for (i = 0; i < 6; i++) {
          printf("%d ", default_msg_position_hi[i]);
        }
        printf("\n");
        printf("input msg: %s%s\n", default_input_msg_lo, default_input_msg_hi);
        printf("output msg: %s%s\n", default_output_msg_lo, default_output_msg_hi);
        if (ctrl_signals & 0x00001) {
          printf("discovered plugboard mappings: \n");
          for (i = 0; i < 6; i++) {
            printf("%c-%c ", default_output_msg_lo[i], msg_mapping_lo[i]);
          }
          printf("\n");
          for (i = 0; i < 6; i++) {
            printf("%c-%c ", default_output_msg_hi[i], msg_mapping_hi[i]);
          }
          printf("\n");
        }
      }
    }
  }

  // // === get VGA char addr =====================
  // // get virtual addr that maps to physical
  // vga_char_virtual_base = mmap(NULL, FPGA_CHAR_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, FPGA_CHAR_BASE);
  // if (vga_char_virtual_base == MAP_FAILED) {
  //   printf("ERROR: mmap2() failed...\n");
  //   close(fd);
  //   return (1);
  // }
  // // Get the address that maps to the FPGA LED control
  // vga_char_ptr = (unsigned int *)(vga_char_virtual_base);
  // // === get VGA pixel addr ====================
  // // get virtual addr that maps to physical
  // vga_pixel_virtual_base = mmap(NULL, SDRAM_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, SDRAM_BASE);
  // if (vga_pixel_virtual_base == MAP_FAILED) {
  //   printf("ERROR: mmap3() failed...\n");
  //   close(fd);
  //   return (1);
  // }
  // // Get the address that maps to the FPGA pixel buffer
  // vga_pixel_ptr = (unsigned int *)(vga_pixel_virtual_base);

  // // Clear the screen
  // VGA_box(0, 0, 639, 479, 0x0000);
  // // Clear the text
  // VGA_text_clear();
  // // Write text for title, parameters, and graph labels
  // VGA_text(10, 1, text_top_row);
  // VGA_text(10, 2, text_next);
  // VGA_text(10, 3, sigma);
  // VGA_text(10, 4, beta);
  // VGA_text(10, 5, rho);
  // VGA_text(15, 33, xz);
  // VGA_text(50, 33, xy);
  // VGA_text(30, 55, yz);

  // // the thread identifiers
  // pthread_t thread_display, thread_input;

  // // For portability, explicitly create threads in a joinable state
  // //  thread attribute used here to allow JOIN
  // pthread_attr_t attr;
  // pthread_attr_init(&attr);
  // pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

  // // now the threads
  // pthread_create(&thread_display, NULL, display, NULL);
  // pthread_create(&thread_input, NULL, input, NULL);

  // pthread_join(thread_display, NULL);
  // pthread_join(thread_input, NULL);
  return 0;
} // end main

// /******** Display Thread *******/
// void *display() {
//   // Convert floats to fixed point (7.20)
//   *lw_pio_init_x_ptr = to_fixed(-1.0, 20);
//   *lw_pio_init_y_ptr = to_fixed(0.1, 20);
//   *lw_pio_init_z_ptr = to_fixed(25.0, 20);
//   *lw_pio_sigma_ptr = to_fixed(10.0, 20);
//   *lw_pio_beta_ptr = to_fixed(8. / 3., 20);
//   *lw_pio_rho_ptr = to_fixed(28.0, 20);
//   *lw_pio_dt_ptr = to_fixed(1. / 256, 20);

//   // Reset kernel
//   *(lw_pio_ptr) = 3;
//   *(lw_pio_ptr) = 2;
//   *(lw_pio_ptr) = 1;
//   *(lw_pio_ptr) = 0;

//   // Update locations of current point and previous point (for graphing)
//   x_loc = *(lw_pio_read_x_ptr);
//   y_loc = *(lw_pio_read_y_ptr);
//   z_loc = *(lw_pio_read_z_ptr);
//   prev_x_loc = x_loc;
//   prev_y_loc = y_loc;
//   prev_z_loc = z_loc;

//   while (1) {
//     // If reset
//     while (reset_flag == 1) {
//       // clear screen and reset the kernel (Bit 1 is reset, Bit 0 is clock)
//       VGA_box(0, 0, 639, 479, 0x0000);
//       color_index = 10;
//       *(lw_pio_ptr) = 3;
//       *(lw_pio_ptr) = 2;
//       *(lw_pio_ptr) = 1;
//       *(lw_pio_ptr) = 0;
//       // If restart, clear screen and update the point locations
//       if (restart_flag == 1) {
//         VGA_box(0, 0, 639, 479, 0x0000);
//         x_loc = *(lw_pio_read_x_ptr);
//         y_loc = *(lw_pio_read_y_ptr);
//         z_loc = *(lw_pio_read_z_ptr);
//         prev_x_loc = x_loc;
//         prev_y_loc = y_loc;
//         prev_z_loc = z_loc;
//         // reset flags
//         restart_flag = 0;
//         reset_flag = 0;
//         hunter_signal = 0;
//         bruce_signal = 0;
//         break;
//       }
//     }
//     // If not reset or paused
//     if ((reset_flag == 0) & (pause_signal == 0)) {
//       // Hunter mode - only the current trace is shown (looks like a dot/tiny line tracing the path of the plot)
//       if (hunter_signal == 1) {
//         // Clear the screen everytime so only the current line is shown
//         VGA_box(0, 0, 639, 479, 0x0000);
//       }
//       *(lw_pio_ptr) = 1;
//       *(lw_pio_ptr) = 0;
//       x_loc = *(lw_pio_read_x_ptr);
//       y_loc = *(lw_pio_read_y_ptr);
//       z_loc = *(lw_pio_read_z_ptr);

//       // Used for Bruce mode - setting the color using the third dimension in order to model depth
//       // blue
//       color_x = (((x_loc + 21000000) / 42000000.0) * 20) + 11;
//       color_x = color_x + (0 << 5) + (0 << 11);
//       // red
//       color_y = (((y_loc + 28000000) / 56000000.0) * 20) + 11;
//       color_y = (0 + (0 << 5) + (color_y << 11));
//       // green
//       color_z = (((z_loc) / 60000000.0) * 40) + 22;
//       color_z = (0 + (color_z << 5) + (0 << 11));

//       // Go back to beginning of color array if at the end
//       if (color_index++ == 11)
//         color_index = 0;

//       // Bruce mode - plot where the saturation of the graph at a certain point is based on the third dimension
//       // Used to model depth of the third dimension - darker is further away, brighter is closer
//       if (bruce_signal == 1) {
//         VGA_line(160 + (int)(x_loc / 150000000.0 * 640), 100 + (int)(z_loc / 150000000.0 * 480), 160 + (int)(prev_x_loc / 150000000.0 * 640),
//                  100 + (int)(prev_z_loc / 150000000.0 * 480), color_y);
//         VGA_line(480 + (int)(x_loc / 150000000.0 * 640), 150 + (int)(y_loc / 150000000.0 * 480), 480 + (int)(prev_x_loc / 150000000.0 * 640),
//                  150 + (int)(prev_y_loc / 150000000.0 * 480), color_z);
//         VGA_line(320 + (int)(y_loc / 150000000.0 * 640), 275 + (int)(z_loc / 150000000.0 * 480), 320 + (int)(prev_y_loc / 150000000.0 * 640),
//                  275 + (int)(prev_z_loc / 150000000.0 * 480), color_x);
//       } else {
//         // Normal mode - we cycle through a color index array so we plot in rainbow colors
//         // Graph line between previous and current point, resize/scale within screen
//         VGA_line(160 + (int)(x_loc / 150000000.0 * 640), 100 + (int)(z_loc / 150000000.0 * 480), 160 + (int)(prev_x_loc / 150000000.0 * 640),
//                  100 + (int)(prev_z_loc / 150000000.0 * 480), colors[color_index]);
//         VGA_line(480 + (int)(x_loc / 150000000.0 * 640), 150 + (int)(y_loc / 150000000.0 * 480), 480 + (int)(prev_x_loc / 150000000.0 * 640),
//                  150 + (int)(prev_y_loc / 150000000.0 * 480), colors[color_index]);
//         VGA_line(320 + (int)(y_loc / 150000000.0 * 640), 275 + (int)(z_loc / 150000000.0 * 480), 320 + (int)(prev_y_loc / 150000000.0 * 640),
//                  275 + (int)(prev_z_loc / 150000000.0 * 480), colors[color_index]);
//       }
//       // Update previous location with current location
//       prev_x_loc = x_loc;
//       prev_y_loc = y_loc;
//       prev_z_loc = z_loc;

//       // Delay (controls how fast we're sending clock signal to FPGA)
//       usleep(time_interval);
//     }

//     // If paused, stay in while loop until unpaused
//     while (pause_signal == 1) {
//       if (pause_signal == 0)
//         break;
//     }
//   }
// }

// /******** Input Thread *******/
// void *input() {
//   while (1) {
//     // Display command and received value
//     printf("Display Command: ");
//     scanf("%s", input_buffer);
//     printf("received value: %s\n", input_buffer);

//     // "s" = slow (add 500 us to clock cycle time)
//     if (strcmp(input_buffer, "s") == 0)
//       time_interval = (int)(time_interval * 1.5);
//     // "f" = slow (subtract 500 us to clock cycle time)
//     else if (strcmp(input_buffer, "f") == 0)
//       time_interval = (int)(time_interval / 1.5);
//     // "p" = pause
//     else if (strcmp(input_buffer, "p") == 0)
//       pause_signal = 1;
//     // "u" = unpause / resume
//     else if (strcmp(input_buffer, "u") == 0)
//       pause_signal = 0;
//     // "hunter mode" = graphing mode where a small rainbow line traces the path
//     else if (strcmp(input_buffer, "hunter_mode") == 0)
//       hunter_signal = 1;
//     // "bruce mode" = depth of third dimension encoded in the color
//     else if (strcmp(input_buffer, "bruce_mode") == 0) {
//       // clear the screen and initialize for "bruce mode"
//       VGA_box(0, 0, 639, 479, 0x0000);
//       x_loc = *(lw_pio_read_x_ptr);
//       y_loc = *(lw_pio_read_y_ptr);
//       z_loc = *(lw_pio_read_z_ptr);
//       prev_x_loc = x_loc;
//       prev_y_loc = y_loc;
//       prev_z_loc = z_loc;
//       x_loc = *(lw_pio_read_x_ptr);
//       y_loc = *(lw_pio_read_y_ptr);
//       z_loc = *(lw_pio_read_z_ptr);
//       prev_x_loc = x_loc;
//       prev_y_loc = y_loc;
//       prev_z_loc = z_loc;
//       bruce_signal = 1;
//     }
//     // "r" = reset
//     else if (strcmp(input_buffer, "r") == 0) {
//       reset_flag = 1;
//       restart_flag = 0;
//       printf("Default Condition (y/n): ");
//       scanf("%s", input_buffer);
//       // "y" = Set to default initial values/parameters
//       if (strcmp(input_buffer, "y") == 0) {
//         *lw_pio_init_x_ptr = to_fixed(-1.0, 20);
//         *lw_pio_init_y_ptr = to_fixed(0.1, 20);
//         *lw_pio_init_z_ptr = to_fixed(25.0, 20);
//         *lw_pio_sigma_ptr = to_fixed(10.0, 20);
//         *lw_pio_beta_ptr = to_fixed(8. / 3., 20);
//         *lw_pio_rho_ptr = to_fixed(28.0, 20);
//         *lw_pio_dt_ptr = to_fixed(1. / 256, 20);
//         restart_flag = 1;
//       }
//       // "n" = User inputs custom values for init positions, parameters, and dt
//       else {
//         printf("initial x position: ");
//         scanf("%s", input_buffer);
//         *lw_pio_init_x_ptr = to_fixed(strtof(input_buffer, NULL), 20);
//         printf("initial y position: ");
//         scanf("%s", input_buffer);
//         *lw_pio_init_y_ptr = to_fixed(strtof(input_buffer, NULL), 20);
//         printf("initial z position: ");
//         scanf("%s", input_buffer);
//         *lw_pio_init_z_ptr = to_fixed(strtof(input_buffer, NULL), 20);
//         printf("sigma value: ");
//         scanf("%s", input_buffer);
//         sprintf(sigma, "sigma: %s", input_buffer);
//         *lw_pio_sigma_ptr = to_fixed(strtof(input_buffer, NULL), 20);
//         printf("beta value: ");
//         scanf("%s", input_buffer);
//         sprintf(beta, "beta: %s", input_buffer);
//         *lw_pio_beta_ptr = to_fixed(strtof(input_buffer, NULL), 20);
//         printf("rho value: ");
//         scanf("%s", input_buffer);
//         sprintf(rho, "rho: %s", input_buffer);
//         *lw_pio_rho_ptr = to_fixed(strtof(input_buffer, NULL), 20);
//         printf("time interval step: ");
//         scanf("%s", input_buffer);
//         *lw_pio_dt_ptr = to_fixed(strtof(input_buffer, NULL), 20);

//         // Rewrite text with updated parameters
//         VGA_text_clear();
//         VGA_text(10, 1, text_top_row);
//         VGA_text(10, 2, text_next);
//         VGA_text(10, 3, sigma);
//         VGA_text(10, 4, beta);
//         VGA_text(10, 5, rho);
//         VGA_text(15, 33, xz);
//         VGA_text(50, 33, xy);
//         VGA_text(30, 55, yz);
//         restart_flag = 1;
//       }
//     }
//   }
// }

// /****************************************************************************************
//  * Subroutine to send a string of text to the VGA monitor
//  ****************************************************************************************/
// void VGA_text(int x, int y, char *text_ptr) {
//   volatile char *character_buffer = (char *)vga_char_ptr; // VGA character buffer
//   int offset;
//   /* assume that the text string fits on one line */
//   offset = (y << 7) + x;
//   while (*(text_ptr)) {
//     // write to the character buffer
//     *(character_buffer + offset) = *(text_ptr);
//     ++text_ptr;
//     ++offset;
//   }
// }

// /****************************************************************************************
//  * Subroutine to clear text to the VGA monitor
//  ****************************************************************************************/
// void VGA_text_clear() {
//   volatile char *character_buffer = (char *)vga_char_ptr; // VGA character buffer
//   int offset, x, y;
//   for (x = 0; x < 79; x++) {
//     for (y = 0; y < 59; y++) {
//       /* assume that the text string fits on one line */
//       offset = (y << 7) + x;
//       // write to the character buffer
//       *(character_buffer + offset) = ' ';
//     }
//   }
// }

// /****************************************************************************************
//  * Draw a filled rectangle on the VGA monitor
//  ****************************************************************************************/
// #define SWAP(X, Y) \
//   do {             \
//     int temp = X;  \
//     X = Y;         \
//     Y = temp;      \
//   } while (0)

// void VGA_box(int x1, int y1, int x2, int y2, short pixel_color) {
//   char *pixel_ptr;
//   int row, col;

//   /* check and fix box coordinates to be valid */
//   if (x1 > 639)
//     x1 = 639;
//   if (y1 > 479)
//     y1 = 479;
//   if (x2 > 639)
//     x2 = 639;
//   if (y2 > 479)
//     y2 = 479;
//   if (x1 < 0)
//     x1 = 0;
//   if (y1 < 0)
//     y1 = 0;
//   if (x2 < 0)
//     x2 = 0;
//   if (y2 < 0)
//     y2 = 0;
//   if (x1 > x2)
//     SWAP(x1, x2);
//   if (y1 > y2)
//     SWAP(y1, y2);
//   for (row = y1; row <= y2; row++)
//     for (col = x1; col <= x2; ++col) {
//       VGA_PIXEL(col, row, pixel_color);
//     }
// }

// /****************************************************************************************
//  * Draw a outline rectangle on the VGA monitor
//  ****************************************************************************************/
// #define SWAP(X, Y) \
//   do {             \
//     int temp = X;  \
//     X = Y;         \
//     Y = temp;      \
//   } while (0)

// void VGA_rect(int x1, int y1, int x2, int y2, short pixel_color) {
//   char *pixel_ptr;
//   int row, col;

//   /* check and fix box coordinates to be valid */
//   if (x1 > 639)
//     x1 = 639;
//   if (y1 > 479)
//     y1 = 479;
//   if (x2 > 639)
//     x2 = 639;
//   if (y2 > 479)
//     y2 = 479;
//   if (x1 < 0)
//     x1 = 0;
//   if (y1 < 0)
//     y1 = 0;
//   if (x2 < 0)
//     x2 = 0;
//   if (y2 < 0)
//     y2 = 0;
//   if (x1 > x2)
//     SWAP(x1, x2);
//   if (y1 > y2)
//     SWAP(y1, y2);
//   // left edge
//   col = x1;
//   for (row = y1; row <= y2; row++) {
//     VGA_PIXEL(col, row, pixel_color);
//   }

//   // right edge
//   col = x2;
//   for (row = y1; row <= y2; row++) {
//     VGA_PIXEL(col, row, pixel_color);
//   }

//   // top edge
//   row = y1;
//   for (col = x1; col <= x2; ++col) {
//     VGA_PIXEL(col, row, pixel_color);
//   }

//   // bottom edge
//   row = y2;
//   for (col = x1; col <= x2; ++col) {
//     VGA_PIXEL(col, row, pixel_color);
//   }
// }

// // =============================================
// // === Draw a line
// // =============================================
// // plot a line
// // at x1,y1 to x2,y2 with color
// // Code is from David Rodgers,
// //"Procedural Elements of Computer Graphics",1985
// void VGA_line(int x1, int y1, int x2, int y2, short c) {
//   int e;
//   signed int dx, dy, j, temp;
//   signed int s1, s2, xchange;
//   signed int x, y;
//   char *pixel_ptr;

//   /* check and fix line coordinates to be valid */
//   if (x1 > 639)
//     x1 = 639;
//   if (y1 > 479)
//     y1 = 479;
//   if (x2 > 639)
//     x2 = 639;
//   if (y2 > 479)
//     y2 = 479;
//   if (x1 < 0)
//     x1 = 0;
//   if (y1 < 0)
//     y1 = 0;
//   if (x2 < 0)
//     x2 = 0;
//   if (y2 < 0)
//     y2 = 0;

//   x = x1;
//   y = y1;

//   // take absolute value
//   if (x2 < x1) {
//     dx = x1 - x2;
//     s1 = -1;
//   }

//   else if (x2 == x1) {
//     dx = 0;
//     s1 = 0;
//   }

//   else {
//     dx = x2 - x1;
//     s1 = 1;
//   }

//   if (y2 < y1) {
//     dy = y1 - y2;
//     s2 = -1;
//   }

//   else if (y2 == y1) {
//     dy = 0;
//     s2 = 0;
//   }

//   else {
//     dy = y2 - y1;
//     s2 = 1;
//   }

//   xchange = 0;

//   if (dy > dx) {
//     temp = dx;
//     dx = dy;
//     dy = temp;
//     xchange = 1;
//   }

//   e = ((int)dy << 1) - dx;

//   for (j = 0; j <= dx; j++) {
//     VGA_PIXEL(x, y, c);

//     if (e >= 0) {
//       if (xchange == 1)
//         x = x + s1;
//       else
//         y = y + s2;
//       e = e - ((int)dx << 1);
//     }

//     if (xchange == 1)
//       y = y + s2;
//     else
//       x = x + s1;

//     e = e + ((int)dy << 1);
//   }
// }

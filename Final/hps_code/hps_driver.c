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

// Each PIO port has its own address offset
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

  //Init variables
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
      if (strcmp(input_buffer, "Y") == 0) { //Yes will set robot to default setting
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

      } else if (strcmp(input_buffer, "N") == 0) { //No command will enable manual roter settings
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
      // set values to output port
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
      // print out default or user input settings and discovered plugboard mappings
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
}

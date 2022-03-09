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

// main bus; PIO
#define FPGA_AXI_BASE 0xC0000000
#define FPGA_AXI_SPAN 0x00001000
// main axi bus base
void *h2p_virtual_base;
volatile signed int *incr_value_col = NULL;
volatile signed int *incr_value_row = NULL;
volatile signed int *init_center_node = NULL;
volatile signed int *init_node = NULL;
volatile signed int *init_rho = NULL;
volatile signed int *number_of_rows = NULL;
volatile signed int *test_test = NULL;

// lw bus; PIO
#define FPGA_LW_BASE 0xff200000
#define FPGA_LW_SPAN 0x00001000
// the light weight bus base
void *h2p_lw_virtual_base;

// read offset is 0x10 for both busses
// remember that eaxh axi master bus needs unique address
#define INCR_VALUE_COL_OFFSET 0x10
#define INCR_VALUE_ROW_OFFSET 0x20
#define INIT_CENTER_NODE_OFFSET 0x30
#define INIT_NODE_OFFSET 0x00
#define INIT_RHO_OFFSET 0x50
#define NUMBER_OF_ROWS_OFFSET 0x40
#define TEST_TEST_OFFSET 0x60

// /dev/mem file id
int fd;

int main(void)
{

	// Declare volatile pointers to I/O registers (volatile
	// means that IO load and store instructions will be used
	// to access these pointer locations,

	// === get FPGA addresses ==================
	// Open /dev/mem
	if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1)
	{
		printf("ERROR: could not open \"/dev/mem\"...\n");
		return (1);
	}

	//============================================
	// get virtual addr that maps to physical
	// for light weight AXI bus
	h2p_lw_virtual_base = mmap(NULL, FPGA_LW_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, FPGA_LW_BASE);
	if (h2p_lw_virtual_base == MAP_FAILED)
	{
		printf("ERROR: mmap1() failed...\n");
		close(fd);
		return (1);
	}

	//============================================

	// ===========================================
	// get virtual address for
	// AXI bus addr
	h2p_virtual_base = mmap(NULL, FPGA_AXI_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, FPGA_AXI_BASE);
	if (h2p_virtual_base == MAP_FAILED)
	{
		printf("ERROR: mmap3() failed...\n");
		close(fd);
		return (1);
	}
	// Get the addresses that map to the two parallel ports on the AXI bus
	incr_value_col = (signed int *)(h2p_virtual_base + INCR_VALUE_COL_OFFSET);
	incr_value_row = (signed int *)(h2p_virtual_base + INCR_VALUE_ROW_OFFSET);
	init_center_node = (signed int *)(h2p_virtual_base + INIT_CENTER_NODE_OFFSET);
	init_node = (signed int *)(h2p_virtual_base + INIT_NODE_OFFSET);
	init_rho = (signed int *)(h2p_virtual_base + INIT_RHO_OFFSET);
	number_of_rows = (signed int *)(h2p_virtual_base + NUMBER_OF_ROWS_OFFSET);
	test_test = (signed int *)(h2p_virtual_base + TEST_TEST_OFFSET);
	//============================================

	while (1)
	{
		int num;
		int junk;
		// input a number
		// reset: 2; clk: 1
		junk = scanf("%d", &num);
		*(number_of_rows) = num;
		// send to PIOs
		junk = scanf("%d", &num);
		*(test_test) = num;
		junk = scanf("%d", &num);
		*(test_test) = num;

		// receive back and print
		printf("pio in=%d\n\r", *(test_test));

	} // end while(1)
} // end main

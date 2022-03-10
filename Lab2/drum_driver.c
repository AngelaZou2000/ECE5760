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

	char input_buffer[64];
	// printf("Number of columns: ");
	// scanf("%s", input_buffer);
	// printf("received number of columns: %s\n", input_buffer);
	// int number_of_cols_value = atoi(input_buffer);
	int number_of_cols_value = 100;
	while (1)
	{
		printf("Want to reset(y/n): ");
		scanf("%s", input_buffer);
		printf("received value: %s\n", input_buffer);
		if (strcmp(input_buffer, "y") == 0)
		{
			// number of rows
			printf("number of rows: ");
			scanf("%s", input_buffer);
			printf("received row value: %s\n", input_buffer);
			int number_of_rows_value = atoi(input_buffer);
			// *number_of_rows = number_of_rows_value;
			// node intialization
			printf("center node initialization value: ");
			scanf("%s", input_buffer);
			float init_center_node_value = strtof(input_buffer, NULL);
			printf("received center node value: %f\n", init_center_node_value);
			// *init_node = to_fixed(0.0, 17);
			// *init_center_node = to_fixed(init_center_node_value, 17);
			float incr_value_row_value = init_center_node_value / (int)(number_of_cols_value / 2);
			float incr_value_col_value = incr_value_row_value / (int)(number_of_rows_value / 2);
			printf("incr row value: %f, %x\n", incr_value_row_value, to_fixed(incr_value_row_value, 17));
			printf("incr col value: %f, %x\n", incr_value_col_value, to_fixed(incr_value_col_value, 17));
			// *incr_value_row = to_fixed(incr_value_row_value, 17);
			// *incr_value_col = to_fixed(incr_value_col_value, 17);
			// init rho value
			printf("rho initialization value: ");
			scanf("%s", input_buffer);
			float init_rho_value = 1 / strtof(input_buffer, NULL);
			printf("received init rho value: %f, %x\n", init_rho_value, to_fixed(init_rho_value, 17));
			// *init_rho = to_fixed(init_rho_value, 17);
			// reset
			// *(test_test) = 1;
			// *(test_test) = 0;

			// input to PIO
			*number_of_rows = number_of_rows_value;
			*init_node = to_fixed(0.0, 17);
			*init_center_node = to_fixed(init_center_node_value, 17);
			*incr_value_row = to_fixed(incr_value_row_value, 17);
			*incr_value_col = to_fixed(incr_value_col_value, 17);
			*init_rho = to_fixed(init_rho_value, 17);
			*(test_test) = 1;
			*(test_test) = 0;
		}

		// junk = scanf("%d", &num);
		// *(number_of_rows) = num;
		// // send to PIOs
		// junk = scanf("%d", &num);
		// *(test_test) = num;
		// junk = scanf("%d", &num);
		// *(test_test) = num;

		// // receive back and print
		// printf("pio in=%d\n\r", *(test_test));

	} // end while(1)
} // end main

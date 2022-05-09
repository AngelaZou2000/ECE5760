/**
 * @file enigma.c
 * @author Angela Zou (az292@cornell.edu)
 * @brief C implementation of enigma
 * @version 0.1
 * @date 2022-04-14
 *
 * @copyright Copyright (c) 2022
 *
 */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// reflector reference
// ABCDEFGHIJKLMNOPQRSTUVWXYZ
// YRUHQSLDPXNGOKMIEBFZCWVJAT
char reflector_key[27] = "YRUHQSLDPXNGOKMIEBFZCWVJAT\0";
// machine order: left --> right -- I II III
char rotor_keys[3][27] = {
    // ABCDEFGHIJKLMNOPQRSTUVWXYZ
    // EKMFLGDQVZNTOWYHXUSPAIBRCJ
    // AJDKSIRUXBLHWTMCQGZNPYFVOE
    // BDFHJLCPRTXVZNYEIWGAKMUSQO
    "EKMFLGDQVZNTOWYHXUSPAIBRCJ\0",
    "AJDKSIRUXBLHWTMCQGZNPYFVOE\0",
    "BDFHJLCPRTXVZNYEIWGAKMUSQO\0",
};
char plugboard_1[1] = "\0";
char plugboard_2[1] = "\0";
char rotor_turnover[4] = "KDO\0";
char rotor_position[4] = "VEQ\0";

int reflector(char *reflector_key, int input) {
  return reflector_key[input] - 'A';
}

// backward
int rotor_l_to_r(char *rotor_key, int input, int offset) {
  int enter_contact = (input + offset) % 26;
  // printf("%s, %d\n", rotor_key, strlen(rotor_key));
  // printf("%d, %c\n", enter_contact, enter_contact + 'A');
  // printf("%s, %d\n", strchr(rotor_key, enter_contact + 'A'), strlen(strchr(rotor_key, enter_contact + 'A')));
  int exit_contact = strlen(rotor_key) - strlen(strchr(rotor_key, enter_contact + 'A'));
  int exit_position = (exit_contact - offset + 26) % 26;
  return exit_position;
}

// forward
int rotor_r_to_l(char *rotor_key, int input, int offset) {
  int enter_contact = (input + offset) % 26;
  int exit_contact = rotor_key[enter_contact] - 'A';
  int exit_position = (exit_contact - offset + 26) % 26;
  return exit_position;
}

int plugboard_mapping(char *plugboard_1, char *plugboard_2, int input) {
  if (strchr(plugboard_1, input + 'A') != NULL) {
    int index = strlen(plugboard_1) - strlen(strchr(plugboard_1, input + 'A'));
    return plugboard_2[index] - 'A';
  } else if (strchr(plugboard_2, input + 'A') != NULL) {
    int index = strlen(plugboard_2) - strlen(strchr(plugboard_2, input + 'A'));
    return plugboard_1[index] - 'A';
  } else {
    return input;
  }
}

char enigma_mapping(char input) {
  int input_value = input - 'A';
  int plugboard_value_in = plugboard_mapping(plugboard_1, plugboard_2, input_value);
  int rotor_value_forward_2 = rotor_r_to_l(rotor_keys[2], plugboard_value_in, rotor_position[2] - 'A');
  int rotor_value_forward_1 = rotor_r_to_l(rotor_keys[1], rotor_value_forward_2, rotor_position[1] - 'A');
  int rotor_value_forward_0 = rotor_r_to_l(rotor_keys[0], rotor_value_forward_1, rotor_position[0] - 'A');
  int reflector_value = reflector(reflector_key, rotor_value_forward_0);
  int rotor_value_backward_0 = rotor_l_to_r(rotor_keys[0], reflector_value, rotor_position[0] - 'A');
  int rotor_value_backward_1 = rotor_l_to_r(rotor_keys[1], rotor_value_backward_0, rotor_position[1] - 'A');
  int rotor_value_backward_2 = rotor_l_to_r(rotor_keys[2], rotor_value_backward_1, rotor_position[2] - 'A');
  int plugboard_value_out = plugboard_mapping(plugboard_1, plugboard_2, rotor_value_backward_2);
  // printf("%d, %d, %d\n", rotor_position[0] - 'A', rotor_position[1] - 'A', rotor_position[2] - 'A');
  // printf("%d, %d, %d, %d, %d, %d, %d, %d, %d\n", input_value, plugboard_value_in, rotor_value_forward_2, rotor_value_forward_1, rotor_value_forward_0, reflector_value, rotor_value_backward_0, rotor_value_backward_1, rotor_value_backward_2, plugboard_value_out);
  return plugboard_value_out + 'A';
}

void rotor_stepping() {
  if (rotor_position[1] == rotor_turnover[1]) {
    rotor_position[0] = (rotor_position[0] - 'A' + 1) % 26 + 'A';
    rotor_position[1] = (rotor_position[1] - 'A' + 1) % 26 + 'A';
  }
  if (rotor_position[2] == rotor_turnover[2]) {
    rotor_position[1] = (rotor_position[1] - 'A' + 1) % 26 + 'A';
  }
  rotor_position[2] = (rotor_position[2] - 'A' + 1) % 26 + 'A';
  // printf("%d %d %d\n", rotor_position[0] - 'A', rotor_position[1] - 'A', rotor_position[2] - 'A');
}

void enigma_running(char *input_str, char *output_str) {
  int i = 0;
  char input_char;
  char value;
  while (input_str[i] != '\0') {
    input_char = input_str[i];
    rotor_stepping();
    value = enigma_mapping(input_char);
    output_str[i] = value;
    i = i + 1;
  }
}

int main(int argc, char **argv) {
  // if (argc != 3)
  // {
  //   printf("wrong number of input arguments to the main function\n");
  //   return 1;
  // }

  // -------- individual function testing --------
  // int rotor_selection = atoi(argv[1]);
  // int input_value = toupper(*argv[2]) - 'A';
  // int offset = atoi(argv[3]);
  //// printf('%d, %d\n', rotor_selection, offset);

  // int reflector_value = reflector(reflector_key, input_value);
  // printf("in: %c [%d], out: %c [%d]\n", toupper(*argv[2]), (int)(input_value), reflector_value + 'A', reflector_value);
  // int rotor_value_forward = rotor_r_to_l(rotor_keys[rotor_selection], input_value, offset);
  // printf("r to l: in: %c [%d], out: %c [%d]\n", toupper(*argv[2]), (int)(input_value), rotor_value_forward + 'A', rotor_value_forward);
  // int rotor_value_backward = rotor_l_to_r(rotor_keys[rotor_selection], input_value, offset);
  // printf("l to r: in: %c [%d], out: %c [%d]\n", toupper(*argv[2]), (int)(input_value), rotor_value_backward + 'A', rotor_value_backward);
  // int plugboard_value = plugboard_mapping(plugboard_1, plugboard_2, input_value);
  // printf("in: %c [%d], out: %c [%d]\n", toupper(*argv[2]), (int)(input_value), plugboard_value + 'A', plugboard_value);

  // -------- verilog verif generation --------
  // char input = 'A';
  // for (int i = 0; i < 26; i++)
  // {
  //   int rotor_value_backward = rotor_l_to_r(rotor_keys[2], input - 'A', 11);
  //   printf("%c, %c, %d\n", input, rotor_value_backward + 'A', rotor_value_backward);
  //   input++;
  // }

  // printf("%d %d %d\n", 'V' - 'A', 'E' - 'A', 'Q' - 'A');

  // -------- full testing --------
  // printf("%c\n", enigma_mapping(toupper(*argv[1])));

  // -------- stepping testing --------
  // rotor_stepping();
  // rotor_stepping();
  // rotor_stepping();
  // rotor_stepping();
  // rotor_stepping();
  // rotor_stepping();
  // rotor_stepping();
  // rotor_stepping();
  // rotor_stepping();
  // rotor_stepping();
  // rotor_stepping();
  // rotor_stepping();
  // rotor_stepping();
  // rotor_stepping();

  // -------- full testing --------
  char input_str[29] = "AABBCCDDEEFFGGHHIIJJKKLLMMNN\0";
  char output_str[29];
  enigma_running(input_str, output_str);
  printf("%s, %s\n", input_str, output_str);
  for (int i = 0; i < 28; i++) {
    printf("%d  ", output_str[i] - 'A');
  }
  return 0;
}
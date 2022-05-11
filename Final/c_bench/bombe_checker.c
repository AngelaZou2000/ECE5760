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

int letter_label[26];

/* Enigma Machine */
char reflector_key[27] = "YRUHQSLDPXNGOKMIEBFZCWVJAT\0";
char rotor_keys[3][27] = {
    "EKMFLGDQVZNTOWYHXUSPAIBRCJ\0",
    "AJDKSIRUXBLHWTMCQGZNPYFVOE\0",
    "BDFHJLCPRTXVZNYEIWGAKMUSQO\0",
};
char rotor_turnover[4] = "KDO\0";
char rotor_position[4] = "VEQ\0";


int reflector(char *reflector_key, int input) {
  return reflector_key[input] - 'A';
}
// backward
int rotor_l_to_r(char *rotor_key, int input, int offset) {
  int enter_contact = (input + offset) % 26;
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
char enigma_mapping(char input, char *plugboard_1, char *plugboard_2) {
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
 }
void enigma_running(char *input_str, char *output_str, char *plugboard_1, char *plugboard_2) {
  int i = 0;
  char input_char;
  char value;
  while (input_str[i] != '\0') {
    input_char = input_str[i];
    rotor_stepping();
    value = enigma_mapping(input_char, plugboard_1, plugboard_2);
    output_str[i] = value;
    i = i + 1;
  }
}

/*
  Function: enigma_test ()
    Output printout: "plugboard1, plugboard2, encrypted message, decrypted message"
*/
void enigma_test(char unmatched_letters[], char encrypted_str[], char original_str[], int plugboard1_guess[], int plugboard2_guess[], char msg_out[], char msg_mapping[], int num_pairs){
  char decrypted_str[50];
  char plugboard1_str[50];
  char plugboard2_str[50];
  for (int i=0; i<12;i++){
      plugboard1_str[i] = msg_out[i];
      plugboard2_str[i] = msg_mapping[i];
  }
  for (int i=0; i<num_pairs;i++){
      plugboard1_str[i+12] = unmatched_letters[plugboard1_guess[i]];
      plugboard2_str[i+12] = unmatched_letters[plugboard2_guess[i]];
  }
  enigma_running(encrypted_str, decrypted_str, plugboard1_str, plugboard2_str);
  printf("%s,%s, ",plugboard1_str, plugboard2_str);
  printf("%s,%s\n", encrypted_str, decrypted_str);
  if (strcmp(decrypted_str,original_str)==0){
    printf("%s\n", "Correct");
  }
}


/* Checks Bombe Machine outputs */
int main(void) {
  
  char msg_out[12] =     "VOCAETNKLWSY";    // Need to find DQ, FR
  char msg_mapping[12] = "VONBPTCKLWSY"; 
  char encrypted_str[50] = "OVVKTAKPNTEBNJALSQVNIWC";  
  char original_str[50] =  "CORNELLITHACANEWYORKUSA"; 
  char unmatched_letters[26] = "";
  int unmatched_letters_count = 0;
  
    for (int i = 0; i < 12; i++) {
      letter_label[(int)msg_out[i] - 65] = 1;
      letter_label[(int)msg_mapping[i] - 65] = 1;
    }
    for (int i = 0; i < 26; i++) {
      if (letter_label[i] == 0) {
        unmatched_letters[unmatched_letters_count] = (char)(i + 65);
        unmatched_letters_count++;
      }
    }
  
  // Example: unmatched_letters = DFGHIJMQRUXZ (len = 12)
  /* 
     TODO: Call findPair() 
     TODO: For each output of findPair(), create two int arrays of plugboard settings
     Example:
        If printout = "20
                       31"
        Create int plugboard1_guess[] = {2,0}
        Create int plugboard2_guess[] = {3,1}
        TODO: Call enigma_test(inputs given above) for each plugboard1_guess[] and plugboard2_guess[] 
  */
  // Example of one output from findPair:
    int plugboard1_guess[50] = {0,1};
    int plugboard2_guess[50] = {7,8};
    int level = 2;
    enigma_test(unmatched_letters,encrypted_str,original_str, plugboard1_guess, plugboard2_guess, msg_out, msg_mapping, level);

}

#include "config.h"
#include <fcntl.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/mman.h>
#include <sys/shm.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

// ----------------------------------------------------
// Enigma Machine
// ----------------------------------------------------
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
  strncpy(rotor_position, init_rotor_position, 4);
  // printf("%s, %s, %s\n", plugboard_1, plugboard_2, input_str);
  while (input_str[i] != '\0') {
    input_char = input_str[i];
    rotor_stepping();
    value = enigma_mapping(input_char, plugboard_1, plugboard_2);
    output_str[i] = value;
    i = i + 1;
  }
  // printf("AFTER WHILE: %s, %s, %s, %s\n", plugboard_1, plugboard_2, input_str, output_str);
}

// -------------------------------------------------------------------------
// Pairing Cleanup: clean up the output plugboard setting from the FPGA and
// create arrays to store undetermined ones.
// -------------------------------------------------------------------------
void pairing_cleanup() {
  int i;
  for (i = 0; i < 26; i++) {
    letter_label[i] = -1;
  }
  for (i = 0; i < 12; i++) {
    letter_label[(int)msg_out[i] - 65] = (int)msg_mapping[i] - 65;
    letter_label[(int)msg_mapping[i] - 65] = (int)msg_out[i] - 65;
  }
  for (i = 0; i < 26; i++) {
    if (letter_label[i] == -1) {
      unmatched_letters[unmatched_letters_count] = (char)(i + 65);
      unmatched_letters_count++;
    } else {
      if (i != letter_label[i]) {
        matched_pair_count = matched_pair_count + 1;
      }
    }
  }
  matched_pair_count = matched_pair_count / 2;
  num_pairs = total_pairs - matched_pair_count;
}

// ----------------------------------------------------
// Enigma Test
// ----------------------------------------------------
/*
  Function: enigma_test ()
    Output printout: "plugboard1, plugboard2, encrypted message, decrypted message"
*/
void enigma_test(int *plugboard1_guess, int *plugboard2_guess) {
  // if ((plugboard1_guess[0] == 1) & (plugboard1_guess[1] == 0) & ((plugboard2_guess[0] == 8) & (plugboard2_guess[1] == 7))) {
  //   printf("here\n");
  // }
  // char decrypted_str[50];
  // char plugboard1_str[50];
  // char plugboard2_str[50];
  for (int i = 0; i < 12; i++) {
    plugboard1_str[i] = msg_out[i];
    plugboard2_str[i] = msg_mapping[i];
  }
  for (int i = 0; i < num_pairs; i++) {
    plugboard1_str[i + 12] = unmatched_letters[plugboard1_guess[i]];
    plugboard2_str[i + 12] = unmatched_letters[plugboard2_guess[i]];
  }
  enigma_running(encrypted_str, decrypted_str, plugboard1_str, plugboard2_str);
  if (strcmp(decrypted_str, original_str) == 0) {
    printf("%s,%s, ", plugboard1_str, plugboard2_str);
    printf("%s,%s\n", encrypted_str, decrypted_str);
    printf("Correct, continue? \n");
    scanf("%s", input_buffer);
    if (strcmp(input_buffer, "Y") == 0) {
      printf("Continue\n");
    }
  }
}

// ----------------------------------------------------
// Find Pairs
// ----------------------------------------------------
int findLastUnmatched() {
  for (int ind = (length - 1); ind >= 0; ind--) {
    if (unMatchedLetter[ind] == 0)
      return ind;
  }
  return -1;
}
int findSecLastUnmatched() {
  for (int ind = (findLastUnmatched() - 1); ind > 0; ind--) {
    if (unMatchedLetter[ind] == 0)
      return ind;
  }
  return -1;
}
int findFirstUnmatched() {
  for (int ind = 0; ind < length; ind++) {
    if (unMatchedLetter[ind] == 0)
      return ind;
  }
  return -1;
}
void printUML() {
  for (int ind = 0; ind < length; ind++) {
    printf("%d ", unMatchedLetter[ind]);
  }
  printf("\n");
}
void printPairing() {
  for (int idx = 0; idx < numPair; idx++) {
    printf("%d ", temp1[idx]);
  }
  printf("\n");
  for (int idx = 0; idx < numPair; idx++) {
    printf("%d ", temp2[idx]);
  }
  printf("\n");
  printf("\n");
}
void findPair(int level, int init_i, int init_j) {
  int i = init_i;
  int j = init_j;
  if (level == 0)
    return;
  int levelContinue = 1;
  while (levelContinue) {
    int lastUnmatched = findLastUnmatched();
    int seclastUnmatched = findSecLastUnmatched();
    // printUML();
    // !! FIXED: boundary check; rethink all of the return conditions
    if (i > seclastUnmatched)
      return;
    while (i <= seclastUnmatched) {
      if (unMatchedLetter[i] == 0) {
        temp1[level - 1] = i;
        unMatchedLetter[i] = 1;
        while (j <= lastUnmatched) {
          if (unMatchedLetter[j] == 0) {
            temp2[level - 1] = j;
            unMatchedLetter[j] = 1;
            break;
          } else {
            j++;
            if (j > lastUnmatched)
              return;
          }
        }
        break;
      } else {
        i++;
        if (i > seclastUnmatched)
          return;
      }
    }
    if (level == 1) {
      // printPairing();
      count = count + 1;
      enigma_test(temp1, temp2);
      unMatchedLetter[i] = 0;
      unMatchedLetter[j] = 0;
      if (j == lastUnmatched) {
        if (i == seclastUnmatched) {
          levelContinue = 0;
          return;
        }
        i++;
        j = i + 1;
      } else {
        j++;
      }
    } else {
      if ((j == lastUnmatched) & (i == seclastUnmatched)) {
        unMatchedLetter[i] = 0;
        unMatchedLetter[j] = 0;
        levelContinue = 0;
        return;
      } else {
        findPair(level - 1, i + 1, i + 2);
        unMatchedLetter[i] = 0;
        unMatchedLetter[j] = 0;
      }
      if (j == lastUnmatched) {
        i = i + 1;
        j = i + 1;
      } else {
        j++;
      }
    }
  }
}

/* Checks Bombe Machine outputs */
int main(void) {
  pairing_cleanup();
  numPair = num_pairs;
  length = unmatched_letters_count;
  findPair(numPair, 0, 1);
}

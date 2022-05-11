// pairing cleanup
int total_pairs = 5;
char msg_out[12] = "VOCAETNKLWSY"; // Need to find DQ, FR
char msg_mapping[12] = "VONBPTCKLWSY";
char unmatched_letters[26] = "";
int unmatched_letters_count;
int matched_pair_count;
int letter_label[26];
int num_pairs;

// find pairing
int length;
int numPair;
int unMatchedLetter[26];
int temp1[10];
int temp2[10];
int count;

// enigma machine
char reflector_key[27] = "YRUHQSLDPXNGOKMIEBFZCWVJAT\0";
char rotor_keys[3][27] = {
    "EKMFLGDQVZNTOWYHXUSPAIBRCJ\0",
    "AJDKSIRUXBLHWTMCQGZNPYFVOE\0",
    "BDFHJLCPRTXVZNYEIWGAKMUSQO\0",
};
char rotor_turnover[4] = "KDO\0";
char rotor_position[4] = "VEQ\0";
char init_rotor_position[4] = "VEQ\0";

// enigma test
char encrypted_str[50] = "OVVKTAKPNTEBNJALSQVNIWC\0";
char original_str[50] = "CORNELLITHACANEWYORKUSA\0";

char input_buffer[64];
char decrypted_str[50];
char plugboard1_str[50];
char plugboard2_str[50];
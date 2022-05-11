// pairing cleanup
char msg_out[12] = "VOCAETNKLWSY"; // Need to find DQ, FR
char msg_mapping[12] = "VONBPTCKLWSY";
char unmatched_letters[26] = "";
int unmatched_letters_count = 0;
int matched_pair_count = 0;

// find pairing
int length = 14;
int numPair = 4;
int unMatchedLetter[14];
int temp1[4];
int temp2[4];
int count;

// enigma test
char encrypted_str[50] = "OVVKTAKPNTEBNJALSQVNIWC";
char original_str[50] = "CORNELLITHACANEWYORKUSA";
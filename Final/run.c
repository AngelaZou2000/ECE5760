#include <stdio.h>
#include <string.h>

int unMatchedLetter[7];
int temp1[3];
int temp2[3];
int length = 7;
int numPair = 3;

int sum() {
  int output = 0;
  for (int ind = 0; ind < length; ind++)
    output += unMatchedLetter[ind];
  return output;
}
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
  int levelContinue = 1;
  while (levelContinue) {
    int lastUnmatched = findLastUnmatched();
    int seclastUnmatched = findSecLastUnmatched();
    printUML();
    // printf("%d, %d\n", seclastUnmatched, lastUnmatched);
    // !! FIXME: boundary check; rethink all of the return conditions
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
            // ?? break out of the i while loop?
            break;
          } else {
            j++;
            if (j > lastUnmatched)
              return;
          }
        }
        // ?? break out of the i while loop?
        break;
      } else {
        i++;
        if (i > seclastUnmatched)
          return;
      }
    }
    // !! TODO: rethink
    if (level == 1) {
      printPairing();
      // TODO: add enigma computation; if find matching message, print and wait for user input; else clear the found matching (code)
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

int main(void) {
  memcpy(unMatchedLetter, (int[]){0, 0, 0, 0, 0, 0, 0}, sizeof(unMatchedLetter));
  // for (int i = 0; i < 7; i++) {
  //   printf("%d ", unMatchedLetter[i]);
  // }
  // printf("\n");
  // int val = findLastUnmatched();
  // printf("val: %d\n", val);
  // return 0;
  findPair(numPair, 0, 1);
  return 0;
}

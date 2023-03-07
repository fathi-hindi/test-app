#include <stddef.h>
#include <regex.h>
#include <sys/types.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>



int validate_complex_number(char *complex_number_string) {
  regex_t regex;
  int reti;

  reti = regcomp(&regex, "(([0-9]+\\.[0-9]+)|([0-9]+))([+|-])(([0-9]+\\.[0-9]+)|([0-9]+))(i)", REG_EXTENDED);
  if (reti) {
    printf("Could not compile regex\n");
    exit(1);
  }

  /* Execute regular expression */
  reti = regexec(&regex, complex_number_string, 0, NULL, 0);
  if (!reti) {
    // Match found
    char real_part_string[20];
    char imaginary_part_string[20];
    int real_part_string_index = 0;
    int imaginary_part_string_index = 0;
    int plus_or_minus_index = 0;
    int i_index = 0;
    int j = 0;
    for (int i = 0; i < strlen(complex_number_string); i++) {
      if (complex_number_string[i] == '+' || complex_number_string[i] == '-') {
        plus_or_minus_index = i;
      } else if (complex_number_string[i] == 'i') {
        i_index = i;
      }
    }

    if (plus_or_minus_index < i_index) {
      for (int i = 0; i < plus_or_minus_index; i++) {
        real_part_string[real_part_string_index++] = complex_number_string[i];
      }
      real_part_string[real_part_string_index] = '\0';

      for (int i = plus_or_minus_index; i < i_index; i++) {
        imaginary_part_string[imaginary_part_string_index++] = complex_number_string[i];
      }
      imaginary_part_string[imaginary_part_string_index] = '\0';
    } else {
      for (int i = 0; i < i_index; i++) {
        imaginary_part_string[imaginary_part_string_index++] = complex_number_string[i];
      }
      imaginary_part_string[imaginary_part_string_index] = '\0';

      for (int i = i_index; i < strlen(complex_number_string); i++) {
        real_part_string[real_part_string_index++] = complex_number_string[i];
      }
      real_part_string[real_part_string_index] = '\0';
    }

    double real_part = atof(real_part_string);
    double imaginary_part = atof(imaginary_part_string);

    printf("Complex number: %f + %fi\n", real_part, imaginary_part);

    return 0;
  } else if (reti == REG_NOMATCH) {
    printf("Invalid complex number\n");
return 1;
} else {
printf("Regex match failed\n");
exit(1);
}

regfree(&regex);
}

int validate_complex_number(char *complex_number_string);

int main() {
  char complex_number_string[100];

  printf("Enter a complex number: ");
  scanf("%s", complex_number_string);

  int result = validate_complex_number(complex_number_string);
  if (result == 0) {
    printf("Valid complex number\n");
  } else {
    printf("Invalid complex number\n");
  }

  return 0;
}
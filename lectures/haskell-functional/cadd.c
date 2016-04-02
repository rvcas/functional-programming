#include <stdio.h>

typedef int (*func)(int);

int takes_y(int y) {
  return(x + y);
}

func cadd(int x) {
  return(&takes_y);
}

int main() {
  printf("%i\n", (cadd(2))(3));
}

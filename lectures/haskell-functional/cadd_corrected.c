#include <stdio.h>
#include <stdlib.h>
typedef int (*func)(int, int);
typedef struct { int x; func f; } closure;
typedef closure *closurePtr;

int add(int x, int y) {
  return x + y;
}

closurePtr cadd(int x) {
  closurePtr c;
  c = (closurePtr)malloc(sizeof(closure));
  c->f = add;
  c->x = x;
  return c;
}

int call_closure(closurePtr c, int arg) {
  return (c->f)(c->x, arg);
}

int main() {
 printf("%i\n", call_closure(cadd(2), 3));
}

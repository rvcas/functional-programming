#include <iostream>
using namespace std;
typedef int (*func)(int);

int takes_y(int y) {
  return(x + y);
}

func cadd(int x) {
  return(&takes_y);
}

int main() {
  cout << (cadd(2))(3) << endl;
}

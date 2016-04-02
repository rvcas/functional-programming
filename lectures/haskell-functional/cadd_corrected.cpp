#include <iostream>
using namespace std;
typedef int (*func)(int, int);

class closure {
public:
  closure(int x_val, func f_val)
    : x(x_val), f(f_val)
  {}

  int call(int arg) {
    return f(x, arg);
  }

private:
  const int x;
  const func f;
};

int add(int x, int y) {
  return x + y;
}

closure* cadd(int x) {
  return new closure(x, add);
}

int main() {
  cout << cadd(2)->call(3) << endl;
}

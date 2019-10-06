#include <cassert>
#include <iostream>
#include <mathutils.hpp>

int main() {
  assert(mul(1, 2) == 2);
  assert(div(1, 2) == 0);
  std::cout << "All tests pass." << std::endl;
}

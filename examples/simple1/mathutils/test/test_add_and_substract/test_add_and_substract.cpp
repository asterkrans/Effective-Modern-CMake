#include <cassert>
#include <iostream>
#include <mathutils.hpp>

int main() {
  assert(add(1, 2) == 3);
  assert(sub(1, 2) == -1);
  std::cout << "All tests pass." << std::endl;
}

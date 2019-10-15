#include <cassert>
#include <iostream>
#include <mathutils.hpp>

int main() {
  assert(mathutils::mul(1, 2) == 2);
  assert(mathutils::div(1, 2) == 0);
  std::cout << "All tests pass." << std::endl;
}

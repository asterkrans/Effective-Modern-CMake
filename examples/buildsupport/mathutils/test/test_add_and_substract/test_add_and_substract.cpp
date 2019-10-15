#include <cassert>
#include <iostream>
#include <mathutils.hpp>

int main() {
  assert(mathutils::add(1, 2) == 3);
  assert(mathutils::sub(1, 2) == -1);
  std::cout << "All tests pass." << std::endl;
}

#include <iostream>
#include <mathutils_headeronly.hpp>

int main() {
  std::cout << "This application calculates 100/2 + 10 - 18." << std::endl;
  
  const int result = mathutils::sub(mathutils::add(mathutils::div(100, 2), 10), 18);
  std::cout << "And the result is: " << result << std::endl;

  return 0;
}

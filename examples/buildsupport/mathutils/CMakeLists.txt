cmake_minimum_required(VERSION 3.15)
project(MathUtils LANGUAGES CXX VERSION 1.0.0)

include(BuildSupport)

add_subdirectory(src/lib)
add_subdirectory(test)

buildsupport_perform_final_configuration()

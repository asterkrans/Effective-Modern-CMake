cmake_minimum_required(VERSION 3.0)
include(BuildSupport)

project(MathUtils LANGUAGES CXX VERSION 1.0.0)

add_subdirectory(src/lib)
add_subdirectory(test)

buildsupport_perform_final_configuration()

cmake_minimum_required(VERSION 3.0)
include(BuildSupport)

project(MathUtils LANGUAGES CXX)

add_subdirectory(src/lib)
add_subdirectory(test)

buildsupport_perform_final_configuration()

cmake_minimum_required(VERSION 3.0)
include(BuildSupport)

project(MathUtils LANGUAGES CXX)

add_subdirectory(src/lib)
add_subdirectory(test)

install(DIRECTORY "${CMAKE_SOURCE_DIR}/include/" DESTINATION "include")

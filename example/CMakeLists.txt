cmake_minimum_required(VERSION 3.15)

include(BuildSupport)

project(ProjectA)

add_library(libA OBJECT )
target_sources(libA PRIVATE main.cpp)

add_executable(exampleA)
target_sources(exampleA PRIVATE main.cpp)

target_compile_options(libA PRIVATE "-O3")

#configure_file(input.txt dummyOutput.txt)

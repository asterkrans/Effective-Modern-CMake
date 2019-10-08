cmake_minimum_required(VERSION 3.0)
include(BuildSupport)

project(Calculator LANGUAGES CXX)

include(MathUtils)

add_subdirectory(src/application)

buildsupport_perform_final_configuration()

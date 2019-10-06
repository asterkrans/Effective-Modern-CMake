cmake_minimum_required(VERSION 3.15)
project(Calculator LANGUAGES CXX)

include(BuildSupport)

include(MathUtils)

add_subdirectory(src/application)

buildsupport_perform_final_configuration()

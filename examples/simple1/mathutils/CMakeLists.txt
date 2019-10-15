cmake_minimum_required(VERSION 3.15)
project(MathUtils LANGUAGES CXX)

enable_testing()

add_subdirectory(src/lib)
add_subdirectory(test)


install(EXPORT ${CMAKE_PROJECT_NAME} DESTINATION "share/cmake/myexports")
install(DIRECTORY "${CMAKE_SOURCE_DIR}/include/" DESTINATION "include")

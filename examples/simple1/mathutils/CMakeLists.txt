cmake_minimum_required(VERSION 3.15)
project(MathUtils LANGUAGES CXX VERSION 1.0.0)

enable_testing()

add_subdirectory(src/lib)
add_subdirectory(test)


install(EXPORT ${PROJECT_NAME} DESTINATION "share/cmake/myexports")
install(DIRECTORY "${CMAKE_SOURCE_DIR}/include/" DESTINATION "include")

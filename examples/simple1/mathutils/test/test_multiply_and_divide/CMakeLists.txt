
project(test_multiply_and_divide)

add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME}
               PRIVATE test_multiply_and_divide.cpp)
               
target_link_libraries(${PROJECT_NAME} PRIVATE mathutils_static)

add_test(NAME test-${PROJECT_NAME} COMMAND ${PROJECT_NAME})

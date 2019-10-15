
project(test_multiply_and_divide)

buildsupport_add_test(${PROJECT_NAME})

target_sources(${PROJECT_NAME}
               PRIVATE test_multiply_and_divide.cpp)
               
target_link_libraries(${PROJECT_NAME} PRIVATE mathutils_static)

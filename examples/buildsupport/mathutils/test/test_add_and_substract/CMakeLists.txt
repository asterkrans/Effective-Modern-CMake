
set(TARGETNAME test_add_and_substract)
project(test_add_and_substract)

buildsupport_add_test(${PROJECT_NAME})

target_sources(${PROJECT_NAME}
               PRIVATE test_add_and_substract.cpp)
               
target_link_libraries(${PROJECT_NAME} PRIVATE mathutils_shared)

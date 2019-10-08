
set(TARGETNAME test_multiply_and_divide)

buildsupport_add_test(${TARGETNAME})

target_sources(${TARGETNAME}
               PRIVATE test_multiply_and_divide.cpp)
               
target_link_libraries(${TARGETNAME} PRIVATE mathutils_static)

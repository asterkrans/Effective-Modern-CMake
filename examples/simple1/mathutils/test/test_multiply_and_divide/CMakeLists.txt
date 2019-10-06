
set(TARGETNAME test_multiply_and_divide)

add_executable(${TARGETNAME})

target_sources(${TARGETNAME}
               PRIVATE test_multiply_and_divide.cpp)
               
target_link_libraries(${TARGETNAME} PRIVATE mathutils_static)

add_test(NAME test-${TARGETNAME} COMMAND ${TARGETNAME})

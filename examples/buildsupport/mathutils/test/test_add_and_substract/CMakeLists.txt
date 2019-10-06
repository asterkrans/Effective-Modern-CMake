
set(TARGETNAME test_add_and_substract)

buildsupport_add_executable(${TARGETNAME})

target_sources(${TARGETNAME}
               PRIVATE test_add_and_substract.cpp)
               
target_link_libraries(${TARGETNAME} PRIVATE mathutils_shared)

add_test(NAME test-${TARGETNAME} COMMAND ${TARGETNAME})

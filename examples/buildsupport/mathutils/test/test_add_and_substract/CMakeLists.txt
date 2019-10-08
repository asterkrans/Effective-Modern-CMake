
set(TARGETNAME test_add_and_substract)

buildsupport_add_test(${TARGETNAME})

target_sources(${TARGETNAME}
               PRIVATE test_add_and_substract.cpp)
               
target_link_libraries(${TARGETNAME} PRIVATE mathutils_shared)

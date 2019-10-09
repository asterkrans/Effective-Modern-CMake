project(mathutils VERSION 1.0.0)

buildsupport_add_library(mathutils_object OBJECT)
target_sources(mathutils_object PRIVATE
               add_and_substract.cpp
               multiply_and_divide.cpp
)
target_include_directories(mathutils_object PUBLIC
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

buildsupport_add_library(mathutils_static STATIC)
target_link_libraries(mathutils_static PUBLIC mathutils_object)

buildsupport_add_library(mathutils_shared SHARED)
target_link_libraries(mathutils_shared PUBLIC mathutils_object)
# These properties could be moved set in buildsupport if we want to:
set_target_properties(mathutils_shared PROPERTIES VERSION ${PROJECT_VERSION})
set_target_properties(mathutils_shared PROPERTIES SOVERSION ${PROJECT_VERSION_MAJOR})

buildsupport_add_library(mathutils_headeronly INTERFACE)
target_include_directories(mathutils_headeronly INTERFACE
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

buildsupport_install_and_export(TARGETS
                                mathutils_static
                                mathutils_shared
                                mathutils_object
                                mathutils_headeronly
                                )

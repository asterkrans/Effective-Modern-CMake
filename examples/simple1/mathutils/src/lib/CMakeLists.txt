
add_library(mathutils_object OBJECT)
target_sources(mathutils_object PRIVATE
               add_and_substract.cpp
               multiply_and_divide.cpp
)
target_include_directories(mathutils_object PUBLIC
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

add_library(mathutils_static STATIC)
target_link_libraries(mathutils_static PUBLIC mathutils_object)

add_library(mathutils_shared SHARED)
target_link_libraries(mathutils_shared PUBLIC mathutils_object)
set_target_properties(mathutils_shared PROPERTIES VERSION ${PROJECT_VERSION})
set_target_properties(mathutils_shared PROPERTIES SOVERSION 1)

add_library(mathutils_headeronly INTERFACE)
target_include_directories(mathutils_headeronly INTERFACE
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

install(TARGETS
        mathutils_static
        mathutils_shared
        mathutils_object
        mathutils_headeronly
        EXPORT ${PROJECT_NAME})

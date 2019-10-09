project(application)

include(MathUtils)

buildsupport_add_executable(${PROJECT_NAME}_static)
target_sources(${PROJECT_NAME}_static PRIVATE main.cpp)
target_link_libraries(${PROJECT_NAME}_static PRIVATE mathutils_static)

buildsupport_add_executable(${PROJECT_NAME})
target_sources(${PROJECT_NAME} PRIVATE main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE mathutils_shared)

buildsupport_add_executable(${PROJECT_NAME}_headeronly)
target_sources(${PROJECT_NAME}_headeronly PRIVATE main_headeronly.cpp)
target_link_libraries(${PROJECT_NAME}_headeronly PRIVATE mathutils_headeronly)

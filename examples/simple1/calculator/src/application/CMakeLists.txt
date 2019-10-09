project(application)

include(MathUtils)

add_executable(${PROJECT_NAME}_static)
target_sources(${PROJECT_NAME}_static PRIVATE main.cpp)
target_link_libraries(${PROJECT_NAME}_static PRIVATE mathutils_static)

add_executable(${PROJECT_NAME})
target_sources(${PROJECT_NAME} PRIVATE main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE mathutils_shared)

add_executable(${PROJECT_NAME}_headeronly)
target_sources(${PROJECT_NAME}_headeronly PRIVATE main_headeronly.cpp)
target_link_libraries(${PROJECT_NAME}_headeronly PRIVATE mathutils_headeronly)

install(TARGETS
        ${PROJECT_NAME}_static
        ${PROJECT_NAME}
        ${PROJECT_NAME}_headeronly
        EXPORT ${CMAKE_PROJECT_NAME})

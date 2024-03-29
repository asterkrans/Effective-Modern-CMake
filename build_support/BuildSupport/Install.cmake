#
# Applications and libraries are installed in the target sysroot by using the install function. Example:
# install(TARGETS a b c)  # Install targets.
#
# To also export the target for use in other projects, use buildsupport_install_and_export() instead:
# buildsupport_install_and_export(TARGETS a b c)
#
# Note: It would be possible to modify this to always export all non-test targets. Maybe add a function
# buildsupport_skip_install(target_name) used to opt out instead?
#

if(buildsupport_internal_install_enable)

  function(buildsupport_install_and_export)
    cmake_parse_arguments(ARG "" "" "TARGETS" ${ARGN})
    
    # Modify export directory as you like.
    # Note: CMAKE_PROJECT_NAME is the name of the top level project, while PROJECT_NAME is the current subproject.
    install(EXPORT ${CMAKE_PROJECT_NAME} DESTINATION "share/cmake/myexports")
  
    install(TARGETS ${ARG_TARGETS}
            EXPORT ${CMAKE_PROJECT_NAME})
  endfunction()  
endif()

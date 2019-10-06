#
# Applications and libraries are installed in the target sysroot by using the install function. Example:
# install(TARGETS a b c)  # Install targets.
# install(TARGETS a b c EXPORT ${PROJECT_NAME})  # Install targets and also export targets for use in other projects.
#
# Note: It would be possible to modify this to always export all non-test targets. Maybe add a function
# buildsupport_skip_install(target_name) used to opt out instead?
#

set(buildsupport_install_enabled TRUE)

function(buildsupport_install_initialize)
  install(DIRECTORY "${CMAKE_SOURCE_DIR}/include/" DESTINATION "include")
  
endfunction()

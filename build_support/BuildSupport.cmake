# 
# Build Support
#
# Simplifies the setup of a build system for C and C++ projects using modern CMake.
#

cmake_minimum_required(VERSION 3.15)
include_guard()


#########################################################################################
# Include features to use.

include(BuildSupport/BuildOptions)

include(BuildSupport/Install)

include(BuildSupport/StripDebugInfo)

option(PRODUCTION_BUILD "Set this in production builds to disable some development features in the build support." OFF)
if (NOT PRODUCTION_BUILD)
  include(BuildSupport/Ccache)
  include(BuildSupport/Testing)
endif()


#########################################################################################
# Initialization of used features.

if(buildsupport_install_enabled)
  buildsupport_install_initialize()
endif()

#########################################################################################
# CMake standard functions "overriden" to add some more value.

function(buildsupport_add_executable target_name)
  add_executable(${target_name} ${ARGN})
  
  if(buildsupport_stripdebuginfo_enabled)
    buildsupport_stripdebuginfo_configure(${target_name})
  endif()
  
  set_property(GLOBAL APPEND PROPERTY BUILDSUPPORT_APPLICATIONS "${target_name}")
endfunction()

function(buildsupport_add_library target_name)
  add_library(${target_name} ${ARGN})
  set_property(GLOBAL APPEND PROPERTY BUILDSUPPORT_LIBRARIES "${target_name}")
endfunction()

function(buildsupport_add_test target_name)
  add_executable(${target_name} ${ARGN})
  set_property(GLOBAL APPEND PROPERTY BUILDSUPPORT_TESTS "${target_name}")
endfunction()


#########################################################################################
# Should be executed last in your top CMakeLists.txt to perform some final configuration
# when all targets have already been registered.
function(buildsupport_perform_final_configuration)
  get_property(application_target_names GLOBAL PROPERTY BUILDSUPPORT_APPLICATIONS)
  get_property(library_target_names GLOBAL PROPERTY BUILDSUPPORT_LIBRARIES)
  get_property(test_target_names GLOBAL PROPERTY BUILDSUPPORT_TESTS)
  
  # Perform final configurations on each target. Only apply function if the given functionallity is in use.
  foreach(target_name ${application_target_names} ${library_target_names} ${test_target_names})
  
  endforeach()
endfunction()

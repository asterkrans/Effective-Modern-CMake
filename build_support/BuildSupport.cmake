# 
# Build Support
#
# Simplifies the setup of a build system for C and C++ projects using modern CMake.
#

cmake_minimum_required(VERSION 3.15)
include_guard(GLOBAL)

include(BuildSupport/BuildOptions)


#########################################################################################
# Include optional features to use.
# 
# Features implements one or more of these functions:
# - buildsupport_internal_xxxx_configure(target):
#        Executed to configure target right after target was created
# - buildsupport_internal_xxxx_final_configure():
#        Executed to do configurations that need to be performed last in the configuration process.
#
# A variable buildsupport_internal_xxx_enable controls if feature is enabled.
# If the target is not enabled, including and calling the configure functions should not do anything.

option(PRODUCTION_BUILD "Set this in production builds to disable some development features in the build support." OFF)

set(buildsupport_internal_install_enable ON)
set(buildsupport_internal_stripdebuginfo_enable ON)

if(NOT ${PRODUCTION_BUILD})
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE STRING "Export compile commands." FORCE)
  set(buildsupport_internal_ccache_enable ON)
  set(buildsupport_internal_runexecutable_enable ON)
  set(buildsupport_internal_testing_enable ON)
  set(buildsupport_internal_clangtidy_enable ON)
endif()

include(BuildSupport/Install)
include(BuildSupport/StripDebugInfo)
include(BuildSupport/Ccache)
include(BuildSupport/RunExecutable)
include(BuildSupport/Testing)
include(BuildSupport/ClangTidy)


#########################################################################################
# CMake standard functions "overriden" to add some more value.

function(buildsupport_add_executable target_name)
  add_executable(${target_name} ${ARGN})
  buildsupport_internal_stripdebuginfo_configure(${target_name})
  buildsupport_add_run_target(${target_name})
  
  set_property(GLOBAL APPEND PROPERTY BUILDSUPPORT_APPLICATIONS "${target_name}")
endfunction()

function(buildsupport_add_library target_name)
  add_library(${target_name} ${ARGN})
  buildsupport_internal_stripdebuginfo_configure(${target_name})
  
  set_property(GLOBAL APPEND PROPERTY BUILDSUPPORT_LIBRARIES "${target_name}")
endfunction()

if(${buildsupport_internal_testing_enable})
  function(buildsupport_add_test target_name)
    add_executable(${target_name} ${ARGN})
    buildsupport_internal_stripdebuginfo_configure(${target_name})
    buildsupport_internal_testing_configure(${target_name})
    
    set_property(GLOBAL APPEND PROPERTY BUILDSUPPORT_TESTS "${target_name}")
  endfunction()
  
else()
  # Testing not enabled.
  function(buildsupport_add_test target_name)
  endfunction()
endif()

#########################################################################################
# Should be executed last in your top CMakeLists.txt to perform some final configuration
# when all targets have already been registered.
function(buildsupport_perform_final_configuration)
  # QualityAssurance:
  # - Verify that all executables are installed.
  # - Verify that all non-imported targets are listed in BUILDSUPPORT_*.
  # TODO!!!



  get_property(application_target_names GLOBAL PROPERTY BUILDSUPPORT_APPLICATIONS)
  get_property(library_target_names GLOBAL PROPERTY BUILDSUPPORT_LIBRARIES)
  get_property(test_target_names GLOBAL PROPERTY BUILDSUPPORT_TESTS)
  
  buildsupport_internal_clangtidy_final_configure()
  
  # Perform final configurations on each target.
  foreach(target_name ${application_target_names} ${library_target_names} ${test_target_names})
    
  endforeach()
endfunction()

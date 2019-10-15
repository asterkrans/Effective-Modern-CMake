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
# Features implement this function:
# - buildsupport_internal_xxxx_configure(target):
#        Executed to configure target right after target was created
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
  buildsupport_internal_clangtidy_configure(${target_name})
  
  set_property(GLOBAL APPEND PROPERTY BUILDSUPPORT_APPLICATIONS "${target_name}")
endfunction()

function(buildsupport_add_library target_name)
  add_library(${target_name} ${ARGN})
  buildsupport_internal_stripdebuginfo_configure(${target_name})
  buildsupport_internal_clangtidy_configure(${target_name})
  
  set_property(GLOBAL APPEND PROPERTY BUILDSUPPORT_LIBRARIES "${target_name}")
endfunction()


function(buildsupport_add_test target_name)
  add_executable(${target_name} ${ARGN})
  buildsupport_internal_stripdebuginfo_configure(${target_name})
  buildsupport_internal_clangtidy_configure(${target_name})
  buildsupport_internal_testing_configure(${target_name})
  
  set_property(GLOBAL APPEND PROPERTY BUILDSUPPORT_TESTS "${target_name}")
endfunction()

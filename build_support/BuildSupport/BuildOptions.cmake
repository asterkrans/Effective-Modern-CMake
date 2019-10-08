#########################################################################################
# Build configurations. Modify to fit your needs.

# Set build type to Release if not defined.
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
endif()

# Supported build configurations, for easier selection and verification.
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Release" "Debug")

#########################################################################################
# Build options for the configurations. Modify to fit your needs.

# No extra flags for release builds. Use configuration from toolchain as is.
set(CMAKE_CXX_FLAGS_RELEASE "" CACHE STRING "Flags used by the C++ compiler." FORCE)
set(CMAKE_C_FLAGS_RELEASE "" CACHE STRING "Flags used by the C compiler." FORCE)

# Debug flags.
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0" CACHE STRING "Flags used by the C++ compiler.")
set(CMAKE_C_FLAGS_DEBUG "-g -O0" CACHE STRING "Flags used by the C compiler.")


#########################################################################################
# Validation

# Validate build configurations.
function(buildsupport_buildoptions_internal_validate_build_types)
  get_property(supported_cmake_build_types CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS)
  list(FIND supported_cmake_build_types ${CMAKE_BUILD_TYPE} is_valid_build_type)
  if(${is_valid_build_type} EQUAL -1)
    string (REPLACE ";" " " supported_cmake_build_types_str "${supported_cmake_build_types}")
    message(FATAL_ERROR "Invalid CMAKE_BUILD_TYPE. Options are: ${supported_cmake_build_types_str}.")
  endif()
endfunction()
buildsupport_buildoptions_internal_validate_build_types()

# Make sure project() was not called before buildsupport was included.
# We want to be able to set default values to the CMAKE_XXX_FLAGS_YYYY above without needing to do FORCE.
# If projet() is run brefore, the variables are already initiated. It FORCE is used it will not be possible
# to override them on command line or by modifying cache (e.g. with ccmake).
if(DEFINED PROJECT_NAME)
  message(FATAL_ERROR "Buildsupport must be included after cmake_minimum_required() but before project() is called in the root CMakeLists.txt file.")
endif()

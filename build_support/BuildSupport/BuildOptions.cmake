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
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0" CACHE STRING "Flags used by the C++ compiler." FORCE)
set(CMAKE_C_FLAGS_DEBUG "-g -O0" CACHE STRING "Flags used by the C compiler." FORCE)


#########################################################################################
# Validation of build configurations.

function(internal_validate_build_types)
  get_property(supported_cmake_build_types CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS)
  list(FIND supported_cmake_build_types ${CMAKE_BUILD_TYPE} is_valid_build_type)
  if(${is_valid_build_type} EQUAL -1)
    string (REPLACE ";" " " supported_cmake_build_types_str "${supported_cmake_build_types}")
    message(FATAL_ERROR "Invalid CMAKE_BUILD_TYPE. Options are: ${supported_cmake_build_types_str}.")
  endif()
endfunction()
internal_validate_build_types()

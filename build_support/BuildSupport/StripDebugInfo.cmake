#
# This strips off debug info from binaries.
# If you are remote debugging, the debug info is not needed on target - only on native host.
# Stripping it off enhances transfer time and storage usage.
#
# When building for production, you may have other ways of handeling the stripping.
# For example Yocto takes care of this in a build task.
#

# TODO: add_custom_target instead? Can be done in final_config? Eller risk att man gör extra strip genom att bygga strip-appl?

if(buildsupport_internal_stripdebuginfo_enable)
  function(buildsupport_internal_stripdebuginfo_configure target_name)
    get_property(target_type TARGET ${target_name} PROPERTY TYPE)
    if(target_type IN_LIST "STATIC_LIBRARY;SHARED_LIBRARY;EXECUTABLE")
      set(target_file "$<TARGET_FILE:${target_name}>")
      add_custom_command(
        TARGET ${target_name}
        POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} --only-keep-debug ${target_file} ${target_file}.debug
        COMMAND ${CMAKE_OBJCOPY} --strip-unneeded  ${target_file} ${target_file}
        COMMAND ${CMAKE_OBJCOPY} --add-gnu-debuglink=${target_file}.debug ${target_file}
      )
    endif()
  endfunction()
  
else()
  # Functionallity not enabled.
  function(buildsupport_stripdebuginfo_configure target_name)
  endfunction()
endif()

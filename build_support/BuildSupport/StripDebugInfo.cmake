#
# This strips off debug info from binaries.
# If you are remote debugging, the debug info is not needed on target - only on native host.
# Stripping it off enhances transfer time and storage usage.
#
# When building for production, you may have other ways of handeling the stripping.
# For example Yocto takes care of this in a build task.
#

set(buildsupport_stripdebuginfo_enabled TRUE)

function(buildsupport_stripdebuginfo_configure target_name)
  set(target_file "$<TARGET_FILE:${target_name}>")
  add_custom_command(
    TARGET ${target_name}
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} --only-keep-debug ${target_file} ${target_file}.debug
    COMMAND ${CMAKE_OBJCOPY} --strip-unneeded  ${target_file} ${target_file}
    COMMAND ${CMAKE_OBJCOPY} --add-gnu-debuglink=${target_file}.debug ${target_file}
  )
endfunction()
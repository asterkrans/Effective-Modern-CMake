
# TODO: Kolla CROSSCOMPILING_EMULATOR ihop med add_custom_target

if(buildsupport_internal_runexecutable_enable)
                     
  function(buildsupport_add_run_target target_name)
    cmake_parse_arguments(ARG "" "" "ARGUMENTS" ${ARGN})
    add_custom_target(run-${target_name}
      COMMAND ./${target_name} ${ARG_ARGUMENTS}  # Todo: get binary name from target?
      DEPENDS ${target_name}
    )
  endfunction()

else()
  # Functionallity not enabled.
  function(buildsupport_add_run_target target_name)
  endfunction()
endif()


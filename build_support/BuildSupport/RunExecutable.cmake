
if(buildsupport_internal_runexecutable_enable)
                     
  function(buildsupport_add_run_target(target_name)
    cmake_parse_arguments(ARG "" "" "ARGUMENTS" ${ARGN})
    message(FATAL_ERROR "Oj da ${ARG_ARGUMENTS}"
    add_custom_target(run-${target_name}
      COMMAND ./${target_name} ${ARG_ARGUMENTS}
      DEPENDS ${target_name}
    )
  endfunction()
endif()

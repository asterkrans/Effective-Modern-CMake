
if(buildsupport_internal_testing_enable)
  enable_testing()

  # Just as the built-in test target, but with --output-on-failure enabled.
  add_custom_target(reg-test
                    COMMAND ${CMAKE_CTEST_COMMAND} --force-new-ctest-process --output-on-failure)
                    
  function(buildsupport_internal_testing_configure target_name)
    add_test(NAME ${target_name} COMMAND ${target_name})
    
    add_custom_target(test-${target_name}
      COMMAND ./${target_name}
      DEPENDS ${target_name}
    )
  endfunction()
  
  
else()
  # Functionallity not enabled.
  function(buildsupport_internal_testing_configure target_name)
  endfunction()
endif()

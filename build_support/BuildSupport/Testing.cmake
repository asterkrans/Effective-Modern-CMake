
enable_testing()


set(test_cmd "reg-test")
add_custom_target(${test_cmd}
                  COMMAND ${CMAKE_CTEST_COMMAND} --force-new-ctest-process --output-on-failure)

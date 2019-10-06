

find_program(CCACHE ccache)

if(CCACHE)
  set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE})
else()
  message(WARNING "Ccache was not found.")
endif()

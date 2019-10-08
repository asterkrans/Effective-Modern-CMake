
if(buildsupport_internal_ccache_enable)

  find_program(CCACHE ccache)
  mark_as_advanced(CCACHE)
  
  if(CCACHE)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE})
  else()
    message(WARNING "Ccache was not found.")
  endif()
  
endif()

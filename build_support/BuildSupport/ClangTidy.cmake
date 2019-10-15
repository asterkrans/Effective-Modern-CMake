#
# Add Clang Tidy targets.
#

set(BUILDSUPPORT_DIR ${CMAKE_CURRENT_LIST_DIR})

if(buildsupport_internal_clangtidy_enable)

  set(BUILDSUPPORT_CLANGTIDY_CHECKS "*") # Configure this!
  
  function(buildsupport_internal_clangtidy_init)
    # We need to add builtin -isystem header paths, to get same setup as your compiler:
    # Should we use builtin defines too?
    # Should it not be enough to set the sysroot, and select -stdlib=libstdc++ instead of libc++?
    execute_process(COMMAND bash -c "${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ARG1} -xc++ -E -P -Wp,-v /dev/null 2>&1 | grep -e '^ '"
                    OUTPUT_VARIABLE compiler_builtin_includes)
    string(REPLACE "\n" ";" compiler_builtin_includes "${compiler_builtin_includes}")
    list(TRANSFORM compiler_builtin_includes STRIP)
    list(REMOVE_ITEM compiler_builtin_includes "")
    list(TRANSFORM compiler_builtin_includes PREPEND "-isystem;")
    list(JOIN compiler_builtin_includes " " compiler_builtin_includes_str)
    set(BUILDSUPPORT_COMPILER_BUILTIN_INCLUDES ${compiler_builtin_includes_str} PARENT_SCOPE)
  endfunction()
  buildsupport_internal_clangtidy_init()
  
  
  function(buildsupport_internal_clangtidy_configure target_name)
    if(NOT TARGET tidy)          
      add_custom_target(configure-tidy DEPENDS ${CMAKE_BINARY_DIR}/clang-tidy/CMakeCache.txt)
      add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/clang-tidy/CMakeCache.txt
                         DEPENDS ${CMAKE_BINARY_DIR}/compile_commands.json
                         COMMAND ${BUILDSUPPORT_DIR}/generate_tidy_cmake.py
                         COMMAND ${CMAKE_COMMAND} -Hclang-tidy/ -Bclang-tidy/
                             -DBUILDSUPPORT_COMPILER_BUILTIN_INCLUDES=${BUILDSUPPORT_COMPILER_BUILTIN_INCLUDES}
                             -DBUILDSUPPORT_CLANGTIDY_CHECKS=modernize-*
                         WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                         VERBATIM)
                         
    add_custom_target(tidy
                      DEPENDS ${CMAKE_BINARY_DIR}/clang-tidy/CMakeCache.txt
                      COMMAND make -j4 -C clang-tidy tidy
                      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                      VERBATIM)
      add_dependencies(tidy configure-tidy)
    endif()
    
    add_custom_target(tidy-${target_name}
                      DEPENDS ${CMAKE_BINARY_DIR}/clang-tidy/CMakeCache.txt
                      COMMAND make -j4 -C clang-tidy tidy-${target_name}
                      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                      VERBATIM)
    add_dependencies(tidy-${target_name} configure-tidy)
    
    # Add dependencies to link libraries.
    # Uncomment this if you like all linked targets to be analysed as well.
    # Note that this could cause massive parallelization due to multiple sub-make-calls.
    #get_property(link_libraries TARGET ${target_name} PROPERTY LINK_LIBRARIES)
    #foreach(link_library ${link_libraries})
    #  if(TARGET tidy-${link_library})
    #    add_dependencies(tidy-${target_name} tidy-${link_library})
    #  endif()
    #endforeach()
     
  endfunction()


else()
  # Functionallity not enabled.
  function(buildsupport_internal_clangtidy_configure target_name)
  endfunction()
endif()

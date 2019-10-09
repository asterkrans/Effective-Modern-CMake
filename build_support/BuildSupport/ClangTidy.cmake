#
# Add Clang Tidy targets.
#

# TODO: Should find() clang-tidy.

set(TIDY_CHECKS "*") # Configure this!
set(CCACHE_TIDY_WRAPPER ${CMAKE_CURRENT_LIST_DIR}/ccache_wrapper_tidy.sh)

if(buildsupport_internal_clangtidy_enable)
  function(buildsupport_internal_clangtidy_final_configure)
  
    add_custom_target(tidy)

    get_property(application_target_names GLOBAL PROPERTY BUILDSUPPORT_APPLICATIONS)
    get_property(library_target_names GLOBAL PROPERTY BUILDSUPPORT_LIBRARIES)
    get_property(test_target_names GLOBAL PROPERTY BUILDSUPPORT_TESTS)
    
    foreach(buildtarget_name ${application_target_names} ${library_target_names} ${test_target_names})
      set(tidytarget_name "tidy-${buildtarget_name}")
      add_custom_target(${tidytarget_name})
      add_dependencies(tidy ${tidytarget_name})
      
      # We assume same compile options for all files on target. It's possible to read the SOURCE property
      # instead if this does not hold true.
      get_property(compile_options TARGET ${buildtarget_name} PROPERTY COMPILE_OPTIONS)
      # NOTE: If using gcc toolchain, you might need to remove compile options not supported by clang compiler here.
      
      # If cross-compiling, you might need to add builtin -isystem header paths also, to get same setup as your compiler:
      # TODO: Get includes using e.g. $CXX -xc++ -E -P -Wp,-v /dev/null 2>&1 | grep -e "^ "
      
      list(APPEND compile_options "-Wall" "-Wextra") # Tidy clang-diagnostic-* checks relies on -W flags. Enable what you need.
      list(JOIN compile_options " " compile_options_str)
      
      get_property(source_names TARGET ${buildtarget_name} PROPERTY SOURCES)
      get_property(source_dir TARGET ${buildtarget_name} PROPERTY SOURCE_DIR)
      foreach(source_name ${source_names})
      
        if(NOT IS_ABSOLUTE ${source_name})
          set(full_source_path "${source_dir}/${source_name}")
        endif()
        
        # TODO: Verify source_name could not contain path! Strip it.  
        set(tidy_fixes_file "${buildtarget_name}-${source_name}.yaml")
        
        
        
        # NOTE: You can use --header-filter=(/path1|/path2) to filter header directories.
        set(tidy_args "--system-headers=0;--export-fixes=${tidy_fixes_file};--checks=${TIDY_CHECKS}")
      
        if(CCACHE)
          # CCACHE expects a compiler call. We use --ccache-skip to make ccache skip non-compiler arguments,
          # and we add -o and -c options. See ccache_wrapper_tidy.sh for details.
          list(TRANSFORM tidy_args PREPEND "--ccache-skip;")
          set(command "${CCACHE}" "${CCACHE_TIDY_WRAPPER}" ${tidy_args} -c ${full_source_path} --ccache-skip -- -o ${tidy_fixes_file} ${compile_options_str})
        else()
          set(command "clang-tidy" ${tidy_args} ${full_source_path} ${ccache_output_file} ${compile_options_str})
        endif()
           
        message("Command is: ${command}")
        add_custom_command(TARGET ${tidytarget_name}
                           COMMAND ${command}
        )
      endforeach()
    endforeach()
    
    
  endfunction()
  
else()
  # Functionallity not enabled.
  function(buildsupport_internal_clangtidy_final_configure)
  endfunction()
endif()

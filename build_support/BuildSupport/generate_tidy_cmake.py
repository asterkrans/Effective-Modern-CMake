#!/usr/bin/env python3
import errno
import os
import re
import subprocess
import sys

scriptdir = os.path.dirname(os.path.realpath(__file__))

def read_compile_commands():
    """Read commands from CMake generated file compile_commands.json.
       Target name, compiler arguments, and source file name are extracted."""
    match_start = '^ *"command":\ *"'
    match_compiler = '[^ ]* *'
    match_compiler_args = '(.*?)(?= *-o )'  # All compiler args before -o.
    match_target_name_from_object_path = '-o CMakeFiles/(.*?)(?=.dir)'
    match_source_file = '[^ ]*?(?= -c ) -c ([^"]*)",'
    
    command_regexp = re.compile(match_start + match_compiler + match_compiler_args + match_target_name_from_object_path + match_source_file)
    
    commands = []
    with open('compile_commands.json', 'r') as infile:
        for line in infile:
            if line.lstrip().startswith('"command"'):
                match = command_regexp.match(line)
                if match:
                    command = {'compiler_flags': match.group(1),
                               'target': match.group(2),
                               'source': match.group(3)}
                    commands.append(command)
                else:
                    print("Error: Could not parse command entry in compile_commands.json.", file=sys.stderr)
                    exit(1)
    return commands


def extract_targets_from_compile_commands():
    
    compile_commands = read_compile_commands()
    targets = dict()
    for command in compile_commands:
        target = targets.setdefault(command['target'])
        if not target:
            # Target did not exist yet. Create.
            
            compiler_flags = command['compiler_flags']
            
            # You might need to modify this to fit your target.
            compiler_flags = re.sub(r'-march=[^ ]*', '-target arm-linux-gnu', compiler_flags)
            
            compiler_flags = compiler_flags.split()
            
            # These are used to resolve implicit include dependencies.
            # TODO: Should also add any (non-builtin) -isystem include.
            include_dirs = [flag[2:] for flag in compiler_flags if flag.startswith('-I')]
            
            target = {
                'name': command['target'],
                'compiler_flags': compiler_flags,
                'include_dirs': include_dirs,
                'sources': []
            }
            targets[command['target']] = target
    
        target['sources'].append(command['source'])
    return list(targets.values())


def get_tidy_command(source, output_files_prefix, fixes_file, compiler_flags):
    tidy_args = '--system-headers=0 --export-fixes={fixes_file} --checks=${{BUILDSUPPORT_CLANGTIDY_CHECKS}} {source}'.format(fixes_file=fixes_file, source=source)
    
    command_wrapper = os.path.join(scriptdir, 'command_wrapper.sh')
    
    return ' '.join([command_wrapper, output_files_prefix, 'clang-tidy', tidy_args, '--', '${BUILDSUPPORT_COMPILER_BUILTIN_INCLUDES_LIST}', compiler_flags])


def main():
    
    def create_dir_and_enter(name):
        try:
            os.makedirs(name)
        except OSError as e:
            if e.errno != errno.EEXIST:
                raise
        os.chdir(name)
    
    targets = extract_targets_from_compile_commands()
    
    
    tidy_builddir = "clang-tidy"
    create_dir_and_enter(tidy_builddir)

    with open('CMakeLists.txt', 'w') as outfile:
        outfile.write("""\
cmake_minimum_required(VERSION 3.5)
project(ClangTidyTargets LANGUAGES CXX)
string(REPLACE " " ";" BUILDSUPPORT_COMPILER_BUILTIN_INCLUDES_LIST "${BUILDSUPPORT_COMPILER_BUILTIN_INCLUDES}")
""")
        
        for target in targets:
            output_files_prefixes = [(target['name'] + "-" + source).replace(os.path.sep, '-') for source in target['sources']]
            exitcode_files = [prefix + '_exitcode.txt' for prefix in output_files_prefixes]
            
            outfile.write("""\n
add_custom_target(tidy-{name}
                  DEPENDS {exitcode_files})
set_property(TARGET tidy-{name} PROPERTY INCLUDE_DIRECTORIES {include_directories})
""".format(name=target['name'],
           include_directories='"' + ';'.join(target['include_dirs']) + '"',
           exitcode_files=' '.join(exitcode_files)))

            for source in target['sources']:
                output_files_prefix = (target['name'] + '-' + source).replace(os.path.sep, '-')
                
                compiler_flags = ' '.join(target['compiler_flags'])
                
                tidy_fixes_file = output_files_prefix + ".yaml"
                tidy_command = get_tidy_command(source, output_files_prefix, tidy_fixes_file, compiler_flags)
                
                exitcode_file = output_files_prefix + '_exitcode.txt'
                
                outfile.write("""
add_custom_command(TARGET tidy-{name}
                   POST_BUILD
                   DEPENDS {exitcode_file}
                   COMMAND {command_printer} {output_files_prefix}
                   USES_TERMINAL
                   VERBATIM)

add_custom_command(OUTPUT {exitcode_file}
                   IMPLICIT_DEPENDS CXX {source}
                   COMMAND {tidy_command}
                   COMMENT "clang-tidy {source}"
                   VERBATIM)
""".format(name=target['name'],
           exitcode_file=exitcode_file,
           command_printer=os.path.join(scriptdir, 'command_printer.sh'),
           output_files_prefix=output_files_prefix,
           source=source,
           tidy_command=tidy_command))

        # Generate a tidy target that runs tidy on everything.        
        all_targets = ' '.join(['tidy-' + target['name'] for target in targets])
        all_fixes_files = ' '.join([(target['name'] + "-" + source).replace(os.path.sep, '-') + '.yaml' for source in target['sources'] for target in targets])
                
        outfile.write("""
add_custom_target(tidy)
add_dependencies(tidy {all_targets})

add_custom_target(tidy-apply-fixes
                  COMMAND ${{CMAKE_COMMAND}} -E make_directory fixits/
                  COMMAND ${{CMAKE_COMMAND}} -E copy {all_fixes_files} fixits/
                  COMMAND clang-apply-replacements fixits/)
add_dependencies(tidy-apply-fixes tidy)
""".format(all_targets=all_targets, all_fixes_files=all_fixes_files))



if __name__ == "__main__" :
    main()

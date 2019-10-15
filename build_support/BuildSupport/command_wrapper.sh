#!/usr/bin/env sh
# command_wrapper.sh output_files_prefix command [command arguments]...
#
# Will execute command and save stderr and exit code to files.
#
output_files_prefix="$1"
shift

"$@" 1> "${output_files_prefix}_stdout.txt" 2> "${output_files_prefix}_stderr.txt"
echo $? >    "${output_files_prefix}_exitcode.txt.tmp"
mv "${output_files_prefix}_exitcode.txt.tmp" "${output_files_prefix}_exitcode.txt"

#!/usr/bin/env sh
# command_printer.sh output_files_prefix
#
# Will print output from previously executed command.
#
output_files_prefix="$1"

cat "${output_files_prefix}_stderr.txt" 1>&2
cat "${output_files_prefix}_stdout.txt"
exit `cat "${output_files_prefix}_exitcode.txt"`

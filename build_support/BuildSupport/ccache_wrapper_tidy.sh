#!/usr/bin/env bash
# Ccache wrapper for invoking Clang-Tidy through Ccache.
#
# To use this, you will need to:
#  - Execute this script through ccache: "ccache ccache_wrapper_tidy.sh ..."
#  - Add --ccache-skip before every tidy argument that is not a compiler flag.
#  - Add a -c flag before the source file(s) to imitate a compiler. (Args removed by this script.)
#  - Add a -o [filename] flag for the output file if any. (That is the fixes file. Args removed by this script.)
args=()
while (( "$#" )); do
  args+=("$1")
  shift
  if [[ "$1" == "-o" ]]; then
    shift
    shift
  fi
  if [[ "$1" == "-c" ]]; then
    shift
  fi
done
echo "*********************"
if [ "${VERBOSE}" -ne "0" ]; then
  echo Executing clang-tidy with arguments: "${args[@]}"
fi
exec clang-tidy "${args[@]}"

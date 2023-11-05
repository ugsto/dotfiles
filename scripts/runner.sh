#!/usr/bin/env sh

set -ex

while getopts ":t:p:" opt; do
  case $opt in
    t) TARGET="$OPTARG"
    ;;
    p) PROCESS="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ -z "$TARGET" ] || [ -z "$PROCESS" ]; then
  echo "Both -t and -p arguments are required."
  exit 1
fi

BASEDIR=$(dirname "$0")

if [ ! -f "$BASEDIR/$TARGET.$PROCESS.sh" ]; then
  echo "File $TARGET.$PROCESS.sh not found in the current directory."
  exit 1
fi


sh "$BASEDIR/$TARGET.$PROCESS.sh"

#!/bin/sh
echo -ne '\033c\033]0;cell\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/cell.x86_64" "$@"

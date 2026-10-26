#!/usr/bin/env sh
set -eu
exec sh "$(dirname "$0")/build_demo.sh" web --base-href /tdesign_example/ --source-maps "$@"

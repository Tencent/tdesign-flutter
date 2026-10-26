#!/usr/bin/env sh
set -eu
cd "$(dirname "$0")/.."
dart ../tool/write_demo_build_info.dart
flutter build "$@"

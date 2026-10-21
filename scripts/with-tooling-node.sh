#!/usr/bin/env bash
# CNB Flutter images lack Node; prepare a pinned runtime only for tooling commands.
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Usage: bash scripts/with-tooling-node.sh command [arguments...]" >&2
  exit 64
fi

version=22.23.3
if [[ "$(node --version 2>/dev/null || true)" == "v$version" ]]; then
  exec "$@"
fi

# Checksums from https://nodejs.org/dist/v22.23.3/SHASUMS256.txt.
case "$(uname -s)-$(uname -m)" in
  Linux-x86_64)
    architecture=x64
    checksum=df450af89261115ef9f9e3830c3eeb2cc9213b63c720b1af623cb5dcbe2e02de
    ;;
  Linux-aarch64|Linux-arm64)
    architecture=arm64
    checksum=a44aeb94849a299b22df10b9e622ec2f605c2183501bc40590705131de7c740f
    ;;
  *) echo "Tooling Node bootstrap supports Linux x64/arm64 only" >&2; exit 69 ;;
esac

cache="${TOOLING_NODE_CACHE:-${HOME}/.cache/tdesign-tooling-node}"
runtime="$cache/node-v$version-linux-$architecture"
if [[ ! -x "$runtime/bin/node" ]]; then
  mkdir -p "$cache"
  temporary="$(mktemp -d "$cache/download.XXXXXX")"
  trap 'rm -rf "$temporary"' EXIT
  archive="node-v$version-linux-$architecture.tar.xz"
  curl --fail --location --retry 3 --connect-timeout 15 --max-time 180 \
    --output "$temporary/$archive" "https://nodejs.org/dist/v$version/$archive"
  printf '%s  %s\n' "$checksum" "$temporary/$archive" | sha256sum --check
  tar -xJf "$temporary/$archive" -C "$temporary"
  mv "$temporary/node-v$version-linux-$architecture" "$runtime"
  rm -rf "$temporary"
  trap - EXIT
fi

if [[ "$("$runtime/bin/node" --version)" != "v$version" ]]; then
  echo "Cached tooling Node version does not match v$version" >&2
  exit 1
fi
export PATH="$runtime/bin:$PATH"
echo "Tooling Node: $(node --version)"
exec "$@"

#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT/tdesign-site"
pnpm run site --mode=preview

cd "$ROOT/tdesign-component/example"
flutter build web -t ./lib/main.dart --release --base-href /flutter/example/

mkdir -p "$ROOT/tdesign-site/_site/flutter/example"
cp -R build/web/* "$ROOT/tdesign-site/_site/flutter/example"

cd "$ROOT/tdesign-site/site"
npx vite preview --mode=preview --port 8686 --host 0.0.0.0

#!/usr/bin/env bash
set -euo pipefail

# 仅预览模式（onlyPreview）下的预览构建与启动脚本。
# 业务服务必须监听 8686 端口（CNB 仅预览模式硬约束）。
# 注意：本脚本以 `daemon: true` 方式运行于后台；失败时不会中断流水线日志，
# 因此务必确保每一步都能成功，否则 8686 服务不会启动、预览无法打开。

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLUTTER_DIR="$ROOT/tdesign-component/example"
SITE_DIR="$ROOT/tdesign-site"
SITE_OUT="$SITE_DIR/_site"

echo "[preview] step 1/5: install tdesign-site dependencies..."
cd "$SITE_DIR"
pnpm install

echo "[preview] step 2/5: build tdesign-site (mode=preview) -> _site..."
pnpm run site --mode=preview

echo "[preview] step 3/5: build flutter example web..."
cd "$FLUTTER_DIR"
flutter pub get
flutter build web -t ./lib/main.dart --release --base-href /flutter/example/

echo "[preview] step 4/5: embed flutter example into site output..."
mkdir -p "$SITE_OUT/flutter/example"
cp -R build/web/* "$SITE_OUT/flutter/example"

echo "[preview] step 5/5: start static server on 8686 (root=$SITE_OUT)..."
cd "$ROOT"
exec dart run scripts/preview_server.dart "$SITE_OUT" 8686

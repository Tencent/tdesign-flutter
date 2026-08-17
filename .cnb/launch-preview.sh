#!/usr/bin/env bash
set -eu
# bash 支持 pipefail，捕获上游命令失败；POSIX sh（dash）不支持，仅 bash 下启用
if [ -n "${BASH_VERSION:-}" ]; then
  set -o pipefail
fi

# 仅预览模式下构建并启动静态服务（须监听 8686）。
# 本脚本以 daemon:true 后台运行，失败不会反映到流水线日志，故每一步须确保成功。

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLUTTER_DIR="$ROOT/tdesign-component/example"
SITE_DIR="$ROOT/tdesign-site"
SITE_OUT="$SITE_DIR/_site"

# 1. 构建站点
cd "$SITE_DIR"
pnpm install
pnpm run site --mode=preview

# 2. 构建 flutter example web
cd "$FLUTTER_DIR"
flutter pub get
flutter build web -t ./lib/main.dart --release --base-href /flutter/example/

# 3. 嵌入产物并启动静态服务（监听 8686）
mkdir -p "$SITE_OUT/flutter/example"
cp -R build/web/* "$SITE_OUT/flutter/example"
cd "$SITE_DIR/site"
pnpm exec vite preview --mode=preview --port 8686 --host 0.0.0.0

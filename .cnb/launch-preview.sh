#!/usr/bin/env bash
set -eu
# bash 支持 pipefail；POSIX sh（dash）不支持，仅 bash 下启用
if [ -n "${BASH_VERSION:-}" ]; then
  set -o pipefail
fi

# 仅预览模式下构建并启动静态服务（须监听 8686）。
# 关键：必须先占住 8686 端口通过平台的启动检测，再后台构建内容，避免检测超时。
# launch 以 daemon:true 运行，日志不直接进流水线，故统一落盘到 $SITE_OUT/preview.log，
# 由 stages 的「preview ready」阶段 tail 展示，便于定位构建问题。

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE_DIR="$ROOT/tdesign-site"
SITE_OUT="$SITE_DIR/_site"
FLUTTER_DIR="$ROOT/tdesign-component/example"
LOG="$SITE_OUT/preview.log"

mkdir -p "$SITE_OUT"
: >"$LOG"

# 1. 安装站点依赖（vite preview 依赖已安装的 vite）
cd "$SITE_DIR"
pnpm install

# 2. 立即后台启动 vite preview，先占住 8686 通过启动检测；vite 会按需提供 _site 内容
cd "$SITE_DIR/site"
nohup pnpm exec vite preview --mode=preview --port 8686 --host 0.0.0.0 >>"$LOG" 2>&1 &
echo "vite preview started on 8686 (pid $!)" >>"$LOG"

# 3. 后台构建站点与 flutter example 并嵌入 _site/flutter/example
(
  cd "$SITE_DIR"
  pnpm run site --mode=preview
  cd "$FLUTTER_DIR"
  flutter pub get
  flutter build web -t ./lib/main.dart --release --base-href /flutter/example/
  mkdir -p "$SITE_OUT/flutter/example"
  cp -R build/web/* "$SITE_OUT/flutter/example"
  echo "BUILD_DONE" >>"$LOG"
) >>"$LOG" 2>&1 &

# 4. 保持脚本作为守护进程存活（daemon:true），vite preview 持续提供预览
wait

#!/usr/bin/env bash
set -eu
# bash 支持 pipefail；POSIX sh（dash）不支持，仅 bash 下启用
if [ -n "${BASH_VERSION:-}" ]; then
  set -o pipefail
fi

# 仅预览模式下构建并启动预览（须监听 8686）。
# 策略：先用 Node.js 内置 HTTP 服务【立即】占住 8686 通过平台启动检测，
#       期间在后台构建站点与 Flutter Web；构建完成后退出 node 占位服务，
#       改用 vite preview 在 8686 端口常驻提供最终预览（含 SPA 路由与正确 MIME）。
# launch 以 daemon:true 运行，日志不直接进流水线，故统一落盘到 $SITE_OUT/preview.log，
# 由 stages 的「preview ready」阶段 tail 展示，便于定位构建问题。

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE_DIR="$ROOT/tdesign-site"
SITE_OUT="$SITE_DIR/_site"
FLUTTER_DIR="$ROOT/tdesign-component/example"
LOG="$SITE_OUT/preview.log"

mkdir -p "$SITE_OUT"
: >"$LOG"

# 1. 【关键】立即用 Node.js 内置 HTTP 服务占住 8686，通过平台启动检测。
#    构建期间仅返回占位页，等 vite preview 接管后再展示真实产物。
cd "$SITE_OUT"
nohup node -e '
const http = require("http");
http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  res.end("<html><body><h1>TDesign Flutter Preview</h1><p>构建中，请稍候刷新…</p></body></html>");
}).listen(8686, "0.0.0.0");
' >>"$LOG" 2>&1 &
NODE_PID=$!
echo "node placeholder server on 8686 (pid $NODE_PID)" >>"$LOG"

# 2. 后台安装站点依赖、构建站点与 flutter example 并嵌入 _site/flutter/example
(
  cd "$SITE_DIR"
  pnpm install
  pnpm run site -- --mode=preview
  cd "$FLUTTER_DIR"
  flutter pub get
  flutter build web -t ./lib/main.dart --release --base-href /flutter/example/
  mkdir -p "$SITE_OUT/flutter/example"
  cp -R build/web/* "$SITE_OUT/flutter/example"
  echo "BUILD_DONE" >>"$LOG"
) >>"$LOG" 2>&1 &
BUILD_PID=$!

# 3. 等待构建完成，随后退出 node 占位服务
wait "$BUILD_PID"
echo "build finished, stopping node placeholder (pid $NODE_PID)" >>"$LOG"
kill "$NODE_PID" 2>/dev/null || true

# 4. 改用 vite preview 在 8686 常驻提供最终预览。
#    site 以 --mode=preview 构建（base=/），而 vite@2.7.6 的 preview 固定按 production
#    解析（base=/flutter/），故必须用全局 --base / 覆盖，使预览在站点根路径可访问；
#    distDir 取 config.build.outDir=../_site，在 site 子目录执行以命中 vite.config.ts。
cd "$SITE_DIR/site"
nohup pnpm exec vite preview --base / --host 0.0.0.0 --port 8686 >>"$LOG" 2>&1 &
echo "vite preview server started on 8686 (pid $!)" >>"$LOG"

# 5. 保持脚本作为守护进程存活（daemon:true），vite preview 持续提供预览
wait

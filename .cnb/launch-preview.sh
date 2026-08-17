#!/usr/bin/env bash
set -eu
# bash 支持 pipefail；POSIX sh（dash）不支持，仅 bash 下启用
if [ -n "${BASH_VERSION:-}" ]; then
  set -o pipefail
fi

# 仅预览模式下构建并启动预览（须监听 8686）。
# 策略：用一个 Node 进程（.cnb/preview-server.js）从启动【一直常驻】8686，
#       期间在后台构建站点与 Flutter Web 到 $SITE_OUT。
#       服务进程从不 kill / 重启，平台对 8686 的转发始终稳定，杜绝
#       "先 node 占位、再换 vite preview"方案中因进程切换导致的转发失效问题。
#       preview-server.js 在构建前返回占位页（自动刷新），构建后实时提供
#       _site 静态文件（含 SPA fallback 与正确 MIME），无需重启即可生效。
# launch 以 daemon:true 运行，日志不直接进流水线，故统一落盘到 $SITE_OUT/preview.log，
# 由 stages 的「preview ready」阶段 tail 展示，便于定位构建问题。

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE_DIR="$ROOT/tdesign-site"
SITE_OUT="$SITE_DIR/_site"
FLUTTER_DIR="$ROOT/tdesign-component/example"
LOG="$SITE_OUT/preview.log"

mkdir -p "$SITE_OUT"
: >"$LOG"

# 1. 【关键】立即启动常驻的 Node 预览服务器占住 8686，通过平台启动检测。
#    该进程全程不退出，构建完成后自动开始提供真实产物。
cd "$SITE_OUT"
nohup node "$ROOT/.cnb/preview-server.js" "$SITE_OUT" 8686 "$LOG" >>"$LOG" 2>&1 &
SERVER_PID=$!
echo "preview server (pid $SERVER_PID) started on 8686" >>"$LOG"

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

# 3. 保持脚本作为守护进程存活（daemon:true）。
#    preview server 常驻 8686 提供预览，后台构建完成后即自动切换到真实产物。
#    此处仅等待构建完成，便于在日志中确认 BUILD_DONE；随后进入 wait 持续保活，
#    直到整个仅预览环境被关闭（keepAliveTimeout 兜底）。
wait "$BUILD_PID"
echo "build finished; preview server (pid $SERVER_PID) keeps serving on 8686" >>"$LOG"
# 显式等待 preview server，保证脚本（daemon:true）在服务存活期间不退出，
# 直到整个仅预览环境被关闭（keepAliveTimeout 兜底）。
wait "$SERVER_PID"

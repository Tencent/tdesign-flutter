#!/usr/bin/env bash
set -eu
# bash 支持 pipefail；POSIX sh（dash）不支持，仅 bash 下启用
if [ -n "${BASH_VERSION:-}" ]; then
  set -o pipefail
fi

# 仅预览模式下构建并启动预览（业务服务必须监听 8686）。
# 策略：用一个 Node 进程（.cnb/preview-server.js）从启动【一直常驻】8686，
#       期间在后台构建站点与 Flutter Web 到 $SITE_OUT。
#       preview-server.js 全程不 kill / 重启：构建前返回占位页（自动刷新），
#       构建完成后实时提供 _site 静态文件（含 SPA fallback 与正确 MIME），
#       平台对 8686 的转发始终稳定，彻底规避 "先占位、再换进程" 及
#       "依赖镜像预装 nginx 常驻" 方案中服务未监听导致的启动检测超时。
# launch 以 daemon:true 运行，日志不直接进流水线，故统一落盘到 /var/log/preview.log。
# stages 的「preview ready」阶段会持续跟随该日志直至出现 BUILD_DONE / BUILD_FAILED 标记，
# 把完整构建输出回显到流水线日志，便于定位构建问题。

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE_DIR="$ROOT/tdesign-site"
SITE_OUT="$SITE_DIR/_site"
FLUTTER_DIR="$ROOT/tdesign-component/example"
LOG="/var/log/preview.log"

mkdir -p "$SITE_OUT"
: >"$LOG"

# 1. 【关键】立即启动常驻的 Node 预览服务器占住 8686，通过平台启动检测。
#    该进程全程不退出，构建完成后自动开始提供真实产物。
nohup node "$ROOT/.cnb/preview-server.js" "$SITE_OUT" 8686 "$LOG" >>"$LOG" 2>&1 &
SERVER_PID=$!
echo "preview server (pid $SERVER_PID) started on 8686" >>"$LOG"

# 2. 后台安装站点依赖、构建站点与 flutter example 并嵌入 _site/flutter/example
#    构建成功写 BUILD_DONE、失败写 BUILD_FAILED，供「preview ready」阶段判定完成状态并回显日志。
#    run() 为每步打印明确的步骤标题、命令回显、退出码与耗时，任一步失败即中止后续步骤，
#    从而在 preview.log 中精确定位失败环节。
(
  set +e
  run() {
    local name="$1"; shift
    local cmd="$*"
    local start; start=$(date +%s)
    echo ""
    echo "===== [$name] @ $(date +%T) ====="
    echo "> $cmd"
    bash -c "$cmd"
    local rc=$?
    local dur=$(( $(date +%s) - start ))
    echo "--- [$name] exit=$rc, ${dur}s ---"
    return "$rc"
  }

  cd "$SITE_DIR"
  run "1/5 install site deps" "pnpm install" \
   && run "2/5 build site (--mode=preview)" "pnpm run site --mode=preview" \
   && ( cd "$FLUTTER_DIR" && run "3/5 flutter pub get" "flutter pub get" ) \
   && ( cd "$FLUTTER_DIR" && run "4/5 flutter build web" "flutter build web -t ./lib/main.dart --release --base-href /flutter/example/" ) \
   && run "5/5 embed example into site out" "mkdir -p '${SITE_OUT}/flutter/example' && cp -R '${FLUTTER_DIR}/build/web/'* '${SITE_OUT}/flutter/example'"
  BUILD_RC=$?

  if [ "$BUILD_RC" -eq 0 ]; then
    echo "BUILD_DONE" >>"$LOG"
  else
    echo "BUILD_FAILED" >>"$LOG"
  fi
  exit "$BUILD_RC"
) >>"$LOG" 2>&1 &
BUILD_PID=$!

# 3. 保持脚本作为守护进程存活（daemon:true）。
#    preview server 常驻 8686 提供预览，后台构建完成后即自动切换到真实产物。
#    显式等待 preview server，保证脚本在服务存活期间不退出，直到整个仅预览
#    环境被关闭（keepAliveTimeout 兜底）。
echo "[$(date +%T)] build started; preview server keeps serving on 8686" >>"$LOG"
wait "$BUILD_PID" || true
echo "[$(date +%T)] build finished; preview server (pid $SERVER_PID) keeps serving on 8686" >>"$LOG"
wait "$SERVER_PID"

#!/usr/bin/env bash
set -eu
# bash 支持 pipefail；POSIX sh（dash）不支持，仅 bash 下启用
if [ -n "${BASH_VERSION:-}" ]; then
  set -o pipefail
fi

# 仅预览模式下构建并启动预览（业务服务必须监听 8686）。
# 策略：复用 default-dev-env 镜像【预装并已配置好】的 nginx——配置已在
#       /etc/nginx/conf.d/default.conf：监听 8686、root=/usr/share/nginx/html、
#       SPA fallback 到 /index.html。本脚本只需【启动 nginx】占住 8686 通过平台
#       启动检测，再在后台构建站点与 Flutter Web 产物并复制到 /usr/share/nginx/html，
#       nginx 即时生效、全程不 kill / 重启，平台对 8686 的转发始终稳定。
#       构建期间镜像默认的占位页（自动刷新）即可作为过渡页，无需脚本额外写入。
# launch 以 daemon:true 运行，日志不直接进流水线，故统一落盘到 /var/log/preview.log。
# stages 的「preview ready」阶段会持续跟随该日志直至出现 BUILD_DONE / BUILD_FAILED 标记，
# 把完整构建输出回显到流水线日志，便于定位构建问题。

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE_DIR="$ROOT/tdesign-site"
SITE_OUT="$SITE_DIR/_site"
FLUTTER_DIR="$ROOT/tdesign-component/example"
WEB_ROOT="/usr/share/nginx/html"
LOG="/var/log/preview.log"

mkdir -p "$SITE_OUT" "$WEB_ROOT"
: >"$LOG"

# 1. 【关键】启动镜像预装的 nginx 占住 8686，通过平台启动检测。
#    default-dev-env 镜像已安装 nginx 且配置好监听 8686（root=/usr/share/nginx/html），
#    此处仅启动它；若已监听则跳过（幂等）。
if ! bash -c 'exec 3<>/dev/tcp/127.0.0.1/8686' 2>/dev/null; then
  echo "[$(date +%T)] starting nginx (镜像预装, root=$WEB_ROOT) on 8686..." >>"$LOG"
  nginx >>"$LOG" 2>&1 \
    || { echo "[$(date +%T)] nginx start failed" >>"$LOG"; echo "BUILD_FAILED" >>"$LOG"; exit 1; }
else
  echo "[$(date +%T)] nginx already listening on 8686" >>"$LOG"
fi
echo "[$(date +%T)] nginx serving $WEB_ROOT on 8686" >>"$LOG"

# 2. 后台安装站点依赖、构建站点与 flutter example 并嵌入 $SITE_OUT/flutter/example，
#    最终整体复制到 nginx 根目录 $WEB_ROOT（覆盖镜像默认占位页），nginx 即时生效。
#    构建成功写 BUILD_DONE、失败写 BUILD_FAILED，供「preview ready」阶段判定完成状态并回显日志。
#    run() 为每步打印明确的步骤标题、命令回显、退出码与耗时，任一步失败即中止后续步骤。
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
   && run "5/5 deploy to nginx root" "mkdir -p '${SITE_OUT}/flutter/example' && cp -R '${FLUTTER_DIR}/build/web/'* '${SITE_OUT}/flutter/example' && cp -R '${SITE_OUT}/.' '$WEB_ROOT'/"
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
#    nginx 常驻 8686 提供预览，后台构建完成后即自动切换到真实产物。
#    显式等待构建与 nginx，保证脚本在服务存活期间不退出，直到整个仅预览
#    环境被关闭（keepAliveTimeout 兜底）。
echo "[$(date +%T)] build started; nginx keeps serving $WEB_ROOT on 8686" >>"$LOG"
wait "$BUILD_PID" || true
echo "[$(date +%T)] build finished; nginx keeps serving $WEB_ROOT on 8686" >>"$LOG"
sleep infinity

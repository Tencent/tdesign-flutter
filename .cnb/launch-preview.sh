#!/usr/bin/env bash
set -eu
# bash 支持 pipefail；POSIX sh（dash）不支持，仅 bash 下启用
if [ -n "${BASH_VERSION:-}" ]; then
  set -o pipefail
fi

# 仅预览模式下构建并启动预览（default-dev-env 镜像预装 nginx 监听 8686）。
# 策略：镜像启动时 nginx 即常驻 8686（root=/usr/share/nginx/html），端口检测天然通过，
#       本脚本仅负责构建站点与 Flutter Web 产物并复制到 /usr/share/nginx/html，
#       nginx 静态服务即时生效、无需重启，彻底规避此前"占位->换进程"导致的转发漂移。
#       构建期间直接复用镜像预装的默认 index.html 占位页（自动刷新、避免空白/404），无需额外写入。
# launch 以 daemon:true 运行，日志不直接进流水线，故统一落盘到 /usr/share/nginx/html/preview.log。
# stages 的「preview ready」阶段会持续跟随该日志直至出现 BUILD_DONE / BUILD_FAILED 标记，
# 把完整构建输出回显到流水线日志，便于定位构建问题。

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE_DIR="$ROOT/tdesign-site"
SITE_OUT="$SITE_DIR/_site"
FLUTTER_DIR="$ROOT/tdesign-component/example"
WEB_ROOT="/usr/share/nginx/html"
LOG="$WEB_ROOT/preview.log"

mkdir -p "$SITE_OUT" "$WEB_ROOT"
: >"$LOG"

# 1. 确认 nginx 已监听 8686（镜像预装并随容器启动）；极端未启动时拉起，保证端口检测通过
if ! bash -c 'exec 3<>/dev/tcp/127.0.0.1/8686' 2>/dev/null; then
  echo "[$(date +%T)] nginx not listening on 8686 yet, starting nginx..." >>"$LOG"
  nginx >>"$LOG" 2>&1 || echo "[$(date +%T)] nginx start failed, check image config" >>"$LOG"
fi

# 2. 后台安装依赖、构建站点与 flutter example，并嵌入 _site/flutter/example
#    构建成功写 BUILD_DONE、失败写 BUILD_FAILED，供「preview ready」阶段判定完成状态并回显日志。
(
  set +e
  cd "$SITE_DIR"
  pnpm install
  pnpm run site --mode=preview
  cd "$FLUTTER_DIR"
  flutter pub get
  flutter build web -t ./lib/main.dart --release --base-href /flutter/example/
  mkdir -p "$SITE_OUT/flutter/example"
  cp -R build/web/* "$SITE_OUT/flutter/example"

  # 3. 将最终产物整体复制到 nginx 根目录（覆盖镜像默认占位页），nginx 即时生效
  cp -R "$SITE_OUT"/. "$WEB_ROOT"/
  BUILD_RC=$?
  if [ "$BUILD_RC" -eq 0 ]; then
    echo "BUILD_DONE" >>"$LOG"
  else
    echo "BUILD_FAILED" >>"$LOG"
  fi
  exit "$BUILD_RC"
) >>"$LOG" 2>&1 &
BUILD_PID=$!

# 4. 守护保活：等待构建完成（失败不退出，便于保留容器查看日志定位）；
#    随后常驻保活，避免 daemon 进程提前退出导致平台判定服务结束（keepAliveTimeout 兜底回收）。
wait "$BUILD_PID" || true
echo "[$(date +%T)] build finished; nginx serves $WEB_ROOT on 8686" >>"$LOG"
sleep infinity

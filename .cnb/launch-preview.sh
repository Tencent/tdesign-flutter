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
#       站点为 Vue Router HTML5 history 模式，脚本会覆盖 nginx 配置开启 SPA fallback
#       （try_files 回退 index.html）并 reload，使 /flutter/components/xxx 等深层路由可直访。
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
#    run() 为每步打印明确的步骤标题、命令回显、退出码与耗时，任一步失败即中止后续步骤，
#    从而在 preview.log 中精确定位失败环节，避免只看到 pnpm 安装等少量输出却不知后续进展。
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
   && run "5/5 deploy to nginx root" "mkdir -p '${SITE_OUT}/flutter/example' && cp -R '${FLUTTER_DIR}/build/web/'* '${SITE_OUT}/flutter/example' && cp -R '${SITE_OUT}/.' '${WEB_ROOT}/.'"
  BUILD_RC=$?

  # 4. 为 tdesign-site 配置 SPA fallback：站点使用 Vue Router HTML5 history 模式
  #    （createWebHistory），直接访问 /flutter/components/xxx 等深层路由时 nginx 找不到
  #    对应物理文件会返回 404，须用 try_files 回退到 index.html，由前端路由接管渲染。
  #    Flutter example 是纯静态产物（hash 路由），单独 location 精确命中、失败返回 404
  #    而非回退到站点首页，避免资源缺失时被 SPA 兜底掩盖。
  NGINX_CONF="/etc/nginx/conf.d/default.conf"
  cat >"$NGINX_CONF" <<'NGINX'
server {
    listen 8686;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    # Flutter Web 示例（静态产物，hash 路由），按物理文件提供
    location /flutter/example/ {
        try_files $uri $uri/ =404;
    }

    # tdesign-site SPA：深层路由回退到 index.html，由 Vue Router 接管
    location / {
        try_files $uri $uri/ /index.html;
    }
}
NGINX
  if nginx -t >>"$LOG" 2>&1; then
    nginx -s reload >>"$LOG" 2>&1 || echo "[$(date +%T)] nginx reload failed, check $NGINX_CONF" >>"$LOG"
  else
    echo "[$(date +%T)] nginx -t failed, keep existing config (SPA fallback NOT applied)" >>"$LOG"
  fi

  if [ "$BUILD_RC" -eq 0 ]; then
    echo "BUILD_DONE" >>"$LOG"
  else
    echo "BUILD_FAILED" >>"$LOG"
  fi
  exit "$BUILD_RC"
) >>"$LOG" 2>&1 &
BUILD_PID=$!

# 5. 守护保活：等待构建完成（失败不退出，便于保留容器查看日志定位）；
#    随后常驻保活，避免 daemon 进程提前退出导致平台判定服务结束（keepAliveTimeout 兜底回收）。
wait "$BUILD_PID" || true
echo "[$(date +%T)] build finished; nginx serves $WEB_ROOT on 8686" >>"$LOG"
sleep infinity

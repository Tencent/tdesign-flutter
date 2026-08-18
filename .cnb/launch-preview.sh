#!/usr/bin/env bash
set -eu
# bash 支持 pipefail；POSIX sh（dash）不支持，仅 bash 下启用
if [ -n "${BASH_VERSION:-}" ]; then
  set -o pipefail
fi

# 仅预览模式下构建并启动预览（业务服务必须监听 8686）。
# 策略：用 nginx 作为静态服务器，从启动【一直常驻】监听 8686（root 指向 $SITE_OUT），
#       期间在后台构建站点与 Flutter Web 产物并覆盖到 $SITE_OUT。
#       nginx 全程不 kill / 重启：构建前用占位 index.html 自动刷新，构建完成后
#       站点 index.html 与 /flutter/example 产物落地即被 nginx 实时提供（无需 reload），
#       平台对 8686 的转发始终稳定，彻底规避 "先占位、再换进程" 导致的服务未监听超时。
# 注意：default-dev-env 镜像并未预装/预启 nginx（此前依赖镜像预装导致启动检测超时），
#       因此脚本必须【主动安装并启动】nginx，立即占住 8686 通过平台启动检测。
# launch 以 daemon:true 运行，日志不直接进流水线，故统一落盘到 /var/log/preview.log。
# stages 的「preview ready」阶段会持续跟随该日志直至出现 BUILD_DONE / BUILD_FAILED 标记，
# 把完整构建输出回显到流水线日志，便于定位构建问题。

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE_DIR="$ROOT/tdesign-site"
SITE_OUT="$SITE_DIR/_site"
FLUTTER_DIR="$ROOT/tdesign-component/example"
LOG="/var/log/preview.log"
NGINX_CONF="/etc/nginx/conf.d/preview.conf"

mkdir -p "$SITE_OUT"
: >"$LOG"

# 1. 【关键】安装并启动 nginx 占住 8686，通过平台启动检测。
#    先写入占位 index.html，使 nginx 在构建前即可返回自动刷新的占位页；构建完成后
#    站点构建会覆盖 index.html、产物嵌入 /flutter/example，nginx 实时提供真实页面。
cat >"$SITE_OUT/index.html" <<'HTML'
<!DOCTYPE html><html lang="zh"><head><meta charset="utf-8">
<meta http-equiv="refresh" content="5"><title>TDesign Flutter Preview</title></head>
<body style="font-family:sans-serif;display:flex;align-items:center;justify-content:center;
height:100vh;margin:0;background:#f4f4f5;color:#333">
<div style="text-align:center"><h1>TDesign Flutter Preview</h1>
<p>构建中，请稍候自动刷新…</p></div></body></html>
HTML

# 1.1 安装 nginx（default-dev-env 镜像未预装；幂等，已安装则跳过）
if ! command -v nginx >/dev/null 2>&1; then
  echo "[$(date +%T)] installing nginx..." >>"$LOG"
  (export DEBIAN_FRONTEND=noninteractive
   apt-get update -y >>"$LOG" 2>&1
   apt-get install -y nginx >>"$LOG" 2>&1) \
    || { echo "[$(date +%T)] nginx install failed" >>"$LOG"; echo "BUILD_FAILED" >>"$LOG"; exit 1; }
else
  echo "[$(date +%T)] nginx already installed" >>"$LOG"
fi

# 1.2 写 nginx 配置：root 指向 $SITE_OUT，SPA fallback + Flutter example 精确命中
cat >"$NGINX_CONF" <<NGINX
server {
    listen 8686;
    server_name _;
    root $SITE_OUT;
    index index.html;

    # Flutter Web 示例（静态产物，hash 路由），按物理文件提供；缺失返回 404 而非回退站点首页
    location /flutter/example/ {
        try_files \$uri \$uri/ =404;
    }

    # tdesign-site SPA（Vue Router history 模式）：深层路由回退到 index.html，由前端路由接管
    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
NGINX

# 1.3 启动 nginx（前台 daemon off 并常驻；已运行则先 reload 以应用新配置）
if ! bash -c 'exec 3<>/dev/tcp/127.0.0.1/8686' 2>/dev/null; then
  nginx -g 'daemon off;' >>"$LOG" 2>&1 &
  NGINX_PID=$!
else
  echo "[$(date +%T)] nginx already listening on 8686, reloading config..." >>"$LOG"
  nginx -s reload >>"$LOG" 2>&1 || true
  NGINX_PID=$(cat /var/run/nginx.pid 2>/dev/null || echo 0)
fi
echo "[$(date +%T)] nginx serving $SITE_OUT on 8686" >>"$LOG"

# 2. 后台安装站点依赖、构建站点与 flutter example 并嵌入 $SITE_OUT/flutter/example
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
#    nginx 常驻 8686 提供预览，后台构建完成后即自动切换到真实产物。
#    显式等待构建与 nginx，保证脚本在服务存活期间不退出，直到整个仅预览
#    环境被关闭（keepAliveTimeout 兜底）。
echo "[$(date +%T)] build started; nginx keeps serving on 8686" >>"$LOG"
wait "$BUILD_PID" || true
echo "[$(date +%T)] build finished; nginx keeps serving $SITE_OUT on 8686" >>"$LOG"
wait "$NGINX_PID"

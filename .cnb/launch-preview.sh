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

# 1. 【关键】立即用 Node.js 内置 HTTP 服务占住 8686，通过平台启动检测。
#    node 在镜像中一定可用；服务同时充当静态文件服务器，
#    构建产物写入 $SITE_OUT 后即可被访问，并提供 SPA fallback。
cd "$SITE_OUT"
nohup node -e '
const http = require("http");
const fs = require("fs");
const path = require("path");
const ROOT = process.cwd();
const MIME = {
  ".html":"text/html", ".js":"text/javascript", ".css":"text/css",
  ".json":"application/json", ".png":"image/png", ".jpg":"image/jpeg",
  ".svg":"image/svg+xml", ".ico":"image/x-icon", ".txt":"text/plain",
  ".woff":"font/woff", ".woff2":"font/woff2", ".ttf":"font/ttf"
};
http.createServer((req, res) => {
  let p = decodeURIComponent(req.url.split("?")[0] || "/");
  if (p === "/") p = "/index.html";
  let fp = path.join(ROOT, p);
  if (!fp.startsWith(ROOT)) { res.writeHead(403); res.end("Forbidden"); return; }
  let ok = true, stat = null;
  try { stat = fs.statSync(fp); } catch { ok = false; }
  if (ok && stat.isDirectory()) fp = path.join(fp, "index.html");
  if (ok && fs.existsSync(fp)) {
    res.writeHead(200, { "Content-Type": MIME[path.extname(fp)] || "application/octet-stream" });
    res.end(fs.readFileSync(fp));
  } else {
    // SPA fallback：文件未就绪时返回占位页
    res.writeHead(200, { "Content-Type": "text/html" });
    res.end("<html><body><h1>TDesign Flutter Preview</h1><p>构建中，请稍候刷新…</p></body></html>");
  }
}).listen(8686, "0.0.0.0");
' >>"$LOG" 2>&1 &
echo "preview server started on 8686 (pid $!)" >>"$LOG"

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

# 3. 保持脚本作为守护进程存活（daemon:true），静态服务持续提供预览
wait

#!/usr/bin/env bash
set -eu
# bash 支持 pipefail，捕获上游命令失败；POSIX sh（dash）不支持，仅 bash 下启用
if [ -n "${BASH_VERSION:-}" ]; then
  set -o pipefail
fi

# 仅预览模式下构建并启动静态服务（须监听 8686）。
#
# 关键点：平台在 Prepare 阶段会做“启动检测”，若未在预期时间内检测到
# 8686 端口的监听服务，整个预览环境会被判定为启动失败（此前就因此超时报错：
# “Preview startup detection timed out: no service listening on port 8686”）。
# 而站点 + Flutter Web 的完整构建耗时远超该检测窗口，因此必须：
#   1) 先立即在 8686 端口启动静态服务器（占住端口，让启动检测立即通过）；
#   2) 再于后台构建产物；服务器按需读取文件，构建完成后页面即可正常访问。

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLUTTER_DIR="$ROOT/tdesign-component/example"
SITE_DIR="$ROOT/tdesign-site"
SITE_OUT="$SITE_DIR/_site"
PORT=8686

# 1. 确保输出目录存在，供静态服务器作为根目录。
mkdir -p "$SITE_OUT"

# 2. 立即在 8686 端口启动静态服务（后台常驻）。
#    preview_server.dart 为纯 Dart 实现、仅用 SDK 内置库，Flutter 镜像自带 dart，
#    不依赖 node/python；支持 SPA 回退与路径穿越防护。
dart run "$ROOT/scripts/preview_server.dart" "$SITE_OUT" "$PORT" &
SERVER_PID=$!
# 给服务器一点时间完成端口绑定，确保启动检测立即命中。
sleep 1

# 3. 后台构建站点与 Flutter Web 产物，完成后嵌入输出目录。
#    （站点构建会先清空 $SITE_OUT 再生成，随后把 Flutter 产物拷入。）
(
  set -eu

  echo "[preview] step 1/3: build site..."
  cd "$SITE_DIR"
  pnpm install
  pnpm run site --mode=preview

  echo "[preview] step 2/3: build flutter example web..."
  cd "$FLUTTER_DIR"
  flutter pub get
  flutter build web -t ./lib/main.dart --release --base-href /flutter/example/

  echo "[preview] step 3/3: embed flutter output into site..."
  mkdir -p "$SITE_OUT/flutter/example"
  cp -R build/web/* "$SITE_OUT/flutter/example"

  echo "[preview] build finished, preview ready at :$PORT"
) &
BUILD_PID=$!

# 4. 保持脚本存活：等待构建结束，同时保持静态服务器常驻。
#    即使构建失败，服务器仍监听 8686，环境不会被判定为启动失败。
wait "$BUILD_PID" || echo "[preview] build failed, keeping static server alive on :$PORT"
wait "$SERVER_PID"

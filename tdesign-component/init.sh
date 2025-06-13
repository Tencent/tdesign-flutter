#!/bin/bash

# 可以指定自己的Flutter SDK路径
#FLUTTER_SDK_PATH=~/tools/flutter

# 设置基础目录（脚本所在目录）`
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 检查Flutter SDK路径
# 检查Flutter SDK路径
if [[ -n "$FLUTTER_SDK_PATH" ]]; then
  FLUTTER_CMD="$FLUTTER_SDK_PATH/bin/flutter"
  echo "使用自定义Flutter路径: $FLUTTER_CMD"
else
  FLUTTER_CMD="flutter"
  echo "使用系统默认Flutter命令"
fi

# 获取Flutter版本号（安全处理错误）
FLUTTER_VERSION=$($FLUTTER_CMD --version 2>/dev/null | awk '/Flutter/{print $2}')
if [[ -z "$FLUTTER_VERSION" ]]; then
  echo "❌ 错误：无法获取Flutter版本号" >&2
  exit 1
fi
echo "检测到Flutter版本: $FLUTTER_VERSION"

# 版本比较函数（使用sort -V替代BASH_REMATCH）
version_ge() {
  # 原理：通过版本排序后检查目标版本是否为最大值
  [[ "$(printf "%s\n" "$1" "3.32.0" | sort -V -r | head -n1)" == "$1" ]]
}

# 执行对应版本的copy.sh
if version_ge "$FLUTTER_VERSION"; then
  echo "✅ 版本 >= 3.32.0，执行高版本脚本"
  COPY_SCRIPT="$BASE_DIR/example/shell/flutter_versions/3.32.2"
else
  echo "ℹ️ 版本 < 3.32.0，执行低版本脚本"
  COPY_SCRIPT="$BASE_DIR/example/shell/flutter_versions/3.16.9"
fi

# 执行copy脚本
if [[ -f "$COPY_SCRIPT/copy.sh" ]]; then
  cd "$COPY_SCRIPT"
  echo "执行: $COPY_SCRIPT"
  bash "copy.sh"
else
  echo "❌ 错误: 找不到脚本 $COPY_SCRIPT" >&2
  exit 1
fi

cd $BASE_DIR

# 在基础目录执行清理和依赖安装
echo "在 $BASE_DIR 执行清理操作..."
$FLUTTER_CMD clean

rm $BASE_DIR/pubspec.lock
rm $BASE_DIR/example/pubspec.lock

echo "获取项目依赖..."

$FLUTTER_CMD pub get

echo "✅ 所有操作完成"
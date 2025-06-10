#!/bin/bash

FLUTTER_SDK_PATH=~/tools/flutter1/

# 设置基础目录（脚本所在目录）
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 检查Flutter SDK路径
if [[ -n "$FLUTTER_SDK_PATH" ]]; then
  FLUTTER_CMD="$FLUTTER_SDK_PATH/bin/flutter"
  echo "使用自定义Flutter路径: $FLUTTER_CMD"
else
  FLUTTER_CMD="flutter"
  echo "使用系统默认Flutter命令"
fi

# 获取Flutter版本号
FLUTTER_VERSION=$($FLUTTER_CMD --version | awk '/Flutter/{print $2}')
echo "检测到Flutter版本: $FLUTTER_VERSION"

# 版本比较函数
version_compare() {
  [[ "$1" =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]]
  VER_MAJOR=${BASH_REMATCH[1]}
  VER_MINOR=${BASH_REMATCH[2]}
  VER_PATCH=${BASH_REMATCH[3]}

  IFS='.' read -r TARGET_MAJOR TARGET_MINOR TARGET_PATCH <<< "3.32.0"

  if (( VER_MAJOR > TARGET_MAJOR )); then return 0; fi
  if (( VER_MAJOR < TARGET_MAJOR )); then return 1; fi
  if (( VER_MINOR > TARGET_MINOR )); then return 0; fi
  if (( VER_MINOR < TARGET_MINOR )); then return 1; fi
  (( VER_PATCH >= TARGET_PATCH ))
}

# 执行对应版本的copy.sh
if version_compare "$FLUTTER_VERSION"; then
  echo "✅ 版本 >= 3.32.0，执行高版本脚本"
  COPY_SCRIPT="$BASE_DIR/example/shell/flutter_versions/3.32.2/copy.sh"
else
  echo "ℹ️ 版本 < 3.32.0，执行低版本脚本"
  COPY_SCRIPT="$BASE_DIR/example/shell/flutter_versions/3.16.9/copy.sh"
fi

# 执行copy脚本
if [[ -f "$COPY_SCRIPT" ]]; then
  echo "执行: $COPY_SCRIPT"
  bash "$COPY_SCRIPT"
else
  echo "❌ 错误: 找不到脚本 $COPY_SCRIPT" >&2
  exit 1
fi

# 在基础目录执行清理和依赖安装
echo "在 $BASE_DIR 执行清理操作..."
$FLUTTER_CMD clean

echo "获取项目依赖..."
$FLUTTER_CMD pub get

echo "✅ 所有操作完成"
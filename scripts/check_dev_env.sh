#!/usr/bin/env bash
# ==============================================
# TDesign Flutter v1.0 开发环境一键检查脚本
# ==============================================
# 用法：
#   bash scripts/check_dev_env.sh
#   (Windows 下在 Git Bash 中运行)
# ==============================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

# 标题
echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}   TDesign Flutter v1.0 环境检查           ${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# -----------------------------------------------
# 辅助函数
# -----------------------------------------------
check_pass() {
  echo -e "  ${GREEN}✓${NC} $1"
  PASS_COUNT=$((PASS_COUNT + 1))
}

check_fail() {
  echo -e "  ${RED}✗${NC} $1"
  echo -e "    ${RED}→ $2${NC}"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

check_warn() {
  echo -e "  ${YELLOW}⚠${NC} $1"
  echo -e "    ${YELLOW}→ $2${NC}"
  WARN_COUNT=$((WARN_COUNT + 1))
}

# -----------------------------------------------
# 1. 检查基础工具
# -----------------------------------------------
echo -e "${BLUE}[1/7] 检查基础工具${NC}"

# Git
if command -v git &> /dev/null; then
  GIT_VERSION=$(git --version 2>&1 | head -n1)
  check_pass "Git 已安装：$GIT_VERSION"
else
  check_fail "Git 未安装" "请安装 Git: https://git-scm.com/download/win"
fi

echo ""

# -----------------------------------------------
# 2. 检查 Flutter SDK
# -----------------------------------------------
echo -e "${BLUE}[2/7] 检查 Flutter SDK${NC}"

if command -v flutter &> /dev/null; then
  FLUTTER_VERSION=$(flutter --version 2>&1 | head -n1)
  check_pass "Flutter 已安装：$FLUTTER_VERSION"
  
  # 提取版本号
  FLUTTER_VER_NUM=$(flutter --version 2>&1 | grep -oP 'Flutter \K[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
  
  if [ -n "$FLUTTER_VER_NUM" ]; then
    # 比较版本号是否 >= 3.32.0
    REQUIRED="3.32.0"
    if [ "$(printf '%s\n' "$REQUIRED" "$FLUTTER_VER_NUM" | sort -V | head -n1)" = "$REQUIRED" ]; then
      check_pass "Flutter 版本满足要求 (>=3.32.0)"
    else
      check_fail "Flutter 版本过低: $FLUTTER_VER_NUM (需要 >=3.32.0)" "运行: flutter upgrade"
    fi
  else
    check_warn "无法解析 Flutter 版本号" "请手动确认版本 >=3.32.0"
  fi
else
  check_fail "Flutter SDK 未安装或未加入 PATH" "请安装 Flutter: https://docs.flutter.dev/get-started/install/windows"
fi

echo ""

# -----------------------------------------------
# 3. 检查 Dart SDK
# -----------------------------------------------
echo -e "${BLUE}[3/7] 检查 Dart SDK${NC}"

if command -v dart &> /dev/null; then
  DART_VERSION=$(dart --version 2>&1)
  check_pass "Dart 已安装：$DART_VERSION"
else
  check_warn "dart 命令未找到（通常随 Flutter 内置）" "尝试: flutter dart --version"
fi

echo ""

# -----------------------------------------------
# 4. 检查 Java / Android SDK
# -----------------------------------------------
echo -e "${BLUE}[4/7] 检查 Android 开发环境${NC}"

if command -v java &> /dev/null; then
  JAVA_VERSION=$(java -version 2>&1 | head -n1)
  check_pass "Java 已安装：$JAVA_VERSION"
else
  check_warn "Java 未找到" "如需 Android 开发，请安装 JDK 17: https://adoptium.net/"
fi

# ANDROID_HOME
if [ -n "$ANDROID_HOME" ]; then
  check_pass "ANDROID_HOME 已设置：$ANDROID_HOME"
else
  # 检查默认路径
  DEFAULT_ANDROID="$LOCALAPPDATA/Android/Sdk"
  if [ -d "$DEFAULT_ANDROID" ]; then
    check_warn "ANDROID_HOME 环境变量未设置，但找到默认路径" "建议设置: setx ANDROID_HOME \"$DEFAULT_ANDROID\""
  else
    check_warn "ANDROID_HOME 未设置，默认路径也不存在" "请安装 Android Studio 并配置 SDK"
  fi
fi

echo ""

# -----------------------------------------------
# 5. 检查项目依赖
# -----------------------------------------------
echo -e "${BLUE}[5/7] 检查项目依赖${NC}"

# 找到项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../tdesign-component" && pwd)"

if [ -d "$PROJECT_DIR" ]; then
  check_pass "项目目录存在：$PROJECT_DIR"
  
  # 检查 pubspec.yaml
  if [ -f "$PROJECT_DIR/pubspec.yaml" ]; then
    check_pass "pubspec.yaml 存在"
  else
    check_fail "pubspec.yaml 不存在" "请确认项目结构完整"
  fi
  
  # 检查 pubspec.lock（表示 flutter pub get 已运行）
  if [ -f "$PROJECT_DIR/pubspec.lock" ]; then
    check_pass "依赖已安装 (pubspec.lock 存在)"
  else
    check_warn "依赖未安装" "请在 tdesign-component 目录运行: flutter pub get"
  fi
  
  # 检查 example 依赖
  EXAMPLE_DIR="$PROJECT_DIR/example"
  if [ -f "$EXAMPLE_DIR/pubspec.lock" ]; then
    check_pass "Example 依赖已安装"
  else
    check_warn "Example 依赖未安装" "请在 example 目录运行: flutter pub get"
  fi
else
  check_fail "项目目录不存在" "请确认在正确的仓库下运行"
fi

echo ""

# -----------------------------------------------
# 6. 检查可用的调试设备
# -----------------------------------------------
echo -e "${BLUE}[6/7] 检查可用设备${NC}"

if command -v flutter &> /dev/null && [ -d "$PROJECT_DIR" ]; then
  # 模拟器
  EMULATOR_COUNT=$(emulator -list-avds 2>/dev/null | wc -l | tr -d ' ')
  if [ "$EMULATOR_COUNT" -gt "0" ] 2>/dev/null; then
    check_pass "发现 $EMULATOR_COUNT 个 Android 模拟器配置"
    emulator -list-avds 2>/dev/null | while read -r avd; do
      if [ -n "$avd" ]; then
        echo -e "    ${GREEN}  -${NC} $avd"
      fi
    done
  else
    check_warn "未找到 Android 模拟器" "在 Android Studio AVD Manager 中创建"
  fi
  
  # Chrome（Web 调试）
  if command -v chrome &> /dev/null || command -v google-chrome &> /dev/null; then
    check_pass "Chrome 浏览器可用（支持 Web 调试）"
  else
    check_warn "Chrome 未找到" "Web 调试需要 Chrome 或 Edge"
  fi
else
  check_warn "跳过设备检查（Flutter 未安装）" ""
fi

echo ""

# -----------------------------------------------
# 7. 运行 flutter doctor 摘要
# -----------------------------------------------
echo -e "${BLUE}[7/7] Flutter Doctor 摘要${NC}"

if command -v flutter &> /dev/null; then
  # 运行 flutter doctor 并提取关键行
  DOCTOR_OUTPUT=$(flutter doctor 2>&1)
  echo "$DOCTOR_OUTPUT" | grep -E "^\s*\[✓\]|^\s*\[✗\]|^\s*\[!\]" | while read -r line; do
    if echo "$line" | grep -q "\[✓\]"; then
      echo -e "  ${GREEN}$line${NC}"
    elif echo "$line" | grep -q "\[✗\]"; then
      echo -e "  ${RED}$line${NC}"
    else
      echo -e "  ${YELLOW}$line${NC}"
    fi
  done
else
  check_fail "无法运行 flutter doctor" "请确认 Flutter 已正确安装"
fi

echo ""

# -----------------------------------------------
# 汇总结果
# -----------------------------------------------
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}   检查结果汇总${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "  ${GREEN}通过: $PASS_COUNT${NC}"
echo -e "  ${RED}失败: $FAIL_COUNT${NC}"
echo -e "  ${YELLOW}警告: $WARN_COUNT${NC}"
echo ""

if [ "$FAIL_COUNT" -eq 0 ]; then
  echo -e "${GREEN}✓ 环境检查通过！可以开始开发了。${NC}"
  echo ""
  echo -e "  快速启动命令："
  echo -e "  ${BLUE}cd tdesign-component/example && flutter run -d chrome${NC}"
elif [ "$FAIL_COUNT" -gt 0 ] && [ "$FAIL_COUNT" -le 2 ]; then
  echo -e "${YELLOW}⚠ 有 $FAIL_COUNT 项未通过，请根据提示修复后重试。${NC}"
else
  echo -e "${RED}✗ 有 $FAIL_COUNT 项未通过，环境存在问题较多，请逐一修复。${NC}"
fi

echo ""
echo -e "${BLUE}============================================${NC}"
echo ""

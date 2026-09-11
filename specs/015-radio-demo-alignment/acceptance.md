# 验收记录

## 验证环境

- 分支：`pr-1049`
- 提交：工作区（基线 `0a4eb1893cb5`）
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze` | 通过 | Flutter 3.32.0，0 issues |
| `flutter test test/components/radio/t_radio_test.dart` | 通过 | Flutter 3.32.0，32 tests，含默认分割线、显式关闭、卡片模式及尺寸 token 覆盖 |
| `flutter test test/radio_page_test.dart test/widget_test.dart` | 通过 | Flutter 3.32.0，Demo 功能与 debug gate，共 10 tests |
| `flutter test test/radio_page_golden_test.dart` | 通过 | Flutter 3.32.0 Linux，light/dark Golden 更新后无更新模式复验，共 2 tests |
| `flutter test --coverage ...` | 通过 | `t_radio.dart` 212/219，96.80% |
| Flutter 3.47.0 `flutter analyze` | 通过 | 0 issues |
| Flutter 3.47.0 Radio tests | 通过 | 组件 32 tests，Demo 功能 10 tests |
| `flutter build web --release` | 通过 | `build/web` 无内部测试模块文案 |
| `flutter build apk --release` | 通过 | 27.6 MB；AOT `libapp.so` 无内部测试模块文案 |
| `flutter build macos --release` | 未执行 | 仓库未配置 macOS desktop project，无法生成 DMG 上游 App |

## 人工验收

- [x] Android 16 真机（1220×2656）顶部、中部、底部截图与小程序公开 Demo 对照
- [x] release Web 产物不包含内部测试模块文案
- [x] release APK AOT 产物不包含内部测试模块文案

## 未覆盖项与后续工作

- macOS 工程未配置，因此不能在本仓库直接生成 App/DMG；测试模块使用 `kDebugMode` 编译期常量保护，release 平台共用同一 Dart 构建路径。

## 小程序实际运行补充复核

- 微信开发者工具 RC 2.02.2607161，基础库 3.17.1，iOS 模拟器：横向示例为通栏容器，`spacer16` 位于白色容器内部；勾选样式使用 24px TDesign `check` 图标，默认选中态使用 24px TDesign `check-circle-filled` 图标；主标题和副标题默认最多显示 3 行、5 行。
- Android 16 真机（1220×2656）：横向示例已移除外部留白形成的卡片轮廓，并保持 token 驱动的内部间距。
- Flutter 3.32 Widget 实测：small / medium / large 块级单行高度为 48 / 56 / 64dp；默认 medium 的 24dp 指示器与 56dp 块高对应小程序默认规格。
- Flutter 3.32：Radio 组件与 Theme 契约测试通过，32 tests；此前 Linux 覆盖率采样为 242/249，97.19%。
- Linux Flutter 3.32：Radio 页面 light / dark Golden 共 2 tests 通过；默认纵向项显示分割线，横向 Demo 显式关闭，卡片模式不显示。
- `flutter analyze`：通过，0 issues。

## 设计走查修复复验（2026-09-11）

- 基线：`origin/develop@044122f61`，分支 `rss1102/fix/radio-design-details`。
- 分割线根因：实际线条坐标已经从正文起点绘制，但左侧透明缩进透出 `bgColorPage`，其颜色与线条接近，真机视觉仍呈通栏；改为由 `bgColorContainer` 承接整条分割线行后，实际线条与可见像素都从正文起点开始。
- 横向 Demo 移除外层重复的垂直 `spacer16`，上下间距仅由 Radio 自身提供，最终均为 16dp。
- 未选中且禁用的指示器使用 `componentBorderColor` 描边与 `bgColorComponentDisabled` 填充；浅色默认值分别为 `#DCDCDC` 与 `#EEEEEE`。
- 纵向与横向卡片扣除 1.5dp 描边占用后使用 token 计算内容 padding，外边框至文案上下均为 16dp，内容中心与卡片中心一致。

| 门禁 | 结果 |
| --- | --- |
| Flutter 3.32.0 组件测试 | 34/34 通过，含可见分割线背景、禁用未选双色和卡片 16dp 回归 |
| Flutter 3.32.0 Demo 测试 | 6/6 通过，含横向上下间距和两类卡片居中 |
| Flutter 3.32.0 analyze | 组件与 example 均 0 issues |
| Flutter 3.47.0 | 组件 34/34、Demo 6/6，组件与 example analyze 均 0 issues |
| 生产代码覆盖率 | `t_radio.dart` 247/255，96.86% |
| Linux Golden | Flutter 3.32.0，浅色/深色更新后无更新模式 2/2 通过，并人工检查分割线、禁用态和卡片区域 |
| Android 真机 | Android 16、1220×2656；最终 APK 覆盖安装后分段检查顶部、禁用态和两类卡片，四项修复均可见 |

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

- 微信开发者工具 RC 2.02.2607161，基础库 3.17.1，iPhone 15 Pro Max 模拟器：横向示例为通栏容器，`spacer16` 位于白色容器内部；勾选样式使用 24px TDesign `check` 图标，默认选中态使用 24px TDesign `check-circle-filled` 图标；主标题和副标题默认最多显示 3 行、5 行。
- Android 16 真机（1220×2656）：横向示例已移除外部留白形成的卡片轮廓，并保持 token 驱动的内部间距。
- Flutter 3.32 Widget 实测：small / medium / large 块级单行高度为 48 / 56 / 64dp；默认 medium 的 24dp 指示器与 56dp 块高对应小程序默认规格。
- Flutter 3.32：Radio 组件与 Theme 契约测试通过，32 tests；此前 Linux 覆盖率采样为 242/249，97.19%。
- Linux Flutter 3.32：Radio 页面 light / dark Golden 共 2 tests 通过；默认纵向项显示分割线，横向 Demo 显式关闭，卡片模式不显示。
- `flutter analyze`：通过，0 issues。

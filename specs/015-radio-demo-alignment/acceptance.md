# 验收记录

## 验证环境

- 分支：`pr-1049`
- 提交：工作区（基线 `aa5a49ab150b`）
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze` | 通过 | Flutter 3.32.0，0 issues |
| `flutter test test/components/radio/t_radio_test.dart` | 通过 | Flutter 3.32.0，24 tests |
| `flutter test test/radio_page_test.dart test/widget_test.dart` | 通过 | Demo 结构、light/dark Golden、debug gate，共 9 tests |
| `flutter test --coverage ...` | 通过 | `t_radio.dart` 212/219，96.80% |
| Flutter 3.47.0 `flutter analyze` | 通过 | 0 issues |
| Flutter 3.47.0 Radio tests | 通过 | 24 tests |
| `flutter build web --release` | 通过 | `build/web` 无内部测试模块文案 |
| `flutter build apk --release` | 通过 | 27.6 MB；AOT `libapp.so` 无内部测试模块文案 |
| `flutter build macos --release` | 未执行 | 仓库未配置 macOS desktop project，无法生成 DMG 上游 App |

## 人工验收

- [x] Android 16 真机（25113PN0EC，1220×2656）顶部、中部、底部截图与小程序公开 Demo 对照
- [x] release Web 产物不包含内部测试模块文案
- [x] release APK AOT 产物不包含内部测试模块文案

## 未覆盖项与后续工作

- macOS 工程未配置，因此不能在本仓库直接生成 App/DMG；测试模块使用 `kDebugMode` 编译期常量保护，release 平台共用同一 Dart 构建路径。

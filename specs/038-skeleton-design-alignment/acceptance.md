# 验收记录

## 验证环境

- 分支：`rss1102/feat/skeleton-design-alignment`
- 基线：已合入 `origin/develop@031b1a06`
- 设计：TDesign for mobile，Figma Skeleton 页面 `24386:5273`
- 小程序参考：`Tencent/tdesign-miniprogram@faaa4bbe4`
- Flutter/Dart：Flutter 3.32.0 与 Flutter 3.47.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/skeleton/t_skeleton_test.dart` | 16/16 通过 | Flutter 3.32.0、Flutter 3.47.0；覆盖闪烁动画 0s / 1s / 2s 关键帧 |
| `flutter test test/skeleton_demo_test.dart` | 3/3 通过 | Flutter 3.32.0、Flutter 3.47.0 |
| `flutter test test/skeleton_demo_golden_test.dart` | 2/2 通过 | Linux amd64、Flutter 3.32.0，生成后无更新复验 |
| `flutter test test/pull_down_refresh_demo_test.dart --tags golden` | 2/2 通过 | Linux amd64、Flutter 3.32.0；同步 Skeleton 默认占位色的下游基线后无更新复验 |
| `flutter analyze --fatal-infos lib test` | 0 error / 0 warning | Flutter 3.32.0、Flutter 3.47.0 |
| `flutter analyze --fatal-infos lib test`（example） | 0 error / 0 warning | Flutter 3.32.0、Flutter 3.47.0 |
| `flutter test --coverage test/components/skeleton/t_skeleton_test.dart` | 135/135，100.00% | Skeleton 生产目录 LH/LF |
| `dart run tool/generate_example_code.dart --check` | 通过 | 三个公开代码面板片段与源码一致 |
| Manifest 脚本测试 | 13/13 通过 | 组件、Demo、Golden 登记完整 |

## 人工验收

- [x] 在 Web Demo 中定位“02 组件动效”，观察渐变与闪烁动画；间隔 450ms 的同一区域截图编码长度分别为 10642/11069 bytes，内容发生变化，两类动画均持续运行。
- [x] 在 Android 真机 `25113PN0EC` 运行并停留在“02 组件动效”，录制 4s 画面观察闪烁动画完整往返两个周期。
- [x] 核对浅色、深色完整页面 Golden：375×1887，中文字体正常，无缺字方框。

## 未覆盖项与后续工作

- 使用已登录的 Google Chrome 核对 Figma Skeleton 页面结构，并以公开小程序 Demo/源码、仓库 Token 和 Linux Golden 交叉验证；Flutter Golden 为像素门禁，不把跨渲染引擎结果表述为 Figma 自动像素差分。
- 本次不增加、删除或改签公开 API，不构成 breaking change。

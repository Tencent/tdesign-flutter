# 验收记录

## 自动化验证

| 环境 | 命令 | 结果 |
| --- | --- | --- |
| Flutter 3.32.0 | `flutter test test/components/search/t_search_test.dart --coverage` | 9 个聚焦测试通过；Search 生产源码 `LH=191 / LF=195`，行覆盖率 97.95% |
| Flutter 3.32.0 | `flutter test test/search_page_test.dart`（Example 包） | 4 个测试通过，含 375×812 浅色与深色快照 |
| Flutter 3.32.0 | 组件包与 Example `flutter analyze --fatal-infos` | 均无问题 |
| Flutter 3.47.0 | Search 组件与 Demo 页面测试 | 9 + 4 个测试通过 |
| Flutter 3.47.0 | 组件包与 Example `flutter analyze --fatal-infos` | 均无问题 |
| Flutter 3.32.0 | `dart run tool/generate_example_code.dart --check` | 通过 |
| Flutter 3.32.0 | Example `flutter build web` | 通过 |
| 通用 | `git diff --check` | 通过 |

## 人工复核

- [x] 40dp 组件本体与 Demo 16/8dp 外围留白
- [x] 基础、结果预览、字数限制、取消、方形/圆形、居中场景
- [x] 结果预览聚焦空值展示 6 项、输入过滤与命中高亮、选择后回填并收起
- [x] 浅色背景、圆角、图标、间距和页面结构
- [x] 深色页面背景、容器背景、输入背景、图标和圆角 token
- [ ] 小程序模拟器深色截图中的文字和图标基线

## 未覆盖项

- 已使用微信开发者工具的官方 Demo 模拟器截图与 Flutter 375×812 Golden 人工对照，并据此修复输入区域背景仅按 24dp intrinsic height 绘制的问题。
- 测试环境缺少中文字体，浅色与深色 Golden 可锁定几何、背景、圆角和图标，但不能证明中文字体视觉；小程序模拟器深色截图仍未完成人工对照。

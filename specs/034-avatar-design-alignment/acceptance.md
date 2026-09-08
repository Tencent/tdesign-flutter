# 验收记录

## 验证环境

- 分支：`rss1102/feat/avatar-design-alignment`
- 修复基线：PR #1090 原 head `ee9266bd`
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0；Golden 使用 Linux Flutter 3.32.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze --no-pub` | 通过 | Flutter 3.32.0，0 issues |
| `flutter test --no-pub test/components/avatar/t_avatar_test.dart` | 32/32 通过 | Flutter 3.32.0 |
| `flutter test --no-pub test/avatar_demo_test.dart` | 3/3 通过 | Flutter 3.32.0，example 工程 |
| `flutter analyze --no-pub` | 通过 | Flutter 3.47.0，0 issues |
| `flutter test --no-pub test/components/avatar/t_avatar_test.dart` | 32/32 通过 | Flutter 3.47.0 |
| `flutter test --no-pub test/avatar_demo_test.dart` | 3/3 通过 | Flutter 3.47.0，example 工程 |
| `flutter test --coverage --no-pub test/components/avatar/t_avatar_test.dart` | 通过 | Avatar 生产代码 LH/LF = 196/201 = 97.51% |
| 集中回归登记自测 | 通过 | coverage/component/example/visual 文件与 runner 登记完整 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例片段与源码同步 |
| `node tool/generate_api.mjs --dry-run` | 通过 | Avatar API 配置包含 TAvatar 与 TAvatarGroup |
| Linux Flutter 3.32 `flutter test --no-pub test/avatar_demo_golden_test.dart` | 2/2 通过 | 更新前 light 0.32% / dark 0.34% 预期差异；检查实际图并更新后，不带更新参数严格复跑通过 |

## 人工验收

- [x] Figma 类型、特殊类型、尺寸和 Avatar Group 逐项比对通过
- [x] 明暗 Golden 中本次变更的头像组裁剪、边框与 `+5` 溢出文案符合设计稿
- [x] 小程序公开能力逐项核对；图片、徽标继续通过 Flutter Widget 组合，组级 API 收敛为布局参数与成员自身形状

## 未覆盖项与后续工作

- Figma 仅提供视觉与标注依据；Flutter API 按 Widget 组合模型收敛，未机械复制小程序字符串 URL、徽标参数或图片加载参数。
- Golden 固定在 Linux + Flutter 3.32.0；Flutter 3.47.0 只验证功能与静态分析，不用于更新像素基线。

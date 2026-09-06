# 验收记录

## 验证环境

- 分支：`rss1102/breaking/avatar-design-alignment`
- 提交：本 PR 单一提交
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0；Golden 使用 Linux Flutter 3.32.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze --no-pub` | 通过 | Flutter 3.32.0，0 issues |
| `flutter test --no-pub test/components/avatar/t_avatar_test.dart` | 26/26 通过 | Flutter 3.32.0 |
| `flutter test --no-pub test/avatar_demo_test.dart` | 2/2 通过 | Flutter 3.32.0，example 工程 |
| `flutter analyze --no-pub` | 通过 | Flutter 3.47.0，0 issues |
| `flutter test --no-pub test/components/avatar/t_avatar_test.dart` | 26/26 通过 | Flutter 3.47.0 |
| `flutter test --no-pub test/avatar_demo_test.dart` | 2/2 通过 | Flutter 3.47.0，example 工程 |
| `flutter test --coverage --no-pub test/components/avatar/t_avatar_test.dart` | 通过 | Avatar 生产代码 LH/LF = 132/135 = 97.78% |
| 集中回归登记自测 | 通过 | coverage/component/example/visual 文件与 runner 登记完整 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例片段与源码同步 |
| `node tool/generate_api.mjs --dry-run` | 通过 | Avatar API 配置包含 TAvatar 与 TAvatarGroup |
| Linux Flutter 3.32 `flutter test --no-pub test/avatar_demo_golden_test.dart` | 2/2 通过 | 明暗 Golden 只读像素比对 |

## 人工验收

- [x] Figma 类型、特殊类型、尺寸和 Avatar Group 逐项比对通过
- [x] 明暗 Golden 无缺字方框、图片模糊或非 TDesign 图标

## 未覆盖项与后续工作

- Figma 仅提供视觉与标注依据；Flutter API 按 Widget 组合模型收敛，未机械复制小程序字符串 URL、徽标参数或图片加载参数。
- Golden 固定在 Linux + Flutter 3.32.0；Flutter 3.47.0 只验证功能与静态分析，不用于更新像素基线。

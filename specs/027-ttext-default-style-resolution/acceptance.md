# 验收记录

## 验证环境

- 分支：rss1102/fix/ttext-default-style
- 基线：origin/develop@3d5ed7731ed6b619b3c3797a51e9a60391de3964
- Flutter/Dart：Flutter 3.32.0 与 latest；Golden 固定 Flutter 3.32.0 Linux

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| Flutter 3.32.0 run_component_regression.dart | 通过 | 36 个登记组件全部通过，生产覆盖率逐组件不低于 95% |
| Flutter latest run_component_regression.dart | 通过 | 36 个登记组件全部通过，生产覆盖率逐组件不低于 95% |
| Flutter 3.32.0 run_example_regression.dart | 通过 | 113 项非视觉示例测试通过 |
| Flutter latest run_example_regression.dart | 通过 | 113 项非视觉示例测试通过 |
| Flutter 3.32.0 Linux run_visual_regression.dart | 通过 | 41 个视觉套件严格比对通过 |
| Flutter 3.32.0 / latest flutter analyze | 通过 | 组件包和 example 均为 0 error、0 warning |
| TText、Theme 与清单聚焦测试 | 通过 | 50 项测试通过 |
| Popover 聚焦功能测试 | 通过 | 7 项测试通过 |
| generate_example_code.dart --check | 通过 | Popover 示例代码片段与源码同步 |

## 人工验收

- [x] 首次全量扫描中 41 个视觉套件有 37 个报告差异，确认共享影响面后再落地根因与基线更新
- [x] 审查 256 张变化 Golden；差异来自自动 bodyMedium 不再覆盖 TText bodyLarge，或其引起的预期布局重排
- [x] 发现并修复 Popover 自定义内容固定 146 高度在正确行高下溢出，改为按内容自适应
- [x] 核对无公开 API 签名变化，示例生成产物已同步

## 未覆盖项与后续工作

- Flutter latest 首次回归与 Linux Golden 同时运行时共享 .dart_tool，导致 shader 派生产物冲突；清理后分别独占重跑均通过，未归因于源码。
- PR 保持 pedding 标签，由维护者结合大范围 Golden 变化决定合入时机。

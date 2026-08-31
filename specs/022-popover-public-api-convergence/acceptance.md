# 验收记录

## 验证环境

- GitHub PR：`Tencent/tdesign-flutter#1033`
- API 实现基线：`230140c1`；后续改动仅同步站点文档、Spec 与验收记录
- Flutter/Dart：Flutter 3.32.0 与 Flutter 3.47.0；Golden 固定为 Flutter 3.32.0 Linux

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| Flutter 3.32.0 `flutter analyze`（Popover 组件、测试与 Demo 定向范围） | 通过 | No issues found |
| Flutter 3.47.0 `flutter analyze`（同一范围） | 通过 | No issues found |
| Flutter 3.32.0 `flutter test --exclude-tags golden test/components/popover/t_popover_test.dart` | 通过 | 53 tests |
| Flutter 3.47.0 同一组件测试 | 通过 | 53 tests |
| 双版本 `example/test/popover_page_test.dart test/popover_demo_test.dart` | 通过 | 每个版本 7 tests |
| `dart run tool/generate_example_code.dart --check` | 通过 | 生成片段与 Demo 源码同步 |
| Popover API Markdown 定向生成 | 通过 | 仅生成 `TPopover`、`TPopoverColorScheme`、`TPopoverPlacement` |
| 站点 README 示例同步检查 | 通过 | 21 个公开 Demo 代码块与生成片段逐项一致 |
| Flutter 3.32.0 覆盖率门禁 | 通过 | Popover 生产源码 `502/518 = 96.91%` |
| Flutter 3.32.0 Linux `flutter test --no-pub test/popover_demo_golden_test.dart` | 通过 | 2 张整页与 42 张展开态，共 44 tests；未更新基线 |
| `git diff --check` | 通过 | 无空白错误 |

组件测试文件包含 37 个静态 `test` / `testWidgets` 声明；其中配色与方位循环分别展开为 6 项和 12 项，运行总数为 `37 + 5 + 11 = 53`。

## 人工验收

- [ ] 真机公开 Demo 文本、自定义内容和十二方位展开正常
- [x] light/dark Golden 无非预期差异

## 未覆盖项与后续工作

- 本次未重新执行真机人工操作；自动化 Demo 交互、边界测试与固定 Linux Golden 已通过。

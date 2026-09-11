# 验收记录

- 基线：Flutter `2ed620b9`；Figma `24386:5265`；小程序 `cc2384cc5`。
- Footer 外层高度未设置时由内容自然撑开；Figma 未定义固定外层高度，小程序 Footer 也未提供 height 属性。
- Flutter 3.32.0：组件测试 7 项、Demo 测试 3 项、工具清单测试 17 项通过；组件生产代码覆盖率 `47/48 = 97.92%`；组件库和 Example 静态分析均无问题。
- Flutter 3.47.0：clean 后重新获取依赖；组件测试 7 项、Demo 测试 3 项通过；组件库和 Example 静态分析均无问题。
- Linux Flutter 3.32.0：明暗 Demo Golden 先生成、人工检查，再以无更新模式复验，2 项通过。
- 生成物：示例代码与 API 文档已重新生成，示例代码 `--check` 通过。

## 链接布局修复（CNB Issue 168）

- 问题：链接页脚中 `IntrinsicWidth` 与外层收缩包围盒 `Container(alignment: center)` 组合，压缩了 `TLink` 文本固有宽度，链接文字逐字竖排。
- 根因：`Container(alignment: Alignment.center)` 传入 `BoxConstraints(minWidth: w, maxWidth: w)`（w 为内容固有宽度），`IntrinsicWidth` 的 `Row` 在该收缩约束下把 `Flexible` 子项压到最小宽度，文字被迫逐字换行。
- 修复：链接行改用 `Wrap(alignment: center, spacing: 12, runSpacing: 4, crossAxisAlignment: center)` 承载链接与分隔线，移除链接上的 `IntrinsicWidth` 与 `Padding`；版权文字去掉重复的 `Row` + `Flexible` 居中。
- 验证环境：Flutter 3.32.8 stable；Linux。
- 自动化验证：

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/footer/t_footer_test.dart` | 通过 | 12 项，含新增单行/居中/窄容器换行用例 |
| `dart run tool/run_component_regression.dart` | 通过 | footer 生产代码覆盖率 `43/43 = 100.00%` |
| `flutter test test/tool/*.dart` | 通过 | 回归调度器清单自测 |
| `dart run tool/run_example_regression.dart` | 通过 | 191 项 |
| `dart run tool/run_visual_regression.dart` | 通过 | Flutter 3.32.8 Linux 全部视觉基线无参数复验 |
| `flutter analyze --fatal-infos`（组件库 / example） | 通过 | 均无问题 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例源码未变，产物同步 |

- Golden：`footer_page_light.png` / `footer_page_dark.png` 已按确认的预期视觉更新，差异仅限双链接行（`bbox (119,431)-(257,447)`），随后以无更新参数复跑通过。
- 人工验收：
  - [x] 375 逻辑宽度下单链接与双链接均单行水平居中，与正确效果截图一致。
  - [x] 160 逻辑宽度下链接保持自身宽度并整体换行，无异常与溢出报错。
- 未覆盖项：Flutter latest 版本门禁由 CI 执行，本地仅验证 3.32.8；真机渲染未单独核对。

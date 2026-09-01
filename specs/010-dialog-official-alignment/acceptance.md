# 验收记录

## 验证环境

- 分支：`rss1102/cnb-issue-67/fix/dialog-official-alignment` 对应的隔离工作树
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub test/components/dialog/t_dialog_test.dart --coverage` | PASS，17 tests；LH/LF `200/202 = 99.01%` | Dialog 尺寸、内容、操作区、主题和路由契约 |
| Popup 完整回归测试及覆盖率 | PASS，170 tests；LH/LF `518/534 = 97.00%` | `shrinkWrap` 默认关闭，既有 240×240 center 契约保持不变 |
| `flutter test --no-pub test/dialog_page_test.dart` | PASS，8 tests | 22 个入口真实点击打开/关闭及关键组合交互 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.32.0，0 issues |
| `dart run tool/generate_example_code.dart --check` | PASS | 生成代码片段与 Demo 源码同步 |
| Flutter 3.47.0 Dialog + Popup 契约测试 | PASS，23 tests | 最终源码复验 |
| `flutter test --no-pub test/dialog_page_test.dart` | PASS，8 tests | Flutter 3.47.0 最终源码复验 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.47.0，0 issues |
| CNB 同款 Flutter 3.32.0 Linux 镜像更新并只读复跑 `dialog_page_golden_test.dart` | PASS，12 tests | 整页及输入、图片、文字按钮、多按钮、关闭按钮亮暗主题基线 |
| 回归调度器工具测试 | PASS，11 tests | Dialog 组件、覆盖率、Demo 功能和视觉回归登记同步 |

## 人工验收

- [x] 22 个入口通过真实 Widget 操作逐项打开并关闭；输入、图片、按钮顺序和返回结果有独立断言。
- [x] 使用 375dp 视口完成小程序与 Flutter 页面、关键打开态截图对照，证据见 [visual-comparison.md](visual-comparison.md)。
- [x] 真实 Web Demo 手动完成输入与清除、图片渲染、文字 Footer、多按钮顺序和关闭按钮交互。

## 未覆盖项与后续工作

- 未执行移动真机触摸验收；本轮证据为 Flutter Widget 真实事件、Linux Golden 和桌面 Web 人工操作。

## 2026-08-31 develop 同步复验

- 已合并 `origin/develop@ab04f68b8bcb572111216170d19045dd16d7895b`，冲突按 develop 共享测试基建与本 PR Dialog 默认值改动并集解决。
- CI 同款 Flutter 3.32.0 Linux：页面 light/dark 与点击“带关闭按钮的对话框”后的 Overlay light/dark Golden 共 4 项，更新后不带 `--update-goldens` 复跑通过。
- Flutter 3.32.0 与 3.47.0：15 个组件测试、4 个 Demo 功能测试和 `flutter analyze --fatal-infos --no-pub` 均通过。
- API 收敛复核：`TDialog` API 不变；`TPopupOptions.center` 新增默认关闭的 `shrinkWrap`，仅供 Dialog 绕开 Popup 240×240 固定尺寸。普通 Popup 默认尺寸和主题行为不变。
- 完整滚动 Web Demo 后发现并移除页尾内部“单元测试”模块；页面测试已增加公开页不出现该模块的断言。
- CI 同款 Flutter 3.32.0 Linux 已重建 375×1992 明暗整页 Golden，并在不带 `--update-goldens` 时复跑页面与点击后弹层 4/4 通过；截图证据已同步更新。

## 2026-09-01 Figma 与完整 Demo 终验

- Figma 当前页面采用“02 组件状态”，因此 Flutter Demo 保留该分组名称；组件内容顺序与官方小程序公开 Demo 对齐。
- 修复居中 Popup 240×240 固定尺寸压窄 311dp Dialog、裁切 `TInput` 的根因；带 Popup `centerSize` 主题时仍保持 Dialog 自适应。
- 文字按钮对齐 32dp Footer 顶间距、56dp 操作高度和 0.5dp 分隔线；三个及以上按钮按主要操作优先排列。
- 图片 Golden 显式等待仓库资产解码，防止把空白图片槽位误收为基线。

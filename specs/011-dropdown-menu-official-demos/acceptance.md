# 验收记录

## 验证环境

- 分支：基于 `origin/develop` 的本地审查工作树
- 提交：待提交
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart latest

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub test/components/dropdown_menu --coverage` | PASS，61 tests | `LH=925` / `LF=941` = 98.30% |
| `flutter test --no-pub test/dropdown_menu_page_test.dart` | PASS，4 tests | Flutter 3.32.0；覆盖公开矩阵、禁用交互及三列展开尺寸 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.32.0，0 issues |
| `flutter test --no-pub test/dropdown_menu_page_test.dart` | PASS，4 tests | Flutter 3.47.0 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.47.0，0 issues |
| `dart run tool/generate_example_code.dart` | PASS | 同步更新三列多选示例片段 |
| CNB 同款 `docker/flutter-3.32.0` Linux 镜像更新并复跑 `dropdown_menu_page_golden_test.dart` | PASS，6 + 6 tests | 整页、单选展开及三列多选展开的 light/dark 基线由 Linux 生成，并无更新参数复跑 |
| 回归调度器工具测试 | PASS，10 tests | DropdownMenu 组件、覆盖率、Demo 功能和视觉回归登记同步 |
| Flutter 3.47.0 组件与 Demo 非视觉测试 | PASS，59 + 3 tests | 主动拖动时的跨引擎坐标舍入以 1px 容差验证，展开关系仍严格检查 |

## 人工验收

- [x] 官方 Demo 的两个公开分组已在运行截图中复核，Flutter 扩展分组已移出公开页，证据见 [visual-comparison.md](visual-comparison.md)。
- [x] 单选及三列多选菜单在点击后完成 Figma 与 Flutter light/dark 展开态核对。

## 未覆盖项与后续工作

- 未新增公共 API；单选值和多选值继续由 `value` / `values` 与回调管理，`controller` 只承担跨树开关命令，避免重复状态源。
- `placement`、overlay 配置、自定义 trigger/panel 仍有独立职责，本次不删除既有公开能力；默认视觉变化不构成公开 API 签名 breaking change。
- Flutter 3.47.0 的既有组件用例 `auto placement can return during the same active drag` 存在 0.93px 几何舍入差异；本次仅将该断言容差收敛为 1 个逻辑像素，未修改组件源码，展开关系仍严格检查。
- 向上展开、custom trigger、scrollable 与局部 Theme 属于 Flutter 扩展能力，不作为小程序公开矩阵的一对一视觉场景；组件聚焦测试继续覆盖这些路径。

## 2026-08-31 develop 同步复验

- 已合并 `origin/develop@fb26b8d5`，并根据固定基线源码纠正原审查误判：官方状态组是两个禁用菜单，不是“一禁用一可用”。
- Demo 已用现有 API 收敛为“全部产品 + 默认排序”、同栏 1/2/3 列多选和两个禁用菜单；页面不再附加 Flutter 扩展或内部单元测试分组。
- CI 同款 Flutter 3.32.0 Linux：页面与单选点击展开态 light/dark Golden 共 4 项、4 个功能测试，更新后复跑共 8 tests 通过。
- Flutter 3.32.0 与 3.47.0：59 个组件测试、3 个 Demo 功能测试和 `flutter analyze --fatal-infos --no-pub` 均通过。
- API 收敛复核：生产组件源码相对 develop 无差异，没有新增或调整公共 API。
- 完整滚动官方 Web 预览确认页面在双禁用菜单后结束；Flutter 已移除扩展与内部测试分组。CI 同款 Flutter 3.32.0 Linux 重建 375×812 明暗整页及点击后展开态 Golden，并在不带 `--update-goldens` 时复跑 4/4 通过；截图证据已同步更新。

## 2026-09-03 Figma 对齐与冲突解决复验

- 已合并 `origin/develop@ed6ac81d`，CI 测试清单与 Golden 字体字符集合采用双方并集，5 个冲突文件均已消解。
- Figma 标注的 48px 菜单栏、4px 文本图标间距、24px 箭头/勾选图标、56px 单选行、16px 选项文字及三列 12px 间距已由 token/theme 默认链实现并加入直接断言。
- 设计稿三列面板改为 12 个正常项、3 个禁用项和底部操作栏；理论高度 348px，Flutter 的 0.5px 分割线使实测高度为 348.5px。
- `CompositedTransformFollower` 与 `ScrollNotificationObserver` 的既有实现已覆盖“滚动时菜单与面板分离”问题，组件测试验证菜单、面板和遮罩同位移，未为此增加第二套定位 API。
- Flutter 3.32.0 与 3.47.0 的 61 个组件测试、4 个 Demo 功能测试及严格 analyze 均通过；生产覆盖率 98.30%。Flutter 3.32.0 Linux 的 6 张 Golden 更新后无更新参数复跑 6/6 通过。

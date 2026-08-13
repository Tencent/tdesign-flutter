# TNoticeBar Review 修复 - 验收记录

## 执行的命令与结果

| 命令 | 结果 |
| --- | --- |
| `flutter analyze lib/src/components/notice_bar/t_notice_bar.dart` | No issues found |
| `flutter analyze test/components/notice_bar/t_notice_bar_test.dart` | No issues found |

> 注：沙箱环境的 pub-cache 缺少 `tdesign_flutter_icons`、`image_picker` 及正确版本的 analyzer，无法在本沙箱编译运行完整测试；需由 CI（flutter 3.32.0 与 latest）执行 `flutter test` 与构建验证。

## 验收项核对

- [x] 水平滚动距离使用可视区宽度，不再依赖屏宽（代码 `_scroll()` 已确认）。
- [x] 冗余 getter 已移除。
- [x] `flutter analyze` 对改动文件无 error/warning。
- [x] 新增滚动距离回归测试与 variant 色值测试（静态校验通过）。
- [ ] CI 构建通过（待执行）。
- [ ] 单元测试全绿（待 CI 执行）。

## 未覆盖项

- 水平滚动的真实帧级平滑度（依赖运行态视觉验证）。
- CI 双版本构建结果。

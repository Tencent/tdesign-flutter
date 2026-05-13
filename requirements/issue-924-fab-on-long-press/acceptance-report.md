# Acceptance Report — issue #924 TFab 长按事件

## 验收结论

状态：✅ 可验收

`TFab` 已对外暴露 `onLongPress`，并补充了示例、测试与文档，能够支持业务侧直接监听悬浮按钮长按行为。

## 需求对照

| 验收项 | 结果 | 说明 |
|---|---|---|
| `TFab` 暴露 `onLongPress` | ✅ | 新增 `GestureLongPressCallback? onLongPress` |
| 长按事件透传到底层手势组件 | ✅ | `InkWell.onLongPress` 已接入 |
| 有验收用例 | ✅ | `TFabPage` 的 `test` 区域新增“长按事件” |
| 有自动化测试 | ✅ | 新增 `tdesign-component/test/t_fab_test.dart` |
| 有文档更新 | ✅ | `tdesign-site/src/fab/README.md` 已补充示例与 API |

## 执行检查

### 通过项

```bash
flutter test test/t_fab_test.dart
flutter analyze lib/src/components/fab/t_fab.dart example/lib/page/t_fab_page.dart test/t_fab_test.dart
```

结果：

- `flutter test test/t_fab_test.dart`：通过
- `flutter analyze ...`：`No issues found!`

## 人工验收指引

1. 打开 `TFab` 示例页。
2. 进入页面底部“单元测试”区域。
3. 对“长按事件”示例执行长按。
4. 确认长按反馈符合预期，且普通点击不会误触发长按逻辑。

## 环境说明

- 校验在 `tdesign-component/` 目录执行：`flutter test test/t_fab_test.dart` 与 `flutter analyze`（见上文路径）。
- 若本地 `pubspec_overrides.yaml` 将 `tdesign_flutter_tools` 指向 stub，则无法运行 `all_build.sh` 中的 API 生成命令；本次已手工同步 `fab_api.md` 中 `onLongPress` 行，与 `TFab` 源码及站点文档一致。

## 归档文件

- `requirements/issue-924-fab-on-long-press/TaskContract.md`
- `requirements/issue-924-fab-on-long-press/test-cases.md`
- `requirements/issue-924-fab-on-long-press/code-review-report.md`
- `requirements/issue-924-fab-on-long-press/acceptance-report.md`
- `requirements/issue-924-fab-on-long-press/pr-body.md`

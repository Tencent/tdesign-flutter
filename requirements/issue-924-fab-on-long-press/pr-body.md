## Summary

- issue: https://github.com/Tencent/tdesign-flutter/issues/924
- 组件：`TFab`
- requirements：`requirements/issue-924-fab-on-long-press`
- 分支：`fix/issue-924-tdfab-on-long-press`
- 关联：`fixes #924`

## Root Cause

- `TFab` 仅暴露了 `onClick`，内部 `InkWell` 没有透传长按事件
- 示例页与站点文档没有长按场景，验收链路不完整

## Fix Plan

- 为 `TFab` 新增 `onLongPress`
- 补充 `ExamplePage.test` 用例与站点 API 文档
- 新增聚焦的 widget test，并补齐 `requirements/` 验收材料

## Test Plan

- [x] `flutter test test/t_fab_test.dart`
- [x] `flutter analyze lib/src/components/fab/t_fab.dart example/lib/page/t_fab_page.dart test/t_fab_test.dart`

## Acceptance Docs

- `requirements/issue-924-fab-on-long-press/TaskContract.md`
- `requirements/issue-924-fab-on-long-press/test-cases.md`
- `requirements/issue-924-fab-on-long-press/code-review-report.md`
- `requirements/issue-924-fab-on-long-press/acceptance-report.md`

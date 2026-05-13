# TaskContract — issue #924 TDFab 暴露 onLongPress 方法

## 基本信息

- issue: https://github.com/Tencent/tdesign-flutter/issues/924
- 组件：`TFab`
- 分支：`fix/issue-924-tdfab-on-long-press`
- 类型：新特性提交（新增公开参数）

## 问题描述

`TFab` 当前仅暴露了 `onClick`，未对外提供长按事件回调。

这导致业务侧无法直接监听悬浮按钮的长按行为，也与仓库内其他已支持长按的组件能力不一致。

## 根因分析

- `tdesign-component/lib/src/components/fab/t_fab.dart` 的 `TFab` 构造方法中没有 `onLongPress` 参数。
- `TFab.build()` 内部虽然使用了 `InkWell`，但只透传了 `onTap: onClick`，没有透传 `onLongPress`。
- `fab` 示例页和站点文档中也没有覆盖长按场景，导致验收路径不完整。

## 修复方案

1. 在 `TFab` 中新增公开参数 `onLongPress`，类型为 `GestureLongPressCallback?`。
2. 在内部 `InkWell` 上透传 `onLongPress`。
3. 按注释规范补齐 `TFab` 相关注释，确保 API 生成工具可识别。
4. 在 `TFab` 示例页的 `test` 区域新增长按用例，并同步更新站点文档。
5. 新增聚焦的 widget test，验证：
   - 长按会触发回调
   - 点击不会误触发长按
   - `onClick` 与 `onLongPress` 可以独立工作

## 贡献指南对照

- 开发规范：新增 API 仅做能力扩展，不破坏原有 `onClick` 语义。
- 代码 Review 自检：
  - 提供了验收用例，并放入 `ExamplePage.test`
  - 提供了对应文档与测试
- 文档自检：
  - `tdesign-component/demo_tool/all_build.sh` 中 `fab` 已有 API 生成配置，本次无需调整
  - API 注释已补充

## 交付物清单

| 序号 | 交付物 | 说明 |
|------|--------|------|
| 1 | `tdesign-component/lib/src/components/fab/t_fab.dart` | 新增 `onLongPress` 参数并透传 |
| 2 | `tdesign-component/example/lib/page/t_fab_page.dart` | 新增长按验收用例 |
| 3 | `tdesign-component/example/assets/code/fab._buildLongPressFab.txt` | 示例代码片段 |
| 4 | `tdesign-component/test/t_fab_test.dart` | 定向 widget test |
| 5 | `tdesign-site/src/fab/README.md` | 补充 API 与示例文档 |
| 6 | `requirements/issue-924-fab-on-long-press/test-cases.md` | 验收用例说明 |
| 7 | `requirements/issue-924-fab-on-long-press/code-review-report.md` | 代码审查结论 |
| 8 | `requirements/issue-924-fab-on-long-press/acceptance-report.md` | 验收与检查结果 |
| 9 | `tdesign-component/example/assets/api/fab_api.md` | API 表补充 `onLongPress`（与生成物一致） |
| 10 | `requirements/issue-924-fab-on-long-press/pr-body.md` | PR 摘要模板 |

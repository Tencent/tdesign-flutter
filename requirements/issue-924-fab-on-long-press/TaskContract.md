# TaskContract — issue #924 TFab 暴露 onLongPress 回调

## 基本信息

- issue: https://github.com/Tencent/tdesign-flutter/issues/924
- 组件：`TFab`
- 分支：`fix/issue-924-fab-on-long-press`
- 目录：`requirements/issue-924-fab-on-long-press`
- 类型：功能扩展（新增可选回调参数）

## 问题描述

- `TFab` 使用 `InkWell` 实现点击，但未将长按能力透出给业务；业务无法在悬浮按钮上实现长按菜单、长按快捷操作等场景。

## 根因分析

- 组件仅向 `InkWell` 传递了 `onTap`（映射为 `onClick`），未声明也未转发 `onLongPress`，导致 Flutter Material 长按语义无法接入。

## 修复方案

1. 在 `TFab` 构造方法与字段中增加可选参数 `onLongPress`（`VoidCallback?`），文档注释使用 `///`。
2. 在 `build` 中将 `onLongPress` 传给根节点 `InkWell` 的 `onLongPress`。
3. 在 `tdesign-component/test/t_fab_test.dart` 增加 widget 测试，验证长按时回调触发。
4. 顺带将 FAB 上原先硬编码的 `Colors.white` / `Colors.black` 投影改为 `TTheme` 的 `fontWhColor1` 与 `shadowsMiddle`，以通过 issue 工作流颜色检查并与主题一致。

## 贡献指南对照

- 开发规范：扩展 Material 交互能力，与系统 `InkWell` 行为对齐；未删减既有 API。
- 代码 Review 自检：构造方法在前、字段在后；公开 API 使用 `///`；样式仍取自 `TTheme`；无新增硬编码文案。
- 文档自检：站点 README 为生成物未手工改；API 生成依赖 `tdesign_flutter_tools`，本地 stub 无法执行时需由 CI 或具备完整工具链的环境补生成。

## 交付物清单

| 序号 | 交付物 | 说明 |
|------|--------|------|
| 1 | `requirements/issue-924-fab-on-long-press/test-cases.md` | 验收用例 |
| 2 | `requirements/issue-924-fab-on-long-press/code-review-report.md` | 代码审查结论 |
| 3 | `requirements/issue-924-fab-on-long-press/acceptance-report.md` | 验收报告 |
| 4 | `requirements/issue-924-fab-on-long-press/pr-body.md` | PR 摘要 |

# TaskContract — issue #924 [TDFab] 暴露 onLongPress 方法

## 基本信息

- issue: https://github.com/Tencent/tdesign-flutter/issues/924
- 组件：`TFab`
- 分支：`fix/issue-924-fab-on-long-press`
- 目录：`requirements/issue-924-fab-on-long-press`
- 类型：新特性（新增可选回调参数 `onLongPress`）

## 问题描述

业务需要在悬浮按钮上实现长按逻辑（例如长按展开菜单、快捷操作等）。`TFab` 内部使用 `InkWell` 承载点击，但未将长按能力透出，调用方无法接入 `onLongPress`。

## 根因分析

`TFab` 的 `build` 中仅向 `InkWell` 传入了 `onTap: onClick`，缺少 `onLongPress` 参数及对应构造字段，导致 Material 长按手势链路无法由外部配置。

## 修复方案

1. 为 `TFab` 增加可选参数 `onLongPress`（`VoidCallback?`），文档注释为「长按回调」。
2. 在 `InkWell` 上设置 `onLongPress: onLongPress`，与 `onTap` 并存，行为与 Flutter 原生一致。
3. 为满足仓库 `check-issue-fix` 对组件文件的色值检查，将原先硬编码的 `Colors.white` 与手写阴影改为 `TTheme.of(context).textColorAnti` 与主题投影 `shadowsMiddle` / `shadowsBase` 回退链。
4. 补充 `tdesign-component/test/t_fab_test.dart` 覆盖长按与单击共存；示例页增加「交互」模块演示长按弹出 `SnackBar`；同步 `example/assets/api/fab_api.md`。

## 贡献指南对照

- 开发规范：新增 API 使用 `///` 注释；样式与色值从 `TTheme` 获取；保持 `TFab` 命名与现有导出一致。
- 代码 Review 自检：构造方法在字段之前；未引入与需求无关的重构；测试可重复执行。
- 文档自检：示例与 API 表已更新；未手工改动 `tdesign-site/src/**/README.md`。

## 交付物清单

| 序号 | 交付物 | 说明 |
|------|--------|------|
| 1 | `requirements/issue-924-fab-on-long-press/test-cases.md` | 验收用例 |
| 2 | `requirements/issue-924-fab-on-long-press/code-review-report.md` | 代码审查结论 |
| 3 | `requirements/issue-924-fab-on-long-press/acceptance-report.md` | 验收报告 |
| 4 | `requirements/issue-924-fab-on-long-press/pr-body.md` | PR 摘要 |
| 5 | `tdesign-component/lib/src/components/fab/t_fab.dart` | 组件实现 |
| 6 | `tdesign-component/test/t_fab_test.dart` | 单元测试 |
| 7 | `tdesign-component/example/lib/page/t_fab_page.dart` | 示例演示 |
| 8 | `tdesign-component/example/assets/api/fab_api.md` | API 文档 |

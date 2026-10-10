# Develop 文档、示例与历史残留清理

基线：origin/develop e724cd0c4。范围：57 个组件/API 页、60 个 Demo 入口及全局配置的结构审计与风险登记；修正当前说明，删除无引用且无公开导出的旧兼容实现及无调用站点转换。

## 契约与范围

本 PR 不修改 Upload/Toast 的运行行为。它们分别由独立 PR [#1153](https://github.com/Tencent/tdesign-flutter/pull/1153) 和 [#1154](https://github.com/Tencent/tdesign-flutter/pull/1154) 修复；风险登记必须区分已复现、独立 PR 已修复和已合并。

保留现行 all_build.sh 入口、有效能力 TODO、公开弃用契约和历史 Changelog/已完成 Spec。不更名公开 API，不更新 Golden 基线。公开 API 文档仅从源码生成。

## 验收

API 导出/注释结构审计、示例映射和编译通过；站点测试与构建通过，严格 analyze 无诊断。静态审计不等于全文语义验收或无 bug，未验证的人工交互和 Linux Golden 必须明确说明。

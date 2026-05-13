---
name: component-workflow
description: 指导 TDesign Flutter 组件、示例、demo 和相关 API 的改动。适用于处理 `tdesign-component/` 下内容、修改组件行为，或更新 Flutter 组件库示例时。
---

# 组件开发流程

## 关注范围

只在必要的最小文件集合内开展改动：

1. `tdesign-component/lib/` 中的组件实现
2. `tdesign-component/demo_tool/` 中的 demo 或 API 配置
3. `tdesign-component/example/` 中的示例页面
4. 当公开 API 或行为变化时需要同步的相关文档

## 评审检查项

- 固定样式 token 应沉淀到主题数据中，而不是以内联值散落在代码里。
- 当新增或修改用户可见文案时，应通过 `TResourceDelegate` 统一管理。
- 没有充分理由时，不要删减系统组件能力，应优先基于原生 Flutter 行为做扩展。
- 如果改动影响公开组件契约，要同步检查该组件对应的 example 和 demo。

## 验证建议

- 优先针对受影响的组件区域做定向验证。
- 除非改动是跨模块的，否则应优先使用聚焦的 `flutter analyze`、相关测试或最小示例运行，而不是做过宽的全仓校验。

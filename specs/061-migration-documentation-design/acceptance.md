> **历史设计，已被后续方案取代。** 本阶段只交付设计。正文来源以 [Spec062](../062-documentation-source-consolidation/spec.md) 为准；阅读结构和组件定位以 [Spec064](../064-migration-reading-flow/spec.md) 为准；侧栏入口以 [Spec072](../072-migration-navigation-and-demo-entry/spec.md) 为准。原定57个独立章节、自动注入摘要和拟定锚点不再作为实施任务，不应据此重复开发。下文及 JSON 矩阵保留原始设计，不能作为当前页面清单或已验证声明。尚缺的真实业务迁移、设备和设计证据见 [发布收口记录](../074-release-readiness-closeout/readiness.md)。

> 文档路径和维护来源已由[Spec062](../062-documentation-source-consolidation/spec.md)调整；下文保留本阶段历史记录，未完成迁移内容和验收仍以原清单为准。

# 设计验收

日期：2026-10-15。结论：本次设计产物完成；生成接入和迁移内容补齐尚未实施，不表示发布准备完成。

## 已核对

- 读取仓库协作规范、现有迁移指南和57 项组件审计索引。
- 核对现有 `site.config.mjs` 已有迁移路由。
- 核对 `page-contract.mjs`：原始组件页只允许生成示例/API 入口，手写迁移段落被拒绝；因此选择渲染层自动注入摘要。
- 核对 `plugin-tdoc/transforms.ts` 存在组件路径识别与 Markdown 预处理入口，方案可以接入该层。
- 设计矩阵恰好57 项，目标组件文档全部存在，拟定锚点全部唯一；站点页面路由与拟定返回路径逐项核对。
- `git diff --check` 通过。

## 尚未验证

拟定锚点尚未写入正式指南；站点尚未显示升级提示。未执行新的 Flutter、站点构建、浏览器或 Golden 验收，因为本次仅增加设计文件。后续实施验证按 plan.md 与 tasks.md 执行。

本次只新增本目录设计文件，保留此前工作区改动；未调整 CI、组件实现、生成 API、发布版本或 CHANGELOG。

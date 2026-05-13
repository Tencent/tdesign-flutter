---
name: doc-sync
description: 保持仓库 README 源文件与下游文档同步。适用于编辑 `README.md`、`README_zh_CN.md`、`tdesign-component/README*`、`tdesign-site/site/docs/getting-started.md` 或相关引导文档时。
---

# 文档同步流程

## 源文件定义

- 将根目录 `README.md` 与 `README_zh_CN.md` 视为唯一源文件。
- `scripts/sync-readme.mjs` 会把根目录 README 同步到以下位置：
  - `tdesign-component/README.md`
  - `tdesign-component/README_zh_CN.md`
  - `tdesign-site/site/docs/getting-started.md`

## 操作流程

1. 优先修改根目录 README 源文件。
2. 执行 `node scripts/sync-readme.mjs`。
3. 检查被同步更新的下游文档。

## 适用边界

- 如果任务只涉及 `tdesign-site/src/**/README.md` 下的组件专属文档，则不需要触发根 README 同步。
- 更新共享 onboarding 内容时，优先使用根目录 `scripts/sync-readme.mjs`，而不是依赖旧的站点单点复制脚本。

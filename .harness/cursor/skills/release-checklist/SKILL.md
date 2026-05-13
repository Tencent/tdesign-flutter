---
name: release-checklist
description: 检查 Flutter 组件库、文档和适配层的发版准备情况。适用于准备发版、整理 changelog，或在合并与发布前做最终核查时。
---

# 发版检查清单

## 核对发版范围

- 确认预期中的组件库、示例和文档改动都已包含在本次交付中。
- 检查 README 或 onboarding 更新是否需要执行 `node scripts/sync-readme.mjs`。
- 检查 Flutter 版本适配文件或初始化说明是否仍与 `tdesign-component/init.sh` 保持一致。

## 验证步骤

1. 对改动区域执行最小必要验证。
2. 检查文档、example 和 demo 是否存在用户可见层面的漂移。
3. 明确标出尚未执行的手工发布、changelog 或后续跟进步骤。

## 输出要求

- 总结已经就绪的部分。
- 列出剩余风险和未验证路径。
- 将发版阻塞项与可选清理项分开描述。

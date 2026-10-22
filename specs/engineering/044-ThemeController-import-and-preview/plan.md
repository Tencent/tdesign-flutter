# import-and-preview 实施方案

<a id="source-044"></a>
<a id="source-066"></a>
<a id="source-067"></a>
<a id="source-068"></a>
<a id="source-080"></a>

## 实现组织

按 spec.md 中的职责边界组织实现，避免复制另一条配置、状态或验证路径；设计理由与被否决的方案只在 Spec 中维护。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 实现或验收入口 | [packages/css2token](../../../packages/css2token) | 与最终方案和候选范围同步维护 |
| 实现或验收入口 | [tdesign-component/example/tool/convert_theme.dart](https://github.com/Tencent/tdesign-flutter/blob/c352421d/tdesign-component/example/tool/convert_theme.dart) | 生成器导入工具属于独立 PR #1176 的固定检查点，尚未进入本 PR 的 develop 基础；本次仅保留设计与证据 |
| 实现或验收入口 | [tdesign-component/example/lib/util/web_theme_message.dart](../../../tdesign-component/example/lib/util/web_theme_message.dart) | 与最终方案和候选范围同步维护 |
| 实现或验收入口 | [tdesign-site/site/app.vue](../../../tdesign-site/site/app.vue) | 与最终方案和候选范围同步维护 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

本次文档整理不执行上述实现或候选验收，不据旧命令流水推定当前检查通过。

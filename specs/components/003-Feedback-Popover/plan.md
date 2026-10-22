# Popover 实施方案

<a id="record-003-contract-hardening"></a>
<a id="record-015-color-scheme-instance-ownership"></a>
<a id="record-022-public-api-convergence"></a>
<a id="record-027-controller-theme-lerp"></a>

## 实现组织

内容统一为 Widget；命令式 showPopover 与 Anchor/Controller 共用浮层路径，Controller 只管理开关，不复制配置。

保留自动翻转、裁剪约束和箭头安全区；展开期间配置不热替换，下一次展开读取新配置。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/popover](../../../tdesign-component/lib/src/components/popover) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/popover](../../../tdesign-component/test/components/popover) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

此前文档整理不代表实现验收；本轮文字槽实现与本地验证见后文和 acceptance.md，不据旧命令流水推定当前检查通过。

## 自定义内容默认值统一

在 patch 段落测量修复之上，将 TTextStyleScope 提升至整个内容子树，测量 Builder 使用槽内上下文。仅增加字体默认值，原生段落设置沿用 merge 语义；显式样式及内部较近主题优先。回归覆盖包装、明暗、缩放和支柱；截图独立用于审阅，不放入 Spec。

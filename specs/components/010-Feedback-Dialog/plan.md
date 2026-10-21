# Dialog 实施方案

## 实现组织

通过明确的内容与动作组合表达确认/取消，不把业务回调编进通用布局。

只修改必要的组合消费者；基础 Button 契约及主题所有权由对应 Spec 维护。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/dialog](../../../tdesign-component/lib/src/components/dialog) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/dialog](../../../tdesign-component/test/components/dialog) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

本次文档整理不执行上述实现或候选验收，不据旧命令流水推定当前检查通过。

<a id="source-083"></a>

## 083 · 文字槽实现与验证安排

- 恢复四处标题/正文包装，保留原生文字居中及现有样式解析；Dialog Popup 精确登记到所属组件视觉入口，补调度自测，保持 ActionSheet 过滤边界。
- 共享 Theme 自定义内容在 Dialog 外取得调用方 TD 文字默认，在内容内显式设置局部主题；功能与 Golden 复用同一场景，原登记功能文件补断言。
- 按原独立分支分别验证，不移用其他分支结论；先双版本功能/分析/覆盖率及生成产物检查，再比较 Dialog 与共享 Theme 的 Linux 原基线。API 文档只接受正式生成器产物，原范围和证据见 acceptance.md。

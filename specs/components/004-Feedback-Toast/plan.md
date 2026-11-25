# Toast 实施方案

<a id="record-004-contract-alignment"></a>
<a id="record-006-overlay-config-and-placement"></a>
<a id="record-054-overlay-pointer"></a>

## 实现组织

全部入口使用同一时长规则，零或负时长表示持续展示；取消特殊无限常量，减少两套生命周期语义。

遮罩可见性与背景交互独立；同 ID 替换避免叠加变暗，不同 ID 仍可并存。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/toast](../../../tdesign-component/lib/src/components/toast) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/toast](../../../tdesign-component/test/components/toast) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

此前文档整理不代表实现验收；本轮文字槽实现与本地验证见后文和 acceptance.md，不据旧命令流水推定当前检查通过。

## 文案槽一致性

showText / showLoading 的 customWidget 文案槽整个子树接入与各自内置文案相同的默认字体和反色文字，使用相同主题/实例配置解析。Row、Padding、Builder 不切断传递；显式字段及内容内部更近的 TTextThemeData 优先，全局隔离保持。自定义内容仍自行布局，不强加内置文案的一行/三行限制；不更改其他 Toast 类型或图标。

补充直接/布局包装、明暗/缩放、显式与局部主题、段落与受限布局回归；双 SDK 组件/覆盖率及分析，Linux 3.32 同环境前后截图和既有 Golden 比较。基线变更按已确认的视觉范围独立审阅，交付状态不作为长期实施约束。


## 1.0.1 overlay-lifecycle

仅修改本分支所属组件生产实现及已登记回归文件，保留既有 API、默认行为及 Controller 绑定规则。直接基于最新 develop 独立验证，不依赖其他修复分支。按实际 CI manifest 执行相关组件、示例非视觉测试及调度器自测；双 SDK 分别解析依赖、严格 analyze、生产覆盖率检查和生成器一致性检查。API 别名、废弃声明等 PR 5 内容不纳入。

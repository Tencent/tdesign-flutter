# Radio 设计说明

<a id="record-015-demo-alignment"></a>
<a id="record-042-group-api-refactor"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

单项和组选中状态重复，inline/block/card 的结构职责混杂。

Radio Demo 已按小程序公开示例整理结构和文案，但真机截图显示默认选中标记、长文案换行和横向布局仍存在差异。现有 `TRadio` 已具备主题色、尺寸和文本行数能力，但缺少内置勾选样式，`TRadioGroup` 也无法把行数配置传给子项。

当前 `TRadio` 通过 `value/groupValue/onChanged` 独立持有组状态，`TRadioGroup`
又持有同一份 `value/onChanged` 并将其转发给每个选项。Group 同时负责数据生成、
布局、卡片开关、分割线和自定义项交互，导致状态入口重复，`itemBuilder` 绕过
`TRadio` 后又由 Group 补充手势与语义。

普通 Radio 只要包含标题就会隐式采用通栏最小高度、背景和内边距。Form 等紧凑
场景无法通过组件 API 表达，只能修改 Theme 间距或在 Demo 中重新拼装图标、文案、
点击与无障碍语义。

## 范围与非目标

本组件的内容、状态、布局与生命周期按最终方案维护；跨组件 Token/Material 规则引用 Theme 工程 Spec，公开 Demo 与 Golden 范围引用对应工程规范，不把已取代的阶段限制继续作为当前要求。

## 最终方案与行为契约

- TRadioGroup<T> 拥有 value/onChanged，默认构造只提供状态；.options 提供标准选项布局并复用同一状态机制。TRadio 只持有单项 value 和 disabled，缺少同类型 Group 时明确报错。
- onChanged == null 表示整组禁用，单项 disabled 只禁用对应项；有效点击至多一次回调，每项保持单一互斥语义链。
- inline 不绘制通栏背景、外围 inset 或分割线，按内容自然换行；block 保持三档标准高度和背景，仅相邻项有分割线；card 保持卡片布局与角标。非 block 显式开启分割线是非法组合。
- 横向 inline 不用 columns 等分，首尾贴齐可用边缘，中间余量均分且至少 spacer16；card 的文案在边框内居中，四周 spacer16，角标不遮挡文案。
- 未选禁用指示器用 componentBorderColor 描边和 bgColorComponentDisabled 填充；标题、副标题、图标按 TD 状态样式解析，不继承外部 Material TextTheme。
- block 分割线从正文起点绘制，缩进由组件背景承接；Demo 不叠加无效外围留白。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | Group 是选中值和变更回调的唯一来源，单项只持有 value 与局部 disabled。 |
| 保留的边界与代价 | 提供纯状态容器与 options 标准布局两层入口，共用交互与语义路径；无 Group 的单项配置明确报错。 |

### 被取代的方案与原因

曾由单项和 Group 同时持有选中状态；最终只保留 Group 状态源。options 负责标准布局，child 入口负责自由组合，两者复用状态与语义，避免两套交互。

- `iconType` 为可选参数，但默认视觉由圆点调整为小程序的实心勾选，属于用户可感知的默认行为变化，需要按 breaking change 记录。
- `showDivider` 的默认值变化会影响未显式传参的既有布局，属于 breaking change；这是为对齐小程序默认 `borderless: false` 及 Checkbox 默认行为所作的契约调整。
- 横向示例仅通过局部 Radio Theme token 调整内边距，不为单个 Demo 扩展布局 API。
- 卡片示例复用 `cardMode`，不保留重复的 Demo 私有绘制。

- 所有直接 `TRadio` 和旧 Group 调用必须迁移，属于明确 breaking change。
- TRadio 离开 Group 无法工作；通过明确异常避免静默错误。
- 完全自定义选项需要调用方显式组合真实 TRadio，代码略多，但消除重复手势和语义源。
- inline 的视觉尺寸与触控区域需要通过组件测试和后续 Form 真机验收分别确认。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- 覆盖 Group 与 options 共用的受控状态、无 Group 报错、父级接受/拒绝与局部/整组禁用。
- 逐项验证 inline/block/card 几何、换行、分割线、角标和单一单选语义。
- 验证明暗与自定义 TD 样式、未选禁用颜色及真实单次回调，不从 Material 文本主题取得隐式状态色。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

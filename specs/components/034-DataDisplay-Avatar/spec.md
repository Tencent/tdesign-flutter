# Avatar 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

头像与头像组的尺寸、形状和样式配置重复，动态 Token 回退容易被插值预填覆盖。

Avatar 公开 Demo 的字符样式、头像组数量、尺寸与操作示例和移动端设计稿存在差异；组件使用 `variant` 表达形状，语义不准确，字符内容也无法通过实例参数使用主题颜色。

## 范围与非目标

本组件的内容、状态、布局与生命周期按最终方案维护；跨组件 Token/Material 规则引用 Theme 工程 Spec，公开 Demo 与 Golden 范围引用对应工程规范，不把已取代的阶段限制继续作为当前要求。

## 最终方案与行为契约

- shape 是唯一形状选择器；旧 variant/TAvatarVariant 已移除。实例 shape 决定头像及头像组成员的外框、裁剪、描边与阴影。
- TAvatarThemeData.foregroundColor 是内置图标和文字前景入口，不再提供同义 textStyle；字符头像按 size 使用内置字号和字重，特殊排版通过 child: Text(...) 组合。
- dimension、图标大小、圆角和组描边在成员规格与全局 Token 已知后解析有效值；两端未配置时保持回退，单边配置不能预填为中号尺寸或固定全局圆角。
- TAvatarGroup.dimension 控制成员外框，cascading 以 start/end 表达方向感知绘制层级。非 Avatar 子项回退默认形状；显式较小圆角不得仍绘制强制正圆。
- 对边长、重叠量与描边执行有限值及组合约束，避免负布局；图片失败保留自定义内容，无回调时不创建点击行为。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | shape 是唯一形状选择器，foregroundColor 是组件 Theme 的单一前景入口；复杂文字通过 child 组合。 |
| 保留的边界与代价 | 尺寸和圆角在消费处解析有效 Token 再插值，不在 Theme.lerp 中猜测中号或全局默认值。 |

### 被取代的方案与原因

早期为 shape 迁移保留了 deprecated variant，并在 Theme 同时保留文字样式；最终选择单一形状与前景入口，复杂文字通过 child 组合，接受删除冗余字段的源码兼容成本。

- 保留旧 API 和既有右侧成员在上层的默认行为，避免立即 breaking；纯展示 Demo 显式选择左侧在上。同时禁止新旧形状参数并用，消除优先级歧义。
- 头像组不强制 children 类型，维持 Flutter 组合能力；组会安全裁剪成员外框，但不会覆盖 `TAvatar` 自身的形状选择。
- 层叠枚举使用 `startUp` / `endUp`，与 `PositionedDirectional` 的布局方向保持同一语义。
- Theme 数值从空值过渡到显式值时按组件有效默认值插值；运行时 token 颜色无法脱离 `BuildContext` 求值，单边配置采用离散切换以避免透明色闪烁。
- Golden 仅在固定 Linux + Flutter 3.32 环境更新，避免宿主差异污染基线。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- 验证 shape、前景色、自然文字/图片/图标、头像组方向和自定义 child。
- 验证按成员规格解析的尺寸、圆角、描边与中断插值，不用固定中号默认值替代动态 Token。
- 测试无效尺寸/间距组合及图片失败，删除的 variant 和同义 textStyle 不重新形成公开入口。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

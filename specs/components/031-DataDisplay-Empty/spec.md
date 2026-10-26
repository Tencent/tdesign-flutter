# Empty 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

空状态变体重复表达内容是否存在，操作文案与回调限制组合。

- Figma Empty `24386:5266`；小程序 `origin/develop@cc2384cc5`。
- 公开 Demo 仅保留图标、自定义图片、带操作三种设计场景。
- 删除重复描述内容存在性的 `variant`；操作区直接由 Widget 组合。

## 范围与非目标

图片、图标、可选描述和 operation Widget 直接组合，不再使用冗余 variant。

## 最终方案与行为契约

- 图片优先于图标，描述始终可选；操作 Widget 非空时以 32 间距展示。
- 默认图标 96，图标/图片到描述间距分别为 22/16。
- Theme 只保存描述文字的具体颜色和字体，不保存按钮语义配色。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 图片、图标、可选描述和 operation Widget 直接组合，不再使用冗余 variant。 |
| 保留的边界与代价 | Theme 只提供描述视觉，不拥有操作按钮语义或业务行为。 |

## 兼容性与迁移

- 删除 `TEmptyVariant`、`variant`、`operationText`、`onPressed`。
- `customOperationWidget` 收敛并改名为 `operation`。

## 验收标准

- 组件、Demo、覆盖率、双版本 analyze/test 通过。
- Flutter 3.32.0 Linux light/dark Golden 更新并复验通过。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

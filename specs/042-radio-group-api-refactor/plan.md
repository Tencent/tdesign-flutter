# 实施方案

## 技术方案

- 在 Radio 内部增加泛型 `_TRadioGroupScope<T>`，传递受控值和 nullable 回调。
- `TRadioGroup` 默认构造包装调用方提供的 `child`；命名构造 `.options` 生成标准
  `Column/Wrap/TSelectionCardGroupLayout`。
- `TRadio` 从 Scope 派生 selected/disabled，并统一拥有手势及 Semantics。
- 用 `TRadioVariant` 替换 `cardMode` 与“有标题即通栏”的隐式结构判断。
- 普通分割线从单个 `TRadio` 移至 `.options` 的项间布局，避免末项关系泄漏到单项 API。
- 删除任意 Widget `itemBuilder`；完全自定义布局使用默认构造的 `child`，其中仍放置
  真实 `TRadio`。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/radio/` | breaking API、状态与三种视觉结构 |
| 测试 | `test/components/radio/` | 状态、回调、语义、布局及主题回归 |
| 示例 | Radio Demo 及仓库内调用 | 全部迁移到 Group 新构造；Form 保持 block 视觉 |
| 文档 | dartdoc、Spec、生成 API/示例 | 新契约与迁移方式 |

## API 变化

- 新增 `TRadioVariant.inline/block/card`。
- `TRadio` 删除 `groupValue`、`onChanged`、`cardMode`、`showDivider`，新增单项
  `disabled` 与 `variant`。
- `TRadioGroup` 默认构造改为 `child` 组合；原数据用法迁移至
  `TRadioGroup.options`。
- `TRadioGroup.options` 使用 `variant` 替换 `cardMode`，`showDivider` 改为 nullable
  并按 variant 解析。
- 删除 `TRadioOptionBuilder` 与 `itemBuilder`。

## 风险与取舍

- 所有直接 `TRadio` 和旧 Group 调用必须迁移，属于明确 breaking change。
- TRadio 离开 Group 无法工作；通过明确异常避免静默错误。
- 完全自定义选项需要调用方显式组合真实 TRadio，代码略多，但消除重复手势和语义源。
- inline 的视觉尺寸与触控区域需要通过组件测试和后续 Form 真机验收分别确认。

## 验证策略

- 单元测试：构造断言、Theme `copyWith/lerp`。
- Widget 测试：两种 Group 构造、回调次数、单项/整组禁用、缺失 Group、三种
  variant、方向、列数、分割线、主题与无障碍语义。
- 静态检查：`dart format`、生成器 `--check`、`flutter analyze --fatal-infos`。
- 视觉回归：先无更新参数执行 Radio Demo Golden；仅对确认的结构变化更新并复跑。
- 双版本：Flutter 3.32.0 与 latest 的集中式 Radio/Example 回归。
- 人工验收：运行 Radio Demo，检查纵向、横向、禁用、指示器位置与卡片示例。

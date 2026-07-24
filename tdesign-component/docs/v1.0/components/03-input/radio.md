# TRadio — v1.0 定稿

> **状态**：已实现 | **控制类**：B | **Sprint**：S2

**源码路径**：`lib/src/components/radio`

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘标准圆环与实心圆点指示器 |
| Material | 对齐 Radio 交互语义；视觉由 TDesign 自绘 |
| Theme | `TRadioThemeData` |
| 禁用 | `onChanged: null` |

## API

### TRadio

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `value` | `T` | - | 本选项标识 |
| `groupValue` | `T?` | - | 当前组选中值 |
| `onChanged` | `ValueChanged<T>?` | - | 选中变更；为 null 时禁用 |
| `title` | `String?` | - | 主标题 |
| `subTitle` | `String?` | - | 副标题 |
| `size` | `TRadioSize` | `medium` | 指示器尺寸 |
| `cardMode` | `bool` | `false` | 卡片模式 |
| `showDivider` | `bool` | `false` | 是否显示底部分割线 |
| `contentDirection` | `TContentDirection` | `right` | 指示器与文案排列方向 |
| `customIconBuilder` | `TRadioIconBuilder?` | - | 自定义指示器 |

### TRadioGroup

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `value` | `T?` | - | 受控选中值 |
| `options` | `List<TRadioOption<T>>` | - | 数据项 |
| `onChanged` | `ValueChanged<T>?` | - | 选中值变化；为 null 时整组禁用 |
| `direction` | `Axis` | `vertical` | 排列方向 |
| `columns` | `int` | `1` | 横向或多列排列的列数 |
| `itemBuilder` | `TRadioOptionBuilder<T>?` | - | 自定义数据项视觉，Group 仍统一持有交互 |

### 类型

| 类型 | 成员 / 字段 | 说明 |
|---|---|---|
| `TRadioSize` | `large` / `medium` / `small` | 指示器尺寸 |
| `TContentDirection` | `left` / `right` | 内容排列方向 |
| `TRadioOption<T>` | `value` / `label` / `subTitle` / `disabled` | Group 数据项 |
| `TRadioThemeData` | ThemeExtension | 组件级主题 |

## Theme

`TRadioThemeData` 通过 `Theme.of(context).mergeExtension(...)` 注入子树，或通过 `MaterialApp.theme.extensions` 注入全局。

| 字段 | 说明 |
|---|---|
| `selectColor` | 选中态颜色 |
| `disableColor` | 禁用态颜色 |
| `titleColor` | 标题颜色 |
| `subTitleColor` | 副标题颜色 |
| `backgroundColor` | 卡片背景色 |
| `spacing` | 指示器与文案间距 |
| `insetSpacing` | 内容内边距 |

## 实现约束

- `TRadio` 与 `TRadioGroup` 均严格受控，不提供命令式控制器。
- Radio 标准视觉固定为圆环加实心圆点；特殊视觉通过 `customIconBuilder`。
- 禁用只通过 `onChanged: null` 表达；数据项禁用使用 `TRadioOption.disabled`。
- 卡片模式与 Checkbox 共用选择卡片视觉和布局规则。

## 验收

| 项 | 要求 |
|---|---|
| 测试 | 覆盖单项、互斥 Group、禁用、卡片、自定义 itemBuilder |
| 文档 | 公开 API 说明列不得为 `-` |
| 覆盖率 | 组件源码总覆盖率不低于 95% |
| API 边界 | 源码、测试、示例、API 文档不得出现命令式控制器、重复 variant 或重复回调入口 |

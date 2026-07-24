# TCheckbox — v1.0 定稿

> **状态**：已实现 | **控制类**：B | **Sprint**：S2

**源码路径**：`lib/src/components/checkbox`

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘指示器与内容布局；点击热区对齐 Material Checkbox 契约 |
| Material | `CheckboxThemeData` 负责 density / tap target |
| Theme | `TCheckboxThemeData` 负责 TDesign 颜色、间距、文字样式与卡片视觉 |
| 禁用 | `onChanged: null` |

## API

### TCheckbox

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `value` | `bool?` | - | 受控选中态；`null` 表示半选态 |
| `onChanged` | `ValueChanged<bool?>?` | - | 选中态变更；为 null 时禁用 |
| `title` | `String?` | - | 主标题 |
| `subTitle` | `String?` | - | 副标题 |
| `size` | `TCheckboxSize` | `medium` | 指示器尺寸 |
| `cardMode` | `bool` | `false` | 卡片模式 |
| `customIconBuilder` | `Widget Function(bool checked)?` | - | 自定义指示器 |
| `contentDirection` | `TContentDirection` | `right` | 指示器与文案排列方向 |
| `showDivider` | `bool` | `false` | 是否显示底部分割线 |

### TCheckboxGroup

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `value` | `List<T>` | - | 受控选中项列表 |
| `options` | `List<TCheckboxOption<T>>` | - | 数据项 |
| `onChanged` | `ValueChanged<List<T>>?` | - | 选中项列表变更；为 null 时整组禁用 |
| `itemBuilder` | `TCheckboxOptionBuilder<T>?` | - | 自定义数据项视觉，Group 仍统一持有交互 |
| `contentDirection` | `TContentDirection` | `right` | 指示器与文案排列方向 |

### 类型

| 类型 | 成员 / 字段 | 说明 |
|---|---|---|
| `TCheckboxSize` | `large` / `medium` / `small` | 指示器尺寸 |
| `TContentDirection` | `left` / `right` | 内容排列方向 |
| `TCheckboxOption<T>` | `value` / `label` / `subTitle` / `disabled` | Group 数据项 |
| `TCheckboxThemeData` | ThemeExtension | 组件级主题 |

## Theme

`TCheckboxThemeData` 通过 `Theme.of(context).mergeExtension(...)` 注入子树，或通过 `MaterialApp.theme.extensions` 注入全局。

| 字段 | 说明 |
|---|---|
| `variant` | 指示器视觉变体 |
| `selectColor` | 选中态颜色 |
| `disableColor` | 禁用态颜色 |
| `titleColor` | 标题颜色 |
| `subTitleColor` | 副标题颜色 |
| `backgroundColor` | 卡片背景色 |
| `spacing` | 指示器与文案间距 |
| `insetSpacing` | 内容内边距 |
| `customSpace` | 自定义外部间距 |

Material `CheckboxThemeData` 只负责 Material density、tap target、overlay、shape、side 等 Material 语义；TDesign 颜色和卡片布局不写入 Material Theme。

## 实现约束

- `TCheckbox` 与 `TCheckboxGroup` 均严格受控，不提供命令式控制器。
- 禁用只通过 `onChanged: null` 表达；数据项禁用使用 `TCheckboxOption.disabled`。
- 纯控件、标题行、卡片模式的点击热区不得小于指示器本身。
- `cardMode` 隐藏默认指示器，使用卡片边框和角标表达选中态。

## 验收

| 项 | 要求 |
|---|---|
| 测试 | 覆盖单项、三态、禁用、Group、多列/卡片、自定义 itemBuilder |
| 文档 | 公开 API 说明列不得为 `-` |
| 覆盖率 | 组件源码总覆盖率不低于 95% |
| API 边界 | 源码、测试、示例、API 文档不得出现命令式控制器或重复回调入口 |

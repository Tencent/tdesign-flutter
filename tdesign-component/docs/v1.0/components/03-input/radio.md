# TRadio — v1.0 定稿

> Sprint **S2** | 控制类 **B** | Material: Radio / RadioListTile / RadioGroup
> 源码：`lib/src/components/radio` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 选择控件薄包装 |
| Material | Radio / RadioListTile / RadioGroup |
| Theme | `TRadioThemeData` |
| 禁用 | `onChanged: null`（B 类）。Group 整组锁定同样 `onChanged: null`。 |
| L4 | `cardMode` → **`TRadioThemeData`** |

## 受控

`value` + `onChanged`；无 `defaultValue`。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TRadio | 单选项 |
| TRadioGroup | 互斥组 |
| TRadioThemeData | L4 默认样式 |
| TRadioGroupController | 组级命令式控制 |
| TRadioSize | 尺寸 |
| TContentDirection | 文案与控件方向 |
| value | 选项值 `T`（单颗）或当前选中 `T?`（Group） |
| onChanged | `ValueChanged<T>?` |
| title / subTitle | 文案 |
| titleMaxLine / subTitleMaxLine | 行数限制 |
| contentDirection | 排列方向 |
| customContentBuilder / customIconBuilder | 自定义内容/图标 |
| cardMode / showDivider | 布局 |
| size | 尺寸 |
| strictMode | 不可取消选中 |
| direction | Group 布局轴 |
| children | Group 选项列表 |
| child | Group 自由布局 |
| rowCount / passThrough / divider | Group 布局 |
| controller | Group Controller |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| id | value | 命名对齐 v1.0 |
| selectId | value: T? | 对齐 Material |
| enable | onChanged: null | Material 禁用 |
| onRadioGroupChange | onChanged | 命名对齐 v1.0 |
| TRadioStyle | TRadioThemeData | L4 → Theme |
| radioStyle | TRadioThemeData.radioStyle | L4 → Theme |
| radioCheckStyle | TRadioThemeData.radioCheckStyle | L4 → Theme |
| selectColor / disableColor / titleColor / subTitleColor / backgroundColor | TRadioThemeData | L4 → Theme |
| titleFont / subTitleFont | TRadioThemeData | L4 → Theme |
| spacing / checkBoxLeftSpace / insetSpacing / customSpace | TRadioThemeData.spacing | L4 → Theme |
| directionalTdRadios | children | 命名对齐 v1.0 |
| TCheckboxGroupController | TRadioGroupController | 命名对齐 v1.0 |

### 废弃

| 符号 | 原因 |
| --- | --- |
| `TRadio extends TCheckbox` | 废弃继承 → 薄包装 Material `Radio` / `RadioListTile` |
| OnRadioGroupChange | 废弃 → 使用 `ValueChanged<T>?` |
| `OnRadioGroupChange` | 改用 `ValueChanged<T>?` |
| enable | 禁用见 `onChanged: null` |

### 新增

| 符号 | 说明 |
| --- | --- |
| **TRadio**\<T\> | 单选项；内部 Material `Radio<T>` + 可选 `RadioListTile` 布局 |
| **TRadioGroup**\<T\> | 互斥组；语义对齐 Material `RadioGroup<T>`（`groupValue`→`value`） |
| **TRadioThemeData** | L4 色、字号、间距、`radioStyle` 等 |
| **TRadioGroupController** | 可选；命令式改选中项 |
| toggleable | 不暴露 — Radio 固定不可三态（Material `toggleable: false`） |

### export

- **保留**：`TRadio`、`TRadioGroup`、`TRadioThemeData`、`TRadioGroupController`、`TRadioSize`、`TContentDirection`
- **移出**：`TRadioStyle`、`HollowCircle` 等内部绘制类、对 `TCheckbox`/`TCheckboxGroup` 实现的 re-export（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TRadioThemeData` · Material: **Radio / RadioListTile / RadioGroup** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value`（单颗） | Material **`Radio.value`** | 本选项标识 `T` |
| `value`（Group） | Material **`RadioGroup.groupValue`** | v1.0 统一命名 **`value: T?`** |
| `onChanged` | Material **`Radio.onChanged`** / **`RadioGroup.onChanged`** | `null` 禁用；Group 下发至子 `Radio` |
| `title` / `subtitle` | Material **`RadioListTile`** | 映射 `title` / `subTitle` |
| `fillColor` / `overlayColor` / `splashRadius` / `visualDensity` / `materialTapTargetSize` | Material **`RadioThemeData`** | `WidgetStateProperty` 三态 |
| `radioStyle` / `radioCheckStyle`（circle/check/hollowCircle…） | TDesign **`TRadioThemeData`** | Material 仅 M3 圆环；TDesign 多形态 |
| `disableColor` / `selectColor` / 文案色 / `spacing` | TDesign **`TRadioThemeData`** | 0.2.x 构造器 L4 迁入 |
| `cardMode` / `direction` / `rowCount` | **TDesign 扩展** | 布局；Material `RadioGroup` 无内置 |

# TCheckbox — v1.0 定稿

> Sprint **S2** | 控制类 **B** | Material: Checkbox
> 源码：`lib/src/components/checkbox` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 选择控件薄包装 |
| Material | Checkbox |
| Theme | `TCheckboxThemeData` |
| 禁用 | `onChanged: null`。 |
| L4 | 构造器 L4 → `TCheckboxThemeData` |

## 受控

`value` + `onChanged`；无 `defaultValue`。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TCheckBoxSize | 尺寸/位置枚举保留 |
| TContentDirection | 标题与控件排列方向（ KEEP） |
| id | Group 内必填，纳入 `TCheckboxGroup` 管理 |
| size | 复选框大小 |
| cardMode | 展示为卡片模式 |
| customIconBuilder | 自定义 Checkbox 显示样式 |
| title | 主标题文案（ KEEP） |
| subTitle | 副标题文案（ KEEP） |
| titleMaxLine | 主标题最大行数 |
| subTitleMaxLine | 副标题最大行数 |
| contentDirection | 内容排列方向 |
| customContentBuilder | 自定义内容区（替代 title/subTitle） |
| showDivider | 列表项底部分割线（cardMode/列表场景） |
| value | 由 `checked` 迁移；`bool?` 三态 |
| onChanged | `ValueChanged<bool?>?`；由 `onCheckBoxChanged` 迁移 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TCheckboxStyle | TCheckboxThemeData | L4 → Theme |
| enable | onChanged: null | Material 禁用 |
| checked | value | 受控统一为 value |
| style | TCheckboxThemeData | L4 → Theme |
| onCheckBoxChanged | onChanged | 命名对齐 v1.0 |
| OnCheckValueChanged | ValueChanged<bool?>? | 对齐 Material |
| backgroundColor | TCheckboxThemeData | L4 → Theme |
| selectColor | TCheckboxThemeData | L4 → Theme |
| disableColor | TCheckboxThemeData | L4 → Theme |
| titleColor | TCheckboxThemeData | L4 → Theme |
| subTitleColor | TCheckboxThemeData | L4 → Theme |
| titleFont | TCheckboxThemeData | L4 → Theme |
| subTitleFont | TCheckboxThemeData | L4 → Theme |
| insetSpacing | TCheckboxThemeData | L4 → Theme |
| spacing | TCheckboxThemeData | L4 → Theme |
| checkBoxLeftSpace | TCheckboxThemeData.spacing | L4 → Theme |
| customSpace | TCheckboxThemeData.spacing | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TCheckbox`、`TCheckboxThemeData`、`TCheckBoxSize`、`TContentDirection`
- **移出**：`TCheckboxStyle`、内部 `HollowCircle` 等绘制类（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TCheckboxThemeData` · Material: **Checkbox** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `fillColor` / `checkColor` / `overlayColor` / `splashRadius` | Material **`CheckboxThemeData`** | 三态（`WidgetStateProperty`）；映射 0.2.x `selectColor`/`disableColor` |
| `side` / `shape` / `visualDensity` / `materialTapTargetSize` | Material **`CheckboxThemeData`** | 边框与形状 |
| `style`（原 `TCheckboxStyle`） | TDesign **`TCheckboxThemeData`** | TDesign 勾选形态枚举；Material 无同名 variant |
| `backgroundColor` / `radius` | TDesign 扩展 | **`cardMode`** 卡片背景与圆角；Material `Checkbox` 无 card 容器 |
| `titleColor` / `subTitleColor` / `titleFont` / `subTitleFont` | TDesign 扩展 | 文案区样式；Material `Checkbox` 仅控件，标题由外层 `ListTile` 或 TDesign 布局承担 |
| `insetSpacing` / `spacing` | TDesign 扩展 | 控件与标题间距；Material 无统一间距 token |

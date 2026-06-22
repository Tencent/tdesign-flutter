# TSelectTag — v1.0 定稿

> Sprint **S3** | 控制类 **B** | Material: FilterChip
> 源码：`lib/src/components/select-tag` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 选择控件薄包装 |
| Material | FilterChip |
| Theme | `TTagThemeData` |
| 禁用 | 交互锁定用 `onChanged: null`（B 类）。 |
| L4 | 构造器 L4 → `TTagThemeData` |

## 受控

`value` + `onChanged`；无 `defaultValue`。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| size | 标签大小 |
| text | KEEP：L1–L3 高频 / Material 同名 |
| icon | KEEP：L1–L3 高频 / Material 同名 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| theme | colorScheme | 命名对齐 v1.0 |
| selectStyle | TSelectTagThemeData | L4 → Theme |
| unSelectStyle | TSelectTagThemeData | L4 → Theme |
| disableSelectStyle | TSelectTagThemeData | L4 → Theme |
| onSelectChanged | onChanged | 命名对齐 v1.0 |
| isSelected | value | 命名对齐 v1.0 |
| iconWidget | TTagThemeData | L4 → Theme |
| padding | TTagThemeData | L4 → Theme |
| forceVerticalCenter | TTagThemeData | L4 → Theme |
| isOutline | TTagThemeData | L4 → Theme |
| shape | TTagThemeData | L4 → Theme |
| isLight | TTagThemeData | L4 → Theme |
| needCloseIcon | TTagThemeData | L4 → Theme |
| onCloseTap | TTagThemeData | L4 → Theme |
| fixedWidth | TTagThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TSelectTag`、`TTagThemeData`
- **移出**：`selectStyle`/`unSelectStyle`/`disableSelectStyle` 等 Style 类（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TTagThemeData` · Material: **FilterChip** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `backgroundColor` / `labelStyle` / `side` / `padding` | Material **`ChipTheme`** | 标签/芯片 |
| `selectStyle` | TDesign **`TTagThemeData`** | 0.2.x L4 迁入（§1 迁移表） |

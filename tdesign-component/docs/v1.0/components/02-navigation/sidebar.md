# TSideBar — v1.0 定稿

> Sprint **S3** | 控制类 **B** | Material: 自绘
> 源码：`lib/src/components/sidebar` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 选择控件薄包装 |
| Material | 自绘 |
| Theme | `TSideBarThemeData` |
| 禁用 | 整栏 onChanged: null；单项 TSidebarItem.disab |
| L4 | `children` → **`TSideBarThemeData`** |

## 受控

`value` + `onChanged`；无 `defaultValue`。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| children | KEEP：L1–L3 高频 / Material 同名 |
| controller | KEEP：L1–L3 高频 / Material 同名 |
| loadingWidget | KEEP：L1–L3 高频 / Material 同名 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TSideBarStyle | TSideBarThemeData | L4 → Theme |
| selectedTextStyle | TSideBarThemeData | L4 → Theme |
| style | TSidebarThemeData | L4 → Theme |
| defaultValue | value | 命名对齐 v1.0 |
| selectedColor | TSideBarThemeData | L4 → Theme |
| unSelectedColor | TSideBarThemeData | L4 → Theme |
| height | TSideBarThemeData | L4 → Theme |
| contentPadding | TSideBarThemeData | L4 → Theme |
| loading | TSideBarThemeData | L4 → Theme |
| selectedBgColor | TSideBarThemeData | L4 → Theme |
| unSelectedBgColor | TSideBarThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TSideBar`、`TSideBarThemeData`
- **移出**：`TSideBarStyle`、`selectedTextStyle` 等 L4 Style（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TSideBarThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `selectedColor` / `unSelectedColor` / `selectedBgColor` / `contentPadding` | TDesign **`TSideBarThemeData`** | 0.2.x L4 默认 |
| `children` / `value` / `onChanged` | **实例 KEEP** | B 类受控与树数据 |

# TCheckboxGroup — v1.0 定稿

> Sprint **S2** | 控制类 **B** | Material: Column+Checkbox
> 源码：`lib/src/components/checkbox-group` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 选择控件薄包装 |
| Material | Column+Checkbox |
| Theme | `TCheckboxThemeData` |
| 禁用 | Group 容器无 Widget 级 `disabled`。 |
| L4 | 构造器 L4 → `TCheckboxThemeData` |

## 受控

`value` + `onChanged`；无 `defaultValue`。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TCheckboxGroup | 多选组 |
| TCheckboxGroupController | 组级命令式控制 |
| customIconBuilder | 自定义选择icon的样式 |
| child | 保留 |
| controller | 保留 |
| titleMaxLine | 保留 |
| customContentBuilder | 保留 |
| contentDirection | 保留 |
| onChanged | `ValueChanged<List<T>>?`；由 `onChangeGroup` 迁移 |
| value | 由 `checkedIds` 迁移 |
| maxChecked | 保留 — 最多可选数量 |
| onOverloadChecked | 保留 — 超出 `maxChecked` 时回调 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| onChangeGroup | onChanged | 命名对齐 v1.0 |
| checkedIds | value | 命名对齐 v1.0 |
| style | TCheckboxThemeData | L4 → Theme |
| spacing | TCheckboxThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| OnGroupChange | 废弃 → `onChanged: ValueChanged<List<T>>?` |
| OnCheckBoxGroupChange | 废弃 → 同上 |

### 新增

_无_

### export

- **保留**：`TCheckboxGroup`、`TCheckboxGroupController`、`TCheckboxThemeData`
- **移出**：`OnGroupChange`、`OnCheckBoxGroupChange` 旧 typedef（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TCheckboxThemeData` · Material: **Column+Checkbox** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` / `onChanged` | Material **`Checkbox`** 组语义 | C 类；Form **`TFormField<List<T>>`** |
| `options` / `maxChecked` | 实例 KEEP | 选项与上限 |
| `onOverloadChecked` | 实例 KEEP | 超限回调（不进 Form validator） |
| `spacing` | **`TCheckboxThemeData`** | L4 |

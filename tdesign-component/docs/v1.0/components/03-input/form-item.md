# TFormItem — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: —
> 源码：`lib/src/components/form/t_form_item.dart` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | — |
| Theme | `TFormThemeData` |
| 禁用 | Item 本身无 bool。 |
| L4 | 构造器 L4 → `TFormThemeData` |

## 受控

无受控 value；按子交互控件控制类处理。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| labelWidget | 自定义标签 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| type / TFormItemType | type / TFormItemType | 删除；`child: TFormField(...)` 组合 |
| formRules / itemRule | formRules / itemRule | 迁入子树 `TFormField.rules` |
| backgroundColor | TFormThemeData | L4 → Theme |
| indicator | TFormThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| select / selectFn | 随 `TFormItemType` 删除 |
| formItemNotifier | 校验改 FormState |
| 字段型 props | 不再根据 type 渲染 Input/Switch 等 |

### 新增

_无_

### export

- **保留**：`TFormItem`、`TFormThemeData`
- **移出**：内部校验/布局 helper（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TFormThemeData` · Material: **—** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `label` | Material **`InputDecoration.labelText`** 语义 | 实例 KEEP |
| `help` | **`helperText`** 语义 | 实例 KEEP |
| `error`（来自子树） | **`errorText`** 语义 | 子 **`TFormField.errorText`** |
| 横/竖布局 | TDesign 扩展 | 见 [form.md §4](../foundation/form.md#4-字段组件接入) |
| 组件默认样式 | **`TFormThemeData`** | 共享 Form Theme |

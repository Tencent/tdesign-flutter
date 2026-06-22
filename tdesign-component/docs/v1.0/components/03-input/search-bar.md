# TSearchBar — v1.0 定稿

> Sprint **S2** | 控制类 **D** | Material: TInput 组合
> 源码：`lib/src/components/search-bar` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material `TextField` 薄包装 |
| Material | TInput 组合 |
| Theme | `TSearchBarThemeData` |
| 禁用 | enabled: false / readOnly: true |
| L4 | 构造器 L4 → `TSearchBarThemeData` |

## 受控

`controller` 主路径 / `initialValue` 辅（init 一次）。禁用：`enabled` / `readOnly`（不用 `onChanged: null`）。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| needCancel | 是否显示取消按钮 |
| controller / focusNode | D 类受控 |
| enabled / readOnly | 禁用与只读 |
| autoFocus / inputAction | Material 同名 |
| onSubmitted / onTapOutside / onEditComplete | 提交与焦点 |
| action / onActionClick / onClearClick | 取消与清除 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| placeHolder | hintText | 对齐 Material / TInput |
| onTextChanged | onChanged | D 类文本通知 |
| TSearchStyle | TSearchBarThemeData | square / round |
| style | TSearchBarThemeData | L4 → Theme |
| TSearchAlignment | TSearchBarThemeData | 对齐方式 |
| alignment | TSearchBarThemeData | L4 → Theme |
| padding / backgroundColor / cursorHeight | TSearchBarThemeData | L4 → Theme |
| mediumStyle / autoHeight | TSearchBarThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| onInputClick | 只读场景用 `readOnly` + `onTap`；不单独暴露 |

### 新增

| 符号 | 说明 |
| --- | --- |
| TInputController | 与 TInput 共用 |
| TSearchBarThemeData | L4 默认 |

### export

- **保留**：`TSearchBar`、`TSearchBarThemeData`、`TInputController`
- **移出**：`TSearchStyle`、`TSearchAlignment`（迁入 Theme）（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TSearchBarThemeData` · Material: **TInput 组合** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| 输入区 | 复用 **`TInput` / `TextField`** | `controller`、`hintText`、`onChanged`、`enabled` |
| `needCancel` / 取消文案 | TDesign **`TSearchBarThemeData`** | 搜索条特有 |
| `backgroundColor` / `padding` / `alignment` | TDesign 扩展 | 容器与搜索图标区 |
| `style` / `mediumStyle` | **MERGE** → `TSearchBarThemeData` 单一默认 |  |

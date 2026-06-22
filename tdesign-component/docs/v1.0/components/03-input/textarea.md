# TTextarea — v1.0 定稿

> Sprint **S2** | 控制类 **D** | Material: TextField multiline
> 源码：`lib/src/components/textarea` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material `TextField` 薄包装 |
| Material | TextField multiline |
| Theme | `TInputThemeData` |
| 禁用 | enabled: false / readOnly: true |
| L4 | 构造器 L4 → `TInputThemeData` |

## 受控

`controller` 主路径 / `initialValue` 辅（init 一次）。禁用：`enabled` / `readOnly`（不用 `onChanged: null`）。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| controller | 主路径受控 |
| enabled | 禁用 |
| readOnly | 只读 |
| label | 标签 |
| hintText | 提示 |
| maxLines | 行数 |
| maxLength | 字数 |
| autofocus | 自动聚焦 |
| focusNode | 焦点 |
| onChanged | 文本变更 |
| onEditingComplete | 编辑完成 |
| decoration | P0 逃逸舱 |
| TFormField | Form 桥接 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TTextareaLayout | TTextareaLayout | 合并进 `TInputLayout` 或保留为多行子集 enum |
| textStyle | TInputThemeData | L4 → Theme |
| hintTextStyle | TInputThemeData | L4 → Theme |
| labelStyle | TInputThemeData | L4 → Theme |
| backgroundColor | TInputThemeData | L4 → Theme |
| decoration | decoration | 单一 `decoration` / `inputDecoration` 逃逸舱 |
| textareaDecoration | 同上 | 同上 |
| textInputBackgroundColor | TInputThemeData | L4 → Theme |
| cursorColor | TInputThemeData | L4 → Theme |
| additionInfoColor | TInputThemeData | L4 → Theme |
| labelWidth | TInputThemeData | L4 → Theme |
| margin | TInputThemeData | L4 → Theme |
| padding | TInputThemeData | L4 → Theme |
| bordered | TInputThemeData | L4 → Theme |

### 废弃

_无_

### 新增

| 符号 | 说明 |
| --- | --- |
| TInput.multiline() | 推荐新代码路径（input.md 双轨） |

### export

- **保留**：`TTextarea`、`TInputThemeData`（与 TInput 共用）、`TFormField`；推荐 `TInput.multiline()`
- **移出**：独立 `TTextareaThemeData`（不新建）、`input_view.dart`、`TTextareaLayout` 若未收敛则移出（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TInputThemeData` · Material: **TextField multiline** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `InputDecorationTheme` 各字段 | Material **`inputDecorationTheme`** | 边框/背景/hint |
| 多行 `minLines` / `autosize` 默认 | TDesign **`TInputThemeData`** | 与 [TInput §2.1](./input.md#21-material-字段-vs-tdesign-扩展) **共用**，不建 `TTextareaThemeData` |

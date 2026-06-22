# TInput — v1.0 定稿

> Sprint **S2** | 控制类 **D** | Material: TextField
> 源码：`lib/src/components/input` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material `TextField` 薄包装 |
| Material | TextField |
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
| TInputLayout | 六种布局 |
| controller | 主路径受控 |
| enabled | 完全禁用 |
| readOnly | 只读 |
| label | 标签 |
| hintText | 提示 |
| prefix | 前缀 |
| suffix | 后缀 |
| layout | 布局形态 |
| maxLines | 行数 |
| maxLength | 字数 |
| obscureText | 密码 |
| autofocus | 自动聚焦 |
| focusNode | 焦点 |
| inputType | 键盘类型 |
| textAlign | 对齐 |
| onChanged | 文本变更 |
| onSubmitted | 提交 |
| decoration | P0 逃逸舱 |
| TInputController | Controller |
| TFormField | Form 桥接 |
| TInput.multiline() | 多行 factory |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TInputType | TInputLayout | 命名对齐 v1.0 |
| TCardStyle | TInputThemeData | L4 → Theme |
| backgroundColor | TInputThemeData | L4 → Theme |
| leftLabel | label | 命名对齐 v1.0 |
| leftIcon | prefix | 命名对齐 v1.0 |
| textStyle | TInputThemeData | L4 → Theme |
| hintTextStyle | TInputThemeData | L4 → Theme |
| cardStyleTopText | TInputThemeData | L4 → Theme |
| cardStyleBottomText | TInputThemeData | L4 → Theme |
| textInputBackgroundColor | TInputThemeData | L4 → Theme |
| cursorColor | TInputThemeData | L4 → Theme |
| clearBtnColor | TInputThemeData | L4 → Theme |
| contentPadding | TInputThemeData | L4 → Theme |
| type | layout: TInputLayout | 命名对齐 v1.0 |
| cardStyle | TInputThemeData | L4 → Theme |
| additionInfoColor | TInputThemeData | L4 → Theme |
| rightWidget | suffix | 命名对齐 v1.0 |
| leftLabelStyle | TInputThemeData | L4 → Theme |
| leftInfoWidth | TInputThemeData | L4 → Theme |
| showBottomDivider | TInputThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| leftLabelSpace | → `TInputThemeData`（间距合并） |
| leftContentSpace | → `TInputThemeData`（间距合并） |
| clearIconSize | → `TInputThemeData` |
| needClear | → `TInputThemeData.showClearButton` 默认 |
| spacer | 与 `contentPadding` 重复，删除 |

### 新增

_无_

### export

- **保留**：`TInput`、`TInputController`、`TInputLayout`、`TInputThemeData`、`TInput.multiline()`、`TFormField`
- **移出**：`TInputStyle` / `TCardStyle`、内部 `input_view.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TInputThemeData` · Material: **TextField** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `border` / `enabledBorder` / `errorBorder` / `focusedBorder` / `disabledBorder` | Material **`InputDecorationTheme`** | 边框三态 |
| `fillColor` / `filled` / `contentPadding` / `isDense` | Material **`InputDecorationTheme`** | 背景与内边距 |
| `hintStyle` / `labelStyle` / `helperStyle` / `errorStyle` | Material **`InputDecorationTheme`** | 文案样式；映射 0.2.x `hintTextStyle`/`leftLabelStyle` |
| `prefixIconColor` / `suffixIconColor` / `iconColor` | Material **`InputDecorationTheme`** | 图标色 |
| `defaultLayout` / `defaultSize` | TDesign **`TInputThemeData`** | Material 无 TDesign layout（normal/card/…）语义 |
| `cardStyle` / `cardStyleTopText` / `cardStyleBottomText` | TDesign 扩展 | **Card layout** 专属；Material `TextField` 无 card 形态 |
| `textStyle` / `cursorColor` / `clearBtnColor` | TDesign 扩展 | 输入正文/光标/清除按钮；部分可通过 `InputDecorationTheme` 近似，TDesign 统一收口 |
| `backgroundColor` / `textInputBackgroundColor` / `additionInfoColor` | TDesign 扩展 | 容器层背景与附加信息色 |
| `contentPadding`（TDesign 粒度） | TDesign 扩展（可选） | 与 Material `contentPadding` merge；0.2.x 多组间距 L4 迁入 |


**双轨**：`TInput.multiline()` 为主；`TTextarea` 保留别名。

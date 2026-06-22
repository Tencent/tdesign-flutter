# TForm — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: `Form` + `FormState`
> 源码：`lib/src/components/form` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | `Form` + `FormState` |
| Theme | `TFormThemeData` |
| 禁用 | 废弃 TForm(disabled: true)；改为各字段 TFormFiel |
| L4 | `child` → **`TFormThemeData`** |

## 受控

无受控 value；按子交互控件控制类处理。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TForm | 表单容器；内部包装 Material `Form` |
| child | 组合式字段（`TFormItem` + `TFormField`） |
| rules | 跨端规则表；编译为 `validator` |
| controller | `TFormController` |
| showErrorMessage | 是否展示错误文案 |
| scrollToFirstError | 校验失败后滚动到首个错误 |
| onSubmit | 校验通过后回调 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| items | child | `child` 组合式 |
| formShowErrorMessage | showErrorMessage | `showErrorMessage` |
| formController | controller | `controller`（`TFormController`） |
| colon | TFormThemeData.showColon | L4 → Theme |
| labelWidth | TFormThemeData | L4 → Theme |
| isHorizontal | layout: TFormLayout | 命名对齐 v1.0 |

### 废弃

| 符号 | 原因 |
| --- | --- |
| data | 集中式 Map；改 `TFormField.name` 收集 |
| TFormItemType | 硬编码字段类型；改组合式 |
| btnGroup | 按钮组移出 Form 或业务自建 |
| preventSubmitDefault | 删除 |
| submitWithWarningMessage | 删除自研逻辑 |
| TFormValidation.check() | 改 Material `FormState.validate()` |
| disabled | 废弃 → 各 `TFormField(enabled: false)` |

### 新增

| 符号 | 说明 |
| --- | --- |
| TFormField\<T\> | 见 form.md |
| TFormController | `submit()` / `reset()` / 触达 `FormState` |
| autovalidateMode | 对齐 Material `Form.autovalidateMode` |
| scrollToFirstError | 校验失败后滚动到首个错误项（ KEEP） |

### export

- **保留**：`t_form.dart` 主入口、`TForm`、`TFormController`、`TFormField`
- **移出**：内部校验引擎、仅布局用的过宽 Inherited export（按附录 C 评审）

---

## 2. Theme

`TFormThemeData` · Material: **`Form` + `FormState`** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `autovalidateMode` / `FormState` | Material **`Form`** | 校验时机与状态机 |
| `onChanged`（字段级） | Material **`FormField`** | 经子树 **`TFormField`** 上报 |
| `controller` / `showErrorMessage` | TDesign 扩展 | **`TFormController`** + 错误展示开关 |
| `layout` / `colon` / `labelWidth` | TDesign **`TFormThemeData`** | 横竖布局与标签区 L4 |
| `child` 组合式 | Flutter 组合 | 替代 0.2.x `items` / `TFormItemType` |

# Form 与 Input 职责及 API 对齐

## 背景

当前 `TForm`、`TFormField`、`TFormItem` 已经可以组合完成表单，但字段校验、表单项视觉结构和输入组件之间存在反向依赖：输入组件直接读取表单 scope，`TInput` 的 `label` 与 `TFormItem.label` 产生重复语义，清除按钮也同时存在组件行为和主题布尔开关两套配置。

TDesign MiniProgram 将表单能力划分为 `Form` 与 `FormItem`；Flutter 还提供原生 `Form` / `FormField`，因此本次对齐采用语义对齐，不复制小程序的模板式数据 API，也不新增高级包装组件。

## 目标

- 明确 `TForm`、`TFormField`、`TFormItem` 的职责和依赖方向。
- 保留 Flutter 受控字段和 `FormField` 校验模式。
- 补齐小程序 Form 中必要的表单操作：按字段校验、清除校验、外部错误注入。
- 允许 `TFormItem` 脱离 `TForm` 使用。
- 移除 `TInput` / `TTextarea` 的重复表单 label 语义。
- 将清除按钮配置收敛为 `clearButtonMode`。
- 复用 `TFormItem.help` 和 `errorText`，不新增 `tips`。
- 保留 Flutter `TextField` / `EditableText` 的编辑、焦点、IME 和无障碍能力，重构 TDesign 外层视觉结构。
- 覆盖小程序 Input、Textarea Demo 所需的边框、状态、字符限制、计数器和自适应高度场景。

## 非目标

- 不新增 `TFormInput`、`TFormTextarea` 等高级组合组件。
- 不将小程序的 `data`、`rules` 对象直接复制到 `TForm`，字段值仍由 Flutter 受控字段管理。
- 不把小程序的模板/slot API 原样复制为 Flutter API；Flutter 使用 Widget、Controller、Formatter 和 ThemeExtension。
- 不手动修改 `CHANGELOG.md`。

## 范围

### 涉及

- `TForm`、`TFormController`、`TFormField` 的字段状态和校验 API。
- `TFormItem` 的错误展示和独立使用行为。
- `TInput`、`TTextarea` 的 label 与 clear button API。
- Form/Input 相关测试、Example 和公开 API dartdoc。

### 不涉及

- 其他组件的表单适配。
- 小程序专属的滚动到首个错误、warning 提交策略。
- 其他组件的视觉重构和小程序专属平台能力（键盘高度、同层渲染、安全键盘等）。

## 行为契约

### 组件关系

```text
TForm                 表单生命周期、字段注册和统一操作
  └─ TFormField<T>    字段值、规则和校验状态
       └─ TFormItem   label、必填标记、help/error 和布局
            └─ TInput / TTextarea  编辑行为和输入视觉
```

三者均可独立使用。`TFormItem` 没有 `TForm` 时，`required` 只显示标记；`errorText` 只使用显式传入的错误文案。

### TForm

- 继续负责 `validate`、`submit`、`reset`、`onChanged`、`onSubmit`。
- 增加 `validate(fields: ...)`、`clearValidate(fields: ...)` 和 `setValidateMessage(...)`。
- 外部错误文案优先于字段本地校验错误；清除校验时同时清除外部错误。
- 视觉默认值继续由 `TFormThemeData` 提供，不在 `TForm` 和 `TFormItem` 之间复制同一套默认参数。

### TFormField

- 负责 `name`、受控 `value`、`onChanged`、`required`、`rules`、`validator`。
- `required` 是校验规则，并向子树提供必填状态供 `TFormItem` 展示标记。
- builder 继续接收 value、onChanged 和 errorText，不增加 label、layout 或输入专属参数。

### TFormItem

- 负责 `label`、`required` 展示覆盖、`help`、`errorText`、`labelWidth`、`labelAlign`、`extra` 和布局；表单级 `requiredMarkPosition` 由 `TFormThemeData` 提供，默认与小程序左侧标记对齐。
- 继承字段错误时，error 优先于 help；显式 `errorText` 优先于字段错误。
- 不负责字段注册、校验规则、controller、键盘、maxlength 或清除按钮。
- 默认视觉使用小程序 FormItem 的容器结构：容器背景、16px 水平/垂直内边距和底部分隔线；放置输入组件时，输入组件的默认外层内边距由 FormItem 内部作用域压缩，避免出现双重留白。
- `TFormThemeData.borderColor` 可覆盖 FormItem 底部分隔线颜色，用于小程序自定义主题或无边界 Demo。

### TInput / TTextarea

- 移除 `label`，label 由 `TFormItem` 或外层页面结构提供。
- `clearButtonMode` 为单一清除按钮配置：`never`、`always`、`focused`。
- `clearButtonMode` 默认 `never`，与小程序 `clearable=false` 对齐；需要清除能力时显式使用 `always` 或 `focused`。
- `suffix` 存在时不自动插入清除按钮。
- `maxLength` 保留 Flutter 原生 grapheme 计数语义；新增 Dart 风格的 `maxCharacter`，按小程序规则以 ASCII 字符 1、非 ASCII 字符 2 计数。
- `TInputStatus` 提供 `normal`、`success`、`warning`、`error` 四种状态；状态只影响输入壳层和计数/帮助色，不替代 `TFormItem` 的字段错误展示。
- `borderless` 控制输入壳层是否绘制边框；`TTextarea.bordered` 为小程序语义的正向别名，二者不在同一组件上重复暴露。
- 非 `borderless` 的单行 `TInput` 默认绘制底部分隔线，匹配小程序 Input；通过 `TInputThemeData.borderRadius` 设置圆角时使用完整边框，用于标签外置等标准输入框场景。
- `TTextarea.indicator` 在配置 `maxLength` 或 `maxCharacter` 时展示当前计数；`autosize` 通过 `minLines`/`maxLines` 组合实现，避免引入平台专属布局 API。
- `decoration` 保留为 Material 迁移逃逸口，仅补充输入内核属性，不再决定默认 TDesign 外层布局。
- `TInputThemeData.borderColor` 可覆盖输入壳层边框颜色；`backgroundColor`、`contentPadding` 和 `borderRadius` 继续负责对应的外层视觉 token。

### 视觉 Demo 契约

- Input、Textarea、Form Demo 使用小程序示例的页面层级：导航栏后以灰色说明条分组，示例内容位于连续的白色容器中。
- Demo 页面不通过外层 `DefaultTextStyle`、颜色或局部 Theme 伪造组件状态；白色容器、分隔线、内边距和字段行由组件或 Demo 页面结构表达。状态颜色由组件根据 `status` 解析，Demo 不再覆盖清除图标等状态颜色。
- Demo 视觉对齐优先验证容器层级、字段行高度、标签与内容的相对位置、分隔线和状态颜色，再验证代码面板等 Example 基础设施。

## 验收标准

- [x] `TFormItem` 可在没有 `TForm` 的页面中独立显示 label、help、errorText 和 required 标记。
- [x] `TFormController` 支持全量及按字段 validate、clearValidate、setValidateMessage。
- [x] Form 外部错误能展示在对应 `TFormItem`，且清除校验后消失。
- [x] `TInput` / `TTextarea` 不再提供 label 参数，清除按钮只由 `clearButtonMode` 决定。
- [x] 默认输入壳层不依赖 Material `InputDecoration` 的 border/fill/padding 绘制，ThemeData 的 Material 输入主题不会污染 TDesign 视觉。
- [x] Input 覆盖基础、前后缀、密码、禁用、只读、清除、边框、状态、`maxLength`、`maxCharacter` 场景。
- [x] 非多行 TInput 通过 `TInputThemeData.borderRadius` 支持完整圆角边框，Demo 不再手绘输入框外框。
- [x] Textarea 覆盖基础、边框、只读、`maxLength`/`maxCharacter` 计数和 min/max 行数场景。
- [x] Form Demo 展示横向/纵向布局、help/error、required、外部校验错误和 reset/submit。
- [x] Form/Input 相关测试通过，`flutter analyze` 零告警。
- [x] Flutter 3.32.0 与 3.47.0 均不使用不兼容 API。

# Form 与 Input 职责及 API 对齐

## 背景

当前 `TForm`、`TFormField`、`TFormItem` 已经可以组合完成表单，但字段校验、表单项视觉结构和输入组件之间存在反向依赖：输入组件直接读取表单 scope，`TInput` 的 `label` 与 `TFormItem.label` 产生重复语义，清除按钮也同时存在组件行为和主题布尔开关两套配置。

TDesign MiniProgram 将表单能力划分为 `Form` 与 `FormItem`；Flutter 还提供原生 `Form` / `FormField`，因此本次对齐采用语义对齐，不复制小程序的模板式数据 API，也不新增高级包装组件。

## 目标

- 明确 `TForm`、`TFormField`、`TFormItem` 的职责和依赖方向。
- 保留 Flutter 受控字段和 `FormField` 校验模式。
- 补齐小程序 Form 中必要的表单操作：按字段校验、清除校验、外部错误注入。
- 允许 `TFormItem` 脱离 `TForm` 使用。
- 移除 `TInput` 的重复表单 label 语义；Textarea 的独立内部标题与表单字段标签分开定义。
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
- `TInput`、`TTextarea` 的标题、clear button 与多行视觉 API。
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
- 未显式配置 `autovalidateMode` 时，初始使用 `disabled`；仅完整 `submit()` 校验失败后切换为 `onUserInteraction`。`validate()`（含指定字段校验）和校验成功的 `submit()` 不改变后续自动校验时机；显式配置时完整遵循 Flutter 的 `disabled`、`always`、`onUserInteraction` 和 `onUnfocus` 语义。
- 视觉默认值继续由 `TFormThemeData` 提供，不在 `TForm` 和 `TFormItem` 之间复制同一套默认参数。

### TFormField

- 负责 `name`、受控 `value`、`onChanged`、`required` 和 Flutter 原生语义的 `validator`。
- 删除与 `validator` 职责重复的 `TFormRule` / `rules`；多个约束在单个 `validator` 中按顺序组合，避免两套校验入口和优先级。
- `required` 是校验规则，并向子树提供必填状态供 `TFormItem` 展示标记。
- builder 继续接收 value、onChanged 和 errorText，不增加 label、layout 或输入专属参数。

### TFormItem

- 负责 `leading`、`label`、`required` 展示覆盖、`help`、`errorText`、`labelWidth`、`labelAlign`、`extra` 和布局；默认标签宽度为 80dp，对齐小程序最大 `5em`；`leading` 用于标签区域前的字段行图标等结构，不进入输入组件的编辑内容区；表单级 `requiredMarkPosition` 由 `TFormThemeData` 提供，默认与小程序左侧标记对齐。
- 继承字段错误时，error 优先于 help；显式 `errorText` 优先于字段错误。
- 不负责字段注册、校验规则、controller、键盘、maxlength 或清除按钮。
- 默认视觉使用小程序 FormItem 的容器结构：容器背景、16px 水平/垂直内边距和底部分隔线；放置输入组件时，输入组件的默认外层内边距由 FormItem 内部作用域压缩，避免出现双重留白。
- `TFormThemeData.borderColor` 可覆盖 FormItem 底部分隔线颜色，用于小程序自定义主题或无边界 Demo。
- `TFormThemeData.leadingGap` 可覆盖前置内容与标签区域的间距，默认读取 8dp 间距 token。
- `TFormThemeData.contentAlignment` 提供字段内容区域的全局默认水平对齐，`TFormItem.contentAlignment` 可逐项覆盖；仅提供 RTL 安全的 `start`、`end`，并同时对齐 child、help 和 error，不改变输入文本自身的 `textAlign`。
- label 默认使用 `fontBodyLarge + textColorPrimary`；help 使用 `fontBodySmall + textColorPlaceholder`；error 使用 `fontBodySmall + errorNormalColor`。组件主题中的局部 TextStyle 只覆盖显式字段，不得清空其余 token 字体属性。
- `TFormItemVerticalAlignment` 只提供 `start`、`center` 两种水平布局下的语义化纵向对齐；实例配置优先于 `TFormThemeData.verticalAlignment`，默认 `start` 保持多行字段与消息场景的现有行为，不暴露 Flutter `CrossAxisAlignment`。
- `extra` 保持纯 Widget 插槽，不附加固定 Padding、Transform 或尺寸；它与 label、字段内容共同遵循上述纵向对齐。Input Demo 的普通图标行使用 `center`，带 tips 的操作按钮保持 `start`，对应小程序默认与 `.extra` 局部覆盖。
- 竖向布局只将 label 与 controls 的内部结构改为纵向排列；`extra` 仍是表单项外层右侧操作区，并与内部内容垂直居中，不得落到 controls 下方。

### TInput / TTextarea

- `TInput` 不提供 label，表单字段 label 由 `TFormItem` 提供。
- `TTextarea.label` 仅表达独立多行输入框内部的标题，使用 `fontBodyMedium + textColorPrimary`；位于 `TFormItem` 中时仍使用 `TFormItem.label`，不得同时传入两份标签。
- `clearButtonMode` 为单一清除按钮配置：`never`、`always`、`focused`。
- `clearButtonMode` 默认 `never`，与小程序 `clearable=false` 对齐；需要清除能力时显式使用 `always` 或 `focused`。
- `suffix` 存在时不自动插入清除按钮。
- `showPasswordToggle` 是 TInput 的可选密码能力；初始显隐状态读取 `obscureText`，显隐切换由组件内部维护，眼睛按钮使用 TDesign 图标和固定图标槽。
- `prefix` / `suffix` 作为内容插槽时，普通图标使用 24dp 图标尺寸和 token 默认图标样式；密码显隐按钮同样使用 24dp 图标槽，不得额外撑高标准 56dp 输入框。Demo 不再在输入框外重复拼接普通图标。
- `maxLength` 保留 Flutter 原生 grapheme 计数语义；新增 Dart 风格的 `maxCharacter`，按小程序规则以 Unicode code point 加权计算，ASCII code point 计 1、非 ASCII code point 计 2。
- `TInputStatus` 提供 `normal`、`success`、`warning`、`error` 四种状态；状态只影响输入壳层和计数/帮助色，已输入文字始终使用正常正文色，且状态不替代 `TFormItem` 的字段错误展示。
- `borderless` 控制输入壳层是否绘制边框；`TTextarea.bordered` 为小程序语义的正向别名，二者不在同一组件上重复暴露。
- 非 `borderless` 的单行 `TInput` 默认绘制底部分隔线，匹配小程序 Input；通过 `TInputThemeData.borderRadius` 设置圆角时使用完整边框，用于标签外置等标准输入框场景。
- `TTextarea.indicator` 在配置 `maxLength` 或 `maxCharacter` 时展示当前计数；`autosize` 通过 `minLines`/`maxLines` 组合实现，避免引入平台专属布局 API。
- Textarea 输入文字使用 `fontBodyLarge`，placeholder 使用 `fontBodyMedium + textColorPlaceholder`，indicator 使用 `fontBodySmall + textColorPlaceholder`；标题与编辑区、编辑区与 indicator 的间距均读取 `spacer8`。
- 独立 Textarea 默认由组件提供 16dp 容器内边距和容器背景；放入 `TFormItem` 时自动去除这层内边距和背景，避免 Demo 或业务手工抵消双重留白。
- 不公开 Material `InputDecoration` 透传入口；hint、前后置内容、背景、边框、内边距、label 和 help/error 分别由 TInput、TInputThemeData 和 TFormItem 的专属 API 负责，避免两套视觉配置冲突。
- `TInputThemeData.borderColor` 可覆盖输入壳层在聚焦与非聚焦状态下的边框颜色；`backgroundColor`、`contentPadding`、`borderRadius` 和 `hintStyle` 继续负责对应的视觉 token。独立输入组件的表单错误样式复用 Material `InputDecorationTheme.errorStyle`，`TFormItem` 内的错误仍由 `TFormThemeData.errorStyle` 控制；Textarea 内部标题复用 Flutter `TextTheme.bodyMedium`。
- 单行 Input 的输入文字和提示词默认使用完整 `fontBodyLarge`；Textarea 按上述多行 token 解析。Theme 或实例只配置颜色时必须保留 token 字号与行高。组件主题文字颜色覆盖所有可用状态的输入文字，状态语义色仅由输入壳层、计数器和错误提示消费；实例 `style.color` 仍具有最高优先级。

### 视觉 Demo 契约

- Input、Textarea、Form Demo 使用小程序示例的页面层级：导航栏后以灰色说明条分组，示例内容位于连续的白色容器中。
- Demo 页面不通过外层 `DefaultTextStyle`、颜色或局部 Theme 伪造组件状态；白色容器、分隔线、内边距和字段行由组件或 Demo 页面结构表达。状态颜色由组件根据 `status` 解析，Demo 不再覆盖清除图标等状态颜色。
- 带图标且带标签的示例使用 `TFormItem.leading + label` 表达字段行结构；`TInput.prefix` 只演示输入内容区前缀，不承载标签文案。
- 自定义样式输入框只在 Demo 覆盖颜色和外层留白，不重复声明组件默认字号、行高或字段行内边距。
- Form Demo 的水平/竖直布局使用同一组用户名、密码、性别、生日、籍贯、年限、自我评价、个人简介、上传照片字段；禁用状态逐组件传递，不使用整棵子树透明度模拟。
- Form Demo 的生日和籍贯是选择触发器，不使用只读 `TInput` 模拟编辑行为；`TFormItem` 负责字段行和内容对齐，业务组合使用文本展示当前值并通过手势打开 Picker，同时提供按钮语义。
- Form Demo 的上传照片字段使用与其他字段相同的表单级校验时机：首次提交前只更新受控文件列表，提交时统一执行空列表必填校验，首次提交后再随用户交互更新错误；Upload 组件只负责回传受控文件列表。
- Textarea Demo 的固定高度、卡片圆角和外置标签容器属于示例场景；内部标题、默认 padding、placeholder 和 indicator 的 token 样式由组件负责。
- Demo 视觉对齐优先验证容器层级、字段行高度、标签与内容的相对位置、分隔线和状态颜色，再验证代码面板等 Example 基础设施。

## 验收标准

- [x] `TFormItem` 可在没有 `TForm` 的页面中独立显示 label、help、errorText 和 required 标记。
- [x] `TFormController` 支持全量及按字段 validate、clearValidate、setValidateMessage。
- [x] Form 外部错误能展示在对应 `TFormItem`，且清除校验后消失。
- [x] `TInput` 不再提供 label；`TTextarea.label` 仅承担独立内部标题，清除按钮只由 `clearButtonMode` 决定。
- [x] `TInput`、`TTextarea` 不再公开 `decoration`，`TInputThemeData` 使用专属 `hintStyle` 代替 `decorationTheme`。
- [x] 默认输入壳层不依赖 Material `InputDecoration` 的 border/fill/padding 绘制，ThemeData 的 Material 输入主题不会污染 TDesign 视觉。
- [x] Input 覆盖基础、前后缀、密码显隐、禁用、只读、清除、边框、状态、`maxLength`、`maxCharacter` 场景。
- [x] 非多行 TInput 通过 `TInputThemeData.borderRadius` 支持完整圆角边框，Demo 不再手绘输入框外框。
- [x] Textarea 覆盖基础、内部标题、边框、禁用、`maxLength`/`maxCharacter` 计数和 min/max 行数场景。
- [x] Form Demo 展示与小程序一致的横向/纵向字段矩阵、禁用、校验和 reset/submit。
- [x] Form/Input 相关测试通过，`flutter analyze` 零告警。
- [x] Flutter 3.32.0 与 3.47.0 均不使用不兼容 API。

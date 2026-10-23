# Form 设计说明

<a id="record-008-input-contract-alignment"></a>
<a id="record-039-design-details"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

字段值、校验状态、标签布局和编辑视觉曾混在多个入口中。

当前 `TForm`、`TFormField`、`TFormItem` 已经可以组合完成表单，但字段校验、表单项视觉结构和输入组件之间存在反向依赖：输入组件直接读取表单 scope，`TInput` 的 `label` 与 `TFormItem.label` 产生重复语义，清除按钮也同时存在组件行为和主题布尔开关两套配置。

TDesign MiniProgram 将表单能力划分为 `Form` 与 `FormItem`；Flutter 还提供原生 `Form` / `FormField`，因此本次对齐采用语义对齐，不复制小程序的模板式数据 API，也不新增高级包装组件。

Form Demo 的默认正常态、排布选择器、禁用开关、水平字段对齐、竖向性别间距和底部操作与指定设计稿不一致。组件整体 Review 同时发现受控字段同步、Controller 绑定、Theme 动画和必填标记局部样式存在契约缺口。

设计基准为 Figma `Form 表单 移动端展示` 节点 [`41936:17938`](https://www.figma.com/design/mdBVCCVGERhxoZLle2eLT0/Flutter-%E8%AE%BE%E8%AE%A1%E8%B5%B0%E6%9F%A5-%E2%80%94%E2%80%94-%E7%A7%BB%E5%8A%A8%E7%AB%AF%E5%B1%95%E7%A4%BA---%E4%BA%A4%E4%BA%92---%E6%96%B0%E5%A2%9E%E7%BB%84%E4%BB%B6?node-id=41936-17938)，画板尺寸为 375 × 1254。旧节点 `45666:6110` 不作为本 PR 的验收依据。

## 范围与非目标

### 目标

- 明确 `TForm`、`TFormField`、`TFormItem` 的职责和依赖方向。
- 保留 Flutter 受控字段和 `FormField` 校验模式。
- 补齐小程序 Form 中必要的表单操作：按字段校验、清除校验、外部错误注入。
- 允许 `TFormItem` 脱离 `TForm` 使用。
- 移除 `TInput` 的重复表单 label 语义；Textarea 的独立内部标题与表单字段标签分开定义。
- 将清除按钮配置收敛为 `clearButtonMode`。
- 复用 `TFormItem.help` 和 `errorText`，不新增 `tips`。
- 保留 Flutter `TextField` / `EditableText` 的编辑、焦点、IME 和无障碍能力，重构 TDesign 外层视觉结构。
- 覆盖小程序 Input、Textarea Demo 所需的边框、状态、字符限制、计数器和自适应高度场景。

- 未选排布按钮使用 `#F3F3F3` 对应的语义 Token。
- 禁用态 Switch 轨道由当前组件状态 Token 解析；Form Demo 不覆盖颜色模拟旧截图。
- 水平表单性别项垂直居中，选择类内容统一左对齐。
- 竖向性别标题到选项 8dp、选项到底部 16dp。
- 两种排布均按“重置、提交”排列，重置为浅色、提交为主要样式。
- 提交按钮通过 `TForm.onSubmit` 接收校验后的表单值，并在成功时给出明确反馈。
- 正常态默认展示设计稿中的用户名、密码、性别、生日、籍贯、年限、评分、个人简介和上传图片；用户名默认态不展示提示文案。
- 排布标题使用设计稿文案“竖向排布”，个人简介内容完整显示且不溢出。
- `TForm.onChanged` 触发时控制器已经包含本次字段值；外部受控值同步不伪装成用户交互。
- 字段 `onChanged` 内读取、校验或提交时使用本次值；`clearValidate` 不卸载字段子树或丢失输入焦点。
- 一个 `TFormController` 同时只绑定一个存活的 `TForm`。
- `TFormThemeData` 从默认值过渡到显式值时不从零尺寸或透明色开始，必填标记局部样式保留默认错误色。
- Form Demo 的查看代码入口展示与实际运行一致且依赖完整的示例。
- Demo 禁用时字段本身也处于禁用语义；日期和籍贯确认后再次打开从当前值继续选择。

### 涉及

- `TForm`、`TFormController`、`TFormField` 的字段状态和校验 API。
- `TFormItem` 的错误展示和独立使用行为。
- `TInput`、`TTextarea` 的标题、clear button 与多行视觉 API。
- Form/Input 相关测试、Example 和公开 API dartdoc。

- Form 受控字段同步、Controller 绑定保护、Theme 解析和组件测试。
- Form Demo 组合、可查看示例、Demo 测试及视觉回归。

### 不涉及

- 不新增 `TFormInput`、`TFormTextarea` 等高级组合组件。
- 不将小程序的 `data`、`rules` 对象直接复制到 `TForm`，字段值仍由 Flutter 受控字段管理。
- 不把小程序的模板/slot API 原样复制为 Flutter API；Flutter 使用 Widget、Controller、Formatter 和 ThemeExtension。
- 不手动修改 `CHANGELOG.md`。

- 其他组件的表单适配。
- 小程序专属的滚动到首个错误、warning 提交策略。
- 其他组件的视觉重构和小程序专属平台能力（键盘高度、同层渲染、安全键盘等）。

- 不新增 Form、Radio、Button、Switch 公开字段或构造参数。
- 不改变表单校验和提交数据结构；Demo 仅消费既有提交回调，重置恢复设计稿展示的默认值。

- Radio、Button、Switch 等其他通用组件的默认主题契约。

## 最终方案与行为契约

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
- `validate(fields: ...)` 遇到未注册或尚未完成构建的字段时返回失败，不静默视为通过。
- 外部错误文案优先于字段本地校验错误；清除校验时同时清除外部错误。
- `clearValidate(fields: ...)` 只清除字段校验展示与外部错误，不重置或改写受控字段值；清除后再次校验必须使用最新 `value`。
- `reset()` 继续委托 Flutter `FormState.reset()` 重置原生字段，同时只重建受控 `TFormField` 的交互与校验状态，不得把其值恢复为过期的 `initialValue`。
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
- `TFormThemeData.contentAlignment` 提供字段内容区域的全局默认水平对齐，`TFormItem.contentAlignment` 可逐项覆盖；提供 RTL 安全的 `start`、`center`、`end`，并同时对齐 child、help 和 error，不改变输入文本自身的 `textAlign`。`center` 档通过内容区 `Align` 包裹实现，使 `TStepper`、`TRate` 等自身不铺满宽度（`MainAxisSize.min`）的字段控件同样参与对齐。
- label 默认使用 `fontBodyLarge + textColorPrimary`；help 使用 `fontBodySmall + textColorPlaceholder`；error 使用 `fontBodySmall + errorNormalColor`。组件主题中的局部 TextStyle 只覆盖显式字段，不得清空其余 token 字体属性。
- `TFormItemVerticalAlignment` 只提供 `start`、`center` 两种水平布局下的语义化纵向对齐；实例配置优先于 `TFormThemeData.verticalAlignment`，默认 `start` 保持多行字段与消息场景的现有行为，不暴露 Flutter `CrossAxisAlignment`。
- `extra` 保持纯 Widget 插槽，不附加固定 Padding、Transform 或尺寸；它与 label、字段内容共同遵循上述纵向对齐。Input Demo 的普通图标行使用 `center`，带 tips 的操作按钮保持 `start`，对应小程序默认与 `.extra` 局部覆盖。
- 竖向布局只将 label 与 controls 的内部结构改为纵向排列；`extra` 仍是表单项外层右侧操作区，并与内部内容垂直居中，不得落到 controls 下方。

### TInput / TTextarea

- `TInput` 不提供 label，表单字段 label 由 `TFormItem` 提供。
- 删除与 `TTextarea` 重复的 `TInput.multiline` 命名构造器；`maxLines` / `minLines` 唯一决定多行布局，`inputType` 只选择 Flutter 键盘类型，不参与视觉布局判断。正式多行输入场景统一使用 `TTextarea`。
- `TTextarea.label` 仅表达独立多行输入框内部的标题，使用 `fontBodyMedium + textColorPrimary`；位于 `TFormItem` 中时仍使用 `TFormItem.label`，不得同时传入两份标签。内部标题默认与编辑区横向排列；`TTextareaLayout.vertical` 用于组件样式中的显式竖排场景。
- `clearButtonMode` 为单一清除按钮配置：`never`、`always`、`focused`。
- `clearButtonMode` 默认 `never`，与小程序 `clearable=false` 对齐；需要清除能力时显式使用 `always` 或 `focused`。
- `suffix` 存在时不自动插入清除按钮。
- `showPasswordToggle` 是 TInput 的可选密码能力；初始显隐状态读取 `obscureText`，显隐切换由组件内部维护，眼睛按钮使用 TDesign 图标和固定图标槽。
- `prefix` / `suffix` 作为内容插槽时，普通图标使用 24dp 图标尺寸和 token 默认图标样式；密码显隐按钮同样使用 24dp 图标槽，不得额外撑高标准 56dp 输入框。Demo 不再在输入框外重复拼接普通图标。
- `maxLength` 保留 Flutter 原生 grapheme 计数语义；新增 Dart 风格的 `maxCharacter`，按 Unicode code point 加权计算，ASCII code point 计 1、非 ASCII code point 计 2。提交文本超限时保留不超过上限的最长前缀；IME composing 期间暂不截断，提交后执行，避免破坏组合输入。
- `TInputStatus` 提供 `normal`、`success`、`warning`、`error` 四种状态；状态只影响输入壳层和计数/帮助色，已输入文字始终使用正常正文色，且状态不替代 `TFormItem` 的字段错误展示。
- `borderless` 控制输入壳层是否绘制边框；`TTextarea.bordered` 为小程序语义的正向别名，二者不在同一组件上重复暴露。
- 非 `borderless` 的单行 `TInput` 默认绘制底部分隔线，匹配小程序 Input；通过 `TInputThemeData.borderRadius` 设置圆角时使用完整边框，用于标签外置等标准输入框场景。
- `TTextarea.indicator` 在配置 `maxLength` 或 `maxCharacter` 时展示当前计数；`autosize` 通过 `minLines`/`maxLines` 组合实现，避免引入平台专属布局 API。
- Textarea 输入文字使用 `fontBodyLarge`，placeholder 使用 `fontBodyMedium + textColorPlaceholder`，indicator 使用 `fontBodySmall + textColorPlaceholder`；横排标题与编辑区的间距读取 `spacer16`，竖排标题与编辑区、编辑区与 indicator 的间距读取 `spacer8`。
- 独立 Textarea 默认由组件提供 16dp 容器内边距和容器背景；放入 `TFormItem` 时自动去除这层内边距和背景，避免 Demo 或业务手工抵消双重留白。
- 不公开 Material `InputDecoration` 透传入口；hint、前后置内容、背景、边框、内边距、label 和 help/error 分别由 TInput、TInputThemeData 和 TFormItem 的专属 API 负责，避免两套视觉配置冲突。
- `TInputThemeData.borderColor` 可覆盖输入壳层在聚焦与非聚焦状态下的边框颜色；`backgroundColor`、`contentPadding`、`borderRadius` 和 `hintStyle` 继续负责对应的视觉 token。输入组件自身展示的表单错误文字使用 TD `fontBodySmall` 与 `errorColor`；`TFormItem` 展示的错误由 `TFormThemeData.errorStyle` 控制。Textarea 内部标题使用 TD `fontBodyMedium`，按启用状态选择主文字色或禁用色；均不从 Material 输入或文字主题隐式取值。
- 单行 Input 的输入文字和提示词默认使用完整 `fontBodyLarge`；Textarea 按上述多行 token 解析。输入实例 `style` 按字段覆盖 token 排版；可用态文字优先使用实例 `style.color`，禁用态使用 `textColorDisabled`。组件 Theme 的 `hintStyle` 只配置提示词，不提供另一套输入文字 style；输入壳层、计数器和错误提示按自身状态解析语义色。

### 视觉 Demo 契约

- Input、Textarea、Form Demo 使用小程序示例的页面层级：导航栏后以灰色说明条分组，示例内容位于连续的白色容器中。
- Demo 页面不通过外层 `DefaultTextStyle`、颜色或局部 Theme 伪造组件状态；白色容器、分隔线、内边距和字段行由组件或 Demo 页面结构表达。状态颜色由组件根据 `status` 解析，Demo 不再覆盖清除图标等状态颜色。
- 带图标且带标签的示例使用 `TFormItem.leading + label` 表达字段行结构；`TInput.prefix` 只演示输入内容区前缀，不承载标签文案。
- 自定义样式输入框只在 Demo 覆盖颜色和外层留白，不重复声明组件默认字号、行高或字段行内边距。
- Form Demo 的水平/竖直布局使用同一组用户名、密码、性别、生日、籍贯、年限、自我评价、个人简介、上传照片字段；禁用状态逐组件传递，不使用整棵子树透明度模拟。
- Form Demo 的生日和籍贯是选择触发器，不使用只读 `TInput` 模拟编辑行为；`TFormItem` 负责字段行和内容对齐，业务组合使用文本展示当前值并通过手势打开 Picker，同时提供按钮语义。
- Form Demo 的上传照片字段使用与其他字段相同的表单级校验时机：首次提交前只更新受控文件列表，提交时统一执行空列表必填校验，首次提交后再随用户交互更新错误；Upload 组件只负责回传受控文件列表。
- Textarea Demo 的固定高度、卡片圆角和外置标签容器属于示例场景；默认 Textarea 保持方形容器，只有 `bordered` 或显式主题圆角才绘制圆角。内部标题、布局、默认 padding、placeholder 和 indicator 的 token 样式由组件负责。Demo 不展示设计稿中不存在的按字符权重限制场景，`03 组件样式` 依次展示竖排样式与卡片样式。
- Input 与 Textarea 的外置标签 Demo 统一由可独立使用的 `TFormItem` 表达，不在 Demo 手写标签字号、颜色和间距。
- Demo 视觉对齐优先验证容器层级、字段行高度、标签与内容的相对位置、分隔线和状态颜色，再验证代码面板等 Example 基础设施。

Demo 只通过现有组件 API、Theme 和基础布局组合表达设计；颜色使用 `bgColorSecondaryContainer`、`componentBorderColor` 等语义 Token。水平与竖向性别项共用 `TRadioGroup.options` 的 `inline` 结构，不在 Demo 中重复实现 Radio 的手势、状态或无障碍语义。正常态和重置态使用同一组设计默认值，避免页面初始展示与重置结果漂移。提交按钮调用 `TFormController.submit`，由 `TForm.onSubmit` 作为唯一成功事件入口展示提交反馈；校验失败时仍由字段错误信息反馈。

`TFormField.value` 继续作为受控字段的最终状态源。字段交互先更新表单值快照和 Flutter `FormFieldState`，再触发表单级与字段级回调，保证两类回调内读取、校验和提交时都使用本次值；父组件直接更新 `value` 时仅同步内部 `FormField`，不触发用户交互通知或 `AutovalidateMode.onUserInteraction`。`clearValidate` 复用已存在的 `FormFieldState`清除本地校验状态，再静默恢复当前受控值，不通过更换 Key 重建子树。Theme 的固定内置默认尺寸参与有效值插值，依赖运行时 Token 的 nullable 视觉字段在任一端未配置时离散切换，避免把 `null` 错当成零值或透明色。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | TForm 管生命周期，TFormField 管受控字段和校验，TFormItem 管布局，Input/Textarea 管编辑。 |
| 保留的边界与代价 | 父级拥有受控值；清除校验不改值，reset 不写回过期初值，避免表单操作破坏业务状态。 |

### 设计演变中的关键理由

- 删除 `TInput.label` 会影响直接使用该参数的调用方，迁移方式为外包 `TFormItem`；Textarea 的内部标题不得替代表单字段标签。
- 删除 Material decoration 入口会影响直接透传 `InputDecoration` 的调用方；hint、前后置内容、背景、边框和内边距分别迁移到 TInput、TFormItem 和 TInputThemeData 的专属属性。
- 受控字段的 reset 仍不能替业务状态自动赋值；reset 只重置 Flutter 校验状态并清除 Form 错误。
- 自绘外层增加了边框、状态、计数和布局维护面，但编辑内核仍是 Flutter 原生控件，焦点、IME、selection、语义树和 formatter 不需要重复实现。
- `maxCharacter` 使用明确的加权 Unicode code point 语义，不与 Flutter 的 `maxLength` 混用；超限时截取最长合法前缀，IME composing 结束后再执行。两个限制同时传入时断言，避免用户无法判断计数口径。

- 性别项不再自行拼接手势、语义或指示器，也不保留旧 Radio 构造参数和 Theme 间距补丁；选中状态、禁用态与无障碍语义均由 `TRadioGroup` 统一负责。
- Form 只负责标签与字段的外部对齐和间距，Radio 的紧凑视觉结构由 `TRadioVariant.inline` 负责。
- `TFormField.value` 仍是最终状态源；交互回调提出的新值会短暂进入表单快照，若父级拒绝该值，帧末同步恢复为受控值。
- 颜色等运行时 Token 无法在 `ThemeExtension.lerp` 中取得有效默认色，因此 null 与显式值之间离散切换，避免产生并不存在的透明中间态。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- `TFormItem` 可在没有 `TForm` 的页面中独立显示 label、help、errorText 和 required 标记。
- `TFormController` 支持全量及按字段 validate、clearValidate、setValidateMessage。
- Form 外部错误能展示在对应 `TFormItem`，且清除校验后消失。
- `TInput` 不再提供 label；`TTextarea.label` 仅承担独立内部标题，并支持默认横排与显式竖排，清除按钮只由 `clearButtonMode` 决定。
- `TInput`、`TTextarea` 不再公开 `decoration`，`TInputThemeData` 使用专属 `hintStyle` 代替 `decorationTheme`。
- 默认输入壳层不依赖 Material `InputDecoration` 的 border/fill/padding 绘制，ThemeData 的 Material 输入主题不会污染 TDesign 视觉。
- Input 覆盖基础、前后缀、密码显隐、禁用、只读、清除、边框、状态、`maxLength`、`maxCharacter` 场景。
- 非多行 TInput 通过 `TInputThemeData.borderRadius` 支持完整圆角边框，Demo 不再手绘输入框外框。
- Textarea 覆盖基础、内部标题、边框、禁用、`maxLength`/`maxCharacter` 计数和 min/max 行数场景。
- Form Demo 展示与小程序一致的横向/纵向字段矩阵、禁用、校验和 reset/submit。
- Form/Input 相关测试通过，`flutter analyze` 零告警。
- Input、Textarea、Form 三个真实 Example 页面具备完整滚动内容的浅色与深色单套 Golden 回归；Linux CI 固定 Flutter 3.32.0 并以 0% 严格比较作为唯一权威结果，其他宿主仅作容差预检，同时严格校验页面结构、内容高度和关键组件几何。
- Flutter 3.32.0 与 3.47.0 均不使用不兼容 API。
- 四组已确认的 Form 偏差均完成修复。
- 不硬编码颜色。
- Demo 回归覆盖颜色、对齐、间距、顺序和主题。
- 性别项不包含旧 Radio API 或 Demo 级视觉兼容代码。
- 正常态默认值、提示文案、排布标题和个人简介高度与正确 Figma 节点一致。
- 提交成功有明确反馈，重置完整恢复全部默认值并清除校验错误。
- `TForm.onChanged`、受控值拒绝和外部受控值同步遵循单一状态源。
- 字段回调使用本次值，清除校验不重建字段子树或丢失焦点。
- Controller 多宿主误用在 debug 模式明确失败。
- Theme 默认值插值和必填标记局部覆盖保持视觉语义。
- 查看代码展示完整的真实 Form Demo。
- Demo 禁用语义由 `TFormField` 与子控件共同体现，Picker 重新打开恢复已确认值。
- 水平、竖向和禁用态均有 light/dark Golden 回归。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

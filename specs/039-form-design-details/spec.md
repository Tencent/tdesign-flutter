# Form 受控状态、主题与 Demo 设计细节对齐

## 背景

Form Demo 的默认正常态、排布选择器、禁用开关、水平字段对齐、竖向性别间距和底部操作与指定设计稿不一致。组件整体 Review 同时发现受控字段同步、Controller 绑定、Theme 动画和必填标记局部样式存在契约缺口。

设计基准为 Figma `Form 表单 移动端展示` 节点 [`41936:17938`](https://www.figma.com/design/mdBVCCVGERhxoZLle2eLT0/Flutter-%E8%AE%BE%E8%AE%A1%E8%B5%B0%E6%9F%A5-%E2%80%94%E2%80%94-%E7%A7%BB%E5%8A%A8%E7%AB%AF%E5%B1%95%E7%A4%BA---%E4%BA%A4%E4%BA%92---%E6%96%B0%E5%A2%9E%E7%BB%84%E4%BB%B6?node-id=41936-17938)，画板尺寸为 375 × 1254。旧节点 `45666:6110` 不作为本 PR 的验收依据。

## 目标

- 未选排布按钮使用 `#F3F3F3` 对应的语义 Token。
- 禁用态开关关闭轨道使用 `#DCDCDC` 对应的语义 Token。
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

## 非目标

- 不新增 Form、Radio、Button、Switch 公开字段或构造参数。
- 不改变表单校验和提交数据结构；Demo 仅消费既有提交回调，重置恢复设计稿展示的默认值。

## 范围

### 涉及

- Form 受控字段同步、Controller 绑定保护、Theme 解析和组件测试。
- Form Demo 组合、可查看示例、Demo 测试及视觉回归。

### 不涉及

- Radio、Button、Switch 等其他通用组件的默认主题契约。

## 行为契约

Demo 只通过现有组件 API、Theme 和基础布局组合表达设计；颜色使用 `bgColorSecondaryContainer`、`componentBorderColor` 等语义 Token。水平与竖向性别项共用 `TRadioGroup.options` 的 `inline` 结构，不在 Demo 中重复实现 Radio 的手势、状态或无障碍语义。正常态和重置态使用同一组设计默认值，避免页面初始展示与重置结果漂移。提交按钮调用 `TFormController.submit`，由 `TForm.onSubmit` 作为唯一成功事件入口展示提交反馈；校验失败时仍由字段错误信息反馈。

`TFormField.value` 继续作为受控字段的最终状态源。字段交互先更新表单值快照和 Flutter `FormFieldState`，再触发表单级与字段级回调，保证两类回调内读取、校验和提交时都使用本次值；父组件直接更新 `value` 时仅同步内部 `FormField`，不触发用户交互通知或 `AutovalidateMode.onUserInteraction`。`clearValidate` 复用已存在的 `FormFieldState`清除本地校验状态，再静默恢复当前受控值，不通过更换 Key 重建子树。Theme 的固定内置默认尺寸参与有效值插值，依赖运行时 Token 的 nullable 视觉字段在任一端未配置时离散切换，避免把 `null` 错当成零值或透明色。

## 验收标准

- [x] 四组已确认的 Form 偏差均完成修复。
- [x] 不硬编码颜色。
- [x] Demo 回归覆盖颜色、对齐、间距、顺序和主题。
- [x] 性别项不包含旧 Radio API 或 Demo 级视觉兼容代码。
- [x] 正常态默认值、提示文案、排布标题和个人简介高度与正确 Figma 节点一致。
- [x] 提交成功有明确反馈，重置完整恢复全部默认值并清除校验错误。
- [x] `TForm.onChanged`、受控值拒绝和外部受控值同步遵循单一状态源。
- [x] 字段回调使用本次值，清除校验不重建字段子树或丢失焦点。
- [x] Controller 多宿主误用在 debug 模式明确失败。
- [x] Theme 默认值插值和必填标记局部覆盖保持视觉语义。
- [x] 查看代码展示完整的真实 Form Demo。
- [x] Demo 禁用语义由 `TFormField` 与子控件共同体现，Picker 重新打开恢复已确认值。
- [x] 水平、竖向和禁用态均有 light/dark Golden 回归。

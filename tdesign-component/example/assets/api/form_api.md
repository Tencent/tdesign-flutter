## API
### TForm
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| btnGroup | List<Widget>? | - | 表单按钮组 |
| colon | bool? | false | 是否在表单标签字段右侧显示冒号 |
| data | Map<String, dynamic> | - | 表单数据 |
| disabled | bool | false | 是否禁用整个表单 |
| errorMessage | Object? | - | 表单信息错误信息配置 |
| formContentAlign | TextAlign | TextAlign.left | 表单内容对齐方式: 左对齐、右对齐、居中对齐 可选项: left/right/center 默认为左对齐 优先级低于 TFormItem 的对齐 API TODO: TStepper TRate 等组件没用实现通用性 |
| formController | FormController? | - | 表单控制器 |
| formLabelAlign | TextAlign? | TextAlign.left | 表单字段标签的对齐方式： 左对齐、右对齐、顶部对齐 可选项: left/right/top TODO: 表单总体标签对齐方式 |
| formShowErrorMessage | bool? | true | 校验不通过时，是否显示错误提示信息，统一控制全部表单项 如果希望控制单个表单项，请给 FormItem 设置该属性 |
| isHorizontal | bool | true | 表单排列方式是否为 水平方向 |
| items | List<TFormItem> | - | 表单内容 items |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| labelWidth | double? | 20.0 | 可以整体设置 label 标签宽度 |
| onReset | Function? | - | 表单重置时触发 |
| onSubmit | Function | - | 表单提交时触发 |
| preventSubmitDefault | bool? | true | 是否阻止表单提交默认事件（表单提交默认事件会刷新页面） 设置为 true 可以避免刷新 |
| requiredMark | bool? | true | 是否显示必填符号（*），默认显示 |
| rules | Map<String, TFormValidation> | - | 整个表单字段校验规则 |
| scrollToFirstError | String? | - | 表单校验不通过时，是否自动滚动到第一个校验不通过的字段，平滑滚动或是瞬间直达。 值为空则表示不滚动。可选项：''/smooth/auto |
| submitWithWarningMessage | bool? | false | 【讨论中】当校验结果只有告警信息时，是否触发 submit 提交事件 |


### TFormItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| additionInfo | String? | - | TInput的辅助信息 |
| backgroundColor | Color? | - | 背景色 |
| child | Widget? | - | 表单子组件 |
| contentAlign | TextAlign? | - | 表单显示内容对齐方式： left、right、top TODO: TStepper TRate 等组件没用实现通用性 |
| formItemNotifier | FormItemNotifier? | - | - |
| formRules | List<TFormValidation>? | - | 整个表单的校验规则 |
| help | String? | - | TInput 默认显示文字 |
| hintText | - | '' | 提示内容 |
| indicator | bool? | - | TTextarea 的属性，指示器 |
| itemRule | List? | - | 表单项验证规则 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 表单项标签左侧展示的内容 |
| labelAlign | TextAlign? | - | TODO: item 标签对齐方式 可选: left、right、top |
| labelWidget | Widget? | - | 自定义标签 |
| labelWidth | double? | - | 标签宽度，如果提供则覆盖Form的labelWidth |
| name | String? | - | 表单字段名称 |
| radios | Map<String, String>? | - | - |
| requiredMark | bool? | true | 是否显示必填标记（*） |
| select | String | '' | 选择器 适用于日期选择器等 |
| selectFn | Function? | - | 选择器方法 适用于日期选择器等 |
| showErrorMessage | bool | true | 是否显示错误信息 |
| tipAlign | TextAlign? | - | 组件提示内容对齐方式 |
| type | TFormItemType | - | 表格单元需要使用的组件类型 |


### TFormValidation
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| errorMessage | String | - | 错误提示信息 |
| type | TFormItemType | - | 校验对象的类型 |
| validate | String? Function(dynamic) | - | 校验方法 |


### TFormItemType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| input | - |
| radios | - |
| dateTimePicker | - |
| cascader | - |
| stepper | - |
| rate | - |
| textarea | - |
| upLoadImg | - |

## API
### TDFormValidation
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| validate | String? Function(dynamic) | - | 校验方法 |
| errorMessage | String | - | 错误提示信息 |
| type | TDFormItemType | - | 校验对象的类型 |

```
```
 ### TDForm
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| items | List<TDFormItem> | - | 表单内容 items |
| rules | Map<String, TDFormValidation> | - | 整个表单字段校验规则 |
| onSubmit | Function | - | 表单提交时触发 |
| data | Map<String, dynamic> | - | 表单数据 |
| colon | bool? | false | 是否在表单标签字段右侧显示冒号 |
| formContentAlign | TextAlign | TextAlign.left | 表单内容对齐方式: 左对齐、右对齐、居中对齐 |
| isHorizontal | bool | true | 表单排列方式是否为 水平方向 |
| disabled | bool | false | 是否禁用整个表单 |
| errorMessage | Object? | - | 表单信息错误信息配置 |
| formLabelAlign | TextAlign? | TextAlign.left | 表单字段标签的对齐方式： |
| labelWidth | double? | 20.0 | 可以整体设置 label 标签宽度 |
| preventSubmitDefault | bool? | true | 是否阻止表单提交默认事件（表单提交默认事件会刷新页面） |
| requiredMark | bool? | true | 是否显示必填符号（*），默认显示 |
| scrollToFirstError | String? | - | 表单校验不通过时，是否自动滚动到第一个校验不通过的字段，平滑滚动或是瞬间直达。 |
| formShowErrorMessage | bool? | true | 校验不通过时，是否显示错误提示信息，统一控制全部表单项 |
| submitWithWarningMessage | bool? | false | 【讨论中】当校验结果只有告警信息时，是否触发 submit 提交事件 |
| onReset | Function? | - | 表单重置时触发 |
| formController | FormController? | - | 表单控制器 |
| btnGroup | List<Widget>? | - | 表单按钮组 |

```
```
 ### TDFormItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| type | TDFormItemType | - | 表格单元需要使用的组件类型 |
| child | Widget? | - | 表单子组件 |
| formItemNotifier |  | - |  |
| label | String? | - | 表单项标签左侧展示的内容 |
| labelWidget | Widget? | - | 自定义标签 |
| help | String? | - | TDInput 默认显示文字 |
| name | String? | - | 表单字段名称 |
| labelAlign | TextAlign? | - | TODO: item 标签对齐方式 |
| contentAlign | TextAlign? | - | 表单显示内容对齐方式： |
| labelWidth | double? | - | 标签宽度，如果提供则覆盖Form的labelWidth |
| tipAlign | TextAlign? | - | 组件提示内容对齐方式 |
| requiredMark | bool? | true | 是否显示必填标记（*） |
| formRules | List<TDFormValidation>? | - | 整个表单的校验规则 |
| itemRule | List? | - | 表单项验证规则 |
| showErrorMessage | bool | true | 是否显示错误信息 |
| indicator | bool? | - | TDTextarea 的属性，指示器 |
| additionInfo | String? | - | TDInput的辅助信息 |
| select | String | '' | 选择器 适用于日期选择器等 |
| selectFn | Function? | - | 选择器方法 适用于日期选择器等 |
| hintText | null | '' | 提示内容 |
| radios |  | - |  |
| key |  | - |  |

## API
### TConfirmDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| buttonStyle | TDialogButtonStyle | TDialogButtonStyle.normal | 按钮样式 |
| buttonStyleCustom | ButtonStyle? | - | 按钮自定义样式 |
| buttonText | String? | - | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonWidget | Widget? | - | 自定义按钮 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| contentWidget | Widget? | - | 内容Widget |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback? | - | 点击 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| showCloseButton | bool? | - | 右上角关闭按钮 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |
| width | double? | - | 弹窗宽度。 |


### TDialogButtonOptions
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| colorScheme | TButtonColorScheme? | - | 按钮配色方案 |
| fontWeight | FontWeight? | - | 字体粗细 |
| height | double? | - | 按钮高度 建议使用默认高度 |
| onPressed | VoidCallback? | - | 点击操作 |
| style | ButtonStyle? | - | 按钮样式 |
| title | String | - | 标题内容 |
| titleColor | Color? | - | 标题颜色 |
| titleSize | double? | - | 字体大小 |
| type | TButtonVariant? | - | 按钮变体类型 |


### TDialogScaffold
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色 |
| body | Widget | - | Dialog主体 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| radius | double | 12.0 | 圆角 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| width | double? | - | 弹窗宽度 |


### TDialogTitle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| title | String? | - | 标题文字 |
| titleColor | Color? | - | 标题颜色 |


### TDialogContent
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String? | - | 标题文字 |
| contentColor | Color? | - | 标题颜色 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |


### TDialogInfoWidget
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| contentWidget | Widget? | - | 内容Widget |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| padding | EdgeInsetsGeometry? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容的内边距 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |


### HorizontalNormalButtons
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftBtn | TDialogButtonOptions | - | 左按钮 |
| rightBtn | TDialogButtonOptions | - | 右按钮 |


### HorizontalTextButtons
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftBtn | TDialogButtonOptions | - | 左按钮 |
| rightBtn | TDialogButtonOptions | - | 右按钮 |


### TDialogButton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| buttonColorScheme | TButtonColorScheme? | - | 按钮配色方案 |
| buttonStyle | ButtonStyle? | - | 按钮样式（P0 逃逸舱） |
| buttonText | String? | - | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonTextFontWeight | FontWeight? | FontWeight.w600 | 按钮文字粗细 |
| buttonTextSize | double? | - | 按钮文字大小 |
| buttonVariant | TButtonVariant? | - | 按钮变体类型 |
| height | double? | 40.0 | 按钮高度 |
| isBlock | bool | true | 是否通栏 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback | - | 点击回调 |
| width | double? | - | 按钮宽度 |


### TDialogButtonStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 常规按钮样式 |
| text | 文字按钮样式 |

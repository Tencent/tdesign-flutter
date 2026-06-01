## API
### TAlertDialog

#### 工厂构造方法

##### TAlertDialog.vertical

纵向按钮排列的对话框
`buttons`参数是必须的，纵向按钮默认样式都是`TButtonTheme.primary`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| buttons | List<TDialogButtonOptions> | - | - |
| backgroundColor | Color? | - | 背景颜色 |
| radius | double | 12.0 | 圆角 |
| title | String? | - | 标题 |
| titleColor | Color? | - | 标题颜色 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| contentWidget | Widget? | - | 内容Widget |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| buttonWidget | Widget? | - | 自定义按钮 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| buttonStyle | TDialogButtonStyle | TDialogButtonStyle.normal | - |
| buttonWidget | Widget? | - | 自定义按钮 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| contentWidget | Widget? | - | 内容Widget |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftBtn | TDialogButtonOptions? | - | 左侧按钮配置 |
| leftBtnAction | Function()? | - | 左侧按钮默认点击 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| rightBtn | TDialogButtonOptions? | - | 右侧按钮配置 |
| rightBtnAction | Function()? | - | 右侧按钮默认点击 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |


### TConfirmDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | Function()? | - | 点击 |
| backgroundColor | Color? | - | 背景颜色 |
| buttonStyle | TDialogButtonStyle | TDialogButtonStyle.normal | 按钮样式 |
| buttonStyleCustom | TButtonStyle? | - | 按钮自定义样式属性，背景色、边框... |
| buttonText | String? | - | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonWidget | Widget? | - | 自定义按钮 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| contentWidget | Widget? | - | 内容Widget |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| showCloseButton | bool? | - | 右上角关闭按钮 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |
| width | double? | - | - |


### TDialogButtonOptions
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | Function()? | - | 点击操作 |
| fontWeight | FontWeight? | - | 字体粗细 |
| height | double? | - | 按钮高度 建议使用默认高度 |
| style | TButtonStyle? | - | 按钮样式 设置单个按钮的样式会覆盖Dialog的默认样式 |
| theme | TButtonTheme? | - | 按钮类型 |
| title | String | - | 标题内容 |
| titleColor | Color? | - | 标题颜色 |
| titleSize | double? | - | 字体大小 |
| type | TButtonType? | - | 按钮类型 |


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
| buttonStyle | TButtonStyle? | - | 按钮样式 |
| buttonText | String? | - | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonTextFontWeight | FontWeight? | FontWeight.w600 | 按钮文字粗细 |
| buttonTextSize | double? | - | 按钮文字大小 |
| buttonTheme | TButtonTheme? | - | 按钮主题 |
| buttonType | TButtonType? | - | 按钮类型 |
| height | double? | 40.0 | 按钮高度 |
| isBlock | bool | true | 按钮高度 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | Function() | - | 点击 |
| width | double? | - | 按钮宽度 |


### TImageDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| buttonWidget | Widget? | - | 自定义按钮 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentWidget | Widget? | - | 内容Widget |
| image | Image | - | 图片 |
| imagePosition | TDialogImagePosition? | TDialogImagePosition.top | 图片位置 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftBtn | TDialogButtonOptions? | - | 左侧按钮配置 |
| padding | EdgeInsets? | - | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| rightBtn | TDialogButtonOptions? | - | 右侧按钮配置 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |


### TInputDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| buttonWidget | Widget? | - | 自定义按钮 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentWidget | Widget? | - | 内容Widget |
| customInputWidget | Widget? | - | 自定义输入框 |
| hintText | String? | '' | 输入提示 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftBtn | TDialogButtonOptions? | - | 左侧按钮配置 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| rightBtn | TDialogButtonOptions? | - | 右侧按钮配置 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| textEditingController | TextEditingController | - | 输入controller |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |


### TDialogButtonStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | - |
| text | - |


### TDialogImagePosition
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| top | - |
| middle | - |

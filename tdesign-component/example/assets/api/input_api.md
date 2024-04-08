## API
### TDInput
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| width | double? | - | 输入框宽度(TDCardStyle时必须设置该参数) |
| textStyle | TextStyle? | - | 文本颜色 |
| backgroundColor | Color? | - | 输入框背景色 |
| decoration | Decoration? | - | 输入框样式 |
| leftIcon | Widget? | - | 带图标的输入框 |
| leftLabel | String? | - | 输入框左侧文案 |
| leftLabelStyle | TextStyle? | - | 左侧标签样式 |
| required | bool? | - | 是否必填标志（红色*） |
| readOnly | bool | false | 是否只读 |
| autofocus | bool | false | 是否自动获取焦点 |
| obscureText | bool | false | 是否隐藏输入的文字，一般用在密码输入框中 |
| onEditingComplete | VoidCallback? | - | 点击键盘完成按钮时触发的回调 |
| onSubmitted | ValueChanged<String>? | - | 点击键盘完成按钮时触发的回调, 参数值为输入的内容 |
| hintText | String? | - | 提示文案 |
| inputType | TextInputType? | - | 键盘类型，数字、字母 |
| onChanged | ValueChanged<String>? | - | 输入文本变化时回调 |
| inputFormatters | List<TextInputFormatter>? | - | 显示输入内容，如限制长度(LengthLimitingTextInputFormatter(6)) |
| inputDecoration | InputDecoration? | - | 自定义输入框样式，默认圆角 |
| maxLines | int | 1 | 最大输入行数 |
| focusNode | FocusNode? | - | 获取或者取消焦点使用 |
| controller | TextEditingController? | - | controller 用户获取或者赋值输入内容 |
| cursorColor | Color? | - | 游标颜色 |
| rightBtn | Widget? | - | 右侧按钮 |
| hintTextStyle | TextStyle? | - | 提示文本颜色，默认为文本颜色 |
| onBtnTap | GestureTapCallback? | - | 右侧按钮点击 |
| labelWidget | Widget? | - | leftLabel右侧组件，支持自定义 |
| textInputBackgroundColor | Color? | - | 文本框背景色 |
| contentPadding | EdgeInsetsGeometry? | - | textInput内边距 |
| type | TDInputType | TDInputType.normal | 输入框类型 |
| size | TDInputSize | TDInputSize.large | 输入框规格 |
| leftInfoWidth | double? | - | 输入框左侧的宽度（输入框有16dp的左侧padding，因而左侧部分不用考虑这16dp） |
| maxLength | int? | 500 | 最大字数限制 |
| additionInfo | String? | '' | 错误提示信息 |
| additionInfoColor | Color? | - | 错误提示颜色 |
| textAlign | TextAlign? | - | 文字对齐方向 |
| onClearTap | GestureTapCallback? | - | 右侧删除点击 |
| needClear | bool | true | 是否需要右侧按钮变为删除 |
| clearBtnColor | Color? | - | 右侧删除按钮颜色 |
| contentAlignment | TextAlign | TextAlign.start | 内容对齐方向 |
| rightWidget | Widget? | - | 右侧自定义组件 特殊类型时生效 |
| showBottomDivider | bool | true | 是否展示底部分割线 |
| cardStyle | TDCardStyle? | - | 卡片默认样式 |
| cardStyleTopText | String? | - | 卡片模式上方文字 |
| cardStyleBottomText | String? | - | 卡片模式下方文字 |

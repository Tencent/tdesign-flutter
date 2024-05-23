## API
### TDTextarea
#### 简介
用于多行文本信息输入
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| width | double? | - | 输入框宽度 |
| textStyle | TextStyle? | - | 文本颜色 |
| backgroundColor | Color? | Colors.white | 输入框背景色 |
| decoration | Decoration? | - | 输入框样式(包括标签) |
| labelStyle | TextStyle? | - | 左侧标签文本样式 |
| required | bool? | - | 是否必填标志（红色*） |
| readOnly | bool? | false | 是否只读 |
| autofocus | bool? | false | 是否自动获取焦点 |
| onEditingComplete | VoidCallback? | - | 点击键盘完成按钮时触发的回调 |
| onSubmitted | ValueChanged<String>? | - | 点击键盘完成按钮时触发的回调, 参数值为输入的内容 |
| hintText | String? | - | 提示文案 |
| inputType | TextInputType? | - | 键盘类型，数字、字母 |
| onChanged | ValueChanged<String>? | - | 输入文本变化时回调 |
| inputFormatters | List<TextInputFormatter>? | - | 显示输入内容，如限制长度(LengthLimitingTextInputFormatter(6)) |
| inputDecoration | InputDecoration? | - | 自定义输入框TextField组件样式 |
| maxLines | int? | - | 最大输入行数 |
| minLines | int? | 4 | 最小输入行数 |
| focusNode | FocusNode? | - | 获取或者取消焦点使用 |
| controller | TextEditingController? | - | controller 用户获取或者赋值输入内容 |
| cursorColor | Color? | - | 游标颜色 |
| hintTextStyle | TextStyle? | - | 提示文本颜色，默认为文本颜色 |
| labelWidget | Widget? | - | label组件，支持自定义 |
| textInputBackgroundColor | Color? | - | 文本框背景色 |
| size | TDInputSize? | TDInputSize.large | 输入框规格 |
| maxLength | int? | - | 最大字数限制 |
| additionInfo | String? | '' | 错误提示信息 |
| additionInfoColor | Color? | - | 错误提示颜色 |
| textAlign | TextAlign? | - | 文字对齐方向 |
| label | String? | - | 输入框标题 |
| indicator | bool? | false | 否显示文本计数器，如 0/140（必须设置maxLength） |
| layout | TDTextareaLayout? | TDTextareaLayout.horizontal | 标题输入框布局方式。可选项：vertical/horizontal |
| autosize | bool? | - | 是否自动增高，值为 autosize 时，maxLines 不生效 |
| labelIcon | Widget? | - | 输入框标题图标 |
| labelWidth | double? | - | 输入框标题宽度 |
| margin | EdgeInsetsGeometry? | - | 外边距 |
| textareaDecoration | Decoration? | - | 输入框样式(不包括标签) |
| bordered | bool? | - | 是否显示外边框 |

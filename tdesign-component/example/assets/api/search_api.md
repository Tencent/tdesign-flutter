## API
### TDSearchBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | String | '' | 自定义操作文字 |
| alignment | TDSearchAlignment? | TDSearchAlignment.left | 对齐方式，居中或这头部对齐 |
| autoFocus | bool | false | 是否自动获取焦点 |
| autoHeight | bool | false | 是否自动计算高度 |
| backgroundColor | Color? | - | 背景颜色 |
| controller | TextEditingController? | - | 控制器 |
| cursorHeight | double? | - | 光标的高 |
| enabled | bool? | - | 是否禁用 |
| focusNode | FocusNode? | - | 自定义焦点 |
| inputAction | TextInputAction? | - | 键盘动作类型 |
| key |  | - |  |
| mediumStyle | bool | false | 是否在导航栏中的样式 |
| needCancel | bool | false | 是否需要取消按钮 |
| onActionClick | TDSearchBarEvent? | - | 自定义操作回调 |
| onClearClick | TDSearchBarClearEvent? | - | 自定义操作回调 |
| onEditComplete | TDSearchBarCallBack? | - | 编辑完成回调 |
| onInputClick | GestureTapCallback? | - | 输入框点击事件 |
| onSubmitted | TDSearchBarEvent? | - | 提交回调 |
| onTapOutside |  | - |  |
| onTextChanged | TDSearchBarEvent? | - | 文字改变回调 |
| padding | EdgeInsets | const EdgeInsets.fromLTRB(16, 8, 16, 8) | 内部填充 |
| placeHolder | String? | - | 预设文案 |
| readOnly | bool? | - | 是否只读 |
| style | TDSearchStyle? | TDSearchStyle.square | 样式 |

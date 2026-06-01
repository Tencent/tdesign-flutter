## API
### TSearchBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | String | '' | 自定义操作文字 |
| alignment | TSearchAlignment? | TSearchAlignment.left | 对齐方式，居中或这头部对齐 |
| autoFocus | bool | false | 是否自动获取焦点 |
| autoHeight | bool | false | 是否自动计算高度 |
| backgroundColor | Color? | - | 背景颜色 |
| controller | TextEditingController? | - | 控制器 |
| cursorHeight | double? | - | 光标的高 |
| enabled | bool? | - | 是否禁用 |
| focusNode | FocusNode? | - | 自定义焦点 |
| inputAction | TextInputAction? | - | 键盘动作类型 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| mediumStyle | bool | false | 是否在导航栏中的样式 |
| needCancel | bool | false | 是否需要取消按钮 |
| onActionClick | TSearchBarEvent? | - | 自定义操作回调 |
| onClearClick | TSearchBarClearEvent? | - | 自定义操作回调 |
| onEditComplete | TSearchBarCallBack? | - | 编辑完成回调 |
| onInputClick | GestureTapCallback? | - | 输入框点击事件 |
| onSubmitted | TSearchBarEvent? | - | 提交回调 |
| onTapOutside | TapRegionCallback? | - | 点击输入框外部回调 |
| onTextChanged | TSearchBarEvent? | - | 文字改变回调 |
| padding | EdgeInsets | const EdgeInsets.symmetric(horizontal: 16, vertical: 8) | 内部填充 |
| placeHolder | String? | - | 预设文案 |
| readOnly | bool? | - | 是否只读 |
| style | TSearchStyle? | TSearchStyle.square | 样式 |


### TSearchStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| square | 方形 |
| round | 圆形 |


### TSearchAlignment
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 默认头部对齐 |
| center | 居中 |


### TSearchBarEvent
#### 类型定义

```dart
typedef TSearchBarEvent = void Function(String value);
```


### TSearchBarClearEvent
#### 类型定义

```dart
typedef TSearchBarClearEvent = bool? Function(String value);
```


### TSearchBarCallBack
#### 类型定义

```dart
typedef TSearchBarCallBack = void Function();
```

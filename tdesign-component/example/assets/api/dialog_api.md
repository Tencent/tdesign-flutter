## API
### TDImageDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| buttonWidget | Widget? | - | 自定义按钮 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentWidget | Widget? | - | 内容Widget |
| image | Image | - | 图片 |
| imagePosition | TDDialogImagePosition? | TDDialogImagePosition.top | 图片位置 |
| key |  | - |  |
| leftBtn | TDDialogButtonOptions? | - | 左侧按钮配置 |
| padding | EdgeInsets? | - | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| rightBtn | TDDialogButtonOptions? | - | 右侧按钮配置 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |

```
```
 ### TDDialogButtonOptions
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action |  Function()? | - | 点击操作 |
| fontWeight | FontWeight? | - | 字体粗细 |
| height | double? | - | 按钮高度 |
| style | TDButtonStyle? | - | 按钮样式 |
| theme | TDButtonTheme? | - | 按钮类型 |
| title | String | - | 标题内容 |
| titleColor | Color? | - | 标题颜色 |
| titleSize | double? | - | 字体大小 |
| type | TDButtonType? | - | 按钮类型 |

```
```
 ### TDConfirmDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action |  Function()? | - | 点击 |
| backgroundColor | Color? | - | 背景颜色 |
| buttonStyle | TDDialogButtonStyle | TDDialogButtonStyle.normal | 按钮样式 |
| buttonStyleCustom | TDButtonStyle? | - | 按钮自定义样式属性，背景色、边框... |
| buttonText | String? | - | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonWidget | Widget? | - | 自定义按钮 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| contentWidget | Widget? | - | 内容Widget |
| key |  | - |  |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| showCloseButton | bool? | - | 右上角关闭按钮 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |
| width |  | - |  |

```
```
 ### TDInputDialog
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
| key |  | - |  |
| leftBtn | TDDialogButtonOptions? | - | 左侧按钮配置 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| rightBtn | TDDialogButtonOptions? | - | 右侧按钮配置 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| textEditingController | TextEditingController | - | 输入controller |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |

```
```
 ### TDAlertDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| buttonStyle |  | TDDialogButtonStyle.normal |  |
| buttonWidget | Widget? | - | 自定义按钮 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| contentWidget | Widget? | - | 内容Widget |
| key |  | - |  |
| leftBtn | TDDialogButtonOptions? | - | 左侧按钮配置 |
| leftBtnAction |  Function()? | - | 左侧按钮默认点击 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| rightBtn | TDDialogButtonOptions? | - | 右侧按钮配置 |
| rightBtnAction |  Function()? | - | 右侧按钮默认点击 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDAlertDialog.vertical  | 纵向按钮排列的对话框

 [buttons]参数是必须的，纵向按钮默认样式都是[TDButtonTheme.primary] |

```
```
 ### TDDialogScaffold
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色 |
| body | Widget | - | Dialog主体 |
| key |  | - |  |
| radius | double | 12.0 | 圆角 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| width | double? | - | 弹窗宽度 |

```
```
 ### TDDialogTitle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| title | String? | - | 标题文字 |
| titleColor | Color? | - | 标题颜色 |

```
```
 ### TDDialogContent
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String? | - | 标题文字 |
| contentColor | Color? | - | 标题颜色 |
| key |  | - |  |

```
```
 ### TDDialogInfoWidget
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| contentWidget | Widget? | - | 内容Widget |
| key |  | - |  |
| padding | EdgeInsetsGeometry? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容的内边距 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |

```
```
 ### HorizontalNormalButtons
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| leftBtn | TDDialogButtonOptions | - | 左按钮 |
| rightBtn | TDDialogButtonOptions | - | 右按钮 |

```
```
 ### HorizontalTextButtons
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| leftBtn | TDDialogButtonOptions | - | 左按钮 |
| rightBtn | TDDialogButtonOptions | - | 右按钮 |

```
```
 ### TDDialogButton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| buttonStyle | TDButtonStyle? | - | 按钮样式 |
| buttonText | String? | - | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonTextFontWeight | FontWeight? | FontWeight.w600 | 按钮文字粗细 |
| buttonTextSize | double? | - | 按钮文字大小 |
| buttonTheme | TDButtonTheme? | - | 按钮主题 |
| buttonType | TDButtonType? | - | 按钮类型 |
| height | double? | 40.0 | 按钮高度 |
| isBlock | bool | true | 按钮高度 |
| key |  | - |  |
| onPressed |  Function() | - | 点击 |
| width | double? | - | 按钮宽度 |

## API
### TDImageDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| image | Image | - | 图片 |
| imagePosition | TDDialogImagePosition? | TDDialogImagePosition.top | 图片位置 |
| backgroundColor | Color | Colors.white | 背景颜色 |
| radius | double | 12.0 | 圆角 |
| title | String? | - | 标题 |
| titleColor | Color | const Color(0xE6000000) | 标题颜色 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| contentWidget | Widget? | - | 内容Widget |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| leftBtn | TDDialogButtonOptions? | - | 左侧按钮配置 |
| rightBtn | TDDialogButtonOptions? | - | 右侧按钮配置 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |

```
```
 ### TDDialogButtonOptions
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | String | - | 标题内容 |
| action |  Function() | - | 点击操作 |
| titleColor | Color? | - | 标题颜色 |
| style | TDButtonStyle? | - | 按钮样式 |
| type | TDButtonType? | - | 按钮类型 |
| theme | TDButtonTheme? | - | 按钮类型 |
| height | double? | - | 按钮高度 |
| fontWeight | FontWeight? | - | 字体粗细 |

```
```
 ### TDConfirmDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| action |  Function()? | - | 点击 |
| backgroundColor | Color | Colors.white | 背景颜色 |
| radius | double | 12.0 | 圆角 |
| title | String? | - | 标题 |
| titleColor | Color | const Color(0xE6000000) | 标题颜色 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| contentWidget | Widget? | - | 内容Widget |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| buttonText | String? | '知道了' | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonStyle | TDDialogButtonStyle | TDDialogButtonStyle.normal | 按钮样式 |
| showCloseButton | bool? | - | 右上角关闭按钮 |

```
```
 ### TDInputDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| textEditingController | TextEditingController | - | 输入controller |
| backgroundColor | Color | Colors.white | 背景颜色 |
| radius | double | 12.0 | 圆角 |
| title | String? | - | 标题 |
| titleColor | Color | const Color(0xE6000000) | 标题颜色 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| contentWidget | Widget? | - | 内容Widget |
| content | String? | - | 内容 |
| hintText | String? | '' | 输入提示 |
| contentColor | Color? | - | 内容颜色 |
| leftBtn | TDDialogButtonOptions? | - | 左侧按钮配置 |
| rightBtn | TDDialogButtonOptions? | - | 右侧按钮配置 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |

```
```
 ### TDAlertDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| backgroundColor | Color | Colors.white | 背景颜色 |
| radius | double | 12.0 | 圆角 |
| title | String? | - | 标题 |
| titleColor | Color | const Color(0xE6000000) | 标题颜色 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| contentWidget | Widget? | - | 内容Widget |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| leftBtn | TDDialogButtonOptions? | - | 左侧按钮配置 |
| rightBtn | TDDialogButtonOptions? | - | 右侧按钮配置 |
| leftBtnAction |  Function()? | - | 左侧按钮默认点击 |
| rightBtnAction |  Function()? | - | 右侧按钮默认点击 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| buttonStyle |  | TDDialogButtonStyle.normal |  |


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
| key |  | - |  |
| body | Widget | - | Dialog主体 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| backgroundColor | Color | Colors.white | 背景色 |
| radius | double | 12.0 | 圆角 |

```
```
 ### TDDialogTitle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| title | String | '对话框标题' | 标题文字 |
| titleColor | Color | Colors.black | 标题颜色 |

```
```
 ### TDDialogContent
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| content | String | '当前弹窗内容' | 标题文字 |
| contentColor | Color | const Color(0x99000000) | 标题颜色 |

```
```
 ### TDDialogInfoWidget
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| title | String? | - | 标题 |
| titleColor | Color | Colors.black | 标题颜色 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| contentWidget | Widget? | - | 内容Widget |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| padding | EdgeInsetsGeometry? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容的内边距 |

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
| key |  | - |  |
| buttonText | String? | '按钮' | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonTextFontWeight | FontWeight? | FontWeight.w600 | 按钮文字粗细 |
| buttonStyle | TDButtonStyle? | - | 按钮样式 |
| buttonType | TDButtonType? | - | 按钮类型 |
| buttonTheme | TDButtonTheme? | - | 按钮主题 |
| onPressed |  Function() | - | 点击 |
| height | double? | 40.0 | 按钮高度 |
| width | double? | - | 按钮宽度 |
| isBlock | bool | true | 按钮高度 |

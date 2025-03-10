# 对话框组件 API 文档

## TDDialogScaffold
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - | 组件唯一标识 |
| body | Widget | - | 对话框主体内容 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| backgroundColor | Color | Colors.white | 对话框背景色 |
| radius | double | 12.0 | 对话框圆角半径 |

---

## TDDialogTitle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - | 组件唯一标识 |
| title | String? | - | 标题文字内容 |
| titleColor | Color | Color(0xE6000000) | 标题文字颜色 |

---

## TDDialogContent
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - | 组件唯一标识 |
| content | String? | - | 内容文字 |
| contentColor | Color | Color(0x99000000) | 内容文字颜色 |

---

## TDDialogInfoWidget
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - | 组件唯一标识 |
| title | String? | - | 信息标题 |
| titleColor | Color | Color(0xE6000000) | 标题文字颜色 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐方式 |
| contentWidget | Widget? | - | 自定义内容组件 |
| content | String? | - | 内容文字 |
| contentColor | Color? | - | 内容文字颜色 |
| contentMaxHeight | double | 0 | 内容区域最大高度 |
| padding | EdgeInsetsGeometry | EdgeInsets.fromLTRB(24,32,24,0) | 内容内边距 |

---

## TDAlertDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - | 组件唯一标识 |
| backgroundColor | Color | Colors.white | 对话框背景色 |
| radius | double | 12.0 | 对话框圆角半径 |
| title | String? | - | 主标题内容 |
| titleColor | Color | Color(0xE6000000) | 标题文字颜色 |
| content | String? | - | 正文内容 |
| contentColor | Color? | - | 正文文字颜色 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐方式 |
| contentWidget | Widget? | - | 自定义正文组件 |
| contentMaxHeight | double | 0 | 正文区域最大高度 |
| leftBtn | TDDialogButtonOptions? | - | 左侧按钮配置 |
| rightBtn | TDDialogButtonOptions? | - | 右侧按钮配置 |
| showCloseButton | bool? | - | 显示关闭按钮 |
| padding | EdgeInsets | EdgeInsets.fromLTRB(24,32,24,0) | 内容内边距 |
| buttonWidget | Widget? | - | 自定义按钮组件 |

#### 工厂构造方法
| 名称 | 说明 |
| --- | --- |
| TDAlertDialog.vertical | 纵向排列按钮样式 |

---

## TDImageDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - | 组件唯一标识 |
| image | Image | - | 显示的图片 |
| imagePosition | TDDialogImagePosition | top | 图片显示位置 |
| backgroundColor | Color | Colors.white | 对话框背景色 |
| radius | double | 12.0 | 对话框圆角半径 |

---

## TDDialogButton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - | 组件唯一标识 |
| buttonText | String? | - | 按钮文字 |
| buttonTextColor | Color? | - | 文字颜色 |
| buttonTextSize | double? | - | 文字大小 |
| buttonTextFontWeight | FontWeight | FontWeight.w600 | 文字粗细 |
| buttonStyle | TDButtonStyle? | - | 按钮样式 |
| buttonType | TDButtonType? | - | 按钮类型 |
| buttonTheme | TDButtonTheme? | - | 按钮主题 |
| onPressed | Function() | - | 点击回调 |
| height | double | 40 | 按钮高度 |
| width | double? | - | 按钮宽度 |
| isBlock | bool | true | 块级显示 |

---

## 按钮布局组件

### HorizontalNormalButtons
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - | 组件唯一标识 |
| leftBtn | TDDialogButtonOptions | - | 左侧按钮配置 |
| rightBtn | TDDialogButtonOptions | - | 右侧按钮配置 |

### HorizontalTextButtons
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - | 组件唯一标识 |
| leftBtn | TDDialogButtonOptions | - | 左侧按钮配置 |
| rightBtn | TDDialogButtonOptions | - | 右侧按钮配置 |
## API
### TToast
#### 简介
轻提示组件
支持文本、图标、加载中等样式，支持多实例同时显示。

#### 静态方法

##### TToast.dismissAll

关闭所有Toast

返回类型：`void`

##### TToast.dismissToast

关闭指定的Toast

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| toastId | String | - | 要关闭的 Toast 实例 ID。 |


##### TToast.showFail

失败提示Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | 提示文案。 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 |
| duration | Duration | const Duration(milliseconds: 3000) | 自动关闭时长。 |
| preventTap | bool? | - | 是否阻止 Toast 展示期间的背景点击。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| maxLines | int? | - | 文案最大行数。 |
| textStyle | TextStyle? | - | Toast 文案样式。 |
| iconSize | double? | - | 图标尺寸。 |
| iconColor | Color? | - | 图标颜色。 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 |


##### TToast.showIconText

带图标的Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | 提示文案。 |
| icon | IconData? | - | 左侧或上方图标。 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 |
| duration | Duration | const Duration(milliseconds: 3000) | 自动关闭时长。 |
| preventTap | bool? | - | 是否阻止 Toast 展示期间的背景点击。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| maxLines | int? | - | 文案最大行数。 |
| textStyle | TextStyle? | - | Toast 文案样式。 |
| iconSize | double? | - | 图标尺寸。 |
| iconColor | Color? | - | 图标颜色。 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 |


##### TToast.showLoading

带文案的加载Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 |
| text | String? | - | 提示文案。 |
| duration | Duration | const Duration(seconds: 99999999) | 自动关闭时长。 |
| preventTap | bool? | - | 是否阻止 Toast 展示期间的背景点击。 |
| customWidget | Widget? | - | 自定义内容；传入后优先展示。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| textStyle | TextStyle? | - | Toast 文案样式。 |
| iconSize | double? | - | 图标尺寸。 |
| iconColor | Color? | - | 图标颜色。 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 |


##### TToast.showLoadingWithoutText

不带文案的加载Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 |
| duration | Duration | const Duration(seconds: 99999999) | 自动关闭时长。 |
| preventTap | bool? | - | 是否阻止 Toast 展示期间的背景点击。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| iconSize | double? | - | 图标尺寸。 |
| iconColor | Color? | - | 图标颜色。 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 |


##### TToast.showSuccess

成功提示Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | 提示文案。 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 |
| duration | Duration | const Duration(milliseconds: 3000) | 自动关闭时长。 |
| preventTap | bool? | - | 是否阻止 Toast 展示期间的背景点击。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| maxLines | int? | - | 文案最大行数。 |
| textStyle | TextStyle? | - | Toast 文案样式。 |
| iconSize | double? | - | 图标尺寸。 |
| iconColor | Color? | - | 图标颜色。 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 |


##### TToast.showText

普通文本Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | 提示文案。 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 |
| duration | Duration | const Duration(milliseconds: 3000) | 自动关闭时长。 |
| maxLines | int? | - | 文案最大行数。 |
| constraints | BoxConstraints? | - | Toast 内容约束。 |
| preventTap | bool? | - | 是否阻止 Toast 展示期间的背景点击。 |
| customWidget | Widget? | - | 自定义内容；传入后优先展示。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| textStyle | TextStyle? | - | Toast 文案样式。 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 |


##### TToast.showWarning

警告Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | 提示文案。 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 |
| duration | Duration | const Duration(milliseconds: 3000) | 自动关闭时长。 |
| preventTap | bool? | - | 是否阻止 Toast 展示期间的背景点击。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| maxLines | int? | - | 文案最大行数。 |
| textStyle | TextStyle? | - | Toast 文案样式。 |
| iconSize | double? | - | 图标尺寸。 |
| iconColor | Color? | - | 图标颜色。 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 |


### IconTextDirection
#### 简介
Toast 文案排列方向
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 横向 |
| vertical | 竖向 |

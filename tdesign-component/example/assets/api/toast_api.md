## API

### TToast

#### 构造方法

##### TToast

无参数。

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| infiniteDuration | Duration | Duration(seconds: 99999999) | 无限时长哨兵值：加载类 Toast 使用，表示"永不自动消失"。 封装为具名常量，避免魔法数字导致用户传入相近的超长 duration 时被误判为无限。 | - |


#### 静态方法

##### TToast.dismissAll

无参数。

关闭所有Toast

##### TToast.dismissToast

位置参数：`toastId`


关闭指定的Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| toastId | String | - | 要关闭的 Toast 实例 ID。 | 是 |


##### TToast.showFail

位置参数：`text`


失败提示Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案。 | 是 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 | 否 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | - | - |


##### TToast.showIconText

位置参数：`text`


带图标的Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案。 | 是 |
| icon | IconData? | - | 左侧或上方图标。 | 否 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 | 否 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | - | - |


##### TToast.showLoading

带文案的加载Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| text | String? | - | 加载提示文案。 | 否 |
| duration | Duration | TToast.infiniteDuration | 自动关闭时长。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| customWidget | Widget? | - | 自定义加载内容；传入后优先展示。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 加载图标尺寸。 | 否 |
| iconColor | Color? | - | 加载图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | - | - |


##### TToast.showLoadingWithoutText

不带文案的加载Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | TToast.infiniteDuration | 自动关闭时长。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| iconSize | double? | - | 加载图标尺寸。 | 否 |
| iconColor | Color? | - | 加载图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | - | - |


##### TToast.showSuccess

位置参数：`text`


成功提示Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案。 | 是 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 | 否 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | - | - |


##### TToast.showText

位置参数：`text`


普通文本Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案；为 null 时只展示自定义内容。 | 是 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| constraints | BoxConstraints? | - | Toast 内容约束。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| customWidget | Widget? | - | 自定义内容；传入后优先展示。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | - | - |


##### TToast.showWarning

位置参数：`text`


警告Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案。 | 是 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 | 否 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | - | - |


### IconTextDirection
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| horizontal | IconTextDirection | - | 横向 | - |
| vertical | IconTextDirection | - | 竖向 | - |


### TToastPlacement
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| top | TToastPlacement | - | 顶部（距屏幕顶部 25%，水平居中） | - |
| middle | TToastPlacement | - | 居中（屏幕正中） | - |
| bottom | TToastPlacement | - | 底部（距屏幕底部 25%，水平居中） | - |

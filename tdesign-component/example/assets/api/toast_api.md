## API

### TToast

#### 构造方法

##### TToast

无参数。

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
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长，默认 2000ms；零或负时长不自动关闭，请调用 dismissToast 或 dismissAll。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时共用固定匿名 ID toast_anonymous，后一次展示替换前一次。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | 本次 Toast 的标识，可传给 `dismissToast`；未传 toastId 时使用共享匿名标识并复用匿名提示。 | - |


##### TToast.showIconText

位置参数：`text`


带图标的Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案。 | 是 |
| icon | IconData? | - | 左侧或上方图标。 | 否 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 | 否 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长，默认 2000ms；零或负时长不自动关闭，请调用 dismissToast 或 dismissAll。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时共用固定匿名 ID toast_anonymous，后一次展示替换前一次。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | 本次 Toast 的标识，可传给 `dismissToast`；未传 toastId 时使用共享匿名标识并复用匿名提示。 | - |


##### TToast.showLoading

带文案的加载Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| text | String? | - | 加载提示文案。 | 否 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长，默认 2000ms；零或负时长不自动关闭，请调用 dismissToast 或 dismissAll。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| customWidget | Widget? | - | 自定义加载文案区域；传入后替换 text 对应内容，加载指示器仍显示。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 加载图标尺寸。 | 否 |
| iconColor | Color? | - | 加载图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时共用固定匿名 ID toast_anonymous，后一次展示替换前一次。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | 本次 Toast 的标识，可传给 `dismissToast`；未传 toastId 时使用共享匿名标识并复用匿名提示。 | - |


##### TToast.showLoadingWithoutText

不带文案的加载Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长，默认 2000ms；零或负时长不自动关闭，请调用 dismissToast 或 dismissAll。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| iconSize | double? | - | 加载图标尺寸。 | 否 |
| iconColor | Color? | - | 加载图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时共用固定匿名 ID toast_anonymous，后一次展示替换前一次。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | 本次 Toast 的标识，可传给 `dismissToast`；未传 toastId 时使用共享匿名标识并复用匿名提示。 | - |


##### TToast.showSuccess

位置参数：`text`


成功提示Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案。 | 是 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 | 否 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长，默认 2000ms；零或负时长不自动关闭，请调用 dismissToast 或 dismissAll。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时共用固定匿名 ID toast_anonymous，后一次展示替换前一次。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | 本次 Toast 的标识，可传给 `dismissToast`；未传 toastId 时使用共享匿名标识并复用匿名提示。 | - |


##### TToast.showText

位置参数：`text`


普通文本Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案；为 null 时只展示自定义内容。 | 是 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长，默认 2000ms；零或负时长不自动关闭，请调用 dismissToast 或 dismissAll。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| constraints | BoxConstraints? | - | Toast 内容约束。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| customWidget | Widget? | - | 自定义内容；传入后优先展示。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时共用固定匿名 ID toast_anonymous，后一次展示替换前一次。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | 本次 Toast 的标识，可传给 `dismissToast`；未传 toastId 时使用共享匿名标识并复用匿名提示。 | - |


##### TToast.showWarning

位置参数：`text`


警告Toast

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案。 | 是 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 | 否 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长，默认 2000ms；零或负时长不自动关闭，请调用 dismissToast 或 dismissAll。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时共用固定匿名 ID toast_anonymous，后一次展示替换前一次。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | 本次 Toast 的标识，可传给 `dismissToast`；未传 toastId 时使用共享匿名标识并复用匿名提示。 | - |


### TOverlayConfig

蒙层行为配置

统一收敛 Toast 展示期间遮罩层的各项行为：
- `showOverlay`：是否显示可见半透明蒙层（与 `preventScrollThrough` 解耦，
`true` 时展示半透明黑色蒙层遮住背景）；
- `color` / `opacity`：蒙层颜色与透明度，`color` 为 null 时由
`Colors.black.withValues(alpha: opacity)` 派生黑色蒙层；
- `preventScrollThrough`：是否禁止背景点击和滚动（与蒙层是否可见解耦，
`true` 时展示期间阻止背景点击、触控滑动和鼠标滚轮；Toast 内容自身仍可交互）。

#### 构造方法

##### TOverlayConfig

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| color | Color? | - | 蒙层颜色；为 null 时由 `opacity` 派生黑色蒙层。 | 否 |
| opacity | double | 0.2 | 蒙层透明度（0~1，默认 0.2）。 | 否 |
| preventScrollThrough | bool | false | 是否禁止背景点击和滚动（默认 false）。 | 否 |
| showOverlay | bool | false | 是否显示可见半透明蒙层（默认 false）。 | 否 |


### IconTextDirection

Toast 文案排列方向
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| horizontal | IconTextDirection | - | 横向 | - |
| vertical | IconTextDirection | - | 竖向 | - |


### TToastPlacement

Toast 展示位置
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| top | TToastPlacement | - | 顶部（中心距 Overlay 顶部 25%，水平居中） | - |
| middle | TToastPlacement | - | 中间（中心距 Overlay 顶部 45%） | - |
| bottom | TToastPlacement | - | 底部（中心距 Overlay 顶部 75%，水平居中） | - |


### TToastThemeData

TToast 组件级 ThemeExtension

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色 | 否 |
| borderRadius | double? | - | 圆角 | 否 |
| iconColor | Color? | - | 图标颜色 | 否 |
| iconSize | double? | - | 图标尺寸 | 否 |
| maxWidth | double? | - | 最大宽度 | 否 |
| padding | EdgeInsetsGeometry? | - | 内边距 | 否 |
| textStyle | TextStyle? | - | 文案样式 | 否 |


#### 静态方法

##### TToastThemeData.lerpDouble

位置参数：`a, b, t`


对 `a` 和 `b` 按 `t` 线性插值；两端均为 null 时返回 null，仅一端为 null 时按 0 参与计算。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| a | double? | - | 插值起始值；单端为空时按 0 参与插值。 | 是 |
| b | double? | - | 插值目标值；单端为空时按 0 参与插值。 | 是 |
| t | double | - | 插值进度；0 表示起点，1 表示终点。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | double? | - | 按 t 线性插值的数值；两端均为 null 时为 null，仅一端为 null 时将该端按 0 计算。 | - |

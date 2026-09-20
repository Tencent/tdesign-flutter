---
title: Toast 轻提示
description: 用于轻量级反馈或提示，不会打断用户操作。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

通过统一入口引入 TDesign Flutter 组件：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

{{ flutter-example-group toast }}

## API
### TToast

#### 静态方法

##### TToast.dismissAll

关闭所有Toast

返回类型：`void`

##### TToast.dismissToast

关闭指定的Toast

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| toastId | String | - | - |


##### TToast.showFail

失败提示Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | - |
| direction | IconTextDirection | IconTextDirection.horizontal | - |
| context | BuildContext | - | - |
| duration | Duration | const Duration(milliseconds: 2000) | - |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等） |
| placement | TToastPlacement | TToastPlacement.middle | 展示位置 |
| backgroundColor | Color? | - | - |
| maxLines | int? | - | - |
| textStyle | TextStyle? | - | - |
| iconSize | double? | - | - |
| iconColor | Color? | - | - |
| toastId | String? | - | - |


##### TToast.showIconText

带图标的Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | - |
| icon | IconData? | - | - |
| direction | IconTextDirection | IconTextDirection.horizontal | - |
| context | BuildContext | - | - |
| duration | Duration | const Duration(milliseconds: 2000) | - |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等） |
| placement | TToastPlacement | TToastPlacement.middle | 展示位置 |
| backgroundColor | Color? | - | - |
| maxLines | int? | - | - |
| textStyle | TextStyle? | - | - |
| iconSize | double? | - | - |
| iconColor | Color? | - | - |
| toastId | String? | - | - |


##### TToast.showLoading

带文案的加载Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| text | String? | - | - |
| duration | Duration | const Duration(seconds: 99999999) | - |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等） |
| placement | TToastPlacement | TToastPlacement.middle | 展示位置 |
| customWidget | Widget? | - | - |
| backgroundColor | Color? | - | - |
| textStyle | TextStyle? | - | - |
| iconSize | double? | - | - |
| iconColor | Color? | - | - |
| toastId | String? | - | - |


##### TToast.showLoadingWithoutText

不带文案的加载Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| duration | Duration | const Duration(seconds: 99999999) | - |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等） |
| placement | TToastPlacement | TToastPlacement.middle | 展示位置 |
| backgroundColor | Color? | - | - |
| iconSize | double? | - | - |
| iconColor | Color? | - | - |
| toastId | String? | - | - |


##### TToast.showSuccess

成功提示Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | - |
| direction | IconTextDirection | IconTextDirection.horizontal | - |
| context | BuildContext | - | - |
| duration | Duration | const Duration(milliseconds: 2000) | - |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等） |
| placement | TToastPlacement | TToastPlacement.middle | 展示位置 |
| backgroundColor | Color? | - | - |
| maxLines | int? | - | - |
| textStyle | TextStyle? | - | - |
| iconSize | double? | - | - |
| iconColor | Color? | - | - |
| toastId | String? | - | - |


##### TToast.showText

普通文本Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | - |
| context | BuildContext | - | - |
| duration | Duration | const Duration(milliseconds: 2000) | - |
| maxLines | int? | - | - |
| constraints | BoxConstraints? | - | - |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等） |
| placement | TToastPlacement | TToastPlacement.middle | 展示位置 |
| customWidget | Widget? | - | - |
| backgroundColor | Color? | - | - |
| textStyle | TextStyle? | - | - |
| toastId | String? | - | - |


##### TToast.showWarning

警告Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | - |
| direction | IconTextDirection | IconTextDirection.horizontal | - |
| context | BuildContext | - | - |
| duration | Duration | const Duration(milliseconds: 2000) | - |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等） |
| placement | TToastPlacement | TToastPlacement.middle | 展示位置 |
| backgroundColor | Color? | - | - |
| maxLines | int? | - | - |
| textStyle | TextStyle? | - | - |
| iconSize | double? | - | - |
| iconColor | Color? | - | - |
| toastId | String? | - | - |


### IconTextDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 横向 |
| vertical | 竖向 |

### TToastPlacement
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| top | 顶部 |
| middle | 居中 |
| bottom | 底部 |

### TOverlayConfig

蒙层行为配置（可见遮罩、拦截点击等）。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| showOverlay | bool | false | 是否显示可见半透明蒙层 |
| color | Color? | - | 蒙层颜色（null 时由 opacity 派生黑色） |
| opacity | double | 0.2 | 蒙层透明度 |
| preventTap | bool | false | 是否拦截背景点击 |

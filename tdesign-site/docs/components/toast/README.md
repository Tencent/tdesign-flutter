---
title: Toast 轻提示
description: 用于轻量级反馈或提示，不会打断用户操作。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[t_toast_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_toast_page.dart)

### 1 基础提示

纯文本

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('纯文本'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText('轻提示文字内容', context: context);
        },
      ),
    );
  }</pre>

</td-code-block>

多行文字

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMultipleTextToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('多行文字'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText(
            '最多一行展示十个汉字宽度限制最多不超过三行文字',
            context: context,
          );
        },
      ),
    );
  }</pre>

</td-code-block>

带横向图标

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHorizontalIconToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('带横向图标'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showIconText(
            '带横向图标',
            icon: TIcons.check_circle,
            direction: IconTextDirection.horizontal,
            context: context,
          );
        },
      ),
    );
  }</pre>

</td-code-block>

带竖向图标

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVerticalIconToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('带竖向图标'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showIconText(
            '带竖向图标',
            icon: TIcons.check_circle,
            direction: IconTextDirection.vertical,
            context: context,
          );
        },
      ),
    );
  }</pre>

</td-code-block>

加载状态

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLoadingToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('加载状态'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          final id = TToast.showLoading(
            text: '加载中...',
            context: context,
          );
          // 3 秒后关闭
          Future.delayed(const Duration(seconds: 3), () {
            TToast.dismissToast(id);
          });
        },
      ),
    );
  }</pre>

</td-code-block>

### 2 组件状态

成功提示

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSuccessToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('成功提示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showSuccess('成功文案', context: context);
        },
      ),
    );
  }</pre>

</td-code-block>

警告提示

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildWarningToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('警告提示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.danger,
        onPressed: () {
          TToast.showWarning('警告文案', context: context);
        },
      ),
    );
  }</pre>

</td-code-block>

错误提示

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFailToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('错误提示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.danger,
        onPressed: () {
          TToast.showFail('错误文案', context: context);
        },
      ),
    );
  }</pre>

</td-code-block>

### 3 显示遮罩

禁止滑动和点击

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCoverToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('禁止滑动和点击'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText(
            '禁止滑动和点击',
            context: context,
            overlay: const TOverlayConfig(
              showOverlay: true,
              opacity: 0.4,
              preventTap: true,
            ),
          );
        },
      ),
    );
  }</pre>

</td-code-block>

### 4 手动关闭

显示提示

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildShowToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('显示提示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText(
            '轻提示文字内容',
            context: context,
            duration: const Duration(seconds: 99999999),
          );
        },
      ),
    );
  }</pre>

</td-code-block>

关闭提示

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHideToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('关闭提示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.dismissAll();
        },
      ),
    );
  }</pre>

</td-code-block>

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

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

纯文字
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textToast(BuildContext context) {
    return TButton(
      onPressed: () {
        TToast.showText('轻提示文字内容', context: context);
      },
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      isBlock: true,
      child: Text('纯文字'),
    );
  }</pre>

</td-code-block>
                                  

多行文字
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _multipleToast(BuildContext context) {
    return TButton(
      onPressed: () {
        TToast.showText('最多一行展示十个汉字宽度限制最多不超过三行文字', context: context);
      },
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      isBlock: true,
      child: Text('多行文字'),
    );
  }</pre>

</td-code-block>
                                  

带竖向图标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _verticalIconToast(BuildContext context) {
    return TButton(
      onPressed: () {
        TToast.showIconText(
          '带竖向图标',
          icon: TIcons.check_circle,
          direction: IconTextDirection.vertical,
          context: context,
        );
      },
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      isBlock: true,
      child: Text('带竖向图标'),
    );
  }</pre>

</td-code-block>
                                  

加载状态(无文字)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _loadingWithoutTextToast(BuildContext context) {
    return TButton(
      onPressed: () {
        final id = TToast.showLoadingWithoutText(context: context);
        Future.delayed(const Duration(seconds: 2), () {
          TToast.dismissToast(id);
        });
      },
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      isBlock: true,
      child: Text('加载状态（无文字）'),
    );
  }</pre>

</td-code-block>


加载状态自定义

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _loadingCustomToast(BuildContext context) {
    return TButton(
      onPressed: () {
        final id = TToast.showLoading(
          context: context,
          customWidget: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: context.tTheme.brandColor1,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const TText('加载'),
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          TToast.dismissToast(id);
        });
      },
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      isBlock: true,
      child: Text('加载状态自定义'),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

成功提示
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _successToast(BuildContext context) {
    return TButton(
      onPressed: () {
        TToast.showSuccess('成功文案', context: context);
      },
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      isBlock: true,
      child: Text('成功提示'),
    );
  }</pre>

</td-code-block>
                                  

警告提示
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _warningToast(BuildContext context) {
    return TButton(
      onPressed: () {
        TToast.showWarning('警告文案', context: context);
      },
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.danger,
      isBlock: true,
      child: Text('警告提示'),
    );
  }</pre>

</td-code-block>
                                  

失败提示
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _failToast(BuildContext context) {
    return TButton(
      onPressed: () {
        TToast.showFail('失败文案', context: context);
      },
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.danger,
      isBlock: true,
      child: Text('失败提示'),
    );
  }</pre>

</td-code-block>
                                  

### 展示位置

顶部展示
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _topToast(BuildContext context) {
    return TButton(
      onPressed: () {
        TToast.showText(
          '顶部提示',
          context: context,
          placement: TToastPlacement.top,
        );
      },
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      isBlock: true,
      child: Text('顶部展示'),
    );
  }</pre>

</td-code-block>
                                  

底部展示
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _bottomToast(BuildContext context) {
    return TButton(
      onPressed: () {
        TToast.showText(
          '底部提示',
          context: context,
          placement: TToastPlacement.bottom,
        );
      },
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      isBlock: true,
      child: Text('底部展示'),
    );
  }</pre>

</td-code-block>
                                  

### 显示遮罩

半透明遮罩
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _showOverlayToast(BuildContext context) {
    return TButton(
      onPressed: () {
        TToast.showText(
          '遮罩展示',
          context: context,
          overlay: const TOverlayConfig(
            showOverlay: true,
            opacity: 0.4,
            preventTap: true,
          ),
        );
      },
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      isBlock: true,
      child: Text('半透明遮罩'),
    );
  }</pre>

</td-code-block>
                                  

### 手动关闭

手动关闭
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _manualCloseToast(BuildContext context) {
    return TButton(
      onPressed: () {
        final id = TToast.showLoading(context: context, text: '加载中...');
        Future.delayed(const Duration(milliseconds: 500), () {
          TToast.dismissToast(id);
        });
      },
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      isBlock: true,
      child: Text('手动关闭'),
    );
  }</pre>

</td-code-block>
                                  



### 自定义时长与倒计时

`duration` 控制 Toast 自动关闭时间；需要让用户感知剩余时间时，可以通过 `customWidget` 在同一个 Toast 内更新内容，无需重复创建 Overlay。

```dart
TToast.showText(
  null,
  context: context,
  duration: const Duration(seconds: 5),
  customWidget: TweenAnimationBuilder<double>(
    tween: Tween(begin: 5, end: 0),
    duration: const Duration(seconds: 5),
    builder: (context, remaining, _) {
      return TText(
        '${remaining.ceil()} 秒后关闭',
        font: context.tTheme.fontBodyMedium,
        textColor: context.tTheme.textColorAnti,
      );
    },
  ),
);
```

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

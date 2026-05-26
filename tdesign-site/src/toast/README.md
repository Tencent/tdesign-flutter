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

[td_toast_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_toast_page.dart)

### 1 组件类型

纯文字
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showText('轻提示文字内容', context: context);
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '纯文字',
    );
  }</pre>

</td-code-block>
                                  

多行文字
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _multipleToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showText('最多一行展示十个汉字宽度限制最多不超过三行文字', context: context);
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '多行文字',
    );
  }</pre>

</td-code-block>
                                  

带横向图标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _horizontalIconToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showIconText(
          '带横向图标',
          icon: TIcons.check_circle,
          context: context,
        );
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '带横向图标',
    );
  }</pre>

</td-code-block>
                                  

带竖向图标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _verticalIconToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showIconText(
          '带竖向图标',
          icon: TIcons.check_circle,
          direction: IconTextDirection.vertical,
          context: context,
        );
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '带竖向图标',
    );
  }</pre>

</td-code-block>
                                  

加载状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _loadingToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showLoading(context: context);
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '加载状态',
    );
  }</pre>

</td-code-block>
                                  

加载状态自定义
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _loadingCustomToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showLoading(
          context: context,
          customWidget: Container(
            width: 50,
            height: 20,
            child: const TText('自定义加载'),
            color: TTheme.of(context).brandColor1,
          ),
        );
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '加载状态',
    );
  }</pre>

</td-code-block>
                                  

加载状态(无文字)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _loadingWithoutTextToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showLoadingWithoutText(context: context);
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '加载状态（无文案）',
    );
  }</pre>

</td-code-block>
                                  

停止加载
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _dismissLoadingToast(BuildContext context) {
    return const TButton(
      onTap: TToast.dismissLoading,
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '停止加载',
    );
  }</pre>

</td-code-block>
                                  

自定义纯文字
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _textCustomToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showText(
          '自定义纯文字',
          context: context,
          customWidget: Container(
            width: 50,
            height: 20,
            child: const TText('自定义纯文字'),
            color: TTheme.of(context).brandClickColor,
          ),
        );
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '纯文字',
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

成功提示
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _successToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showSuccess('成功文案', context: context);
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '成功提示',
    );
  }</pre>

</td-code-block>
                                  

成功提示(竖向)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _successVerticalToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showSuccess(
          '成功文案',
          direction: IconTextDirection.vertical,
          context: context,
        );
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '成功提示(竖向)',
    );
  }</pre>

</td-code-block>
                                  

警告提示
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _warningToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showWarning(
          '警告文案',
          direction: IconTextDirection.horizontal,
          context: context,
        );
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '警告提示',
    );
  }</pre>

</td-code-block>
                                  

警告提示(竖向)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _warningVerticalToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showWarning(
          '警告文案',
          direction: IconTextDirection.vertical,
          context: context,
        );
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '警告提示(竖向)',
    );
  }</pre>

</td-code-block>
                                  

失败提示
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _failToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showFail(
          '失败文案',
          direction: IconTextDirection.horizontal,
          context: context,
        );
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '失败提示',
    );
  }</pre>

</td-code-block>
                                  

失败提示(竖向)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _failVerticalToast(BuildContext context) {
    return TButton(
      onTap: () {
        TToast.showFail(
          '失败文案',
          direction: IconTextDirection.vertical,
          context: context,
        );
      },
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      isBlock: true,
      text: '失败提示(竖向)',
    );
  }</pre>

</td-code-block>
                                  


## API
### TToast

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| dismissAll | void | - | 关闭所有Toast |
| dismissLoading | void | - | 关闭加载Toast（向后兼容） |
| dismissToast | void | required String toastId | 关闭指定的Toast |
| showFail | String | required String? text, IconTextDirection direction, required BuildContext context, Duration duration, bool? preventTap, Color? backgroundColor, int? maxLines, TextStyle? textStyle, double? iconSize, Color? iconColor, String? toastId | 失败提示Toast |
| showIconText | String | required String? text, IconData? icon, IconTextDirection direction, required BuildContext context, Duration duration, bool? preventTap, Color? backgroundColor, int? maxLines, TextStyle? textStyle, double? iconSize, Color? iconColor, String? toastId | 带图标的Toast |
| showLoading | String | required BuildContext context, String? text, Duration duration, bool? preventTap, Widget? customWidget, Color? backgroundColor, TextStyle? textStyle, double? iconSize, Color? iconColor, String? toastId | 带文案的加载Toast |
| showLoadingWithoutText | String | required BuildContext context, Duration duration, bool? preventTap, Color? backgroundColor, double? iconSize, Color? iconColor, String? toastId | 不带文案的加载Toast |
| showSuccess | String | required String? text, IconTextDirection direction, required BuildContext context, Duration duration, bool? preventTap, Color? backgroundColor, int? maxLines, TextStyle? textStyle, double? iconSize, Color? iconColor, String? toastId | 成功提示Toast |
| showText | String | required String? text, required BuildContext context, Duration duration, int? maxLines, BoxConstraints? constraints, bool? preventTap, Widget? customWidget, Color? backgroundColor, TextStyle? textStyle, String? toastId | 普通文本Toast |
| showWarning | String | required String? text, IconTextDirection direction, required BuildContext context, Duration duration, bool? preventTap, Color? backgroundColor, int? maxLines, TextStyle? textStyle, double? iconSize, Color? iconColor, String? toastId | 警告Toast |


### IconTextDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 横向 |
| vertical | 竖向 |


  
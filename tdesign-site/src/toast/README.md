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
    return TDButton(
      onTap: () {
        TDToast.showText('轻提示文字内容', context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '纯文字',
    );
  }</pre>

</td-code-block>
                                  

多行文字
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _multipleToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showText('最多一行展示十个汉字宽度限制最多不超过三行文字', context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '多行文字',
    );
  }</pre>

</td-code-block>
                                  

带横向图标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _horizontalIconToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showIconText('带横向图标',
            icon: TDIcons.check_circle, context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '带横向图标',
    );
  }</pre>

</td-code-block>
                                  

带竖向图标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _verticalIconToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showIconText('带竖向图标',
            icon: TDIcons.check_circle,
            direction: IconTextDirection.vertical,
            context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '带竖向图标',
    );
  }</pre>

</td-code-block>
                                  

加载状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _loadingToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showLoading(context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '加载状态',
    );
  }</pre>

</td-code-block>
                                  

加载状态(无文字)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _loadingWithoutTextToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showLoadingWithoutText(context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '加载状态（无文案）',
    );
  }</pre>

</td-code-block>
                                  

停止加载
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _dismissLoadingToast(BuildContext context) {
    return const TDButton(
      onTap: TDToast.dismissLoading,
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '停止加载',
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

成功提示
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _successToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showSuccess('成功文案',context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '成功提示',
    );
  }</pre>

</td-code-block>
                                  

成功提示(竖向)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _successVerticalToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showSuccess('成功文案',
            direction: IconTextDirection.vertical, context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '成功提示(竖向)',
    );
  }</pre>

</td-code-block>
                                  

警告提示
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _warningToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showWarning('警告文案',
            direction: IconTextDirection.horizontal, context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '警告提示',
    );
  }</pre>

</td-code-block>
                                  

警告提示(竖向)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _warningVerticalToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showWarning('警告文案',
            direction: IconTextDirection.vertical, context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '警告提示(竖向)',
    );
  }</pre>

</td-code-block>
                                  

失败提示
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _failToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showFail('失败文案',
            direction: IconTextDirection.horizontal, context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '失败提示',
    );
  }</pre>

</td-code-block>
                                  

失败提示(竖向)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _failVerticalToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showFail('失败文案',
            direction: IconTextDirection.vertical, context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '失败提示(竖向)',
    );
  }</pre>

</td-code-block>
                                  


## API
### TDToast

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showText |  |   required String? text,  required BuildContext context,  Duration duration,  int? maxLines,  BoxConstraints? constraints,  bool? preventTap,  Color? backgroundColor, | 普通文本Toast |
| showIconText |  |   required String? text,  IconData? icon,  IconTextDirection direction,  required BuildContext context,  Duration duration,  bool? preventTap,  Color? backgroundColor,  int? maxLines, | 带图标的Toast |
| showSuccess |  |   required String? text,  IconTextDirection direction,  required BuildContext context,  Duration duration,  bool? preventTap,  Color? backgroundColor,  int? maxLines, | 成功提示Toast |
| showWarning |  |   required String? text,  IconTextDirection direction,  required BuildContext context,  Duration duration,  bool? preventTap,  Color? backgroundColor,  int? maxLines, | 警告Toast |
| showFail |  |   required String? text,  IconTextDirection direction,  required BuildContext context,  Duration duration,  bool? preventTap,  Color? backgroundColor,  int? maxLines, | 失败提示Toast |
| showLoading |  |   required BuildContext context,  String? text,  Duration duration,  bool? preventTap,  Color? backgroundColor, | 带文案的加载Toast |
| showLoadingWithoutText |  |   required BuildContext context,  String? text,  Duration duration,  bool? preventTap,  Color? backgroundColor, | 不带文案的加载Toast |
| dismissLoading |  |  | 关闭加载Toast |


  
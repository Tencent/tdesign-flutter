---
title: Dialog 对话框
description: 用于显示重要提示或请求用户进行重要操作，一种打断当前操作的模态视图。
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

[td_dialog_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_dialog_page.dart)

### 1 组件类型

反馈类对话框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFeedbackNormal(BuildContext context) {
    return TDButton(
      text: '反馈类-带标题',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDConfirmDialog(
              title: _dialogTitle,
              content: _commonContent,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFeedbackNoTitle(BuildContext context) {
    return TDButton(
      text: '反馈类-无标题',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDConfirmDialog(
              content: _commonContent,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFeedbackOnlyTitle(BuildContext context) {
    return TDButton(
      text: '反馈类-纯标题',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDConfirmDialog(
              title: _dialogTitle,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFeedbackLongContent(BuildContext context) {
    return TDButton(
      text: '反馈类-内容超长',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDConfirmDialog(
              title: _dialogTitle,
              content: _longContent,
              contentMaxHeight: 300,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  

确认类对话框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildConfirmNormal(BuildContext context) {
    return TDButton(
      text: '确认类-带标题',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDAlertDialog(
              title: _dialogTitle,
              content: _commonContent,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildConfirmNoTitle(BuildContext context) {
    return TDButton(
      text: '确认类-无标题',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDAlertDialog(
              content: _commonContent,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildConfirmOnlyTitle(BuildContext context) {
    return TDButton(
      text: '确认类-纯标题',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDAlertDialog(
              title: _dialogTitle,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  

输入类对话框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildInputNormal(BuildContext context) {
    return TDButton(
      text: '输入类-带描述',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDInputDialog(
              textEditingController: TextEditingController(),
              title: _dialogTitle,
              content: _commonContent,
              hintText: _inputHint,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildInputNoContent(BuildContext context) {
    return TDButton(
      text: '输入类-无描述',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDInputDialog(
              textEditingController: TextEditingController(),
              title: _dialogTitle,
              hintText: _inputHint,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  

带图片的对话框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildImageTop(BuildContext context) {
    return TDButton(
      text: '图片置顶-带标题描述',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDImageDialog(
              image: _demoImage,
              title: _dialogTitle,
              content: _commonContent,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildImageTopNoTitle(BuildContext context) {
    return TDButton(
      text: '图片置顶-无标题',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDImageDialog(
              image: _demoImage,
              content: _commonContent,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildImageTopOnlyTitle(BuildContext context) {
    return TDButton(
      text: '图片置顶-纯标题',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDImageDialog(
              image: _demoImage,
              title: _dialogTitle,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildImageMiddle(BuildContext context) {
    return TDButton(
      text: '图片居中-带标题描述',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDImageDialog(
              image: _demoImage,
              title: _dialogTitle,
              content: _commonContent,
              imagePosition: TDDialogImagePosition.middle,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildImageMiddleOnlyTitle(BuildContext context) {
    return TDButton(
      text: '图片居中-纯标题',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDImageDialog(
              image: _demoImage,
              title: _dialogTitle,
              imagePosition: TDDialogImagePosition.middle,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildImageMiddleOnlyImage(BuildContext context) {
    return TDButton(
      text: '图片居中-纯图片',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDImageDialog(
              image: _demoImage,
              imagePosition: TDDialogImagePosition.middle,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 组件类型

文字按钮
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextButtonSingle(BuildContext context) {
    return TDButton(
      text: '单个文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDConfirmDialog(
              title: _dialogTitle,
              content: _commonContent,
              buttonStyle: TDDialogButtonStyle.text,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextButtonDouble(BuildContext context) {
    return TDButton(
      text: '左右文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDAlertDialog(
              title: _dialogTitle,
              content: _commonContent,
              buttonStyle: TDDialogButtonStyle.text,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  

横向基础按钮
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildNormalButtonSingle(BuildContext context) {
    return TDButton(
      text: '单个横向基础按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDConfirmDialog(
              title: _dialogTitle,
              content: _commonContent,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildNormalButtonDouble(BuildContext context) {
    return TDButton(
      text: '左右横向基础按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDAlertDialog(
              title: _dialogTitle,
              content: _commonContent,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  

纵向基础按钮
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVerticalButtonDouble(BuildContext context) {
    return TDButton(
      text: '两个纵向基础按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDAlertDialog.vertical(
                title: _dialogTitle,
                content: _commonContent,
                buttons: [
                  TDDialogButtonOptions(
                      title: '主要按钮',
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TDButtonTheme.primary),
                  TDDialogButtonOptions(
                      title: '次要按钮',
                      titleColor: TDTheme.of(context).brandColor7,
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TDButtonTheme.light),
                ]);
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVerticalButtonTriple(BuildContext context) {
    return TDButton(
      text: '三个纵向基础按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDAlertDialog.vertical(
                title: _dialogTitle,
                content: _commonContent,
                buttons: [
                  TDDialogButtonOptions(
                      title: '主要按钮',
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TDButtonTheme.primary),
                  TDDialogButtonOptions(
                      title: '次要按钮',
                      titleColor: TDTheme.of(context).brandColor7,
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TDButtonTheme.light),
                  TDDialogButtonOptions(
                      title: '次要按钮',
                      titleColor: TDTheme.of(context).brandColor7,
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TDButtonTheme.light),
                ]);
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  

带关闭按钮的对话框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDialogWithCloseButton(BuildContext context) {
    return TDButton(
      text: '带关闭按钮的对话框',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDConfirmDialog(
              title: _dialogTitle,
              content: _commonContent,
              showCloseButton: true,
            );
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  


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
| padding | EdgeInsets? | - | 内容内边距 |
| buttonWidget | Widget? | - | 自定义按钮 |

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
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| buttonWidget | Widget? | - | 自定义按钮 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDAlertDialog.vertical  | 纵向按钮排列的对话框

 [buttons]参数是必须的，纵向按钮默认样式都是[TDButtonTheme.primary] |

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
| buttonText | String? | - | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonStyle | TDDialogButtonStyle | TDDialogButtonStyle.normal | 按钮样式 |
| showCloseButton | bool? | - | 右上角关闭按钮 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| buttonWidget | Widget? | - | 自定义按钮 |

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
| title | String? | - | 标题文字 |
| titleColor | Color | Colors.black | 标题颜色 |

```
```
 ### TDDialogContent
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| content | String? | - | 标题文字 |
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
| buttonText | String? | - | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonTextSize | double? | - | 按钮文字大小 |
| buttonTextFontWeight | FontWeight? | FontWeight.w600 | 按钮文字粗细 |
| buttonStyle | TDButtonStyle? | - | 按钮样式 |
| buttonType | TDButtonType? | - | 按钮类型 |
| buttonTheme | TDButtonTheme? | - | 按钮主题 |
| onPressed |  Function() | - | 点击 |
| height | double? | 40.0 | 按钮高度 |
| width | double? | - | 按钮宽度 |
| isBlock | bool | true | 按钮高度 |

```
```
 ### TDDialogButtonOptions
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | String | - | 标题内容 |
| action |  Function()? | - | 点击操作 |
| titleColor | Color? | - | 标题颜色 |
| titleSize | double? | - | 字体大小 |
| style | TDButtonStyle? | - | 按钮样式 |
| type | TDButtonType? | - | 按钮类型 |
| theme | TDButtonTheme? | - | 按钮类型 |
| height | double? | - | 按钮高度 |
| fontWeight | FontWeight? | - | 字体粗细 |

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
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| buttonWidget | Widget? | - | 自定义按钮 |
| customInputWidget | Widget? | - | 自定义输入框 |


  
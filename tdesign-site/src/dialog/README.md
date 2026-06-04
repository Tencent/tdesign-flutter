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
    return TButton(
      text: '反馈类-带标题',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
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
    return TButton(
      text: '反馈类-无标题',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
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
    return TButton(
      text: '反馈类-纯标题',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
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
    return TButton(
      text: '反馈类-内容超长',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
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
    return TButton(
      text: '确认类-带标题',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog(
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
    return TButton(
      text: '确认类-无标题',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog(
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
    return TButton(
      text: '确认类-纯标题',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog(
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
    return TButton(
      text: '输入类-带描述',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TInputDialog(
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
    return TButton(
      text: '输入类-无描述',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TInputDialog(
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
    return TButton(
      text: '图片置顶-带标题描述',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
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
    return TButton(
      text: '图片置顶-无标题',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
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
    return TButton(
      text: '图片置顶-纯标题',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
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
    return TButton(
      text: '图片居中-带标题描述',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
              image: _demoImage,
              title: _dialogTitle,
              content: _commonContent,
              imagePosition: TDialogImagePosition.middle,
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
    return TButton(
      text: '图片居中-纯标题',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
              image: _demoImage,
              title: _dialogTitle,
              imagePosition: TDialogImagePosition.middle,
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
    return TButton(
      text: '图片居中-纯图片',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
              image: _demoImage,
              imagePosition: TDialogImagePosition.middle,
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
    return TButton(
      text: '单个文字按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
              title: _dialogTitle,
              content: _commonContent,
              buttonStyle: TDialogButtonStyle.text,
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
    return TButton(
      text: '左右文字按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog(
              title: _dialogTitle,
              content: _commonContent,
              buttonStyle: TDialogButtonStyle.text,
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
    return TButton(
      text: '单个横向基础按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
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
    return TButton(
      text: '左右横向基础按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog(
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
    return TButton(
      text: '两个纵向基础按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog.vertical(
                title: _dialogTitle,
                content: _commonContent,
                buttons: [
                  TDialogButtonOptions(
                      title: '主要按钮',
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TButtonTheme.primary),
                  TDialogButtonOptions(
                      title: '次要按钮',
                      titleColor: TTheme.of(context).brandColor7,
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TButtonTheme.light),
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
    return TButton(
      text: '三个纵向基础按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog.vertical(
                title: _dialogTitle,
                content: _commonContent,
                buttons: [
                  TDialogButtonOptions(
                      title: '主要按钮',
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TButtonTheme.primary),
                  TDialogButtonOptions(
                      title: '次要按钮',
                      titleColor: TTheme.of(context).brandColor7,
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TButtonTheme.light),
                  TDialogButtonOptions(
                      title: '次要按钮',
                      titleColor: TTheme.of(context).brandColor7,
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TButtonTheme.light),
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
    return TButton(
      text: '带关闭按钮的对话框',
      size: TButtonSize.large,
      type: TButtonType.outline,
      theme: TButtonTheme.primary,
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
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
### TAlertDialog

#### 工厂构造方法

##### TAlertDialog.vertical

纵向按钮排列的对话框
`buttons`参数是必须的，纵向按钮默认样式都是`TButtonTheme.primary`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| buttons | List<TDialogButtonOptions> | - | - |
| backgroundColor | Color? | - | 背景颜色 |
| radius | double | 12.0 | 圆角 |
| title | String? | - | 标题 |
| titleColor | Color? | - | 标题颜色 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| contentWidget | Widget? | - | 内容Widget |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| buttonWidget | Widget? | - | 自定义按钮 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| buttonStyle | TDialogButtonStyle | TDialogButtonStyle.normal | - |
| buttonWidget | Widget? | - | 自定义按钮 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| contentWidget | Widget? | - | 内容Widget |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftBtn | TDialogButtonOptions? | - | 左侧按钮配置 |
| leftBtnAction | Function()? | - | 左侧按钮默认点击 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| rightBtn | TDialogButtonOptions? | - | 右侧按钮配置 |
| rightBtnAction | Function()? | - | 右侧按钮默认点击 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |


### TConfirmDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | Function()? | - | 点击 |
| backgroundColor | Color? | - | 背景颜色 |
| buttonStyle | TDialogButtonStyle | TDialogButtonStyle.normal | 按钮样式 |
| buttonStyleCustom | TButtonStyle? | - | 按钮自定义样式属性，背景色、边框... |
| buttonText | String? | - | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonWidget | Widget? | - | 自定义按钮 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| contentWidget | Widget? | - | 内容Widget |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| showCloseButton | bool? | - | 右上角关闭按钮 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |
| width | double? | - | - |


### TDialogButtonOptions
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | Function()? | - | 点击操作 |
| fontWeight | FontWeight? | - | 字体粗细 |
| height | double? | - | 按钮高度 建议使用默认高度 |
| style | TButtonStyle? | - | 按钮样式 设置单个按钮的样式会覆盖Dialog的默认样式 |
| theme | TButtonTheme? | - | 按钮类型 |
| title | String | - | 标题内容 |
| titleColor | Color? | - | 标题颜色 |
| titleSize | double? | - | 字体大小 |
| type | TButtonType? | - | 按钮类型 |


### TDialogScaffold
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色 |
| body | Widget | - | Dialog主体 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| radius | double | 12.0 | 圆角 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| width | double? | - | 弹窗宽度 |


### TDialogTitle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| title | String? | - | 标题文字 |
| titleColor | Color? | - | 标题颜色 |


### TDialogContent
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String? | - | 标题文字 |
| contentColor | Color? | - | 标题颜色 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |


### TDialogInfoWidget
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentMaxHeight | double | 0 | 内容的最大高度，默认为0，也就是不限制高度 |
| contentWidget | Widget? | - | 内容Widget |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| padding | EdgeInsetsGeometry? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容的内边距 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |


### HorizontalNormalButtons
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftBtn | TDialogButtonOptions | - | 左按钮 |
| rightBtn | TDialogButtonOptions | - | 右按钮 |


### HorizontalTextButtons
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftBtn | TDialogButtonOptions | - | 左按钮 |
| rightBtn | TDialogButtonOptions | - | 右按钮 |


### TDialogButton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| buttonStyle | TButtonStyle? | - | 按钮样式 |
| buttonText | String? | - | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonTextFontWeight | FontWeight? | FontWeight.w600 | 按钮文字粗细 |
| buttonTextSize | double? | - | 按钮文字大小 |
| buttonTheme | TButtonTheme? | - | 按钮主题 |
| buttonType | TButtonType? | - | 按钮类型 |
| height | double? | 40.0 | 按钮高度 |
| isBlock | bool | true | 按钮高度 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | Function() | - | 点击 |
| width | double? | - | 按钮宽度 |


### TImageDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| buttonWidget | Widget? | - | 自定义按钮 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentWidget | Widget? | - | 内容Widget |
| image | Image | - | 图片 |
| imagePosition | TDialogImagePosition? | TDialogImagePosition.top | 图片位置 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftBtn | TDialogButtonOptions? | - | 左侧按钮配置 |
| padding | EdgeInsets? | - | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| rightBtn | TDialogButtonOptions? | - | 右侧按钮配置 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |


### TInputDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| buttonWidget | Widget? | - | 自定义按钮 |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色 |
| contentWidget | Widget? | - | 内容Widget |
| customInputWidget | Widget? | - | 自定义输入框 |
| hintText | String? | '' | 输入提示 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftBtn | TDialogButtonOptions? | - | 左侧按钮配置 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距 |
| radius | double | 12.0 | 圆角 |
| rightBtn | TDialogButtonOptions? | - | 右侧按钮配置 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| textEditingController | TextEditingController | - | 输入controller |
| title | String? | - | 标题 |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| titleColor | Color? | - | 标题颜色 |


### TDialogButtonStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | - |
| text | - |


### TDialogImagePosition
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| top | - |
| middle | - |


  
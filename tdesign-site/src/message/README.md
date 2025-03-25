---
title: Message 全局提示
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

[td_message_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_message_page.dart)

### 1 组件类型

纯文字的通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPlainTextMessage(BuildContext context) {
    return TDButton(
      isBlock: true,
      text: '纯文字的通知',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      width: 450,
      theme: TDButtonTheme.primary,
      onTap: () {
        TDMessage.showMessage(
          context: context,
          content: _commonContent,
          visible: true,
          icon: false,
          theme: MessageTheme.info,
          duration: 3000,
          onDurationEnd: () {
            print('message end');
          },
        );
      },
    );
  }</pre>

</td-code-block>
                                  

带图标的通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildIconTextMessage(BuildContext context) {
    return TDButton(
        isBlock: true,
        text: '带图标的通知',
        size: TDButtonSize.large,
        type: TDButtonType.outline,
        width: 450,
        theme: TDButtonTheme.primary,
        onTap: () {
          TDMessage.showMessage(
            context: context,
            content: _commonContent,
            visible: true,
            icon: true,
            theme: MessageTheme.info,
            duration: 3000,
          );
        });
  }</pre>

</td-code-block>
                                  

带关闭的通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMessageWithCloseButton(BuildContext context) {
    return TDButton(
        isBlock: true,
        text: '带关闭的通知',
        size: TDButtonSize.large,
        type: TDButtonType.outline,
        width: 450,
        theme: TDButtonTheme.primary,
        onTap: () {
          TDMessage.showMessage(
            context: context,
            visible: true,
            icon: true,
            content: _commonContent,
            theme: MessageTheme.info,
            duration: 300000,
            closeBtn: true,
            link: MessageLink(name: '按钮', uri: Uri.parse('www.example.com')),
            onCloseBtnClick: () {
              print('Close button clicked!');
            },
          );
        });
  }</pre>

</td-code-block>
                                  

可滚动的通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRollingMessage(BuildContext context) {
    return TDButton(
        isBlock: true,
        text: '可滚动的通知',
        size: TDButtonSize.large,
        type: TDButtonType.outline,
        width: 450,
        theme: TDButtonTheme.primary,
        onTap: () {
          TDMessage.showMessage(
              context: context,
              visible: true,
              icon: false,
              marquee: MessageMarquee(speed: 5000, loop: 1, delay: 300),
              content: longContent,
              theme: MessageTheme.info,
              duration: 8000,
              onCloseBtnClick: () {
                print('Close button clicked!');
              });
        });
  }</pre>

</td-code-block>
                                  

带按钮的通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLinkMessage(BuildContext context) {
    return TDButton(
        isBlock: true,
        text: '带按钮的通知',
        size: TDButtonSize.large,
        type: TDButtonType.outline,
        width: 450,
        theme: TDButtonTheme.primary,
        onTap: () {
          TDMessage.showMessage(
              context: context,
              visible: true,
              icon: true,
              content: _commonContent,
              theme: MessageTheme.info,
              duration: 3000,
              link: '按钮',
              onLinkClick: () {
                print('link clicked!');
              });
        });
  }</pre>

</td-code-block>
                                  
### 1 组件状态

普通通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildInfoMessage(BuildContext context) {
    return TDButton(
      isBlock: true,
      text: '普通通知',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      width: 450,
      theme: TDButtonTheme.primary,
      onTap: () {
        TDMessage.showMessage(
          context: context,
          visible: true,
          icon: true,
          content: _commonContent,
          theme: MessageTheme.info,
          duration: 3000,
        );
      },
    );
  }</pre>

</td-code-block>
                                  

成功通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSuccessMessage(BuildContext context) {
    return TDButton(
      isBlock: true,
      text: '成功通知',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      width: 450,
      theme: TDButtonTheme.primary,
      onTap: () {
        TDMessage.showMessage(
          context: context,
          visible: true,
          icon: true,
          content: _commonContent,
          theme: MessageTheme.success,
          duration: 3000,
        );
      },
    );
  }</pre>

</td-code-block>
                                  

警示通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildWarningMessage(BuildContext context) {
    return TDButton(
        isBlock: true,
        text: '警示通知',
        size: TDButtonSize.large,
        type: TDButtonType.outline,
        width: 450,
        theme: TDButtonTheme.primary,
        onTap: () {
          TDMessage.showMessage(
            context: context,
            visible: true,
            icon: true,
            content: _commonContent,
            theme: MessageTheme.warning,
            duration: 3000,
          );
        });
  }</pre>

</td-code-block>
                                  

错误通知
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildErrorMessage(BuildContext context) {
    return TDButton(
        isBlock: true,
        text: '错误通知',
        size: TDButtonSize.large,
        type: TDButtonType.outline,
        width: 450,
        theme: TDButtonTheme.primary,
        onTap: () {
          TDMessage.showMessage(
            context: context,
            visible: true,
            icon: true,
            content: _commonContent,
            theme: MessageTheme.error,
            duration: 3000,
          );
        });
  }</pre>

</td-code-block>
                                  


## API

暂无对应api


  
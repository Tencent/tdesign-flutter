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
              link: MessageLink(
                name: '按钮',
                uri: Uri.parse('https://tdesign.tencent.com/'),
              ),
              // link: '按钮',
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
### MessageLink
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| name | String | - | 名称 |
| uri | Uri? | - | 资源链接 |
| color | Color? | - | 颜色 |

```
```
 ### MessageMarquee
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| speed | int? | - | 速度 |
| loop | int? | - | 循环次数 |
| delay | int? | - | 延迟时间(毫秒) |

```
```
 ### TDMessage
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| closeBtn | dynamic | - | 关闭按钮 |
| content | String? | - | 通知内容 |
| duration | int? | 3000 | 消息内置计时器 |
| icon | dynamic | true | 自定义消息前面的图标 |
| link | dynamic | - | 链接名称 |
| marquee | MessageMarquee? | - | 跑马灯效果 |
| offset | List<double>? | - | 相对于 placement 的偏移量 |
| theme | MessageTheme? | MessageTheme.info | 消息组件风格 info/success/warning/error |
| visible | bool? | true | 是否显示 |
| onCloseBtnClick | VoidCallback? | - | 点击关闭按钮触发 |
| onDurationEnd | VoidCallback? | - | 计时结束后触发 |
| onLinkClick | VoidCallback? | - | 点击链接文本时触发 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showMessage |  |   required BuildContext context,  String? content,  bool? visible,  int? duration,  dynamic closeBtn,  dynamic icon,  dynamic link,  MessageMarquee? marquee,  List<double>? offset,  MessageTheme? theme,  VoidCallback? onCloseBtnClick,  VoidCallback? onDurationEnd,  VoidCallback? onLinkClick, |  |


  
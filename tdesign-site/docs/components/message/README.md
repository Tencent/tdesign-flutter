---
title: Message 消息通知
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

[t_message_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_message_page.dart)

### 1 组件类型

纯文字的通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextMessage(BuildContext context) {
    return _fullWidthButton(
      text: '纯文字的通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条纯文字的消息通知',
        showIcon: false,
      ),
    );
  }</pre>

</td-code-block>

带图标的通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildIconMessage(BuildContext context) {
    return _fullWidthButton(
      text: '带图标的通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条带图标的消息通知',
      ),
    );
  }</pre>

</td-code-block>

带关闭的通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCloseMessage(BuildContext context) {
    return _fullWidthButton(
      text: '带关闭的通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条带关闭的消息通知',
        duration: null,
        showCloseButton: true,
        action: TLink(
          child: const Text('按钮'),
          colorScheme: TLinkColorScheme.primary,
          onPressed: () => TMessage.show(
            context: context,
            content: '已点击按钮',
          ),
        ),
      ),
    );
  }</pre>

</td-code-block>

可滚动的通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildScrollMessage(BuildContext context) {
    return _fullWidthButton(
      text: '可滚动的通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条较长的通知信息，这是一条较长的通知信息，这是一条较长的通知信息',
        showIcon: false,
        duration: null,
        marquee: const TMessageMarquee(repeat: true),
      ),
    );
  }</pre>

</td-code-block>

带按钮的通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLinkMessage(BuildContext context) {
    return _fullWidthButton(
      text: '带按钮的通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条带操作的消息通知',
        duration: null,
        action: TLink(
          child: const Text('链接'),
          colorScheme: TLinkColorScheme.primary,
          onPressed: () => TMessage.show(
            context: context,
            content: '已点击链接',
          ),
        ),
      ),
    );
  }</pre>

</td-code-block>

组件调用

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildComponentMessage(BuildContext context) {
    return const _DeclarativeMessageDemo();
  }</pre>

</td-code-block>

### 2 组件风格

普通通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildInfoMessage(BuildContext context) {
    return _fullWidthButton(
      text: '普通通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条普通通知信息',
      ),
    );
  }</pre>

</td-code-block>

成功通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSuccessMessage(BuildContext context) {
    return _fullWidthButton(
      text: '成功通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条成功的提示消息',
        variant: TMessageVariant.success,
      ),
    );
  }</pre>

</td-code-block>

警示通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildWarningMessage(BuildContext context) {
    return _fullWidthButton(
      text: '警示通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条需要用户关注到的警示通知',
        variant: TMessageVariant.warning,
      ),
    );
  }</pre>

</td-code-block>

错误通知

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildErrorMessage(BuildContext context) {
    return _fullWidthButton(
      text: '错误通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条错误提示通知',
        variant: TMessageVariant.error,
      ),
    );
  }</pre>

</td-code-block>

## API
### TMessage

#### 静态方法

##### TMessage.show

在 Overlay 中显示消息并返回控制句柄。未显式传入 `offset` 时，新消息会替换同一 Overlay 中上一条默认位置的消息；显式传入不同 `offset` 的消息可以同时展示。

返回类型：`TMessageHandle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| content | String | '' | 通知内容 |
| duration | Duration? | const Duration(seconds: 3) | 自动关闭时长；必须为正数，null 表示不自动关闭 |
| showIcon | bool | true | 是否显示前置图标 |
| icon | Widget? | - | 自定义前置图标 |
| action | Widget? | - | 消息尾部操作组件，外观与行为由组件自身负责 |
| showCloseButton | bool | false | 是否显示关闭按钮 |
| closeButton | Widget? | - | 自定义关闭按钮 |
| marquee | TMessageMarquee? | - | 跑马灯配置 |
| offset | Offset? | - | 期望的屏幕绝对坐标。 `useSafeArea` 为 true 时，最终消息矩形会被约束在安全可视区域内。 |
| variant | TMessageVariant | TMessageVariant.info | 消息语义色 |
| onCloseButtonPressed | VoidCallback? | - | 点击关闭按钮时触发 |
| onDurationEnd | VoidCallback? | - | 自动展示时长结束且关闭动画完成时触发 |
| onDismissed | VoidCallback? | - | 关闭动画完成时触发 |
| useSafeArea | bool | true | 是否避让系统安全区，默认为 true。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| closeButton | Widget? | - | 自定义关闭按钮 |
| content | String | '' | 通知内容 |
| duration | Duration? | const Duration(seconds: 3) | 自动关闭时长；必须为正数，null 表示不自动关闭 |
| icon | Widget? | - | 自定义前置图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| action | Widget? | - | 消息尾部操作组件，外观与行为由组件自身负责 |
| marquee | TMessageMarquee? | - | 跑马灯配置 |
| offset | Offset? | - | 期望的屏幕绝对坐标。 `useSafeArea` 为 true 时，最终消息矩形会被约束在安全可视区域内。 |
| onCloseButtonPressed | VoidCallback? | - | 点击关闭按钮时触发 |
| onDismissed | VoidCallback? | - | 关闭动画完成时触发 |
| onDurationEnd | VoidCallback? | - | 自动展示时长结束且关闭动画完成时触发 |
| showCloseButton | bool | false | 是否显示关闭按钮 |
| showIcon | bool | true | 是否显示前置图标 |
| useSafeArea | bool | true | 是否避让系统安全区，默认为 true。 |
| variant | TMessageVariant | TMessageVariant.info | 消息语义色 |
| visible | bool | false | 是否显示，默认为 false |

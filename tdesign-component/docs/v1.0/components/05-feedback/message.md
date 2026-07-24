# TMessage

命令式消息组件，使用 `TMessage.show` 创建消息并返回 `TMessageHandle`。

## API

```dart
final handle = TMessage.show(
  context: context,
  content: '操作成功',
  variant: TMessageVariant.success,
  duration: const Duration(seconds: 3),
);
handle.dismiss();
```

`TMessage` 支持 `content`、`duration`、`variant`、`showIcon`、`icon`、`link`、
`showCloseButton`、`closeButton`、`marquee` 和 `offset`。关闭和自动关闭分别通过
`onDismissed`、`onDurationEnd` 通知。

## Theme

`TMessageThemeData` 只保存背景色、形状、阴影和默认偏移等视觉默认值，可通过
`Theme.of(context).mergeExtension(...)` 注入子树。

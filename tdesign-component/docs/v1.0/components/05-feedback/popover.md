# TPopover

命令式气泡弹层，调用 `TPopover.showPopover` 展示内容。

```dart
TPopover.showPopover(
  context: context,
  content: '提示内容',
  placement: TPopoverPlacement.bottom,
);
```

## API

内容可使用 `content` 或固定尺寸的 `contentWidget`。`placement`、`colorScheme`、
`showArrow`、`arrowSize`、`padding`、`width`、`height`、`radius` 和回调均为调用参数。
`onTap` 和 `onLongTap` 使用强类型回调：`void Function(String? content)`。

## Theme

`TPopoverThemeData` 仅提供视觉默认值：语义色、背景色、内边距、尺寸约束、圆角、
蒙层颜色、箭头和偏移。调用参数优先于 ThemeExtension，可通过
`Theme.of(context).mergeExtension(...)` 注入子树。

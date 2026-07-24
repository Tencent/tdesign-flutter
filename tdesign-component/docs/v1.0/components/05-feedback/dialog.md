# TDialog

Dialog 组件使用 Flutter 的 `showDialog` 生命周期，内容和按钮由实例参数控制。

## API

`TConfirmDialog` 提供标题、内容、按钮、关闭按钮和 `onPressed`。多按钮场景使用
`TDialogButtonOptions`，按钮回调类型为 `VoidCallback?`。

```dart
showDialog<void>(
  context: context,
  builder: (_) => TConfirmDialog(
    title: '确认操作',
    content: '是否继续？',
    onPressed: () {},
  ),
);
```

## Theme

`TDialogThemeData` 只提供背景、形状、阴影、蒙层、文字样式、内容布局和按钮样式默认值。
实例字段优先于 ThemeExtension。

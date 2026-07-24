# TToast

Toast 是命令式反馈组件，通过静态方法展示，并返回 Toast id 供关闭使用。

```dart
final id = TToast.showText('保存成功', context: context);
TToast.dismissToast(id);
```

常用入口包括 `showText`、`showIconText`、`showSuccess`、`showWarning`、`showFail`、
`showLoading` 和 `showLoadingWithoutText`。关闭使用 `dismissToast` 或 `dismissAll`，
加载 Toast 使用返回的 Toast id 关闭。

`TToastThemeData` 仅控制背景、文字、图标、圆角、内边距和最大宽度等视觉默认值。

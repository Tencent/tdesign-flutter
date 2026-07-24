# TPopup

Popup 是反馈、选择器和业务浮层共用的命令式基础设施。

```dart
final handle = TPopup.show(
  context,
  options: TPopupOptions.bottom(
    titleWidget: const Text('标题'),
    child: const SizedBox(height: 120),
  ),
);
handle.close();
```

`TPopupOptions` 支持 bottom、top、left、right 和 center 五种布局。内容、尺寸、动画、
蒙层和生命周期回调由 Options 控制，`TPopupHandle` 负责打开、关闭和查询展示状态。

## Theme

`TPopupThemeData` 只提供蒙层、动画时长、面板圆角和背景色默认值。显式 Options 字段
优先于 ThemeExtension，可通过 `Theme.of(context).mergeExtension(...)` 注入子树。

# TActionSheet

命令式动作面板，调用静态入口并自行持有返回的 `TPopupHandle`。

```dart
TActionSheet.showList(
  context,
  items: [
    TActionSheetItem(label: '编辑'),
    TActionSheetItem(label: '删除', disabled: true),
  ],
  onChanged: (item, index) {},
);
```

可用入口为 `showList`、`showGrid`、`showGroup`。`TActionSheetThemeData` 只提供
对齐、尺寸、蒙层和面板圆角等视觉布局默认值；内容、选择和关闭回调均由调用参数控制。

# TSwipeCell

滑动单元格由 `TSwipeCell`、`TSwipeCellPanel` 和 `TSwipeCellAction` 组成。

```dart
TSwipeCell(
  cell: const TCell(title: Text('内容')),
  right: TSwipeCellPanel(
    children: [TSwipeCellAction(label: '删除')],
  ),
)
```

展开状态、分组、关闭策略、拖动行为和 controller 都是实例参数。`TSwipeCellThemeData`
仅提供滑动动画时长默认值；外部传入的 `SlidableController` 由调用方负责生命周期。

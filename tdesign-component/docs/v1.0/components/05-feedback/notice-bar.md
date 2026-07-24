# TNoticeBar

公告栏组件支持静态文本、水平滚动和垂直轮播。

```dart
TNoticeBar(
  content: '这是一条公告',
  marquee: true,
  onPressed: (target) {},
)
```

多条垂直内容使用 `items: List<String>`。滚动行为由实例参数 `marquee`、`speed`、
`interval` 和 `direction` 控制；`TNoticeBarThemeData` 只提供变体、图标、颜色、文字、
内边距和高度等视觉默认值。

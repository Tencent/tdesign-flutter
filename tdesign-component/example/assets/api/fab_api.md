## API
### TFab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| bottom | double? | - | 距屏幕底部偏移（默认 32） |
| child | Widget? | - | 自定义内容；有则替代默认内嵌 TButton |
| draggable | TFabDragAxis? | - | 拖拽轴向；null 表示不启用拖拽，`TFabDragAxis.all` 表示全向拖拽 |
| icon | Widget? | - | 图标；未传时默认 `Icons.add` |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| magnet | TFabMagnet? | - | 拖拽结束吸附方向；null 表示不吸附 |
| onDragEnd | TFabDragCallback? | - | 拖拽结束回调 |
| onDragStart | TFabDragCallback? | - | 拖拽开始回调 |
| onLongPress | VoidCallback? | - | 长按回调；仅在 `onPressed` 非空时生效 |
| onPressed | VoidCallback? | - | 点击回调，null 时禁用 |
| right | double? | - | 距屏幕右侧偏移（默认 16） |
| semanticLabel | String? | - | 读屏标签 |
| text | String | '' | 图标 + 文字形态；非空时内嵌 TButton 为 round 形状 |
| tooltip | String? | - | 纯图标 Fab 的 tooltip 提示 |
| useSafeArea | bool | true | 是否避让系统安全区。 默认为 true。固定定位的 `right`、`bottom` 从安全边界起算； 拖拽与吸附范围同时避让四侧安全区。 |
| xBounds | TFabBounds? | - | 水平拖拽边界限制 |
| yBounds | TFabBounds? | - | 垂直拖拽边界限制 |

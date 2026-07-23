## API
### TFab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| bottom | double? | - | 距屏幕底部偏移（默认 32） |
| buttonProps | TButtonProps? | - | 内嵌 TButton 的部分配置透传 |
| child | Widget? | - | 自定义内容；有则替代默认内嵌 TButton，忽略 `buttonProps` |
| draggable | TFabDragAxis? | - | 拖拽轴向；null 表示不启用拖拽，`TFabDragAxis.all` 表示全向拖拽 |
| icon | Widget? | - | 图标；未传时默认 `Icons.add` |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| magnet | TFabMagnet? | - | 拖拽结束吸附方向；null 表示不吸附 |
| onDragEnd | TFabDragCallback? | - | 拖拽结束回调 |
| onDragStart | TFabDragCallback? | - | 拖拽开始回调 |
| onPressed | VoidCallback? | - | 点击回调，null 时禁用 |
| right | double? | - | 距屏幕右侧偏移（默认 16） |
| semanticLabel | String? | - | 读屏标签 |
| text | String | '' | 图标 + 文字形态；非空时内嵌 TButton 为 round 形状 |
| tooltip | String? | - | 纯图标 Fab 的 tooltip 提示 |
| xBounds | TFabBounds? | - | 水平拖拽边界限制 |
| yBounds | TFabBounds? | - | 垂直拖拽边界限制 |


### TFabThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaultBottom | double? | - | 默认距屏幕底部偏移（逻辑像素） |
| defaultRight | double? | - | 默认距屏幕右侧偏移（逻辑像素） |
| defaultXBounds | TFabBounds? | - | 默认水平拖拽边界限制 |
| defaultYBounds | TFabBounds? | - | 默认垂直拖拽边界限制 |
| dragTapSlop | double? | - | 点击 vs 拖拽判定阈值（位移逻辑像素） |
| magnetAnimationDuration | Duration? | - | 吸附动画时长 |


### TButtonProps
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| colorScheme | TButtonColorScheme? | - | 按钮配色方案 |
| shape | TButtonShape? | - | 按钮形状 |
| size | TButtonSize? | - | 按钮尺寸 |
| style | ButtonStyle? | - | P0 按钮样式覆盖 |
| variant | TButtonVariant? | - | 按钮变体 |


### TFabBounds
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| end | double | - | 终点留白（水平：right，垂直：bottom） |
| start | double | - | 起点留白（水平：left，垂直：top） |


### TFabDragDetails
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| end | DragEndDetails? | - | 拖拽结束详情 |
| position | Offset | - | 当前位置（相对父 Stack 内容区） |
| start | DragStartDetails? | - | 拖拽开始详情 |


### TFabDragAxis
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| all | 允许水平和垂直方向拖拽 |
| vertical | 仅允许垂直方向拖拽 |
| horizontal | 仅允许水平方向拖拽 |


### TFabMagnet
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 拖拽结束后吸附到左侧边界 |
| right | 拖拽结束后吸附到右侧边界 |


### TFabDragCallback
#### 类型定义

```dart
typedef TFabDragCallback = void Function(TFabDragDetails details);
```

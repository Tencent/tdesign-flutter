## API

### TFab

悬浮操作按钮组件

T2 组合模式：定位层（右下角悬浮 + 可选拖拽/吸附/边界）+ 动作层（默认内嵌 TButton）
默认动作层使用 large / fill / primary 规格；纯图标为圆形，图文为胶囊形。
默认动作层不继承父级 `TButtonThemeData`；完整视觉定制请使用 `child`。
`TFab` 返回 `Positioned`，应作为 `Stack` 的直接子组件使用。

#### 构造方法

##### TFab

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| bottom | double? | - | 距父级 Stack 内容区底部偏移（默认 32） | 否 |
| child | Widget? | - | 自定义内容；有则替代默认内嵌 TButton。 自定义内容自行负责尺寸、形状、颜色和投影；`TFab` 继续负责定位、拖拽、 点击和禁用语义。 | 否 |
| draggable | TFabDragAxis? | - | 拖拽轴向；null 表示不启用拖拽，`TFabDragAxis.all` 表示全向拖拽 | 否 |
| icon | Widget? | - | 图标；未传时使用 TDesign add 图标。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| magnet | TFabMagnet? | - | 拖拽结束吸附方向；null 表示不吸附 | 否 |
| onDragEnd | TFabDragCallback? | - | 拖拽结束回调 | 否 |
| onDragStart | TFabDragCallback? | - | 拖拽开始回调 | 否 |
| onPressed | VoidCallback? | - | 点击回调，null 时禁用 | 否 |
| right | double? | - | 距父级 Stack 内容区右侧偏移（默认 16） | 否 |
| semanticLabel | String? | - | 读屏标签 | 否 |
| text | String | '' | 图标 + 文字形态；非空时内嵌 TButton 为 round 形状 | 否 |
| tooltip | String? | - | 纯图标 Fab 的 tooltip 提示 | 否 |
| useSafeArea | bool | true | 是否避让系统安全区。 默认为 true。固定定位的 `right`、`bottom` 从安全边界起算； 拖拽与吸附范围同时避让四侧安全区。 | 否 |
| xBounds | TFabBounds? | - | 水平拖拽边界限制 | 否 |
| yBounds | TFabBounds? | - | 垂直拖拽边界限制 | 否 |


### TFabBounds

拖拽边界限制

`start` 和 `end` 必须是非负有限值。

#### 构造方法

##### TFabBounds

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| end | double | - | 终点留白（水平：right，垂直：bottom）。 | 是 |
| start | double | - | 起点留白（水平：left，垂直：top）。 | 是 |


### TFabDragDetails

拖拽回调详情

#### 构造方法

##### TFabDragDetails

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| end | DragEndDetails? | - | 拖拽结束详情 | 否 |
| position | Offset | - | 当前定位偏移，`dx` 为 right，`dy` 为 bottom。 | 是 |
| start | DragStartDetails? | - | 拖拽开始详情 | 否 |


### TFabThemeData

Fab 定位层 ThemeExtension

仅管理 Fab 定位层的默认值（偏移、边界、拖拽阈值等）。
默认动作层固定使用 large / fill / primary；需要完整自定义动作层时使用
`TFab.child`。

#### 构造方法

##### TFabThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| defaultBottom | double? | - | 距父级 Stack 底部的默认偏移；未设置时为 32 逻辑像素。 | 否 |
| defaultRight | double? | - | 距父级 Stack 右侧的默认偏移；未设置时为 16 逻辑像素。 | 否 |
| defaultXBounds | TFabBounds? | - | 默认水平拖拽边界；未设置时左右各保留 16 逻辑像素。 | 否 |
| defaultYBounds | TFabBounds? | - | 默认垂直拖拽边界；未设置时上下边界均为 0。 | 否 |
| dragTapSlop | double? | - | 点击与拖拽的判定阈值；未设置时为 18 逻辑像素。 按手势起点到当前位置的屏幕全方向最大位移判定，与 `TFabDragAxis` 限制的 位置更新轴向无关。 | 否 |
| magnetAnimationDuration | Duration? | - | 吸附动画时长；未设置时为 200 毫秒。 | 否 |


#### 实例方法

##### TFabThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| defaultRight | double? | - | 字段含义：距父级 Stack 右侧的默认偏移；未设置时为 16 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| defaultBottom | double? | - | 字段含义：距父级 Stack 底部的默认偏移；未设置时为 32 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| defaultXBounds | TFabBounds? | - | 字段含义：默认水平拖拽边界；未设置时左右各保留 16 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| defaultYBounds | TFabBounds? | - | 字段含义：默认垂直拖拽边界；未设置时上下边界均为 0。 调用时的空值行为见方法说明。 | 否 |
| magnetAnimationDuration | Duration? | - | 字段含义：吸附动画时长；未设置时为 200 毫秒。 调用时的空值行为见方法说明。 | 否 |
| dragTapSlop | double? | - | 字段含义：点击与拖拽的判定阈值；未设置时为 18 逻辑像素。 按手势起点到当前位置的屏幕全方向最大位移判定，与 `TFabDragAxis` 限制的 位置更新轴向无关。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TFabThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TFabThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TFabThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TFabThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


### TFabDragAxis

拖拽轴向
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| all | TFabDragAxis | - | 允许水平和垂直方向拖拽 | - |
| vertical | TFabDragAxis | - | 仅允许垂直方向拖拽 | - |
| horizontal | TFabDragAxis | - | 仅允许水平方向拖拽 | - |


### TFabMagnet

吸附方向
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| left | TFabMagnet | - | 拖拽结束后吸附到左侧边界 | - |
| right | TFabMagnet | - | 拖拽结束后吸附到右侧边界 | - |


### TFabDragCallback

拖拽回调

位置参数：`details`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| details | TFabDragDetails | - | 当前 right/bottom 定位偏移及对应手势详情。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | void | - | 无返回值。 | - |

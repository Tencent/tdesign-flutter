## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TAvatar
#### 简介
头像。
`image` 负责图片内容，`child` 负责文字、图标等自定义内容。两者同时提供时，
`child` 会作为图片加载失败前的背景内容。默认图标与文字前景色由
`TAvatarThemeData.foregroundColor` 控制；特殊文字排版可在 `child` 中使用
`Text(style: ...)`，组件不再额外提供文字样式入口。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget? | - | 自定义头像内容。 | 否 |
| fit | BoxFit | BoxFit.cover | 图片填充方式。 | 否 |
| image | ImageProvider&lt;Object&gt;? | - | 头像图片。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onTap | GestureTapCallback? | - | 点击回调；为空时头像不创建点击行为。 | 否 |
| shape | TAvatarShape? | - | 头像形状；未设置时使用圆形默认值。 | 否 |
| size | TAvatarSize? | - | 头像尺寸；未设置时继承所在头像组的尺寸，独立使用时默认为中号。 | 否 |


### TAvatarGroup
#### 简介
叠放头像组。
头像组只负责布局，不解析图片来源或缓存成员状态。
当成员是 `TAvatar` 时，其 `TAvatar.shape` 同时决定成员外框与裁剪形状；
其他 Widget 使用圆形默认值。
组尺寸由首个可见且显式设置 `TAvatar.size` 的成员确定，未设置时为中号；
成员自己的显式尺寸始终优先，未设置的成员和折叠头像继承组尺寸。
默认按 8 逻辑像素重叠，所有成员使用按尺寸区分的描边与阴影；
可通过 `TAvatarThemeData` 调整这些视觉值。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| cascading | TAvatarGroupCascading | TAvatarGroupCascading.endUp | 头像组成员的层叠方向，使用 start/end 语义并跟随文字方向。 | 否 |
| children | List&lt;Widget&gt; | - | 头像列表。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxCount | int? | - | 最多显示的头像数量。 | 否 |
| overflow | Widget? | - | 发生截断时显示在末尾的内容。 | 否 |
| spacing | double? | - | 相邻头像的重叠宽度；有效范围为 0 到成员外框边长。 | 否 |


### TAvatarThemeData
#### 简介
头像组件级 ThemeExtension。
仅保存视觉默认值，不保存头像内容、回调或头像组成员。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认背景色；未设置时回退全局 `brandColorLightActive`。 | 否 |
| circleBorderRadius | double? | - | 圆形头像圆角；未设置时回退全局 `radiusCircle`（逻辑像素）。 | 否 |
| dimension | double? | - | 自定义头像边长。 | 否 |
| foregroundColor | Color? | - | 默认图标与继承文字的前景色；未设置时回退全局品牌色。 | 否 |
| groupBorderColor | Color? | - | 头像组成员描边颜色。 | 否 |
| groupBorderWidth | double? | - | 头像组成员描边宽度。 未设置时按成员尺寸使用小/中/大 1/2/3 逻辑像素。 | 否 |
| groupShadow | BoxShadow? | - | 头像组成员阴影；未设置时使用 1px 水平偏移、2px `blurRadius` 和 15% 黑色。 | 否 |
| groupSpacing | double? | - | 头像组重叠宽度。 | 否 |
| iconSize | double? | - | 默认图标大小。 | 否 |
| squareBorderRadius | double? | - | 方形头像圆角；未设置时回退全局 `radiusDefault`（默认 6 逻辑像素）。 | 否 |


### TAvatarSize
#### 简介
头像尺寸。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | 大尺寸。 |
| medium | 中尺寸。 |
| small | 小尺寸。 |


### TAvatarShape
#### 简介
头像形状。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形头像。 |
| square | 方形头像。 |


### TAvatarGroupCascading
#### 简介
头像组的层叠方向。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| startUp | 起始侧头像位于上层。 |
| endUp | 结束侧头像位于上层。 |

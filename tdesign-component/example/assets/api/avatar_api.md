## API

### TAvatar

#### 构造方法

##### TAvatar

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| child | Widget? | - | 自定义头像内容。 | 否 |
| fit | BoxFit | BoxFit.cover | 图片填充方式。 | 否 |
| image | ImageProvider&lt;Object&gt;? | - | 头像图片。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onTap | GestureTapCallback? | - | 点击回调；为空时头像不创建点击行为。 | 否 |
| shape | TAvatarShape? | - | 头像形状；未设置时使用圆形默认值。 | 否 |
| size | TAvatarSize? | - | 头像尺寸；未设置时继承所在头像组的尺寸，独立使用时默认为中号。 | 否 |


### TAvatarGroup

叠放头像组。

头像组只负责布局，不解析图片来源或缓存成员状态。
当成员是 `TAvatar` 时，其 `TAvatar.shape` 同时决定成员外框与裁剪形状；
其他 Widget 使用圆形默认值。
组尺寸由首个可见且显式设置 `TAvatar.size` 的成员确定，未设置时为中号；
成员自己的显式尺寸始终优先，未设置的成员和折叠头像继承组尺寸。
默认按 8 逻辑像素重叠，所有成员使用按尺寸区分的描边与阴影；
可通过 `TAvatarThemeData` 调整这些视觉值。

#### 构造方法

##### TAvatarGroup

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| cascading | TAvatarGroupCascading | TAvatarGroupCascading.endUp | 头像组成员的层叠方向，使用 start/end 语义并跟随文字方向。 | 否 |
| children | List&lt;Widget&gt; | - | 头像列表。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxCount | int? | - | 最多显示的原始头像数量；为空时显示全部，非空时必须大于 0。 若发生截断且提供了 `overflow`，会额外显示一个折叠头像。 | 否 |
| overflow | Widget? | - | 发生截断时显示在末尾的内容。 | 否 |
| spacing | double? | - | 相邻头像的重叠宽度；非空时必须是有限、非负值，布局时限制到成员边长。 为空时使用组件主题，最终回退为 8 逻辑像素。 | 否 |


### TAvatarSize

头像尺寸。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| large | TAvatarSize | - | 大尺寸。 | - |
| medium | TAvatarSize | - | 中尺寸。 | - |
| small | TAvatarSize | - | 小尺寸。 | - |


### TAvatarShape

头像形状。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| circle | TAvatarShape | - | 圆形头像。 | - |
| square | TAvatarShape | - | 方形头像。 | - |


### TAvatarGroupCascading

头像组的层叠方向。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| startUp | TAvatarGroupCascading | - | 起始侧头像位于上层。 | - |
| endUp | TAvatarGroupCascading | - | 结束侧头像位于上层。 | - |


### TAvatarThemeData

头像组件级 ThemeExtension。

仅保存视觉默认值，不保存头像内容、回调或头像组成员。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认背景色；未设置时回退全局 `brandColorLightActive`。 | 否 |
| circleBorderRadius | double? | - | 圆形头像圆角；未设置时回退全局 `radiusCircle`（逻辑像素）。 | 否 |
| dimension | double? | - | 自定义头像边长；未设置时小、中、大尺寸分别为 40、48、64 逻辑像素。 | 否 |
| foregroundColor | Color? | - | 默认图标与继承文字的前景色；未设置时回退全局品牌色。 | 否 |
| groupBorderColor | Color? | - | 头像组成员描边颜色；未设置时使用 `bgColorContainer` Token。 | 否 |
| groupBorderWidth | double? | - | 头像组成员描边宽度。 未设置时按成员尺寸使用小/中/大 1/2/3 逻辑像素。 | 否 |
| groupShadow | BoxShadow? | - | 头像组成员阴影；未设置时使用 1px 水平偏移、2px `blurRadius` 和 15% 黑色。 | 否 |
| groupSpacing | double? | - | 头像组重叠宽度；未设置时为 8 逻辑像素，实例 spacing 优先。 | 否 |
| iconSize | double? | - | 默认图标大小；未设置时小、中、大尺寸分别为 20、24、32 逻辑像素。 | 否 |
| squareBorderRadius | double? | - | 方形头像圆角；未设置时回退全局 `radiusDefault`（默认 6 逻辑像素）。 | 否 |

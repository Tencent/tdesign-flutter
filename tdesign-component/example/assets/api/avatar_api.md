## API
### TAvatar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 自定义头像内容。 |
| fit | BoxFit | BoxFit.cover | 图片填充方式。 |
| image | ImageProvider<Object>? | - | 头像图片。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onTap | GestureTapCallback? | - | 点击回调；为空时头像不创建点击行为。 |
| shape | TAvatarShape? | - | 头像形状；未设置时使用圆形默认值。 |
| size | TAvatarSize? | - | 头像尺寸；未设置时继承所在头像组的尺寸，独立使用时默认为中号。 |


### TAvatarGroup
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cascading | TAvatarGroupCascading | TAvatarGroupCascading.endUp | 头像组成员的层叠方向，使用 start/end 语义并跟随文字方向。 |
| children | List<Widget> | - | 头像列表。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxCount | int? | - | 最多显示的头像数量。 |
| overflow | Widget? | - | 发生截断时显示在末尾的内容。 |
| spacing | double? | - | 相邻头像的重叠宽度；有效范围为 0 到成员外框边长。 |


### TAvatarThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认背景色；未设置时回退全局 `brandColorLightActive`。 |
| circleBorderRadius | double? | - | 圆形头像圆角；未设置时回退全局 `radiusCircle`（逻辑像素）。 |
| dimension | double? | - | 自定义头像边长。 |
| foregroundColor | Color? | - | 默认图标与继承文字的前景色；未设置时回退全局品牌色。 |
| groupBorderColor | Color? | - | 头像组成员描边颜色。 |
| groupBorderWidth | double? | - | 头像组成员描边宽度。 未设置时按成员尺寸使用小/中/大 1/2/3 逻辑像素。 |
| groupShadow | BoxShadow? | - | 头像组成员阴影；未设置时使用 1px 水平偏移、2px `blurRadius` 和 15% 黑色。 |
| groupSpacing | double? | - | 头像组重叠宽度。 |
| iconSize | double? | - | 默认图标大小。 |
| squareBorderRadius | double? | - | 方形头像圆角；未设置时回退全局 `radiusDefault`（默认 6 逻辑像素）。 |

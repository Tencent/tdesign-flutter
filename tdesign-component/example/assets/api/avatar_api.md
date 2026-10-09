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

#### 构造方法

##### TAvatarGroup

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| cascading | TAvatarGroupCascading | TAvatarGroupCascading.endUp | 头像组成员的层叠方向，使用 start/end 语义并跟随文字方向。 | 否 |
| children | List&lt;Widget&gt; | - | 头像列表。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxCount | int? | - | 最多显示的头像数量。 | 否 |
| overflow | Widget? | - | 发生截断时显示在末尾的内容。 | 否 |
| spacing | double? | - | 相邻头像的重叠宽度；有效范围为 0 到成员外框边长。 | 否 |


### TAvatarThemeData

#### 构造方法

##### TAvatarThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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


#### 实例方法

##### TAvatarThemeData.copyWith

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| dimension | double? | - | 字段含义：自定义头像边长。 调用时的空值行为见方法说明。 | 否 |
| iconSize | double? | - | 字段含义：默认图标大小。 调用时的空值行为见方法说明。 | 否 |
| circleBorderRadius | double? | - | 字段含义：圆形头像圆角；未设置时回退全局 `radiusCircle`（逻辑像素）。 调用时的空值行为见方法说明。 | 否 |
| squareBorderRadius | double? | - | 字段含义：方形头像圆角；未设置时回退全局 `radiusDefault`（默认 6 逻辑像素）。 调用时的空值行为见方法说明。 | 否 |
| backgroundColor | Color? | - | 字段含义：默认背景色；未设置时回退全局 `brandColorLightActive`。 调用时的空值行为见方法说明。 | 否 |
| foregroundColor | Color? | - | 字段含义：默认图标与继承文字的前景色；未设置时回退全局品牌色。 调用时的空值行为见方法说明。 | 否 |
| groupSpacing | double? | - | 字段含义：头像组重叠宽度。 调用时的空值行为见方法说明。 | 否 |
| groupBorderWidth | double? | - | 字段含义：头像组成员描边宽度。 未设置时按成员尺寸使用小/中/大 1/2/3 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| groupBorderColor | Color? | - | 字段含义：头像组成员描边颜色。 调用时的空值行为见方法说明。 | 否 |
| groupShadow | BoxShadow? | - | 字段含义：头像组成员阴影；未设置时使用 1px 水平偏移、2px `blurRadius` 和 15% 黑色。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TAvatarThemeData | - | - | - |


##### TAvatarThemeData.lerp

位置参数：`other, t`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | TAvatarThemeData? | - | - | 是 |
| t | double | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TAvatarThemeData | - | - | - |

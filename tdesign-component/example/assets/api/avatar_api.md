## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TAvatar

#### 声明

```dart
class TAvatar extends StatelessWidget
```

#### 默认构造方法


```dart
const TAvatar({
  this.image,
  this.child,
  this.size,
  this.shape,
  this.fit = BoxFit.cover,
  this.onTap,
  super.key,
})
```

##### 参数

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

#### 声明

```dart
class TAvatarGroup extends StatelessWidget
```

#### 默认构造方法


```dart
const TAvatarGroup({
  required this.children,
  this.maxCount,
  this.overflow,
  this.spacing,
  this.cascading = TAvatarGroupCascading.endUp,
  super.key,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| cascading | TAvatarGroupCascading | TAvatarGroupCascading.endUp | 头像组成员的层叠方向，使用 start/end 语义并跟随文字方向。 | 否 |
| children | List&lt;Widget&gt; | - | 头像列表。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxCount | int? | - | 最多显示的头像数量。 | 否 |
| overflow | Widget? | - | 发生截断时显示在末尾的内容。 | 否 |
| spacing | double? | - | 相邻头像的重叠宽度；有效范围为 0 到成员外框边长。 | 否 |


### TAvatarThemeData

#### 声明

```dart
class TAvatarThemeData extends ThemeExtension<TAvatarThemeData>
```

#### 默认构造方法


```dart
const TAvatarThemeData({
  this.dimension,
  this.iconSize,
  this.circleBorderRadius,
  this.squareBorderRadius,
  this.backgroundColor,
  this.foregroundColor,
  this.groupSpacing,
  this.groupBorderWidth,
  this.groupBorderColor,
  this.groupShadow,
})
```

##### 参数

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


#### 实例方法

##### TAvatarThemeData.copyWith

```dart
TAvatarThemeData copyWith({
  double? dimension,
  double? iconSize,
  double? circleBorderRadius,
  double? squareBorderRadius,
  Color? backgroundColor,
  Color? foregroundColor,
  double? groupSpacing,
  double? groupBorderWidth,
  Color? groupBorderColor,
  BoxShadow? groupShadow,
})
```


返回类型：`TAvatarThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| dimension | double? | - | 自定义头像边长。 | 否 |
| iconSize | double? | - | 默认图标大小。 | 否 |
| circleBorderRadius | double? | - | 圆形头像圆角；未设置时回退全局 `radiusCircle`（逻辑像素）。 | 否 |
| squareBorderRadius | double? | - | 方形头像圆角；未设置时回退全局 `radiusDefault`（默认 6 逻辑像素）。 | 否 |
| backgroundColor | Color? | - | 默认背景色；未设置时回退全局 `brandColorLightActive`。 | 否 |
| foregroundColor | Color? | - | 默认图标与继承文字的前景色；未设置时回退全局品牌色。 | 否 |
| groupSpacing | double? | - | 头像组重叠宽度。 | 否 |
| groupBorderWidth | double? | - | 头像组成员描边宽度。 未设置时按成员尺寸使用小/中/大 1/2/3 逻辑像素。 | 否 |
| groupBorderColor | Color? | - | 头像组成员描边颜色。 | 否 |
| groupShadow | BoxShadow? | - | 头像组成员阴影；未设置时使用 1px 水平偏移、2px `blurRadius` 和 15% 黑色。 | 否 |


##### TAvatarThemeData.lerp

```dart
TAvatarThemeData lerp(TAvatarThemeData? other, double t)
```


返回类型：`TAvatarThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TAvatarThemeData? | - | - | 是 |
| t | double | - | - | 是 |

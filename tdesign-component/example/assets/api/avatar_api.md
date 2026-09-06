## API
### TAvatar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 头像背景色，优先于 Theme。 |
| child | Widget? | - | 自定义头像内容。 |
| fit | BoxFit | BoxFit.cover | 图片填充方式。 |
| foregroundColor | Color? | - | 默认图标及字符内容的前景色，优先于 Theme。 |
| image | ImageProvider<Object>? | - | 头像图片。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onTap | GestureTapCallback? | - | 点击回调；为空时头像不创建点击行为。 |
| shape | TAvatarShape? | - | 头像形状；未设置时依次读取 Theme 和圆形默认值。 |
| size | TAvatarSize? | - | 头像尺寸；未设置时依次读取 Theme 和中尺寸默认值。 |
| textStyle | TextStyle? | - | 字符内容样式，优先于 Theme，并继承对应尺寸的默认字号和字重。 |
| variant | TAvatarVariant? | - | 头像形状的旧命名。 |


### TAvatarGroup
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cascading | TAvatarGroupCascading | TAvatarGroupCascading.rightUp | 头像组成员的层叠方向。 |
| children | List<Widget> | - | 头像列表。 |
| dimension | double? | - | 头像组成员的外框边长；未设置时读取 Theme，默认 48。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxCount | int? | - | 最多显示的头像数量。 |
| overflow | Widget? | - | 发生截断时显示在末尾的内容。 |
| shape | TAvatarShape | TAvatarShape.circle | 头像组成员外框形状。 |
| spacing | double? | - | 相邻头像的重叠宽度。 |

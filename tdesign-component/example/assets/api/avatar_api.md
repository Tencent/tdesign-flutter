## API
### TAvatar
#### 简介
头像。
`image` 负责图片内容，`child` 负责文字、图标等自定义内容。两者同时提供时，
`child` 会作为图片加载失败前的背景内容。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 自定义头像内容。 |
| fit | BoxFit | BoxFit.cover | 图片填充方式。 |
| image | ImageProvider<Object>? | - | 头像图片。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onTap | GestureTapCallback? | - | 点击回调；为空时头像不创建点击行为。 |
| size | TAvatarSize? | - | 头像尺寸；未设置时依次读取 Theme 和中尺寸默认值。 |
| variant | TAvatarVariant? | - | 头像形状；未设置时依次读取 Theme 和圆形默认值。 |


### TAvatarGroup
#### 简介
叠放头像组。
头像组只负责布局，不解析图片来源或缓存成员状态。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<Widget> | - | 头像列表。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxCount | int? | - | 最多显示的头像数量。 |
| overflow | Widget? | - | 发生截断时显示在末尾的内容。 |
| spacing | double? | - | 相邻头像的重叠宽度。 |


### TAvatarThemeData
#### 简介
头像组件级 ThemeExtension。
仅保存视觉默认值，不保存头像内容、回调或头像组成员。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认背景色。 |
| dimension | double? | - | 自定义头像边长。 |
| foregroundColor | Color? | - | 默认前景色。 |
| groupBorderColor | Color? | - | 头像组成员描边颜色。 |
| groupBorderWidth | double? | - | 头像组成员描边宽度。 |
| groupSpacing | double? | - | 头像组重叠宽度。 |
| iconSize | double? | - | 默认图标大小。 |
| size | TAvatarSize? | - | 默认头像尺寸档位。 |
| squareBorderRadius | double? | - | 方形头像圆角。 |
| variant | TAvatarVariant? | - | 默认头像形状。 |


### TAvatarSize
#### 简介
头像尺寸。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | 大尺寸。 |
| medium | 中尺寸。 |
| small | 小尺寸。 |


### TAvatarVariant
#### 简介
头像形状。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形头像。 |
| square | 方形头像。 |

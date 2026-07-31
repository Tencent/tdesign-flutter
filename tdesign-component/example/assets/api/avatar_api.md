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
| size | TAvatarSize? | - | 头像尺寸；未设置时依次读取 Theme 和中尺寸默认值。 |
| variant | TAvatarVariant? | - | 头像形状；未设置时依次读取 Theme 和圆形默认值。 |

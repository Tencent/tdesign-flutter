## API
### TImageViewer

#### 静态方法

##### TImageViewer.show

显示全屏图片预览。
调用方需要主动关闭时，可通过持有的 `NavigatorState` 调用
`NavigatorState.pop`；返回的 Future 会在路由关闭后完成一次。

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于展示预览弹窗。 |
| images | List<ImageProvider<Object>> | - | 是待预览的图片列表，不能为空。 |
| labels | List<String>? | - | 是与图片一一对应的标签文案。 |
| initialIndex | int | 0 | 设置初始展示的图片索引。 |
| showClose | bool | true | 控制关闭按钮是否显示。 |
| showDelete | bool | false | 控制删除按钮是否显示。 |
| showIndex | bool | true | 控制当前页码是否显示。 |
| loop | bool | false | 控制是否循环切换图片。 |
| autoplay | bool | false | 控制是否自动切换图片；图片放大时暂停，还原后恢复。 |
| autoplayInterval | Duration | const Duration(seconds: 3) | 设置自动切换图片的时间间隔。 |
| onIndexChanged | ValueChanged<int>? | - | 在当前图片索引变化时触发。 |
| onDelete | ValueChanged<int>? | - | 在点击删除按钮时触发，仅通知当前索引。 |
| onTap | ValueChanged<int>? | - | 在点击当前全屏预览区、关闭预览前触发。 |
| onLongPress | ValueChanged<int>? | - | 在长按当前图片时触发。 |
| leadingBuilder | TImageViewerItemBuilder? | - | 构建导航栏起始区域。 |
| trailingBuilder | TImageViewerItemBuilder? | - | 构建导航栏末尾区域。 |


### TImageViewerItemBuilder
#### 类型定义

```dart
typedef TImageViewerItemBuilder = Widget Function(BuildContext context, int index);
```

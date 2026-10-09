## API

### TImageViewer

#### 静态方法

##### TImageViewer.show

显示全屏图片预览。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于展示预览弹窗。 调用方需要主动关闭时，可通过持有的 `NavigatorState` 调用 `NavigatorState.pop`；返回的 Future 会在路由关闭后完成一次。 | 是 |
| images | List&lt;ImageProvider&lt;Object&gt;&gt; | - | 是待预览的图片列表，不能为空。 | 是 |
| labels | List&lt;String&gt;? | - | 是与图片一一对应的标签文案。 | 否 |
| initialIndex | int | 0 | 设置初始展示的图片索引。 | 否 |
| showClose | bool | true | 控制关闭按钮是否显示。 | 否 |
| showDelete | bool | false | 控制删除按钮是否显示。 | 否 |
| showIndex | bool | true | 控制当前页码是否显示。 | 否 |
| loop | bool | false | 控制是否循环切换图片。 | 否 |
| autoplay | bool | false | 控制是否自动切换图片；图片放大时暂停，还原后恢复。 | 否 |
| autoplayInterval | Duration | const Duration(seconds: 3) | 设置自动切换图片的时间间隔。 | 否 |
| onIndexChanged | ValueChanged&lt;int&gt;? | - | 在当前图片索引变化时触发。 | 否 |
| onDelete | ValueChanged&lt;int&gt;? | - | 在点击删除按钮时触发，仅通知当前索引。 | 否 |
| onTap | ValueChanged&lt;int&gt;? | - | 在点击当前全屏预览区、关闭预览前触发。 | 否 |
| onLongPress | ValueChanged&lt;int&gt;? | - | 在长按当前图片时触发。 | 否 |
| leadingBuilder | TImageViewerItemBuilder? | - | 构建导航栏起始区域。 | 否 |
| trailingBuilder | TImageViewerItemBuilder? | - | 构建导航栏末尾区域。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;void&gt; | - | - | - |


### TImageViewerItemBuilder

位置参数：`context, index`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| index | int | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | - | - |

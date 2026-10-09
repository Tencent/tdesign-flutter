## API

### TImageViewer

命令式图片预览工具。

#### 主题配置

组件主题通过 `TImageViewerThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TImageViewerThemeData` 说明。

#### 静态方法

##### TImageViewer.show

显示全屏图片预览。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于展示预览弹窗。 调用方需要主动关闭时，可通过持有的 `NavigatorState` 调用 `NavigatorState.pop`；返回的 Future 会在路由关闭后完成一次。 | 是 |
| images | List&lt;ImageProvider&lt;Object&gt;&gt; | - | 是待预览的图片列表，不能为空。 | 是 |
| labels | List&lt;String&gt;? | - | 是与图片一一对应的标签文案；非空时长度必须等于 images，否则抛出 ArgumentError。 | 否 |
| initialIndex | int | 0 | 设置初始展示的图片索引，必须在 0 到 images.length - 1 之间；否则抛出 RangeError。 | 否 |
| showClose | bool | true | 控制关闭按钮是否显示。 | 否 |
| showDelete | bool | false | 控制删除按钮是否显示。 | 否 |
| showIndex | bool | true | 控制当前页码是否显示。 | 否 |
| loop | bool | false | 控制是否循环切换图片。 | 否 |
| autoplay | bool | false | 控制是否自动切换图片；图片放大时暂停，还原后恢复。 | 否 |
| autoplayInterval | Duration | const Duration(seconds: 3) | 设置自动切换图片的时间间隔，必须大于 Duration.zero；否则抛出 ArgumentError。 | 否 |
| onIndexChanged | ValueChanged&lt;int&gt;? | - | 在当前图片索引变化时触发。 | 否 |
| onDelete | ValueChanged&lt;int&gt;? | - | 在点击删除按钮时触发，仅通知当前索引。 | 否 |
| onTap | ValueChanged&lt;int&gt;? | - | 在点击当前全屏预览区、关闭预览前触发。 | 否 |
| onLongPress | ValueChanged&lt;int&gt;? | - | 在长按当前图片时触发。 | 否 |
| leadingBuilder | TImageViewerItemBuilder? | - | 构建导航栏起始区域。 | 否 |
| trailingBuilder | TImageViewerItemBuilder? | - | 构建导航栏末尾区域。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;void&gt; | - | 预览路由被弹出时完成，不等待关闭动画结束；参数不合法时在展示前同步抛出异常。 | - |


### TImageViewerThemeData

图片预览组件级 ThemeExtension

#### 构造方法

##### TImageViewerThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| appBarBackgroundColor | Color? | - | 导航栏背景色 null 时使用不透明 fontGray1 Token。 | 否 |
| backgroundColor | Color? | - | 预览页背景色 null 时由 fontGray1 与 bgColorContainer 叠加得到默认背景色。 | 否 |
| iconColor | Color? | - | 图标颜色 null 时使用 textColorAnti Token。 | 否 |
| indexStyle | TextStyle? | - | 页码文字样式 null 时使用 textColorAnti 和 fontBodyMedium 字号，字号最终回退 14。 | 否 |
| labelStyle | TextStyle? | - | 标签文字样式 null 时使用 textColorAnti 作为标签文字颜色。 | 否 |
| viewerHeight | double? | - | 预览区默认高度 | 否 |
| viewerWidth | double? | - | 预览区默认宽度 | 否 |


#### 实例方法

##### TImageViewerThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 字段含义：预览页背景色 null 时由 fontGray1 与 bgColorContainer 叠加得到默认背景色。 调用时的空值行为见方法说明。 | 否 |
| appBarBackgroundColor | Color? | - | 字段含义：导航栏背景色 null 时使用不透明 fontGray1 Token。 调用时的空值行为见方法说明。 | 否 |
| iconColor | Color? | - | 字段含义：图标颜色 null 时使用 textColorAnti Token。 调用时的空值行为见方法说明。 | 否 |
| labelStyle | TextStyle? | - | 字段含义：标签文字样式 null 时使用 textColorAnti 作为标签文字颜色。 调用时的空值行为见方法说明。 | 否 |
| indexStyle | TextStyle? | - | 字段含义：页码文字样式 null 时使用 textColorAnti 和 fontBodyMedium 字号，字号最终回退 14。 调用时的空值行为见方法说明。 | 否 |
| viewerWidth | double? | - | 字段含义：预览区默认宽度 调用时的空值行为见方法说明。 | 否 |
| viewerHeight | double? | - | 字段含义：预览区默认高度 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TImageViewerThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TImageViewerThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TImageViewerThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TImageViewerThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


### TImageViewerItemBuilder

图片预览导航栏槽位构建器。

位置参数：`context, index`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 图片预览导航栏的构建上下文。 | 是 |
| index | int | - | 当前图片索引，从 0 开始。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | 导航栏对应槽位的内容。 | - |

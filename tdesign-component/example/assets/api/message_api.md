## API
### TMessage
#### 简介
顶部消息组件

#### 静态方法

##### TMessage.show

在 Overlay 中显示消息并返回控制句柄

返回类型：`TMessageHandle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 |
| content | String | '' | 通知内容 |
| duration | Duration? | const Duration(seconds: 3) | 自动关闭时长，null 表示不自动关闭 |
| showIcon | bool | true | 是否显示前置图标 |
| icon | Widget? | - | 自定义前置图标 |
| link | TMessageLink? | - | 链接配置 |
| showCloseButton | bool | false | 是否显示关闭按钮 |
| closeButton | Widget? | - | 自定义关闭按钮 |
| marquee | TMessageMarquee? | - | 跑马灯配置 |
| offset | Offset? | - | 相对屏幕左上角的偏移 |
| variant | TMessageVariant | TMessageVariant.info | 消息语义色 |
| onCloseButtonPressed | VoidCallback? | - | 点击关闭按钮时触发 |
| onDurationEnd | VoidCallback? | - | 自动展示时长结束且关闭动画完成时触发 |
| onLinkPressed | VoidCallback? | - | 点击链接时触发 |
| onDismissed | VoidCallback? | - | 关闭动画完成时触发 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| closeButton | Widget? | - | 自定义关闭按钮 |
| content | String | '' | 通知内容 |
| duration | Duration? | const Duration(seconds: 3) | 自动关闭时长，null 表示不自动关闭 |
| icon | Widget? | - | 自定义前置图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| link | TMessageLink? | - | 链接配置 |
| marquee | TMessageMarquee? | - | 跑马灯配置 |
| offset | Offset? | - | 相对屏幕左上角的偏移 |
| onCloseButtonPressed | VoidCallback? | - | 点击关闭按钮时触发 |
| onDismissed | VoidCallback? | - | 关闭动画完成时触发 |
| onDurationEnd | VoidCallback? | - | 自动展示时长结束且关闭动画完成时触发 |
| onLinkPressed | VoidCallback? | - | 点击链接时触发 |
| showCloseButton | bool | false | 是否显示关闭按钮 |
| showIcon | bool | true | 是否显示前置图标 |
| variant | TMessageVariant | TMessageVariant.info | 消息语义色 |
| visible | bool | true | 是否显示 |


### TMessageHandle
#### 简介
命令式消息句柄

### TMessageLink
#### 简介
消息中的链接配置
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| color | Color? | - | 链接颜色 |
| name | String | - | 链接文案 |
| uri | Uri? | - | 链接地址 |


### TMessageMarquee
#### 简介
跑马灯配置
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| delay | Duration | Duration.zero | 开始滚动前的延迟 |
| duration | Duration | const Duration(seconds: 10) | 单次滚动时长 |
| repeat | bool | false | 是否循环滚动 |

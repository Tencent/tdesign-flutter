## API
### TMessage

#### 静态方法

##### TMessage.show

在 Overlay 中显示消息并返回控制句柄

返回类型：`TMessageHandle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| content | String | '' | 通知内容 |
| duration | Duration? | const Duration(seconds: 3) | 自动关闭时长，null 表示不自动关闭 |
| showIcon | bool | true | 是否显示前置图标 |
| icon | Widget? | - | 自定义前置图标 |
| link | TMessageLink? | - | 链接配置 |
| showCloseButton | bool | false | 是否显示关闭按钮 |
| closeButton | Widget? | - | 自定义关闭按钮 |
| marquee | TMessageMarquee? | - | 跑马灯配置 |
| offset | Offset? | - | 期望的屏幕绝对坐标。 `useSafeArea` 为 true 时，最终消息矩形会被约束在安全可视区域内。 |
| variant | TMessageVariant | TMessageVariant.info | 消息语义色 |
| onCloseButtonPressed | VoidCallback? | - | 点击关闭按钮时触发 |
| onDurationEnd | VoidCallback? | - | 自动展示时长结束且关闭动画完成时触发 |
| onLinkPressed | VoidCallback? | - | 点击链接时触发 |
| onDismissed | VoidCallback? | - | 关闭动画完成时触发 |
| useSafeArea | bool | true | 是否避让系统安全区，默认为 true。 |

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
| offset | Offset? | - | 期望的屏幕绝对坐标。 `useSafeArea` 为 true 时，最终消息矩形会被约束在安全可视区域内。 |
| onCloseButtonPressed | VoidCallback? | - | 点击关闭按钮时触发 |
| onDismissed | VoidCallback? | - | 关闭动画完成时触发 |
| onDurationEnd | VoidCallback? | - | 自动展示时长结束且关闭动画完成时触发 |
| onLinkPressed | VoidCallback? | - | 点击链接时触发 |
| showCloseButton | bool | false | 是否显示关闭按钮 |
| showIcon | bool | true | 是否显示前置图标 |
| useSafeArea | bool | true | 是否避让系统安全区，默认为 true。 |
| variant | TMessageVariant | TMessageVariant.info | 消息语义色 |
| visible | bool | true | 是否显示 |

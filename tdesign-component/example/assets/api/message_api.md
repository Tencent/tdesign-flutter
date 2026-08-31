## API
### TMessage

#### 静态方法

##### TMessage.show

在 Overlay 中显示消息并返回控制句柄。
未显式传入 `offset` 时，新消息会替换同一 Overlay 中上一条默认位置的消息；
显式传入不同 `offset` 的消息可以同时展示。

返回类型：`TMessageHandle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| content | String | '' | 通知内容 |
| duration | Duration? | const Duration(seconds: 3) | 自动关闭时长；必须为正数，null 表示不自动关闭。 |
| showIcon | bool | true | 是否显示前置图标 |
| icon | Widget? | - | 自定义前置图标 |
| action | Widget? | - | 消息尾部操作组件。 操作的外观与行为由组件自身负责，例如传入带 `VoidCallback` 的按钮或链接。 |
| showCloseButton | bool | false | 是否显示关闭按钮 |
| closeButton | Widget? | - | 自定义关闭按钮 |
| marquee | TMessageMarquee? | - | 跑马灯配置 |
| offset | Offset? | - | 期望的屏幕绝对坐标。 `useSafeArea` 为 true 时，最终消息矩形会被约束在安全可视区域内。 |
| status | TMessageStatus | TMessageStatus.info | 消息语义状态 |
| onCloseButtonPressed | VoidCallback? | - | 点击关闭按钮时触发 |
| onDurationEnd | VoidCallback? | - | 自动展示时长结束且关闭动画完成时触发 |
| onDismissed | VoidCallback? | - | 消息完成关闭、被句柄移除、被新消息替换或 Overlay 卸载时触发。 每次展示最多触发一次。 |
| useSafeArea | bool | true | 是否避让系统安全区，默认为 true。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | Widget? | - | 消息尾部操作组件。 操作的外观与行为由组件自身负责，例如传入带 `VoidCallback` 的按钮或链接。 |
| closeButton | Widget? | - | 自定义关闭按钮 |
| content | String | '' | 通知内容 |
| duration | Duration? | const Duration(seconds: 3) | 自动关闭时长；必须为正数，null 表示不自动关闭。 |
| icon | Widget? | - | 自定义前置图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| marquee | TMessageMarquee? | - | 跑马灯配置 |
| offset | Offset? | - | 期望的屏幕绝对坐标。 `useSafeArea` 为 true 时，最终消息矩形会被约束在安全可视区域内。 |
| onCloseButtonPressed | VoidCallback? | - | 点击关闭按钮时触发 |
| onDismissed | VoidCallback? | - | 消息完成关闭、被句柄移除、被新消息替换或 Overlay 卸载时触发。 每次展示最多触发一次。 |
| onDurationEnd | VoidCallback? | - | 自动展示时长结束且关闭动画完成时触发 |
| showCloseButton | bool | false | 是否显示关闭按钮 |
| showIcon | bool | true | 是否显示前置图标 |
| status | TMessageStatus | TMessageStatus.info | 消息语义状态 |
| useSafeArea | bool | true | 是否避让系统安全区，默认为 true。 |
| visible | bool | false | 是否显示，默认为 false |

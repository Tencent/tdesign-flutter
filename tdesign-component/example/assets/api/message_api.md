## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TMessage

#### 声明

```dart
class TMessage extends StatefulWidget
```


#### 静态方法

##### TMessage.show

```dart
static TMessageHandle show({
  required BuildContext context,
  String content = '',
  Duration? duration = const Duration(seconds: 3),
  bool showIcon = true,
  Widget? icon,
  Widget? action,
  bool showCloseButton = false,
  Widget? closeButton,
  TMessageMarquee? marquee,
  Offset? offset,
  TMessageStatus status = TMessageStatus.info,
  VoidCallback? onCloseButtonPressed,
  VoidCallback? onDurationEnd,
  VoidCallback? onDismissed,
  bool useSafeArea = true,
})
```


在 Overlay 中显示消息并返回控制句柄。
未显式传入 `offset` 时，新消息会替换同一 Overlay 中上一条默认位置的消息；
显式传入不同 `offset` 的消息可以同时展示。

返回类型：`TMessageHandle`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| content | String | '' | 通知内容 | 否 |
| duration | Duration? | const Duration(seconds: 3) | 自动关闭时长；必须为正数，null 表示不自动关闭。 | 否 |
| showIcon | bool | true | 是否显示前置图标 | 否 |
| icon | Widget? | - | 自定义前置图标 | 否 |
| action | Widget? | - | 消息尾部操作组件。 操作的外观与行为由组件自身负责，例如传入带 `VoidCallback` 的按钮或链接。 | 否 |
| showCloseButton | bool | false | 是否显示关闭按钮 | 否 |
| closeButton | Widget? | - | 自定义关闭按钮 | 否 |
| marquee | TMessageMarquee? | - | 跑马灯配置 | 否 |
| offset | Offset? | - | 期望的屏幕绝对坐标。 未显式传入时，消息保留 16 逻辑像素水平外间距；`useSafeArea` 为 true 时， 显式坐标也会被约束在含该外间距的系统安全可视区域内。 | 否 |
| status | TMessageStatus | TMessageStatus.info | 消息语义状态 | 否 |
| onCloseButtonPressed | VoidCallback? | - | 点击关闭按钮时触发 | 否 |
| onDurationEnd | VoidCallback? | - | 自动展示时长结束且关闭动画完成时触发 | 否 |
| onDismissed | VoidCallback? | - | - | 否 |
| useSafeArea | bool | true | 是否避让系统安全区，默认为 true。设为 false 时显式 `offset` 保持绝对坐标， 消息宽度仍使用扣除 16 像素水平外间距后的默认宽度。 | 否 |

#### 默认构造方法


```dart
const TMessage({
  super.key,
  this.content = '',
  this.duration = const Duration(seconds: 3),
  this.showIcon = true,
  this.icon,
  this.action,
  this.showCloseButton = false,
  this.closeButton,
  this.marquee,
  this.offset,
  this.status = TMessageStatus.info,
  this.onCloseButtonPressed,
  this.onDurationEnd,
  this.onDismissed,
  this.useSafeArea = true,
})
```

创建消息组件

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| action | Widget? | - | 消息尾部操作组件。 操作的外观与行为由组件自身负责，例如传入带 `VoidCallback` 的按钮或链接。 | 否 |
| closeButton | Widget? | - | 自定义关闭按钮 | 否 |
| content | String | '' | 通知内容 | 否 |
| duration | Duration? | const Duration(seconds: 3) | 自动关闭时长；必须为正数，null 表示不自动关闭。 | 否 |
| icon | Widget? | - | 自定义前置图标 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| marquee | TMessageMarquee? | - | 跑马灯配置 | 否 |
| offset | Offset? | - | 期望的屏幕绝对坐标。 未显式传入时，消息保留 16 逻辑像素水平外间距；`useSafeArea` 为 true 时， 显式坐标也会被约束在含该外间距的系统安全可视区域内。 | 否 |
| onCloseButtonPressed | VoidCallback? | - | 点击关闭按钮时触发 | 否 |
| onDismissed | VoidCallback? | - | 消息完成关闭、被句柄移除、被新消息替换或 Overlay 卸载时触发。 每次展示最多触发一次。 | 否 |
| onDurationEnd | VoidCallback? | - | 自动展示时长结束且关闭动画完成时触发 | 否 |
| showCloseButton | bool | false | 是否显示关闭按钮 | 否 |
| showIcon | bool | true | 是否显示前置图标 | 否 |
| status | TMessageStatus | TMessageStatus.info | 消息语义状态 | 否 |
| useSafeArea | bool | true | 是否避让系统安全区，默认为 true。设为 false 时显式 `offset` 保持绝对坐标， 消息宽度仍使用扣除 16 像素水平外间距后的默认宽度。 | 否 |

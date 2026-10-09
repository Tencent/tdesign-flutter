## API

### TMessage

顶部消息组件。

直接构造即渲染消息，并应作为 `Stack` 的子组件使用。页面内的展示与隐藏由父级
Widget 树插入或移除组件；使用自动关闭或关闭按钮时，可在 `onDismissed` 中同步
移除父级状态。全局 Overlay 消息使用 `TMessage.show`，并通过返回的
`TMessageHandle` 关闭。

#### 主题配置

组件主题通过 `TMessageThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。可配置字段和未设置时的回退见本页的
`TMessageThemeData` 配置项。

#### 构造方法

##### TMessage

创建消息组件

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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


#### 静态方法

##### TMessage.show

在 Overlay 中显示消息并返回控制句柄。

未显式传入 `offset` 时，新消息会替换同一 Overlay 中上一条默认位置的消息；
显式传入不同 `offset` 的消息可以同时展示。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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
| onDismissed | VoidCallback? | - | 消息完成关闭、被句柄移除、被新消息替换或 Overlay 卸载时触发；每次展示最多一次。 | 否 |
| useSafeArea | bool | true | 是否避让系统安全区，默认为 true。设为 false 时显式 `offset` 保持绝对坐标， 消息宽度仍使用扣除 16 像素水平外间距后的默认宽度。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TMessageHandle | - | 已插入 Overlay 的消息控制句柄，可用于查询显示状态与主动关闭。 | - |


### TMessageMarquee

跑马灯配置

#### 构造方法

##### TMessageMarquee

创建跑马灯配置

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| delay | Duration | Duration.zero | 开始滚动前的延迟 | 否 |
| duration | Duration | const Duration(seconds: 10) | 单次滚动时长 | 否 |
| repeat | bool | false | 是否循环滚动 | 否 |


### TMessageHandle

命令式消息句柄

#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| isShowing | bool | - | 消息是否仍在 Overlay 中 | - |


#### 实例方法

##### TMessageHandle.dismiss

无参数。

立即移除消息；重复调用不会重复触发 `onDismissed`。

### TMessageStatus

TMessage 语义状态
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| info | TMessageStatus | - | 信息 | - |
| success | TMessageStatus | - | 成功 | - |
| warning | TMessageStatus | - | 警告 | - |
| error | TMessageStatus | - | 错误 | - |


### TMessageThemeData

TMessage 组件级 ThemeExtension

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色 未配置时使用 bgColorContainer Token。 | 否 |
| elevation | double? | - | 阴影 未配置时使用全局 shadow1 绘制阴影；非空时改用 Material elevation。 | 否 |
| shape | ShapeBorder? | - | 形状 未配置时使用 radiusDefault Token 构造圆角矩形。 | 否 |


#### 静态方法

##### TMessageThemeData.lerpDouble

位置参数：`a, b, t`


对 `a` 和 `b` 按 `t` 线性插值；两端均为 null 时返回 null，仅一端为 null 时按 0 参与计算。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| a | double? | - | 插值起始值；单端为空时按 0 参与插值。 | 是 |
| b | double? | - | 插值目标值；单端为空时按 0 参与插值。 | 是 |
| t | double | - | 插值进度；0 表示起点，1 表示终点。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | double? | - | 按 t 线性插值的数值；两端均为 null 时为 null，仅一端为 null 时将该端按 0 计算。 | - |

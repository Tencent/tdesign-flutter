## API
### TPullDownRefresh
#### 简介
TDesign 下拉刷新组件。
以**最小、Flutter 惯用**的 API 封装 `EasyRefresh`，对齐官方
（小程序 / mobile-vue）PullDownRefresh 的行为表现：
下拉 → 松手 → 刷新 → 完成四态，支持触底加载、超时、
四态文案自定义与受控刷新。
典型用法：
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 必填：滚动内容（对应官方默认 slot）。 必须为**有界、可滚动**的内容（如 `ListView` / `GridView` / `CustomScrollView`）。 若内容自身不可滚动，请用 `SizedBox` 等为其指定固定高度，否则下拉 / 触底 手势无法生效。 |
| controller | TPullDownRefreshController? | - | 外部主动刷新控制器。 通过 `TPullDownRefreshController.refresh` 从页面外部触发刷新。刷新完成时机 由 `onRefresh` 返回的 Future、异常或 `refreshTimeout` 共同决定；超时后 控制器 Future 也会完成，迟到的原始 Future 不会再次改变刷新状态。 底层 `EasyRefreshController` 由 State 创建并释放；外部控制器仅持有引用， 无需也不能重复 dispose（详见 `TPullDownRefreshController` 文档）。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loadingBarHeight | double | 50 | Header 容器高度 = 触发阈值（默认 50，对齐官方 `loadingBarHeight`）。 |
| lowerThreshold | double | 50 | 距离底部多少逻辑像素时触发加载（默认 50，对齐官方 `lowerThreshold`）。 |
| maxBarHeight | double | 80 | 最大下拉高度（默认 80，对齐官方 `maxBarHeight`）。 |
| onLoadMore | FutureOr<void> Function()? | - | 触底加载回调（对应官方 `scrolltolower` 事件）。 非空时自动启用，触底达到 `lowerThreshold` 时触发；Footer 本身不增加 TDesign 未定义的可见样式。 返回的 `Future` 完成后自动结束加载态。与 `onRefresh` 一致，本回调若同步 抛错或返回的 `Future` 失败， 加载任务会**正常结束（不悬挂）**，错误经 `FlutterError.reportError` 上报 （不吞掉）。若需在失败时做业务处理，请在回调内部自行 try/catch。 |
| onRefresh | FutureOr<void> Function()? | - | 下拉触发刷新回调（对应官方 `refresh` 事件）。 为空时禁用下拉刷新。返回的 Future 完成后自动展示完成态并复位。 若回调同步抛错或返回的 Future 失败，刷新任务会**正常结束（不悬挂）**， 错误通过 `FlutterError.reportError` 上报（不吞掉），但不会作为未捕获异常 中断 easy_refresh 的动画流程。若需在失败时做业务处理，请在回调内部自行 try/catch。 |
| onStateChanged | ValueChanged<TPullDownRefreshState>? | - | 刷新状态变化回调（对应官方 `change`/`onChange` 事件）。 值域为 `TPullDownRefreshState`。仅在状态**跳变**时回调（已去重）， 且通过异步调度触发，**不会**在 build 期间同步调用，可在回调中安全 `setState`。其中 `TPullDownRefreshState.timeout` 是一次性超时通知， 随后会收到 `TPullDownRefreshState.inactive`。 |
| refreshTimeout | Duration? | const Duration(milliseconds: 3000) | 刷新超时时长（**默认 3 秒**）；超过时长仍未完成 `onRefresh` 时自动结束刷新， 并通过 `onStateChanged` 上报 `TPullDownRefreshState.timeout`。 默认启用 3 秒超时；传入 `null` 可关闭超时。 `timeout` 是一次性状态通知，随后立即结束刷新并回到 `TPullDownRefreshState.inactive`，无专属渲染文案。超时后即使原始 `onRefresh` Future 迟到完成，也不会再次上报 `TPullDownRefreshState.done`。 必须为非负时长。 |
| successDuration | Duration | const Duration(milliseconds: 500) | 刷新完成提示的展示时长（默认 500ms，对齐官方 `successDuration`）。 必须为非负时长。 |
| texts | TPullDownRefreshTexts? | - | 四态提示语；为空时回退 l10n（默认中文与官方 `loadingTexts` 一致）。 |


### TPullDownRefreshController
#### 简介
`TPullDownRefresh` 的外部刷新控制器。
使用 Flutter 惯用的控制器模式，从页面外部通过 `refresh` 主动触发一次刷新。
返回的 Future 会在本次刷新成功、回调失败或超时复位后完成；它不返回业务结果。
回调异常仍由 `TPullDownRefresh` 通过 `FlutterError.reportError` 上报。
## 生命周期（所有权）
底层刷新控制器的所有权归 `TPullDownRefresh` 的 State 独占管理：
State 在 `initState` 中创建、在 `dispose` 中释放。本控制器不拥有需要调用方
释放的资源，因此不提供公开 `dispose()`。

### TPullDownRefreshTexts
#### 简介
下拉刷新四态提示语。
对应官方（小程序 / mobile-vue）`loadingTexts: string[]` 数组，
覆盖「下拉刷新 / 松手刷新 / 正在刷新 / 刷新完成」四个阶段的文案。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| pullToRefresh | String | - | 下拉未达阈值时的提示语（官方默认「下拉刷新」）。 |
| refreshComplete | String | - | 刷新完成时的提示语（官方默认「刷新完成」）。 |
| refreshing | String | - | 刷新进行中的提示语（官方默认「正在刷新」）。 |
| releaseToRefresh | String | - | 下拉已达阈值、松手即刷新的提示语（官方默认「松手刷新」）。 |


### TPullDownRefreshState
#### 简介
下拉刷新状态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| inactive | 未触发（初始 / 完成复位后）。 |
| dragging | 下拉中，未达到触发阈值。 |
| ready | 已达阈值、松手即触发刷新。 |
| refreshing | 刷新进行中。 |
| done | 刷新完成、展示完成态。 |
| timeout | 刷新超时的一次性通知，随后回到 `TPullDownRefreshState.inactive`。 |

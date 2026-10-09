## API

### TPullDownRefresh

TDesign 下拉刷新组件。

通过 `EasyRefresh` 提供下拉刷新能力：
下拉 → 松手 → 刷新 → 完成四态，支持触底加载、超时、
四态文案自定义与受控刷新。

#### 构造方法

##### TPullDownRefresh

构造 `TPullDownRefresh`。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 必填：滚动内容（对应官方默认 slot）。 必须为**有界且可滚动**的内容（如 `ListView` / `GridView` / `CustomScrollView`）。 `SizedBox` 等只能提供尺寸约束，不能把静态内容变成可滚动内容；若内容自身不可滚动， 下拉 / 触底手势仍无法生效，应将内容放入可滚动容器。 | 是 |
| controller | TPullDownRefreshController? | - | 外部主动刷新控制器。 通过 `TPullDownRefreshController.refresh` 从页面外部触发刷新。刷新完成时机 由 `onRefresh` 返回的 Future、异常或 `refreshTimeout` 共同决定；超时后 控制器 Future 也会完成，迟到的原始 Future 不会再次改变刷新状态。 刷新资源由组件管理；外部控制器无需也不提供 dispose （详见 `TPullDownRefreshController` 文档）。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| loadingBarHeight | double | 50 | Header 容器高度与触发阈值，默认 50 逻辑像素，必须大于 0。 | 否 |
| lowerThreshold | double | 50 | 距离底部多少逻辑像素时触发加载，默认 50，必须大于 0。 | 否 |
| maxBarHeight | double | 80 | 最大下拉高度，默认 80 逻辑像素，不得小于 loadingBarHeight。 | 否 |
| onLoadMore | FutureOr&lt;void&gt; Function()? | - | 触底加载回调（对应官方 `scrolltolower` 事件）。 非空时自动启用，触底达到 `lowerThreshold` 时触发；Footer 本身不增加 TDesign 未定义的可见样式。 返回的 `Future` 完成后自动结束加载态。与 `onRefresh` 一致，本回调若同步 抛错或返回的 `Future` 失败， 加载任务会**正常结束（不悬挂）**，错误经 `FlutterError.reportError` 上报 （不吞掉）。若需在失败时做业务处理，请在回调内部自行 try/catch。 | 否 |
| onRefresh | FutureOr&lt;void&gt; Function()? | - | 下拉触发刷新回调（对应官方 `refresh` 事件）。 为空时禁用下拉刷新。返回的 Future 完成后自动展示完成态并复位。 若回调同步抛错或返回的 Future 失败，刷新任务会**正常结束（不悬挂）**， 错误通过 `FlutterError.reportError` 上报（不吞掉），但不会作为未捕获异常 中断 easy_refresh 的动画流程。若需在失败时做业务处理，请在回调内部自行 try/catch。 | 否 |
| onStateChanged | ValueChanged&lt;TPullDownRefreshState&gt;? | - | 刷新状态变化回调（对应官方 `change`/`onChange` 事件）。 值域为 `TPullDownRefreshState`。仅在状态**跳变**时回调（已去重）， 且通过异步调度触发，**不会**在 build 期间同步调用，可在回调中安全 `setState`。其中 `TPullDownRefreshState.timeout` 是一次性超时通知， 随后会收到 `TPullDownRefreshState.inactive`。 | 否 |
| refreshTimeout | Duration? | const Duration(milliseconds: 3000) | 刷新超时时长（**默认 3 秒**）；超过时长仍未完成 `onRefresh` 时自动结束刷新， 并通过 `onStateChanged` 上报 `TPullDownRefreshState.timeout`。 默认启用 3 秒超时；传入 `null` 可关闭超时。 `timeout` 是一次性状态通知，随后立即结束刷新并回到 `TPullDownRefreshState.inactive`，无专属渲染文案。超时后即使原始 `onRefresh` Future 迟到完成，也不会再次上报 `TPullDownRefreshState.done`。 必须为非负时长。 | 否 |
| successDuration | Duration | const Duration(milliseconds: 500) | 刷新完成提示的展示时长（默认 500ms，对齐官方 `successDuration`）。 必须为非负时长。 | 否 |
| texts | TPullDownRefreshTexts? | - | 四态提示语；为空时回退 l10n（默认中文与官方 `loadingTexts` 一致）。 | 否 |


### TPullDownRefreshController

`TPullDownRefresh` 的外部刷新控制器。

使用 Flutter 惯用的控制器模式，从页面外部通过 `refresh` 主动触发一次刷新。
返回的 Future 会在本次刷新成功、回调失败或超时复位后完成；它不返回业务结果。
回调异常仍由 `TPullDownRefresh` 通过 `FlutterError.reportError` 上报。

#### 生命周期（所有权）

刷新资源由 `TPullDownRefresh` 随挂载和卸载管理；本控制器不拥有
需要调用方释放的资源，因此无需也不提供公开 `dispose()`。

#### 构造方法

##### TPullDownRefreshController

无参数。

#### 实例方法

##### TPullDownRefreshController.refresh

无参数。

从页面外部主动触发一次下拉刷新。

`await refresh()` 表示这次刷新流程已经结束，不代表业务一定成功；
成功、回调失败和超时都会完成 Future。组件未挂载或未配置刷新回调
时，该方法立即完成。

###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;void&gt; | - | 刷新流程结束时完成；业务失败或超时也会完成，未挂载或无刷新回调时立即完成。 | - |


### TPullDownRefreshTexts

下拉刷新四态提示语。

覆盖「下拉刷新 / 松手刷新 / 正在刷新 / 刷新完成」四个阶段的文案。

#### 构造方法

##### TPullDownRefreshTexts

构造四态文案。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| pullToRefresh | String | - | 下拉未达阈值时的提示语（官方默认「下拉刷新」）。 | 是 |
| refreshComplete | String | - | 刷新完成时的提示语（官方默认「刷新完成」）。 | 是 |
| refreshing | String | - | 刷新进行中的提示语（官方默认「正在刷新」）。 | 是 |
| releaseToRefresh | String | - | 下拉已达阈值、松手即刷新的提示语（官方默认「松手刷新」）。 | 是 |


### TPullDownRefreshState

下拉刷新状态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| inactive | TPullDownRefreshState | - | 未触发（初始 / 完成复位后）。 | - |
| dragging | TPullDownRefreshState | - | 下拉中，未达到触发阈值。 | - |
| ready | TPullDownRefreshState | - | 已达阈值、松手即触发刷新。 | - |
| refreshing | TPullDownRefreshState | - | 刷新进行中。 | - |
| done | TPullDownRefreshState | - | 刷新完成、展示完成态。 | - |
| timeout | TPullDownRefreshState | - | 刷新超时的一次性通知，随后回到 `TPullDownRefreshState.inactive`。 | - |

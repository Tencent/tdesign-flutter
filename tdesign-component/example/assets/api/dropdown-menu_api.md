## API

### TDropdownMenu

用于页面内容排序、筛选的横向下拉筛选栏。

#### 构造方法

##### TDropdownMenu

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| animationDuration | Duration? | - | 展开、关闭及切换动画时长。 未指定时为 200ms。系统禁用动画时始终使用零时长。 | 否 |
| closeOnOverlayTap | bool | true | - | 否 |
| controller | TDropdownMenuController? | - | - | 否 |
| items | List&lt;TDropdownMenuItem&gt; | - | - | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onClosed | TDropdownMenuClosedCallback? | - | - | 否 |
| onOpened | ValueChanged&lt;int&gt;? | - | - | 否 |
| placement | TDropdownMenuPlacement | TDropdownMenuPlacement.auto | - | 否 |
| scrollable | bool | false | - | 否 |
| showOverlay | bool | true | - | 否 |
| useRootOverlay | bool | false | - | 否 |


### TDropdownMenuPlacement

下拉筛选面板相对筛选栏的展开位置。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| auto | TDropdownMenuPlacement | - | - | - |
| below | TDropdownMenuPlacement | - | - | - |
| above | TDropdownMenuPlacement | - | - | - |


### TDropdownMenuCloseReason

下拉筛选面板关闭的原因。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| selection | TDropdownMenuCloseReason | - | - | - |
| confirm | TDropdownMenuCloseReason | - | - | - |
| cancel | TDropdownMenuCloseReason | - | - | - |
| overlay | TDropdownMenuCloseReason | - | - | - |
| back | TDropdownMenuCloseReason | - | - | - |
| trigger | TDropdownMenuCloseReason | - | - | - |
| controller | TDropdownMenuCloseReason | - | - | - |
| switchItem | TDropdownMenuCloseReason | - | - | - |


### TDropdownMenuClosedCallback

下拉筛选面板关闭回调。

位置参数：`index, reason`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| index | int | - | - | 是 |
| reason | TDropdownMenuCloseReason | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | void | - | - | - |


### TDropdownMenuPanelBuilder

默认触发项的面板构建器。

位置参数：`context, controller`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| controller | TDropdownMenuPanelController | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | - | - |


### TDropdownMenuTriggerBuilder

自定义触发项构建器。

位置参数：`context, state`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| state | TDropdownMenuTriggerState | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | - | - |

## API
### TDropdownMenu
#### 简介
用于页面内容排序、筛选的横向下拉筛选栏。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration? | - | 展开、关闭及切换动画时长。 未指定时为 200ms。系统禁用动画时始终使用零时长。 |
| closeOnOverlayTap | bool | true | 点按蒙层/外部区域是否关闭，默认 true。 |
| controller | TDropdownMenuController? | - | 可选命令式控制器；未传时组件创建内部控制器。 |
| items | List<TDropdownMenuItem> | - | 筛选项，按列表顺序排列。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onClosed | TDropdownMenuClosedCallback? | - | 关闭动画完成后报告索引及关闭原因。 |
| onOpened | ValueChanged<int>? | - | 展开动画完成后报告筛选项索引。 |
| placement | TDropdownMenuPlacement | TDropdownMenuPlacement.auto | 展开位置，默认根据可用空间自动选择。 |
| scrollable | bool | false | 是否允许触发栏横向滚动，默认 false。 |
| showOverlay | bool | true | 是否显示蒙层，默认 true。 |
| useRootOverlay | bool | false | 是否使用根 Overlay，默认 false。 |


### TDropdownMenuPlacement
#### 简介
下拉筛选面板相对筛选栏的展开位置。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| auto | 根据可用空间自动选择，空间变化时避免展开方向反复跳动。 |
| below | 固定向筛选栏下方展开。 |
| above | 固定向筛选栏上方展开。 |


### TDropdownMenuCloseReason
#### 简介
下拉筛选面板关闭的原因。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| selection | 单选项目提交后关闭。 |
| confirm | 多选草稿确认后关闭。 |
| cancel | 用户取消草稿。 |
| overlay | 点按覆盖层或外部区域关闭。 |
| back | 系统返回关闭。 |
| trigger | 再次激活已展开的触发项关闭。 |
| controller | 命令式控制器发起关闭。 |
| switchItem | 切换到另一筛选项时关闭原面板。 |


### TDropdownMenuClosedCallback
#### 简介
下拉筛选面板关闭回调。
#### 类型定义

```dart
typedef TDropdownMenuClosedCallback = void Function(int index, TDropdownMenuCloseReason reason);
```


### TDropdownMenuPanelBuilder
#### 简介
默认触发项的面板构建器。
#### 类型定义

```dart
typedef TDropdownMenuPanelBuilder = Widget Function(BuildContext context, TDropdownMenuPanelController controller);
```


### TDropdownMenuTriggerBuilder
#### 简介
自定义触发项构建器。
#### 类型定义

```dart
typedef TDropdownMenuTriggerBuilder = Widget Function(BuildContext context, TDropdownMenuTriggerState state);
```

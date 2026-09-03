## API
### TDropdownMenu
#### 简介
用于页面内容排序、筛选的横向下拉筛选栏。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration? | - | 展开、关闭及切换动画时长。 未指定时使用 `TDropdownThemeData.animationDuration`，再回退到 200ms。 显式值（包括 `Duration.zero`）优先于主题；系统禁用动画时始终使用零时长。 |
| closeOnOverlayTap | bool | true | - |
| controller | TDropdownMenuController? | - | - |
| items | List<TDropdownMenuItem> | - | - |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onClosed | TDropdownMenuClosedCallback? | - | - |
| onOpened | ValueChanged<int>? | - | - |
| placement | TDropdownMenuPlacement | TDropdownMenuPlacement.auto | - |
| scrollable | bool | false | - |
| showOverlay | bool | true | - |
| useRootOverlay | bool | false | - |


### TDropdownMenuPlacement
#### 简介
下拉筛选面板相对筛选栏的展开位置。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| auto | - |
| below | - |
| above | - |


### TDropdownMenuCloseReason
#### 简介
下拉筛选面板关闭的原因。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| selection | - |
| confirm | - |
| cancel | - |
| overlay | - |
| back | - |
| trigger | - |
| controller | - |
| switchItem | - |


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

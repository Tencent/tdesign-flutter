## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TDropdownMenu
#### 简介
用于页面内容排序、筛选的横向下拉筛选栏。

#### 声明

```dart
class TDropdownMenu extends StatefulWidget
```

#### 默认构造方法


```dart
const TDropdownMenu({
  super.key,
  required this.items,
  this.controller,
  this.placement = TDropdownMenuPlacement.auto,
  this.scrollable = false,
  this.showOverlay = true,
  this.closeOnOverlayTap = true,
  this.useRootOverlay = false,
  this.animationDuration,
  this.onOpened,
  this.onClosed,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
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

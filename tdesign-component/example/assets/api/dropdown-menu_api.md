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


### TDropdownMenuOption
#### 简介
下拉筛选面板中的不可变选项。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | - |
| group | String? | - | - |
| label | String | - | - |
| value | T | - | - |


### TDropdownSingleSelectPanel
#### 简介
单选筛选面板。选择有效选项后立即提交并关闭。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| controller | TDropdownMenuPanelController | - | - |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxHeight | double? | - | 滚动主体的最大高度；默认 280dp。 |
| onChanged | ValueChanged<T> | - | 提交候选选中值；重选同一项仍通知，并请求关闭面板。 最终选中状态由调用方通过 value 回写。 |
| options | List<TDropdownMenuOption<T>> | - | - |
| value | T? | - | - |


### TDropdownMultiSelectPanel
#### 简介
多选筛选面板。
`values` 表示已提交值，每次打开时用于初始化草稿。选项点击只更新面板内部草稿，
点击确认后才通过 `onConfirm` 提交。
打开期间 `values` 变化时，尚未修改的草稿会同步；已有修改的草稿保留用户编辑。
未确认即关闭会丢弃草稿，再次打开时使用最新的 `values`。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| columns | int | 1 | - |
| controller | TDropdownMenuPanelController | - | - |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxHeight | double? | - | 面板最大高度；默认滚动主体最多 280dp，底部操作区另计。 |
| onConfirm | ValueChanged<Set<T>> | - | - |
| options | List<TDropdownMenuOption<T>> | - | - |
| values | Set<T> | - | - |


### TDropdownMenuTriggerState
#### 简介
自定义触发项可读取的不可变状态。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| enabled | bool | - | - |
| index | int | - | - |
| isOpen | bool | - | - |
| toggle | VoidCallback | - | - |


### TDropdownMenuPanelController
#### 简介
当前面板可使用的局部控制器。
#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| index | int | - | - |


### TDropdownMenuItem
#### 简介
一个筛选触发项及其对应面板。

#### 工厂构造方法

##### TDropdownMenuItem.custom

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| triggerBuilder | TDropdownMenuTriggerBuilder? | - | - |
| panelBuilder | TDropdownMenuPanelBuilder | - | - |
| enabled | bool | true | - |
| flex | int | 1 | - |
| width | double? | - | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| enabled | bool | true | - |
| flex | int | 1 | - |
| label | String? | - | - |
| panelBuilder | TDropdownMenuPanelBuilder | - | - |
| width | double? | - | - |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| triggerBuilder | TDropdownMenuTriggerBuilder? | - | - |


### TDropdownMenuController
#### 简介
类型安全的下拉筛选栏控制器。
单目标菜单控制器；同时绑定多个菜单会抛出 StateError。
未绑定时命令无副作用，调用方负责 dispose。

### TDropdownThemeData
#### 简介
DropdownMenu 的组件级视觉与布局默认值。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| actionAreaPadding | EdgeInsetsGeometry? | - | - |
| actionGap | double? | - | - |
| activeIconColor | Color? | - | - |
| activeTextStyle | TextStyle? | - | - |
| barBackgroundColor | Color? | - | - |
| barHeight | double? | - | - |
| disabledIconColor | Color? | - | - |
| disabledOptionColor | Color? | - | - |
| disabledOptionTextStyle | TextStyle? | - | - |
| disabledTextStyle | TextStyle? | - | - |
| dividerColor | Color? | - | - |
| iconColor | Color? | - | - |
| iconSize | double? | - | - |
| optionBorderRadius | BorderRadius? | - | - |
| optionColor | Color? | - | - |
| optionHeight | double? | - | - |
| optionPadding | EdgeInsetsGeometry? | - | - |
| optionTextStyle | TextStyle? | - | - |
| overlayColor | Color? | - | 遮罩颜色，包含透明度。未指定时为黑色 60%，动画按展开进度缩放透明度。 |
| panelBackgroundColor | Color? | - | - |
| selectedOptionColor | Color? | - | - |
| selectedOptionTextStyle | TextStyle? | - | - |
| textStyle | TextStyle? | - | - |


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

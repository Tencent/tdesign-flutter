## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TPopup
#### 简介
弹出层入口。

### 主题配置
组件主题通过 `TPopupThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TPopupThemeData` 说明。

#### 声明

```dart
final class TPopup
```


#### 静态方法

##### TPopup.show

```dart
static TPopupHandle show(
  BuildContext context, {
  required TPopupOptions options,
  BuildContext? navigatorContext,
  bool useRootNavigator = false,
})
```


每次调用打开独立浮层，可叠加展示；参数与方向不匹配时抛出 `FlutterError`。
## 返回值
用于控制当前浮层的关闭、重新打开及状态查询。

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 `Navigator` 并获取局部主题。 | 是 |
| options | TPopupOptions | - | 浮层配置；创建句柄时合并 `context` 的 `TPopupThemeData`，重新打开不重新解析已合并的主题值。 | 是 |
| navigatorContext | BuildContext? | - | 承载浮层的导航上下文；未指定时使用 `context`。 | 否 |
| useRootNavigator | bool | false | 是否使用根 `Navigator`。 | 否 |


### TPopupHeader
#### 简介
底部头部布局，提供取消按钮、标题和确认按钮三个插槽；按钮行为由调用方设置。

#### 声明

```dart
class TPopupHeader extends StatelessWidget
```

#### 默认构造方法


```dart
const TPopupHeader({
  super.key,
  this.cancelButton,
  this.title,
  this.confirmButton,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| cancelButton | Widget? | - | 左侧取消操作；为 null 时不显示。 | 否 |
| confirmButton | Widget? | - | 右侧确认操作；为 null 时不显示。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| title | Widget? | - | 中间标题；为 null 时不显示。 | 否 |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| headerHeight | double | 58 | 标准头部高度。 |


### TPopupOptions
#### 简介
`TPopup.show` 的配置对象。
| 构造方法 | 方向 | 方向专用参数 |
| --- | --- | --- |
| `TPopupOptions` | 由 `placement` 指定 | 按对应方向使用下列参数 |
| `TPopupOptions.bottom` | 底部 | `height`、`inset`（`TPopupBottomInset`）、`headerBuilder` |
| `TPopupOptions.center` | 居中 | `width`、`height`、`closeBuilder` |
| `TPopupOptions.top` | 顶部 | `height`、`inset`（`TPopupTopInset`） |
| `TPopupOptions.left` | 左侧 | `width`、`inset`（`TPopupLeftInset`） |
| `TPopupOptions.right` | 右侧 | `width`、`inset`（`TPopupRightInset`） |
| 条件 | 行为 |
| --- | --- |
| 显式设置尺寸、圆角、面板颜色或蒙层颜色 | 优先于 `TPopupThemeData` |
| 参数与方向不匹配 | `TPopup.show` / `TPopupHandle.open` 抛出 `FlutterError` |

#### 声明

```dart
class TPopupOptions
```


#### 工厂构造方法

##### TPopupOptions.bottom

```dart
factory TPopupOptions.bottom({
  required Widget child,
  double? height,
  TPopupBottomInset? inset,
  TPopupHeaderBuilder? headerBuilder,
  double? radius,
  Color? backgroundColor,
  TPopupOverlayConfig? overlay,
  bool destroyOnClose = false,
  Duration? animationDuration,
  VoidCallback? onOpened,
  VoidCallback? onClosed,
  TPopupVisibleChangeCallback? onVisibleChange,
  bool useSafeArea = false,
})
```


底部弹出配置。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 面板内容，占用面板内可用空间；底部有头部时占用剩余高度。长内容需自行使用滚动组件。 | 是 |
| height | double? | - | 面板高度，受可用高度约束；底部包含头部，居中不包含面板外关闭区。未传时取方向对应的 Popup 主题值，再回退到 240；仅顶部/底部/居中支持。 | 否 |
| inset | TPopupBottomInset? | - | 交叉轴留白；须使用当前方向的 Inset 类型，居中不支持。 | 否 |
| headerBuilder | TPopupHeaderBuilder? | - | 底部头部，占用 `height` 内的空间；未指定时不显示，可用 `TPopupHeader` 组合标题与操作按钮。 | 否 |
| radius | double? | - | 顶部/底部/居中默认取主题大圆角，左侧/右侧默认无圆角；显式值或 `TPopupThemeData.panelRadius` 可覆盖。 | 否 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层配置；未指定时显示蒙层、拦截背景交互并支持点击关闭。 | 否 |
| destroyOnClose | bool | false | 为 true 时，被其他不透明路由覆盖可释放内容状态；关闭后始终释放，再次打开创建新状态。 | 否 |
| animationDuration | Duration? | - | 打开/关闭动画时长；未指定时使用 240ms。 | 否 |
| onOpened | VoidCallback? | - | 打开动画结束后触发。 | 否 |
| onClosed | VoidCallback? | - | 关闭动画结束后触发；非栈顶浮层直接移除时在路由释放时触发。关闭完成前重新 `TPopupHandle.open`，旧周期不触发。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 打开时同步触发 true，开始关闭时触发 false，均不等待动画结束；第二个参数为 `TPopupTrigger`。 | 否 |
| useSafeArea | bool | false | 避让安全区：顶部仅上边，底部仅下边，左侧避让左/上/下边，右侧避让右/上/下边，居中避让全部边；与 `inset` 叠加。仅内容需避让时可在 `child` 中使用 `SafeArea`。 | 否 |


##### TPopupOptions.center

```dart
factory TPopupOptions.center({
  required Widget child,
  double? width,
  double? height,
  TPopupSlotBuilder? closeBuilder,
  double? radius,
  Color? backgroundColor,
  TPopupOverlayConfig? overlay,
  bool destroyOnClose = false,
  Duration? animationDuration,
  VoidCallback? onOpened,
  VoidCallback? onClosed,
  TPopupVisibleChangeCallback? onVisibleChange,
  bool useSafeArea = false,
})
```


居中弹出配置。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 面板内容，占用面板内可用空间；底部有头部时占用剩余高度。长内容需自行使用滚动组件。 | 是 |
| width | double? | - | 面板宽度，受可用宽度约束；未传时取方向对应的 Popup 主题值，再回退到左侧/右侧 280、居中 240。其他方向不支持。 | 否 |
| height | double? | - | 面板高度，受可用高度约束；底部包含头部，居中不包含面板外关闭区。未传时取方向对应的 Popup 主题值，再回退到 240；仅顶部/底部/居中支持。 | 否 |
| closeBuilder | TPopupSlotBuilder? | - | 居中面板外下方关闭区，不计入 `height`，与间距一起占用额外高度；未指定时不显示，按钮由 builder 提供。 | 否 |
| radius | double? | - | 顶部/底部/居中默认取主题大圆角，左侧/右侧默认无圆角；显式值或 `TPopupThemeData.panelRadius` 可覆盖。 | 否 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层配置；未指定时显示蒙层、拦截背景交互并支持点击关闭。 | 否 |
| destroyOnClose | bool | false | 为 true 时，被其他不透明路由覆盖可释放内容状态；关闭后始终释放，再次打开创建新状态。 | 否 |
| animationDuration | Duration? | - | 打开/关闭动画时长；未指定时使用 240ms。 | 否 |
| onOpened | VoidCallback? | - | 打开动画结束后触发。 | 否 |
| onClosed | VoidCallback? | - | 关闭动画结束后触发；非栈顶浮层直接移除时在路由释放时触发。关闭完成前重新 `TPopupHandle.open`，旧周期不触发。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 打开时同步触发 true，开始关闭时触发 false，均不等待动画结束；第二个参数为 `TPopupTrigger`。 | 否 |
| useSafeArea | bool | false | 避让安全区：顶部仅上边，底部仅下边，左侧避让左/上/下边，右侧避让右/上/下边，居中避让全部边；与 `inset` 叠加。仅内容需避让时可在 `child` 中使用 `SafeArea`。 | 否 |


##### TPopupOptions.left

```dart
factory TPopupOptions.left({
  required Widget child,
  double? width,
  TPopupLeftInset? inset,
  double? radius,
  Color? backgroundColor,
  TPopupOverlayConfig? overlay,
  bool destroyOnClose = false,
  Duration? animationDuration,
  VoidCallback? onOpened,
  VoidCallback? onClosed,
  TPopupVisibleChangeCallback? onVisibleChange,
  bool useSafeArea = false,
})
```


左侧弹出配置。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 面板内容，占用面板内可用空间；底部有头部时占用剩余高度。长内容需自行使用滚动组件。 | 是 |
| width | double? | - | 面板宽度，受可用宽度约束；未传时取方向对应的 Popup 主题值，再回退到左侧/右侧 280、居中 240。其他方向不支持。 | 否 |
| inset | TPopupLeftInset? | - | 交叉轴留白；须使用当前方向的 Inset 类型，居中不支持。 | 否 |
| radius | double? | - | 顶部/底部/居中默认取主题大圆角，左侧/右侧默认无圆角；显式值或 `TPopupThemeData.panelRadius` 可覆盖。 | 否 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层配置；未指定时显示蒙层、拦截背景交互并支持点击关闭。 | 否 |
| destroyOnClose | bool | false | 为 true 时，被其他不透明路由覆盖可释放内容状态；关闭后始终释放，再次打开创建新状态。 | 否 |
| animationDuration | Duration? | - | 打开/关闭动画时长；未指定时使用 240ms。 | 否 |
| onOpened | VoidCallback? | - | 打开动画结束后触发。 | 否 |
| onClosed | VoidCallback? | - | 关闭动画结束后触发；非栈顶浮层直接移除时在路由释放时触发。关闭完成前重新 `TPopupHandle.open`，旧周期不触发。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 打开时同步触发 true，开始关闭时触发 false，均不等待动画结束；第二个参数为 `TPopupTrigger`。 | 否 |
| useSafeArea | bool | false | 避让安全区：顶部仅上边，底部仅下边，左侧避让左/上/下边，右侧避让右/上/下边，居中避让全部边；与 `inset` 叠加。仅内容需避让时可在 `child` 中使用 `SafeArea`。 | 否 |


##### TPopupOptions.right

```dart
factory TPopupOptions.right({
  required Widget child,
  double? width,
  TPopupRightInset? inset,
  double? radius,
  Color? backgroundColor,
  TPopupOverlayConfig? overlay,
  bool destroyOnClose = false,
  Duration? animationDuration,
  VoidCallback? onOpened,
  VoidCallback? onClosed,
  TPopupVisibleChangeCallback? onVisibleChange,
  bool useSafeArea = false,
})
```


右侧弹出配置。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 面板内容，占用面板内可用空间；底部有头部时占用剩余高度。长内容需自行使用滚动组件。 | 是 |
| width | double? | - | 面板宽度，受可用宽度约束；未传时取方向对应的 Popup 主题值，再回退到左侧/右侧 280、居中 240。其他方向不支持。 | 否 |
| inset | TPopupRightInset? | - | 交叉轴留白；须使用当前方向的 Inset 类型，居中不支持。 | 否 |
| radius | double? | - | 顶部/底部/居中默认取主题大圆角，左侧/右侧默认无圆角；显式值或 `TPopupThemeData.panelRadius` 可覆盖。 | 否 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层配置；未指定时显示蒙层、拦截背景交互并支持点击关闭。 | 否 |
| destroyOnClose | bool | false | 为 true 时，被其他不透明路由覆盖可释放内容状态；关闭后始终释放，再次打开创建新状态。 | 否 |
| animationDuration | Duration? | - | 打开/关闭动画时长；未指定时使用 240ms。 | 否 |
| onOpened | VoidCallback? | - | 打开动画结束后触发。 | 否 |
| onClosed | VoidCallback? | - | 关闭动画结束后触发；非栈顶浮层直接移除时在路由释放时触发。关闭完成前重新 `TPopupHandle.open`，旧周期不触发。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 打开时同步触发 true，开始关闭时触发 false，均不等待动画结束；第二个参数为 `TPopupTrigger`。 | 否 |
| useSafeArea | bool | false | 避让安全区：顶部仅上边，底部仅下边，左侧避让左/上/下边，右侧避让右/上/下边，居中避让全部边；与 `inset` 叠加。仅内容需避让时可在 `child` 中使用 `SafeArea`。 | 否 |


##### TPopupOptions.top

```dart
factory TPopupOptions.top({
  required Widget child,
  double? height,
  TPopupTopInset? inset,
  double? radius,
  Color? backgroundColor,
  TPopupOverlayConfig? overlay,
  bool destroyOnClose = false,
  Duration? animationDuration,
  VoidCallback? onOpened,
  VoidCallback? onClosed,
  TPopupVisibleChangeCallback? onVisibleChange,
  bool useSafeArea = false,
})
```


顶部弹出配置。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 面板内容，占用面板内可用空间；底部有头部时占用剩余高度。长内容需自行使用滚动组件。 | 是 |
| height | double? | - | 面板高度，受可用高度约束；底部包含头部，居中不包含面板外关闭区。未传时取方向对应的 Popup 主题值，再回退到 240；仅顶部/底部/居中支持。 | 否 |
| inset | TPopupTopInset? | - | 交叉轴留白；须使用当前方向的 Inset 类型，居中不支持。 | 否 |
| radius | double? | - | 顶部/底部/居中默认取主题大圆角，左侧/右侧默认无圆角；显式值或 `TPopupThemeData.panelRadius` 可覆盖。 | 否 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层配置；未指定时显示蒙层、拦截背景交互并支持点击关闭。 | 否 |
| destroyOnClose | bool | false | 为 true 时，被其他不透明路由覆盖可释放内容状态；关闭后始终释放，再次打开创建新状态。 | 否 |
| animationDuration | Duration? | - | 打开/关闭动画时长；未指定时使用 240ms。 | 否 |
| onOpened | VoidCallback? | - | 打开动画结束后触发。 | 否 |
| onClosed | VoidCallback? | - | 关闭动画结束后触发；非栈顶浮层直接移除时在路由释放时触发。关闭完成前重新 `TPopupHandle.open`，旧周期不触发。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 打开时同步触发 true，开始关闭时触发 false，均不等待动画结束；第二个参数为 `TPopupTrigger`。 | 否 |
| useSafeArea | bool | false | 避让安全区：顶部仅上边，底部仅下边，左侧避让左/上/下边，右侧避让右/上/下边，居中避让全部边；与 `inset` 叠加。仅内容需避让时可在 `child` 中使用 `SafeArea`。 | 否 |

#### 默认构造方法


```dart
const TPopupOptions({
  required this.child,
  this.placement = TPopupPlacement.bottom,
  this.width,
  this.height,
  this.inset,
  this.radius,
  this.backgroundColor,
  this.overlay,
  this.destroyOnClose = false,
  this.animationDuration,
  this.headerBuilder,
  this.closeBuilder,
  this.onOpened,
  this.onClosed,
  this.onVisibleChange,
  this.useSafeArea = false,
})
```

通过 `placement` 指定方向。

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| animationDuration | Duration? | - | 打开/关闭动画时长；未指定时使用 240ms。 | 否 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 | 否 |
| child | Widget | - | 面板内容，占用面板内可用空间；底部有头部时占用剩余高度。长内容需自行使用滚动组件。 | 是 |
| closeBuilder | TPopupSlotBuilder? | - | 居中面板外下方关闭区，不计入 `height`，与间距一起占用额外高度；未指定时不显示，按钮由 builder 提供。 | 否 |
| destroyOnClose | bool | false | 为 true 时，被其他不透明路由覆盖可释放内容状态；关闭后始终释放，再次打开创建新状态。 | 否 |
| headerBuilder | TPopupHeaderBuilder? | - | 底部头部，占用 `height` 内的空间；未指定时不显示，可用 `TPopupHeader` 组合标题与操作按钮。 | 否 |
| height | double? | - | 面板高度，受可用高度约束；底部包含头部，居中不包含面板外关闭区。未传时取方向对应的 Popup 主题值，再回退到 240；仅顶部/底部/居中支持。 | 否 |
| inset | TPopupInset? | - | 交叉轴留白；须使用当前方向的 Inset 类型，居中不支持。 | 否 |
| onClosed | VoidCallback? | - | 关闭动画结束后触发；非栈顶浮层直接移除时在路由释放时触发。关闭完成前重新 `TPopupHandle.open`，旧周期不触发。 | 否 |
| onOpened | VoidCallback? | - | 打开动画结束后触发。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 打开时同步触发 true，开始关闭时触发 false，均不等待动画结束；第二个参数为 `TPopupTrigger`。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层配置；未指定时显示蒙层、拦截背景交互并支持点击关闭。 | 否 |
| placement | TPopupPlacement | TPopupPlacement.bottom | 弹出方向。 | 否 |
| radius | double? | - | 顶部/底部/居中默认取主题大圆角，左侧/右侧默认无圆角；显式值或 `TPopupThemeData.panelRadius` 可覆盖。 | 否 |
| useSafeArea | bool | false | 避让安全区：顶部仅上边，底部仅下边，左侧避让左/上/下边，右侧避让右/上/下边，居中避让全部边；与 `inset` 叠加。仅内容需避让时可在 `child` 中使用 `SafeArea`。 | 否 |
| width | double? | - | 面板宽度，受可用宽度约束；未传时取方向对应的 Popup 主题值，再回退到左侧/右侧 280、居中 240。其他方向不支持。 | 否 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| overlayConfig | TPopupOverlayConfig | - | 解析后的蒙层配置；未传时使用默认值。 |


#### 实例方法

##### TPopupOptions.assertPlacementParams

```dart
void assertPlacementParams()
```


检查参数与方向是否匹配。
| 模式 | 行为 |
| --- | --- |
| debug | 无效组合抛出 `FlutterError` |
| release | 不执行检查 |

返回类型：`void`

##### TPopupOptions.copyWith

```dart
TPopupOptions copyWith({
  Widget? child,
  TPopupPlacement? placement,
  Object? width = _unset,
  Object? height = _unset,
  Object? inset = _unset,
  Object? radius = _unset,
  Object? backgroundColor = _unset,
  Object? overlay = _unset,
  bool? destroyOnClose,
  Duration? animationDuration,
  Object? headerBuilder = _unset,
  Object? closeBuilder = _unset,
  Object? onOpened = _unset,
  Object? onClosed = _unset,
  Object? onVisibleChange = _unset,
  bool? useSafeArea,
})
```


复制配置。
## 返回值
应用指定参数后的配置副本。

返回类型：`TPopupOptions`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget? | - | 非空值替换原配置；不传或 null 保留原值。 | 否 |
| placement | TPopupPlacement? | - | 非空值替换原配置；不传或 null 保留原值。 | 否 |
| width | Object? | _unset | 不传时保留原值；显式 null 清除本字段，非空值须为 num。 | 否 |
| height | Object? | _unset | 不传时保留原值；显式 null 清除本字段，非空值须为 num。 | 否 |
| inset | Object? | _unset | 不传时保留原值；显式 null 清除本字段，非空值须为 TPopupInset。 | 否 |
| radius | Object? | _unset | 不传时保留原值；显式 null 清除本字段，非空值须为 num。 | 否 |
| backgroundColor | Object? | _unset | 不传时保留原值；显式 null 清除本字段，非空值须为 Color。 | 否 |
| overlay | Object? | _unset | 不传时保留原值；显式 null 清除本字段，非空值须为 TPopupOverlayConfig。 | 否 |
| destroyOnClose | bool? | - | 非空值替换原配置；不传或 null 保留原值。 | 否 |
| animationDuration | Duration? | - | 非空值替换原配置；不传或 null 保留原值。 | 否 |
| headerBuilder | Object? | _unset | 不传时保留原值；显式 null 清除本字段，非空值须为 TPopupHeaderBuilder。 | 否 |
| closeBuilder | Object? | _unset | 不传时保留原值；显式 null 清除本字段，非空值须为 TPopupSlotBuilder。 | 否 |
| onOpened | Object? | _unset | 不传时保留原值；显式 null 清除本字段，非空值须为 VoidCallback。 | 否 |
| onClosed | Object? | _unset | 不传时保留原值；显式 null 清除本字段，非空值须为 VoidCallback。 | 否 |
| onVisibleChange | Object? | _unset | 不传时保留原值；显式 null 清除本字段，非空值须为 TPopupVisibleChangeCallback。 | 否 |
| useSafeArea | bool? | - | 非空值替换原配置；不传或 null 保留原值。 | 否 |


##### TPopupOptions.normalized

```dart
TPopupOptions normalized()
```


按方向整理配置。
| 字段 | 保留条件 | 不满足时 |
| --- | --- | --- |
| `headerBuilder` | 底部 | 清除 |
| `closeBuilder` | 居中 | 清除 |
| 其他参数 | 所有方向 | 保持原值 |
## 返回值
保留当前方向适用插槽的配置副本。

返回类型：`TPopupOptions`

### TPopupHandle
#### 简介
`TPopup.show` 的返回值，用于控制同一份 `TPopupOptions` 的多次打开与关闭。

#### 声明

```dart
class TPopupHandle
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| isShowing | bool | - | 浮层仍在路由栈中且未开始关闭时为 true。 |
| navigatorContext | BuildContext? | - | 与 `TPopup.show` 的 `navigatorContext` 相同。 |
| options | TPopupOptions | - | `TPopup.show` 合并显式配置与 `TPopupThemeData` 后的配置；重新 `open` 不重新解析已合并的主题值，并按 `TPopupOptions.placement` 裁剪无效字段。 |
| result | Future&lt;Object?&gt; | - | 本次打开的路由结果；关闭时完成，不等待关闭动画结束，动画完成通知见 `TPopupOptions.onClosed`。 每次成功 `open` 都会创建新的 Future；应在对应的 `open` 之后读取。 |
| themeContext | BuildContext | - | 用于捕获调用点局部 Theme 的 context。 |
| useRootNavigator | bool | - | 与 `TPopup.show` 的 `useRootNavigator` 相同。 |


#### 实例方法

##### TPopupHandle.close

```dart
void close([Object? result])
```


关闭此句柄对应的浮层，触发源为 `TPopupTrigger.api`。
| 状态 | 行为 |
| --- | --- |
| 未展示或已开始关闭 | 不执行操作 |
| 位于栈顶 | 返回上一层，执行关闭动画 |
| 位于其他浮层下方 | 直接移除此层，保留其他浮层 |

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| result | Object? | - | 关闭浮层时返回的业务结果；通过该句柄的 result Future 接收。 | 否 |


##### TPopupHandle.open

```dart
void open([BuildContext? context])
```


打开或重新打开浮层。
| 状态 | 行为 |
| --- | --- |
| 已展示 | 不重复打开 |
| Navigator 可用 | 打开浮层，创建新的 `result` Future |
| 无可用 Navigator | debug 触发断言，release 返回 |
| 参数与方向不匹配 | debug / release 均抛出 `FlutterError` |

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext? | - | 导航上下文；未指定或无效时依次尝试缓存的 Navigator、`navigatorContext`。有效时重新捕获此处的内容 Theme，否则使用 `themeContext`；不重新解析 `options` 中已合并的 Popup 主题值。 | 否 |


### TPopupOverlayConfig
#### 简介
蒙层配置。
| showOverlay | preventTap | 行为 |
| --- | --- | --- |
| true | true | 显示蒙层、拦截背景交互；支持点击回调和关闭 |
| true | false | 显示蒙层，背景可交互；不接收蒙层点击 |
| false | true | 无可见蒙层，拦截背景交互；不支持蒙层点击关闭 |
| false | false | 无可见蒙层，背景可交互 |

#### 声明

```dart
class TPopupOverlayConfig
```

#### 默认构造方法


```dart
const TPopupOverlayConfig({
  this.showOverlay = true,
  this.color,
  this.preventTap = true,
  this.closeOnClick,
  this.onClick,
})
```

创建蒙层配置。

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| closeOnClick | bool? | - | 点击蒙层是否关闭；仅显示蒙层且拦截交互时生效，未指定时为 true。 | 否 |
| color | Color? | - | 蒙层颜色（含透明度）；未指定时取 `TPopupThemeData.barrierColor`，再回退到 black54。 | 否 |
| onClick | VoidCallback? | - | 蒙层点击回调；仅显示蒙层且拦截交互时触发，是否关闭由 `closeOnClick` 决定。 | 否 |
| preventTap | bool | true | 是否拦截背景交互。 | 否 |
| showOverlay | bool | true | 是否显示可见蒙层。 | 否 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| effectiveCloseOnClick | bool | - | 实际是否支持蒙层点击关闭；无可见蒙层或允许穿透时为 false，否则取 `closeOnClick`（未指定为 true）。 |


### TPopupInset
#### 简介
Popup 在交叉轴方向的边缘留白基类。

#### 声明

```dart
abstract class TPopupInset
```

#### 默认构造方法


```dart
const TPopupInset()
```


### TPopupBottomInset
#### 简介
bottom 方向的左右留白。

#### 声明

```dart
class TPopupBottomInset extends TPopupInset
```

#### 默认构造方法


```dart
const TPopupBottomInset({this.left = 0, this.right = 0})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| left | double | 0 | 左侧留白 | 否 |
| right | double | 0 | 右侧留白 | 否 |


### TPopupTopInset
#### 简介
top 方向的左右留白。

#### 声明

```dart
class TPopupTopInset extends TPopupInset
```

#### 默认构造方法


```dart
const TPopupTopInset({this.left = 0, this.right = 0})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| left | double | 0 | 左侧留白 | 否 |
| right | double | 0 | 右侧留白 | 否 |


### TPopupLeftInset
#### 简介
left 方向的上下留白。

#### 声明

```dart
class TPopupLeftInset extends TPopupInset
```

#### 默认构造方法


```dart
const TPopupLeftInset({this.top = 0, this.bottom = 0})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| bottom | double | 0 | 底部留白 | 否 |
| top | double | 0 | 顶部留白 | 否 |


### TPopupRightInset
#### 简介
right 方向的上下留白。

#### 声明

```dart
class TPopupRightInset extends TPopupInset
```

#### 默认构造方法


```dart
const TPopupRightInset({this.top = 0, this.bottom = 0})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| bottom | double | 0 | 底部留白 | 否 |
| top | double | 0 | 顶部留白 | 否 |


### TPopupThemeData
#### 简介
Popup 子树默认样式，通过 Theme.extensions 注入。
| 配置来源 | 优先级 |
| --- | --- |
| TPopupOptions 显式值 | 最高 |
| TPopupThemeData | 其次 |
| 组件默认值 | 最后 |

#### 声明

```dart
class TPopupThemeData extends ThemeExtension<TPopupThemeData>
```


#### 静态方法

##### TPopupThemeData.lerpDouble

```dart
static double? lerpDouble(double? a, double? b, double t)
```


数值线性插值。
| 输入 | 结果 |
| --- | --- |
| 两端均为 null | null |
| 一端为 null | 该端按 0 计算 |
| 两端均非空 | 按 `t` 线性插值 |
## 返回值
插值结果；两端均为 null 时返回 null。

返回类型：`double?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| a | double? | - | 起始值。 | 是 |
| b | double? | - | 目标值。 | 是 |
| t | double | - | 插值进度。 | 是 |

#### 默认构造方法


```dart
const TPopupThemeData({
  this.barrierColor,
  this.panelRadius,
  this.panelBackgroundColor,
  this.edgeHeight,
  this.drawerWidth,
  this.centerSize,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| barrierColor | Color? | - | 蒙层颜色，透明度直接由 `Color` 的 alpha 指定。 | 否 |
| centerSize | Size? | - | center 未显式传入宽高时的默认面板尺寸 | 否 |
| drawerWidth | double? | - | left / right 未显式传入宽度时的默认抽屉宽度 | 否 |
| edgeHeight | double? | - | top / bottom 未显式传入高度时的默认面板高度 | 否 |
| panelBackgroundColor | Color? | - | 内容区背景色 | 否 |
| panelRadius | double? | - | 面板圆角；未指定时顶部/底部/居中取全局主题大圆角，左侧/右侧无圆角。 | 否 |


#### 实例方法

##### TPopupThemeData.copyWith

```dart
TPopupThemeData copyWith({
  Color? barrierColor,
  double? panelRadius,
  Color? panelBackgroundColor,
  double? edgeHeight,
  double? drawerWidth,
  Size? centerSize,
})
```


复制主题；非空参数替换对应配置，null 参数保留当前配置。
## 返回值
应用指定参数后的主题副本。

返回类型：`TPopupThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| barrierColor | Color? | - | 蒙层颜色（含透明度）。 | 否 |
| panelRadius | double? | - | 面板圆角。 | 否 |
| panelBackgroundColor | Color? | - | 面板背景色。 | 否 |
| edgeHeight | double? | - | 顶部/底部面板高度。 | 否 |
| drawerWidth | double? | - | 左侧/右侧面板宽度。 | 否 |
| centerSize | Size? | - | 居中面板尺寸。 | 否 |


##### TPopupThemeData.lerp

```dart
TPopupThemeData lerp(ThemeExtension<TPopupThemeData>? other, double t)
```


按 `t` 对主题进行插值。
## 返回值
过渡主题；目标为空或类型不匹配时返回当前对象。

返回类型：`TPopupThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TPopupThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


##### TPopupThemeData.merge

```dart
TPopupThemeData merge(TPopupThemeData? other)
```


合并主题；`other` 的非空字段优先，空字段保留当前值。
## 返回值
合并后的主题；`other` 为空时返回当前对象。

返回类型：`TPopupThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TPopupThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


### TPopupPlacement
#### 简介
`TPopupOptions.placement` 的弹出方向。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| top | 顶部滑入。 |
| left | 左侧滑入。 |
| right | 右侧滑入。 |
| bottom | 底部滑入。 |
| center | 屏幕居中。 |


### TPopupTrigger
#### 简介
`TPopupVisibleChangeCallback` 的触发来源。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| overlay | 点击蒙层，且 `TPopupOverlayConfig.effectiveCloseOnClick` 为 true。 |
| close | 居中关闭区 builder 调用 close。 |
| api | 外部 API 主动触发的显隐变化，如 `TPopupHandle.close` 或打开事件。 |
| systemBack | 系统返回键或系统路由返回触发的关闭。 |
| custom | 头部 builder 调用 close 等自定义关闭。 |


### TPopupHeaderBuilder
#### 简介
底部头部构建器。
`context` 构建上下文。
`close` 关闭 Popup，触发源为 `TPopupTrigger.custom`。
## 返回值
构建的底部头部内容。
#### 类型定义

```dart
typedef TPopupHeaderBuilder = Widget Function(BuildContext context, VoidCallback close);
```


### TPopupSlotBuilder
#### 简介
居中面板外关闭区构建器；交互与无障碍语义由 builder 提供。
`context` 构建上下文。
`close` 关闭 Popup，触发源为 `TPopupTrigger.close`。
## 返回值
构建的面板外关闭区内容。
#### 类型定义

```dart
typedef TPopupSlotBuilder = Widget Function(BuildContext context, VoidCallback close);
```


### TPopupVisibleChangeCallback
#### 简介
浮层显隐变化回调。
`visible` true 表示打开，false 表示开始关闭。
`trigger` 触发来源；打开时为 `TPopupTrigger.api`。
## 返回值
无返回值。
#### 类型定义

```dart
typedef TPopupVisibleChangeCallback = void Function(bool visible, TPopupTrigger trigger);
```

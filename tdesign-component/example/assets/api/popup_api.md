## API

### TPopup

弹出层入口：五向滑入 / 居中弹出，支持蒙层、可选 bottom 头部和
可选 center 面板外下方关闭区。

通过 `show` 命令式打开；返回 `TPopupHandle` 用于关闭与再次打开。
多次调用 `show` 会继续压入新的浮层路由，可用于叠加展示。

配置项见 `TPopupOptions`；方向见 `TPopupPlacement`。

#### 静态方法

##### TPopup.show

位置参数：`context`


打开浮层并压入独立 `PopupRoute`。

返回 `TPopupHandle`，可用 `TPopupHandle.close`、`TPopupHandle.open`、
`TPopupHandle.isShowing` 控制与查询。
重复调用会继续 push 新的浮层；若需互斥请在业务层管理。

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 `Navigator` 并展示浮层。 | 是 |
| options | TPopupOptions | - | 浮层配置；方向固定时推荐 `TPopupOptions.bottom` 等命名工厂。 | 是 |
| navigatorContext | BuildContext? | - | 可选，指定承载浮层的 `Navigator` 的 context，默认 `context`。 | 否 |
| useRootNavigator | bool | false | 为 true 时使用根 `Navigator`（嵌套导航场景）。 | 否 |


### TPopupHeader

Popup 标准头部布局。

本组件只负责取消按钮、标题和确认按钮的布局，不注入默认内容或业务行为。
需要关闭 Popup 时，在 `TPopupOptions.headerBuilder` 中构建按钮并调用其 `close` 参数。

#### 构造方法

##### TPopupHeader

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

`TPopup.show` 的配置对象。

#### 使用说明

生命周期回调见 `onOpened`、`onClosed`、`onVisibleChange`；
蒙层行为见 `overlay`（`TPopupOverlayConfig`）。
单次打开的显式尺寸、面板颜色、圆角及蒙层颜色优先于
`TPopupThemeData` 的子树默认值；动画时长未指定时使用 240 毫秒。

##### 构造方式选择

| 场景 | 推荐用法 |
|------|----------|
| 弹出方向已知 | `TPopupOptions.bottom`、`TPopupOptions.center`、`TPopupOptions.top`、`TPopupOptions.left`、`TPopupOptions.right` |
| 方向由变量决定 | 默认构造并设置 `placement`；传错字段会在 `TPopup.show` / `TPopupHandle.open` 时抛 `FlutterError` |

命名工厂只暴露当前方向生效的字段（例如 `TPopupOptions.bottom` 无 `width` 参数）。

##### 不同弹出方向的可用参数

| `TPopupPlacement` | 头部 / 关闭区 | 尺寸 |
|-------------------|-------------|------|
| `TPopupPlacement.bottom` | `headerBuilder` | `height`、`inset` |
| `TPopupPlacement.center` | `closeBuilder` | `width`、`height` |
| `TPopupPlacement.top` | — | `height`、`inset` |
| `TPopupPlacement.left`、`TPopupPlacement.right` | — | `width`、`inset` |

`headerBuilder` 与 `closeBuilder` 默认均为 `null`，基础 Popup 只渲染
`child`。显式提供 builder 时才会渲染相应区域，builder 可调用 `close`
关闭浮层。

#### 构造方法

##### TPopupOptions

通用构造；`placement` 在运行时才能确定时使用。

方向已知时请优先使用 `TPopupOptions.bottom` 等命名工厂。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| animationDuration | Duration? | - | 打开/关闭动画时长，默认 240ms（与小程序公开 duration 默认值一致）。 | 否 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 | 否 |
| child | Widget | - | 浮层主体内容（必填）。 | 是 |
| closeBuilder | TPopupSlotBuilder? | - | center 面板外下方关闭区；仅 `TPopupPlacement.center` 生效，默认不显示。 builder 的 `close` 参数只负责关闭 Popup，不会自动生成关闭按钮。 | 否 |
| destroyOnClose | bool | false | 为 true 时路由 maintainState 为 false，被其他不透明路由覆盖时可释放内容 State。 关闭路由后无论本字段取值如何，内容 State 都会释放；再次打开会创建新 State。 | 否 |
| headerBuilder | TPopupHeaderBuilder? | - | bottom 头部；仅 `TPopupPlacement.bottom` 生效，默认不显示。 可返回 `TPopupHeader` 组合取消按钮、标题和确认按钮；builder 的 `close` 参数只负责关闭 Popup，不会自动生成任何按钮。 | 否 |
| height | double? | - | 高度；`TPopupPlacement.top`、`TPopupPlacement.bottom` 生效；`TPopupPlacement.center` 约束面板尺寸。 top / bottom 未传时默认 240；center 未传时默认 240。 | 否 |
| inset | TPopupInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 | 否 |
| onClosed | VoidCallback? | - | 当前展示周期真正结束。 大多数场景下会在关闭动画结束后触发；非栈顶路由被直接移除时不保证存在关闭动画。 | 否 |
| onOpened | VoidCallback? | - | 打开动画结束。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化；第二个参数为 `TPopupTrigger`。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层行为配置；为 null 时使用 `TPopupOverlayConfig` 默认值（标准模态弹层）。 | 否 |
| placement | TPopupPlacement | TPopupPlacement.bottom | 出现位置，默认 `TPopupPlacement.bottom`。 | 否 |
| radius | double? | - | 内容区圆角。 `TPopupPlacement.top`、`TPopupPlacement.bottom`、`TPopupPlacement.center` 默认取主题大圆角；`TPopupPlacement.left`、`TPopupPlacement.right` 默认**无圆角**（对齐官方全高矩形），仅当显式设置本字段或通过 `TPopupThemeData.panelRadius` 注入时应用圆角。 | 否 |
| useSafeArea | bool | false | 是否避让系统安全区，默认 false；center 使用完整安全区，其他方向避让贴边侧及相邻边。 为 true 时通过 `Positioned` 偏移使面板不侵入刘海、Home Indicator 等区域； top/bottom/left/right 还会与对应 `inset` 叠加。需要避让时显式设为 true； 也可以在 `child` 内使用 Flutter 原生 `SafeArea`，只约束内容而保留面板背景贴边。 | 否 |
| width | double? | - | 宽度；`TPopupPlacement.left`、`TPopupPlacement.right`、`TPopupPlacement.center` 生效。 left / right 未传时默认 280；center 未传时默认 240。 | 否 |


##### TPopupOptions.bottom

创建 `TPopupPlacement.bottom` 配置。

固定 `placement` 为 `TPopupPlacement.bottom`；默认不显示头部。
蒙层、动画、生命周期等字段语义见同名成员文档。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 浮层主体内容（必填）。 | 是 |
| height | double? | - | 高度；`TPopupPlacement.top`、`TPopupPlacement.bottom` 生效；`TPopupPlacement.center` 约束面板尺寸。 top / bottom 未传时默认 240；center 未传时默认 240。 | 否 |
| inset | TPopupBottomInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 | 否 |
| headerBuilder | TPopupHeaderBuilder? | - | bottom 头部；仅 `TPopupPlacement.bottom` 生效，默认不显示。 可返回 `TPopupHeader` 组合取消按钮、标题和确认按钮；builder 的 `close` 参数只负责关闭 Popup，不会自动生成任何按钮。 | 否 |
| radius | double? | - | 内容区圆角。 `TPopupPlacement.top`、`TPopupPlacement.bottom`、`TPopupPlacement.center` 默认取主题大圆角；`TPopupPlacement.left`、`TPopupPlacement.right` 默认**无圆角**（对齐官方全高矩形），仅当显式设置本字段或通过 `TPopupThemeData.panelRadius` 注入时应用圆角。 | 否 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层行为配置；为 null 时使用 `TPopupOverlayConfig` 默认值（标准模态弹层）。 | 否 |
| destroyOnClose | bool | false | 为 true 时路由 maintainState 为 false，被其他不透明路由覆盖时可释放内容 State。 关闭路由后无论本字段取值如何，内容 State 都会释放；再次打开会创建新 State。 | 否 |
| animationDuration | Duration? | - | 打开/关闭动画时长，默认 240ms（与小程序公开 duration 默认值一致）。 | 否 |
| onOpened | VoidCallback? | - | 打开动画结束。 | 否 |
| onClosed | VoidCallback? | - | 当前展示周期真正结束。 大多数场景下会在关闭动画结束后触发；非栈顶路由被直接移除时不保证存在关闭动画。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化；第二个参数为 `TPopupTrigger`。 | 否 |
| useSafeArea | bool | false | 是否避让系统安全区，默认 false；center 使用完整安全区，其他方向避让贴边侧及相邻边。 为 true 时通过 `Positioned` 偏移使面板不侵入刘海、Home Indicator 等区域； top/bottom/left/right 还会与对应 `inset` 叠加。需要避让时显式设为 true； 也可以在 `child` 内使用 Flutter 原生 `SafeArea`，只约束内容而保留面板背景贴边。 | 否 |


##### TPopupOptions.center

创建 `TPopupPlacement.center` 配置。

固定 `placement` 为 `TPopupPlacement.center`；默认不显示关闭按钮。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 浮层主体内容（必填）。 | 是 |
| width | double? | - | 宽度；`TPopupPlacement.left`、`TPopupPlacement.right`、`TPopupPlacement.center` 生效。 left / right 未传时默认 280；center 未传时默认 240。 | 否 |
| height | double? | - | 高度；`TPopupPlacement.top`、`TPopupPlacement.bottom` 生效；`TPopupPlacement.center` 约束面板尺寸。 top / bottom 未传时默认 240；center 未传时默认 240。 | 否 |
| closeBuilder | TPopupSlotBuilder? | - | center 面板外下方关闭区；仅 `TPopupPlacement.center` 生效，默认不显示。 builder 的 `close` 参数只负责关闭 Popup，不会自动生成关闭按钮。 | 否 |
| radius | double? | - | 内容区圆角。 `TPopupPlacement.top`、`TPopupPlacement.bottom`、`TPopupPlacement.center` 默认取主题大圆角；`TPopupPlacement.left`、`TPopupPlacement.right` 默认**无圆角**（对齐官方全高矩形），仅当显式设置本字段或通过 `TPopupThemeData.panelRadius` 注入时应用圆角。 | 否 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层行为配置；为 null 时使用 `TPopupOverlayConfig` 默认值（标准模态弹层）。 | 否 |
| destroyOnClose | bool | false | 为 true 时路由 maintainState 为 false，被其他不透明路由覆盖时可释放内容 State。 关闭路由后无论本字段取值如何，内容 State 都会释放；再次打开会创建新 State。 | 否 |
| animationDuration | Duration? | - | 打开/关闭动画时长，默认 240ms（与小程序公开 duration 默认值一致）。 | 否 |
| onOpened | VoidCallback? | - | 打开动画结束。 | 否 |
| onClosed | VoidCallback? | - | 当前展示周期真正结束。 大多数场景下会在关闭动画结束后触发；非栈顶路由被直接移除时不保证存在关闭动画。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化；第二个参数为 `TPopupTrigger`。 | 否 |
| useSafeArea | bool | false | 是否避让系统安全区，默认 false；center 使用完整安全区，其他方向避让贴边侧及相邻边。 为 true 时通过 `Positioned` 偏移使面板不侵入刘海、Home Indicator 等区域； top/bottom/left/right 还会与对应 `inset` 叠加。需要避让时显式设为 true； 也可以在 `child` 内使用 Flutter 原生 `SafeArea`，只约束内容而保留面板背景贴边。 | 否 |


##### TPopupOptions.left

创建 `TPopupPlacement.left` 配置。

固定 `placement` 为 `TPopupPlacement.left`；未传 `width` 时布局默认宽度 280。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 浮层主体内容（必填）。 | 是 |
| width | double? | - | 宽度；`TPopupPlacement.left`、`TPopupPlacement.right`、`TPopupPlacement.center` 生效。 left / right 未传时默认 280；center 未传时默认 240。 | 否 |
| inset | TPopupLeftInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 | 否 |
| radius | double? | - | 内容区圆角。 `TPopupPlacement.top`、`TPopupPlacement.bottom`、`TPopupPlacement.center` 默认取主题大圆角；`TPopupPlacement.left`、`TPopupPlacement.right` 默认**无圆角**（对齐官方全高矩形），仅当显式设置本字段或通过 `TPopupThemeData.panelRadius` 注入时应用圆角。 | 否 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层行为配置；为 null 时使用 `TPopupOverlayConfig` 默认值（标准模态弹层）。 | 否 |
| destroyOnClose | bool | false | 为 true 时路由 maintainState 为 false，被其他不透明路由覆盖时可释放内容 State。 关闭路由后无论本字段取值如何，内容 State 都会释放；再次打开会创建新 State。 | 否 |
| animationDuration | Duration? | - | 打开/关闭动画时长，默认 240ms（与小程序公开 duration 默认值一致）。 | 否 |
| onOpened | VoidCallback? | - | 打开动画结束。 | 否 |
| onClosed | VoidCallback? | - | 当前展示周期真正结束。 大多数场景下会在关闭动画结束后触发；非栈顶路由被直接移除时不保证存在关闭动画。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化；第二个参数为 `TPopupTrigger`。 | 否 |
| useSafeArea | bool | false | 是否避让系统安全区，默认 false；center 使用完整安全区，其他方向避让贴边侧及相邻边。 为 true 时通过 `Positioned` 偏移使面板不侵入刘海、Home Indicator 等区域； top/bottom/left/right 还会与对应 `inset` 叠加。需要避让时显式设为 true； 也可以在 `child` 内使用 Flutter 原生 `SafeArea`，只约束内容而保留面板背景贴边。 | 否 |


##### TPopupOptions.right

创建 `TPopupPlacement.right` 配置。

固定 `placement` 为 `TPopupPlacement.right`；未传 `width` 时布局默认宽度 280。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 浮层主体内容（必填）。 | 是 |
| width | double? | - | 宽度；`TPopupPlacement.left`、`TPopupPlacement.right`、`TPopupPlacement.center` 生效。 left / right 未传时默认 280；center 未传时默认 240。 | 否 |
| inset | TPopupRightInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 | 否 |
| radius | double? | - | 内容区圆角。 `TPopupPlacement.top`、`TPopupPlacement.bottom`、`TPopupPlacement.center` 默认取主题大圆角；`TPopupPlacement.left`、`TPopupPlacement.right` 默认**无圆角**（对齐官方全高矩形），仅当显式设置本字段或通过 `TPopupThemeData.panelRadius` 注入时应用圆角。 | 否 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层行为配置；为 null 时使用 `TPopupOverlayConfig` 默认值（标准模态弹层）。 | 否 |
| destroyOnClose | bool | false | 为 true 时路由 maintainState 为 false，被其他不透明路由覆盖时可释放内容 State。 关闭路由后无论本字段取值如何，内容 State 都会释放；再次打开会创建新 State。 | 否 |
| animationDuration | Duration? | - | 打开/关闭动画时长，默认 240ms（与小程序公开 duration 默认值一致）。 | 否 |
| onOpened | VoidCallback? | - | 打开动画结束。 | 否 |
| onClosed | VoidCallback? | - | 当前展示周期真正结束。 大多数场景下会在关闭动画结束后触发；非栈顶路由被直接移除时不保证存在关闭动画。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化；第二个参数为 `TPopupTrigger`。 | 否 |
| useSafeArea | bool | false | 是否避让系统安全区，默认 false；center 使用完整安全区，其他方向避让贴边侧及相邻边。 为 true 时通过 `Positioned` 偏移使面板不侵入刘海、Home Indicator 等区域； top/bottom/left/right 还会与对应 `inset` 叠加。需要避让时显式设为 true； 也可以在 `child` 内使用 Flutter 原生 `SafeArea`，只约束内容而保留面板背景贴边。 | 否 |


##### TPopupOptions.top

创建 `TPopupPlacement.top` 配置。

固定 `placement` 为 `TPopupPlacement.top`；无内置头部。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 浮层主体内容（必填）。 | 是 |
| height | double? | - | 高度；`TPopupPlacement.top`、`TPopupPlacement.bottom` 生效；`TPopupPlacement.center` 约束面板尺寸。 top / bottom 未传时默认 240；center 未传时默认 240。 | 否 |
| inset | TPopupTopInset? | - | 交叉轴边缘留白；具体类型由 `placement` 决定。 * `TPopupPlacement.bottom` 使用 `TPopupBottomInset` * `TPopupPlacement.top` 使用 `TPopupTopInset` * `TPopupPlacement.left` 使用 `TPopupLeftInset` * `TPopupPlacement.right` 使用 `TPopupRightInset` * `TPopupPlacement.center` 不支持 | 否 |
| radius | double? | - | 内容区圆角。 `TPopupPlacement.top`、`TPopupPlacement.bottom`、`TPopupPlacement.center` 默认取主题大圆角；`TPopupPlacement.left`、`TPopupPlacement.right` 默认**无圆角**（对齐官方全高矩形），仅当显式设置本字段或通过 `TPopupThemeData.panelRadius` 注入时应用圆角。 | 否 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层行为配置；为 null 时使用 `TPopupOverlayConfig` 默认值（标准模态弹层）。 | 否 |
| destroyOnClose | bool | false | 为 true 时路由 maintainState 为 false，被其他不透明路由覆盖时可释放内容 State。 关闭路由后无论本字段取值如何，内容 State 都会释放；再次打开会创建新 State。 | 否 |
| animationDuration | Duration? | - | 打开/关闭动画时长，默认 240ms（与小程序公开 duration 默认值一致）。 | 否 |
| onOpened | VoidCallback? | - | 打开动画结束。 | 否 |
| onClosed | VoidCallback? | - | 当前展示周期真正结束。 大多数场景下会在关闭动画结束后触发；非栈顶路由被直接移除时不保证存在关闭动画。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化；第二个参数为 `TPopupTrigger`。 | 否 |
| useSafeArea | bool | false | 是否避让系统安全区，默认 false；center 使用完整安全区，其他方向避让贴边侧及相邻边。 为 true 时通过 `Positioned` 偏移使面板不侵入刘海、Home Indicator 等区域； top/bottom/left/right 还会与对应 `inset` 叠加。需要避让时显式设为 true； 也可以在 `child` 内使用 Flutter 原生 `SafeArea`，只约束内容而保留面板背景贴边。 | 否 |


#### 属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| overlayConfig | TPopupOverlayConfig | - | 解析后的蒙层配置；未传时使用默认值。 |


#### 实例方法

##### TPopupOptions.assertPlacementParams

无参数。

在 debug 模式检查方向与宽高、inset 组合；无效组合抛出校验异常，release 模式不执行。

返回类型：`void`

##### TPopupOptions.copyWith

返回配置副本。

未传入的字段保持原值；对头部/关闭 builder 显式传入 `null` 表示隐藏该区域。

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

无参数。

返回按展示方向归一化的配置副本：仅 bottom 保留 headerBuilder，仅 center 保留 closeBuilder。

返回类型：`TPopupOptions`

### TPopupHandle

`TPopup.show` 的返回值，用于控制同一份 `TPopupOptions` 的多次打开与关闭。

#### 属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| isShowing | bool | - | 浮层是否仍在展示（路由在栈中且未进入关闭流程）。 额外校验 `Route.isActive`：当路由被外部移除（如 Navigator 被销毁或 路由被直接 pop）时，`_route` 引用可能残留，此时应视为未展示， 避免句柄常驻为“展示中”而阻断后续 open。 |
| navigatorContext | BuildContext? | - | 与 `TPopup.show` 的 `navigatorContext` 相同。 |
| options | TPopupOptions | - | 创建时传入的配置；每次 `open` 会按 `TPopupOptions.placement` 裁剪无效字段后使用。 |
| result | Future&lt;Object?&gt; | - | 当前这次打开结束后的路由结果。 每次 `open` 都会创建新的 Future；应在对应的 `open` 之后读取。 |
| themeContext | BuildContext | - | 用于捕获调用点局部 Theme 的 context。 |
| useRootNavigator | bool | - | 与 `TPopup.show` 的 `useRootNavigator` 相同。 |


#### 实例方法

##### TPopupHandle.close

位置参数：`result`


关闭当前展示的浮层；`TPopupOptions.onVisibleChange` 的 `TPopupTrigger` 为
`TPopupTrigger.api`。

已关闭或未展示时调用无副作用。
嵌套浮层场景下会关闭当前 handle 对应的那一层，而不会误关栈顶其它浮层。

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| result | Object? | - | 关闭浮层时返回的业务结果；通过该句柄的 result Future 接收。 | 否 |


##### TPopupHandle.open

位置参数：`context`


打开或重新打开浮层。

已展示时调用无副作用。Navigator 已销毁且未提供新 `context` 时，debug 下 assert，
release 下静默返回。

配置非法时会直接抛出 `FlutterError`，debug / release 行为一致。

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext? | - | 可选。首次调用须能解析 `Navigator`（传入 `context` 或依赖 `navigatorContext`）；后续可省略，优先复用缓存的 `NavigatorState`。 | 否 |


### TPopupOverlayConfig

Popup 蒙层行为配置（可见遮罩、背景拦截、点击行为）。

通过 `TPopupOptions.overlay` 配置蒙层颜色、背景点击拦截、关闭行为和点击回调。

`showOverlay` 与 `preventTap` 解耦，可独立配置：
* `showOverlay=true, preventTap=true`（默认）：标准模态弹层（显示蒙层 + 拦截背景）；
* `showOverlay=true, preventTap=false`：显示蒙层但不拦截背景交互；
* `showOverlay=false, preventTap=true`：透明模态弹层（拦截交互但不显示蒙层）；
* `showOverlay=false, preventTap=false`：非模态浮层（不显示蒙层也不拦截交互）。

#### 构造方法

##### TPopupOverlayConfig

创建蒙层配置。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| closeOnClick | bool? | - | 点击可见蒙层是否关闭；省略时在可点击的可见蒙层上默认为 true。 仅当 `showOverlay` 与 `preventTap` 都为 true 时生效；视觉蒙层允许点击穿透时， 不会接收点击事件，也不会关闭 Popup。 | 否 |
| color | Color? | - | 蒙层颜色（含 alpha）；为 null 时默认 black54。 | 否 |
| onClick | VoidCallback? | - | 可见蒙层点击回调；是否关闭取决于 `effectiveCloseOnClick`。 仅当 `showOverlay` 与 `preventTap` 都为 true 时触发。 | 否 |
| preventTap | bool | true | 是否拦截背景交互（默认 true）；对应原 `modal` 参数。 | 否 |
| showOverlay | bool | true | 是否显示可见半透明蒙层（默认 true）。 | 否 |


#### 属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| effectiveCloseOnClick | bool | - | 解析后的点击可见蒙层是否关闭。 没有可见蒙层或允许点击穿透时始终为 false；其余情况省略 `closeOnClick` 时 默认为 true。 |


### TPopupInset

Popup 在交叉轴方向的边缘留白基类。

#### 构造方法

##### TPopupInset

无参数。

### TPopupBottomInset

bottom 方向的左右留白。

#### 构造方法

##### TPopupBottomInset

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| left | double | 0 | 左侧留白 | 否 |
| right | double | 0 | 右侧留白 | 否 |


### TPopupTopInset

top 方向的左右留白。

#### 构造方法

##### TPopupTopInset

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| left | double | 0 | 左侧留白 | 否 |
| right | double | 0 | 右侧留白 | 否 |


### TPopupLeftInset

left 方向的上下留白。

#### 构造方法

##### TPopupLeftInset

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| bottom | double | 0 | 底部留白 | 否 |
| top | double | 0 | 顶部留白 | 否 |


### TPopupRightInset

right 方向的上下留白。

#### 构造方法

##### TPopupRightInset

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| bottom | double | 0 | 底部留白 | 否 |
| top | double | 0 | 顶部留白 | 否 |


### TPopupThemeData

TPopup 组件级 ThemeExtension

通过 Theme 子树注入，控制子树的默认浮层样式。
`TPopupOptions` 的对应字段优先于 Theme Extension。

#### 构造方法

##### TPopupThemeData

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| barrierColor | Color? | - | 蒙层颜色，透明度直接由 `Color` 的 alpha 指定。 | 否 |
| centerSize | Size? | - | center 未显式传入宽高时的默认面板尺寸 | 否 |
| drawerWidth | double? | - | left / right 未显式传入宽度时的默认抽屉宽度 | 否 |
| edgeHeight | double? | - | top / bottom 未显式传入高度时的默认面板高度 | 否 |
| panelBackgroundColor | Color? | - | 内容区背景色 | 否 |
| panelRadius | double? | - | 内容区圆角。 top/bottom/center 默认取全局主题大圆角； left/right 默认**无圆角**（对齐官方全高矩形），仅当设置本字段时应用圆角。 | 否 |


#### 静态方法

##### TPopupThemeData.lerpDouble

位置参数：`a, b, t`


对 `a` 和 `b` 按 `t` 线性插值；两端均为 null 时返回 null，仅一端为 null 时按 0 参与计算。

返回类型：`double?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| a | double? | - | 起始值。 | 是 |
| b | double? | - | 目标值。 | 是 |
| t | double | - | 插值进度。 | 是 |


#### 实例方法

##### TPopupThemeData.copyWith

返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TPopupThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| barrierColor | Color? | - | 字段含义：蒙层颜色，透明度直接由 `Color` 的 alpha 指定。 调用时的空值行为见方法说明。 | 否 |
| panelRadius | double? | - | 字段含义：内容区圆角。 top/bottom/center 默认取全局主题大圆角； left/right 默认**无圆角**（对齐官方全高矩形），仅当设置本字段时应用圆角。 调用时的空值行为见方法说明。 | 否 |
| panelBackgroundColor | Color? | - | 字段含义：内容区背景色 调用时的空值行为见方法说明。 | 否 |
| edgeHeight | double? | - | 字段含义：top / bottom 未显式传入高度时的默认面板高度 调用时的空值行为见方法说明。 | 否 |
| drawerWidth | double? | - | 字段含义：left / right 未显式传入宽度时的默认抽屉宽度 调用时的空值行为见方法说明。 | 否 |
| centerSize | Size? | - | 字段含义：center 未显式传入宽高时的默认面板尺寸 调用时的空值行为见方法说明。 | 否 |


##### TPopupThemeData.lerp

位置参数：`other, t`


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TPopupThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TPopupThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


##### TPopupThemeData.merge

位置参数：`other`


合并两个 ThemeExtension，`other` 优先于 this

返回类型：`TPopupThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TPopupThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


### TPopupPlacement

浮层出现方向；决定 `TPopupOptions` 中哪些字段生效。

各方向的可用参数见 `TPopupOptions` 的「不同弹出方向的可用参数」说明。
方向固定时请用 `TPopupOptions.bottom`、`TPopupOptions.center` 等命名工厂。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| top | 自顶部滑入；默认高 240，使用 `TPopupOptions.height`、`TPopupOptions.inset`（`TPopupTopInset`）覆盖。 |
| left | 自左侧滑入；默认宽 280，使用 `TPopupOptions.width`、`TPopupOptions.inset`（`TPopupLeftInset`）覆盖。 |
| right | 自右侧滑入；默认宽 280，使用 `TPopupOptions.width`、`TPopupOptions.inset`（`TPopupRightInset`）覆盖。 |
| bottom | 自底部滑入；默认高 240；使用 `TPopupOptions.height`、`TPopupOptions.inset`（`TPopupBottomInset`）覆盖。 |
| center | 屏幕居中；默认 240 × 240，使用 `TPopupOptions.width`、`TPopupOptions.height` 覆盖； 使用 `TPopupOptions.closeBuilder` 控制面板外下方关闭区。 |


### TPopupTrigger

浮层关闭或显隐变化时的触发来源。

作为 `TPopupVisibleChangeCallback` 的第二个参数，以及关闭流程中的语义标记。

内置行为会映射为 `TPopupTrigger.overlay`，center 关闭 builder 调用 `close`
映射为 `TPopupTrigger.close`；
`TPopupHandle.close` 为 `TPopupTrigger.api`；系统返回为
`TPopupTrigger.systemBack`；headerBuilder 内调用 `close` 等为
`TPopupTrigger.custom`。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| overlay | 点击蒙层，且 `TPopupOverlayConfig.effectiveCloseOnClick` 为 true。 |
| close | 点击 center 关闭槽位。 |
| api | 外部 API 主动触发的显隐变化，如 `TPopupHandle.close` 或打开事件。 |
| systemBack | 系统返回键或系统路由返回触发的关闭。 |
| custom | 无框架预设动作语义的自定义关闭，如 headerBuilder 内调用 `close`。 |


### TPopupHeaderBuilder

bottom 整行头部自定义构建器。

* `context` 构建上下文
* `close` 关闭浮层，触发源为 `TPopupTrigger.custom`
#### 类型定义

```dart
typedef TPopupHeaderBuilder = Widget Function(BuildContext context, VoidCallback close);
```


### TPopupSlotBuilder

center 面板外关闭区构建器。

* `context` 构建上下文
* `close` 关闭浮层，触发源为 `TPopupTrigger.close`

自定义 builder 需自行提供交互与无障碍语义；框架仅为内置默认控件补充默认语义。
#### 类型定义

```dart
typedef TPopupSlotBuilder = Widget Function(BuildContext context, VoidCallback close);
```


### TPopupVisibleChangeCallback

浮层显隐变化回调。

* `visible` 为 true 表示打开，false 表示开始关闭
* `trigger` 关闭来源，见 `TPopupTrigger`；打开时为 `TPopupTrigger.api`
#### 类型定义

```dart
typedef TPopupVisibleChangeCallback = void Function(bool visible, TPopupTrigger trigger);
```

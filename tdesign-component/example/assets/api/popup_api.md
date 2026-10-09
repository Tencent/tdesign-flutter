## API

### TPopup

弹出层入口。

#### 主题配置

组件主题通过 `TPopupThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。可配置字段和未设置时的回退见本页的
`TPopupThemeData` 配置项。

#### 静态方法

##### TPopup.show

位置参数：`context`


每次调用打开独立浮层，可叠加展示；参数与方向不匹配时抛出 `FlutterError`。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 `Navigator` 并获取局部主题。 | 是 |
| options | TPopupOptions | - | 浮层配置；创建句柄时合并 `context` 的 `TPopupThemeData`，重新打开不重新解析已合并的主题值。 | 是 |
| navigatorContext | BuildContext? | - | 承载浮层的导航上下文；未指定时使用 `context`。 | 否 |
| useRootNavigator | bool | false | 是否使用根 `Navigator`。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TPopupHandle | - | 用于控制当前浮层的关闭、重新打开及状态查询。 | - |


### TPopupHeader

底部头部布局，提供取消按钮、标题和确认按钮三个插槽；按钮行为由调用方设置。

#### 构造方法

##### TPopupHeader

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| cancelButton | Widget? | - | 左侧取消操作；为 null 时不显示。 | 否 |
| confirmButton | Widget? | - | 右侧确认操作；为 null 时不显示。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| title | Widget? | - | 中间标题；为 null 时不显示。 | 否 |


#### 静态成员

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| headerHeight | double | 58 | 标准头部高度。 | - |


### TPopupOptions

`TPopup.show` 的配置对象。

<!-- api-table: details -->
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| `TPopupOptions` | - | - | 方向：由 `placement` 指定；方向专用参数：按对应方向使用下列参数 | - |
| `TPopupOptions.bottom` | - | - | 方向：底部；方向专用参数：`height`、`inset`（`TPopupBottomInset`）、`headerBuilder` | - |
| `TPopupOptions.center` | - | - | 方向：居中；方向专用参数：`width`、`height`、`closeBuilder` | - |
| `TPopupOptions.top` | - | - | 方向：顶部；方向专用参数：`height`、`inset`（`TPopupTopInset`） | - |
| `TPopupOptions.left` | - | - | 方向：左侧；方向专用参数：`width`、`inset`（`TPopupLeftInset`） | - |
| `TPopupOptions.right` | - | - | 方向：右侧；方向专用参数：`width`、`inset`（`TPopupRightInset`） | - |

<!-- api-table: details -->
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 显式设置尺寸、圆角、面板颜色或蒙层颜色 | - | - | 优先于 `TPopupThemeData` | - |
| 参数与方向不匹配 | - | - | `TPopup.show` / `TPopupHandle.open` 抛出 `FlutterError` | - |

#### 构造方法

##### TPopupOptions

通过 `placement` 指定方向。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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


##### TPopupOptions.bottom

底部弹出配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

居中弹出配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

左侧弹出配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

右侧弹出配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

顶部弹出配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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


#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| overlayConfig | TPopupOverlayConfig | - | 解析后的蒙层配置；未传时使用默认值。 | - |


#### 实例方法

##### TPopupOptions.assertPlacementParams

无参数。

检查参数与方向是否匹配。

<!-- api-table: details -->
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| debug | - | - | 无效组合抛出 `FlutterError` | - |
| release | - | - | 不执行检查 | - |

##### TPopupOptions.copyWith

复制配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TPopupOptions | - | 应用指定参数后的配置副本。 | - |


##### TPopupOptions.normalized

无参数。

按方向整理配置。

<!-- api-table: details -->
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| `headerBuilder` | - | - | 保留条件：底部；不满足时：清除 | - |
| `closeBuilder` | - | - | 保留条件：居中；不满足时：清除 | - |
| 其他参数 | - | - | 保留条件：所有方向；不满足时：保持原值 | - |

###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TPopupOptions | - | 保留当前方向适用插槽的配置副本。 | - |


### TPopupHandle

`TPopup.show` 的返回值，用于控制同一份 `TPopupOptions` 的多次打开与关闭。

#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| isShowing | bool | - | 浮层仍在路由栈中且未开始关闭时为 true。 | - |
| navigatorContext | BuildContext? | - | 与 `TPopup.show` 的 `navigatorContext` 相同。 | - |
| options | TPopupOptions | - | `TPopup.show` 合并显式配置与 `TPopupThemeData` 后的配置；重新 `open` 不重新解析已合并的主题值，并按 `TPopupOptions.placement` 裁剪无效字段。 | - |
| result | Future&lt;Object?&gt; | - | 本次打开的路由结果；关闭时完成，不等待关闭动画结束，动画完成通知见 `TPopupOptions.onClosed`。 每次成功 `open` 都会创建新的 Future；应在对应的 `open` 之后读取。 | - |
| themeContext | BuildContext | - | 用于捕获调用点局部 Theme 的 context。 | - |
| useRootNavigator | bool | - | 与 `TPopup.show` 的 `useRootNavigator` 相同。 | - |


#### 实例方法

##### TPopupHandle.close

位置参数：`result`


关闭此句柄对应的浮层，触发源为 `TPopupTrigger.api`。

<!-- api-table: details -->
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 未展示或已开始关闭 | - | - | 不执行操作 | - |
| 位于栈顶 | - | - | 返回上一层，执行关闭动画 | - |
| 位于其他浮层下方 | - | - | 直接移除此层，保留其他浮层 | - |

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| result | Object? | - | 关闭浮层时返回的业务结果；通过该句柄的 result Future 接收。 | 否 |


##### TPopupHandle.open

位置参数：`context`


打开或重新打开浮层。

<!-- api-table: details -->
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 已展示 | - | - | 不重复打开 | - |
| Navigator 可用 | - | - | 打开浮层，创建新的 `result` Future | - |
| 无可用 Navigator | - | - | debug 触发断言，release 返回 | - |
| 参数与方向不匹配 | - | - | debug / release 均抛出 `FlutterError` | - |

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext? | - | 导航上下文；未指定或无效时依次尝试缓存的 Navigator、`navigatorContext`。有效时重新捕获此处的内容 Theme，否则使用 `themeContext`；不重新解析 `options` 中已合并的 Popup 主题值。 | 否 |


### TPopupOverlayConfig

蒙层配置。

<!-- api-table: details -->
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| showOverlay：true | - | - | preventTap：true；显示蒙层、拦截背景交互；支持点击回调和关闭 | - |
| showOverlay：true | - | - | preventTap：false；显示蒙层，背景可交互；不接收蒙层点击 | - |
| showOverlay：false | - | - | preventTap：true；无可见蒙层，拦截背景交互；不支持蒙层点击关闭 | - |
| showOverlay：false | - | - | preventTap：false；无可见蒙层，背景可交互 | - |

#### 构造方法

##### TPopupOverlayConfig

创建蒙层配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| closeOnClick | bool? | - | 点击蒙层是否关闭；仅显示蒙层且拦截交互时生效，未指定时为 true。 | 否 |
| color | Color? | - | 蒙层颜色（含透明度）；未指定时取 `TPopupThemeData.barrierColor`，再回退到 black54。 | 否 |
| onClick | VoidCallback? | - | 蒙层点击回调；仅显示蒙层且拦截交互时触发，是否关闭由 `closeOnClick` 决定。 | 否 |
| preventTap | bool | true | 是否拦截背景交互。 | 否 |
| showOverlay | bool | true | 是否显示可见蒙层。 | 否 |


#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| effectiveCloseOnClick | bool | - | 实际是否支持蒙层点击关闭；无可见蒙层或允许穿透时为 false，否则取 `closeOnClick`（未指定为 true）。 | - |


### TPopupInset

Popup 在交叉轴方向的边缘留白基类。

#### 构造方法

##### TPopupInset

无参数。

### TPopupBottomInset

bottom 方向的左右留白。

#### 构造方法

##### TPopupBottomInset

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| left | double | 0 | 左侧留白 | 否 |
| right | double | 0 | 右侧留白 | 否 |


### TPopupTopInset

top 方向的左右留白。

#### 构造方法

##### TPopupTopInset

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| left | double | 0 | 左侧留白 | 否 |
| right | double | 0 | 右侧留白 | 否 |


### TPopupLeftInset

left 方向的上下留白。

#### 构造方法

##### TPopupLeftInset

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| bottom | double | 0 | 底部留白 | 否 |
| top | double | 0 | 顶部留白 | 否 |


### TPopupRightInset

right 方向的上下留白。

#### 构造方法

##### TPopupRightInset

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| bottom | double | 0 | 底部留白 | 否 |
| top | double | 0 | 顶部留白 | 否 |


### TPopupPlacement

`TPopupOptions.placement` 的弹出方向。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| top | TPopupPlacement | - | 顶部滑入。 | - |
| left | TPopupPlacement | - | 左侧滑入。 | - |
| right | TPopupPlacement | - | 右侧滑入。 | - |
| bottom | TPopupPlacement | - | 底部滑入。 | - |
| center | TPopupPlacement | - | 屏幕居中。 | - |


### TPopupTrigger

`TPopupVisibleChangeCallback` 的触发来源。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| overlay | TPopupTrigger | - | 点击蒙层，且 `TPopupOverlayConfig.effectiveCloseOnClick` 为 true。 | - |
| close | TPopupTrigger | - | 居中关闭区 builder 调用 close。 | - |
| api | TPopupTrigger | - | 外部 API 主动触发的显隐变化，如 `TPopupHandle.close` 或打开事件。 | - |
| systemBack | TPopupTrigger | - | 系统返回键或系统路由返回触发的关闭。 | - |
| custom | TPopupTrigger | - | 头部 builder 调用 close 等自定义关闭。 | - |


### TPopupHeaderBuilder

底部头部构建器。

位置参数：`context, close`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 构建上下文。 | 是 |
| close | VoidCallback | - | 关闭 Popup，触发源为 `TPopupTrigger.custom`。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | 构建的底部头部内容。 | - |


### TPopupSlotBuilder

居中面板外关闭区构建器；交互与无障碍语义由 builder 提供。

位置参数：`context, close`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 构建上下文。 | 是 |
| close | VoidCallback | - | 关闭 Popup，触发源为 `TPopupTrigger.close`。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | 构建的面板外关闭区内容。 | - |


### TPopupVisibleChangeCallback

浮层显隐变化回调。

位置参数：`visible, trigger`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| visible | bool | - | true 表示打开，false 表示开始关闭。 | 是 |
| trigger | TPopupTrigger | - | 触发来源；打开时为 `TPopupTrigger.api`。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | void | - | 无返回值。 | - |


### TPopupThemeData

Popup 子树默认样式，通过 Theme.extensions 注入。

<!-- api-table: details -->
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| TPopupOptions 显式值 | - | - | 优先级：最高 | - |
| TPopupThemeData | - | - | 优先级：其次 | - |
| 组件默认值 | - | - | 优先级：最后 | - |

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| barrierColor | Color? | - | 蒙层颜色，透明度直接由 `Color` 的 alpha 指定。 | 否 |
| centerSize | Size? | - | center 未显式传入宽高时的默认面板尺寸 | 否 |
| drawerWidth | double? | - | left / right 未显式传入宽度时的默认抽屉宽度 | 否 |
| edgeHeight | double? | - | top / bottom 未显式传入高度时的默认面板高度 | 否 |
| panelBackgroundColor | Color? | - | 内容区背景色 | 否 |
| panelRadius | double? | - | 面板圆角；未指定时顶部/底部/居中取全局主题大圆角，左侧/右侧无圆角。 | 否 |


#### 静态方法

##### TPopupThemeData.lerpDouble

位置参数：`a, b, t`


数值线性插值。

<!-- api-table: details -->
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 两端均为 null | - | - | null | - |
| 一端为 null | - | - | 该端按 0 计算 | - |
| 两端均非空 | - | - | 按 `t` 线性插值 | - |

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| a | double? | - | 起始值。 | 是 |
| b | double? | - | 目标值。 | 是 |
| t | double | - | 插值进度。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | double? | - | 插值结果；两端均为 null 时返回 null。 | - |

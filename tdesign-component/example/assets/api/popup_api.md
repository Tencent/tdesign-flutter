## API
### TPopup
#### 简介
弹出层：支持五向滑入/居中弹出、蒙层、bottom 操作栏与 center 关闭区。

 命令式用法优先调用 [show]；声明式将 [TPopup] 包裹业务子树并设 [initialVisible]（弹层在独立路由中，[build] 仅渲染 [child]）。
 bottom 操作栏参数仅对 [TPopupPlacement.bottom] 生效；center 关闭参数仅对 center 生效；
 top/left/right 仅使用 [child] 与布局参数。
 嵌套时 [close] 只关栈顶 Popup；无 Popup 时不操作当前页。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autoCloseOnCancel | bool | true | 点击取消后是否自动关闭，默认 true。 |
| autoCloseOnConfirm | bool | true | 点击确定后是否自动关闭，默认 true。 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 |
| cancel | Widget? | kPopupActionDefault | bottom 左侧按钮；默认 [kPopupActionDefault] 表示默认文案，传 null 隐藏左侧。 |
| cancelBtn | String? | - | bottom 左侧按钮文案，覆盖默认「取消」。 |
| cancelBuilder | WidgetBuilder? | - | bottom 左侧按钮构建器，优先级高于 [cancel]。 |
| child | Widget | - | 浮层主体内容（必填）。 |
| closeBuilder | TPopupCloseBuilder? | kPopupDefaultClose | center 关闭区：`null` 不显示；未传则用 [kPopupDefaultClose] 默认圆圈图标； |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭（须 [showOverlay] 为 true）。 |
| confirm | Widget? | kPopupActionDefault | bottom 右侧按钮；默认 [kPopupActionDefault]，传 null 隐藏右侧。 |
| confirmBtn | String? | - | bottom 右侧按钮文案，覆盖默认「确定」。 |
| confirmBuilder | WidgetBuilder? | - | bottom 右侧按钮构建器，优先级高于 [confirm]。 |
| destroyOnClose | bool | false | 为 true 时 Popup 路由 [Route.maintainState] 为 false，关闭后不保留路由内 State； |
| duration | Duration | const Duration(milliseconds: 240) | 打开与关闭动画时长（一致）。 |
| headerBuilder | TPopupHeaderBuilder? | kPopupDefaultHeader | bottom 头部：`null` 无头部；未传则用 [kPopupDefaultHeader] 默认操作栏；自定义见 [TPopupHeaderBuilder]。 |
| height | double? | - | 高度；对 top、bottom 生效；center 且下方关闭时约束内容区高度。 |
| initialVisible | bool | false | 声明式：为 true 时在首帧后自动 [show]。 |
| key |  | - |  |
| margin | EdgeInsets? | - | 外边距；center 忽略。bottom 的 top 可用来做日历式距顶留白。 |
| navigatorContext | BuildContext? | - | 指定 Navigator 的 context，默认使用当前 context。 |
| onCancel | VoidCallback? | - | 点击 bottom 左侧按钮回调。 |
| onClose | VoidCallback? | - | 开始关闭时回调（含蒙层、按钮、程序化关闭）。 |
| onCloseBtn | VoidCallback? | - | center 点击关闭控件前的回调。 |
| onClosed | VoidCallback? | - | 关闭动画结束且路由移除后回调。 |
| onConfirm | VoidCallback? | - | 点击 bottom 右侧按钮回调。 |
| onOpen | VoidCallback? | - | 开始打开时回调（路由入栈）。 |
| onOpened | VoidCallback? | - | 打开动画结束后回调。 |
| onOverlayClick | VoidCallback? | - | 点击蒙层时回调（在是否关闭判断之前）。 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化及触发来源。 |
| overlayColor | Color? | - | 蒙层颜色，默认 black54。 |
| overlayOpacity | double? | - | 蒙层透明度系数（0–1），与 [overlayColor] 的 alpha 相乘后用于绘制。 |
| placement | TPopupPlacement | TPopupPlacement.bottom | 出现位置，默认 [TPopupPlacement.bottom]。 |
| preventScrollThrough | bool | true | 是否拦截底层滚动；无蒙层时用透明层吸收滚动。 |
| radius | double? | - | 内容区圆角，默认主题大圆角。 |
| showOverlay | bool | true | 是否绘制半透明蒙层；为 false 时须保留其它关闭入口。 |
| title | String? | - | bottom 操作栏中间标题文案。 |
| titleAlignLeft | bool | false | bottom 仅标题行时是否左对齐，默认居中。 |
| titleWidget | Widget? | - | bottom 操作栏中间标题组件，优先级高于 [title]。 |
| useRootNavigator | bool | false | 是否使用根 Navigator。 |
| width | double? | - | 宽度；对 left、right、center 生效。 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| close |  |   required BuildContext context,  Object? result, | 关闭当前 Navigator 栈顶 [TPopup]。     仅关闭 Tracker 栈顶展示中的 Popup；无 Popup 时不操作（不会 pop 当前页）。 |
| show |  |   required BuildContext context,  required Widget child,  TPopupPlacement placement,  double? width,  double? height,  EdgeInsets? margin,  double? radius,  Color? backgroundColor,  bool showOverlay,  bool closeOnOverlayClick,  Color? overlayColor,  double? overlayOpacity,  bool preventScrollThrough,  bool destroyOnClose,  Duration duration,  String? title,  Widget? titleWidget,  bool titleAlignLeft,  String? cancelBtn,  Widget? cancel,  WidgetBuilder? cancelBuilder,  VoidCallback? onCancel,  String? confirmBtn,  Widget? confirm,  WidgetBuilder? confirmBuilder,  VoidCallback? onConfirm,  bool autoCloseOnCancel,  bool autoCloseOnConfirm,  TPopupCloseBuilder? closeBuilder,  VoidCallback? onCloseBtn,  TPopupHeaderBuilder? headerBuilder,  VoidCallback? onOpen,  VoidCallback? onOpened,  VoidCallback? onClose,  VoidCallback? onClosed,  TPopupVisibleChangeCallback? onVisibleChange,  VoidCallback? onOverlayClick,  BuildContext? navigatorContext,  bool useRootNavigator, | 命令式打开浮层，参数与 [TPopup] 构造器一致。     返回 [TPopupHandle]；优先 [TPopupHandle.close]，或在 Popup 子树内 [close]。     [cancel]/[confirm] 默认 [kPopupActionDefault] 表示默认文案，显式 null 可隐藏操作栏侧。   [closeBuilder] 未传为 [kPopupDefaultClose]（默认关闭图标），显式 null 不显示关闭区。 |

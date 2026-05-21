## API
### TPopup
#### 简介
弹出层：五向滑入 / 居中弹出，支持蒙层、bottom 操作栏、center 下方关闭。

 ## 怎么用

 **命令式（推荐）** — 先组配置，再 `show`，用返回的 [TPopupHandle] 关闭：

 ```dart
 final handle = TPopup(
   options: TPopupOptions(
     placement: TPopupPlacement.bottom,
     title: '标题',
     child: MyPanel(),
   ),
 ).show(context);

 // 关闭这一层（须保留 handle，不要用 context 猜栈顶）
 handle.close();
 ```

 **声明式** — 包住子树，`initialVisible: true` 时首帧自动 [show]；[build] 只渲染 [options.child]：

 ```dart
 TPopup(
   options: TPopupOptions(child: body),
   initialVisible: true,
 )
 ```

 字段说明见 [TPopupOptions]；按 [TPopupPlacement] 只有部分参数生效（无效参数会在
 [TPopupOptions.normalized] 中裁掉）。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| initialVisible | bool | false | 为 true 时，挂载后首帧自动调用 [show]（仅声明式）。 |
| key |  | - |  |
| navigatorContext | BuildContext? | - | 指定使用哪个 [Navigator]；默认 [show] 传入的 `context` 所在 Navigator。 |
| options | TPopupOptions | - | 浮层内容与行为配置，见 [TPopupOptions]。 |
| useRootNavigator | bool | false | 为 true 时使用根 [Navigator]（嵌套导航场景）。 |

```
```

### TPopupOptions
#### 简介
浮层配置：[TPopup] 构造与 [TPopup.show] 的唯一参数来源。

 ## 按 [placement] 用哪些字段

 | placement | 常用字段 |
 |-----------|----------|
 | [TPopupPlacement.bottom] | `title` / `cancel` / `confirm` / `headerBuilder`、`height`、`margin` |
 | [TPopupPlacement.center] | `closeBuilder`、`width`、`height`（有下方关闭时） |
 | [TPopupPlacement.top] / [left] / [right] | 主要 `child`、`margin`、方向对应 `width` 或 `height` |

 传给其它 placement 的 bottom / center 专用字段会在 [normalized] 里裁掉。

 ## 三态占位（bottom / center）

 - **未传参数**：使用默认 UI（如默认取消/确定文案、默认关闭图标）。
 - **显式 `null`**：隐藏该槽位（如 `cancel: null` 隐藏左侧；`closeBuilder: null` 无关闭按钮）。
 - **自定义 Widget / Builder**：完全自定义该区域。

 [TPopup.show] 内部会先 [normalized] 再绘制。
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
| closeBuilder | TPopupCloseBuilder? | kPopupDefaultClose | center 关闭区：`null` 不显示；未传则用 [kPopupDefaultClose]；bottom 与三边忽略。 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭（须 [showOverlay] 为 true）。 |
| confirm | Widget? | kPopupActionDefault | bottom 右侧按钮；默认 [kPopupActionDefault]，传 null 隐藏右侧。 |
| confirmBtn | String? | - | bottom 右侧按钮文案，覆盖默认「确定」。 |
| confirmBuilder | WidgetBuilder? | - | bottom 右侧按钮构建器，优先级高于 [confirm]。 |
| destroyOnClose | bool | false | 为 true 时 Popup 路由 maintainState 为 false，关闭后不保留路由内 State。 |
| duration | Duration | const Duration(milliseconds: 240) | 打开与关闭动画时长（一致）。 |
| headerBuilder | TPopupHeaderBuilder? | kPopupDefaultHeader | bottom 头部：`null` 无头部；未传则用 [kPopupDefaultHeader]；自定义见 [TPopupHeaderBuilder]。 |
| height | double? | - | 高度；对 top、bottom 生效；center 且下方关闭时约束内容区高度。 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距；center 忽略。bottom 的 top 可用来做日历式距顶留白。 |
| onCancel | VoidCallback? | - | 点击 bottom 左侧按钮回调。 |
| onClose | VoidCallback? | - | 开始关闭时回调。 |
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
| width | double? | - | 宽度；对 left、right、center 生效。 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| isActionDefault |  |   required Widget? action, |  |

```
```

### TPopupHeaderData
#### 简介
传给自定义 [TPopupOptions.headerBuilder] 的标题栏数据（库内已组装好各槽 Widget）。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cancel | Widget? | - | 左侧区域 Widget（null 表示该侧已隐藏）。 |
| confirm | Widget? | - | 右侧区域 Widget（null 表示该侧已隐藏）。 |
| onCancel | VoidCallback? | - | 点击左侧区域时回调（是否关闭由 [TPopupOptions.autoCloseOnCancel] 决定）。 |
| onConfirm | VoidCallback? | - | 点击右侧区域时回调（是否关闭由 [TPopupOptions.autoCloseOnConfirm] 决定）。 |
| title | Widget? | - | 中间标题（可为 null）。 |

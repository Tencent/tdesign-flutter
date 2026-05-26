## API
### TPopup
#### 简介
弹出层入口：五向滑入 / 居中弹出，支持蒙层、bottom 操作区、center 面板外下方关闭区。

 通过 [show] 命令式打开；返回 [TPopupHandle] 用于关闭与再次打开。
 多次调用 [show] 会继续压入新的浮层路由，可用于叠加展示。

 **示例**

 ```dart
 final handle = TPopup.show(
   context,
   options: TPopupOptions.bottom(
     titleWidget: const Text('标题'),
     child: MyPanel(),
   ),
 );
 handle.close();
 handle.open();
 ```

 配置项见 [TPopupOptions]；方向见 [TPopupPlacement]。

#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TPopup._  |  |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| show |  |   required BuildContext context,  required TPopupOptions options,  BuildContext? navigatorContext,  bool useRootNavigator, | 打开浮层并压入独立 [PopupRoute]。     [context] 用于查找 [Navigator] 并展示浮层。     [options] 浮层配置；方向固定时推荐 [TPopupOptions.bottom] 等命名工厂。     返回 [TPopupHandle]，可用 [TPopupHandle.close]、[TPopupHandle.open]、   [TPopupHandle.isShowing] 控制与查询。   重复调用会继续 push 新的浮层；若需互斥请在业务层管理。     [navigatorContext] 可选，指定承载浮层的 [Navigator] 的 context，默认 [context]。     [useRootNavigator] 为 true 时使用根 [Navigator]（嵌套导航场景）。 |

```
```

### TPopupOptions
#### 简介
[TPopup.show] 的配置对象。

 ## 如何创建

 | 场景 | 推荐用法 |
 |------|----------|
 | 弹出方向已知 | [TPopupOptions.bottom]、[TPopupOptions.center]、[TPopupOptions.top]、[TPopupOptions.left]、[TPopupOptions.right] |
 | 方向由变量决定 | 默认构造并设置 [placement]；传错字段会在 [TPopup.show] / [TPopupHandle.open] 时抛 [FlutterError] |

 命名工厂只暴露当前方向生效的字段（例如 [TPopupOptions.bottom] 无 [width] 参数）。

 ## 字段与 [TPopupPlacement]

 | [TPopupPlacement] | 头部 / 关闭区 | 尺寸 |
 |-------------------|-------------|------|
 | [TPopupPlacement.bottom] | [headerBuilder]、[titleWidget]、[cancelBuilder]、[confirmBuilder] | [height]、[inset] |
 | [TPopupPlacement.center] | [closeBuilder] | [width]、[height] |
 | [TPopupPlacement.top] | — | [height]、[inset] |
 | [TPopupPlacement.left]、[TPopupPlacement.right] | — | [width]、[inset] |

 ## Builder 三态（[headerBuilder]、[cancelBuilder]、[confirmBuilder]、[closeBuilder]）

 | 传参方式 | 效果 |
 |----------|------|
 | 省略（使用默认值） | 渲染内置 UI |
 | 显式 `null` | 隐藏该区域 |
 | 自定义 [TPopupHeaderBuilder] / [TPopupSlotBuilder] | 完全替换；需自行提供交互与语义，可调用 `close` 关闭浮层 |

 [titleWidget] 默认为 `null`，表示无标题内容。

 生命周期回调见 [onOpen]、[onOpened]、[onClose]、[onClosed]、[onVisibleChange]、[onOverlayClick]。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration | const Duration(milliseconds: 240) | 打开/关闭动画时长。 |
| backgroundColor | Color? | - | 内容区背景色，默认主题容器色。 |
| cancelBuilder | TPopupSlotBuilder? | _kPopupDefaultCancel | bottom 左侧操作槽；仅 [headerBuilder] 为内置默认时生效。 |
| child | Widget | - | 浮层主体内容（必填）。 |
| closeBuilder | TPopupSlotBuilder? | _kPopupDefaultClose | center 面板外下方关闭区；仅 [TPopupPlacement.center] 生效。三态见类文档「Builder 三态」。 |
| closeOnOverlayClick |  | - |  |
| confirmBuilder | TPopupSlotBuilder? | _kPopupDefaultConfirm | bottom 右侧操作槽；仅 [headerBuilder] 为内置默认时生效。 |
| destroyOnClose | bool | false | 为 true 时路由 `maintainState` 为 false，关闭后不保留路由内 State。 |
| headerBuilder | TPopupHeaderBuilder? | _kPopupDefaultHeader | bottom 头部；仅 [TPopupPlacement.bottom] 生效。三态见类文档「Builder 三态」。 |
| height | double? | - | 高度；[TPopupPlacement.top]、[TPopupPlacement.bottom] 生效；[TPopupPlacement.center] 约束面板尺寸。 |
| inset | TPopupInset? | - | 交叉轴边缘留白；具体类型由 [placement] 决定。 |
| modal | bool | true | 是否以模态方式展示；为 true 时阻断背景交互与底层语义/焦点。 |
| onClose | VoidCallback? | - | 开始关闭（与 [onVisibleChange] 的 `visible: false` 同期）。 |
| onClosed | VoidCallback? | - | 当前展示周期真正结束。 |
| onOpen | VoidCallback? | - | 路由 push 时（打开动画开始前）。 |
| onOpened | VoidCallback? | - | 打开动画结束。 |
| onOverlayClick | VoidCallback? | - | 蒙层点击；是否关闭取决于 [closeOnOverlayClick]。 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 显隐变化；第二个参数为 [TPopupTrigger]。 |
| overlayColor | Color? | - | 蒙层颜色，默认 black54。 |
| overlayOpacity | double? | - | 蒙层透明度系数（0–1），与 [overlayColor] 的 alpha 相乘后用于绘制。 |
| placement | TPopupPlacement | TPopupPlacement.bottom | 出现位置，默认 [TPopupPlacement.bottom]。 |
| radius | double? | - | 内容区圆角，默认主题大圆角。 |
| showOverlay | bool | true | 是否绘制半透明蒙层。 |
| titleWidget | Widget? | - | bottom 标题插槽；仅 [headerBuilder] 为内置默认时生效。`null` 表示无标题。 |
| width | double? | - | 宽度；[TPopupPlacement.left]、[TPopupPlacement.right]、[TPopupPlacement.center] 生效。 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TPopupOptions.bottom  | 创建 [TPopupPlacement.bottom] 配置。

 固定 [placement] 为 [TPopupPlacement.bottom]；默认带内置头部。
 蒙层、动画、生命周期等字段语义见同名成员文档。 |
| TPopupOptions.center  | 创建 [TPopupPlacement.center] 配置。

 固定 [placement] 为 [TPopupPlacement.center]；默认展示面板外下方圆形关闭按钮。 |
| TPopupOptions.left  | 创建 [TPopupPlacement.left] 配置。

 固定 [placement] 为 [TPopupPlacement.left]；未传 [width] 时布局默认宽度 280。 |
| TPopupOptions.right  | 创建 [TPopupPlacement.right] 配置。

 固定 [placement] 为 [TPopupPlacement.right]；未传 [width] 时布局默认宽度 280。 |
| TPopupOptions.top  | 创建 [TPopupPlacement.top] 配置。

 固定 [placement] 为 [TPopupPlacement.top]；无内置头部。 |

```
```

### TPopupHandle
#### 简介
[TPopup.show] 的返回值，用于控制同一份 [TPopupOptions] 的多次打开与关闭。

 **示例**

 ```dart
 final handle = TPopup.show(
   context,
   options: TPopupOptions.bottom(child: panel),
 );
 handle.close();
 handle.open(); // 可省略 context，复用已缓存的 Navigator
 ```

#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TPopupHandle._  |  |

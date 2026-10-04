## API
### TPopover
#### 简介
气泡弹层
可通过 `showPopover` 一次性弹出，或通过 `TPopoverAnchor` 建立可控制气泡，
支持 12 个方向定位和箭头。蒙层色与圆角由触发 `BuildContext` 最近的
`TPopoverThemeData` 控制；单个气泡可包裹局部 Theme。

#### 静态方法

##### TPopover.showPopover

显示气泡弹层。

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 触发元素上下文，用于锚点定位、Overlay 与主题解析。 |
| content | Widget | - | 气泡内容；直接传入未设样式的 Text 使用默认文字样式。 |
| colorPreset | TPopoverColorPreset | TPopoverColorPreset.defaultTheme | 气泡预设配色。 |
| closeOnClickOutside | bool | true | 点击气泡外部区域时是否关闭弹层。 外部目标仍会接收该次点击，因此可在单次点击中从一个气泡切换到另一个气泡。 |
| closeOnScroll | bool | true | 页面滚动时是否关闭弹层。 默认为 true，避免触发元素移动后气泡停留在旧坐标。 |
| placement | TPopoverPlacement | TPopoverPlacement.top | 浮层出现位置，默认为 `TPopoverPlacement.top`。 |
| showArrow | bool? | - | 是否显示气泡箭头。 |
| width | double? | - | 内容外框宽度（包含 padding）。 未设置时按 `content` 的实际布局宽度确定，并受组件主题尺寸约束。 |
| height | double? | - | 内容外框高度（包含 padding）。 未设置时按 `content` 的实际布局高度确定，并受组件主题尺寸约束。 |
| onTap | VoidCallback? | - | 点击气泡内容时触发。 |
| onLongPress | VoidCallback? | - | 长按气泡内容时触发。 |


### TPopoverAnchor
#### 简介
将可控制的气泡与 Widget 树中的触发区域绑定。
`TPopoverAnchor` 声明气泡内容、位置和视觉配置，`TPopoverController` 只负责
`open`、`close` 和 `isOpen`。简单的一次性展示仍可使用
`TPopover.showPopover`。
蒙层色与圆角由最近的 `TPopoverThemeData` 控制；单个气泡使用局部 Theme。
气泡展开时会读取当前的内容、位置、视觉配置和关闭策略；展开期间更新这些
配置不会刷新已显示的浮层，关闭后再次展开时生效。`builder` 和 `child` 仍按
普通 Widget 树的更新规则重建。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| builder | TPopoverAnchorBuilder | - | 构建气泡所绑定的触发区域。 构建器会收到当前有效的控制器；未传入 `controller` 时由组件内部创建。 |
| child | Widget? | - | 传递给 `builder` 的可选子组件。 |
| closeOnClickOutside | bool | true | 点击气泡外部区域时是否关闭弹层。 外部目标仍会接收该次点击，因此可在单次点击中从一个气泡切换到另一个气泡。 |
| closeOnScroll | bool | true | 页面滚动时是否关闭弹层。 |
| colorPreset | TPopoverColorPreset | TPopoverColorPreset.defaultTheme | 气泡预设配色。 |
| content | Widget | - | 气泡内容。 |
| controller | TPopoverController? | - | 可选控制器，用于从触发区域外部展开或关闭气泡。 |
| height | double? | - | 内容外框高度（包含 padding）。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onClose | VoidCallback? | - | 气泡展示周期结束时触发，包含主动关闭和锚点卸载。 |
| onLongPress | VoidCallback? | - | 长按气泡内容时触发。 |
| onOpen | VoidCallback? | - | 气泡内容成功插入 Overlay 后触发，不表示展开动画完成。 |
| onTap | VoidCallback? | - | 点击气泡内容时触发。 |
| placement | TPopoverPlacement | TPopoverPlacement.top | 浮层出现位置。 |
| showArrow | bool? | - | 是否显示气泡箭头。 |
| width | double? | - | 内容外框宽度（包含 padding）。 |


### TPopoverController
#### 简介
控制与其绑定的 `TPopoverAnchor`。
气泡内容、位置和视觉配置由 `TPopoverAnchor` 声明，控制器只负责展开、关闭
和查询当前状态，不形成第二份配置来源。
每个控制器应绑定一个 Anchor。重复绑定会使命令指向最后挂载的 Anchor，
旧 Anchor 卸载不会解除新绑定；请为同时存在的 Anchor 分别创建控制器。

#### 静态方法

##### TPopoverController.maybeOf

返回 `context` 最近的 `TPopoverAnchor` 所关联的控制器。
未处于 Anchor 的触发区域或气泡内容子树时返回 null。

返回类型：`TPopoverController?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 触发区域或气泡内容子树中的上下文。 |


### TPopoverThemeData
#### 简介
TPopover 组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认气泡样式。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowSize | double? | - | 箭头尺寸 |
| backgroundColor | Color? | - | 气泡背景色 |
| barrierColor | Color? | - | 蒙层色；未设置时透明。单个气泡可用局部 Theme 覆盖。 |
| borderRadius | BorderRadius? | - | 气泡圆角；未设置时回退全局默认圆角。单个气泡可用局部 Theme 覆盖。 |
| boxShadow | List<BoxShadow>? | - | 气泡阴影 |
| maxHeight | double? | - | 最大高度 |
| maxWidth | double? | - | 文本内容的最大宽度 |
| minWidth | double? | - | 最小宽度 |
| offset | double? | - | 弹层与触发元素的间距 |
| padding | EdgeInsetsGeometry? | - | 内边距 |


### TPopoverColorPreset
#### 简介
弹出气泡的内置配色预设；不切换全局明暗主题。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认深色配色。 |
| light | 浅色。 |
| primary | 品牌主色。 |
| success | 成功。 |
| warning | 警告。 |
| danger | 危险色。 |


### TPopoverPlacement
#### 简介
气泡弹层定位方向。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| topLeft | 上左。 |
| top | 上方。 |
| topRight | 上右。 |
| rightTop | 右上。 |
| right | 右侧。 |
| rightBottom | 右下。 |
| bottomRight | 下右。 |
| bottom | 下方。 |
| bottomLeft | 下左。 |
| leftBottom | 左下。 |
| left | 左侧。 |
| leftTop | 左上。 |


### TPopoverAnchorBuilder
#### 简介
`TPopoverAnchor` 的触发区域构建器。
`controller` 用于展开、关闭气泡和查询展开状态；`child` 是传给
`TPopoverAnchor.child` 的可选、不依赖展开状态的子组件。
#### 类型定义

```dart
typedef TPopoverAnchorBuilder = Widget Function(BuildContext context, TPopoverController controller, Widget? child);
```

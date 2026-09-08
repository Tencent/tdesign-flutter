## API
### TPopover
#### 简介
气泡弹层
可通过 `showPopover` 一次性弹出，或通过 `TPopoverAnchor` 建立可控制气泡，
支持 12 个方向定位和箭头。

#### 静态方法

##### TPopover.showPopover

显示气泡弹层

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| content | Widget | - | - |
| offset | double? | - | 弹层与触发元素的间距。 |
| colorScheme | TPopoverColorScheme | TPopoverColorScheme.defaultTheme | 气泡预设配色。 |
| closeOnClickOutside | bool | true | 点击气泡外部区域时是否关闭弹层。 |
| closeOnScroll | bool | true | 页面滚动时是否关闭弹层。 默认为 true，避免触发元素移动后气泡停留在旧坐标。 |
| placement | TPopoverPlacement | TPopoverPlacement.top | 浮层出现位置，默认为 `TPopoverPlacement.top`。 |
| showArrow | bool? | - | 是否显示气泡箭头。 |
| arrowSize | double? | - | 箭头尺寸。 |
| padding | EdgeInsetsGeometry? | - | 内容内边距。 |
| width | double? | - | 内容外框宽度（包含 padding）。 未设置时按 `content` 的实际布局宽度确定，并受组件主题尺寸约束。 |
| height | double? | - | 内容外框高度（包含 padding）。 未设置时按 `content` 的实际布局高度确定，并受组件主题尺寸约束。 |
| overlayColor | Color? | - | 蒙层颜色。 |
| onTap | VoidCallback? | - | 点击气泡内容时触发。 |
| onLongTap | VoidCallback? | - | 长按气泡内容时触发。 |
| radius | BorderRadius? | - | 气泡圆角。 |


### TPopoverAnchor
#### 简介
将可控制的气泡与 Widget 树中的触发区域绑定。
`TPopoverAnchor` 声明气泡内容、位置和视觉配置，`TPopoverController` 只负责
`open`、`close` 和 `isOpen`。简单的一次性展示仍可使用
`TPopover.showPopover`。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowSize | double? | - | 箭头尺寸。 |
| builder | TPopoverAnchorBuilder | - | 构建气泡所绑定的触发区域。 构建器会收到当前有效的控制器；未传入 `controller` 时由组件内部创建。 |
| child | Widget? | - | 传递给 `builder` 的可选子组件。 |
| closeOnClickOutside | bool | true | 点击气泡外部区域时是否关闭弹层。 |
| closeOnScroll | bool | true | 页面滚动时是否关闭弹层。 |
| colorScheme | TPopoverColorScheme | TPopoverColorScheme.defaultTheme | 气泡预设配色。 |
| content | Widget | - | 气泡内容。 |
| controller | TPopoverController? | - | 可选控制器，用于从触发区域外部展开或关闭气泡。 |
| height | double? | - | 内容外框高度（包含 padding）。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| offset | double? | - | 弹层与触发元素的间距。 |
| onClose | VoidCallback? | - | 气泡通过任意路径关闭后触发。 |
| onLongTap | VoidCallback? | - | 长按气泡内容时触发。 |
| onOpen | VoidCallback? | - | 气泡展开后触发。 |
| onTap | VoidCallback? | - | 点击气泡内容时触发。 |
| overlayColor | Color? | - | 蒙层颜色。 |
| padding | EdgeInsetsGeometry? | - | 内容内边距。 |
| placement | TPopoverPlacement | TPopoverPlacement.top | 浮层出现位置。 |
| radius | BorderRadius? | - | 气泡圆角。 |
| showArrow | bool? | - | 是否显示气泡箭头。 |
| width | double? | - | 内容外框宽度（包含 padding）。 |


### TPopoverController
#### 简介
控制与其绑定的 `TPopoverAnchor`。
气泡内容、位置和视觉配置由 `TPopoverAnchor` 声明，控制器只负责展开、关闭
和查询当前状态，不形成第二份配置来源。

#### 静态方法

##### TPopoverController.maybeOf

返回 `context` 最近的 `TPopoverAnchor` 所关联的控制器。
未处于 Anchor 的触发区域或气泡内容子树时返回 null。

返回类型：`TPopoverController?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |


### TPopoverColorScheme
#### 简介
弹出气泡预设配色。
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

## API

### TPopover

气泡弹层

可通过 `showPopover` 一次性弹出，或通过 `TPopoverAnchor` 建立可控制气泡，
支持 12 个方向定位和箭头。蒙层色与圆角由触发 `BuildContext` 最近的
`TPopoverThemeData` 控制；单个气泡可包裹局部 Theme。

#### 构造方法

##### TPopover

无参数。

#### 静态方法

##### TPopover.showPopover

显示气泡弹层

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 触发元素的上下文，用于计算气泡锚点位置。 | 是 |
| content | Widget | - | 气泡内容。 直接传入未设置样式的 `Text` 时使用气泡默认文字样式；组合内容应自行定义 子组件样式和布局。 | 是 |
| colorPreset | TPopoverColorPreset | TPopoverColorPreset.defaultTheme | 气泡预设配色。 | 否 |
| closeOnClickOutside | bool | true | 点击气泡外部区域时是否关闭弹层。 外部目标仍会接收该次点击，因此可在单次点击中从一个气泡切换到另一个气泡。 | 否 |
| closeOnScroll | bool | true | 页面滚动时是否关闭弹层。 默认为 true，避免触发元素移动后气泡停留在旧坐标。 | 否 |
| placement | TPopoverPlacement | TPopoverPlacement.top | 浮层出现位置，默认为 `TPopoverPlacement.top`。 | 否 |
| showArrow | bool? | - | 是否显示气泡箭头。 | 否 |
| width | double? | - | 内容外框宽度（包含 padding）。 未设置时按 `content` 的实际布局宽度确定，并受组件主题尺寸约束。 | 否 |
| height | double? | - | 内容外框高度（包含 padding）。 未设置时按 `content` 的实际布局高度确定，并受组件主题尺寸约束。 | 否 |
| onTap | VoidCallback? | - | 点击气泡内容时触发。 | 否 |
| onLongTap | VoidCallback? | - | 长按气泡内容时触发。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;void&gt; | - | 气泡关闭时完成的 Future；不是打开完成通知。 | - |


### TPopoverAnchor

将可控制的气泡与 Widget 树中的触发区域绑定。

`TPopoverAnchor` 声明气泡内容、位置和视觉配置，`TPopoverController` 只负责
`open`、`close` 和 `isOpen`。简单的一次性展示仍可使用
`TPopover.showPopover`。
蒙层色与圆角由最近的 `TPopoverThemeData` 控制；单个气泡使用局部 Theme。

气泡展开时会读取当前的内容、位置、视觉配置和关闭策略；展开期间更新这些
配置不会刷新已显示的浮层，关闭后再次展开时生效。`builder` 和 `child` 仍按
普通 Widget 树的更新规则重建。

#### 构造方法

##### TPopoverAnchor

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| builder | TPopoverAnchorBuilder | - | 构建气泡所绑定的触发区域。 构建器会收到当前有效的控制器；未传入 `controller` 时由组件内部创建。 | 是 |
| child | Widget? | - | 传递给 `builder` 的可选子组件。 | 否 |
| closeOnClickOutside | bool | true | 点击气泡外部区域时是否关闭弹层。 外部目标仍会接收该次点击，因此可在单次点击中从一个气泡切换到另一个气泡。 | 否 |
| closeOnScroll | bool | true | 页面滚动时是否关闭弹层。 | 否 |
| colorPreset | TPopoverColorPreset | TPopoverColorPreset.defaultTheme | 气泡预设配色。 | 否 |
| content | Widget | - | 气泡内容。 | 是 |
| controller | TPopoverController? | - | 可选控制器，用于从触发区域外部展开或关闭气泡。 | 否 |
| height | double? | - | 内容外框高度（包含 padding）。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onClose | VoidCallback? | - | 气泡通过任意路径关闭后触发。 | 否 |
| onLongTap | VoidCallback? | - | 长按气泡内容时触发。 | 否 |
| onOpen | VoidCallback? | - | 气泡展开后触发。 | 否 |
| onTap | VoidCallback? | - | 点击气泡内容时触发。 | 否 |
| placement | TPopoverPlacement | TPopoverPlacement.top | 浮层出现位置。 | 否 |
| showArrow | bool? | - | 是否显示气泡箭头。 | 否 |
| width | double? | - | 内容外框宽度（包含 padding）。 | 否 |


### TPopoverController

控制与其绑定的 `TPopoverAnchor`。

气泡内容、位置和视觉配置由 `TPopoverAnchor` 声明，控制器只负责展开、关闭
和查询当前状态，不形成第二份配置来源。

#### 构造方法

##### TPopoverController

无参数。

#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| isOpen | bool | - | 与该控制器绑定的气泡是否已展开。 | - |


#### 静态方法

##### TPopoverController.maybeOf

位置参数：`context`


返回 `context` 最近的 `TPopoverAnchor` 所关联的控制器。

未处于 Anchor 的触发区域或气泡内容子树时返回 null。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 当前构建上下文，用于读取祖先配置。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TPopoverController? | - | 最近的 PopoverAnchor 控制器；不在其触发区域或气泡内容子树时为 null。 | - |


#### 实例方法

##### TPopoverController.close

无参数。

关闭与该控制器绑定的气泡。

未绑定或已经关闭时无副作用。

##### TPopoverController.open

无参数。

展开与该控制器绑定的气泡。

控制器必须先通过 `TPopoverAnchor.controller` 绑定到 Widget 树。

### TPopoverThemeData

TPopover 组件级 ThemeExtension

通过 Theme 子树注入，控制子树的默认气泡样式。

#### 构造方法

##### TPopoverThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| arrowSize | double? | - | 箭头尺寸；未配置时为 8 逻辑像素。 | 否 |
| backgroundColor | Color? | - | 气泡背景色 | 否 |
| barrierColor | Color? | - | 蒙层色；未设置时透明。单个气泡可用局部 Theme 覆盖。 | 否 |
| borderRadius | BorderRadius? | - | 气泡圆角；未设置时回退全局默认圆角。单个气泡可用局部 Theme 覆盖。 | 否 |
| boxShadow | List&lt;BoxShadow&gt;? | - | 气泡阴影；未配置时使用 shadow3 Token，Token 为空时无阴影。 | 否 |
| maxHeight | double? | - | 最大高度 | 否 |
| maxWidth | double? | - | 文本内容的最大宽度 | 否 |
| minWidth | double? | - | 最小宽度 | 否 |
| offset | double? | - | 弹层与触发元素的间距；未配置时为 4 逻辑像素。 | 否 |
| padding | EdgeInsetsGeometry? | - | 内边距 | 否 |


#### 实例方法

##### TPopoverThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 字段含义：气泡背景色 调用时的空值行为见方法说明。 | 否 |
| padding | EdgeInsetsGeometry? | - | 字段含义：内边距 调用时的空值行为见方法说明。 | 否 |
| minWidth | double? | - | 字段含义：最小宽度 调用时的空值行为见方法说明。 | 否 |
| maxWidth | double? | - | 字段含义：文本内容的最大宽度 调用时的空值行为见方法说明。 | 否 |
| maxHeight | double? | - | 字段含义：最大高度 调用时的空值行为见方法说明。 | 否 |
| borderRadius | BorderRadius? | - | 字段含义：气泡圆角；未设置时回退全局默认圆角。单个气泡可用局部 Theme 覆盖。 调用时的空值行为见方法说明。 | 否 |
| barrierColor | Color? | - | 字段含义：蒙层色；未设置时透明。单个气泡可用局部 Theme 覆盖。 调用时的空值行为见方法说明。 | 否 |
| arrowSize | double? | - | 字段含义：箭头尺寸；未配置时为 8 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| offset | double? | - | 字段含义：弹层与触发元素的间距；未配置时为 4 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| boxShadow | List&lt;BoxShadow&gt;? | - | 字段含义：气泡阴影；未配置时使用 shadow3 Token，Token 为空时无阴影。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TPopoverThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TPopoverThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TPopoverThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TPopoverThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


##### TPopoverThemeData.merge

位置参数：`other`


合并主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | TPopoverThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TPopoverThemeData | - | 返回合并后的主题；`other` 的非空字段覆盖当前字段，other 为空时返回当前主题。 | - |


### TPopoverColorPreset

弹出气泡的内置配色预设；不切换全局明暗主题。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| defaultTheme | TPopoverColorPreset | - | 默认深色配色。 | - |
| light | TPopoverColorPreset | - | 浅色。 | - |
| primary | TPopoverColorPreset | - | 品牌主色。 | - |
| success | TPopoverColorPreset | - | 成功。 | - |
| warning | TPopoverColorPreset | - | 警告。 | - |
| danger | TPopoverColorPreset | - | 危险色。 | - |


### TPopoverPlacement

气泡弹层定位方向。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| topLeft | TPopoverPlacement | - | 上左。 | - |
| top | TPopoverPlacement | - | 上方。 | - |
| topRight | TPopoverPlacement | - | 上右。 | - |
| rightTop | TPopoverPlacement | - | 右上。 | - |
| right | TPopoverPlacement | - | 右侧。 | - |
| rightBottom | TPopoverPlacement | - | 右下。 | - |
| bottomRight | TPopoverPlacement | - | 下右。 | - |
| bottom | TPopoverPlacement | - | 下方。 | - |
| bottomLeft | TPopoverPlacement | - | 下左。 | - |
| leftBottom | TPopoverPlacement | - | 左下。 | - |
| left | TPopoverPlacement | - | 左侧。 | - |
| leftTop | TPopoverPlacement | - | 左上。 | - |


### TPopoverAnchorBuilder

`TPopoverAnchor` 的触发区域构建器。

位置参数：`context, controller, child`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 触发区域的构建上下文。 | 是 |
| controller | TPopoverController | - | 关联气泡控制器，用于开关气泡与查询状态。 | 是 |
| child | Widget? | - | 传入 Anchor 的可选静态子组件。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | 气泡触发区域内容。 | - |

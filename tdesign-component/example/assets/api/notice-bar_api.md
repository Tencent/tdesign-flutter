## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TNoticeBar
#### 简介
公告栏
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| content | String | '' | 单条公告内容。 当 `items` 非空时不显示此内容。 | 否 |
| direction | Axis | Axis.horizontal | 滚动方向 | 否 |
| interval | Duration | const Duration(seconds: 2) | 垂直轮播的切换间隔，仅在 `direction` 为 `Axis.vertical` 时生效。 | 否 |
| items | List&lt;String&gt; | const &lt;String&gt;[] | 多条公告内容，主要用于垂直轮播。 非空时作为内容数据源，并优先于 `content`。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| marquee | bool | false | 是否启用横向跑马灯展示。 | 否 |
| maxLines | int | 1 | 文本行数（仅静态有效） | 否 |
| onPressed | ValueChanged&lt;TNoticeBarTapTarget&gt;? | - | 点击事件 | 否 |
| operation | Widget? | - | 内容右侧、`suffixIcon` 左侧的自定义操作区。 可以和 `suffixIcon` 同时显示。 | 否 |
| prefix | Widget? | - | 自定义前缀区域。 为 null 时根据 `status` 显示默认图标；传入 `SizedBox.shrink` 可隐藏 前缀区域。组件统一在非空前缀与正文之间保留 `TSpacers.spacer` 间距 （默认 8 逻辑像素）；自定义 `Icon` 中未显式指定的颜色或尺寸会继承公告栏 状态色和标准图标尺寸。 | 否 |
| speed | double | 50 | 横向跑马灯每秒滚动的逻辑像素，仅在 `direction` 为 `Axis.horizontal` 且 `marquee` 为 true 时生效。 | 否 |
| status | TNoticeBarStatus | TNoticeBarStatus.info | 公告栏业务状态，决定默认配色和默认前缀图标。 | 否 |
| suffixIcon | IconData? | - | 尾部图标，可以和 `operation` 同时显示。 | 否 |


### TNoticeBarThemeData
#### 简介
TNoticeBar 组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认公告栏样式。

#### 静态方法

##### TNoticeBarThemeData.lerpDouble

在两个可选数值之间插值。
当仅一端有值时采用离散切换，避免把缺省值错误地当作 0。组件已知默认值
的字段会在 `lerp` 内使用其实际默认值平滑插值。

返回类型：`double?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| a | double? | - | 起始值。 | 是 |
| b | double? | - | 目标值。 | 是 |
| t | double | - | 插值进度。 | 是 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 公告栏背景色 | 否 |
| height | double? | - | 文字高度 | 否 |
| leftIconColor | Color? | - | 公告栏左侧图标颜色 | 否 |
| padding | EdgeInsetsGeometry? | - | 公告栏内边距 | 否 |
| rightIconColor | Color? | - | 公告栏右侧图标颜色 | 否 |
| textStyle | TextStyle? | - | 公告栏内容样式 | 否 |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaultPadding | EdgeInsets | EdgeInsets.only(top: 13, bottom: 13, left: 16, right: 12) | 默认内边距 |


#### 实例方法

##### TNoticeBarThemeData.merge

合并两个 ThemeExtension，`other` 优先于 this

返回类型：`TNoticeBarThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TNoticeBarThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


##### TNoticeBarThemeData.resolve

根据状态和上下文解析出完整的样式（颜色等）

返回类型：`TNoticeBarThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 当前构建上下文，用于读取祖先配置。 | 是 |
| status | TNoticeBarStatus | TNoticeBarStatus.info | 公告栏语义状态，默认 info，用于解析状态对应的颜色。 | 否 |


### TNoticeBarTapTarget
#### 简介
公告栏点击区域
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| prefix | 前缀区域 |
| content | 公告内容 |
| operation | 右侧操作区 |
| suffix | 尾部图标 |


### TNoticeBarStatus
#### 简介
公告栏业务状态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| info | 普通信息（默认）。 |
| success | 成功信息。 |
| warning | 警示信息。 |
| error | 错误信息。 |

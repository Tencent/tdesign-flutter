## API
### TNoticeBar
#### 简介
公告栏
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String | '' | 单条公告内容 |
| direction | Axis | Axis.horizontal | 滚动方向 |
| interval | Duration | const Duration(seconds: 2) | 垂直轮播的切换间隔，仅在 `direction` 为 `Axis.vertical` 时生效。 |
| items | List<String> | const <String>[] | 多条公告内容，主要用于垂直轮播 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| marquee | bool | false | 是否启用横向跑马灯展示。 |
| maxLines | int | 1 | 文本行数（仅静态有效） |
| onPressed | ValueChanged<TNoticeBarTapTarget>? | - | 点击事件 |
| operation | Widget? | - | 内容右侧、`suffixIcon` 左侧的自定义操作区。 可以和 `suffixIcon` 同时显示。 |
| prefix | Widget? | - | 自定义前缀区域。 为 null 时根据 `status` 显示默认图标；传入 `SizedBox.shrink` 可隐藏 前缀区域。自定义内容完全接管该区域的尺寸与间距。 |
| speed | double | 50 | 横向跑马灯每秒滚动的逻辑像素，仅在 `direction` 为 `Axis.horizontal` 且 `marquee` 为 true 时生效。 |
| status | TNoticeBarStatus | TNoticeBarStatus.info | 公告栏业务状态，决定默认配色和默认前缀图标。 |
| suffixIcon | IconData? | - | 尾部图标，可以和 `operation` 同时显示。 |


### TNoticeBarThemeData
#### 简介
TNoticeBar 组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认公告栏样式。

#### 静态方法

##### TNoticeBarThemeData.lerpDouble

返回类型：`double?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| a | double? | - | 起始值。 |
| b | double? | - | 目标值。 |
| t | double | - | 插值进度。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 公告栏背景色 |
| height | double? | - | 文字高度 |
| leftIconColor | Color? | - | 公告栏左侧图标颜色 |
| padding | EdgeInsetsGeometry? | - | 公告栏内边距 |
| rightIconColor | Color? | - | 公告栏右侧图标颜色 |
| textStyle | TextStyle? | - | 公告栏内容样式 |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaultPadding | EdgeInsets | - | 默认内边距 |


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

## API
### TNoticeBar
#### 简介
公告栏
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String | '' | 单条公告内容 |
| direction | Axis | Axis.horizontal | 滚动方向 |
| interval | Duration | const Duration(seconds: 3) | 垂直轮播的切换间隔 |
| items | List<String> | const <String>[] | 多条公告内容，主要用于垂直轮播 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| left | Widget? | - | 左侧内容（自定义左侧内容，优先级高于prefixIcon） |
| marquee | bool | false | 是否启用滚动展示 |
| maxLines | int | 1 | 文本行数（仅静态有效） |
| onPressed | ValueChanged<TNoticeBarTapTarget>? | - | 点击事件 |
| right | Widget? | - | 右侧内容（自定义右侧内容，优先级高于suffixIcon） |
| speed | double | 50 | 每秒滚动的逻辑像素 |


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
| prefixIcon | IconData? | - | 左侧图标 |
| rightIconColor | Color? | - | 公告栏右侧图标颜色 |
| suffixIcon | IconData? | - | 右侧图标 |
| textStyle | TextStyle? | - | 公告栏内容样式 |
| variant | TNoticeBarVariant? | - | 语义色变体 |

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
| prefix | 左侧图标 |
| content | 公告内容 |
| suffix | 右侧图标 |


### TNoticeBarVariant
#### 简介
公告栏语义色
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| info | 信息（默认） |
| success | 成功 |
| warning | 警告 |
| error | 错误 |

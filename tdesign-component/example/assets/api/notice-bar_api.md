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
| prefixIcon | IconData? | - | 左侧图标；`left` 非空时不渲染。 |
| right | Widget? | - | 右侧内容（自定义右侧内容，优先级高于suffixIcon） |
| speed | double | 50 | 每秒滚动的逻辑像素 |
| suffixIcon | IconData? | - | 右侧图标；`right` 非空时不渲染。 |


### TNoticeBarTapTarget
#### 简介
公告栏点击区域
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| prefix | 左侧图标 |
| content | 公告内容 |
| suffix | 右侧图标 |

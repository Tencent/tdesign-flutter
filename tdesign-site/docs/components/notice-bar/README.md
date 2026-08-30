---
title: NoticeBar 公告栏
description: 在导航栏下方，用于给用户显示提示消息。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[t_notice_bar_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_notice_bar_page.dart)

### 01 组件类型

默认根据 `status` 显示前缀图标；使用空 Widget 可以显示纯文字公告栏。

```dart
const TNoticeBar(
  content: '这是一条普通的通知信息',
  prefix: SizedBox.shrink(),
)
```

自定义前缀、操作区和尾部图标。自定义前缀中的 `Icon` 未指定颜色或尺寸时，
会继承当前 `status` 的图标颜色和公告栏标准图标尺寸；显式值优先：

```dart
TNoticeBar(
  content: '这是一条普通的通知信息',
  prefix: const Icon(TIcons.sound),
  operation: const TLink(child: Text('详情')),
  suffixIcon: TIcons.chevron_right,
  onPressed: (target) {
    if (target == TNoticeBarTapTarget.operation) {
      // 打开详情
    }
  },
)
```

`operation` 和 `suffixIcon` 是两个独立区域，可以同时显示。

### 02 组件状态

```dart
const Column(
  children: [
    TNoticeBar(content: '默认状态公告栏'),
    TNoticeBar(
      status: TNoticeBarStatus.success,
      content: '成功状态公告栏',
    ),
    TNoticeBar(
      status: TNoticeBarStatus.warning,
      content: '警示状态公告栏',
    ),
    TNoticeBar(
      status: TNoticeBarStatus.error,
      content: '错误状态公告栏',
    ),
  ],
)
```

### 03 可滚动公告栏

`marquee` 和 `speed` 只控制横向跑马灯：

```dart
const TNoticeBar(
  content: '提示文字描述提示文字描述提示文字描述提示文字描述文',
  marquee: true,
  speed: 80,
)
```

纵向轮播使用 `items`、`direction` 和 `interval`，不需要开启 `marquee`：

```dart
const TNoticeBar(
  prefix: Icon(TIcons.sound),
  items: ['君不见', '高堂明镜悲白发', '朝如青丝暮成雪'],
  direction: Axis.vertical,
  interval: Duration(seconds: 3),
)
```

## API

### TNoticeBar

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String | `''` | 单条公告内容；`items` 非空时不显示 |
| items | List&lt;String&gt; | `const []` | 多条公告内容，主要用于纵向轮播；非空时优先于 `content` |
| status | TNoticeBarStatus | `info` | 业务状态，决定默认配色和默认前缀图标 |
| prefix | Widget? | `null` | 自定义前缀；null 使用状态默认图标，`SizedBox.shrink()` 隐藏前缀；子级 `Icon` 默认继承状态颜色和标准尺寸 |
| operation | Widget? | `null` | 内容右侧、尾部图标左侧的自定义操作区 |
| suffixIcon | IconData? | `null` | 尾部图标，可与 operation 同时显示 |
| direction | Axis | `Axis.horizontal` | 滚动方向 |
| maxLines | int | `1` | 静态文本最大行数 |
| marquee | bool | `false` | 是否启用横向跑马灯 |
| speed | double | `50` | 横向跑马灯每秒滚动的逻辑像素 |
| interval | Duration | `Duration(seconds: 2)` | 纵向轮播切换间隔 |
| onPressed | ValueChanged&lt;TNoticeBarTapTarget&gt;? | `null` | 点击区域回调 |

### TNoticeBarStatus

| 名称 | 说明 |
| --- | --- |
| info | 普通信息（默认） |
| success | 成功信息 |
| warning | 警示信息 |
| error | 错误信息 |

### TNoticeBarTapTarget

| 名称 | 说明 |
| --- | --- |
| prefix | 前缀区域 |
| content | 公告内容 |
| operation | 右侧操作区 |
| suffix | 尾部图标 |

### TNoticeBarThemeData

ThemeExtension 只提供最终样式覆盖，不保存组件业务状态。

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| height | double? | 文字与默认图标高度 |
| backgroundColor | Color? | 公告栏背景色 |
| textStyle | TextStyle? | 公告栏内容样式 |
| leftIconColor | Color? | 默认前缀图标及自定义前缀中未显式着色的 `Icon` 颜色 |
| rightIconColor | Color? | 尾部图标颜色 |
| padding | EdgeInsetsGeometry? | 公告栏内边距 |

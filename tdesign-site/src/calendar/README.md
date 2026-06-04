---
title: Calendar 日历
description: 按照日历形式展示数据或日期的容器；纯日历面板，不含内置弹窗。
spline: data
isComponent: true
---

## 引入

在 `tdesign_flutter/tdesign_flutter.dart` 中导出 [TCalendar]。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

完整示例：[t_calendar_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_calendar_page.dart)

| 场景 | 说明 |
| --- | --- |
| 单选 / 多选 / 区间 | [TCell] + 底部弹层；弹层内独立 [TCalendar] 实例，`onConfirm` 回写 |
| 锚点对比 | 无 `anchorDate` vs 有 `anchorDate` 的首屏月份 |
| 自定义副标题 | [subtitleBuilder] |
| 自定义单元格 | [cellBuilder] |
| 农历 | [subtitleBuilder] + 外置控制栏改 [anchorDate] |

弹层请使用 `showModalBottomSheet`（或 [TPopup]）自行组装，**不再提供** `TCalendar.showPopup`。

## API

<!-- 与 tdesign-component/example/assets/api/calendar_api.md 同步，由 tdesign_flutter_tools 生成 -->

### TCalendar

#### 简介

日历组件（纯日历面板，不含弹窗、表单等封装）。

#### 状态约定

- `initialValue`：**非受控**，仅在组件首次挂载时写入选中态；运行期修改不会同步到界面。外部重置选中请更换 `Key` 或销毁后重建（如弹层关闭再打开）。
- `onChange`：用户点选导致选中变化时触发；挂载阶段不会调用。选中高亮由组件内部维护。
- `anchorDate`：首屏及运行期可更新的**滚动锚点**，滚到该日所在月份，不自动改选中。
- `onMonthChanged`：用户滑动导致可见月份变化时触发，便于外置年月条同步文案。

#### 自定义展示

- `subtitleBuilder`：日期主数字下方的**副标题**（农历、价格、节日等）。
- `cellBuilder`：**整格**自定义，设置后不再渲染默认主数字与副标题布局。
- `monthTitleBuilder`：每个月份区块顶部的年月标题。

弹层场景请自行 `showModalBottomSheet` 包裹本组件，并用新 `Key` 或新实例传入 `initialValue`；外置月份导航请更新 `anchorDate` 而非回写 `initialValue`。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| anchorDate | DateTime? | - | 滚动锚点日期：将列表定位到该日**所在月份**的首屏位置。**不**自动把该日设为选中。运行期更新本参数会重新滚动（见 `animateTo`）。未设置时：有非空 `initialValue` 则滚到其中最早一日所在月，否则滚到 `minDate` 首月。 |
| animateTo | bool | false | `anchorDate` 或首屏定位变更导致滚动时，是否使用动画，默认 false。 |
| cellBuilder | TCalendarCellBuilder? | - | 整格自定义构建器；与 `subtitleBuilder` 互斥。 |
| firstDayOfWeek | int | 0 | 第一天从星期几开始，0 = 周日 … 6 = 周六。 |
| height | double? | - | 高度，不传时自动按 5 行日期计算 |
| initialValue | List&lt;DateTime&gt;? | - | 初始选中（**非受控**，仅挂载生效）。不传时内部选中为空。 |
| key | Key? | - | 组件标识；重置选中时请更换 Key |
| maxDate | DateTime? | - | 最大可选日期，默认 2100-12-31 |
| minDate | DateTime? | - | 最小可选日期，默认 1970-01-01 |
| monthTitleBuilder | TCalendarMonthTitleBuilder? | - | 月标题构建器 |
| onCellTap | void Function(TCalendarCellModel cell)? | - | 每次点击日期格；选中结果以 `onChange` 为准 |
| onChange | ValueChanged&lt;List&lt;DateTime&gt;&gt; | - | 选中变化（必填）；挂载时不调用 |
| onMonthChanged | ValueChanged&lt;DateTime&gt;? | - | 可见月份变化（当月 1 日） |
| style | TCalendarStyle? | - | 自定义样式 |
| subtitleBuilder | TCalendarSubtitleBuilder? | - | 副标题构建器 |
| type | CalendarType | CalendarType.single | single / multiple / range |

### TCalendarStyle

`TCalendar` 的样式配置。使用 `TCalendarStyle.generateStyle` 获取主题默认样式，再用 `forSelectType` 按 `DateSelectType` 区分各态样式。

### CalendarType / DateSelectType

| CalendarType | 说明 |
| --- | --- |
| single | 单选 |
| multiple | 多选 |
| range | 区间 |

| DateSelectType | 说明 |
| --- | --- |
| selected | 选中 |
| disabled | 禁用 |
| start / centre / end | 区间起止与中间 |
| empty | 未选中 |

### TCalendarSubtitleBuilder / TCalendarCellBuilder

- `TCalendarSubtitleBuilder`：副标题；返回 `null` 不显示副标题行。
- `TCalendarCellBuilder`：整格自定义；返回非 null 时替换默认格布局。

完整参数表见仓库内 `tdesign-component/example/assets/api/calendar_api.md`，可用 `tdesign_flutter_tools` 从源码注释重新生成。

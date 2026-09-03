# Calendar 公开 Demo 与日期契约对齐

## 背景

Flutter Calendar 当前公开 Demo 按内部能力拆分，和小程序公开页面的分组、实例顺序及触发式体验不一致；日期边界携带时分秒时还会把边界当天误判为不可选。

## 目标

- 公开 Demo 按小程序 `b60cdc8a1dce1f06dd45cb4e41eefd31c674e514` 的页面顺序覆盖基础、多选、描述、翻页、区间、国际化、不可选和无 Popup 场景。
- Popup、确认栏、本地化和月份切换优先由 Flutter Widget 组合表达，不扩张 `TCalendar` 公共 API。
- `minDate` / `maxDate` 按自然日解释并允许单日范围。
- 默认高度完整容纳六行日期的月份，不裁切最后一行。
- 补齐 Demo 结构、交互、light/dark Golden 与组件回归证据。

## 非目标

- 不复制小程序 `visible`、`usePopup`、`autoClose`、`confirmBtn`、`localeText`、`defaultValue` 等平台编排参数。
- 不把弹层或工具栏重新合并进纯日历面板。
- 不改变 1970-01-01 至 2100-12-31 的既有默认范围。

## 行为契约

- `value + onChanged` 继续构成严格受控状态；`onChanged == null` 是唯一禁用入口。
- `variant` 继续唯一表达 single / multiple / range 选择行为。
- `minDate` 与 `maxDate` 忽略时分秒；二者可以是同一天，但前者不能晚于后者。
- `firstDayOfWeek` 仅接受 0...6。
- 未通过 Theme 指定高度时，Calendar 按六行月份计算默认高度。
- Popup、标题、确认/取消、月份翻页及逐实例语言由 Demo 组合完成。

## 验收标准

- 公开页面仅出现两组、九个可见实例，顺序与小程序一致。
- 每个触发场景可打开底部日历并在确认后更新页面值；取消不提交。
- inline 多选场景保持可交互。
- 组件测试、Demo 功能测试、light/dark Golden、覆盖率和双版本 analyze 通过。

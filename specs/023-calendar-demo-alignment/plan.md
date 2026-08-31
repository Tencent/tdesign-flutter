# 技术方案

- 使用 `ExamplePage.compactDemo`、`ExampleModule`、`ExampleItem` 与 `TCellGroup` 重排公开页面。
- 使用 `TPopup + TPopupHeader + TCalendar` 组合弹出式日历；月份翻页使用 `anchorDate` 的声明式组合；逐实例英文使用 `Localizations.override` 和 `monthTitleBuilder`。
- 构造阶段将边界转为年月日，并增加 `firstDayOfWeek` 与范围断言。
- 新增组件边界测试、Demo 全页结构/交互测试及固定字体的 light/dark Golden。

## API Review

| 能力 | Flutter 结论 |
| --- | --- |
| `value/defaultValue` | 仅保留严格受控 `value`，不增加第二状态源 |
| `readonly` | 使用 nullable `onChanged`，不增加重复禁用入口 |
| `type` | 使用 `variant` 表达选择形态，符合现有 Flutter 命名 |
| Popup/visible/title/confirm | 属于外层编排，使用 Widget 组合 |
| `format` | 使用 `cellBuilder/subtitleBuilder`，避免可变数据对象泄漏 |
| `localeText` | 使用 Flutter Localizations 与 builder |
| `switchMode` | 使用外部工具栏与 `anchorDate` 组合 |
| 默认范围 | 保留既有宽范围，避免无授权 breaking；Demo 显式传入业务范围 |

## 风险

- Demo Popup 高度随视口变化，需在 375dp 视口验证裁切和内部滚动。
- macOS 字体栅格只作辅助预检；权威 Golden 固定 Flutter 3.32.0 Linux。

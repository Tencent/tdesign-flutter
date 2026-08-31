# DateTimePicker 公开 Demo 对齐

## 目标

- 按小程序 `b60cdc8a1dce1f06dd45cb4e41eefd31c674e514` 的公开顺序覆盖年月日、年月、时分秒、时分、完整日期时间、步长和无 Popup。
- 保持 `TDateTimePicker` 为纯滚轮、严格受控组件；Popup 与确认草稿由 Flutter 组合层持有。
- Review 全量 API、默认值、重复入口与状态所有权，并补齐 Demo、Golden、组件回归和覆盖率证据。

## API 契约

- `value + onChanged` 是唯一受控路径；`onChanged == null` 禁用。
- `DateTimePickerMode(dateMode:, timeMode:)` 以 typed 组合替代小程序字符串/数组 mode。
- `DateTimePickerSteps`、`start`、`end` 和 `showWeek` 保持单一职责；未配置步长默认为 1。
- `visible`、`usePopup`、`title`、按钮、`defaultValue` 和格式字符串属于小程序容器/动态数据契约，不复制到 Flutter 滚轮组件。
- 保持年月日默认 mode，不改变既有默认行为。

## 验收标准

- 页面按两组七个可见实例展示；第二组使用顺序编号 `02`，不复制小程序页面重复使用 `01` 的内容错误。
- Popup 取消不提交、确定提交；inline 实例实时受控。
- 组件测试、Demo 测试、light/dark Golden、覆盖率和双版本 analyze 通过。

# Calendar 滚轮 Legacy 路径迁移规划

## 背景

`TDateTimePicker` 已统一为 **Snapshot + DateTimePickerWheel** 架构。  
`TCalendar` 内部仍通过 [`DatePickerModel`](../calendar/date_picker_model.dart) 使用滚轮，存在双轨实现：

| 路径 | 触发条件 | UI | 数据层 |
|------|----------|-----|--------|
| **Snapshot** | `useWeekDay == false` 且 `filterItems == null` | `DateTimePickerWheel` | `DateTimePickerSnapshot` |
| **Legacy** | `useWeekDay == true` 或 `filterItems != null` | `TDatePicker._buildLegacyWheel` 自绘 `ListWheelScrollView` | `DatePickerModel.data` / `controllers` |

新接入业务应直接使用 `TDateTimePicker`，勿再扩展 Legacy 路径。

## 语义差异（迁移时需对齐）

### 1. 星期展示

| | TDateTimePicker | Calendar Legacy |
|--|-----------------|-----------------|
| API | `showWeek: true` | `useWeekDay: true` |
| 表现 | 日列 label 后缀（如 `15日 周五`） | **独立 week 列** |
| 选中值 | `TDateTimePickerValue` 无 week 字段 | `selected['week']` |

**迁移建议**：Legacy 的 `useWeekDay` 改为 `showWeek` + Snapshot 路径；week 展示用 `toDateTime().weekday` 派生。

### 2. 列过滤

| | TDateTimePicker | Calendar Legacy |
|--|-----------------|-----------------|
| API | 无 `filterItems` | `filterItems(key, items)` 回调 |
| 表现 | 边界由 `start`/`end` + Snapshot 收紧 | 按列 key 过滤 options |

**迁移建议**：

- 短期：保留 Legacy，文档标明仅 TCalendar 内部兼容。
- 长期：评估是否用 `renderLabel` + `start`/`end` 覆盖常见过滤场景；无法覆盖时再设计公开 API（避免回调式 `filterItems` 泄漏到 `TDateTimePicker`）。

### 3. 数据类型

| | TDateTimePicker | Calendar (`TDatePicker`) |
|--|-----------------|--------------------------|
| 选中结果 | `TDateTimePickerValue` | `Map<String, int>` via `model.selected` |
| 范围 | `TDateTimePickerValue?` start/end | `List<int>?` dateStart/dateEnd |

**迁移建议**：`DatePickerModel.selected` 可继续提供 `Map` 适配，内部统一 `snapshot.toResult()`（已实现）。

## 迁移阶段

### 阶段 1（当前，已完成）

- [x] Snapshot 路径作为 `DatePickerModel` 默认（无 week / 无 filter）
- [x] `TDateTimePicker` 与 Calendar 共享 `DateTimePickerWheel`
- [x] 单元测试覆盖 Snapshot 边界与 widget 集成

### 阶段 2（建议）

1. 盘点 TCalendar 中 `useWeekDay: true` 的调用点，改为 `showWeek` + Snapshot 路径。
2. 为 `filterItems` 场景建立用例清单，逐个评估能否用 `start`/`end`/`renderLabel` 替代。
3. 补充 `DatePickerModel` Legacy 路径 widget 测试（当前覆盖薄）。

### 阶段 3（可选）

1. 删除 `_buildLegacyWheel` 与 `DatePickerModel` 中 `data`/`controllers` 遗留字段。
2. `TDatePicker` 标记 `@Deprecated`，引导使用 `TDateTimePicker` + `TPopup`。

## 风险

- Legacy 与 Snapshot 在闰月、步进、range 收紧上行为可能不一致，迁移需逐场景回归 TCalendar 演示页。
- `filterItems` 若无法替代，需单独设计 API，避免再次分叉实现。

## 相关文件

- [`t_date_time_picker.dart`](t_date_time_picker.dart) — 对外组件
- [`t_date_time_picker_internal.dart`](t_date_time_picker_internal.dart) — Snapshot / 边界（part 拆分）
- [`t_date_picker.dart`](../calendar/t_date_picker.dart) — Calendar 内嵌选择器
- [`date_picker_model.dart`](../calendar/date_picker_model.dart) — 双轨入口

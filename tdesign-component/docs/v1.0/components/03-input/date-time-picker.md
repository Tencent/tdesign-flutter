# TDateTimePicker — v1.0 定稿

> Sprint **S4** | 控制类 **F** | Material: Wheel
> 源码：`lib/src/components/date-time-picker` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘滚轮；底层复用 `TPicker` 能力 |
| Material | Cupertino/Material 滚轮对照 |
| Theme | `TPickerThemeData`（与 TPicker 共用） |
| 禁用 | Widget 级 `onChanged: null`（F 类） |
| L4 | mode/start/end/steps 等 → **`TPickerThemeData`** |

## 受控

`value` + `onChanged`；项级 `*.disabled` KEEP。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TDateTimePicker | 纯滚轮 Widget（无工具栏） |
| DateTimePickerMode | 年月日时分组合 |
| TDateTimePickerValue | 列快照 / partial 初值 |
| renderLabel | 列标签定制 |
| showWeek | 是否显示星期列 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| onChange | onChanged | F 类 |
| initialValue | value | 受控；不用 Widget 级一次性初值 |
| mode / start / end / steps | TPickerThemeData | L4 → Theme |
| height / itemCount | TPickerThemeData | 与 TPicker 共用 |
| showWeek / renderLabel | TPickerThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| initialValue（非受控重置） | 改 `value` + 父 State；重置用 `key` 破例 |

### 新增

| 符号 | 说明 |
| --- | --- |
| value | 受控 `DateTime` / `TDateTimePickerValue` |
| TPickerController | 可选；与 TPicker 共用 |

### show API（嵌入 TPopup）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `value` | L1 | **新增** | 受控选中时刻 |
| `onChanged` | L3 | **改名** | 原 `onChange` |
| `mode` | L1/L4 | → Theme 默认 | `DateTimePickerMode` |
| `start` / `end` / `steps` | L4 | → Theme | 范围与步进 |
| `showWeek` / `renderLabel` | L4 | → Theme | 列定制 |
| 工具栏/确认 | — | **业务组装** | 配合 `TPopup.show` + 确认按钮 |

### L4 迁入 `TPickerThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `mode` | `dateTimeMode` | CupertinoDatePicker mode |
| `start` / `end` | `minDate` / `maxDate` | 范围 |
| `steps` | `stepMinutes` 等 | 步进 |
| `showWeek` / `renderLabel` | `showWeek` / `columnLabelBuilder` | TDesign 扩展 |
| `height` / `itemCount` | 与 [picker.md](./picker.md) 共用 | 滚轮视窗 |

### export

- **保留**：`TDateTimePicker`、`DateTimePickerMode`、`TDateTimePickerValue`、`DateTimePickerRenderLabel`、`TPickerThemeData`
- **移出**：`t_date_time_picker_internal.dart` 实现细节（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TPickerThemeData` · Material: **Wheel** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` / `onChanged` | TDesign Widget API | `DateTime` 受控 |
| `mode` / `start` / `end` / `steps` | **`TPickerThemeData`** | 年月日时分列与范围 L4 |
| `showWeek` / `renderLabel` | **`TPickerThemeData`** | 星期列与列标签 |
| `height` / `itemCount` | **`TPickerThemeData`** | 与 [TPicker](./picker.md) 共用滚轮 Theme |

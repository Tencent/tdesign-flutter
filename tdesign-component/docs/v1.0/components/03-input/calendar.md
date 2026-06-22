# TCalendar — v1.0 定稿

> Sprint **S4** | 控制类 **F** | Material: 自绘
> 源码：`lib/src/components/calendar` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘 + Material 底座（滚轮/日历等） |
| Material | 自绘 |
| Theme | `TCalendarThemeData` |
| 禁用 | Widget 级: onChanged: null |
| L4 | `cellBuilder` → **`TCalendarThemeData`** |

## 受控

`value` + `onChanged`；项级 `*.disabled` KEEP。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TCalendar | 月历面板 |
| TCalendarVariant | 单选/范围等模式 |
| minDate / maxDate | 可选区间；区间外格自动 disabled |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| CalendarType | TCalendarVariant | 命名对齐 v1.0 |
| style | TCalendarThemeData | L4 → Theme |
| onChange | onChanged | 命名对齐 v1.0 |
| firstDayOfWeek | TCalendarThemeData | L4 → Theme |
| height | TCalendarThemeData | L4 → Theme |
| onMonthChanged | TCalendarThemeData | L4 → Theme |
| monthTitleBuilder | TCalendarThemeData | L4 → Theme |
| cellBuilder | TCalendarThemeData | L4 → Theme |
| subtitleBuilder | TCalendarThemeData | L4 → Theme |
| animateTo | TCalendarThemeData | L4 → Theme |
| anchorDate | TCalendarThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| type | 改名 → `variant`（废弃参数名 `type`） |
| initialValue | - [CalendarType.range]：2 个元素（起始、结束日期） |

### 新增

| 符号 | 说明 |
| --- | --- |
| value | 受控 `List<DateTime>`；配套 `onChanged`；初值由父 State 持有 |
| TCalendarVariant | 单选/范围等模式（原 `CalendarType`） |
| TCalendarThemeData | L4 月历布局与 builder 默认 |

### show API（嵌入 TPopup / 路由）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `value` | L1 | **新增** | 受控 `List<DateTime>` |
| `onChanged` | L3 | **改名** | 原 `onChange` |
| `variant` | L1 | **改名** | 原 `type` / `CalendarType` |
| `minDate` / `maxDate` | L2 | **保留** | 可选区间 |
| `cellBuilder` 等 | L4 | → Theme | 单元格/标题定制默认 |
| 命令式整页 | — | **可选** | 全屏日期选择可 `Navigator`；面板场景配合 `TPopup.show` |

### L4 迁入 `TCalendarThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `firstDayOfWeek` / `height` / `style` | 月历布局默认 | 自绘；Material `showDatePicker` 为对照 |
| `cellBuilder` / `subtitleBuilder` / `monthTitleBuilder` | builder 默认 | TDesign 扩展 |
| `onMonthChanged` / `animateTo` / `anchorDate` | 翻月行为默认 | TDesign 扩展 |

### export

- **保留**：`TCalendar`、`TCalendarVariant`、`DateSelectType`、`TCalendarThemeData`
- **移出**：`TCalendarStyle`、`t_calendar_style.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TCalendarThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` / `onChanged` | TDesign Widget API | `List<DateTime>` 受控 |
| `variant` | TDesign Widget API | 由 `type`/`CalendarType` 迁移；单选/范围等模式 |
| `minDate` / `maxDate` | TDesign Widget API | **保留**实例 L2；区间外格自动 `DateSelectType.disabled` |
| `firstDayOfWeek` / `height` / `style` | TDesign **`TCalendarThemeData`** | 月历布局 L4 |
| `cellBuilder` / `subtitleBuilder` / `monthTitleBuilder` | TDesign **`TCalendarThemeData`** | 单元格与标题定制 |
| `onMonthChanged` / `animateTo` / `anchorDate` | TDesign **`TCalendarThemeData`** | 翻月与定位行为默认 |
| `showDatePicker` 等 | Material 对照 | 命令式日期选择走 Material；**内嵌日历面板**走 TCalendar |

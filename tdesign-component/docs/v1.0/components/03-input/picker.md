# TPicker — v1.0 定稿

> Sprint **S4** | 控制类 **F** | Material: 自绘滚轮
> 源码：`lib/src/components/picker` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘 + Material 底座（滚轮/日历等） |
| Material | 自绘滚轮 |
| Theme | `TPickerThemeData` |
| 禁用 | Widget 级: onChanged: null |
| L4 | `onColumnScrollEnd` → **`TPickerThemeData`** |

## 受控

`value` + `onChanged`；项级 `*.disabled` KEEP。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TPicker | 滚轮选择器 |
| items | 数据源（`TPickerColumns` / `TPickerLinked`） |
| TPickerOption / TPickerValue | 选项与选中快照 |
| TPickerOption.disabled | 行级不可选（数据字段） |
| itemBuilder | 自定义滚轮项 |
| columnBuilder | 自定义列（见 export） |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| onChange | onChanged | F 类；`void Function(int col, TPickerValue value)?` |
| initialValue | — | 移除；父 State 持有 `value` |
| height / itemCount | TPickerThemeData | L4 → Theme |
| onColumnScrollEnd | TPickerThemeData | L4 默认回调 |
| disabled | onChanged: null | 整组禁用 |

### 废弃

| 符号 | 原因 |
| --- | --- |
| initialValue | init 一次性语义 → 父 State + `value` |
| disabled | Widget 级 bool → `onChanged: null` |

### 新增

| 符号 | 说明 |
| --- | --- |
| value | 受控各列选中值 `List<dynamic>` |
| TPickerController | 可选命令式 |
| TPickerThemeData | L4 滚轮视窗与列行为 |

### show API（嵌入 TPopup）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `value` | L1 | **保留** | 受控各列选中值 |
| `onChanged` | L3 | **改名** | 原 `onChange` |
| `items` / `itemBuilder` | L2 | **保留** | 数据源与项渲染 |
| `height` / `itemCount` | L4 | → Theme | 滚轮视窗默认 |
| 工具栏/确认 | — | **业务组装** | 配合 `TPopup.show` + 确认按钮写入父 State |

### L4 迁入 `TPickerThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `height` / `itemCount` | 滚轮视窗 | CupertinoPicker 近似 |
| `onColumnScrollEnd` | 列滚动结束默认 | TDesign 扩展 |
| `itemBuilder` 默认 | `defaultItemBuilder` | TDesign 扩展 |

### export

- **保留**：`TPicker`、`TPickerOption`、`TPickerValue`、`TPickerColumnData`、`TPickerController`、`TPickerThemeData`、公开 `columnBuilder` typedef
- **移出**：`picker_data.dart`、`picker_keys.dart`（附录 C 默认移出）、`picker_item.dart` 收窄（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TPickerThemeData` · Material: **自绘滚轮** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `child` / `value` / `onChanged` | TDesign Widget API | F 类受控；无 Material 同名 Widget |
| `TPickerOption.disabled` | TDesign 数据模型 | 行级不可选；非 Widget `disabled` |
| `height` / `itemCount` / `itemBuilder` | TDesign **`TPickerThemeData`** | 滚轮列 L4；0.2.x 构造器迁入 |
| `onColumnScrollEnd` | TDesign **`TPickerThemeData`** | 列滚动结束回调默认 |
| CupertinoPicker 视觉参考 | Material 生态对照 | 实现可参考 `CupertinoPicker`，但 API 走 Extension |

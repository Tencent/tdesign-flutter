# TProgress — v1.0 定稿

> Sprint **S2** | 控制类 **C** | Material: ProgressIndicator
> 源码：`lib/src/components/progress` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 连续值控件薄包装 |
| Material | ProgressIndicator |
| Theme | `TProgressThemeData` |
| 禁用 | `onChanged: null`（或省略 `onChanged` ≈ 禁用）。 |
| L4 | 构造器 L4 → `TProgressThemeData` |

## 受控

`value` + `onChanged`（含 `onChangeStart`/`End` 等）。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TProgressLabelPosition | 尺寸/位置枚举保留 |
| value | C 类进度值（ KEEP） |
| label | 进度文案（ KEEP） |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TProgressType | variant | 命名对齐 v1.0 |
| variant | variant | v1.0 语义形态 |
| onTap | onPressed | 命名对齐 v1.0 |
| progressStatus | TProgressThemeData | L4 → Theme |
| progressLabelPosition | TProgressThemeData | L4 → Theme |
| strokeWidth | TProgressThemeData | L4 → Theme |
| color | TProgressThemeData | L4 → Theme |
| backgroundColor | TProgressThemeData | L4 → Theme |
| linearBorderRadius | TProgressThemeData | L4 → Theme |
| circleRadius | TProgressThemeData | L4 → Theme |
| showLabel | TProgressThemeData | L4 → Theme |
| customProgressLabel | TProgressThemeData | L4 → Theme |
| labelWidgetWidth | TProgressThemeData | L4 → Theme |
| labelWidgetAlignment | TProgressThemeData | L4 → Theme |
| animationDuration | TProgressThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| TProgressStatus | 内部状态枚举，v1.0 不公开 |
| onLongPress | REMOVE：非设计稿关键态；与 Button 一致删除 |

### 新增

_无_

### export

- **保留**：`TProgress`、`TProgressLabelPosition`、`TProgressThemeData`
- **移出**：`TProgressStatus` 内部状态 enum（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TProgressThemeData` · Material: **ProgressIndicator** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `color` / `linearTrackColor` / `circularTrackColor` / `strokeWidth` | Material **`ProgressIndicatorTheme`** | 线型/环形轨道 |
| `variant` | TDesign **`TProgressThemeData`** | 原 `type` / `TProgressType` |
| `linearBorderRadius` / `circleRadius` / `showLabel` / `customProgressLabel` | TDesign 扩展 | 标签位置与圆角 |
| `progressLabelPosition` | TDesign 扩展 | 原 `TProgressLabelPosition` 默认 |

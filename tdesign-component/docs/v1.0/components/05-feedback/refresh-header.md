# TRefreshHeader — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: easy_refresh
> 源码：`lib/src/components/refresh` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | easy_refresh |
| Theme | `TRefreshThemeData` |
| 禁用 | 无 Widget 级禁用相关字段。`enableHapticFeedback` / `enableInfiniteRefresh` 为能力开关，见 [disabled-evolution.md §6](../foundation/disabled-evolution.md#6-易混淆名字含-enabledisable-但不是组件禁用)。 |
| L4 | `spring` → **`TRefreshThemeData`** |

## 受控

无受控 value；按子交互控件控制类处理。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| enableHapticFeedback | 下拉触觉反馈，保留（≠ 禁用） |
| enableInfiniteRefresh | 无限刷新开关，保留（≠ 禁用） |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| loadingIcon | TRefreshThemeData | L4 → Theme |
| backgroundColor | TRefreshThemeData | L4 → Theme |
| extent | TRefreshThemeData | L4 → Theme |
| triggerDistance | TRefreshThemeData | L4 → Theme |
| float | TRefreshThemeData | L4 → Theme |
| completeDuration | TRefreshThemeData | L4 → Theme |
| infiniteOffset | TRefreshThemeData | L4 → Theme |
| overScroll | TRefreshThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TRefreshHeader`、`TRefreshThemeData`
- **移出**：内部 `*Style`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TRefreshThemeData` · Material: **easy_refresh** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `triggerOffset` / `triggerDistance` / `extent` | **easy_refresh `Header`** | 触发与占位高度 |
| `clamping` / `float` / `overScroll` | **easy_refresh `Header`** | 回弹与越界 |
| `processedDuration` / `completeDuration` | **easy_refresh `Header`** | 完成态停留 |
| `hapticFeedback` / `enableHapticFeedback` | **实例 KEEP** | 触觉开关（≠ 禁用） |
| `infiniteOffset` / `enableInfiniteRefresh` | **实例 KEEP** | 无限刷新 |
| `loadingIcon` / `backgroundColor` | TDesign **`TRefreshThemeData`** | 指示器与背景 L4 |
| `spring` / `frictionFactor` 等 | **easy_refresh `Header`** | 物理参数默认 Theme |

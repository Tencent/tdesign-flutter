# TSwipeCell — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: flutter_slidable 包装
> 源码：`lib/src/components/swipe-cell` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | flutter_slidable 包装 |
| Theme | `TSwipeCellThemeData` |
| 禁用 | 侧滑能力用 `enabled: false`，不是 A/B 类 `onPressed`/`onChanged`。 |
| L4 | `close` → **`TSwipeCellThemeData`** |

## 受控

无受控 value；按子交互控件控制类处理。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TSwipeDirection | KEEP：L1 语义枚举 |
| controller | KEEP：L1–L3 高频 / Material 同名 |
| direction | KEEP：L1–L3 高频 / Material 同名 |
| close | KEEP：工具/static 方法保留 |
| of | KEEP：工具/static 方法保留 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| onChange | onChanged | 命名对齐 v1.0 |
| disabled | enabled: false | Material 禁用 |
| slidableKey | TSwipeCellThemeData | L4 → Theme |
| cell | TSwipeCellThemeData | L4 → Theme |
| opened | TSwipeCellThemeData | L4 → Theme |
| groupTag | TSwipeCellThemeData | L4 → Theme |
| closeWhenOpened | TSwipeCellThemeData | L4 → Theme |
| closeWhenTapped | TSwipeCellThemeData | L4 → Theme |
| dragStartBehavior | TSwipeCellThemeData | L4 → Theme |
| duration | TSwipeCellThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TSwipeCell`、`TSwipeDirection`、`TSwipeCellThemeData`
- **移出**：`flutter_slidable` re-export、`t_swipe_cell_inherited.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TSwipeCellThemeData` · Material: **flutter_slidable 包装** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `child` | **Slidable** 内容 | 实例 KEEP |
| `left` / `right` 操作区 | **SlidableAction** | 实例 actions KEEP |
| `controller` | **SlidableController** | KEEP |
| `direction` | **Slidable** | KEEP |
| `closeWhenOpened` / `closeWhenTapped` / `dragStartBehavior` / `duration` | **`TSwipeCellThemeData`** | L4 |
| `close` / `of` | static 工具 | KEEP |

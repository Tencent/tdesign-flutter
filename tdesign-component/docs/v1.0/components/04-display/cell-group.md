# TCellGroup — v1.0 定稿

> Sprint **S3** | 控制类 **A** | Material: Column
> 源码：`lib/src/components/cell-group` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | Column |
| Theme | `TCellThemeData` |
| 禁用 | `onTap: null`（Material ListTile/TabBar 系保留 `onTap`，不用 `onPressed`）。 |
| L4 | 构造器 L4 → `TCellThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| cells | `List<TCell>` 子项 |
| builder | `CellBuilder` 自定义 cell 父组件 |
| title / titleWidget | 组标题 |
| bordered / isShowLastBordered | 组边框 |
| scrollable | 组内可滚动 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TCellGroupTheme | TCellThemeData.groupVariant | default / card |
| theme | TCellThemeData | L4 → Theme |
| style | TCellThemeData | 移除 `TCellStyle` 实例 |

### 废弃

| 符号 | 原因 |
| --- | --- |
| TCellStyle 构造器参数 | 不 export；迁入 `TCellThemeData` |
| TCellGroupTheme | 迁入 Theme |

### 新增

_无_（复用 [cell.md](./cell.md) 的 `TCellThemeData`）

### export

- **保留**：`TCellGroup`、`TCellThemeData`
- **移出**：`TCellGroupTheme`、`TCellStyle`、`t_cell_style.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TCellThemeData` · Material: **Column** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| children | Material **`Column`** / List | **`TCell` 子项组合** |
| `bordered` / `isShowLastBordered` | **`TCellThemeData`** | 组级边框默认 |
| `style` | **`TCellThemeData`** | 组级 L4 |

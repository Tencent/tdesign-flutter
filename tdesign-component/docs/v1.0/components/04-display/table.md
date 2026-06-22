# TTable — v1.0 定稿

> Sprint **S4** | 控制类 **—** | Material: 自绘
> 源码：`lib/src/components/table` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | 自绘 |
| Theme | `TTableThemeData` |
| 禁用 | 无 Widget 级 bool。 |
| L4 | `loading` → **`TTableThemeData`** |

## 受控

无受控 value；按子交互控件控制类处理。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| columns / TTableCol | 列定义 |
| data | 数据源 |
| onCellTap / onScroll | 单元格与滚动 |
| onSelect / onRowSelect | 行选择 |
| empty / loading / showHeader / footerWidget | 空态、加载与结构 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| bordered / stripe | TTableThemeData | L4 → Theme |
| rowHeight / height / width | TTableThemeData | L4 → Theme |
| backgroundColor / defaultSort | TTableThemeData | L4 → Theme |
| loadingWidget | TTableThemeData | L4 → Theme |

### 废弃

_无_

### 新增

| 符号 | 说明 |
| --- | --- |
| TTableThemeData | L4 表格默认样式 |

### export

- **保留**：`TTable`、`TTableThemeData`
- **移出**：内部 `*Style`、表格渲染 helper（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TTableThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `columns` / `data` | TDesign 实例 | 列定义与行数据 |
| `onCellTap` / `onScroll` / `onSelect` / `onRowSelect` | 实例 KEEP | 交互回调 |
| `empty` / `loadingWidget` / `footerWidget` | 实例 KEEP | 槽位 Widget |
| `bordered` / `stripe` / `showHeader` | 默认 Theme；可实例破例 | **`TTableThemeData`** |
| `height` / `rowHeight` / `backgroundColor` / `defaultSort` | **`TTableThemeData`** | L4 |
| `loading` | **`TTableThemeData`** | 默认 loading 态 |

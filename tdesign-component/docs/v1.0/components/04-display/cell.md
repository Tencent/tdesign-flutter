# TCell — v1.0 定稿

> Sprint **S3** | 控制类 **A** | Material: ListTile
> 源码：`lib/src/components/cell` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | ListTile |
| Theme | `TCellThemeData` |
| 禁用 | 不设 `disabled` 参数。 |
| L4 | 构造器 L4 → `TCellThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| arrow | 是否显示右侧箭头 |
| title | 标题 |
| TCellAlign | 保留 |
| bordered | 保留 |
| subtitle | 由 `description` 迁移 |
| prefix | 由 `leftIcon` 迁移 |
| onTap | 由 `onClick` 迁移；`GestureTapCallback?` |
| onLongPress | 保留 — Material `ListTile.onLongPress` |
| titleWidget | 保留 — 实例标题 Widget |
| subtitleWidget | 由 `descriptionWidget` 保留/更名 |
| image / imageWidget / imageSize / imageCircle | 保留 — leading 图片区 |
| leftIconWidget / prefix | 保留 — 左侧区 |
| note / noteWidget / noteMaxWidth / noteMaxLine | 保留 — 右侧 note 区 |
| rightIcon / rightIconWidget | 保留 — trailing 区 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| description | subtitle | 命名对齐 v1.0 |
| leftIcon | prefix | 命名对齐 v1.0 |
| onClick | onTap | 命名对齐 v1.0 |
| disabled | onTap: null | Material 禁用 |
| style | TCellThemeData | L4 → Theme |
| align | TCellThemeData | L4 → Theme |
| hover | TCellThemeData | L4 → Theme |
| showBottomBorder | TCellThemeData | L4 → Theme |
| height | TCellThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| TCellClick | 废弃 → `GestureTapCallback? onTap`（同 Material `ListTile.onTap`） |

### 新增

_无_

### export

- **保留**：`TCell`、`TCellAlign`、`TCellThemeData`
- **移出**：`TCellStyle`、`TCellClick`（废弃 typedef）（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TCellThemeData` · Material: **ListTile** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `title` / `subtitle` / `leading` / `trailing` | Material **`ListTile`** | 映射 `title` / `subtitle` / `prefix` / `note`+`arrow` |
| `onTap` / `onLongPress` | Material **`ListTile`** | `GestureTapCallback?` |
| `titleWidget` / `subtitleWidget` / `*Widget` 槽位 | **实例 KEEP** | 每行内容不同；Material `title`/`subtitle` 可为 Widget |
| `titleColor` / `iconColor` / `contentPadding` / `dense` | Material **`ListTileTheme`** | 默认样式 |
| `note` 区 / `arrow` 布局 | TDesign 扩展 | Material ListTile 无 note 语义 |
| `bordered` / `hover` / `height` 默认 | TDesign **`TCellThemeData`** | L4 默认 |

# TResult — v1.0 定稿

> Sprint **S3** | 控制类 **A** | Material: 自绘
> 源码：`lib/src/components/result` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | 自绘 |
| Theme | `TResultThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → `TResultThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| icon | KEEP：L1–L3 高频 / Material 同名 |
| title | KEEP：L1–L3 高频 / Material 同名 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TResultTheme | TResultVariant | `TResultVariant`（`default` / `success` / `warning` / `error`） |
| description | subtitle | 命名对齐 v1.0 |
| titleStyle | TResultThemeData | L4 → Theme |
| theme | variant | 命名对齐 v1.0 |

### 废弃

| 符号 | 原因 |
| --- | --- |
| `TResultTheme` | → `TResultVariant` |

### 新增

| 符号 | 说明 |
| --- | --- |
| **TResultVariant** | 结果态语义 |
| variant | 由 `theme` 迁移 |

### export

- **保留**：`TResult`、`TResultVariant`、`TResultThemeData`
- **移出**：`TResultTheme`（enum）、构造器 `titleStyle` 等 L4 Style（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TResultThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `icon` / `title` / `subtitle` | **实例 KEEP** | 结果内容 |
| `variant` | **实例** | 默认图标/语义色映射 |
| `titleStyle` | TDesign **`TResultThemeData`** | 标题 L4 默认 |

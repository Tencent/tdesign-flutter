# TNoticeBar — v1.0 定稿

> Sprint **S3** | 控制类 **A** | Material: 自绘
> 源码：`lib/src/components/notice-bar` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | 自绘 |
| Theme | `TNoticeBarThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | `variant` → **`TNoticeBarThemeData`** |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| maxLines | 文本行数（仅静态有效） |
| direction | KEEP：L1–L3 高频 / Material 同名 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| style | TNoticeBarThemeData | L4 → Theme |
| onTap | onPressed | 命名对齐 v1.0 |
| context | context | 删除 — 0.2.x 已 `@deprecated`，与 `content` 重复；统一用 `content` |
| marquee | TNoticeBarThemeData | L4 → Theme |
| speed | TNoticeBarThemeData | L4 → Theme |
| interval | TNoticeBarThemeData | L4 → Theme |
| theme | TNoticeBarThemeData | L4 → Theme |
| prefixIcon | TNoticeBarThemeData | L4 → Theme |
| suffixIcon | TNoticeBarThemeData | L4 → Theme |
| height | TNoticeBarThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TNoticeBar`、`TNoticeBarThemeData`
- **移出**：`TNoticeBarStyle`、`t_notice_bar_style.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TNoticeBarThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `content` | TDesign 实例 | 通告文案；语义近横向 **`Banner`** |
| `direction` / `maxLines` | 实例 KEEP | 布局与行数 |
| `onPressed` | 实例 KEEP | 整条点击 |
| `marquee` / `speed` / `interval` | TDesign **`TNoticeBarThemeData`** | 滚动行为默认 |
| `prefixIcon` / `suffixIcon` / `height` / `style` | TDesign **`TNoticeBarThemeData`** | L4 |
| `variant`（原 `theme` enum） | TDesign 扩展 | 语义色；Material 无内置四态 |

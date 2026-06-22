# TBadge — v1.0 定稿

> Sprint **S2** | 控制类 **A** | Material: Badge M3
> 源码：`lib/src/components/badge` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | Badge M3 |
| Theme | `TBadgeThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → `TBadgeThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TBadgeSize | 尺寸/位置枚举保留 |
| count | 红点数量 |
| maxCount | 最大红点数量 |
| size | 红点尺寸 |
| TBadgeBorder | KEEP：设计稿语义枚举保留 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TBadgeType | variant | 对齐 Material |
| variant | variant | v1.0 语义形态 |
| border | TBadgeThemeData | L4 → Theme |
| color | TBadgeThemeData | L4 → Theme |
| textColor | TBadgeThemeData | L4 → Theme |
| message | TBadgeThemeData | L4 → Theme |
| widthLarge | TBadgeThemeData | L4 → Theme |
| widthSmall | TBadgeThemeData | L4 → Theme |
| padding | TBadgeThemeData | L4 → Theme |
| showZero | TBadgeThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TBadge`、`TBadgeSize`、`TBadgeBorder`、`TBadgeThemeData`
- **移出**：内部 `*Style`、绘制 helper（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TBadgeThemeData` · Material: **Badge M3** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `backgroundColor` / `textColor` / `padding` / `alignment` | Material **`BadgeTheme`**（或组件默认） | 徽标底色与文案 |
| `variant` | TDesign **`TBadgeThemeData`** | 原 `TBadgeType` / `type` |
| `border` / `widthLarge` / `widthSmall` / `showZero` / `message` | TDesign 扩展 | Material Badge 无独立 border/双宽度语义 |

# TTag — v1.0 定稿

> Sprint **S3** | 控制类 **A** | Material: Chip
> 源码：`lib/src/components/tag` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | Chip |
| Theme | `TTagThemeData` |
| 禁用 | `disable` 不是交互禁用 API，仅控制灰态样式。 |
| L4 | 构造器 L4 → `TTagThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| size | 标签大小 |
| text | KEEP：L1–L3 高频 / Material 同名 |
| icon | KEEP：L1–L3 高频 / Material 同名 |
| onCloseTap | 关闭回调（KEEP；`disable` 不挡此回调） |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| theme | colorScheme | 命名对齐 v1.0 |
| disable | TTagThemeData | L4 → Theme |
| style | TTagThemeData | L4 → Theme |
| iconWidget | TTagThemeData | L4 → Theme |
| textColor | TTagThemeData | L4 → Theme |
| backgroundColor | TTagThemeData | L4 → Theme |
| font | TTagThemeData | L4 → Theme |
| fontWeight | TTagThemeData | L4 → Theme |
| padding | TTagThemeData | L4 → Theme |
| forceVerticalCenter | TTagThemeData | L4 → Theme |
| isOutline | TTagThemeData | L4 → Theme |
| shape | TTagThemeData | L4 → Theme |
| isLight | TTagThemeData | L4 → Theme |
| needCloseIcon | TTagThemeData | L4 → Theme |
| overflow | TTagThemeData | L4 → Theme |
| fixedWidth | TTagThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TTag`、`TTagThemeData`
- **移出**：`TTagStyles`、`t_tag_styles.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TTagThemeData` · Material: **Chip** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `backgroundColor` / `labelStyle` / `side` / `padding` | Material **`ChipTheme`** | 标签/芯片 |
| `textColor` / `font` / `fixedWidth` / `style` | TDesign **`TTagThemeData`** | 0.2.x L4 默认 |

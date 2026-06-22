# TLink — v1.0 定稿

> Sprint **S2** | 控制类 **A** | Material: InkWell+Text
> 源码：`lib/src/components/link` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | InkWell+Text |
| Theme | `TLinkThemeData` |
| 禁用 | 废弃 `state: TLinkState.disabled`。 |
| L4 | 构造器 L4 → `TLinkThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TLinkType | 链接形态（basic / underline / icon） |
| TLinkSize | 尺寸 |
| uri | 跳转 URI |
| prefixIcon / suffixIcon | 链式图标 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TLinkStyle | TLinkColorScheme | 语义色；对齐 Button `colorScheme` |
| label | child | L2 内容 |
| linkClick | onPressed | A 类回调 |
| type | variant | 命名对齐 v1.0 |
| style | colorScheme | 原 `TLinkStyle` 枚举 |
| state | onPressed: null | 废弃 `TLinkState.disabled` |
| color / iconSize / fontSize | TLinkThemeData | L4 → Theme |
| leftGapWithIcon / rightGapWithIcon | TLinkThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| TLinkState | 禁用改用 `onPressed: null` |
| LinkClick | → `VoidCallback?` / `ValueChanged<Uri?>? onPressed` |

### 新增

| 符号 | 说明 |
| --- | --- |
| TLinkThemeData | L4 默认样式 |
| TLinkConfiguration | T2 组合配置（保留） |

### export

- **保留**：`TLink`、`TLinkType`、`TLinkSize`、`TLinkColorScheme`、`TLinkThemeData`、`TLinkConfiguration`
- **移出**：`TLinkStyle`、`TLinkState`、`LinkClick`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TLinkThemeData` · Material: **InkWell+Text** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `foregroundColor` / `overlayColor` | Material **`TextButtonTheme`** / InkWell | 链接色与水波纹 |
| `variant` | TDesign **`TLinkThemeData`** | 原 `TLinkType` / `type` |
| `fontSize` / `iconSize` / `prefixIcon` / `suffixIcon` / 间距 | TDesign 扩展 | 链式图标布局 |
| `uri` | TDesign 扩展（可选） | 默认链接色/下划线策略 |

# TLink — v1.0 定稿

> Sprint **S2** | 控制类 **A** | Material: InkWell+Text
> 源码：`lib/src/components/link` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（内部按 `uri` 与回调选择触发路径） |
| Material | InkWell+Text |
| Theme | `TLinkThemeData` |
| 禁用 | 回调为 `null` 时禁用 |
| L4 | 构造器 L4 → `TLinkThemeData` |

## 控制方案

`onPressed` / `onTap`；**不提供** `value`。禁用：回调 `null`。


---

## 1. API

### 构造器与类型

| 符号 | 说明 |
| --- | --- |
| `TLink` | 链接 Widget |
| `TLinkVariant` | 链接形态（basic / underline / icon） |
| `TLinkSize` | 尺寸 |
| `TLinkColorScheme` | 语义色 |
| `uri` | 跳转 URI |
| `prefixIcon` / `suffixIcon` | 链式图标 |
| `TLinkThemeData` | L4 默认样式 |

### export

- `TLink`
- `TLinkVariant`
- `TLinkSize`
- `TLinkColorScheme`
- `TLinkThemeData`


---

## 2. Theme

`TLinkThemeData` · Material: **InkWell+Text** · [theme.md](../foundation/theme.md)

### TLinkThemeData 字段

| 字段 | 类型 | 管什么 | 默认 |
| --- | --- | --- | --- |
| `defaultVariant` | `TLinkVariant` | 未传构造器 `variant` 时的默认形态 | `basic` |
| `defaultSize` | `TLinkSize` | 未传构造器 `size` 时的默认尺寸 | `medium` |

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `foregroundColor` / `overlayColor` | Material **`TextButtonTheme`** / InkWell | 链接色与水波纹 |
| `variant` | TDesign 构造器 L1（非 Material） | `TLinkVariant`；默认由 `TLinkThemeData.defaultVariant` 提供 |
| `size` | TDesign 构造器 L1（非 Material） | `TLinkSize`；默认由 `TLinkThemeData.defaultSize` 提供 |
| `fontSize` / `iconSize` / `prefixIcon` / `suffixIcon` / 间距 | TDesign 扩展 | 链式图标布局 |
| `uri` | TDesign 扩展（可选） | 默认链接色/下划线策略 |

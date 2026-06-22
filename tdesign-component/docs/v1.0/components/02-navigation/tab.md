# TTab — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: Tab
> 源码：`lib/src/components/tabs` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | Tab |
| Theme | `TTabBarThemeData` |
| 禁用 | `enabled: false`（Tab 无 `onChanged`，不适用 `onChanged: null`）。 |
| L4 | 构造器 L4 → `TTabBarThemeData` |

## 受控

无受控 value；按子交互控件控制类处理。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TTabSize | 尺寸/位置枚举保留 |
| size | 选项卡尺寸 |
| text | KEEP：L1–L3 高频 / Material 同名 |
| child | KEEP：L1–L3 高频 / Material 同名 |
| icon | KEEP：L1–L3 高频 / Material 同名 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TTabOutlineType | variant 枚举 | 对齐 Material |
| enable | enabled: false | Material 禁用 |
| badge | TTabBarThemeData | L4 → Theme |
| iconMargin | TTabBarThemeData | L4 → Theme |
| height | TTabBarThemeData | L4 → Theme |
| contentHeight | TTabBarThemeData | L4 → Theme |
| textMargin | TTabBarThemeData | L4 → Theme |
| outlineType | TTabBarThemeData | L4 → Theme |
| calculatedHeight | TTabBarThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TTab`、`TTabSize`、`TTabBarThemeData`
- **移出**：内部 `*Style`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TTabBarThemeData` · Material: **Tab** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `indicatorColor` / `labelStyle` / `dividerColor` | Material **`TabBarTheme`** | Tab 指示器与标签 |
| `conMarg` | TDesign **`TTabBarThemeData`** | 0.2.x L4 迁入（§1 迁移表） |

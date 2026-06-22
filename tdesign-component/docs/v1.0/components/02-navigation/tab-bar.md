# TTabBar — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: Material TabBar
> 源码：`lib/src/components/tabs` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | Material TabBar |
| Theme | `TTabBarThemeData` |
| 禁用 | 读子项 [TTab.enabled](./tab.md)。 |
| L4 | 构造器 L4 → `TTabBarThemeData` |

## 受控

无受控 value；按子交互控件控制类处理。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| width | tabBar宽度 |
| controller | KEEP：L1–L3 高频 / Material 同名 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TTabBarOutlineType | variant 枚举 | 对齐 Material |
| labelStyle | TTabBarThemeData | L4 → Theme |
| unselectedLabelStyle | TTabBarThemeData | L4 → Theme |
| decoration | TTabBarThemeData | L4 → Theme |
| backgroundColor | TTabBarThemeData | L4 → Theme |
| indicatorColor | TTabBarThemeData | L4 → Theme |
| indicatorHeight | TTabBarThemeData | L4 → Theme |
| indicatorWidth | TTabBarThemeData | L4 → Theme |
| labelColor | TTabBarThemeData | L4 → Theme |
| unselectedLabelColor | TTabBarThemeData | L4 → Theme |
| isScrollable | TTabBarThemeData | L4 → Theme |
| height | TTabBarThemeData | L4 → Theme |
| indicatorPadding | TTabBarThemeData | L4 → Theme |
| indicator | TTabBarThemeData | L4 → Theme |
| showIndicator | TTabBarThemeData | L4 → Theme |
| physics | TTabBarThemeData | L4 → Theme |
| labelPadding | TTabBarThemeData | L4 → Theme |
| outlineType | TTabBarThemeData | L4 → Theme |
| dividerColor | TTabBarThemeData | L4 → Theme |
| dividerHeight | TTabBarThemeData | L4 → Theme |
| selectedBgColor | TTabBarThemeData | L4 → Theme |
| unSelectedBgColor | TTabBarThemeData | L4 → Theme |
| tabAlignment | TTabBarThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TTabBar`、`TTabBarVariant`、`TTabBarThemeData`
- **移出**：`TTabBarOutlineType`（改名 `TTabBarVariant`）、`t_horizontal_tab_bar.dart` fork（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TTabBarThemeData` · Material: **Material TabBar** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `tabs` / `controller` | Material **`TabBar`** | **实例 KEEP**；与 Material 同级 |
| `onTap` | Material **`TabBar.onTap`** | **`ValueChanged<int>?`**；保留名（[api §3](../foundation/api.md#3-动作回调)） |
| `isScrollable` / `tabAlignment` | Material **`TabBar`** | 可滚动与对齐 |
| `indicatorColor` / `indicatorWeight` / `indicatorPadding` / `indicator` | Material **`TabBarTheme`** | 指示器 |
| `labelColor` / `unselectedLabelColor` / `labelStyle` / `unselectedLabelStyle` | Material **`TabBarTheme`** | 标签样式 |
| `dividerColor` / `dividerHeight` | Material **`TabBarTheme`** | 底部分割线 |
| `overlayColor` / `splashFactory` | Material **`TabBarTheme`** | 水波纹 |
| `enableFeedback` | Material **`TabBar`** | 触觉；≠ 禁用 |
| `variant`（outlineType）/ `selectedBgColor` / `unSelectedBgColor` / `decoration` | TDesign **`TTabBarThemeData`** | TDesign 胶囊/卡片形态与块背景 |

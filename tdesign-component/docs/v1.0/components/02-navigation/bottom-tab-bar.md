# TBottomTabBar — v1.0 定稿

> Sprint **S3** | 控制类 **B** | Material: NavigationBar
> 源码：`lib/src/components/tabbar` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 选择控件薄包装 |
| Material | NavigationBar |
| Theme | `TBottomNavThemeData` |
| 禁用 | `onChanged: null`。 |
| L4 | 构造器 L4 → `TBottomNavThemeData` |

## 受控

`value` + `onChanged`；无 `defaultValue`。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TBottomTabBarIndicatorAnimation | KEEP：设计稿语义枚举保留 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TBottomTabBarBasicType | variant 枚举 | 对齐 Material |
| TBottomTabBarComponentType | variant 枚举 | 对齐 Material |
| TBottomTabBarOutlineType | variant 枚举 | 对齐 Material |
| currentIndex | value | 命名对齐 v1.0 |
| basicType | TBottomNavThemeData | L4 → Theme |
| componentType | TBottomNavThemeData | L4 → Theme |
| outlineType | TBottomNavThemeData | L4 → Theme |
| barHeight | TBottomNavThemeData | L4 → Theme |
| useVerticalDivider | TBottomNavThemeData | L4 → Theme |
| dividerHeight | TBottomNavThemeData | L4 → Theme |
| dividerThickness | TBottomNavThemeData | L4 → Theme |
| dividerColor | TBottomNavThemeData | L4 → Theme |
| showTopBorder | TBottomNavThemeData | L4 → Theme |
| topBorder | TBottomNavThemeData | L4 → Theme |
| useSafeArea | TBottomNavThemeData | L4 → Theme |
| placeholder | TBottomNavThemeData | L4 → Theme |
| selectedBgColor | TBottomNavThemeData | L4 → Theme |
| unselectedBgColor | TBottomNavThemeData | L4 → Theme |
| backgroundColor | TBottomNavThemeData | L4 → Theme |
| centerDistance | TBottomNavThemeData | L4 → Theme |
| needInkWell | TBottomNavThemeData | L4 → Theme |
| indicatorAnimation | TBottomNavThemeData | L4 → Theme |
| animationDuration | TBottomNavThemeData | L4 → Theme |
| animationCurve | TBottomNavThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TBottomTabBar`、`TBottomNavThemeData`、`TBottomTabBarIndicatorAnimation`
- **移出**：内部 fork 文件 `t_horizontal_tab_bar.dart`（实现阶段删除）（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TBottomNavThemeData` · Material: **NavigationBar** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` / `onChanged` | Material **`NavigationBar`** | B 类受控；`onChanged: null` 禁用 |
| `navigationTabs` | **实例 KEEP** | 底栏项配置（图标/文案/角标等） |
| `backgroundColor` / `elevation` / `indicatorColor` | Material **`NavigationBarTheme`** | 容器与选中指示 |
| `labelBehavior` / `height` | Material **`NavigationBar`** | 标签显示策略与高度 |
| `animationDuration` / `animationCurve` | Material 动画 | 切换动效默认 |
| `basicType` / `componentType` / `outlineType` → **`variant`** | TDesign **`TBottomNavThemeData`** | TDesign 底栏形态（图标/文字组合等） |
| `barHeight` / 分割线 / `useSafeArea` / `needInkWell` / 弹出菜单尺寸 | TDesign **`TBottomNavThemeData`** | 0.2.x L4 默认 |

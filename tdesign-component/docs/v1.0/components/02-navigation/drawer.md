# TDrawer — v1.0 定稿

> Sprint **S4** | 控制类 **E** | Material: Drawer
> 源码：`lib/src/components/drawer` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Overlay / Route；命令式 `show` 为主 |
| Material | Drawer + `TPopup` 壳 |
| Theme | `TDrawerThemeData` |
| 禁用 | 浮层无 Widget 级禁用 |
| L4 | show 样式 → **`TDrawerThemeData`** |

## 受控

命令式 `TDrawer(...).show(context)` 或 `visible` + `onVisibleChange`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TDrawer.show | 打开抽屉（E 类） |
| TDrawerPlacement | left / right |
| child | 抽屉内容（合并 `contentWidget`） |
| items / TDrawerItem | 菜单项列表 |
| titleWidget / footer | 布局槽 |
| onClose / onItemClick | 关闭与项点击 |
| closeOnOverlayClick / showOverlay | Route 行为 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| items（内容） | child | 命名对齐 v1.0 |
| style | TDrawerThemeData | L4 → Theme |
| drawerTop / hover / backgroundColor | TDrawerThemeData | L4 → Theme |
| isShowLastBordered | TDrawerThemeData | L4 → Theme |
| width | 实例 KEEP | Material `Drawer.width` |

### 废弃

| 符号 | 原因 |
| --- | --- |
| contentWidget | 并入 `child` |

### 新增

_无_

### show API（`TDrawer.show`）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `context` | E 首参 | **保留** | `BuildContext` |
| `child` | L2 | **保留** | 抽屉主体 |
| `items` | L2 | **保留** | 菜单项模式 |
| `placement` | L1 | **保留** | `TDrawerPlacement` |
| `titleWidget` / `footer` | L2 | **保留** | 头尾槽 |
| `onClose` / `onItemClick` | L3 | **保留** | 回调 |
| `closeOnOverlayClick` / `showOverlay` | L3 | **保留** | 蒙层行为 |
| `width` | L1 | **保留实例** | 抽屉宽度 |
| `backgroundColor` / `hover` / `drawerTop` | L4 | → Theme | 默认样式 |

### L4 迁入 `TDrawerThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `backgroundColor` / `elevation` | `backgroundColor` / `elevation` | `DrawerTheme` |
| `barrierColor` | `barrierColor` | `ModalRoute` |
| `hover` / 项分隔线 | `itemHoverColor` / `dividerColor` | TDesign 扩展 |
| `drawerTop` / `isShowLastBordered` | `headerSpacing` / `showLastDivider` | TDesign 扩展 |

### export

- **保留**：`TDrawer`、`TDrawerItem`、`TDrawerPlacement`、`TDrawerThemeData`
- **移出**：`TDrawerWidget`、`t_drawer_widget.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TDrawerThemeData` · Material: **Drawer** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `child` / `items` | **单次 show L2** | 内容或菜单项 |
| `onClose` / `onItemClick` | **单次 show L3** | 用户回调 |
| `show` | **E 类** | 经 `TPopup` / Route 打开 |
| `width` / `elevation` / `backgroundColor` | Material **`Drawer`** + Theme | 宽度可实例覆盖 |
| `barrierColor` | Material **`ModalRoute`** | 蒙层默认 Theme |

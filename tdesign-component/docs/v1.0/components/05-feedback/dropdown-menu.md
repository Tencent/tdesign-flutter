# TDropdownMenu — v1.0 定稿

> Sprint **S4** | 控制类 **F** | Material: Overlay
> 源码：`lib/src/components/dropdown-menu` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘 + Material 底座（滚轮/日历等） |
| Material | Overlay |
| Theme | `TDropdownThemeData` |
| 禁用 | Widget 级 `onChanged: null`。 |
| L4 | `child` → **`TDropdownThemeData`** |

## 受控

`value` + `onChanged`；项级 `*.disabled` KEEP。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TDropdownMenu | 下拉菜单容器 |
| items / builder | 菜单项列表 |
| TDropdownItem / TDropdownItemOption | 下拉项与选项 |
| TDropdownItem.disabled | 项级禁用（数据） |
| TDropdownItemController | 命令式重置/更新选项 |
| closeOnClickOverlay / direction / showOverlay | 浮层行为 |
| onMenuOpened / onMenuClosed | 开闭回调 |
| multiple / onConfirm / onReset | 多选确认流 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| onChange | onChanged | F 类（`TDropdownItem`） |
| width / height / decoration | TDropdownThemeData | L4 → Theme |
| arrowIcon / arrowColor / tabBarAlign | TDropdownThemeData | L4 → Theme |
| duration / isScrollable | TDropdownThemeData | L4 → Theme |
| labelBuilder | 保留实例 | 自定义标签槽位 |

### 废弃

_无_

### 新增

| 符号 | 说明 |
| --- | --- |
| TDropdownThemeData | L4 菜单栏与浮层默认 |

### show API（Overlay 组合）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `items` / `builder` | L2 | **保留** | 菜单项与自定义栏 |
| `value` / `onChanged` | L1/L3 | **保留** | 各 `TDropdownItem` 受控 |
| `closeOnClickOverlay` / `showOverlay` | L3 | **保留** | 浮层行为 |
| `onMenuOpened` / `onMenuClosed` | L3 | **保留** | 开闭通知 |
| `multiple` / `onConfirm` / `onReset` | L2 | **保留** | 多选确认流 |
| `width` / `height` / `decoration` | L4 | → Theme | 菜单栏默认样式 |

### L4 迁入 `TDropdownThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `width` / `height` / `decoration` | 菜单栏容器 | Overlay 面板 |
| `arrowIcon` / `arrowColor` / `tabBarAlign` | 指示器与对齐 | TDesign 扩展 |
| `duration` / `isScrollable` | 动画/滚动 | TDesign 扩展 |

### export

- **保留**：`TDropdownMenu`、`TDropdownItem`、`TDropdownItemOption`、`TDropdownItemController`、`TDropdownThemeData`
- **移出**：内部 Overlay 路由实现类（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TDropdownThemeData` · Material: **Overlay** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `arrowColor` / `width` / `height` / `decoration` | TDesign **`TDropdownThemeData`** | 0.2.x L4 默认 |
| `child` / `onMenuOpened` / `onMenuClosed` | **实例 KEEP** | F 类组合与回调 |

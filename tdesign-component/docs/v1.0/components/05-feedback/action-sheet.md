# TActionSheet — v1.0 定稿

> Sprint **S4** | 控制类 **E** | Material: TPopup 组合
> 源码：`lib/src/components/action-sheet` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Overlay / Route；命令式 `show` 为主 |
| Material | `TPopup.show` + BottomSheet 视觉 |
| Theme | `TActionSheetThemeData` |
| 禁用 | 浮层无 Widget 级禁用；项级 `TActionSheetItem.disabled` KEEP |
| L4 | show 布局/蒙层参数 → **`TActionSheetThemeData`** |

## 受控

命令式 `showList/Grid/GroupActionSheet` 为主；声明式 `visible` 为辅（少用）。无 Widget 级 `disabled`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| showListActionSheet | 列表型命令式 show |
| showGridActionSheet | 宫格型命令式 show |
| showGroupActionSheet | 分组型命令式 show |
| TActionSheetItem | 选项数据（`label` / `icon` / `badge` / `group`） |
| TActionSheetItem.disabled | 项级禁用（数据字段） |
| TActionSheetAlign | center / left / right |
| onCancel / onClose | 取消与关闭回调 |
| visible | 声明式构造时立即 show（辅路径） |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TActionSheetTheme | variant | list / grid / group；三族 show 固定 variant |
| items | child | 命名对齐 v1.0（show 参数仍传 `List<TActionSheetItem>`） |
| description | subtitle | 列表/宫格副标题 |
| onSelected | onChanged | E 类选中回调 |
| TActionSheetItemCallback | TActionSheetOnChanged | 类型改名 |
| align / cancelText / count / rows | TActionSheetThemeData | L4 → Theme |
| itemHeight / itemMinWidth / showCancel | TActionSheetThemeData | L4 → Theme |
| showOverlay / closeOnOverlayClick | TActionSheetThemeData | L4 → Theme |
| showPagination / scrollable / useSafeArea | TActionSheetThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| TActionSheetItemCallback | → `TActionSheetOnChanged` |
| `TActionSheet(context, …)` 构造器主路径 | 改用三族 static show |

### 新增

| 符号 | 说明 |
| --- | --- |
| TActionSheetThemeData | L4 列表/宫格/分组默认布局 |
| TActionSheetOnChanged | `void Function(TActionSheetItem item, int index)?` |

### show API（三族 static）

**公共参数**（list / grid / group 均适用）：

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `context` | E 首参 | **保留** | `BuildContext` |
| `items`（→ `child`） | L2 | **保留** | `List<TActionSheetItem>` |
| `onChanged` | L3 | **改名** | 原 `onSelected` |
| `onCancel` / `onClose` | L3 | **保留** | 取消/关闭 |
| `align` | L1 | **保留** | `TActionSheetAlign` |
| `showCancel` / `cancelText` | L1/L4 | **保留** / → Theme | 取消按钮 |
| `showOverlay` / `closeOnOverlayClick` | L3/L4 | **保留** / → Theme | 蒙层行为 |
| `useSafeArea` | L4 | → Theme | 安全区 |

**`showListActionSheet` 专有**：

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `subtitle` | L2 | **改名** | 原 `description` |

**`showGridActionSheet` 专有**：

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `subtitle` | L2 | **改名** | 原 `description` |
| `count` / `rows` | L4 | → Theme | 分页宫格 |
| `itemHeight` / `itemMinWidth` | L4 | → Theme | 宫格单元尺寸 |
| `scrollable` / `showPagination` | L4 | → Theme | 滚动与分页 |

**`showGroupActionSheet` 专有**：

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `itemHeight` / `itemMinWidth` | L4 | → Theme | 分组行高/最小宽 |
| `TActionSheetItem.group` | L2 数据 | **保留** | 分组 key；缺省则项不展示 |

实现壳：`TPopup.show` + `TPopupOptions.bottom`（见 [popup.md](./popup.md)）。

### L4 迁入 `TActionSheetThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `cancelText` / `showCancel` | `cancelText` / `showCancelButton` | BottomSheet 取消区 |
| `align` 默认 | `defaultAlign` | TDesign 扩展 |
| `itemHeight` / `itemMinWidth` | `itemHeight` / `itemMinWidth` | 宫格/分组布局 |
| `count` / `rows` / `showPagination` / `scrollable` | 宫格分页默认 | TDesign 扩展 |
| `showOverlay` / `closeOnOverlayClick` | `barrierDismissible` 默认 | `ModalRoute` |
| `useSafeArea` | `useSafeArea` | 安全区 |
| 容器圆角 / 蒙层色 | `panelRadius` / `barrierColor` | `BottomSheetTheme` + `TPopup` |

### export

- **保留**：`showListActionSheet`、`showGridActionSheet`、`showGroupActionSheet`、`TActionSheetItem`、`TActionSheetAlign`、`TActionSheetOnChanged`、`TActionSheetThemeData`
- **移出**：`TActionSheetTheme`（enum 改名 `variant` 或内聚 Theme）、`TActionSheetItemCallback`、`TActionSheetList/Grid/Group` 内部 Widget（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TActionSheetThemeData` · Material: **TPopup + BottomSheet** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `child`（items）/ `subtitle` | **单次 show L2** | 选项与副标题 |
| `onChanged` / `onCancel` / `onClose` | **单次 show L3** | 选中与关闭 |
| 三族 `show*` | **E 类首参** | 内部 `TPopup.show(context, …)` |
| `TActionSheetItem.disabled` | **数据项** | 灰显且不触发 `onChanged` |
| 宫格 count/rows/分页/滚动 | **`TActionSheetThemeData`** | grid 专属 L4 |
| 蒙层 / 圆角 / 安全区 / 取消文案 | **`TActionSheetThemeData`** + **`TPopupThemeData`** | 默认可子树 merge |

# TPopup — v1.0 定稿

> Sprint **S4** | 控制类 **E** | Material: `PopupRoute` + Navigator
> 源码：`lib/src/components/popup` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Overlay / Route；命令式 `show` 为主 |
| Material | `PopupRoute` + Navigator |
| Theme | `TPopupThemeData` |
| 禁用 | 浮层 无 Widget 级 disabled / enable |
| L4 | 构造器 L4 → `TPopupThemeData` |

## 受控

命令式 `show()` 或 `visible` + `onVisibleChange`。无 Widget 级 `disabled`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TPopup | E 类 show 入口 |
| TPopup.show | 打开浮层 |
| TPopupOptions | 单次参数见组件 |
| TPopupHandle | 生命周期句柄 |
| TPopupPlacement | 五向 + center |
| TPopupTrigger | 关闭来源 |
| TPopupBottomInset 等 | 方向 inset |
| TPopupThemeData | L4 默认 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| 零散构造器 L4 | TPopupThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| `defaultVisible` 等 Widget 初值 | 废弃 → 不调 `show` 或 `TPopupHandle.close()` |
| Widget 级 `disabled` | E 类无容器禁用 |
| 错误文档项 `context`→Theme | `BuildContext` 为 `show` 首参，不进 Theme |

### 新增

_无_

### show API（`TPopup.show`）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `context` | E 首参 | **保留** | `BuildContext` |
| `options` | L2–L3 | **保留** | `TPopupOptions` 命名工厂 bottom/center/… |
| `child` | L2 | **保留** | 浮层内容 |
| `placement` | L1 | **保留** | `TPopupPlacement` |
| `onVisibleChange` / `onClose` | L3 | **保留** | 显隐与关闭 |
| `closeOnOverlayClick` | L3 | **保留** | 对齐 `barrierDismissible` |
| `height` / `width` / `inset` | L1/L4 | **保留实例** | 方向相关尺寸 |
| `overlayColor` / `animationDuration` | L4 | → Theme | 蒙层与动画 |
| header/cancel/confirm builder | L2 | **保留** | bottom/center 操作区 |

### L4 迁入 `TPopupThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `overlayColor` | `barrierColor` | `ModalRoute` |
| `animationDuration` | `transitionDuration` | Route |
| 默认 header 文案/样式 | `headerStyle` / `cancelText` / `confirmText` | TDesign 扩展 |
| 圆角 / 安全区 | `panelRadius` / `useSafeArea` | BottomSheet 近似 |

### export

- **保留**：`TPopup`、`TPopup.show`、`TPopupOptions`、`TPopupHandle`、`TPopupPlacement`、`TPopupTrigger`、inset 类型、`TPopupThemeData`、builder typedef
- **移出**：`_PopupNavigatorRoute` 等 `_*` 内部实现（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TPopupThemeData` · Material: **`PopupRoute` + Navigator** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `Navigator.push` / `PopupRoute` | Material **Route** | `TPopup.show` 实现基础 |
| `barrierColor` / `transitionDuration` | Material **`ModalRoute`** | → `overlayColor` / `animationDuration` |
| `useRootNavigator` | Material **`showDialog`** 等同名参数 | `show` 可选参数 |
| `child` | Material **Route 内容** | 实例 KEEP |
| `placement`（五向 + center） | **TDesign 扩展** | Material 仅 bottom/center 有标准 API |
| `headerBuilder` / cancel / confirm / close 槽位 | **TDesign 扩展** | bottom/center 操作区 |
| `TPopupThemeData` 默认 L4 | TDesign 扩展 | 子树 mergeExtension |

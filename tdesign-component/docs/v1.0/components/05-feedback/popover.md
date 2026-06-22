# TPopover — v1.0 定稿

> Sprint **S4** | 控制类 **E** | Material: Overlay
> 源码：`lib/src/components/popover` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Overlay / Route；命令式 `show` 为主 |
| Material | `showDialog` + 锚点定位 Overlay |
| Theme | `TPopoverThemeData` |
| 禁用 | 浮层无 Widget 级禁用 |
| L4 | show 色/尺寸/内边距 → **`TPopoverThemeData`** |

## 受控

命令式 `show()` 为主。无 Widget 级 `disabled`；可选后续声明式 `visible` + `onVisibleChange`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| showPopover | 命令式 show API（E 类） |
| TPopoverPlacement | 12 向定位枚举 |
| content / contentWidget | 气泡文案或自定义内容 |
| placement / showArrow / offset | 相对锚点定位 |
| closeOnClickOutside | 对齐 `barrierDismissible` |
| onTap / onLongTap | 内容区点击/长按 |
| arrowSize | 箭头尺寸（高频可保留实例） |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TPopoverTheme | TPopoverColorScheme | 语义色 enum；避免与 ThemeExtension 混淆 |
| theme | colorScheme | 原 `TPopoverTheme`（dark/light/info/…） |
| padding / width / height / radius | TPopoverThemeData | L4 → Theme |
| overlayColor | barrierColor | Material 命名 |

### 废弃

| 符号 | 原因 |
| --- | --- |
| `TPopoverTheme` 作 Theme 名 | 改名为 `TPopoverColorScheme` + `TPopoverThemeData` |

### 新增

| 符号 | 说明 |
| --- | --- |
| TPopoverThemeData | L4 气泡背景、边框、阴影、内边距默认 |
| TPopoverColorScheme | 原 `TPopoverTheme` 语义色 |

### show API（`showPopover`）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `context` | E 首参 | **保留** | 锚点与 Overlay 上下文 |
| `content` / `contentWidget` | L2 | **保留** | 二选一；自定义优先 |
| `placement` | L1 | **保留** | `TPopoverPlacement` |
| `showArrow` / `offset` | L1 | **保留** | 箭头与锚点偏移 |
| `closeOnClickOutside` | L3 | **保留** | 点击蒙层关闭 |
| `onTap` / `onLongTap` | L3 | **保留** | 内容区手势 |
| `arrowSize` | L1/L4 | **保留实例** | 默认取自 Theme |
| `theme` | L4 | → `colorScheme` | 原 enum 语义色 |
| `padding` / `width` / `height` / `radius` | L4 | → Theme | 气泡盒模型 |
| `overlayColor` | L4 | → `barrierColor` | 蒙层色默认 Theme |

### L4 迁入 `TPopoverThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `theme` dark/light/info/… | `colorScheme` + `backgroundColor` | 无内置 Popover；走 Extension |
| `padding` | `padding` | 近似 `Material` 内边距 |
| `width` / `height` | `minWidth` / `maxHeight` | 气泡约束 |
| `radius` | `borderRadius` | `ShapeBorder` |
| `overlayColor` | `barrierColor` | `Dialog.barrierColor` |
| `arrowSize` | `arrowSize` | TDesign 扩展 |

### export

- **保留**：`TPopover`、`showPopover`、`TPopoverPlacement`、`TPopoverColorScheme`、`TPopoverThemeData`
- **移出**：`TPopoverWidget`、`t_popover_widget.dart`、旧名 `TPopoverTheme` enum（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TPopoverThemeData` · Material: **Overlay / Dialog 蒙层** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `content` / `contentWidget` | **单次 show L2** | 当次气泡内容 |
| `placement` / `showArrow` / `offset` | **单次 show L1** | 锚点定位 KEEP |
| `closeOnClickOutside` | Material **`barrierDismissible`** | show 参数 KEEP |
| `onTap` / `onLongTap` | **单次 show L3** | 内容回调 |
| `showPopover` | **E 类首参** | `showDialog(context, …)` + Overlay |
| `colorScheme` | **`TPopoverColorScheme`** | dark/light/info/success/warning/error |
| 内边距 / 圆角 / 尺寸 / 箭头 / 蒙层色 | **`TPopoverThemeData`** | L4 默认；实例可破例 |

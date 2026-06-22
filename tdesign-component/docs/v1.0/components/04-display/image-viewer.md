# TImageViewer — v1.0 定稿

> Sprint **S4** | 控制类 **E** | Material: 命令式预览
> 源码：`lib/src/components/image-viewer` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Overlay / Route；命令式 `show` 为主 |
| Material | `showDialog` + 全屏 PageView |
| Theme | `TImageViewerThemeData` |
| 禁用 | 浮层无 Widget 级禁用 |
| L4 | show 色/字号/尺寸 → **`TImageViewerThemeData`** |

## 受控

命令式 `show()` 为主；当前页由 `defaultIndex` + `onIndexChange` 通知。无 Widget 级 `disabled`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| showImageViewer | 命令式 show API（E 类） |
| images / labels | 预览资源 URL/asset 与标签 |
| defaultIndex | 打开时初始页 |
| closeBtn / deleteBtn / showIndex | 工具栏按钮显隐 |
| loop / autoplay / duration | 轮播行为 |
| onClose / onDelete / onIndexChange | 关闭、删除、翻页回调 |
| onTap / onLongPress | 图片手势 |
| leftItemBuilder / rightItemBuilder | 导航栏左右槽位 |
| barrierDismissible / modalBarrierColor | Material Dialog 遮罩 |
| ignoreDeleteError | 删除失败是否吞异常 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| bgColor / navBarBgColor / iconColor | TImageViewerThemeData | L4 → Theme |
| labelStyle / indexStyle | TImageViewerThemeData | L4 → Theme |
| width / height | TImageViewerThemeData | L4 预览区默认尺寸 |
| `TTheme.of` 取蒙层色 | Theme + `TImageViewerThemeData` | 移除 `TTheme` 单例 |

### 废弃

_无_

### 新增

| 符号 | 说明 |
| --- | --- |
| TImageViewerThemeData | L4 预览页背景、导航栏、图标与文案样式 |

### show API（`showImageViewer`）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `context` | E 首参 | **保留** | `BuildContext` |
| `images` | L2 | **保留** | 图片列表（URL / asset / File） |
| `labels` | L2 | **保留** | 与 images 对齐的标签 |
| `defaultIndex` | L1 | **保留** | 初始页索引 |
| `closeBtn` / `deleteBtn` / `showIndex` | L1 | **保留** | 工具栏显隐 |
| `loop` / `autoplay` / `duration` | L3 | **保留** | 轮播；`duration` 毫秒 |
| `onClose` / `onDelete` / `onIndexChange` | L3 | **保留** | 用户回调 |
| `onTap` / `onLongPress` | L3 | **保留** | 图片手势 |
| `leftItemBuilder` / `rightItemBuilder` | L2 | **保留** | 导航栏定制 |
| `barrierDismissible` | L3 | **保留** | 对齐 Material |
| `modalBarrierColor` | L4 | → Theme | 默认 `TImageViewerThemeData.barrierColor` |
| `bgColor` / `navBarBgColor` / `iconColor` | L4 | → Theme | 预览页配色 |
| `labelStyle` / `indexStyle` | L4 | → Theme | 标签与页码样式 |
| `width` / `height` | L4 | → Theme | 预览区默认尺寸 |

### L4 迁入 `TImageViewerThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `bgColor` | `backgroundColor` | 全屏 Scaffold 背景 |
| `navBarBgColor` | `appBarBackgroundColor` | 近似 `AppBarTheme` |
| `iconColor` | `iconColor` | `IconTheme` |
| `labelStyle` / `indexStyle` | `labelStyle` / `indexStyle` | `TextTheme` |
| `modalBarrierColor` | `barrierColor` | `DialogTheme.barrierColor` |
| `width` / `height` | `viewerWidth` / `viewerHeight` | 无；TDesign 预览框 |

### export

- **保留**：`TImageViewer`、`showImageViewer`、`TImageViewerThemeData`、回调 typedef（`OnClose` / `OnDelete` / `OnIndexChange` 等）
- **移出**：`TImageViewerWidget`、`image_viewer_widget.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TImageViewerThemeData` · Material: **Dialog + 全屏预览** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `images` / `labels` / `defaultIndex` | **单次 show L2** | 业务内容与初始页 |
| 工具栏显隐 / 轮播 / 手势回调 | **单次 show L3** | 当次交互行为 |
| `showImageViewer` | **E 类首参** | `showDialog(context, …)` |
| `leftItemBuilder` / `rightItemBuilder` | **实例 Builder** | 导航栏槽位 KEEP |
| 背景 / 导航栏 / 图标 / 文案色 | **`TImageViewerThemeData`** | L4 默认 |
| `barrierColor` / `barrierDismissible` | Material **`DialogTheme`** + show 参数 | 蒙层可单次覆盖 |

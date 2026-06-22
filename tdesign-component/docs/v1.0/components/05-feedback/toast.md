# TToast — v1.0 定稿

> Sprint **S4** | 控制类 **E** | Material: Overlay
> 源码：`lib/src/components/toast` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Overlay 直插；命令式 static `show*` 为主 |
| Material | 对照 `SnackBar` / `ScaffoldMessenger`（实现可 Overlay） |
| Theme | `TToastThemeData` |
| 禁用 | 浮层无 Widget 级禁用；不 show 即可 |
| L4 | 色/字号/图标 → **`TToastThemeData`** |

## 受控

命令式 `show*` 返回 `toastId`；`dismissToast` / `dismissAll` / `dismissLoading` 关闭。无 `visible` 声明式主路径。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| showText | 纯文本 Toast |
| showIconText | 自定义图标 + 文本 |
| showSuccess / showWarning / showFail | 语义图标 + 文本 |
| showLoading / showLoadingWithoutText | 加载态（长 `duration`） |
| dismissToast / dismissAll / dismissLoading | 按 id / 全部 / 加载态关闭 |
| IconTextDirection | 图标与文本横/竖排列 |
| toastId | 可选；show 返回 id 供 dismiss |
| preventTap | 是否拦截点击穿透 |
| customWidget | 自定义 Toast 内容 |
| maxLines / constraints | 文本布局 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TToastConfig | TToastThemeData | L4 默认；单次 show 可破例 |
| backgroundColor / textStyle / iconSize / iconColor | TToastThemeData | L4 → Theme |
| duration（毫秒 int） | Duration | 对齐 Material |
| text 首参 | text | show 方法首参 KEEP |

### 废弃

| 符号 | 原因 |
| --- | --- |
| TToastConfig 公开类 | 迁入 `TToastThemeData`；不 export |

### 新增

| 符号 | 说明 |
| --- | --- |
| TToastThemeData | L4 背景、文案、图标默认 |

### show API（static 方法族）

**公共参数**（各 `show*` 均适用，除非注明）：

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `context` | E 首参 | **保留** | `BuildContext` |
| `text` | L2 | **保留** | 文案（loading 可选） |
| `duration` | L3 | **保留** | 默认 3s；loading 用超长 |
| `preventTap` | L3 | **保留** | 拦截点击 |
| `toastId` | L1 | **保留** | 传入则复用 id；否则自动生成 |
| `customWidget` | L2 | **保留** | 自定义内容（showText/showLoading） |
| `backgroundColor` / `textStyle` | L4 | → Theme | 单次可覆盖 Theme |
| 返回值 | — | **保留** | `String` toastId |

**`showIconText` / showSuccess / showWarning / showFail 增加**：

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `icon` | L2 | **保留** | showIconText 必填；语义 show 内置图标 |
| `direction` | L1 | **保留** | `IconTextDirection` horizontal/vertical |
| `iconSize` / `iconColor` | L4 | → Theme | 图标样式 |

**`showLoadingWithoutText` 减少**：

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `text` | — | **无** | 仅转圈 |
| `iconSize` / `iconColor` | L4 | → Theme | loading 指示器 |

**关闭 API（非 show，E 类配套）**：

| 方法 | 说明 |
| --- | --- |
| `dismissToast(toastId)` | 关闭指定实例 |
| `dismissAll()` | 关闭全部 |
| `dismissLoading()` | 关闭所有 loading 态 |

### L4 迁入 `TToastThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `backgroundColor` | `backgroundColor` | `SnackBarThemeData` |
| `textStyle` | `textStyle` | `SnackBarThemeData` |
| `iconSize` / `iconColor` | `iconSize` / `iconColor` | TDesign 扩展 |
| `preventTap` 默认 | `preventTap` | 点击穿透策略 |
| `duration` 默认 | `defaultDuration` | `SnackBar.duration` |
| 圆角 / 内边距 / 最大宽度 | `borderRadius` / `padding` / `maxWidth` | TDesign 轻提示盒模型 |

### export

- **保留**：`TToast`（全部 static show/dismiss）、`IconTextDirection`、`TToastThemeData`
- **移出**：`TToastConfig`、`_TTextToast` 等内部 Widget（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TToastThemeData` · Material: **Overlay / SnackBar 对照** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `text` / `customWidget` | **单次 show L2** | 当次内容 |
| `duration` / `preventTap` | **单次 show L3** | 展示时长与点击策略 |
| `showText` 等 static | **E 类** | Overlay 插入 |
| `toastId` 返回值 + dismiss | **实例管理** | 多 Toast 并存 |
| 背景 / 文案 / 图标色 / 圆角 | **`TToastThemeData`** | L4 默认 |
| success/warning/fail 内置图标 | TDesign 扩展 | Material SnackBar 无四态图标 |

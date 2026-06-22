# TMessage — v1.0 定稿

> Sprint **S4** | 控制类 **E** | Material: SnackBar / ScaffoldMessenger
> 源码：`lib/src/components/message` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Overlay / Route；命令式 `show` 为主 |
| Material | SnackBar / ScaffoldMessenger |
| Theme | `TMessageThemeData` |
| 禁用 | 浮层 无 Widget 级 disabled。不展示 → 不调 showMess |
| L4 | 构造器 L4 → `TMessageThemeData` |

## 受控

命令式 `show()` 或 `visible` + `onVisibleChange`。无 Widget 级 `disabled`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TMessage | 声明式（少用） |
| showMessage | 命令式入口 |
| TMessageOptions | content/duration/closeBtn 等见 |
| TMessageHandle | 关闭句柄 |
| TMessageVariant | 四态语义 |
| TMessageLink | 链接 |
| TMessageMarquee | 滚动 |
| TMessageThemeData | L4 默认 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| MessageTheme | TMessageVariant | 命名对齐 v1.0 |
| theme | variant | 命名对齐 v1.0 |
| MessageLink | TMessageLink | 命名对齐 v1.0 |
| MessageMarquee | TMessageMarquee | 命名对齐 v1.0 |
| duration（`int` 毫秒） | Duration | 对齐 Material |
| offset（`List<double>`） | Offset? | 命名对齐 v1.0 |
| 构造器 L4 色/圆角/阴影/宽高等 | TMessageThemeData | L4 → Theme |
| Overlay 直插 | Overlay 直插 | 实现可保留 Overlay 或对齐 `ScaffoldMessenger.showSnackBar`；API 不变 |

### 废弃

| 符号 | 原因 |
| --- | --- |
| MessageTheme | 由 `TMessageVariant` 替代 |
| Widget 级 `disabled` | E 类无容器禁用；不 show 即可 |

### 新增

| 符号 | 说明 |
| --- | --- |
| **TMessageOptions** | 单次 `showMessage` 参数打包（对标 `SnackBar` 构造字段） |
| **TMessageHandle** | 可选；`close()` 提前关闭当前消息 |
| **TMessageVariant** | 由 `MessageTheme` 迁移 |
| **TMessageLink** | 由 `MessageLink` 迁移 |
| **TMessageMarquee** | 由 `MessageMarquee` 迁移 |
| variant | 由 `theme` 迁移 |

### export

- **保留**：`TMessage`、`showMessage`、`TMessageOptions`、`TMessageHandle`、`TMessageThemeData`、`TMessageVariant`、`TMessageLink`、`TMessageMarquee`
- **移出**：`MessageTheme` 旧 enum 名（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

### show API（`showMessage`）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `context` | E 首参 | **保留** | `BuildContext` |
| `content` | L2 | **保留** | 通知文案 |
| `variant` | L1 | **改名** | 原 `theme` / `MessageTheme` |
| `duration` | L3 | **保留** | `Duration` |
| `icon` / `closeBtn` | L1 | **保留** | 图标与关闭按钮 |
| `link` / `marquee` | L2 | **保留** | 链接与跑马灯 |
| `offset` | L1 | **保留** | 顶栏偏移 |
| `onCloseBtnClick` / `onLinkClick` / `onDurationEnd` | L3 | **保留** | 回调 |
| 背景/圆角/阴影/宽度 | L4 | → Theme | `TMessageThemeData` |

### L4 迁入 `TMessageThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `theme` info/success/… | `colorScheme` + 背景色 | SnackBar 无四态 |
| `backgroundColor` / `shape` / `elevation` | `backgroundColor` / `shape` / `elevation` | `SnackBarThemeData` |
| `offset` 默认 | `defaultOffset` | TDesign 顶栏浮层 |
| `marquee` 默认 | `defaultMarquee` | TDesign 扩展 |

---

## 2. Theme

`TMessageThemeData` · Material: **SnackBar / ScaffoldMessenger** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `content` | Material **`SnackBar.content`** | 实例 KEEP；`String` 或 `Widget` |
| `duration` | Material **`SnackBar.duration`** | 实例 KEEP；`Duration` |
| `action` | Material **`SnackBarAction`** | 映射 **`link`** + **`onLinkClick`** |
| `showCloseIcon` / 关闭交互 | Material **`SnackBar`**（M3） | 映射 **`closeBtn`** + **`onCloseBtnClick`** |
| `behavior` / `margin` | Material **`SnackBar`** | TDesign 顶栏浮层 → **`offset`** + Overlay 实现 |
| `backgroundColor` / `shape` / `elevation` / `width` / `padding` | Material **`SnackBarThemeData`** | 默认 → **`TMessageThemeData`**；单次 show 可破例 |
| `variant`（info/success/…） | TDesign 扩展 | 语义色；Material SnackBar 无内置四态 |
| `marquee` | TDesign 扩展 | 文案滚动；Material 无 |
| `icon`（bool/Widget） | TDesign 扩展 | 左侧图标区 |
| 组件默认样式 | TDesign **`TMessageThemeData`** | 子树 `mergeExtension` |

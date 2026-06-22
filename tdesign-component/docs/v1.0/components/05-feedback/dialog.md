# TDialog — v1.0 定稿

> Sprint **S3** | 控制类 **E** | Material: AlertDialog
> 源码：`lib/src/components/dialog` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Overlay / Route；命令式 `show` 为主 |
| Material | AlertDialog |
| Theme | `TDialogThemeData` |
| 禁用 | 浮层无 Widget 级禁用；按钮 `onPressed: null` |
| L4 | show 样式参数 → **`TDialogThemeData`** |

## 受控

命令式 `show()` 为主。无 Widget 级 `disabled`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| showAlert | 命令式 alert（E 类） |
| showConfirm | 命令式 confirm |
| showInput | 命令式 input |
| TAlertDialog / TConfirmDialog / TInputDialog | 声明式 Widget（少用） |
| title / content / contentWidget | 文案与自定义内容 |
| leftBtn / rightBtn / buttons | 按钮区 |
| barrierDismissible | Material 同名 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| 零散 show 系列 | showAlert / showConfirm / showInput | 三族合并 |
| TDialogButtonOptions 内 L4 | TDialogThemeData | 色/字号/高度 → Theme |
| TDialogButtonOptions.action | onPressed | A 类 |
| backgroundColor / radius / titleColor / contentColor | TDialogThemeData | L4 → Theme |
| padding / buttonStyle | TDialogThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| 未合并的旧 show 入口 | 由三族之一替代 |
| TDialogButtonOptions 内 `style`/`type`/`theme` | 迁入 Theme + `onPressed` |

### 新增

| 符号 | 说明 |
| --- | --- |
| TDialogThemeData | L4 对话框与按钮区默认 |

### show API（三族）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `context` | E 首参 | **保留** | `BuildContext` |
| `title` / `content` / `contentWidget` | L2 | **保留** | 文案区 |
| `leftBtn` / `rightBtn` / `buttons` | L3 | **保留** | 按钮配置；内部 `onPressed` |
| `barrierDismissible` | L3 | **保留** | 点击蒙层关闭 |
| `onClose` | L3 | **保留** | 关闭回调 |
| `backgroundColor` / `radius` / `padding` | L4 | → Theme | 容器样式 |
| `titleColor` / `contentColor` / `titleAlignment` | L4 | → Theme | 文案样式 |

### L4 迁入 `TDialogThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `backgroundColor` / `radius` / `elevation` | `backgroundColor` / `shape` / `elevation` | `DialogThemeData` |
| `titleColor` / `contentColor` / `titleTextStyle` | `titleTextStyle` / `contentTextStyle` | `DialogTheme` |
| `barrierColor` | `barrierColor` | `showDialog` |
| `buttonStyle` / 按钮 L4 | `actionButtonStyle` | `TextButtonTheme` |
| `padding` / `contentMaxHeight` | `contentPadding` / `contentMaxHeight` | TDesign 扩展 |

### export

- **保留**：`showAlert`、`showConfirm`、`showInput`、`TAlertDialog`、`TConfirmDialog`、`TInputDialog`、`TDialogButtonOptions`、`TDialogButtonStyle`、`TDialogThemeData`
- **移出**：`TDialogScaffold`、`TDialogButton`、`t_dialog_widget.dart` 等内部 Widget（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TDialogThemeData` · Material: **AlertDialog** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `title` / `content` / `actions` | Material **`AlertDialog`** | 单次 show KEEP |
| `showAlert` / `showConfirm` / `showInput` | **E 类命令式** | `Future<T?>` 对齐 **`showDialog`** |
| `barrierDismissible` | Material **`showDialog`** | 单次 show KEEP |
| 内部确认/取消按钮 | Material **`TextButton`** 等 | A 类 **`onPressed`** |
| `backgroundColor` / `shape` / 文案样式 | Material **`DialogThemeData`** | 默认 → **`TDialogThemeData`** |

# TSkeleton — v1.0 定稿

> Sprint **S3** | 控制类 **A** | Material: 自绘
> 源码：`lib/src/components/skeleton` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | 自绘 |
| Theme | `TSkeletonThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → `TSkeletonThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TSkeletonAnimation | KEEP：设计稿语义枚举保留 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TSkeletonTheme | TSkeletonVariant | `TSkeletonVariant` 预设（`avatar` / `image` / `text` / `paragraph`） |
| animation | TSkeletonThemeData | L4 → Theme |
| delay | TSkeletonThemeData | L4 → Theme |
| theme | variant | 命名对齐 v1.0 |

### 废弃

| 符号 | 原因 |
| --- | --- |
| `TSkeletonTheme` | → `TSkeletonVariant` |

### 新增

| 符号 | 说明 |
| --- | --- |
| **TSkeletonVariant** | 预设形态 |
| **TSkeleton.fromRowCol** | 自定义 `rowCol` 布局 |
| variant | 由 `theme` 迁移 |

### export

- **保留**：`TSkeleton`、`TSkeletonVariant`、`TSkeletonAnimation`、`TSkeletonThemeData`
- **移出**：`TSkeletonTheme`（enum）、`t_skeleton_rowcol.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TSkeletonThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| 占位块布局 | **实例 KEEP** | `rowCol` / `TSkeletonVariant` 预设 |
| `animation` / `delay` | TDesign **`TSkeletonThemeData`** | 动画类型与延迟默认 |
| 块色 / 渐变 / 圆角 | TDesign **`TSkeletonThemeData`** | 自绘 L4 |

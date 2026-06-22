# TEmpty — v1.0 定稿

> Sprint **S3** | 控制类 **A** | Material: 自绘
> 源码：`lib/src/components/empty` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | 自绘 |
| Theme | `TEmptyThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → `TEmptyThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| icon | KEEP |
| image | KEEP — 自定义插图 Widget |
| emptyText | KEEP — 主文案 |
| operationText | KEEP — 操作按钮文案（`variant=operation` 时） |
| customOperationWidget | KEEP — 自定义操作区（替代默认按钮） |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TEmptyType | TEmptyVariant | 命名对齐 v1.0 |
| onTapEvent | onPressed | 命名对齐 v1.0 |
| type | variant | 命名对齐 v1.0 |
| emptyTextColor | TEmptyThemeData | L4 → Theme |
| emptyTextFont | TEmptyThemeData | L4 → Theme |
| operationTheme | TEmptyThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| TTapEvent | 废弃 → `VoidCallback? onPressed` |
| `TEmptyType` | → `TEmptyVariant` |
| `TTapEvent` | → `VoidCallback?` |

### 新增

| 符号 | 说明 |
| --- | --- |
| **TEmptyVariant** | `plain` / `operation` |
| variant | 由 `type` 迁移 |
| onPressed | 由 `onTapEvent` 迁移 |

### export

- **保留**：`TEmpty`、`TEmptyVariant`、`TEmptyThemeData`
- **移出**：`TEmptyType`（改名 `TEmptyVariant`）、`TTapEvent`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TEmptyThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| 文案 / 插图 / 操作区 | **实例 KEEP** | 业务空态内容 |
| `onPressed` | Material **Button** 惯例 | 内置操作按钮禁用 |
| 文案色/字号/默认按钮配色 | TDesign **`TEmptyThemeData`** | L4 默认 |

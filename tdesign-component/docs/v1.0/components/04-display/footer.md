# TFooter — v1.0 定稿

> Sprint **S3** | 控制类 **A** | Material: 自绘
> 源码：`lib/src/components/footer` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | 自绘 |
| Theme | `TFooterThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → `TFooterThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| width | 自定义图片宽 |
| type | KEEP：L1–L3 高频 / Material 同名 |
| text | KEEP：L1–L3 高频 / Material 同名 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TFooterType | TFooterVariant | 命名对齐 v1.0 |
| height | TFooterThemeData | L4 → Theme |
| type | variant | 命名对齐 v1.0 |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TFooter`、`TFooterThemeData`
- **移出**：内部 `*Style`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TFooterThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `text` / `logo` / `links` | **实例 KEEP** | 文案、品牌图、链接区（内嵌 `TLink`） |
| `variant` | **实例** | `text` / `link` / `brand` |
| `width` / 默认 `height` | 实例 + **`TFooterThemeData`** | 图片尺寸；高度默认 Theme |

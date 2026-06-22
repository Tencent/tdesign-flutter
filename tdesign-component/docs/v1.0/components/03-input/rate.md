# TRate — v1.0 定稿

> Sprint **S3** | 控制类 **C** | Material: 自绘
> 源码：`lib/src/components/rate` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 连续值控件薄包装 |
| Material | 自绘 |
| Theme | `TRateThemeData` |
| 禁用 | `onChanged: null`。 |
| L4 | 构造器 L4 → `TRateThemeData` |

## 受控

`value` + `onChanged`（含 `onChangeStart`/`End` 等）。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| size | 评分图标的大小 |
| PlacementEnum | KEEP：设计稿语义枚举保留 |
| icon | KEEP：L1–L3 高频 / Material 同名 |
| direction | KEEP：L1–L3 高频 / Material 同名 |
| texts | KEEP：实例辅助文案列表 |
| builderText | KEEP：实例自定义文案 Builder |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| color | TRateThemeData | L4 → Theme |
| onChange | onChanged | 命名对齐 v1.0 |
| disabled | onChanged: null | Material 禁用 |
| allowHalf | TRateThemeData | L4 → Theme |
| count | TRateThemeData | L4 → Theme |
| gap | TRateThemeData | L4 → Theme |
| placement | TRateThemeData | L4 → Theme |
| showText | TRateThemeData | L4 → Theme |
| textWidth | TRateThemeData | L4 → Theme |
| mainAxisAlignment | TRateThemeData | L4 → Theme |
| crossAxisAlignment | TRateThemeData | L4 → Theme |
| mainAxisSize | TRateThemeData | L4 → Theme |
| iconTextGap | TRateThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TRate`、`TRateThemeData`、`PlacementEnum`
- **移出**：内部 `*Style`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TRateThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` / `onChanged` | 语义对齐 Material **`Slider`** | C 类；`onChanged: null` 禁用 |
| `count` / `allowHalf` | **实例** | 星数与半星（默认可 Theme） |
| `icon` / `texts` / `builderText` | **实例 KEEP** | 图标与文案映射 |
| `color` / `gap` / 对齐 / `showText` | TDesign **`TRateThemeData`** | L4 默认 |

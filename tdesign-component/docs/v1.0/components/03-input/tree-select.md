# TTreeSelect — v1.0 定稿

> Sprint **S4** | 控制类 **F** | Material: 自绘
> 源码：`lib/src/components/tree` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘 + Material 底座（滚轮/日历等） |
| Material | 自绘 |
| Theme | `TTreeSelectThemeData` |
| 禁用 | `onChanged: null`（F 类）。 |
| L4 | 构造器 L4 → `TTreeSelectThemeData` |

## 受控

`value` + `onChanged`；项级 `*.disabled` KEEP。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TTreeSelect | 多列树形选择 |
| options | 树形数据源 |
| multiple | 单/多选 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TTreeSelectStyle | TTreeSelectThemeData | L4 → Theme |
| onChange | onChanged | 命名对齐 v1.0 |
| style | TTreeSelectThemeData | L4 → Theme |
| height | TTreeSelectThemeData | L4 → Theme |
| outwardCornerRadius | TTreeSelectThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| defaultValue | 初始值，对应options中的value值 |

### 新增

| 符号 | 说明 |
| --- | --- |
| value | 受控选中项；配套 `onChanged`；初值由父 State 持有 |
| TTreeSelectThemeData | L4 列宽/圆角/样式默认 |

### show API（嵌入 TPopup）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `value` | L1 | **新增** | 受控选中项（单/多选由 `multiple` 决定） |
| `onChanged` | L3 | **改名** | 原 `onChange` |
| `options` | L2 | **保留** | 树形数据源 |
| `multiple` | L2 | **保留** | 单/多选 |
| `height` / `columnWidth` / `style` | L4 | → Theme | 列布局默认 |
| 确认/重置 | — | **业务组装** | 多选场景配合 `TPopup.show` 底栏 |

### L4 迁入 `TTreeSelectThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `height` / `columnWidth` | 列布局 | 自绘多列 |
| `outwardCornerRadius` / `color` | 面板圆角/背景 | TDesign 扩展 |
| `style` | variant 默认 | 原 `TTreeSelectStyle` |

### export

- **保留**：`TTreeSelect`、`TTreeSelectThemeData`
- **移出**：`TTreeSelectStyle`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TTreeSelectThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `options` | 实例 KEEP | 树形数据 |
| `multiple` | 实例 KEEP | 单/多选 |
| `value` / `onChanged` | C 类（若有） | 选中值 |
| `columnWidth` / `height` / `style` / `outwardCornerRadius` / `color` | **`TTreeSelectThemeData`** | L4 |

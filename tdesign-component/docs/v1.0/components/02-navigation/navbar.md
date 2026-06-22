# TNavBar — v1.0 定稿

> Sprint **S3** | 控制类 **A** | Material: AppBar
> 源码：`lib/src/components/navbar` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | AppBar |
| Theme | `TNavBarThemeData` |
| 禁用 | 操作项 `onPressed: null`；返回 `onBack: null`。 |
| L4 | 构造器 L4 → `TNavBarThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| title / titleWidget | 标题文案与自定义标题 |
| centerTitle | 标题居中 |
| onBack / useDefaultBack | 返回行为 |
| belowTitleWidget / flexibleSpace | 扩展区域 |
| TNavBarItem | 左右操作项（待收敛为 leading/actions 槽位） |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| leftBarItems | leading | 对齐 AppBar |
| rightBarItems | actions | 对齐 AppBar |
| titleColor / backIconColor | TNavBarThemeData | L4 → Theme |
| titleFont / titleFontWeight / titleFontFamily | TNavBarThemeData | L4 → Theme |
| backgroundColor / height / padding / titleMargin | TNavBarThemeData | L4 → Theme |
| opacity / border / boxShadow / useBorderStyle | TNavBarThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| screenAdaptation | 屏幕适配改 Theme / MediaQuery 默认 |
| TNavBarItemBorder | 迁入 `TNavBarThemeData.border` |

### 新增

| 符号 | 说明 |
| --- | --- |
| TNavBarThemeData | L4 默认 |

### export

- **保留**：`TNavBar`、`TNavBarItem`、`TNavBarThemeData`
- **移出**：`TNavBarItemBorder` 等内部 enum（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TNavBarThemeData` · Material: **AppBar** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `backIconColor` / `titleColor` / `titleFont` / `height` / `backgroundColor` | TDesign **`TNavBarThemeData`** | 0.2.x L4；`titleWidget` 等槽位 **KEEP** 实例 |
| `leading` / `actions` / `flexibleSpace` | Material **`AppBar`** 同级 | 实例组合 |

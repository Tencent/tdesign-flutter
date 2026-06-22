# TLoading — v1.0 定稿

> Sprint **S2** | 控制类 **A** | Material: CircularProgressIndicator
> 源码：`lib/src/components/loading` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | CircularProgressIndicator |
| Theme | `TLoadingThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → `TLoadingThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TLoadingSize | 尺寸/位置枚举保留 |
| size | 尺寸 |
| TLoadingIcon | KEEP：设计稿语义枚举保留 |
| icon | KEEP：L1–L3 高频 / Material 同名 |
| text | KEEP：L1–L3 高频 / Material 同名 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| iconColor | TLoadingThemeData | L4 → Theme |
| refreshWidget | TLoadingThemeData | L4 → Theme |
| textColor | TLoadingThemeData | L4 → Theme |
| axis | TLoadingThemeData | L4 → Theme |
| customIcon | TLoadingThemeData | L4 → Theme |
| duration | TLoadingThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TLoading`、`TLoadingSize`、`TLoadingIcon`、`TLoadingThemeData`
- **移出**：`t_circle_indicator.dart` 内部 Widget（默认不 export）（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TLoadingThemeData` · Material: **CircularProgressIndicator** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` | Material **`CircularProgressIndicator`** | `null` 为 indeterminate |
| `color` / `backgroundColor` / `strokeWidth` / `strokeAlign` | Material **`ProgressIndicatorTheme`** | 指示器绘制 |
| `semanticsLabel` / `semanticsValue` | Material 无障碍 | 读屏文案 |
| `text` / `icon` / `size` | **实例 KEEP** | 加载文案与 TDesign 图标语义 |
| `axis` / `textColor` / `iconColor` / `customIcon` / `duration` | TDesign **`TLoadingThemeData`** | 文案+指示器组合布局与动画默认 |
| `refreshWidget` | TDesign **`TLoadingThemeData`** | 下拉刷新等场景的自定义指示器默认 |

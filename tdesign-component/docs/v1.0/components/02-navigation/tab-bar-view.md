# TTabBarView — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: TabBarView
> 源码：`lib/src/components/tabs` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | TabBarView |
| Theme | `TTabBarThemeData` |
| 禁用 | 容器无统一 bool。 |
| L4 | 构造器 L4 → `TTabBarThemeData` |

## 受控

无受控 value；按子交互控件控制类处理。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| children | KEEP：Material `TabBarView.children` |
| controller | Material `TabBarView.controller`；与 TTabBar 共用 `TabController` |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| isSlideSwitch | physics | 对齐 Material |
| — | — | 新增 Material `dragStartBehavior` / `clipBehavior`（可选） |
| 默认不可滑动 | physics: NeverScrollableScrollPhysics() | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| isSlideSwitch | 由 `physics` 表达 |

### 新增

| 符号 | 说明 |
| --- | --- |
| physics | Material `TabBarView.physics` |
| dragStartBehavior | Material `TabBarView.dragStartBehavior` |
| clipBehavior | Material `TabBarView.clipBehavior` |

### export

- **保留**：`TTabBarView`、`TTabBarThemeData`
- **移出**：内部 `*Style`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TTabBarThemeData` · Material: **TabBarView** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `children` | Material **`TabBarView`** | 页面列表 |
| `controller` | Material **`TabBarView`** | 与 **`TabBar`** 共享 |
| `physics` | Material **`TabBarView`** | 是否允许手势滑页；0.2.x `isSlideSwitch` 映射 |
| `dragStartBehavior` | Material **`TabBarView`** | 拖拽行为 |
| `clipBehavior` | Material **`TabBarView`** | 裁剪 |
| 默认 `physics` | TDesign **`TTabBarThemeData`** | 默认 **`NeverScrollableScrollPhysics`**（与 0.2.x 一致） |
| Tab 指示器/标签样式 | Material **`TabBarTheme`** | 属 **TTabBar**，非 TabBarView |

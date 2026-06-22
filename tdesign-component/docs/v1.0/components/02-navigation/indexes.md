# TIndexes — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: 自绘
> 源码：`lib/src/components/indexes` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | 自绘 |
| Theme | `TIndexesThemeData` |
| 禁用 | 容器/展示无统一 bool。 |
| L4 | 构造器 L4 → `TIndexesThemeData` |

## 受控

无受控 value；按子交互控件控制类处理。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| indexList | 索引字符列表（默认 A–Z） |
| builderContent | 按索引构建内容区 |
| builderAnchor | 自定义锚点标题 |
| builderIndex | 自定义侧边索引项 |
| scrollController | 滚动控制器 |
| onSelect | 点击侧边栏索引 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| onChange | onChanged | 命名对齐 v1.0 |
| indexListMaxHeight | TIndexesThemeData | L4 → Theme |
| sticky | TIndexesThemeData | L4 → Theme |
| stickyOffset | TIndexesThemeData | L4 → Theme |
| capsuleTheme | TIndexesThemeData | L4 → Theme |
| reverse | TIndexesThemeData | L4 → Theme |

### 废弃

_无_

### 新增

| 符号 | 说明 |
| --- | --- |
| TIndexesThemeData | L4 索引栏与锚点默认 |
| activeIndex | 内部当前索引（可选受控扩展） |

### export

- **保留**：`TIndexes`、`TIndexesList`、`TIndexesAnchor`、`TIndexesThemeData`
- **移出**：`sticky_header` 内部实现细节（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TIndexesThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `child` / 锚点列表 | **Scrollable + 自绘** | 实例 **`builderContent`** / **`builderAnchor`** / **`builderIndex`** |
| 右侧索引条 | TDesign 扩展 | 字母索引交互；Material 无直接等价 |
| `indexListMaxHeight` | TDesign **`TIndexesThemeData`** | L4 默认 |

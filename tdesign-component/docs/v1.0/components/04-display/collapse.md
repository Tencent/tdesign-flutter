# TCollapse — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: ExpansionPanelList / ExpansionPanel
> 源码：`lib/src/components/collapse` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | ExpansionPanelList / ExpansionPanel |
| Theme | `TCollapseThemeData` |
| 禁用 | 容器无统一 bool。 |
| L4 | 构造器 L4 → `TCollapseThemeData` |

## 受控

无受控 value；按子交互控件控制类处理。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| children | `List<TCollapsePanel>`；Material `ExpansionPanelList.children` |
| headerBuilder | 面板标题区（Material `ExpansionPanel.headerBuilder`） |
| body | 面板内容（Material `ExpansionPanel.body`） |
| isExpanded | 多开模式下是否展开（Material `ExpansionPanel.isExpanded`） |
| value | 手风琴模式下面板唯一标识（Material `ExpansionPanel.value`） |
| expandIconTextBuilder | 展开图标旁说明文案（TDesign 扩展） |
| animationDuration | Material `ExpansionPanelList.animationDuration` |
| elevation | Material `ExpansionPanelList.elevation` |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TCollapseStyle | TCollapseThemeData.style | L4 → Theme |
| style | TCollapseThemeData | L4 → Theme |
| expansionCallback | onExpansionChanged | 对齐 Material |
| initialOpenPanelValue | value | 命名对齐 v1.0 |
| backgroundColor | TCollapseThemeData | L4 → Theme |

### 废弃

_无_

### 新增

| 符号 | 说明 |
| --- | --- |
| **TCollapseMode** | `multiple` / `accordion` |
| **TCollapsePanel** | 公开面板类型（0.2.x 已存在；v1.0 继续 export） |
| mode | 手风琴 / 多开；默认 `multiple` |
| onExpansionChanged | `ExpansionPanelCallback?` — `(index, isExpanded)` |
| onChanged | 手风琴可选：`ValueChanged<T?>?` — 以 panel `value` 为载荷的受控回调 |

### export

- **保留**：`TCollapse`、`TCollapsePanel`、`TCollapseMode`、`TCollapseThemeData`
- **移出**：`TCollapseStyle`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TCollapseThemeData` · Material: **ExpansionPanelList / ExpansionPanel** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `children` | Material **`ExpansionPanelList`** | `List<ExpansionPanel>` → `TCollapsePanel` |
| `onExpansionChanged` | Material **`expansionCallback`** | `(int index, bool isExpanded)` |
| `animationDuration` / `elevation` | Material **`ExpansionPanelList`** | 实例 KEEP |
| `headerBuilder` / `body` / `isExpanded` | Material **`ExpansionPanel`** | 面板结构 |
| `value`（Panel） | Material **`ExpansionPanel.value`** | 手风琴模式必填且互异 |
| `value`（Collapse 手风琴） | **受控扩展** | 当前展开 panel 的 `value`；替代 Widget 级 `initialOpenPanelValue` |
| `style`（block/card） | TDesign **`TCollapseThemeData`** | Material 无 block/card 语义 |
| `expandIconTextBuilder` | TDesign 扩展 | 展开按钮旁文案 |
| `backgroundColor` | TDesign **`TCollapseThemeData`** | 默认面板背景；实例 Panel 可破例 |

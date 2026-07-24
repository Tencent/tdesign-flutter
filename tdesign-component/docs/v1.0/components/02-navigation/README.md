# 导航

> 与 [官网 · 导航](https://tdesign.tencent.com/flutter/overview) 对齐。
> 返回 [v1.0 文档索引](../../README.md)

## 文档组织

| 类型 | 规则 | 数量 |
|---|---|---|
| **定稿** | 一官网入口一文件 | 8 篇 |

## 定稿写法（8 篇统一）

- **三节**：§1 API · §2 Theme · §3 实现/测试/Example
- **文首**：元信息 + **读法** + **图例链** + TOC
- **架构 + 控制方案**：`## 架构` 表 + `## 控制方案`（对齐 [controlled.md](../../foundation/controlled.md) · [api.md](../../foundation/api.md)）
- **§1.1**：每个参数单独一行；子类型用独立表
- **§1 脚注**：L4 样式统一迁入 §2 Theme
- **§1 P0 声明**：每篇 §1 显式写明「无 P0 逃逸舱（`style` / `decoration` 默认无）」（四问判定见 [theme.md §2.2](../../foundation/theme.md#22-p0-逃逸舱判定)）
- **L2 槽位**：Widget 实例用语义名（`title`/`child`）；Builder 用 `{语义}Builder` → [api.md §2.1](../../foundation/api.md#21-l2-内容槽widget-实例-vs-builder-回调)
- **§1.3**：公开 export / 不 export 两行式
- **§2**：配置选型三行 + 单张字段表（含决策列）+ **「字段归类：进 Theme 与不进 Theme」**（[theme.md §4](../../foundation/theme.md#4-material-vs-themeextension) 必填；小节顶部一行说明 Material 判定结论：能主题化者为 P1 TDesign 扩展 / P2 Material 子主题，并明确分区「进 Theme」与「不进 Theme（构造器 Lx）」）；覆盖顺序统一写 `P0` > `P1` > `P2` > `P3` > `P4` 记号
- **§3**：链 [testing.md](../../guide/testing.md)
- **篇幅**：约 90–150 行；不写附录 C、不贴大段代码（E 类 `show` 用法除外）

## 官网对照

| 定稿 | 控制类 | 文档状态 | 官网 |
|---|---|---|---|
| [tab-bar.md](./tab-bar.md) | B | **已定稿** | [TabBar 标签栏](https://tdesign.tencent.com/flutter/components/tab-bar) |
| [tabs.md](./tabs.md) | — | **已定稿** | [Tabs 选项卡](https://tdesign.tencent.com/flutter/components/tabs) |
| [backtop.md](./backtop.md) | A | **已定稿** | [BackTop](https://tdesign.tencent.com/flutter/components/back-top) |
| [navbar.md](./navbar.md) | A | **已定稿** | [Navbar](https://tdesign.tencent.com/flutter/components/navbar) |
| [steps.md](./steps.md) | — | **已定稿** | [Steps](https://tdesign.tencent.com/flutter/components/steps) |
| [drawer.md](./drawer.md) | E | **已定稿** | [Drawer](https://tdesign.tencent.com/flutter/components/drawer) |
| [indexes.md](./indexes.md) | — | **已定稿** | [Indexes](https://tdesign.tencent.com/flutter/components/indexes) |
| [sidebar.md](./sidebar.md) | B | **已定稿** | [SideBar](https://tdesign.tencent.com/flutter/components/side-bar) |


## 组件清单

| 实现 | 产品 | 定稿 | Sprint |
|---|---|---|---|
| [ ] | TabBar | [tab-bar.md](./tab-bar.md) | S3 |
| [ ] | Tabs | [tabs.md](./tabs.md) | S3 |
| [ ] | TBackTop | [backtop.md](./backtop.md) | S3 |
| [ ] | TNavBar | [navbar.md](./navbar.md) | S3 |
| [ ] | TSteps | [steps.md](./steps.md) | S3 |
| [ ] | TDrawer | [drawer.md](./drawer.md) | S4 |
| [ ] | TIndexes | [indexes.md](./indexes.md) | S3 |
| [ ] | TSideBar | [sidebar.md](./sidebar.md) | S3 |

> **文档**：上表 8 篇定稿 md 均已 **已定稿**；`[ ]` 表示 Dart 实现尚未按 §3 验收。

# v1.0 文档说明

> TDesign Flutter **1.0 重构**设计文档集。文档定稿 ≠ 代码已全部落地；实现进度见各 `components/*/README.md`。

```
docs/
└── v1.0/
    ├── README.md                  # ← 你在这里：各块职责地图
    │
    ├── guide/                     # 怎么在这个仓库里干活
    │   ├── developer-guide.md     #   环境、目录结构、本地命令
    │   ├── component-doc.md       #   单篇组件 md 怎么写
    │   ├── doc-generation.md      #   注释 → API 生成（tdesign_flutter_tools）
    │   ├── testing.md             #   CI、测试位置/运行/命名、Widget/Golden、发布前检查
    │   └── component-acceptance-standard.md  # 整体工作验收标准 + Theme 接入验证方法
    │
    ├── migration/                 # 迁移回 tdesign-flutter 主仓的分批 PR 方案与进展
    │   ├── README.md              #   目录说明和迁移原则
    │   ├── pr-staging-plan.md     #   分阶段 PR 拆分方案
    │   └── progress.md            #   当前进展、验收快照和风险
    │
    ├── foundation/                # 全组件共守的设计规则（按需查阅，组件 md 只写差异）
    │   ├── api.md                 #   构造器 L1–L4、命名、禁用、export
    │   ├── controlled.md          #   受控模型、控制类 A–F
    │   ├── theme.md               #   Token、ThemeExtension、子树覆盖
    │   ├── form.md                #   TForm / TFormField
    │   └── disabled-evolution.md  #   0.2.x 禁用字段 → v1.0 映射
    │
    └── components/                # 逐组件定稿（§1 API · §2 升级 · §3 Theme）
        ├── 01-base/               #   基础（含分类 Sprint / Tier 清单 README）
        ├── 02-navigation/         #   导航
        ├── 03-input/              #   输入
        ├── 04-display/            #   数据展示
        └── 05-feedback/           #   反馈

example/assets/api/                # Example API 面板（注释生成，非本目录；见 guide/doc-generation.md）
```

**入门**：[`guide/developer-guide.md`](./guide/developer-guide.md) → `components/{分类}/{组件}.md`（样板 [`button.md`](./components/01-base/button.md)）

---

## 快速导航

按主题快速跳到对应文档与关键章节：

| 主题 | 文档 | 关键章节 |
| --- | --- | --- |
| **Theme 层级**（四层架构 / 优先级 P0–P4 / 子树覆盖 / 禁止 `themeData`） | [foundation/theme.md](./foundation/theme.md) | §1 四层 · §2 优先级 · §3 子树覆盖 · §2.2 P0 逃逸舱 |
| **测试**（CI 门槛 / 测试位置·运行·命名 / Widget 必测 / Golden） | [guide/testing.md](./guide/testing.md) | §1 CI · §2.1 位置·运行·命名 · §3 必测 · §4 Golden |
| **验收标准 + 验证**（整体工作验收 / Theme 接入验证 / Web 网页） | [guide/component-acceptance-standard.md](./guide/component-acceptance-standard.md) | 一·二 验收项 · §四 Theme 验证方法 · 补充项 G |
| **组件 md 编写**（章节结构 / 发布前去重清单） | [guide/component-doc.md](./guide/component-doc.md) | §2 章节 · §8 去重清单 |
| **注释 → API 文档生成**（tdesign_flutter_tools） | [guide/doc-generation.md](./guide/doc-generation.md) | §3 注释约束 · §6 发布前 |
| **迁移回主仓**（分批 PR 方案 / 进展 / 风险） | [migration/README.md](./migration/README.md) | [PR 拆分](./migration/pr-staging-plan.md) · [进展](./migration/progress.md) |
| **开发入门**（环境 / 目录 / 本地命令） | [guide/developer-guide.md](./guide/developer-guide.md) | — |

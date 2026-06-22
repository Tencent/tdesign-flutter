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
    │   └── testing.md             #   CI、Widget/Golden、发布前检查
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

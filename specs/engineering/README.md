# 工程 Spec

[返回总规范](../README.md) · [组件 Spec](../components/README.md)

本目录收录 5 份跨组件工程契约，格式为 `<编号>-<类别>-<事项描述>`。按独立职责与独立验收边界决定是否拆分，不按历史任务或 PR 数量创建 Spec。

| Spec | 职责 |
| --- | --- |
| [044-Testing-golden-regression](./044-Testing-golden-regression/spec.md) | Golden 覆盖、精确比较、归属和基线维护 |
| [044-ThemeController-import-and-preview](./044-ThemeController-import-and-preview/spec.md) | 控制器实时预览、生成器 CSS 转换与应用导入 |
| [046-Demo-experience](./046-Demo-experience/spec.md) | 公开示例边界、调试区块和 Demo 体验 |
| [048-Theme-configuration-contracts](./048-Theme-configuration-contracts/spec.md) | Token、TThemeData、组件 Theme、实例 API 及 Material 隔离的统一契约 |
| [057-Release-readiness](./057-Release-readiness/spec.md) | 暂留的发布候选验收门槛；关闭后归入 PUBLISH.md |

Theme 只维护一份配置契约，Material 隔离是其中一章；Token 运行要求归 [Theme 验收](./048-Theme-configuration-contracts/acceptance.md)，报告、截图、审计表归该目录的 `evidence/`，不单设验证 Spec。ThemeController 独立维护输入转换和主题同步链路。

Testing 只维护 Golden；通用文档与测试规范维护在 CONTRIBUTING.md 和站点指南。Release 暂存未关闭的候选门槛，不沿用旧 PR 或历史 CI 作为当前发布状态。

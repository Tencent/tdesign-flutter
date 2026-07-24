# v1.0 迁移方案与进展

> 本目录用于记录 `tdesign-flutter-v1` 分批迁移回 `tdesign-flutter` 主仓的 PR 方案、验收口径和阶段进展。

## 文档职责

| 文档 | 用途 |
| --- | --- |
| [pr-staging-plan.md](./pr-staging-plan.md) | 分批 PR 阶段、每阶段范围、验收口径和拆分原则 |
| [progress.md](./progress.md) | 当前迁移进展、已完成验证、剩余风险和下一步 |

## 迁移原则

1. 每个 PR 必须能独立通过定向 `flutter analyze`、定向 `flutter test`、API 文档生成/校验。
2. 不引入旧 API 兼容层；已在 v1 文档中清理的历史 API 不回填到源码。
3. tools 重构与 v1 组件源码迁移分开提交，避免 review 范围互相污染。
4. 组件 PR 必须同时包含源码、测试、API 注释、生成 API 文档和对应 v1 文档。
5. 优先合入后续组件会依赖的基础能力，再合入依赖更复杂的组合组件。

## 当前建议路线

先以 `01-base` 作为主仓迁移的试点，但不要一次性提交完整 base 大 PR。推荐拆为：

1. base 约束与基础设施
2. `text` / `divider` / `icon`
3. `button` / `link`
4. `fab`

完成 01-base 后，再按依赖链推进 input、overlay/feedback、display、navigation 和复杂业务组件。

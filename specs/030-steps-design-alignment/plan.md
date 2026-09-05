# 实施计划

1. 记录新版 Figma、小程序公开 Demo 与 Flutter 当前实现的结构、视觉和交互差异。
2. 收敛 `value`、`status`、`variant`、`onChange` 的职责及 Theme 所有权。
3. 重构公开 Demo 为新版 Figma 的三组顺序，并保留小程序受控、只读和自定义内容的操作模式。
4. 先完成组件、Demo、API/Theme Review 与真机明暗主题实际操作，再生成并严格复跑 light/dark Golden。
5. 完成双 SDK analyze、测试、覆盖率、构建、生成产物和持久安装。
6. 独立创建 GitHub/CNB PR，关联 #1027 Steps 条目并请求 CodeBuddy Review。

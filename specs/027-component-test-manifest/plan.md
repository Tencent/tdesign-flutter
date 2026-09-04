# Plan

1. 将现有覆盖率、组件、Demo 和视觉测试清单无损迁移到强类型 manifest。
2. 让三个既有 runner 从 manifest 派生清单，并增加 Demo 功能测试 runner。
3. 将 GitHub 与 CNB 的 Demo 长命令替换为公共 runner。
4. 增加名称唯一、文件存在、组件能力完整和 CI 入口一致性测试。
5. 运行严格 analyze、工具测试和完整 Demo 功能回归。

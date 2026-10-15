# 实施方案

1. 从最新 develop 独立建 release/1.0.0，不依赖发布准备整理PR。
2. 修改组件pubspec，使用现有 Demo 元数据工具同步展示版本，保留上次构建时间；不修改已有 Demo 构建号策略。
3. 提交后执行 flutter pub publish --dry-run，核对归档包含迁移说明、许可证与字体，排除测试、工具、Demo及缓存。
4. 双SDK检查公开入口与迁移消费；创建目标develop的草稿PR，核对自动生成日志。
5. 先完成发布准备缺口，再同步最终develop、冻结候选和执行最终矩阵。正式发布按PUBLISH.md办理。

# 实施与验证安排

复用资源准备和 APK workflow，保持 Web/APK 并行；只保留 NDK 跟随 SDK、Gradle bin 与缓存相关 Android 改动。

从本轮移出版本号重构、元数据脚本和对应测试、Example 锁文件及所有 enforce-lockfile / latest 删除锁文件分支。预览元数据恢复为经格式校验的组件版本、PR 编号和工作流运行编号，保留现有发布器格式。

在独立 SDK 目录以普通 release 命令重建 APK；检查工作流、元数据格式、生成资源及实际包版本。旧候选的 Web/iOS 验证保留原范围，不外推精简版已完成远端构建。l10n 的双版本生成与语言切换结论仍对应未变化的配置。

## 文档审计测试提速

在原工具中提取 `runApiDocsAudit(args, root:, output:)`，返回退出码；CLI 只负责标准输出和进程退出码适配。测试显式传入临时 fixture 路径与 StringBuffer，复用原有断言，仅 CLI 冒烟用例复制脚本并启动 Dart。风险集中在脚本路径、输出重定向、返回码及重复调用状态，分别用真实 CLI 对照与重复调用验证。双版本功能回归入口保持原样。

## 功能回归并行拆分

使用 suite: [components, examples, tooling] 与 SDK 的二维矩阵分配原步骤，复用同一份 checkout/SDK 配置，避免复制三份 setup。组件和工具任务只显式执行组件目录的 pub get；现有 Flutter 会同时自动解析 Example 依赖，满足片段分析需要。示例任务保留原有组件及 Example 准备步骤。tooling 包含 css2token、外部迁移消费者、工具自测及示例结构/片段检查。保留 test 双版本名称并依赖 regression 矩阵，使用 always() 检查全部上游结果，严格要求 success。汇总等待全部 SDK，任一分支失败时两个汇总检查均失败。

风险为测试遗漏、依赖准备不足、分支保护检查名称变化和 runner 并发额度/重复准备开销。验证原命令清单前后完全一致、workflow 语法及门禁的成功/失败/取消/跳过组合；在两个独立 SDK 副本运行全部原入口。CNB 继续使用原集中调度器，本轮不改变其平台配置。GitHub job 并行依赖独立 runner，本地同一副本依次运行入口，避免并发写 Flutter 构建缓存；不把本地耗时当成远端并行测量。

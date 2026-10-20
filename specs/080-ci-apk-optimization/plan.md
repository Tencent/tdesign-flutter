# 实施与验证安排

复用资源准备和 APK workflow，保持 Web/APK 并行；只保留 NDK 跟随 SDK、Gradle bin 与缓存相关 Android 改动。

从本轮移出版本号重构、元数据脚本和对应测试、Example 锁文件及所有 enforce-lockfile / latest 删除锁文件分支。预览元数据恢复为经格式校验的组件版本、PR 编号和工作流运行编号，保留现有发布器格式。

在独立 SDK 目录以普通 release 命令重建 APK；检查工作流、元数据格式、生成资源及实际包版本。旧候选的 Web/iOS 验证保留原范围，不外推精简版已完成远端构建。l10n 的双版本生成与语言切换结论仍对应未变化的配置。

## 文档审计测试提速

在原工具中提取 `runApiDocsAudit(args, root:, output:)`，返回退出码；CLI 只负责标准输出和进程退出码适配。测试显式传入临时 fixture 路径与 StringBuffer，复用原有断言，仅 CLI 冒烟用例复制脚本并启动 Dart。风险集中在脚本路径、输出重定向、返回码及重复调用状态，分别用真实 CLI 对照与重复调用验证。双版本功能回归入口保持原样。

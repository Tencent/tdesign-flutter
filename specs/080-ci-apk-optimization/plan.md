# 实施与验证安排

复用资源准备和 APK workflow，保持 Web/APK 并行；只保留 NDK 跟随 SDK、Gradle bin 与缓存相关 Android 改动。

从本轮移出版本号重构、元数据脚本和对应测试、Example 锁文件及所有 enforce-lockfile / latest 删除锁文件分支。预览元数据恢复为经格式校验的组件版本、PR 编号和工作流运行编号，保留现有发布器格式。

在独立 SDK 目录以普通 release 命令重建 APK；检查工作流、元数据格式、生成资源及实际包版本。旧候选的 Web/iOS 验证保留原范围，不外推精简版已完成远端构建。l10n 的双版本生成与语言切换结论仍对应未变化的配置。

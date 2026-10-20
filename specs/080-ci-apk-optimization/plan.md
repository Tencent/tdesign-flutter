# 实施与验证安排


资源准备和 APK 构建分别使用可复用 workflow；PR 的最低版本 APK 由预览构建提供，latest APK 仍由兼容任务验证。Web 与 APK 在资源准备后并行。组件测试与 Golden 调度保持原状，不在此轮改变覆盖率口径。

Android 版本序号迁移、NDK 跟随 SDK、Gradle bin 分发、固定 SDK 锁文件分别通过实际 APK 与检查验证。Flutter 3.32.0 的原生 release 构建必须保留默认插件准备，不能使用 --no-pub 跳过注册更新。远端 Artifact 传递和发布结果在推送后另行验收。

### l10n 清理

只移除废弃 synthetic-package 配置并显式设置 lib/l10n 输出目录，不调整翻译、导入或工具链版本。两个 SDK 的独立目录删除原生成文件后重新生成，比较三个生成文件的字节内容；分别执行严格分析、现有中英文切换测试和 release APK 构建。执行结论追加到 acceptance.md，不覆盖上轮 APK 验收的候选指纹。

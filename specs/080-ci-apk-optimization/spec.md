# CI 与 Demo APK 构建优化

## 背景

PR 的相同 SDK APK 重复构建，平台矩阵反复生成资源，网站与 APK 串行；日期版本号同日不递增，l10n 含废弃选项。目标是在保留双 SDK、release 和现有回归口径的前提下减少重复工作。

## 方案与边界


- l10n 直接生成到 `lib/l10n`，不再声明废弃的 synthetic-package 选项。保留 ARB、现有导入和 generate: true；最低与较新 SDK 均需在删除旧生成文件后重新生成并验证，不能以旧文件残留推定兼容。不升级 Gradle、AGP 或 Kotlin。

- 资源准备在 Flutter 3.32.0 下统一生成 API、示例片段与构建元数据，工作流内通过 Artifact 传递给 APK、Web、iOS。依赖和编译目录不跨 SDK 共享。
- PR 的 3.32.0 APK 由 PREVIEW_BUILD 负责，同时提供兼容验证与下载；test-build 保留 latest APK，develop push 仍验证双版本。预览 Web 与 APK 并行，发布仍等待两者成功，保留来源 PR、Artifact 和线上内容校验。
- 保留 release 与通用架构、测试依赖和组件回归。Gradle 使用 bin 分发与用户目录缓存；缓存命中不是成功条件。
- 官方 GitHub APK 使用 PREVIEW_BUILD 运行序号生成 versionCode：2030000000 + run_number，上限 2100000000。迁移基数高于切换日旧日期方案；工作流重试可使用相同版本。其他工作流的验证包不作为同一连续发布序列。
- Android versionName 读取统一版本资源，versionCode 消费 Flutter build-number；版本资源缺失立即失败，不再回退旧版本。本地无显式 build-number 时沿用 Flutter 的默认值。
- Example 的固定 SDK 交付构建使用锁文件；latest 兼容构建单独解析依赖，不能受固定 SDK 锁文件限制。

验收包括工作流语法、资源传递、双 SDK 依赖与检查、Android 版本及 release APK 构建。本地不推定远端工作流或预览发布已通过。

## 取舍

保留两个工作流各自的资源准备，避免跨运行查找 Artifact 带来来源与权限耦合。工具链升级及组件覆盖率调度重构不纳入本轮。

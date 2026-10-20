# 本地验证记录

以下记录绑定原独立验证副本的候选指纹；为单独提交 PR，将相同的构建代码与 l10n 配置移植到 develop 基线 d0de29e8b902c910c86dca05b46fc8604790d591。未带入文档整理 PR #1178 的改动。下述“未提交、未推送”描述当次本地验收时点，当前 PR 的远端状态另行核对。

## APK 与 CI 优化本地验收（2026-10-20）

候选基线：`e81b5b67b67069cc08314fd505055a692cd54d52`，独立副本分支 `perf/ci-apk-local` 的未提交修改。对所有修改及新增的非 specs 文件，按仓库路径排序，逐项写入 UTF-8 路径、NUL 和原始文件内容的 SHA-256 为 `b225358e2363d447a423651af76a279705b19ade84ce3ee9c899aef34944d4e2`（13 个文件）。没有修改 sources 或原工作副本，没有提交、推送或远端工作流执行。

环境：macOS arm64，JDK 17，Android SDK；Flutter 3.32.0 与本机较新 stable SDK 3.47.7 使用不同项目目录。该记录不宣称 3.47.7 永远等于远端 latest。

| 检查 | 结果与边界 |
| --- | --- |
| actionlint 1.7.7 | test-build、preview-build、prepare-demo、build-apk 四份工作流通过；YAML 解析和 git diff --check 通过。不能代替远端 Artifact 传递。 |
| 构建元数据 | 2 项 Node 测试通过，涵盖旧版本升级、序号递增、非法输入和 Android 上限；CLI 产物与现有发布器的 build-env 格式一致。 |
| 资源准备 | Flutter 3.32.0 生成 57 份 API 文档、示例片段和构建元数据；生成文档/片段与原文件无差异；57 个组件契约检查通过。动态构建时间未作为源码变更保留。 |
| 固定版本依赖 | Example 锁文件在 Flutter 3.32.0 下 enforce-lockfile 解析通过；3.47.7 在独立目录删除锁文件后在线解析通过。 |
| 静态分析 | 两个 SDK 的 flutter analyze --no-pub --fatal-infos 均无诊断。 |
| 回归入口 | Flutter 3.32.0 的 run_component_regression_test.dart 与 run_visual_regression_test.dart 共 17 项通过；没有执行全部组件功能或 Golden。 |
| 3.32.0 release APK | 构建成功，约 29.1 MB；aapt 验证 versionName=1.0.0、versionCode=2030001980，minSdk=21；apksigner 验证通过。SHA-256：d25dbe05d36a826ad3d21d1d3270cc7e8ee20f719aece807718b7a2172ce4d72。 |
| 3.47.7 release APK | 构建成功，约 66.3 MB；aapt 验证 versionName=1.0.0、versionCode=2030001980，minSdk=24。SHA-256：165568dd0bf459eef1de8b4874a93ecdbe958e0a45fa0aa07fb0bea17c9c75cc。 |

原生构建验证发现 Flutter 3.32.0 在 --no-pub 时跳过 release 插件注册更新，造成 integration_test 注册代码与原生依赖不一致。最终 workflow 保留默认构建准备，不删除测试依赖或手工修补生成的插件注册文件。Gradle NDK 跟随各自 Flutter SDK。

3.47.7 仍提示现有 AGP/Kotlin 即将低于支持范围及 l10n synthetic-package 废弃；本轮未扩大为工具链升级。上述 APK 是本地构建与包字段证据，未安装、未验证前台运行或旧包覆盖安装；不证明 GitHub/Linux 或 iOS/Web 实际执行通过，也没有测量远端优化后的耗时。剩余事项见 tasks.md。

## l10n 清理双版本验收（2026-10-20）

在上述独立副本中，移除 synthetic-package 和过时注释，显式设置 output-dir: lib/l10n。本轮未升级工具链：Gradle 8.14、AGP 8.11.1、Kotlin 2.2.20；未修改 ARB、导入或生成 Dart。基线 SHA 与上轮相同，累计未提交源码按上轮算法计算的指纹为 `60193f84e9f08b8609084cf96072aaa3bcd3ed52ebf916cfc1002e0f5421f705`（14 个非 specs 文件），l10n.yaml 的 SHA-256 为 `007ec51ce35db760911c81f8203244dd6facad5a5c36730182c3437ce7b897af`。

两个 SDK 在独立项目目录中，先删除 app_localizations.dart、app_localizations_en.dart、app_localizations_zh.dart，再执行 flutter gen-l10n，排除旧产物残留。生成后的三个文件在双版本之间、与修改前均逐字节一致。

| 检查 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 从空生成文件重新生成 l10n | 通过 | 通过 |
| 严格静态分析 | 无诊断 | 无诊断 |
| 现有中英文切换测试 | 1 项通过，确认中文“确认”切换为英文 Confirm | 同一测试通过 |
| release APK | 成功，约 29.1 MB | 成功，约 66.3 MB |
| synthetic-package 废弃警告 | 生成及构建日志未出现 | 生成及构建日志未出现 |

测试入口为 Example 的 `test/theme/theme_demo_test.dart`，使用完整测试名 `internationalization guide uses current resource context after locale changes` 筛选。没有扩展为全部组件功能或 Golden 回归。

本轮 APK SHA-256：3.32.0 为 `6f370b63d64ace3b92c151930afdf13d08c3977c1e53ee073834fa5f6103b0f5`；3.47.7 为 `cac3af952dc113dc49a7473fe401459ae8af13ba6a4cd7a288cf70ac4759e303`。日志与验证包保存在本任务工作区的 `artifacts/l10n-cleanup-20261020/`，不纳入源码提交。

结论只覆盖本地 l10n 配置、生成结果、语言切换和 APK 构建；未提交、未推送，未验证远端 CI、Web/iOS 构建或设备运行。3.47.7 的现有工具链升级预警仍保留，按用户要求不在本轮升级。上轮其他待验收事项仍由 tasks.md 维护。

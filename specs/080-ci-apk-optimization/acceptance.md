# 本地验证记录

## 精简版推送前本地验收（2026-10-20）

已有版本 b467d630ad98a5bd6e23e2d3df9d50174b1dfb8f 已确认推送至 PR #1179。随后在 rss1102/perf/ci-apk-minimal 独立副本中移出版本号重构、两个元数据脚本和 Example 锁文件治理；以下结论记录推送前的本地范围。远端结果按 PR #1179 的实际 head 和检查链接核对。

相对 develop 基线 d0de29e8b902c910c86dca05b46fc8604790d591，8 个非 specs 修改文件按路径排序，以路径、NUL、原始内容拼接的 SHA-256 为 19c061523ed8b32e4e8ab94f689bba52fb969a1bea545fbdaf15cc1a96f912a8。Android 工程只保留 ndkVersion 跟随 Flutter 和 Gradle 8.14 all 改 bin；settings.gradle、version.gradle 与基线相同。

- actionlint 1.7.7 与 git diff --check 通过；预览元数据的正常/预发布版本、发布器字段格式及非法版本/运行编号检查通过。
- Flutter 3.32.0 与 3.47.7 在独立目录执行普通 flutter build apk --release 均成功；没有独立 Example pub get、enforce-lockfile、--no-pub 或 build-number 覆盖。
- aapt 核对两个 APK 的版本均为 1.0.0 / 2026102001，符合恢复后的旧日期方案。3.32.0 包 SHA-256 为 0fdfc96b2a9103b018a7fe16a049295f44e789d45510ff5f67c3eff3ef9a60dd；3.47.7 为 335fac5ce1baa372e14876b0e7de8612932e2dc846f343b717effe3baa40885b。
- 完整日志、包字段与配置指纹保存在任务工作区 artifacts/ci-apk-minimal-20261020/，不纳入代码。

本轮不升级工具链、不修改已推送副本；未重新执行精简版的 Web/iOS、全部测试、远端 CI 或设备安装。以下旧候选记录保留各自边界，不能代替精简版的这些验证。原版本号同日重复、版本文件缺失回退及依赖复现问题转为 tasks.md 的独立事项。

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

## 2026-10-20 文档审计测试提速（本地验证）

基于 0878a075 的独立副本。审计规则保持，新增显式 root/output 的函数入口；每次调用使用独立解析缓存。62 项旧用例全部保留，增加 5 项入口、筛选、同步及状态验证；其中 3 项使用真实 CLI 子进程。

| 验证 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 审计测试修改前 | 62 项通过，293.72 秒 | 未测 |
| 审计测试修改后 | 67 项通过，17.47 秒 | 67 项通过，22.86 秒 |
| CI 原六项工具测试 | 152 项通过，15.63 秒 | 152 项通过，16.74 秒 |
| flutter analyze --no-pub --fatal-infos | 整包，无诊断 | 仅修改的工具和测试，无诊断 |

审计执行 `flutter test --no-pub test/tool/audit_api_docs_test.dart --reporter expanded`；完整回归保持 test-build.yml 的 Test regression tooling 六文件列表。真实包 `dart tool/audit_api_docs.dart --json` 的修改前后输出逐字节一致，370 项声明、0 issues。CLI JSON 成功、文本失败与参数错误的退出码及输出经过验证；脚本从包目录外运行仍正确解析 root。

3.47.7 的最初精简验证副本缺少其他工具检查的测试、Golden 及 workflow 文件，补齐后完整回归通过；没有降低断言或修改 CI 清单。证据位于工作区 `artifacts/pr1179-audit-optimization-20261020/`，包含日志、JSON 对照与源码哈希。

同机单次耗时包含启动与编译，期间有其他验证进程；3.32.0 该样本约减少 94.1%，不是受控性能基准或远端 CI 耗时结论。本次审计重构未重新构建 APK、Web、iOS，未升级工具链。后续按用户授权提交到 PR #1179；本节结果仅代表本地验证，新提交远端 CI 需另行确认。

## 2026-10-20 功能回归并行拆分（仅本地验证）

基于 f50c39d9 的独立副本。test-build.yml 增加 suite 与 SDK 二维矩阵，将原步骤分配给 components/examples/tooling 六个独立 runner；原测试命令逐项核对一致。保留原 test 检查名称作为汇总门禁，等待所有分支，任一失败、取消或跳过都不能通过。一个 SDK 失败时两个汇总检查均失败，不再表示该 SDK 单独的状态。

双 SDK 各在独立 checkout 执行最终矩阵对应的全部命令：57 个组件测试及独立覆盖率检查全部通过（均 >=95%）；公开示例 508 项及内部开关 1 项通过；工具测试 152 项通过；css2token 测试/分析、外部迁移消费者分析/测试及结构/片段检查全部通过。另用两份新 checkout 只执行组件目录 pub get 后运行全部工具检查，同样通过。组件 Flutter pub get 会自动解析 ./example，日志已确认；工具任务不需重复的显式 Example 安装步骤，但片段分析仍需要其依赖。

工作流 actionlint 通过；矩阵条件分配后命令没有遗漏/重复；双 SDK 和原检查名称保持。汇总 shell 的 success/failure/cancelled/skipped 四种上游聚合结果实际执行验证，仅 success 通过。

同一 SDK 本地按入口顺序运行，避免共享工作目录并发写缓存；两个 SDK 各自独立。日志与结果见工作区 artifacts/pr1179-test-split-local-20261020/。本机组件入口分别 339.89/407.14 秒、示例入口 127.97/117.34 秒，只是带其他并行验证负载的样本；未测量 GitHub 并发收益或排队。CNB、Golden、APK、Web、iOS 和工具链未改，本轮未重跑这些平台构建或 Golden；未提交、未推送。

workflow SHA256：`4a570e2f454e245a89172e8e193bc1cef0d32e241540cf5bca1c76d8fcfa230c`。

## 2026-10-20 按组件名固定分两组（仅本地验证）

基于a326c592独立副本。组件名UTF-16编码求和后取模2并加1，固定得到1/2；组件功能与Golden共用同一函数。组件名不变则组号不变，其他组件新增/删除或清单排序不影响其归属。已删除历史耗时表和加权算法，不增加组件分组字段；仍只维护现有清单，不保证耗时均衡。

组件两组27/30个，双SDK各完整运行57个组件，独立覆盖率检查均>=95%。最终工具测试各157项通过，严格分析无诊断。自测核对固定映射、条目变化不重分组、分组完整性、组内顺序、组件/Golden同组及跨组共享首个归属；两个入口非法参数均退出64。临时失败Flutter替身验证各组进程数与失败退出1，未吞掉失败。

Golden先全局按原executionKey去重，再归首个声明组件的固定组：34/43个套件。在两个独立Linux amd64 Ubuntu24.04 / Flutter3.32.0容器中实际比对全部通过；名单与计划逐项一致，共77个唯一套件无遗漏/重复。基线PNG未修改，没有使用更新参数。

CI矩阵、原名称汇总门禁及按组failure artifact保持，actionlint通过；组件4项、示例2项、工具2项和Golden2组。无参数仍完整执行，CNB配置不改。证据见工作区artifacts/pr1179-fixed-shards-local-20261020/，GROUPS.md仅为生成的审阅报告，不是维护配置。

本地组件同SDK按组依次运行，Golden使用模拟amd64的Linux容器，环境不等同GitHub；未测量远端并行收益或实际耗时。未升级工具链、未重建APK/Web/iOS或重复未改动的Example功能入口；未提交、未推送。

## 片段门禁与 API 生成提速（2026-10-20，本地未推送）

双版本 tooling 恢复原 checkout 的片段 --check，并登记 3 项生成调度/真实批处理测试。Node 一次传入任务，Dart 顺序调用原工具包生成器，每个组件新实例。原 CLI 对照与新入口在两个 SDK 上均通过全部 57 份文档字节比较；file 模式及 getComments 开关另以真实 CLI 对照一致。

| Flutter | 原入口全量检查 | 新入口全量检查 |
| --- | ---: | ---: |
| 3.32.0 | 50.12s | 9.35s |
| 3.47.7 | 30.50s | 6.97s |

本机各一次前后运行，未控制其他进程负载，不能外推远端 CI 耗时。双 SDK analyze 0 诊断、原有工具回归各 157 项、新增 Node 测试各 3 项、结构/片段检查全部通过；过期片段退出 1 且不写回；真实生成失败不执行后续任务。两版本无 package_config 冷启动通过（沿用对应 SDK 既有锁文件，不代表全部依赖缓存为空）。actionlint、Node 语法、diff 检查通过。3.32.0 本机峰值 RSS 约 876 MiB。

证据：工作区 artifacts/pr1179-api-generator-local-20261020/REPORT.md 及相邻日志。临时编译原 CLI 的候选因 latest 编译开销而放弃，最终代码只使用单进程批处理。生产组件、工具链、平台配置和 Golden 未改，未重跑 APK/Web/iOS 或全量组件/Golden，未触发远端 CI。以上为推送前本地结果，推送后的 CI 与耗时在 PR 描述中绑定最终 head 和运行链接。

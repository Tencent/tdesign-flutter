# 实施与验证安排

复用资源准备和 APK workflow，保持 Web/APK 并行；只保留 NDK 跟随 SDK、Gradle bin 与缓存相关 Android 改动。

从本轮移出版本号重构、元数据脚本和对应测试、Example 锁文件及所有 enforce-lockfile / latest 删除锁文件分支。预览元数据恢复为经格式校验的组件版本、PR 编号和工作流运行编号，保留现有发布器格式。

在独立 SDK 目录以普通 release 命令重建 APK；检查工作流、元数据格式、生成资源及实际包版本。旧候选的 Web/iOS 验证保留原范围，不外推精简版已完成远端构建。l10n 的双版本生成与语言切换结论仍对应未变化的配置。

## 文档审计测试提速

在原工具中提取 `runApiDocsAudit(args, root:, output:)`，返回退出码；CLI 只负责标准输出和进程退出码适配。测试显式传入临时 fixture 路径与 StringBuffer，复用原有断言，仅 CLI 冒烟用例复制脚本并启动 Dart。风险集中在脚本路径、输出重定向、返回码及重复调用状态，分别用真实 CLI 对照与重复调用验证。双版本功能回归入口保持原样。

## 功能回归并行拆分

按 components、examples、tooling 与 SDK 组织矩阵，组件组选择见下节，复用同一份 checkout/SDK 配置，避免复制三份 setup。组件和工具任务只显式执行组件目录的 pub get；现有 Flutter 会同时自动解析 Example 依赖，满足片段分析需要。示例任务保留原有组件及 Example 准备步骤。tooling 包含 css2token、外部迁移消费者、工具自测及示例结构/片段检查。保留 test 双版本名称并依赖 regression 矩阵，使用 always() 检查全部上游结果，严格要求 success。汇总等待全部 SDK，任一分支失败时两个汇总检查均失败。

风险为测试遗漏、依赖准备不足、分支保护检查名称变化和 runner 并发额度/重复准备开销。验证原命令清单前后完全一致、workflow 语法及门禁的成功/失败/取消/跳过组合；在两个独立 SDK 副本运行全部原入口。CNB 继续使用原集中调度器，本轮不改变其平台配置。GitHub job 并行依赖独立 runner，本地同一副本依次运行入口，避免并发写 Flutter 构建缓存；不把本地耗时当成远端并行测量。

## 组件名固定分组

公共函数 regressionShardForComponent 仅对组件名的 UTF-16 编码求和并按奇偶分组，不使用运行时 hashCode、耗时表、随机数或清单位置。同一个组件的功能测试和 Golden 使用同一组号；不维护第二份组件名单，新增组件只需按现有方式登记测试。删除上一版历史耗时常量和加权分配器。代价是不能保证耗时均衡，后续是否增加组数需另行决策。

组件调度保留每次 Flutter 进程与 coverage.run([component])。视觉调度先保留 executionKey 的首个套件，再按该组件的固定组号选择，避免共享套件跨组重复；默认执行也复用同一去重路径。参数解析、分组并集/交集、共享归属、组内顺序、固定映射、增删组件不重分配及组件/Golden 归属一致均需测试。

修改 workflow include 矩阵为 components 两组、examples/tooling 各一组；Golden 改为两组矩阵与原名称汇总。CNB 继续无参数完整执行。双 SDK 在独立目录跑全部两组组件及工具测试，Golden 使用已有 amd64 Linux Flutter 3.32.0 镜像在各自副本比对，绝不写回基线。容器环境与 GitHub runner 不完全等同，不能推定远端耗时。

## 片段门禁与 API 生成器复用

先补回 tooling 中的 generate_example_code.dart --check。Node 将校验后的源路径、名称、分组、注释选项和输出目录传给单个 Dart 进程；薄适配入口构造与原 CLI 相同的 CommandInfo / SmartCreator 参数并顺序执行，不维护第二份生成规则。通过原 CLI 产物字节对比、跨组件状态、失败中止与临时目录清理验证。临时 AOT 编译方案因 latest 的编译成本导致总耗时增加而未采用，不引入 SDK 版本分支。

## CI 入口与检查完整性

用固定 case 的 Bash 脚本集中维护 tooling 命令。GitHub 选择步骤，CNB 执行全部。工具测试直接执行整目录；组件和 Example 清单与磁盘集合核对，新增文件必须登记，不维护第二份测试清单。用隔离替身验证任意工作目录、步骤选择、参数错误及失败传播，并以真实双 SDK 完整入口验证。

先执行漏测文件；登记后执行受影响组件含覆盖率、完整 Example、tooling 与严格分析。临时篡改生成产物，验证只读检查失败且不写回，恢复后核对哈希。验证 workflow 语法、CNB 引用、共享步骤集合及原门禁；Linux 只对现有 Popup 过滤场景无更新诊断，不改基线。不推送远端。

## 同步 develop

合并 develop `f3ad5064`（含 Spec 归并与 Button/NavBar/Dialog 文字槽回归）。PUBLISH 采用新版发布说明并保留本 PR 的 Demo APK 构建边界；CI Spec 迁入 engineering 并更新索引和引用。保留合并进入的新测试登记、固定分组与共享去重，不额外改生产组件或 Golden。双 SDK 验证 tooling、相关组件、完整 Example 和严格分析；Linux 无更新比对受影响场景。

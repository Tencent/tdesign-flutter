# CI 正确性审查与修复方案（不实施）

## 判断

当前 test-build 确实执行并通过了双版本分析/组件/Demo/独立消费检查、Linux 3.32.0 已登记 Golden 和六个构建组合，矩阵不是空跑。远端实际 latest 为 Flutter 3.47.7，最低为 3.32.0。通过范围是入口实际调度集合，不能写成“磁盘上全部测试、全部状态与正式发布均有保障”。

以下为发布前需要处理的缺口；本次不修改 workflow、测试清单或远端规则。

## P1：正式发布未锁定已验收提交

位置：[auto-release.yml:82](../../.github/workflows/auto-release.yml#L82)、[tag-push.yml:18](../../.github/workflows/tag-push.yml#L18)。

复现顺序：release PR 合并得到 A，随后 develop 又进入 B；merge_tag checkout develop 时可能已经是 B，因此 tag 不一定指向 A。即使 tag 指向 A，TAG_PUSH 随后 git merge origin/develop 仍可能将 B 合到 main。只要期间进入新提交，就可能使 release 版本、tag、main/站点来源不一致。

最小修复方案：以已合并 release PR 的 merge_commit_sha 为候选，核对该确切 SHA 的必要检查成功后打 tag；发布构建及同步都只读取该 tag/SHA。main 不能合并执行时最新 develop；若仍需同步，明确保持该已验收提交，或在同步后的确切提交重新验证并保持产物版本一致。增加 release 并发约束、版本/tag 格式过滤、pubspec/tag 一致检查及重复运行的幂等校验。已有同名 tag 指向不同 SHA 时直接失败。

验证：用隔离测试仓库模拟 A 后紧跟 B，断言 tag/包/站点/APK 的 provenance 均指向 A；重复运行不重新打错 tag。此次未创建远端 tag。

## P1：当前分支规则未要求 CI 必须通过

证据：GitHub branches/develop/protection 返回 required_status_checks.contexts=[]、checks=[]；repos/.../rules/branches/develop 返回空列表。当前需要 1 人审批，但 enforce_admins=false。当前配置不能证明上述 test-build job 是合并硬门槛。

最小修复方案：为 develop/release 流程配置必要的 analyze、test、visual、APK/iOS/Web 检查（或一个必需的汇总 job），要求最终 SHA 成功才允许合并；autofix 改 head 后也必须重新满足。若使用路径跳过，汇总检查须区分合法跳过与失败，避免 required check 永久 pending。管理员绕过范围按团队发布权限单独决定；本次不改远端设置。

验证：构造失败测试和旧 head 成功/新 head 未完成两种 PR，均不能通过发布门槛；文档-only 的预期跳过不会意外卡死。

## P1：文件已登记，但两种 Golden 场景未运行

位置：[component_test_manifest.dart:415](../../tdesign-component/tool/component_test_manifest.dart#L415)、[run_visual_regression_test.dart:180](../../tdesign-component/test/tool/run_visual_regression_test.dart#L180)。

t_popup_consumers_golden_test.dart 包含 actionSheet/dialog/drawer 三个场景，唯一登记附带 --plain-name，只执行 drawer。自测只验证该文件在集合中，无法发现文件内部被过滤的两种场景。Spec 055 记录过 actionSheet/dialog 扩展基线差异，尚无当前无更新运行证据；本轮不能断言它们当前仍失败，也不能用已登记 CI 全绿核销。

最小修复方案：在 Linux Flutter 3.32.0 对该文件三个场景无更新运行，核对实际/基线/差异并确定是组件缺陷还是需设计裁定的旧图；完成修复后移除过滤或分别登记三个明确场景。自测从文件存在性推进到实际用例/场景集合和过滤白名单，遗漏必须解释。

验证：三个场景均出现在 CI 日志；删除其中一个场景登记时门禁失败；不得用直接更新基线或放宽容差替代归因。

## P2：三份非视觉功能测试未调度

位置：[component_test_manifest.dart:697](../../tdesign-component/tool/component_test_manifest.dart#L697)、[run_component_regression_test.dart:10](../../tdesign-component/test/tool/run_component_regression_test.dart#L10)。

未进入组件清单，也未被其他入口或测试文件引用：

- test/components/loading/t_activity_indicator_test.dart
- test/components/loading/t_circle_indicator_test.dart
- test/components/misc/t_small_files_test.dart

本轮本地 Flutter 3.32.0 对这三份文件执行 flutter test --no-pub，20 项全部通过（exit 0）。这证明漏调度而非当前已发现的功能失败；此前“全部组件回归通过”仅指已登记集合。

最小修复方案：两个 loading 文件加入 loading 套件；misc 文件按 TFabBounds、DateTimePickerSteps 等实际覆盖对象拆回对应组件或登记共享功能入口。加“磁盘非视觉测试与已登记/明确排除集合”核对，避免今后只检查已登记文件存在。

验证：双版本实际运行这些测试；新增一个未登记普通测试时调度自测失败。此问题应在 1.0 发布前收口。

## P2：build 会覆盖 API 资产，缺少提交内容一致性硬检查

位置：[test-build.yml:196](../../.github/workflows/test-build.yml#L196)。

build 在检查/构建前执行生成 API，不使用 --check，也没有生成前后 git diff 检查。构建成功只能证明重写后的资产能构建，不能保证提交中的说明与源码完全同步。AST 审计擅长签名契约，不能替代全文生成一致性。当前本地正式工具 --check 已过，说明当前资产没有这个实际差异；问题是配置缺少预防门禁。

最小修复方案：依赖解析后运行 node tool/generate_api.mjs --check；autofix 仍负责写入，验证 workflow 只检查最终 head。正式发布记录工具 resolved SHA、SDK 和依赖来源；外部 main 发生变化后不能把旧工具结果当作新产物证明。将生成检查放一个明确 job，可减少六个 build 组合重复生成。

验证：只改一行 API 生成文案而不改源码时 CI 失败；autofix 修复并产生新 head 后检查通过。

## 正式发布校验仍需补齐

仓库当前可见 workflow 没有 pub publish --dry-run/正式包消费门禁；PUBLISH.md 描述 tag 后触发站点/发布，但本仓库配置没有完整展示 pub.dev/CDN 正式上传链，可能由外部系统承接，不能据此声称线上根本没有发布机制。

方案：先确认真实发布系统与责任人，再为确切候选执行 dry-run、版本/tag一致、归档内容/字体资源及独立宿主安装验证；发布后检查 pub.dev、站点、APK 的版本与 SHA/资源哈希。实际上传由正式发布流程执行。不要只因 tag 工作流执行就立即关闭发布任务：当前 close-release-issue 与 main 同步是并列 job，即便同步失败也可能关闭 issue；应依赖成功的完整交付和上线验证。

## 次要文档同步缺口

[autofix.yml:5](../../.github/workflows/autofix.yml#L5) 忽略根目录 *.md；仅修改根 README 的 PR 不会触发其中的 Sync README files。建议把 README 同步检查拆成能响应源 README 的独立检查，或修改过滤规则。验证根 README 单独改动后，包副本和站点副本保持一致。

## 已检查且不列为故障

- build matrix 的 include 确实生成 Android/iOS/Web × 两版本的六个 job，当前均 success。
- CNB 与 GitHub 共用功能清单；CNB 3.32 执行视觉、latest 不执行像素对照，符合仓库环境边界。
- 没有发现容差被放宽或 runner 在失败后吞退出码；真实设备和设计对照本来就不能由 Linux 快照自动证明。
- 不凭第三方 action 标签较新/较旧推断不可用，当前动作有实际成功记录。
- merge_tag checkout 使用 PERSONAL_TOKEN；不能仅因为另一个 action 入参是 GITHUB_TOKEN 就断言 git push 不会触发后续事件。触发行为需按实际认证链确认，参见 [GitHub 官方说明](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow)。

## 推荐修复顺序

先锁发布 SHA 并设置必需检查，再补两类漏调度与生成 --check；将正式打包/交付验证接入同一发布候选。每项修复作为独立可验证改动，不扩大组件 API 或直接更新 Golden。

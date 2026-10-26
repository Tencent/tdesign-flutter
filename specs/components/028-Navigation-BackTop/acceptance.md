# BackTop 验证范围与结论

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | `f3e14c43`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

- 浏览器连接器的安全策略拒绝访问本机 `127.0.0.1` Demo，因此没有把 Web
  实际浏览器点击冒充为已完成；Web release 构建、真实 Widget 滚动交互和 Linux
  Golden 已通过。
- iOS 真机未验证；移动端操作验收以 Xiaomi Android 16 设备 `40302eeb` 为准。
- Figma 只提供浅色移动端画板，Flutter 深色主题是基于语义 Token 的扩展；系统状态栏也不在 Flutter Golden 边界内。两项差异均已在 `visual-comparison.md` 明示，并须由真机截图补证。
- GitHub PR #1079 在完整验收前已创建；本记录明确纠正交付顺序。最终真机、双 SDK、覆盖率与生成检查现已完成，仍须更新该 PR，并在 CNB 独立创建 PR、完成 CodeBuddy Review 后才可签收。

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。

## 1.0.1 backtop-completed 独立候选（2026-10-23）

- 基线 develop `071efaba0111d868efe0b6a7ce55f6f784069a62`；分支 `rss1102/feat/backtop-completed-1.0.1`，直接基于基线，不依赖其他修复分支。只包含本组源码、已登记回归、生成 API 与 Spec；不纳入后续 API 兼容别名/废弃迁移。
- macOS arm64；Flutter 3.32.0 / 3.47.7（官方 stable ref `abaf9c523780a608bd46686fd5e53740a07077f8` 与已安装高版本一致）。两 SDK 使用独立依赖解析、构建目录，分别离线解析组件包与 Example 的依赖。锁文件指纹保存在[验证数据](evidence/1.0.1-independent.json)。
- 变更的生产源码、测试及生成 API 按排序路径/NUL/文件字节 SHA-256：`07f22f96192a3f014bf924cf7e971ec4bed9c43ac906e76b980949a9916220dd`；其相对基线的二进制 diff SHA-256：`f2ae5e9659ca290448790be2b62423ebcf462a0fa2f4f9c2e29e1199cc7dfba3`。双版本相关输入逐文件一致。验收文案和证据文件不纳入自引用指纹。
- 每 SDK：本组 manifest 中 3 个组件文件共 68 项通过；1 个 Example 文件共 3 项通过；三份调度器自测 30 项通过。严格 analyze 零诊断；API 生成并检查 57 份；示例片段 --check 通过。未沿用旧总补丁计数。
- 本组件生产覆盖率：3.32.0 263/267 = 98.50%；3.47.7 263/267 = 98.50%，均通过 95% 门禁。范围来自 manifest coverageTargets，数据按本组功能测试合并运行后分别过滤，不混入 Demo 或其他组件。
- 入口：在 tdesign-component 中分别用各 SDK 执行 `flutter test --no-pub --coverage --reporter expanded <manifest.componentTests>`、`dart run tool/check_component_coverage.dart backtop`、`flutter analyze --no-pub --fatal-infos`；调度器自测为 check_component_coverage_test / run_component_regression_test / run_visual_regression_test 三个 test/tool 文件。Example 使用 `flutter test --no-pub --exclude-tags golden --dart-define=TDESIGN_DEMO_TEST_MODULES=false <manifest.exampleTests>`。清单的实际文件集及日志摘要见验证数据。
- API 通过 AST 对比旧公开构造参数、属性、方法签名和默认值；仅 BackTop 允许新增可选 onCompleted。新测试均在原 manifest 登记的文件内，GitHub test-build.yml 调用公共组件和 Example runner，三份调度器自测确认清单一致。
- 最终 Review 通过，无阻塞问题。onCompleted 是唯一新增可选 API，用于表达旧 onPressed 无法保证的成功结果。旧 onPressed 不废弃，启用规则、无 Controller 即时通知与动画 Future 结束后通知不变。仅按完成时原 Controller/原位置/到顶/挂载状态判断；同帧、跨帧重绑及临时更换后恢复允许完成，完成时解绑/位置替换/中断/卸载拒绝。成功在旧回调副作用前记录，发送前重查身份；两项正式新增回归覆盖旧回调成功后解绑或替换位置。没有逐帧观察、历史计数、观察器或专用 Controller。
- 原始日志、LCOV、锁文件与独立补丁保存在工作区外层 `artifacts/pr1148-independent/04-backtop-completed/`，与本记录的指纹绑定；摘要随分支保留在验证数据中。未执行设备、正式 Linux Golden 或远端 CI；改动不涉及绘制/布局/Theme/字体，未更新图片基线。历史视觉/设备任务继续按原 tasks 保留，不据本次功能验收核销。未推送、创建 PR 或发布。

## 2.0 回调迁移说明的文档检查（2026-10-23）

基于远端候选 `373c92f7919fb7f1c227873e7103a4ac8e4a78d1` 补充 onPressed/onCompleted 的 API 注释、生成文档和迁移计划。去除 dartdoc 后生产文件与该候选一致；没有改变回调时机、完成条件、默认值或绑定规则。Flutter 3.47.7 和 3.32.0 的生成器检查通过，生成的 BackTop API 逐字节一致；低版本使用原隔离目录，仅用于本次 BackTop 文档验证。日志为工作区外层 publication/pr1193-api-plan-*.log。只修改文档，未重复运行功能测试或 Golden；之前的测试记录仍绑定原候选，不能外推为新提交完整 CI 已通过。

### 文档字形检查补验

远端 afba79c9 的两版 tooling 均为 170 passed / 1 failed，失败项为共享字体的源码字形覆盖检查：扫描包含 dartdoc，将注释新增的“史”“废”计入字体要求。已用同义措辞保留回调说明，未修改字体清单、字体资源或测试规则。两版 API 生成/检查通过，run_visual_regression_test.dart 各 14 项通过，包含实际失败的字形检查；本地结果不代替后续远端 CI。此前仅运行生成器未覆盖此约束，已补充本项验证。

### 回调文档统一中文

基于候选 `6ccb9900a67d43e2c33826ae003aa8efc9c578d6`，将 onPressed/onCompleted 的说明统一为中文，保留全部触发条件、完成时绑定检查、调用顺序及 2.0 迁移计划。去除 dartdoc 后生产代码逐字一致。Flutter 3.32.0 / 3.47.7 文档生成及一致性检查通过，BackTop API 产物相同；字体覆盖相关测试 run_visual_regression_test.dart 两版各 14 项通过。没有修改字体清单、字体资源、测试规则或运行行为；新提交完整 CI 由远端执行，本记录不代替其结果。日志见工作区外层 publication/pr1193-cn-doc-*.log。

### 回调注释精简检查

基于候选 `fe1c15e284bba8f0ac3b500d9df90535a6351542` 按已确认版本精简两个回调的中文说明，仅保留关键使用契约与 2.0 计划。执行代码及 spec.md 的边界说明原文均未改变。Flutter 3.32.0 / 3.47.7 的 API 生成和一致性检查通过，BackTop 生成内容相同；字体覆盖相关测试两版各 14 项通过。原始日志见工作区外层 publication/pr1193-concise-doc-*.log。未重复运行功能测试或 Golden，新提交完整 CI 由远端执行。

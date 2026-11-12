# Theme 验证范围与证据

<a id="source-048"></a>
<a id="source-051"></a>
<a id="source-055"></a>
<a id="source-078"></a>
<a id="source-053"></a>
<a id="source-054"></a>

## 验证范围与本次边界

本次只验证结构、引用、数据格式与工具路径，不重新执行组件、Golden、设备或发布验收。原证据的日期、源码指纹、SDK 与未决状态保持原有范围。

<a id="token-runtime-verification"></a>

## Token 运行验证契约

<a id="source-047"></a>
<a id="source-059"></a>
<a id="source-060"></a>
<a id="source-077"></a>
<a id="source-079"></a>

### 目标与证据边界

补齐 Token 从冻结参考源、全局 Token、组件 Theme、实例覆盖到真实 Widget/布局/绘制的消费证据；默认同值不等于动态回退正确，源码映射或 getter 通过不等于实际渲染正确。

### 行为契约

- 每项区分：默认值已验证、Token/Theme/实例覆盖已验证、实际差异、目标歧义、未实现能力、设计/跨端视觉待验证。发现差异不把当前值写成期望值来消除失败。
- 运行断言检查真实Widget/布局/绘制输入，不能只检查getter、源码文字或行覆盖率。
- 原始小程序声明值与实际消费状态分开；例如Less中的2dp边框须追到实际绘制表达式，不能机械换算。
- 在现有已调度组件测试内扩展有缺口的场景，保持CI配置与调度清单不变。双SDK执行受影响功能检查与严格分析；本机macOS不生成或更新Golden。
- 证据绑定源码指纹、SDK、依赖和可重跑命令。finalPaintVerified只在对应视觉证据充分时更新，不把运行路径通过冒称像素已对齐。

### 证据组织

- `evidence/token-source/`：冻结源声明、Token 对照表与差异清单。
- `evidence/consumption/`：组件消费队列、映射与审查结果。
- `evidence/runtime/`：实际运行观察、源定位与可重跑命令。
- `evidence/differences/`：已发现差异的规则与处置结果，不把旧候选补丁视为已实施。
- `evidence/design/`：组件详情页、设计映射、实际消费及视觉审查依据。
- `evidence/defaults/`：已确认默认值变更及覆盖优先级的验证依据。
- 证据维护边界见 [证据说明](./evidence/README.md)：保留历史快照，不再维护专项生成脚本。

这些文件是有日期、源码指纹和 SDK 边界的证据快照。本次只迁移路径，不重新运行、不刷新哈希或把历史状态改为当前通过；迁移后重新运行的证据应另行绑定新候选。历史 PR 拆分和补丁草案不再作为独立 Spec。

### 验收要求

逐项区分默认值、全局 Token 回退、组件 Theme、实例覆盖、插值、设计差异、未实现能力和缺失证据；保留未决项。功能、Golden、设计和设备分别留证，禁止批量勾选或更改期望值消除差异。

## 运行结果入口

本轮只验证文档收敛、文件引用、数据格式和工具语法；未重新执行组件功能、Golden、设备或远端发布验证，不能据此宣称这些门槛通过。

实际运行观察与待验证项见 [运行报告](./evidence/runtime/runtime-review.md) 和 [差异处置](./evidence/differences/solutions.md)。证据保留原日期、源码指纹与 SDK 边界；路径迁移不刷新验收结论。

## 未完成事项

实现与运行验证待办统一见 [tasks.md](./tasks.md)；不将历史源码指纹或已迁移报告认定为新候选通过。

## 历史验证检查点

以下为已有记录的摘要，本次未重跑，也未重新查询 PR、CI 或合并状态。不同检查点不能拼接为当前候选通过。

| 检查点 / 证据身份 | 已记录范围 | 原始数据与边界 |
| --- | --- | --- |
| 2026-10-17，783aeaab8b6c4b113fdfcda1d508cdda1611d320，相对 3774df7de9647cf261fb0ec63062e0b363b23bcd | 3.32.0 / 3.47.7 各 565 项相关功能、115 项页面检查，四组覆盖率≥95%，严格分析与 API 审计；98 张 Golden 的哈希/差异归因审阅 | [源指纹、命令与结果](./evidence/design/pr-review-results.json)、[Golden 清单](./evidence/design/ci-golden-review.json)。本轮未改基线；未取得的 7 页及 Table 设计绑定不由这些结果补齐 |
| b374adc29503907bd51724c202d14eb3c8b44ab0 恢复检查点 | 原恢复点双 SDK 功能与页面结果 | [结果](./evidence/defaults/results.json)。仅属于恢复点，其旧远端待办不代表当前状态 |
| 后续 nullable 插值复核，源码指纹以数据文件为准 | 17 项新增回归、双 SDK 各 512 项组件 / 157 项页面检查、八组覆盖率>95%；25 组 Linux 3.32 无更新视觉比较 | [复核结果](./evidence/defaults/review-results.json)、[独立 CI 登记复核](./evidence/defaults/ci-registration-results.json)。不外推到随后字体和 Golden 补充 |
| 2026-10-19 字体与默认值 Golden 补充，基于 f5d8df2f2bc43224406319b4944930454458930c，原检查点 ca5c7c61379e9ef850b7cc6866089d4d90468f6b | 原 98 张中 2 张 BackTop 字体基线替换，新增 6 张 Cell/Tabs，共 104 张变更；8 项授权更新后无更新比较通过 | [图片哈希、场景、环境与验证](./evidence/defaults/golden-completion-results.json)。保留 Linux 3.32/DPR1 与字体范围，非 57 页全状态视觉覆盖 |

PR 拆分、重放、分支切换与重复推送记录已移除。影响最终实现的插值原因、配置优先级和视觉取舍并入 [设计说明](./spec.md#关键决策与取舍)。候选发布门槛仍由 [Release](../057-Release-readiness/readiness.md) 维护。

## 自定义文字槽统一验收（2026-10-22）

<a id="1184-合并验收2026-10-22"></a>

### 范围与最终取舍

#1182 的既有槽位漏接、Drawer 标题段落保留及 Popover 测量修复已进入 develop `077045a1`；#1184 在其上统一六类自定义文字槽，并让 TabBar 自定义菜单按实际内容等高布局。保留全局 TText 隔离、显式字段与内部更近主题优先，以及原生段落边界；按已确认的 patch 发布策略交付，同时保留默认外观变化和迁移风险说明。

### 已交付候选

#1184 `6a3075946`（生产输入与 `7b40eaa8` 一致）：Flutter 3.32.0 / 3.47.7 各 1,472 项组件/共享/清单测试、85 项页面测试通过，14 组覆盖率均达 95%，严格分析、57 份 API、6 份同步文档和示例片段检查通过。Linux 3.32.0 的 19 个受影响视觉套件共 217 项通过，含 Popover 50 项；该集合未覆盖本轮新增的 TabBar 自定义菜单专项 Golden。

已确认并接纳 Popover 自定义菜单明暗两张基线：字距0.25→0，文字盒23→22，菜单单项47→46，外框150×146不变；原差异为1,848/1,853像素。其他既有基线未改。三阶段专项渲染各10组无布局异常：Popover 保留原生单行弹层300×120→300×48的修复，最终默认 TText 接入16/24与气泡文字色；4组 Toolbar 与 develop 零像素差。

该提交[验收 CI](https://github.com/Tencent/tdesign-flutter/actions/runs/39763948282)与[预览](https://github.com/Tencent/tdesign-flutter/actions/runs/39763948250)完成，30项成功、1项条件跳过；autofix 未改变 head。此结果只绑定已交付提交，不外推到后续本地候选。截图单独在 PR 审阅资源中托管，不存 Spec。

### 保留的专项证据

#1182 曾以 develop `e02efbac` 为基点完成双版本各966项组件/共享/清单、54项页面、10组覆盖率及48组明暗前后对照；范围包含已有槽位漏接、Drawer 标题段落与 Popover 测量，不能缩成仅上述两个组件。

自定义文字槽候选的156组前后对照中，82组发生预期变化，24组完整显式样式/内部局部主题对照零像素差；输入摘要为 `269fa926180aa70275998214a16e2a173b97055e3a740e51226082928e068509`。这些是兼容性边界证据，不表示所有业务内容无变化；执行流水由 Git 历史追溯，不重复登记推送过程。

### Review 收口验收

基于 `6a3075946` 的独立本地分支，新增 TabBar 自定义菜单8张明暗 Golden，将 Picker/Steps/TabBar 完全相同的测试辅助代码提取到共享 helper，收敛过期交付表述及重复验收记录；不修改组件生产 Dart、正式 Demo、工具链或已有 Golden PNG。验证输入摘要：`6b44a3403ed3be5b3de2b16f2cfb4cd89249c88a9ed57f03f8d2d7edb5dbc686`。Flutter 3.32.0 / 3.47.7 各378项相关组件/共享/清单测试、25项页面测试通过；新增基线齐备后各30项清单自测再次通过，严格分析无诊断。Picker/Steps/TabBar 覆盖率分别97.57%/99.25%/97.17%，双版本均达到95%门槛；示例片段与6份同步文档检查通过。

固定 Linux Flutter 3.32.0 的4个受影响视觉套件共49项无更新比较通过，新增文件的6项测试覆盖8张截图。8张新图均与预先审阅的实际渲染零像素差，原有683张 Golden PNG 哈希全部不变；共享 helper 提取本身净减少298行测试代码，场景和断言保留。所有组件生产 Dart 均未改，未重跑无关平台构建或完整19套视觉矩阵。

### 未覆盖范围

本节记录本地验证；交付后的远端 CI 必须绑定最终 head，不能沿用此前已交付提交的结论。未新增设备安装、前台运行或完整设计逐项验收；组件原有真实待办仍在各自 tasks 中保留。正式 Popover Demo 的主题说明调整仍在另一独立本地分支，未混入本候选。

## Drawer / TabBar 旧 implements 兼容验收（2026-10-26）

### 候选与结论

本节独立于上文历史验收。基于 develop `058ac453bc4bf5974ee9e69fef1150de8e156c0b`，本地分支 `rss1102/fix/theme-resolver-implements-compat`；仅修改两个 ThemeData 的内部解析、相关测试与本 Spec，不修改现有 FAQ 工作区；本节记录推送前的本地验收。

五个 `@internal` 解析方法移至不经公开 barrel 导出的命名 extension，计算由同文件私有函数完成；类内不再声明这些解析成员或私有过渡 getter。`copyWith` / `lerp` 只从库内插值对象安全读取过渡状态，旧 `implements` 作为普通公开字段来源参与插值。构造、字段、方法参数、默认值和优先级未改；组件、Controller、回调及生命周期实现均未改。

双 SDK 的源码、测试、工具及生成资源共 2327 个文件逐字节一致，清单 `input-manifest.json` 的 SHA-256 为 `39d15dd9e871c27728967ff6d3a7ff7186ad4847c1e7cc5e8c6956f0d5b71361`。完整日志和输入清单位于本地工作区 `artifacts/theme-resolver-compat/`，不进入仓库；验收后的仅 Spec 文字整理不改变测试输入。

### 正式回归与调度

- 包外消费者：`test/tool/theme_implements_consumer_test.dart` 分析仅实现 1.0.0 成员的真实类，不使用 `noSuchMethod`；验证公开包不暴露五个内部桥接方法。修复前同一消费者明确报 Drawer 缺少四个成员、TabBar 缺少一个成员，修复后两版本均零诊断。
- 运行回归：`test/theme/theme_implements_compatibility_test.dart` 的 15 项测试覆盖原生/旧实现四种端点组合、双向插值、null、copyWith 保留/覆盖、实时 fallback、LTR/RTL padding、实际组件 Token 更新、AnimatedTheme 动画中断和最终值；原有 Token/组件测试保留，仅内部测试增加直接导入。
- 新运行测试已加入 Drawer 与 TabBar 的 `component_test_manifest.dart`；GitHub / CNB 既有组件调度器读取该清单。包外编译测试由两端既有 `scripts/run-tooling-checks.sh tool-tests` 的 `test/tool` 发现，无需新增工作流。

| 验证项 | Flutter 3.32.0 / Dart 3.8.0 | Flutter 3.47.7 / Dart 3.13.5 |
| --- | --- | --- |
| Drawer 正式清单（含新运行测试） | 116 通过 | 116 通过 |
| TabBar 正式清单（含新运行测试） | 138 通过 | 138 通过 |
| 两组件、共享 Token 与全部 tool 测试合并运行 | 432 通过 | 432 通过 |
| Drawer 生产行覆盖率，单独清单 | 287/299，95.99% | 287/299，95.99% |
| TabBar 生产行覆盖率，单独清单 | 676/683，98.98% | 676/683，98.98% |
| 严格分析 `flutter analyze --no-pub --fatal-infos` | 零诊断 | 零诊断 |
| Drawer/TabBar 示例及 API 展示 | 87 通过 | 87 通过 |
| API 生成 `node tool/generate_api.mjs --check` | 57 份一致 | 57 份一致 |
| 示例生成 `dart run tool/generate_example_code.dart --check` | 通过，无产物变化 | 通过，无产物变化 |

上述运行有重叠，不相加作为独立用例数。全部 tool 测试包含字体覆盖与回归调度自测。示例使用正式入口参数 `--exclude-tags golden --dart-define=TDESIGN_DEMO_TEST_MODULES=false`；初次遗漏该开关时内部调试模块影响了菜单位置和代码入口数量，按正式参数复跑通过，未修改示例或断言。首次新增测试曾错误要求代理实现保持对象身份，已改为核对其既有委托结果；没有为测试更改生产行为。

复跑：组件目录下分别运行清单中 Drawer/TabBar 的 `componentTests`，添加 `--coverage --exclude-tags demo`，再运行 `dart run tool/check_component_coverage.dart drawer` 或 `tab_bar`；共享检查为 `flutter test --no-pub test/theme/token_default_transition_test.dart test/tool`。示例目录下运行 `flutter test --no-pub --exclude-tags golden --dart-define=TDESIGN_DEMO_TEST_MODULES=false test/drawer/drawer_demo_test.dart test/tab_bar/tab_bar_demo_test.dart test/api_docs_test.dart`。每个 SDK 使用独立依赖目录；SDK revision 与原始结果另存于本地证据目录。

### 最终 Review 与风险

复查移出成员、延迟解析优先级、copyWith 状态保留、正反/中断 lerp、旧消费者实际渲染及公开导出，未发现阻塞问题。没有新增缓存、观察器、宿主或 Controller 契约；不改变 Token 的值、主题插值公式或默认布局。

相对 1.0.0 的这两个 ThemeData 公共接口是兼容性修复，既有 implements 无需新增内部成员。直接调用 develop 新增 `@internal` 类方法的代码不在此兼容承诺内；本修复也不消除其他 PR 的独立 API / implements 风险。外部实现自行覆盖的 `lerp` / `copyWith` 仍由业务负责，本次不代理或重写业务规则。

验证范围是 macOS 本地编译、Widget/工具/文档与布局断言；未执行 Android/iOS 真机、Web release 或 Linux Golden，不外推这些结果。绘制算法与基线未改，不在 macOS 生成或更新 Golden；本节不包含远端 CI 结果，提交 PR 后须按最新 head 另行核对。

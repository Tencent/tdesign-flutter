> 历史快照：本文对应Ghost修复前的Spec059指纹与比较目标。最新32项处置、修复后验证及未实施方案见 [Spec060](../060-token-difference-resolution/acceptance.md)。原始观察和机器数据保留，不用旧日志验证新源码。

# 2026-10-15 组件消费证据补齐记录

## 本批结论

原677项已逐条登记目标、冻结源码选择器/属性、当前Flutter名称定位、运行证据或缺口。当前阶段统计见[runtime-review.md](runtime-review.md)，机器可读数据见[runtime-review.json](runtime-review.json)。本批完成证据补核工具及七个组件的首批运行验证，整个677项任务尚未完成。

| 当前阶段 | 数量 |
|---|---:|
| 默认运行已验证，视觉待验收 | 116 |
| 运行差异待处理 | 31 |
| 平台边框几何待裁定 | 1 |
| 冻结源码未找到消费者 | 5 |
| 待补运行证据 | 524 |

原始Spec048静态盘点及Spec058名称定位文件保留为历史基线。这里的阶段状态不把原reviewDecision中的pending直接改为最终通过；finalPaintVerified也未改为true。新增运行验证检查实际Material/Text/布局/绘制输入，仍不等于最终合成像素一致。custom=true为独立改变色板、字号、圆角和间距的测试哨兵，不是建议采用的设计值。

## 冻结目标证据

- 目标为小程序1a1c5ca135b0e9bf19abc43a59870c4908a28ad5，通过该完整SHA的codeload源码归档读取；归档SHA256记入runtime-review.json。
- 初次部分Git克隆遇到远端缺失对象，未用不完整checkout作为证据；编译使用完整冻结归档。
- `node tool/audit_compiled_token_consumption.mjs <冻结小程序根目录>`使用站点锁定的Less4.5.1编译全部213个Less文件，0失败；789项找到CSS渲染属性或自定义属性转发引用，15项在编译CSS及其他源文件中均未找到消费。
- 自定义属性转发也保留为消费候选，例如Switch的loading色经--td-loading-color转给子组件，不能因为它不直接写color就判无消费者。
- 原677项中新增确认5项无冻结消费者：buttonIconSpacer、inputErrorTextColor、inputSuccessTextColor、inputWarningTextColor、progressCircleIconSize。其余10项在原台账已有相同结论；不重复计数。
- [编译证据](compiled-consumption.json)含每个输入文件摘要、输出CSS摘要、选择器、属性和值；编译不证明小程序宿主所有动态CSS路径或Flutter像素。

## 运行验证

在现有已调度的Button、Switch、Input、Link、Avatar、Empty、Progress测试文件内新增46项检查；共享helper只在显式环境变量TDESIGN_TOKEN_EVIDENCE=1时输出结构化观察。没有增加或修改CI调度清单。

- Flutter3.32.0/Dart3.8.0与Flutter3.47.7/Dart3.13.5，严格analyze均0问题。
- 按现有manifest运行上述七组件的16个功能测试文件，排除demo标签，双版本各439项通过。46项新增检查是439项的子集。
- 逐SDK采集1008条观察，涉及150个变量名；其中149个来自原677项，另1个为原已审的switchUncheckedColor。两套观察逐条完全相同。
- 原始样本见[runtime-observations.json](runtime-observations.json)。enforce=false表示尚未裁定的差异诊断，不是已通过断言；这类观察保留实际/比较目标和场景并进入差异队列。未将其写成与当前实现相同的期望值来伪造对齐。
- 初次只运行七个主测试文件时，Switch/Link覆盖率不足；改按已有完整manifest文件集合运行后达标。下表是完整范围的最终结果，未降低阈值或缩小生产源码范围。

| 组件 | LH/LF（两版本相同） | 覆盖率 |
|---|---:|---:|
| Button | 471/474 | 99.37% |
| Switch | 385/401 | 96.01% |
| Input | 321/330 | 97.27% |
| Link | 114/116 | 98.28% |
| Avatar | 281/285 | 98.60% |
| Empty | 33/33 | 100.00% |
| Progress | 646/655 | 98.63% |

两环境的270个相关lib/资源/测试/清单/pubspec文件摘要完全一致；SDK与实际lock摘要分别记录，不能把不同依赖解析组合误称为同一组合。SDK使用可写临时副本，配置写入临时XDG_CONFIG_HOME，没有改用户SDK/配置目录。本轮所有生产源码保持上一轮准备后的内容，未新增生产行为变更；测试和证据工具不涉及Golden更新。

## 可重复检查

1. 在两个隔离、源码一致的工程中分别解析并记录依赖、Flutter/Dart版本；使用当前manifest中上述七组件的全部16个componentTests文件。
2. 运行`flutter analyze --no-pub --fatal-infos`、`flutter test --no-pub --exclude-tags demo --coverage <16个文件>`；分别运行`dart run tool/check_component_coverage.dart <组件名>`核对七组件。
3. 运行`TDESIGN_TOKEN_EVIDENCE=1 flutter test --no-pub --reporter expanded --plain-name 'token consumption' <七个t_*_test.dart主文件>`收集focus-low.log/focus-high.log。
4. 编译冻结Less并保存compiled-consumption.json。将analyze-low/high.log、full-low/high.log、focus-low/high.log、coverage-low/high-组件.log、SDK机器输出sdk-low/high.json、pubspec-high.lock、冻结归档frozen-source.tar.gz及manifest-files.txt存于同一日志目录。
5. 运行`node tool/summarize_component_token_evidence.mjs <日志目录>`。工具校验46项聚焦测试、完整回归、严格分析、各组件95%阈值、双SDK样本一致性，然后输出阶段报告。完整命令/文件集合见[validation-commands.json](validation-commands.json)。
6. 加`--require-complete`执行最终验收检查。本次实际执行返回1，报告672项仍需适用的运行/契约/视觉证据；它不会把439项功能测试通过解释成Token任务全部完成。5项无消费者仅关闭冻结版本适用性审查。

工具记录源码/资源/测试摘要和日志摘要。相关源码、依赖、主题环境或字体变化后，应复验受影响层级，不能只重生成文案沿用旧结果。

## 后续处置

31项差异分组、修复边界及524项后续顺序见[next-batches.md](next-batches.md)。190个尚未运行验证的条目已补充现有测试候选位置，只作为后续人工核对入口，不算运行证据。

本轮未改正式版本号、公开API、生成CHANGELOG、CI/工作流/测试清单、远端规则；未提交、推送、建tag或发布。最终设计/设备/审查仍按Spec048与发布验收表执行。

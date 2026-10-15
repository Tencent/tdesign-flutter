# 2026-10-15 差异处置与验证记录

## 结果

Spec059的31项运行差异及1项平台几何均已给出可审查的处置，见[逐项解决方案](solutions.md)。本轮实施1个确定的Ghost回退修复（对应2个观察项），为8项已有契约支持的差异补断言；其余21项差异及1项平台几何保留具体方案，不冒称已修复。

| 处置 | 项数 | 当前状态 |
|---|---:|---|
| Ghost语义回退已修复 | 2 | 双SDK运行通过，最终视觉仍待验收 |
| 既有Flutter契约支持 | 8 | 现有契约及双SDK运行断言支持，不应按旧CSS变量盲改 |
| 默认视觉/交互方案 | 21 | 逐项列明目标、修改位置、影响和验证；尚未实施 |
| 平台边框几何方案 | 1 | 待目标小程序宿主的实际伪元素几何证据 |

全部677项的最新分层见[resolution-report.json](resolution-report.json)：原116项默认运行通过、2项本轮修复、8项已有契约支持、21项实施方案、1项平台几何、5项无冻结消费者、524项待补运行，合计677。最终像素状态仍未转为通过。

## 已实施修复

默认配色的TButtonVariant.ghost原来读取fontWhite1，导致独立自定义textColorAnti不能控制文字/描边。现在启用态统一读取textColorAnti；禁用仍读取fontWhite4，实例ButtonStyle的前景和边框仍优先。

- [实际代码补丁](implemented-fix.patch)仅修改Button统一解析器的一处回退，未新增公开API或组件Theme字段。
- 新增1项Ghost回归，分别在浅/暗下验证全局语义Token、原始白色层级、禁用及实例样式独立覆盖；检查实际Text前景、Material边框颜色及宽度。
- 原有矩阵中的2项观察改为强制断言；默认主题下textColorAnti与fontWhite1值相等的断言通过。没有宣称自定义主题的变化无需视觉复验。
- 迁移指南增加Ghost自定义反色主题说明，包/站点副本由同步脚本生成；发布说明只补内部草稿，不手改自动CHANGELOG。

## 8项契约差异

不是重新选择一个方便通过的目标；全部有修复前已经存在的契约依据，原始小程序比较继续保存。

- Avatar的4项字号/图标尺寸使用既有尺寸预设，特殊排版由内容Widget/既有Theme表达。依据Spec034、Spec048及TAvatarThemeData.iconSize的公开默认。
- Avatar组描边回退bgColorContainer，依据公开groupBorderColor契约；此前Spec034已记录明暗头像组设计验收，未恢复固定白色。
- Empty描述间距图标/图片分别22/16，操作间距固定32，依据Spec031的直接设计契约。
- 独立Input的contentPadding默认固定16，FormItem作用域为0，依据公开dartdoc及已有组合规则。

每项新增contract/场景的强制运行断言，覆盖浅/暗与自定义全局值；旧目标的原始不匹配仍在beforeExamples/afterRawComparisons中，新契约证据单独记录为currentContractWitnesses。没有把finalPaintVerified设为true。

## 主工作区验证

| 检查 | Flutter3.32.0/Dart3.8.0 | Flutter3.47.7/Dart3.13.5 |
|---|---|---|
| 严格analyze，含info | 0问题 | 0问题 |
| 七组件现有manifest全部16个功能文件 | 440项通过 | 440项通过 |
| 聚焦token consumption检查（440的子集） | 47项通过 | 47项通过 |
| 仓库外独立迁移consumer | 严格分析及21项通过 | 严格分析及21项通过 |
| 组件生产行覆盖率 | 全部≥95% | 全部≥95% |

覆盖率两版本相同：Button471/474=99.37%，Switch385/401=96.01%，Input321/330=97.27%，Link114/116=98.28%，Avatar281/285=98.60%，Empty33/33=100%，Progress646/655=98.63%。阈值和源码范围没有降低。

每SDK采集1076条观察，逐条相同；270个相关源码/资源/测试/清单/pubspec文件在测试前后及两环境间一致，实际依赖锁分别记录。较新SDK的独立迁移首次因用户缓存active_roots写入受限失败，换独立临时缓存后解析、严格分析和21项测试通过；原始失败没有冒充通过。

[验证器](../../tool/verify_token_difference_resolutions.mjs)检查前后源码/依赖快照、双SDK一致性、全部运行/覆盖率日志、原32项完整映射、已有契约引用及强制断言，生成本轮机器记录。运行命令和日志文件约定见[validation-commands.json](validation-commands.json)。Spec059保持修复前快照，不用旧日志给新源码背书。

## 四项未应用的视觉修复候选

[候选补丁](proposed-visual-fixes.patch)包含：默认填充按压背景bgColorComponentActive、浅色填充按压背景brandColorLightActive、Switch关闭内容色bgColorSecondaryContainerActive、Input正常分隔线componentStroke；Switch dartdoc随候选同步。

- 对当前主工作区git apply --check通过，补丁没有应用到主工作区。
- 在源码/依赖固定的隔离工程、Flutter3.47.7运行47项聚焦检查通过；4项对应20条目标观察全部匹配。除了补丁的4个文件，其余验证输入与主工作区相同，运行前后快照一致。
- 这是方案可编译且聚焦行为可复现的证据，不是完整回归或正式验收。候选尚缺低SDK、完整相关回归、目标设计及Linux受影响Golden；需根据实际按压状态层合成结果决定是否采用。
- 其余按钮危险色/语义优先级/Ghost状态层以及Switch整体几何方案逐项写在solutions.md，未混入这个最小候选补丁。

## 视觉与发布边界

本机macOS，Docker客户端存在但Linux daemon未运行，当前不能执行规定的Linux3.32 Golden。未在macOS生成、更新或冒充Linux视觉通过。Ghost修复的自定义主题场景和所有拟议默认视觉变化仍须完成适用的设计/视觉验收。

本轮未改CI/工作流、集中测试清单、正式版本、远端规则或Golden；未提交、推送、建tag或发布。524项后续运行审查继续保留，32项处置记录不替代全量1.0放行。

# 2026-10-13 本地边界调整

起点：PR #1157 head `93c1d7479586017618f2e3b0d21818b6cae1a632`。只在已附着 worktree 本地处理，不推送、不评论、不修改远端 PR。acceptance.md 和 tasks.md 保留旧 head 的历史记录，当前验收以本页为准。

## 边界排查与调整

| 入口 | 内置视觉 | 保留的行为或内容主题 |
| --- | --- | --- |
| 共享 Material / Tooltip 内容恢复 | TD glyph 使用 TD Token / Theme / 实例样式 | 普通内容完整恢复原始 IconTheme 的颜色、尺寸、透明度、阴影；Material 内容保留原生正文主题，组件已公开的插槽默认样式继续提供 |
| Button / IconButton | 已解析的插槽文字/图标、尺寸、形状和反馈视觉继续由 TD 控制 | 自定义内容的 Theme 和附近组件主题恢复；原生 enableFeedback、mouseCursor 保留，实例配置优先，普通与渐变按钮一致 |
| Input / Search / Textarea | 完整 TD 文字样式、自有 hint，TextField decoration=null，密度不能改变规格 | 删除编辑器整体 Theme / TextSelectionTheme 重置；选择高亮、手柄、键盘、控制器、焦点继续走原生能力 |
| TText | TD 排版和 glyph 所有权保持 | 不覆盖原生默认选择颜色；实例 selectionColor 优先 |
| Tooltip | 内部局部视觉边界保持 | 保留触发模式、显示/退出/等待时长、反馈及无障碍设置 |
| Slider / ListTile / Divider / Progress | 保留局部样式解析与规格，不恢复 Material 组件视觉覆盖 | 原生控件实现与现有回调保持；ListTile 自定义 leading/header 恢复调用方主题 |
| TMaterialThemeBuilder | 继续单向投影 TD Token 到 Material Widget | 保留用户自定义内容和原生能力，不把 M3 能力整体禁用 |

Button.style.visualDensity 仍按已接受的决策忽略，使用标准密度；受支持的 size / padding / 宽高定制保留。外部 Material 组件视觉主题仍不是 TD 定制入口，原有 breaking 迁移结论有效。本次修正不新增公开 API。

## 任务

- [x] 修复自定义内容图标/字体主题恢复及回归
- [x] 移除编辑器与原生选择主题的过度隔离
- [x] 保留 Tooltip、反馈和 mouseCursor 原生能力，核对显式 TD 配置
- [x] 同步规范、dartdoc 与生成文档
- [x] 双版本完整回归、严格 analyze 与覆盖率
- [x] Linux Golden 有意差异验收与无更新复跑

## 此前边界调整的双版本验证

| 验证 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 完整组件回归 | 57 组 / 2,820 项通过 | 57 组 / 2,820 项通过 |
| 工具回归 | 155 项通过 | 155 项通过 |
| Demo 功能回归 | 365 项通过 | 365 项通过 |
| 最后补跑 Button / Theme | 239 项通过 | 239 项通过 |
| 组件 / Demo analyze --fatal-infos | 零诊断 | 零诊断 |
| 所有登记的生产源码覆盖率 | 最低 95.55% | 最低 95.55% |
| 最终 Button / Theme 覆盖率 | 96.52% / 98.12% | 96.52% / 97.26% |

latest SDK SHA 为 `abaf9c523780a608bd46686fd5e53740a07077f8`，与本次查询 Flutter stable ref 相同。新版 InputDecorationTheme 附近覆盖专项 1 项、Search light/dark 运行交互 2 项通过。新增回归核对实际图标尺寸/透明度/阴影、原始主题动态更新、TD 内置视觉、原生选择颜色、实例 selectionColor、键盘提交、Tooltip 触发和反馈；同时核对 Material 视觉覆盖仍被阻止。

API --check 验证 57 份生成文档；Demo 结构验证 60 个入口与 370 个公开 ExampleItem，代码片段审计 370 项通过。生成产物仅由 dartdoc 源码变化更新。

日志保存在 `/private/tmp/td-1157-local-*.log`。组件完整回归日志逐组记录生产源码 LH/LF；普通与渐变按钮最后统一行为后补跑 Button/Theme 239 项并重新验证覆盖率。

## Golden

Linux Flutter 3.32.0 初次完整对比只有新增 `m3_custom_content.png` 缺基线，全部既有截图通过。只为新场景生成基线并逐图检查：左为 M2，右为 M3，自定义内容保留绿色 64dp 图标及紫色 28dp 文字；TD 图标使用 24dp，TD 文字保持自有排版。自定义内容的原生文字行高可随其主题变化，这不改变 TD glyph 自身规格。

随后不带 `--update-goldens` 全量复跑：75 个登记入口，去重后 74 组实际执行，669 项测试全部通过，未调整容差。逐文件哈希确认现有 807 张基线未变化，本次只新增 1 张基线。源码与 latest/Linux 验证副本逐文件哈希一致。

截图：[m3_custom_content.png](../../tdesign-component/test/components/theme/goldens/m3_custom_content.png)。

完整视觉日志：

- `/private/tmp/td-style-ownership-linux/linux-local-visual-compare.log`
- `/private/tmp/td-style-ownership-linux/linux-local-theme-update.log`
- `/private/tmp/td-style-ownership-linux/linux-local-visual-verify.log`

## 交付状态

所有调整仅保留在 PR worktree 的本地未提交改动；未推送、未更新远端 PR、未新增远端 CI 结论。最终源码严格 analyze 为零诊断，`git diff --check` 通过。

## 复审后的四项修复

此前通过的注册回归与 Golden 不覆盖本次新复现边界，当前最终验收以下列修复及新验证为准。

- [x] Cell 必填标记的完整 TD 文字默认值，保留 requiredStyle 与自定义内容主题
- [x] Divider 内容默认文字样式解析，保留 TD Theme 与 child 显式样式
- [x] Button 属性按状态回退 TD 默认值，保留渐变背景有意空值
- [x] 按状态保留原生 mouseCursor 主题回退
- [x] 最终双版本、覆盖率、Golden 验证与再次 Review

### 四项修复的最终验收（2026-10-13）

- [x] Cell：必填标记使用完整 TD 文字解析；requiredStyle 和标题自定义主题保留。
- [x] Divider：默认文案字号、字距、词距、阴影与 Material 正文隔离；TD Theme 和 child 显式样式保留。
- [x] Button / InternalIconButton：实例状态属性仅覆盖非空值，缺省状态回退 TD 默认；显式透明色、无边框及渐变背景有意空值保留。
- [x] mouseCursor：按状态使用实例、原生主题、原生默认值；普通、渐变和图标按钮均覆盖。
- [x] 关联修复：普通按钮 layer builder 延后到挂载时恢复原主题，防止外部正文重新覆盖 TD 插槽文字；保留回调原始主题、显式图层和图标默认值。
- [x] 最终双版本、覆盖率、Golden 与再次 Review。

| 最终门禁 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 冻结源码完整组件回归 | 57 组 / 2,838 项通过 | 57 组 / 2,838 项通过 |
| 工具回归 | 155 项通过 | 155 项通过 |
| Demo 功能回归 | 365 项通过 | 365 项通过 |
| 组件 / Demo analyze --fatal-infos | 零诊断 | 零诊断 |
| 生产源码最低覆盖率 | 95.55% | 95.55% |
| Button / Theme 覆盖率 | 99.15% / 98.22% | 99.15% / 97.41% |
| 上次 Review 四个独立复现探针 | 4 项通过 | 4 项通过 |

首次组件门禁发现 Button 覆盖率 94.69%。状态回退归并到解析层后，渐变分支原来的空值默认路径不再可达；删除重复默认值并补充原生 layer builder 实际主题/文字/图标测试后，冻结源码两版完整门禁直接通过。中间失败日志保留，不用补跑结果替代最终全量门禁。

Linux Flutter 3.32.0 首轮全量比较仅有 Cell 8 张、Divider 2 张预期差异以及新增场景缺基线。逐图检查确认 Cell 只改变必填星号的 TD 排版，Divider 只改变默认文字字距及随文案宽度调整的分割线。只更新这 10 张并新增下列 2 张，不调整容差：

- [默认排版与部分状态样式](../../tdesign-component/test/components/theme/goldens/m3_owned_typography.png)
- [按下时显式粉色前景](../../tdesign-component/test/components/theme/goldens/m3_partial_state_pressed.png)

无更新参数全量复跑通过：75 个登记入口，74 组实际执行，670 项测试。新增场景在松开并退出焦点后再次比较默认画面，恢复通过。最终哈希确认除上述 10 张更新与 2 张新增外没有图片变化，本地保存图片与 Linux 验证副本一致。此前的 m3_custom_content.png 仍保持不变。

此处运行基线按 component/test 与 example/test 统计：修复前 607 张，修复后 609 张，其中 597 张既有基线不变。此前“807 张”记录来自包含 Spec Golden 证据图片的哈希集合，并非运行基线数量；其 Spec 图片均未变动。

最终复审未发现新增的 Material 默认视觉泄漏、显式配置或内容主题误伤、原生交互回退问题。检查了状态空值/透明值、普通与渐变分支、原始主题恢复、编辑器原生选择/焦点/键盘及 Tooltip 行为。最后只删除一个随已删重复方法残留的孤立注释，未改变运行逻辑，并重跑双版本严格 analyze。

另记录一项既有非 Material 几何差异：extraSmall outline 普通按钮 28dp，渐变按钮 30dp，M2/M3 与两版 SDK 均相同，来自自绘 ShapeDecoration 的边框内缩。本轮四项修复未改变该既有尺寸；状态回退测试以各分支原有几何作为基准，不据此宣称所有按钮规格已经跨端对齐。

最终日志：

- /private/tmp/td1157-repair-components-final-332.log
- /private/tmp/td1157-repair-components-final-latest.log
- /private/tmp/td1157-repair-tools-{332,latest}.log
- /private/tmp/td1157-repair-demo-{332,latest}.log
- /private/tmp/td1157-repair-analyze-final-{332,latest}.log
- /private/tmp/td1157-repair-demo-analyze-{332,latest}.log
- /private/tmp/td1157-repair-api-check.log（57 份 API 文档检查通过）
- /private/tmp/td1157-review-final-{332,latest}.log
- /private/tmp/td1157-review-geometry-{332,latest}.log
- /private/tmp/td-style-ownership-linux/linux-repair-visual-{compare,update,verify}.log

最终状态：HEAD 仍为 93c1d747，所有改动均本地未提交；没有推送、评论、改写远端 PR 或远端 CI 状态。临时复现文件已移除，测试生成的本地 coverage 已归档到 /private/tmp/td1157-final-coverage-332。

最终 lib Dart 源码指纹：e60ae644a21fe07152df88a000ce1628ab7ccb7733cb5d35a9095f43801486a3；本地、latest 与 Linux 副本一致。

## 渐变尺寸后续修复

上述已知的 30dp / 28dp 差异已修复，且 outline / ghost 其他 size 的相同问题也已消除。本轮最终证据以 [gradient-geometry.md](./gradient-geometry.md) 为准；此前四项记录保留为历史。

# 严格边界本地实施与验收

起点：PR #1157 / 2747c1e92；本地实施阶段不推送，最终交付授权与结果见末节。

## 所有权

- TD 内置配置入口仅为公开实例属性/style、TD ThemeExtension、Token；外部 M2/M3 默认及显式主题不透传。
- 环境亮暗、平台、方向、系统字体缩放和无障碍继续响应。自定义 widget/builder 保留调用方主题。
- 内部 Material 编辑、菜单、选择、Tooltip、滚动条、焦点和键盘能力保留，不把隔离实现替换成关闭能力。

## 实施范围

Button/IconButton 的反馈与状态指针；Tooltip 的完整视觉、触发及时长；Input/Search/继承 Input 的 Textarea 的选择颜色、手柄和默认菜单；TText 默认 selectionColor；所有内部 ScrollView 的局部滚动行为；Collapse 对齐；Slider 的版本、overlay 和原有滑块间距/交互默认值；Upload 圆环约束；内部文字投影和 elevation overlay。

ScrollView 使用局部 TInternalScrollScope，内部 chrome 拒绝外部主题，viewport 下恢复原 ScrollConfiguration，使嵌套的调用方滚动视图保持自己的行为。已有实例 physics、Swiper 控制样式、ButtonStyle 各状态显式值、TText.selectionColor 和输入配置保留。

## 验证矩阵

- 功能：全局/附近 Material Theme 的视觉和行为配置无效；显式 TD 及状态回退有效；自定义主题恢复；真实选择/复制、输入提交、滚动、按钮和键盘交互。
- 双版本：Flutter 3.32.0 与 3.47.7 的组件包/Example analyze、全组件覆盖率门禁、工具及 Demo 非 Golden 回归。
- Linux Golden：既有全部登记入口先比较；新增 light/dark 的选择菜单与 Tooltip/高标题场景，外部 M2/M3 共用同一像素基线；仅更新确认的有意差异，然后无更新复跑。

菜单最终运行 review 发现原生按钮的局部 TextStyle 会丢失 TD 字体配置：现保留原生各平台按钮、动作和布局，标签使用 TD 文字解析。实际 RenderParagraph 回归覆盖所有 TargetPlatform 的 23dp 字号、TD 字体族与字距；macOS 悬停文字对比色、单行省略及 iOS Live Text 图标分支保留。

双版本完整 57 组组件及覆盖率、155 项工具、365 项 Example 非 Golden 回归通过。最后菜单标签调整仅影响 Theme/Input/Search/Textarea，已在双版本补跑这些组件和覆盖率；两个包/Example analyze 零诊断。最终 Golden 与逐图 review 结果见下方；历史验收不代替最终源码。

## 最终验证与 review

- Flutter 3.32.0 / 3.47.7 完整 57 组组件功能和生产覆盖率门禁：各 2883 项通过，最低 Indexes 709/742 = 95.55%；工具各 155 项、Example 非 Golden 各 365 项通过。
- 最后菜单标签及暗色提示修正后，双版本 Theme/Input/Search/Textarea 对应清单重新执行：各 182 项通过，组件包及 Example analyze 零诊断。主题覆盖率低版本 750/767 = 97.78%，最新 745/767 = 97.13%；Input 313/324 = 96.60%，Search 194/200 = 97.00%，Textarea 104/105 = 99.05%。
- Linux/amd64 Flutter 3.32：75 个登记入口，去重实际 74 套件 / 684 项，无更新参数全量复跑全部通过。原容差、字体和比较器保持；原有 613 张 PNG 字节哈希全部不变，仅新增 6 张审图通过的 light/dark 提示、选区菜单、桌面滚动条基线。
- 新场景在外部 M2/M3 下匹配同一基线。逐图发现并修正暗色 Tooltip 白字白底及原生图标缺字字体；最终文字可读、实际 MaterialIcons 正常、标题前置内容居中，无观察到裁切。桌面 6dp 滚动条不接受外部 29dp/pink/interactive=false。
- 最终 review 未发现本轮边界内的剩余外部 Material 视觉/行为入口，未发现 TD 显式配置、自定义内容主题或必要原生操作回归。字体实际字号/字体族/字距、Clipboard.setData、macOS 悬停、编辑/滚动/状态回退均有运行断言。
- 平台、亮暗、方向、缩放、语言与无障碍环境保留。原生布局及绘制实现继续由 Flutter 承担，未来 SDK 升级仍执行本门禁；不承诺任意原生算法升级永远零像素变化。

生产 lib 指纹（排序相对路径 + NUL + 文件字节 + NUL，SHA-256）：`ede02ebe560c557f2b1779b9c6cd3a3099c26b097a8f1c2bc80fd7ee824e6e11`。

历史实施阶段：本地 worktree 保留全部修改，当时 HEAD 为 2747c1e92；未提交、未推送、未修改远端 PR。逐图报告位于本地 `td1157-visual-review/strict-boundary.html`。

## 最终 review 补充：内置原生文字选择

最终全量入口审查发现 Steps 序号、Progress 默认百分比、ConfirmDialog/Fab/DropdownMenu/Upload 生成的原生 Text 和内部提示词仍可能从外部 DefaultSelectionStyle 继承高亮色。现仅为这些内置 Text 明确 TD brandColor 的 40% alpha；字体、DefaultTextStyle、原生选择注册和调用方传入文字不变。Progress 默认标签在 build 时读取 Token，继续响应 TD 主题更新，不在 initState 建立主题依赖。

新增 M2/M3 回归读取 SelectionArea 内实际 RenderParagraph.selectionColor，验证各内置文字使用 TD 默认；普通调用方文字保留外部选择主题，按钮自定义文字的显式颜色仍有效。最终受影响清单为 Theme/Input/Search/Textarea/Steps/Progress/Dialog/Fab/DropdownMenu/Upload；双版本和无更新 Golden 结果在提交前核对。

用户最新授权：最终 review 无阻塞问题后提交、推送并更新 PR 标题和完整模板描述。上述“仅本地”是实施阶段历史状态。

### 提交前最终检查点

最终 lib SHA-256（同上算法）：`e14091cd2cbfff980b9128b5047589e08f1c086a07226e38071e7c8ca23d18e4`；与双版本及 Linux Golden 副本 250 个生产源码文件一致。

- Flutter 3.32.0 / 3.47.7 各 10 组 / 530 项最终受影响组件测试通过，analyze 零诊断；所有组生产覆盖率超过 95%（最低 Input 313/324 = 96.60%，Theme 分别 752/769 = 97.79% 与 747/769 = 97.14%）。未受影响清单复用上方成功检查点。
- 无更新参数补跑全部受影响视觉清单：13 个独立套件 / 129 项通过。完整 74 套件 / 684 项的其他结果未受此次只增加选择颜色的修正影响；未更新任何已有或新增 PNG，原有 613 张字节哈希再次核对不变。
- 最终 diff 检查通过。未发现约定范围内的剩余外部 Material 配置入口或 M2/M3 主题默认依赖；TD 显式配置、调用方内容主题、实际原生编辑/复制、滚动、焦点、平台菜单和语义能力保持。此结论不替代未来 Flutter 算法升级的运行验证。

按最新用户授权提交并推送本次全部本地修正，PR 描述改为严格视觉与行为配置边界，完整保留模板。新 head 的远端 CI 独立确认，不复用旧提交绿灯。

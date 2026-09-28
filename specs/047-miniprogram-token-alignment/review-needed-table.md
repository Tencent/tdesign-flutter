# Token 待审查项（精简）

基准：`tdesign-miniprogram/develop@1a1c5ca135b0e9bf19abc43a59870c4908a28ad5`，对照当前 Flutter 工作区。这里只列**已发现的值差**、**语义选择**和**无法用静态数值证明等价的表达差异**；普通同名同值项不列入。详细原始行见[全局 Token 表](./global-token-table.md)和[组件变量表](./component-token-table.md)。

| 优先级 | 项目及范围 | 当前事实 / 疑点 | 下一步与判断人 | 状态 |
| --- | --- | --- | --- | --- |
| P0 | 暗色 `bgColorSpecialComponent`（1 项） | 小程序 `_dark.less:136` 为 `transparent`；Flutter 暗色现显式解析为透明。 | 已用暗色 Theme 测试和审计脚本验证。 | 已修复，无值差 |
| P1 | `radiusCircle` 与组件圆角 | 小程序全局是 CSS `50%`；Flutter 保留固定 `9999dp`，为唯一批准的全局值差。小程序只有圆形 BackTop 使用它；Flutter 半圆 BackTop、TabBar 胶囊使用 `radiusRound`，Indexes 索引项/提示气泡按自身尺寸取圆角。 | 工程侧在 Linux 3.32.0 做无更新 Golden，另以设计稿裁定其他尺寸和颜色。 | 固定半径语义已恢复，视觉待验 |
| P1 | Tag `danger` → 全局 `errorColor`（1 条跨层命名链） | 小程序 `tag.less:12` 的 `--td-tag-danger-color` 回退到 `@error-color`，最终读取 `--td-error-color`；Flutter `TTagColorScheme.danger` 默认也读取 `errorColor`。 | 用户已决定保留小程序的跨层命名，不引入 `dangerColor` 全局别名。 | 已确认保留，非值差 |
| P1 | `sliderDefaultColor`（1 个变量、2 套回退） | `slider.less:12–13` 的默认与禁用值复用同一个 `--td-slider-default-color`；浅色候选 `#e7e7e7` / `#eeeeee`，暗色候选 `#383838` / `#2c2c2c`。实际值取决于使用位置和变量是否被外部定义。 | 先按状态/消费者追踪 Flutter 实际用色，再决定是否需要组件级拆分；不能给它一个虚构的统一默认值。 | 小程序源码歧义，待消费核对 |
| P1 | `tabBarBorderColor`（1 个变量、暗色 2 套回退） | `tab-bar-item.less:8` 与 `tab-bar.less:6` 使用同名变量；浅色均 `#e7e7e7`，暗色分别 `#383838` 与 `#e8e8e8`。 | 分别对比 TabBar、TabBarItem 的边线，保留两个使用场景。 | 小程序源码歧义，待消费核对 |
| P1 | `progressCircleInnerBgColor` 暗色覆盖 | `_components.less` 暗色定义为 `var(--bg-color-page)`，不是已定义的 `--td-bg-color-page`；静态审计无法把它解析成确定颜色。 | 先确认小程序运行时是否由外部定义该 CSS 变量及真实像素，再决定 Flutter 默认值；不根据名称擅改。 | 小程序值未解析 |
| P2 | 无回退的 3 个组件变量 | `navbarLeftMaxWidth`、`uploadDragTransitionDuration`、`uploadDragTransitionTimingFunction` 仅有 `var(--td-...)`，没有 `var()` 备用值。未定义时 CSS 声明可能无效，或由外层样式/动画兜底。 | 按各组件实际 CSS 级联核对；不自动判作 Flutter 缺失。 | 待消费核对 |
| P2 | 含 CSS `calc()` 的 14 个组件变量 | 默认表达已展开全局引用，但 `calc()` 仍保留为布局算式；不能把表中的表达直接视作固定 dp。逐项名称见组件表或 `token-audit.json` 的 `componentAuditSummary.cssCalcExpressions`。 | 核对 Flutter 对应布局算式及约束，并在实际尺寸下比较结果；通常不需要公开 14 个 Theme 字段。 | 几何消费待核 |
| P1 | BackTop 小程序与旧 Figma 规格冲突 | 小程序半圆形默认约 60×40、图标约 22、深色无边框；仓库既有 Figma 规格记载带文字宽 69、图标 20、边框 0.5。圆角来源可由源码裁定，其他三项不能混为一个基准。 | Figma View seat 调用配额已耗尽；待可获取高清节点时逐项裁定，当前不改这些默认值。 | 设计基准冲突，未裁定 |
| P2 | `rpx` 尺寸转换（`spacer`～`spacer6` 等） | 表内按 375 宽的 `2rpx = 1dp` 比较；小程序 `rpx` 随屏宽变化，Flutter 当前为固定 dp。 | 用户已接受此数值换算，52 个含 `rpx` 的全局 Token 按该口径通过；仅当要求其他屏宽严格响应式等价时另议策略。 | 数值已接受，非本轮阻塞 |
| P2 | 复合字体及字体族（22 项） | 20 个复合 `font*` 和 2 个 `fontFamily*` 已转成 Flutter 字号、行高、字重及 fallback；静态值可对应，实际字体安装、字形、基线无法由值证明。 | 工程侧先在目标设备和设计稿上比对代表字号/中英文；出现实际差异后再请你裁定。 | 视觉待验证，非已知值差 |
| P2 | 外阴影 `shadow1`～`shadow4`（4 项） | CSS 多层阴影已转为 `BoxShadow`；TabBar 胶囊在小程序使用 `shadow-3`，Flutter 消费端已由误用的 `shadow1` 改为 `shadow3`。Linux 3.32.0 无更新截图相对旧 Golden 有 7475/48000 像素差异（测试比较器 15.57%），主要在阴影区域，不能把旧基线当设计目标。 | 用同尺寸小程序或高清设计图核对阴影观感；CSS 与 Flutter 模糊算法可能仍不同。 | 来源已修正，平台表达待验证 |
| P2 | 内阴影 `shadowInsetTop/Right/Bottom/Left`（4 项） | 小程序当前是 0.5px 的零模糊内线；Flutter 以 `BorderSide` 表达，亚像素渲染可能不同。 | 工程侧比对实际使用组件；若小程序以后加入模糊，需重新设计表达。 | 平台表达待验证 |
| P2 | 旧 `spacer4` 消费点（组件局部值） | 小程序 `--td-spacer-4 = 64rpx`，Flutter 全局 `spacer4 = 32dp`；旧 Flutter 的 4dp 使用点暂保留为局部值。 | 工程侧逐组件核对局部 4dp 是否有对应组件变量；无需逐条交你审 804 项。 | 消费链待核 |
| P2 | 现有 Linux Golden 基线 | 修复固定半径和非 Apple 默认字体后，受影响 47 张截图为 12 通过、35 差异；原先为 10 通过、37 差异。BackTop 浅色两张已恢复，TabBar 数字不再是方块。暗色 Demo 的代表像素是反色文字 alpha 修正后的 1 级灰度差；TabBar 还有既有设计对齐布局与正确 `shadow3` 的旧基线差。 | 已保留 master/test/diff 图；继续用设计稿及同配置小程序判断剩余视觉差，不能把旧 Golden 自动当设计正确值。 | 视觉门禁未通过，字体/圆角缺陷已修复 |

## 审查范围

`radiusCircle` 在 Flutter 保留固定 `9999dp` 的公开语义，与小程序 CSS `50%` 是明确例外，且不能强加给原本使用 `radiusRound` 或组件尺寸圆角的消费者。Tag 的 `danger → errorColor` 已按小程序保留；`rpx` 只在要求非 375 宽严格跟随小程序时再判断。暗色背景值差已修复；字体、阴影、局部间距须先拿出实际渲染差异再请你审。组件变量的 804 行已提取明暗默认表达与候选值，但 Flutter 最终消费值尚未逐项证明（25 行与同目录 Flutter Theme 字段同名，跨目录共 32 行）。不能因为没有同名字段就推定需要新增公开 API，也不能把同名字段当成值已对齐。

# 组件 Theme/API 收敛与 Golden 复核报告（2026-09-27）

## 结论与口径

本批代码已把公开组件的**同名** Widget API / Theme 字段候选从 64 项收敛到 0（AST 按实际导出过滤）。Button 具体样式优先级已修复；Text 的默认正文回退已按小程序 14dp/22dp 修正。Text 两张 Golden，以及本轮已裁定的 TabBar/导航 24 张 Golden，已在固定 Linux 3.32.0 更新并无更新复跑通过。**这不等于全部组件可合并发布**：同义但异名的便利字段、804 个小程序组件变量的最终消费链、其他旧 Linux Golden 仍未完全验收。不能宣称设计稿像素完全一致；未裁定的 Golden 不批量更新。

统一归属：实例 API 负责内容、状态、交互、离散规格/语义和单项结构布局；组件 Theme 负责可复用的具体视觉默认值，实例完整 `style` 可以显式覆盖单项；未覆盖时沿小程序表达式回退全局 Token。`TIcon` 这类 Flutter 原生基础组件使用实例属性和标准 `IconTheme`，不额外维护同义组件 Theme。删除已有公开字段属于 breaking change，发布前必须按仓库规范记录迁移及更新日志。

## 已修改

| 组件组 | 收敛结果 | 验证 |
| --- | --- | --- |
| SearchBar、Collapse、Table、Link、Cell、Input、Switch、TimeCounter、DropdownMenu、Stepper、Button | `variant`/`size`/交互时长等离散选择归实例；颜色、圆角、背景、间距等具体值归 Theme；同义字段删除 | 本批聚焦测试及双版本静态分析通过；详见 [所有权表](./ownership-table.md) |
| Avatar/AvatarGroup、Skeleton、BackTop、TimeCounter | 圆形消费端明确读取 `radiusCircle` 或组件 Theme 圆角；BackTop 半圆独立读取 `radiusRound`；未增加假想的 CSS 百分比辅助 API | Avatar 34 项、BackTop 69 项、Skeleton 18 项、TimeCounter 47 项聚焦测试通过；自定义圆角测试覆盖 |
| Icon、TabsBar、Indexes、Swiper | 原生 IconTheme、指示器、列表最大高度、分页对齐各保留一个入口 | 聚焦测试通过；Swiper 公开 Demo 在 3.47 的 shader 环境问题单列 |
| Drawer、SideBar、NavBar、底部 TabBar | 视觉数值只留 Theme，实例保留状态/布局语义；公开 Demo 的定制场景改用局部 Theme | 聚焦测试通过；底部 TabBar 42 项、Demo 9 项通过 |
| Dialog / TConfirmDialog | 面板背景、形状、阴影、宽度、最大高度、内容内边距归 Theme | 组件 32 项；Linux 3.32 Demo 16 项及图片浅色 Golden 通过 |
| Form | 标签宽度与文字对齐归 Theme；单个表单项的纵向/内容区域对齐归实例 | 61 项组件测试通过 |
| Text | 逐字段核对后恢复 `TTextThemeData` 的公开默认能力：`font`、`textStyle`、`strutStyle`、`textWidthBasis`、`textHeightBehavior`；实例 `style`/段落参数负责单项覆盖，显式 Flutter 文字主题仍可继承；Cascader/Picker 的既有共享消费路径恢复 | Flutter 3.32/3.47 的 `lib test` 严格 `analyze` 零告警，同组 187 项聚焦测试双版本通过；新增 Text/Picker/Cascader 主题层级断言 |
| Button 预设与 outline | 移除显式 `colorScheme` 对组件 Theme 具体样式的二次覆写；小程序 outline 四套配色的默认/按压/禁用回退按实际 CSS 变量调整 | Flutter 3.32/3.47 各 112 项 Button 聚焦测试通过；Linux Button Demo 4 张无更新 Golden 仍失败，但本次优先级修复前后实际 PNG SHA 完全相同，outline 状态调整亦未改变这 4 张取样截图 |
| Tag 组件回退链与尺寸 | 浅色 warning/danger/success 直接读取色阶 1；普通 outline 读取容器背景、默认描边读取组件背景；方形圆角由组件 Theme 覆盖、否则跟随全局 radiusSmall；公开 Demo 四档默认外高仍按小程序 20/24/28/40dp、文字 10/12/14/14dp，关闭图标读取占位文字色 | 最新聚焦回归与 Linux 旧 Golden 差异见 Spec 047 验收记录；旧基线未更新 |
| Popover | `showArrow` 归实例；偏移、箭头尺寸、内边距归 Theme | 65 项组件测试，定制内容浅色 Golden 通过 |

## 全局 Token 与 `radiusCircle`

冻结源：小程序 `develop@1a1c5ca135b0e9bf19abc43a59870c4908a28ad5`。最新审计得到两边全局键各 216、同名 216、独有项 0；浅/暗模式未批准原始值差、引用链差、缺失 getter 均为 0。已批准的原始值差包括小程序 `radiusCircle: 50%` 与 Flutter `radiusCircle: 9999dp` 的平台表达差异，以及浅色 `grayColor3 = #E8E8E8` 与其 4 个引用项；后者经设计裁定保留。`radiusCircle` 在 develop 的默认配置中也已是 9999，本批没有把默认值从 50% 改成 9999。正方形上的最终轮廓相同，但非正方形只保证 Flutter 固定半径形成胶囊，不保证 CSS 百分比的逐像素几何。

| 消费端 | 原风险 | 当前修复/判断 |
| --- | --- | --- |
| Avatar / AvatarGroup | 固定半宽可遮蔽用户自定义 Token | 使用组件 `circleBorderRadius ?? radiusCircle`；测试自定义 7dp 与组件 Theme 10dp |
| Skeleton circle block | 固定半宽可遮蔽用户自定义 Token | 使用 `radiusCircle`；测试自定义 7dp |
| TimeCounter round block | `BoxShape.circle` 会遮蔽圆角 Token | 使用可裁剪的圆角；测试自定义 6dp |
| BackTop 圆形/半圆形 | 半圆误用 `radiusCircle` 或圆形不读 Token | 圆形读取 `radiusCircle`，半圆只读取 `radiusRound`；两条路径分别测试 |

在受影响 Demo 的无更新 Golden 中，Avatar 正式迁移前后的**实际输出 PNG SHA 相同**；TimeCounter 的暗色实际输出在圆角消费修正前后 SHA 亦相同。结合默认 Token 未改，现有 Golden 差异不能归因于 `radiusCircle` 这次修复。若业务显式把 `radiusCircle` 从 9999 改为小值，形状改变是预期行为；非正方形与 CSS 50% 的差异仍须按设计稿分别判断。

## Linux 3.32.0 Golden

| 样本 | 通过 | 差异 | 已核实的主要原因/判断 |
| --- | ---: | ---: | --- |
| 原定 47 个用例：BackTop/导航/底部 TabBar 组件、BackTop/Indexes/TabBar Demo（含 1 个非图片注册测试） | 35 | 12 | 原始当前源码对旧基线为 11/36；本轮裁定并更新 TabBar 组件 12、TabBar Demo 10、导航组合 2 张后，固定 Linux 3.32.0 无更新复跑三组 14/14、11/11（含注册测试），剩余 BackTop 组件 1、BackTop Demo 4、Indexes Demo 7 张仍有差异。剩余项暂不更新 |
| `radiusCircle` 相关的 Avatar/BackTop/Skeleton/TimeCounter Demo 14 张 | 6 | 8 | Avatar 浅色 16958px/3.66%、暗色 20571px/4.44%，主要是品牌浅色/焦点色及图标轮廓；Skeleton 浅色通过、暗色主要是文字字形；TimeCounter 暗色高级页 10875px/1.72%，差异集中在文字/颜色；BackTop 的浅色场景通过、暗色仍有 Token/文字差异 |
| Dialog 图片浅色、Popover 自定义内容浅色 | 2 | 0 | 局部 Theme 迁移后与旧基线一致；只证明这两个取样状态 |
| Text Demo 浅色/暗色整页 | 2 | 0 | 初始旧图 375×1618，错误的 Material `bodyLarge` 被字体兜底配置升格为显式值时新图 375×1642。修复后使用小程序 `paragraph.less` 的 `fontBodyMedium` 14dp/22dp，实际图 375×1616；剩余差异含示例文案变化与旧字号字形。经源码和实际图核对，仅更新这两张基线，并在同一 Linux 3.32.0 环境无更新严格复跑 2/2 通过；这不是 Figma 像素对齐结论 |
| Button Demo 页面及按压浅/暗 4 张 | 0 | 4 | 与旧基线的页面浅色 6187px、暗色 24857px，按压浅色 6187px、暗色 29072px 差异仍在；当前样式优先级修复前后 4 张实际 PNG SHA 逐一相同。样本没有覆盖 outline 按压/禁用的新回退，不能用这些旧基线失败归咎于本次 Button 修复，也不能据此宣布新状态视觉已验收 |
| Tag Demo 页面/选中浅暗 4 张 | 0 | 4 | 本轮修正默认 outline 背景、square 4dp 圆角及关闭图标色后，无更新旧基线比对分别差 3168px/0.64%、12212px/2.49%、3026px/0.62%、11870px/2.42%。实际图显示 outline 外观变化符合冻结小程序源码；旧基线同时含暗色文字/图标等其他差异，尚未逐项归因，故未更新 |

本轮更新前的 24 张精确 RGBA 差异统计：TabBar 组件 12 张共 29,094/576,000 像素（5.051%）；TabBar Demo 10 张共 257,902/3,759,000 像素（6.861%）；导航组合 2 张共 50,997/912,240 像素（5.590%，按两图较大面积计）。更新后同环境无更新复跑均为 0 差异。导航组合旧图 420×1084、新图 420×1086；Steps 后续内容整体下移 2px，源于 TText 默认正文 Token/解析后的行高变化，而非导航组件另有位移代码。TabBar 胶囊 Demo 由旧纯图标变为设计契约记录的 4 个 `Item` 图文项及首项圆点徽标；组件本身保留 16px 外边距、8px 内边距/项间距与 75.75×40px 选中项几何，不为旧 Golden 回退实现。

除已裁定并更新的 Text、TabBar 和导航样本外，其余仍是“当前 Linux 输出 vs 旧 Golden”，不是“当前输出 vs Figma”。旧 Golden 在正确 Token 值改变后可能过时；不能用它的失败单独判断实现错误，也不能无设计证据批量更新。未裁定样本的差异图保存在 Linux 隔离目录的各测试 `failures/` 下，未写入仓库 Golden。Figma MCP 当前触及 Starter 额度上限；浏览器可见设计文件和既有数值化 Spec 支持本轮 TabBar 几何裁定，但不能视为全部 47 个用例已完成设计稿数值比对。

## 尚不合理或未完成的审查

| 优先级 | 问题 | 证据 | 建议修复与验收 |
| --- | --- | --- | --- |
| P0 | 公开 API 大范围 breaking 尚待发布决策与外部迁移验证 | 已发布字段删除清单及替代写法见 [迁移文档](./migration.md)；尚未用外部调用方编译验证 | 按最终 diff 逐字段核对迁移，选择 breaking 版本与提交类型，验证示例和实际使用方；不能作为普通重构发布 |
| 已处理 | Avatar/Popover 的已确认同义视觉入口 | Avatar `foregroundColor` 与 `textStyle.color`；Popover `radius` 与 Theme `borderRadius`、`overlayColor` 与 Theme `barrierColor` | 2026-09-28 已收敛为单一 Theme 入口，迁移方式与回归见下方补记；其他组件仍须继续查异名同义字段 |
| P1 | 804 个组件变量未全部证明最终消费 | [逐项静态证据](./component-consumption-audit.json)固定读取小程序 `1a1c5ca`：406 项有同目录全局 getter 候选、25 项有组件 Theme 字段候选（10 项两者都有）、291 项同目录无直接证据、82 项无对应 Flutter 组件目录。进一步查 Less 动态 `@@` 与直接 CSS 引用后，100 项属于“动态 Less 可能消费”，仅 10 项在冻结源码未见静态消费者。Button 12 项、Tag 12 项默认 Widget 值及 Tag 7 项回退 Widget 路径已逐项裁定；其余 682 项仍待审。候选命中不是最终绘制证明 | 按[审查队列](./component-consumption-review.md)继续对有对应组件的行做状态/Theme/最终绘制核验；81 项小程序已消费但 Flutter 当前没有对应组件，应归属未来组件范围，不给现有组件制造假 Theme 字段 |
| P1 | 小程序自身变量歧义 | `sliderDefaultColor`、`tabBarBorderColor` 回退冲突；3 项无回退，1 项未解析引用，14 项 CSS `calc()` | 保留原始表达与使用位置，设计稿/运行态逐项裁定，不能擅自定值 |
| P1 | 原定 47 个用例仍有 12 个旧基线差异 | BackTop 组件 1、BackTop Demo 4、Indexes Demo 7；其余 TabBar/导航已按设计契约和 Token 字体度量裁定 | 继续按设计稿/小程序逐实例判断剩余差异；修实现缺陷后，在固定 Linux 3.32 更新对应基线并无更新重跑；再验 3.47 功能，不机械要求跨系统像素相同 |
| P2 | Flutter 3.47 的部分 Demo 测试受 SDK shader 错误干扰 | Dialog、Popover、Swiper 公开 Demo 出现 `shaders/ink_sparkle.frag` 解码失败，而 Linux 3.32 Dialog 16 项全通过 | 将环境问题与组件断言分开；修复/刷新 3.47 SDK 缓存后重跑，不能当作组件通过或失败 |

## 发布判断

当前可作为**阶段性实现与审查报告**，尚不能合并发布。Text 的已发布组件 Theme 能力已恢复并与实例覆盖分层，Button/Input 的完整实例 `style` 同理保留；Button 的显式 `colorScheme` 不再覆盖 Theme 具体颜色。Text 两张及本轮 TabBar/导航 24 张 Golden 已在 Linux 更新/严格复跑；剩余差异仍须逐项裁定。下一步解决其余视觉差异、组件变量消费链及 breaking 发布验证，再完成全仓双版本门禁。此次未提交或推送。

## 2026-09-28 单入口收敛补记

Avatar 移除了 `TAvatarThemeData.textStyle`，保留 `foregroundColor` 为默认文字和图标的唯一前景色入口；默认字号/字重仍随 `size`，特殊文字排版通过 `child: Text(style: ...)`。Popover 移除了 `TPopoverAnchor` 和 `TPopover.showPopover` 的 `overlayColor/radius`，保留 Theme 的 `barrierColor/borderRadius`；`borderRadius` 改为 `BorderRadius?` 以保留逐角配置。单实例自定义使用局部 Theme。API 生成清单已收录两个 Theme 类，生成文档不再展示被删除的字段和仅供内部使用的插值辅助方法。

两组件的组件测试在 3.32.0 与 3.47.0 各通过 100 项，公开 Demo 功能测试各通过 7 项；两版本的完整组件包和 Demo 包严格分析均为 0 issues。3.32.0 Linux 隔离覆盖率 Avatar 169/173（97.69%）、Popover 620/632（98.10%）。Linux 3.32.0 无更新复跑 Avatar/Popover Demo Golden 共 25 通过、27 差异；Avatar 的浅/暗差分别仍为 16,958px / 20,571px，与本报告先前记录的值相同。Popover 的失败样本仍需逐张做 Token/旧基线/实现归因；本次不更新 Golden、不宣称视觉门禁通过。上述 API 删除与 Theme 字段改型均属 breaking，迁移见 `migration.md`。

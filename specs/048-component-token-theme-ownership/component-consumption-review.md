# 组件 Token 消费审查队列

数据来自 [`component-consumption-audit.json`](./component-consumption-audit.json)，固定小程序源码 `1a1c5ca135b0e9bf19abc43a59870c4908a28ad5`。每项均保留小程序变量名、默认浅/暗值、全局回退表达式和 Flutter 代码位置。下表仅是审查范围与优先级，不把静态命中误判为最终绘制一致。

| 分类 | 数量 | 判定与下一步 |
| --- | ---: | --- |
| 同目录全局 getter 候选 | 411 | 验证状态、Theme 覆盖、默认值最终传到 Widget 或 Painter；仅有字段引用不足以通过。 |
| Theme 字段候选，且有全局 getter | 10 | 验证局部 Theme 的值优先于全局回退，且实例不存在同义样式入口。 |
| 仅 Theme 字段候选 | 15 | 验证 Theme 为空时小程序默认值和暗色值。 |
| 同目录无直接字段证据 | 286 | 区分组件能力缺失、等价硬编码、Flutter 原生样式、跨目录封装与小程序未使用变量。 |
| 无对应 Flutter 组件目录 | 82 | 不机械增加组件 Theme 字段；先确认组件能力是否计划支持。 |

未对应的 82 项来自小程序 `color-picker` 21、`count-down` 5、`grid`/`grid-item` 18、`guide` 29、`overlay` 2、`segmented` 7。BackTop、TabBar、SideBar 等命名不同但确有 Flutter 组件的项目，已通过显式目录别名映射，不计入这 82 项。除其中 1 项在冻结源码中未找到消费，其他 81 项属于 Flutter 当前未实现的组件表面，不应给已有组件硬塞同名 Theme 字段；未来若实现对应组件须重新纳入。

早期“113 项 Less 别名未使用”的判断过于粗糙：小程序 Less 通过 `@@变量` 动态拼接消费 Button、StepItem 等 100 项。扩展扫描 Less/WXSS/WXML/WXS/JS/TS 中的 CSS 变量直接引用后，只有 **10 项**在冻结源码中找不到静态消费证据；这些项目前不要求 Flutter 为对齐当前小程序可见样式而新增 Theme 字段，但不能据此删除小程序的公开 CSS 变量。详见 JSON 的 `miniSourceUse` 和 `reviewDecision`。

| 已裁定的组件变量 | 数量 | 证据与结论 |
| --- | ---: | --- |
| Button 四档高度、水平内边距、图标尺寸 | 12 | 小程序明暗默认值均等于 Flutter 尺寸表；[组件测试](../../tdesign-component/test/components/button/t_button_test.dart)检查最终按钮高度、padding 和 IconTheme 尺寸。对齐的是 375 宽下默认值，不代表已开放逐项组件 Theme 覆盖。 |
| Tag 四档字体、图标尺寸、内边距 | 12 | 小程序始终有 1dp 边框；Flutter 无描边态将该边框宽度补入 padding，四档最终边框盒高度、字体、图标及内边距由 [Tag 组件测试](../../tdesign-component/test/components/tag/t_tag_test.dart)验证。没有把原始 CSS padding 误当成 Flutter 的内部 padding。 |
| Tag 浅色三色、outline 背景/默认描边、square 圆角、关闭图标色 | 7 | 小程序引用链已在组件修正，并由实际 Widget 测试检查；阶段性记录为“回退链与 Widget 已验证、跨端视觉待裁定”。 |
| Switch 未选中轨道色 | 1 | 回退从误用的 `textColorDisabled` 修正为 `bgColorSecondaryContainerActive`，Widget 断言与 Linux 7 张关联 Golden 已核；其余 Switch 状态和变量仍待审。 |
| 冻结小程序源码无静态消费者 | 10 | 不为了这些声明而给 Flutter 增加 Theme 字段；未来小程序开始消费或发现动态路径时重审。 |

| 优先组件 | 变量总数 | 无直接证据 | 需要重点裁定的差异 |
| --- | ---: | ---: | --- |
| Button | 98 | 29 | 四档高度、水平内边距、图标尺寸共 12 项已确认默认 Widget 值；outline 四套配色和默认/按压/禁用状态已补测试。`dashed`/`ghost` 变体及其他字段仍须按实例检查，不能把 2dp Less 边框机械写成 Flutter 2dp。 |
| Switch | 32 | 29 | 未选中轨道回退已修复；其余禁用状态、尺寸与滑块仍须逐项追踪绘制值。 |
| Tag | 31 | 11 | 12 项尺寸默认值和 7 项回退链/Widget 路径已核对；其余状态组合与 Golden 仍须检查，不能用 Demo 覆盖补齐。 |
| Avatar | 18 | 15 | `radiusCircle` 的 Flutter 固定半径例外必须保留并按非正方形实例核对。 |
| Popover | 13 | 11 | 箭头、偏移和内容内边距需分别核对 Theme 入口与最终布局。 |

验收规则：每个被 Flutter 支持且在小程序实际使用的变量，记录小程序浅/暗最终值、Flutter Theme/Token/常量的有效来源，以及一个实际 Widget/Painter 状态断言；设计稿可访问时再加对应实例的像素比对。`reviewDecision` 记录阶段性裁定；当前未完成跨端最终像素验证，所以 `finalPaintVerified` 仍保持 `false`，不能把 24+7+1 项阶段性结果误称为完全视觉对齐。

## 2026-09-29：Progress 逐变量消费链复核

以下是 Progress 9 个变量的**实际默认消费**，不是只按同名字段猜测。小程序基线仍为 `1a1c5ca`；Flutter 最终值由当前 Widget 测试和 Linux Golden 复核。完整跨端像素验收尚未完成，故 JSON 的 `finalPaintVerified` 不改为 `true`。

| 小程序组件变量 | 小程序最终消费 | Flutter 最终消费与结论 |
| --- | --- | --- |
| `--td-progress-line-stroke-width` | `progress.less` 线性轨道高度，12rpx → 6dp | `linearStrokeWidth=6` → `_ProgressIndicator.strokeWidth` → `progress-track` 高度；组件测试实测 6dp。 |
| `--td-progress-stroke-plump-width` | plump 高度，40rpx → 20dp | `plumpHeight=20` → 轨道高度；组件测试实测 20dp。 |
| `--td-progress-stroke-circle-width` | 环形内圆尺寸和 WXS 环宽，12rpx → 6dp；micro 局部覆盖 4rpx → 2dp | `circularStrokeWidth=6` / `microCircularStrokeWidth=2` → `TProgressCircular` painter；圆环中心内径按 `diameter - 2×strokeWidth`，micro 分支亦同。 |
| `--td-progress-circle-width` | 224rpx → 112dp；micro 局部覆盖 48rpx → 24dp | `circularSize=112` / `microCircularSize=24` → `SizedBox.square`；组件测试实测 112/24dp。组件 Theme 使用 `circleSize` 表达外框边长，不再把直径误称为半径。 |
| `--td-progress-circle-icon-size` | 默认 96rpx → 48dp；WXML 状态图标直接写 `96rpx`，组件 Less 中声明的变量本身未在该文件消费 | Flutter 圆环状态 `IconTheme.size=48`，默认值与运行结果一致；小程序组件变量的独立覆盖能力并未因此得到证明，不能机械开放同名 Theme 字段。 |
| `--td-progress-circle-label-font` | `@font-title-extraLarge` → 20dp/28dp、w600 | `fontTitleExtraLarge` → `_buildLabelWidget` → `DefaultTextStyle`；组件测试核对字号、行高、字重。 |
| `--td-progress-track-bg-color` | `@bg-color-component` → 浅 `#e7e7e7` / 暗 `#383838` | `bgColorComponent` 默认进入线性 `BoxDecoration` 或环形 Painter；显式 `TProgressThemeData.backgroundColor` / Flutter `ProgressIndicatorTheme` 按公开优先级覆盖。 |
| `--td-progress-inner-bg-color` | `@brand-color`，状态样式另选 warning/error/success | `brandColor` 与状态 Token → 线性填充/环形 Painter；组件测试覆盖四种状态最终线性填充颜色。 |
| `--td-progress-circle-inner-bg-color` | 浅色未覆盖，Less 回退 `@bg-color-container`；暗色 `_components.less:28` 覆盖为 `var(--bg-color-page)`，但冻结源码未定义**无 `td-` 前缀**的该变量。未由宿主定义时，CSS 背景在计算值阶段失效为透明；宿主可定义它或直接覆盖组件变量 | 浅色 `bgColorContainer`、暗色透明 → 内圆 `DecoratedBox`；`TProgressThemeData.circleInnerBgColor` 是唯一组件级显式覆盖。Widget 测试覆盖浅/暗与覆盖；Linux 暗色两张旧 Golden 无更新通过，浅色两张仍有其他轨道/圆环差异，暂不更新。 |

Tag 字体宽度：固定 Linux Golden 字体、medium `TTag('Tag')`、文字缩放 1 时，实际 `RenderParagraph` 宽 **20.5078125dp**、左右预算各 8dp、组件总宽 **36.5078125dp**，已新增真实字体加载后的 Demo 测试。Figma 实例 38px 减去两侧 8px，反推文字约 22px，但这仍是**间接推算**，不是设计字体的直接字形测量。组件已读取全局字体族并保留 Demo/宿主提供的中文字体回退；四张 Tag Linux Golden 无更新通过。不能用固定宽度或加大 padding 伪造 38px，也不能在未得到同字体测量时宣布与 Figma 逐像素一致。

暗色 CSS 变量的透明判断依据：[W3C CSS Custom Properties §3](https://www.w3.org/TR/css-variables-1/#using-variables)：已定义组件变量中再引用缺失变量，不会重新选用外层 `var()` 的 Less 回退，而会使 `background-color` 在计算值阶段成为初始值 `transparent`。若应用宿主另行定义 `--bg-color-page`，该判断需按宿主实际值重算。

## 2026-10-03：Switch 未选中轨道 Token 复核

小程序 `--td-switch-unchecked-color` 的默认回退为 `@bg-color-secondarycontainer-active`（浅色 `#dcdcdc`、暗色 `#383838`）。Flutter 此前误用文字禁用色 `textColorDisabled`（浅色 `#42000000`、暗色 `#38ffffff`），属于组件消费 Token 错误，不是平台渲染差异。`TSwitchResolve.trackOffColor` 改用 `bgColorSecondaryContainerActive`；组件 Theme 的显式 `trackOffColor` 仍覆盖该默认值。此项须以 Widget 值和最终 Linux Golden 核验；Switch 其余组件变量不因此自动通过。

## 2026-09-30：Avatar / AvatarGroup 消费链初核

头像本体的背景、前景、三档边长、文字字号、图标字号和圆/方角，分别走 `TAvatarThemeData` → 全局 Token / `TAvatarDefaults` → `ColoredBox`、`SizedBox.square`、`DefaultTextStyle`、`IconTheme`、`ClipRRect`，默认数值与小程序 `avatar.less` 相同：背景 `brandColorLightActive`、前景 `brandColor`、边长 40/48/64dp、文字 14/16/20dp、图标 20/24/32dp、方角 `radiusDefault=6dp`。`radiusCircle` 的 50% 与固定 999dp 表达差异仍是已批准的平台例外；非正方形内容不得据此宣称像素完全一致。

头像组的旧实现曾对所有成员使用统一 2dp 描边、单行 8dp 重叠；小程序 `avatar-group.less` 的三档偏移均为 -8dp，但其 WXML 的 `avatar--border` 仅施加于折叠头像，并支持换行与 2dp 行距。随后直接核对 Figma Avatar 组件集 `26722:7669` 和公开展板 `25054:18489`：设计实例是单行，全部成员均有容器色描边，小/中/大分别为 1/2/3px，重叠 8px，并有水平偏移 1px、模糊 2px、黑色 15% 阴影；因此此处不机械移植小程序的“仅折叠头像描边/换行”。Flutter 组件已改为逐成员尺寸描边与阴影，描边色继续从组件 Theme 回退到全局 `bgColorContainer`。公开 Demo 的图片顺序、`+2` 和右侧成员在上的层叠方向也已按展板修正；不再把 Demo 数据错误归为 Token 错误。Figma / develop / current 的同尺寸裁切及像素差异见本轮验收记录。

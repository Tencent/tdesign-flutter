# 实施方案

## 技术方案

1. 只读盘点公开 Widget 参数、组件 Theme 字段和实际解析路径；同名仅作为候选，按语义判定，不按名称机械删除。
2. 收敛同义入口，包括跨实例 `style`、组件 Theme 与便利标量的基础视觉字段。已有完整 `style` 的字段由 `style` 独占 TDesign 公开配置；未被完整 `style` 覆盖的可复用视觉字段归组件 Theme；实例 API 持有状态、规格与结构选择。每项先记录迁移影响再改公开 API。
3. 对受影响的小程序组件变量，记录 CSS `var()` 的回退表达式、明暗及状态分支，再检查 Flutter 是否读取正确的全局 Token、组件常量或必要 Theme 字段。优先审查所有 `@radius-circle` 消费路径：Avatar、BackTop、CountDown/TimeCounter、Skeleton，并验证正方形与非正方形边界；保留已确认的 Flutter 全局 `radiusCircle = 9999dp` API 语义，不把默认例外伪装成 CSS `50%` 同值。
4. 改动后先验证聚焦功能与覆盖优先级，再在固定 Linux 3.32.0 环境无更新复跑相关 Golden。Golden 按来源做消融：全局 Token 改值、组件 Token 缺失/错误、`radiusCircle` 错用、字体/阴影跨引擎、旧基线或 Demo 布局，逐张给出处置建议。正确 Token 值导致的旧基线差异与组件缺陷分别归因。
5. TimeCounter 对应小程序 CountDown：移除组件 Theme 的 `defaultSize/defaultVariant`，保留实例选择；为确有组件变量的默认/块文字色、块背景色及方/圆块圆角提供具体 Theme 值。圆块在默认正方形尺寸下使用全局 `radiusCircle`，自定义该 Token 时必须从固定的 `BoxShape.circle` 转成对应 dp 圆角，而不忽略覆盖。
6. 按最终单入口规则修订前期的 Text/Button/Input 多层样式方案：`TTextThemeData.textStyle` 承担子树级默认文字样式，公开 `TText.style` 承担单实例完整文字样式，`font` 仅作为字体 Token 预设；移除与 `style` 同义的分散文字参数。组合组件逐项动态样式由内部解析后交给原生 Text。`TInput.style` 承担输入文字样式；Button 的实例 `ButtonStyle` 承担可表达的视觉字段，Theme 只留独有视觉配置。仓内调用与双版本回归已核验，真实外部调用方仍须完成 breaking 迁移编译。
7. 修正 Avatar Theme 动画：当插值一端未配置尺寸、图标尺寸、组描边宽度或圆角时，保留内部插值两端与进度，由 `TAvatar`/`TAvatarGroup` 在获知成员 `size` 与当前全局 Token 后求实际数值；公开 nullable 字段不伪装成一个中号或固定 Token 值。两端均显式配置时沿用普通数值插值；默认圆形仍沿用正圆绘制，自定义半径小于边长一半时，内容、描边和阴影共用同一圆角矩形几何。
8. 组件 Theme 动画使用运行时有效默认值：Avatar 组间距在最终尺寸下解析并约束；Tag 的通用颜色和 padding 在配色、规格已知后插值，固定宽度的自适应态与数值态离散切换；Progress 的尺寸、粗细、轨道/前景色和圆角在 variant 与状态已知后插值，不确定态比例与时长使用内置默认值；Button 图文间距从 4dp 插值。Progress 对外尺寸字段从误称半径的 `circleRadius` 改为 `circleSize`，不添加兼容别名。
9. 移除 Material `TextTheme` 与 `DefaultTextStyle` 的自动补全/显式来源推断及其组件消费分支。TDesign 文字默认值只从全局 Token/Theme 取得，组件 Theme 提供子树覆盖，已有实例样式负责单项覆盖；Material `ThemeData.textTheme` 仅供原生 Material 控件使用，不再构成 TDesign 文字样式入口。
10. 为 Tag 前置图标复用正文的有效前景色，保持关闭图标独立；用最小 Widget 用例锁定组件 Theme、全局 Token 和禁用态的优先级。此前为显式 Material 色板加入的字段级推断属于反向桥接，随全仓单向主题链一起删除，不发布新的 `TExplicitColorSchemeColors` 类型。
11. 按组件逐项移除 Material → TDesign 的视觉输入：ColorScheme、Material 组件 Theme、IconTheme/TextTheme、禁用色与分隔线、AppBar/Dialog/InputDecoration 等。保留 `Theme.of(context).extension<T...>()` 读取、全局 TDesign Token 到原生 Material 控件的投影、平台交互/无障碍机制及组件内部向原生子控件传递已解析样式。每个被移除的子树覆盖入口要核对是否已有组件 Theme 或实例完整样式，缺少真实定制入口时按单入口所有权判断，而非机械增补。
12. 以静态扫描核对所有组件不存在 Material 外观反向读取，并以显式 Material Theme 注入测试证明其不改变 TDesign 默认样式；验证 TDesign Theme 和实例样式仍生效、原生 Material 控件仍接收投影。重跑双版本组件测试、分析及 Linux 3.32.0 无更新 Golden，逐项归因差异。
13. 对本轮已取样的三类状态作定向修复：Button 在 `ButtonStyle` 解析中只对深色主色填充禁用文字采用 `fontWhite4`；Switch 将轨道、滑块填充和加载指示器各自解析到状态色，并由组件 Theme 提供具体颜色覆盖，避免整控件透明度；Slider 浅色禁用滑块描边回退 `componentBorder`，深色保留原 `bgColorComponentDisabled`。固定浅/深色与禁用/加载状态测试，之后在 Linux 3.32.0 对受影响 Golden 无更新复跑。

## 影响范围

| 范围 | 影响 |
| --- | --- |
| 组件 Theme/API | 仅修改经逐项审查确认重复或错用 Token 的组件；已发布字段变更列为 breaking |
| 测试 | 公开契约、自定义全局 Token、子树 Theme、实例配置、明暗视觉 |
| Demo 与文档 | 仅修正因公开 API 迁移而失效的使用，不能加入样式遮盖 |
| 报告 | 修改清单、风险、Golden 差异和未覆盖组件 |

## 风险与取舍

- 删除已发布 Theme 字段或 Widget 参数是 breaking change；不能把仅标记 deprecated 当成已实现单一控制源。上一轮临时增加的 `radiusCircleBorder` 辅助 API 未形成独立组件契约，删除它并由 BackTop 内部直接构造相同边框，避免误用于半圆或非正方形组件。
- 本轮用户要求同一绘制字段即使跨子树默认与单实例覆盖也不再保留两套 TDesign 公开入口。这会移除部分已发布子树批量定制能力；须列出迁移方式、breaking 范围和外部调用风险。
- 804 个小程序组件变量目前有 2 个回退冲突、1 个未解析暗色表达式、3 个无回退；这些不是可直接认定的 Flutter 缺失项。

## 验证策略

- 静态：全局 216 键审计、Theme/API 重叠候选及实际引用核对。
- 功能：受影响组件在 Flutter 3.32.0 与 latest 的聚焦测试、定向 `flutter analyze --fatal-infos`。
- 视觉：固定 Linux 3.32.0、不更新 Golden；检查 master/test/diff 与具体 Token/布局来源。
- 人工：对设计稿无法裁定的项明确标记，不宣称像素一致。

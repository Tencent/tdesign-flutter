# TD 内置样式所有权

## 目标与行为契约

阻止 Material/M2/M3 默认视觉意外改变 TD 内置样式，保留原生能力。TD 内置视觉通过受支持的实例参数/style、TD ThemeExtension 和 Token 定制；外部 Material 组件视觉主题不作为覆盖入口。调用方自定义内容使用自身的原始主题，组件已公开的内容默认样式继续提供。

- 内置文字和图标的颜色、字体、字距、形状、尺寸及布局由 TD 解析；已有 TD 显式配置继续生效。
- 普通内容容器、Tooltip 不向自定义内容重新注入未经组件解析的图标颜色或尺寸。Button/IconButton 等已拥有插槽图标默认值的控件仅保留自己明确解析的默认值。
- 原生 Material 控件可以继续承担交互、绘制、焦点、键盘、无障碍和动画，不以避免视觉干扰为由整体重置用户内容主题。
- Input/Search/Textarea 编辑器使用完整 TD 文字样式及自有装饰边界；不重置整套编辑器 Theme，不覆盖原生文本选择颜色、手柄主题和平台输入能力。
- TText 的选择行为及 selectionColor 保持 Flutter 契约；默认继承原生选择主题，实例 selectionColor 仍优先。不把原生选择高亮判为 TD 排版泄漏。
- Tooltip 的触发模式、显示/退出/等待时长、反馈及无障碍设置继承原生主题；视觉字段继续由内部局部边界控制。
- Button/IconButton 的原生反馈和 mouseCursor 设置保留，受支持的实例配置优先。已有密度决策仍有效：Button.style.visualDensity 不改变 TD 规格尺寸，使用标准密度；用户通过 size/padding/宽高定制。
- 禁用、选择、值、回调、控制器、亮暗模式、字体缩放、方向和平台语义不变。外部 Material 视觉配置不得控制 TD 业务状态。

## Breaking 与迁移

本地调整修正此前过度隔离，并不新增公开 API。外部 Material 组件视觉主题不再是 TD 定制入口仍属 breaking；迁移到 TD Theme/Token/实例配置。原生能力及调用方主题行为保留，不将其误列为被删除的能力。

## 验收

以 PR head 93c1d747 为本轮修正的审查起点。在两个 SDK 验证自定义内容的实际 IconTheme/字号/颜色、内置 glyph 隔离、原生选择与反馈、Tooltip 行为和交互。受影响组件及消费者通过后执行完整双版本回归、严格 analyze 和覆盖率；Linux 3.32 Golden 先比较，仅验收有意差异后更新，并无更新参数复跑。最终交付按用户授权执行，结果见 [final-review.md](./final-review.md)。

## 按状态回退与文字插槽

- Cell 必填标记与 Divider 文字默认值必须完整解析，不从 Material 默认字体、字距、词距或阴影补空缺。组件 TD Theme 和自定义内容的显式样式保持优先级。
- Button/IconButton 实例 WidgetStateProperty 仅覆盖当前状态的非空值；返回 null 时回退该状态的 TD 默认值。显式透明色、无边框等非空值仍生效。
- 内部渐变清空 backgroundColor 的逻辑不走实例状态回退，保留其有意空值。
- mouseCursor 按状态依次使用实例非空值、原生主题值、原生默认值，不用对象级非空判断提前截断回退。

- Button layer builders 保留调用方原始主题；内部主题恢复在图层挂载后执行，不得用外部默认正文字体替换按钮已解析的插槽默认值。

## 渐变按钮尺寸与描边

- 所有 size / variant 的普通与渐变按钮使用相同的内容 padding 与尺寸约束；边框不额外参与布局，只在前景绘制一次。
- 默认字号下 large / medium / small / extraSmall 高度为 48 / 40 / 32 / 28dp；outline / ghost 不得因描边产生额外的宽高。
- 显式 padding、minimumSize / fixedSize / maximumSize、状态边框与形状、点击区尺寸、RTL 以及自定义内容主题和位置保持原语义。
- 不将尺寸 Token 改为硬高度；字体缩放和大尺寸内容可像普通按钮一样撑大 minimumSize 按钮。
- 本项修正恢复已定义的尺寸契约，不新增或删除公开 API。原 PR 的 Material 主题迁移 breaking 说明保留；这一尺寸缺陷修复的用户更新日志为：fix(button): 修复渐变描边按钮尺寸与普通按钮不一致。不改自动生成的 CHANGELOG。

# 组件 Token 消费与 Theme/API 所有权收敛

## 背景

全局 Token 已按冻结的小程序版本逐项审计。组件 CSS 变量在小程序中先尝试组件变量，再按各自表达式回退到全局 Token、局部常量或计算式。Flutter 当前有多处将同一形态、状态或功能选择同时放在 Widget API 和组件 Theme 中，形成两个公开控制入口；组件 Theme 的具体视觉字段也不能仅凭同名认定已经消费了对应的小程序变量。

## 目标

- 逐组件核对小程序组件变量的默认表达、Flutter 最终消费值和覆盖优先级，不把小程序 CSS 变量机械转成公开 Theme 字段。
- 每项形态、状态、交互、功能选择明确一个公开所有者。组件 Theme 只承载有子树批量定制需求的具体视觉默认值。
- 保留全局 Token 的动态回退：未显式设置组件视觉值时，修改上游全局 Token 应传导至组件。
- 把 API 删除、行为变化、无法裁定的小程序歧义和旧 Golden 差异分别报告。

## 非目标

- 不以旧 Golden 反推设计正确值，不因旧基线失败盲目回退正确的 Token 值。
- 不按 CSS 变量数量创建同数目的 Flutter Theme 字段。
- 不在 Demo 层覆盖组件内部视觉以制造截图一致。

## 范围

### 涉及

- 当前组件 ThemeExtension 与公开 Widget 参数的重叠字段及其真实消费链。
- 已映射的 804 个小程序组件变量中，本轮实际影响的组件默认视觉与回退关系。
- 受影响组件的 API 文档、测试、Demo 使用与 Linux 3.32.0 Golden。

### 不涉及

- 用户尚未裁定的小程序源码自身歧义，不擅自选定一种默认值。
- 与组件默认样式无关的业务状态或外部应用逻辑。

## 行为契约

- 组件变量未显式覆盖时必须沿小程序原回退表达式取得默认值；若回退全局 Token，不得将当时的颜色或尺寸预填到高优先级 Theme 字段。
- 形态、状态、交互和功能选择只能有一个公开权威入口；不能同时由 Widget 参数与 ThemeExtension 独立决定。迁移已发布 API 时列出 breaking 风险与替代用法。
- 用户确认区分配置作用域：组件 Theme 管子树可复用的默认视觉，实例完整 `style` 管单实例显式覆盖；两者可以控制相同绘制字段，但必须有明确的优先级、真实使用需求和测试。不得以此为由再增加同义的独立标量入口；状态、形态和功能选择仍只能有一个权威入口。
- 统一归属标准：实例 API 选择离散的组件规格与语义（如 `size`、`variant`、`colorScheme`、`shape`）、内容、状态、交互与回调；组件 Theme 优先定义可供子树复用的具体视觉数值（如高度、内边距、字号、颜色、边框宽度、圆角、阴影）。因此 `size: small` 属 API，而 small 对应的高度/字号/间距属于 Theme 或其全局 Token 回退。不得在 Theme 再设 `defaultSize`/`variant`。若具体视觉值本身是每实例的核心输入（如单个图标的颜色/物理尺寸），可由 API 持有，但必须移除组件 Theme 的同义字段并优先复用 Flutter 已有的 `IconTheme` 等标准继承机制；不得两边同时保留。不是所有原始数值都必然开放 Theme 字段，须有稳定定制需求且能保持 Token 回退。
- 对实际保留的视觉 Theme 字段，解析优先级为实例显式完整 `style` → 显式组件 Theme → 适用的显式 Flutter 主题 → TDesign 全局 Token 或组件内置默认值；独立实例标量与 Theme 同义时须逐项证明其不同作用域或收敛为完整 `style`。Flutter 原生继承与组件 Theme 的重叠默认值同样需要证明组件 Theme 有独特能力。
- `colorScheme` 预设、业务状态、回调和内容不进入组件 Theme；`size`/`variant`/`shape` 等离散规格选择也不进入组件 Theme。视觉开关若只是渲染装饰且无实例语义，优先 Theme；若改变组件交互或结构，则留在 API 并写明理由。
- `TButton.colorScheme` 仅选择内置调色预设，不是对各绘制字段的实例样式覆盖。无论是否显式传入，预设均先于显式 Material/组件 Theme 合并；组件 Theme 中逐字段指定的颜色、文字和边框优先，单实例需覆写具体值时使用 `TButton.style`。背景、前景、描边及各交互状态均遵守这一顺序。
- 动画时长若直接决定单次组件交互的展开/收起时间，归实例 API；Theme 可承载动画曲线、颜色或尺寸等不与该时长同义的视觉默认值。系统“减少动态效果”始终优先于实例时长。
- 无法由同值比较证明视觉等价的字体、阴影、百分比几何及响应式尺寸须独立记录；全局 `radiusCircle` 维持已记录的 Flutter 固定半径例外。
- 当前决定：`TButton`、`TInput` 等组件的完整实例 `style` 与组件 Theme 默认值可以并存，不能机械删除任何一侧；实例选择器仍只负责规格、形态、语义和交互。`TText` 同理保留单实例 `style`，并保留 `TTextThemeData` 提供的 TDesign 字体及原生继承不能完整替代的段落默认能力。`DefaultTextStyle`、显式 Material `TextTheme`、组件 Theme 与实例 `style` 逐字段解析并测试优先级；不能把默认 Demo 的样式补丁当作组件实现。
- 无显式字体的独立 `TText` 使用小程序 `packages/components/paragraph/paragraph.less` 中 `@font-body-medium` 的 14dp/22dp 语义，而非 `fontBodyLarge` 16dp/24dp；组合组件传入的内置文字默认值、显式 Flutter 主题、组件 Theme 与实例样式仍按既定优先级覆盖。这个默认字号/行高变化属于可见 breaking 行为，须列入迁移与 Golden 审查。
- Avatar 默认图标与文字的前景色只由 `TAvatarThemeData.foregroundColor` 控制；移除组件 Theme 中可同时设置颜色的 `textStyle`。字符头像仍按 `size` 使用内置字号与字重，特殊排版由调用方传入带样式的 `child: Text(...)`，不为通用 `Widget child` 再增组件级文字样式入口。
- Popover 蒙层色和气泡圆角只由 `TPopoverThemeData.barrierColor/borderRadius` 控制；移除 `TPopoverAnchor` 与 `TPopover.showPopover` 的同义实例字段 `overlayColor/radius`。单个气泡可包裹局部 Theme；`borderRadius` 使用 `BorderRadius` 保存原实例圆角的逐角表达能力。默认值仍沿组件原有回退，不以旧 Golden 自动裁定。

## 验收标准

- [ ] Theme/API 重叠字段有逐项所有权、迁移与 breaking 风险结论；已实施范围无重复行为控制源。
- [ ] 受影响组件的默认值及自定义全局 Token、组件 Theme、实例配置路径均有测试。
- [ ] Flutter 3.32.0 与 latest 的受影响功能测试和定向分析通过。
- [ ] Linux 3.32.0 对受影响 Golden 先做无更新比对，逐项记录值变化、实现缺陷、旧基线或未裁定项，不直接批量更新。
- [ ] 报告区分已修改、仍有风险和 Golden 未通过的原因，不宣称未验证的 804 项全部对齐。

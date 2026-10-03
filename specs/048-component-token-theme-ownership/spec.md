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
- 同一具体视觉字段只能有一个 TDesign 公开配置入口。已有实例完整 `style` 能表达该字段时，不再在组件 Theme 或独立实例标量中开放同义字段；没有完整 `style` 时由组件 Theme 控制可复用视觉值，实例 API 只保留状态、规格、结构选择与交互。全局 Token 是未配置时的默认来源，不是另一份组件配置入口。
- 统一归属标准：实例 API 选择离散的组件规格与语义（如 `size`、`variant`、`colorPreset`、`shape`）、内容、状态、交互与回调；组件 Theme 优先定义可供子树复用的具体视觉数值（如高度、内边距、字号、颜色、边框宽度、圆角、阴影）。因此 `size: small` 属 API，而 small 对应的高度/字号/间距属于 Theme 或其全局 Token 回退。不得在 Theme 再设 `defaultSize`/`variant`。若具体视觉值本身是每实例的核心输入（如单个图标的颜色/物理尺寸），可由 API 持有，但必须移除组件 Theme 的同义字段；不得两边同时保留。不是所有原始数值都必然开放 Theme 字段，须有稳定定制需求且能保持 Token 回退。
- 所有 TDesign 组件统一使用单向主题链：实例显式样式（若存在）→ 组件 ThemeExtension 显式字段（若不存在同义实例入口）→ 全局 TDesign Theme/Token → 已文档化的内置默认值。Material `ThemeData` 仅承载这些 TDesign ThemeExtension，并可接收 TDesign Token 向原生 Material 控件的投影；`ColorScheme`、`TextTheme`、`IconTheme`、Material 组件 Theme、`DefaultTextStyle` 等外部 Material 样式不反向控制 TDesign 组件。组件内部传递给原生子控件的已解析样式不属于反向输入。避免保留按最终值猜测“显式 Material 配置”的兼容桥接。
- `colorPreset` 只选择内置配色，不进入组件 Theme，也不表示 Material `ColorScheme` 实体；`variant` 决定填充、描边等绘制处理，`status` 决定当前业务状态。业务状态、回调和内容不进入组件 Theme；`size`/`variant`/`shape` 等离散规格选择也不进入组件 Theme。视觉开关若只是渲染装饰且无实例语义，优先 Theme；若改变组件交互或结构，则留在 API 并写明理由。
- `TButton.colorPreset` 仅选择内置调色预设，不是对各绘制字段的实例样式覆盖。单实例的具体背景、前景、描边及交互状态通过 `TButton.style` 覆写；不再读取显式 Material 按钮主题。组件 Theme 不再提供与 `ButtonStyle` 同义的字段。
- Button 主色填充禁用态的浅色前景沿用反色文字，深色前景使用小程序组件变量 `--td-button-primary-disabled-color` 的 `fontWhite4` 回退；实例 `ButtonStyle` 仍是唯一显式覆盖入口。
- Switch 禁用和加载分别解析轨道、滑块及加载内容颜色，不对整个组件统一施加透明度。可交互滑块填充回退 `textColorAnti`；开启/关闭的禁用轨道分别回退 `brandColorDisabled` / `bgColorComponentDisabled`，禁用滑块浅色回退 `fontWhite1`、深色回退 `fontWhite2`；加载内容浅色回退品牌色、深色回退 `fontWhite1`。这些具体视觉值可由 Switch 组件 Theme 覆盖，不增加状态型实例 API。
- Slider 禁用滑块的默认描边以已核对的设计稿为准：浅色 `componentBorder`（`#DDD`），深色继续使用 `bgColorComponentDisabled`；已有 `disabledThumbBorderColor` 是唯一组件级显式覆盖入口。设计稿与小程序浅色回退 `#F3F3F3` 的分歧保留在审查报告中，不修改全局 Token。
- 动画时长若直接决定单次组件交互的展开/收起时间，归实例 API；Theme 可承载动画曲线、颜色或尺寸等不与该时长同义的视觉默认值。系统“减少动态效果”始终优先于实例时长。
- 无法由同值比较证明视觉等价的字体、阴影、百分比几何及响应式尺寸须独立记录；全局 `radiusCircle` 维持已记录的 Flutter 固定半径例外。
- 本轮收敛 `TButton`、`TInput`、Dialog action 已有完整实例 `style` 所覆盖的视觉字段，并去除 `TTagThemeData.fontWeight` 与 `font` 的重复设置；`TTabsBar` 的容器背景/分割线归组件 Theme，不再保留实例完整装饰入口。`TText` 的单实例完整样式、SwipeCellAction 的逐项外观和 Popup 蒙层透明度入口已按下文迁移；这仍不等于全仓所有组件都已满足单入口标准。
- 无显式字体的独立 `TText` 使用小程序 `packages/components/paragraph/paragraph.less` 中 `@font-body-medium` 的 14dp/22dp 语义，而非 `fontBodyLarge` 16dp/24dp；文字样式统一由全局 TDesign Token/Theme、组件 Theme 与实例样式逐级覆盖，不从 Material `TextTheme` 或 `DefaultTextStyle` 的最终值推断显式配置。Material 文本主题仅作为原生 Flutter 控件的投影。这个默认字号/行高与继承行为变化属于可见 breaking 行为，须列入迁移与 Golden 审查。
- Cell、Popup 等接收任意标题 Widget 的组合组件，其自身标题样式必须在内部同时提供给 `TTextThemeData.textStyle` 与原生 `DefaultTextStyle`：前者供未显式设置样式的 `TText` 消费，后者供原生 `Text` 消费。子节点显式 `TText.style` / `Text.style` 仍优先；此局部组件样式不等于从外部 Material `TextTheme` 或 `DefaultTextStyle` 自动推断 TDesign 样式。
- Avatar 默认图标与文字的前景色只由 `TAvatarThemeData.foregroundColor` 控制；移除组件 Theme 中可同时设置颜色的 `textStyle`。字符头像仍按 `size` 使用内置字号与字重，特殊排版由调用方传入带样式的 `child: Text(...)`，不为通用 `Widget child` 再增组件级文字样式入口。
- Avatar 的形状选择只保留 `TAvatar.shape`；移除已弃用且与其一一等价的 `variant` 参数和 `TAvatarVariant`。圆形、方形以及头像组成员裁剪、描边和阴影必须由同一形状及有效圆角决定；默认正圆视觉不变，自定义较小 `radiusCircle` 时组外框不得仍强制绘制为正圆。
- Avatar Theme 的尺寸、图标尺寸、组描边宽度及圆角存在随成员规格或全局 Token 变化的回退值。与显式 Theme 值插值时须在成员最终规格和全局 Token 已知后解析两端有效值；不能在 `ThemeExtension.lerp` 中预设中号尺寸或固定全局圆角。两端均未配置时继续由组件读取实时回退值。
- SideBar 的标签排版由组件 Theme 的未选中、选中样式分别控制；移除 `TSideBarItem.textStyle`，避免选中项上的实例样式被 Theme 的 `selectedTextStyle` 整体替换。每项数据只保留内容、状态和身份信息。
- SideBar 的 `textStyle.color` 只控制未选中态；选中态优先 `selectedTextStyle.color`，否则品牌色；禁用态始终禁用色。选中态可继承未选中样式的排版字段，但不得继承其颜色。图标、指示线与标签的状态色保持一致。
- Tag 的方形、圆角、标记形状由 `TTag.shape` 和 `TSelectTag.shape` 选择；Theme 只负责选定形状后的具体圆角等视觉值，不再保存 `shape` 选择器。
- Tag 前置图标与正文共用组件 Theme 或全局 Token 解析后的前景色；禁用色仍由状态决定，关闭图标继续读取独立的占位色 Token。显式 Material `ColorScheme` 不改变 Tag 外观；其余组件遵循同一单向规则。
- `TTextSpan` 是独立 Span 局部样式入口，仅保留 Flutter 原生 `style`；移除与 `style` 同义的字体、颜色和删除线便捷参数，未指定样式时继续继承父 Span。
- `TTextThemeData` 的子树级字号、行高、字重、颜色统一放在 `textStyle`；删除同层级的 `font`，Text、Cascader、Picker 对这一主题使用同一条消费链。实例保留 `font` 作为 TDesign 字体 Token 预设，完整 `style` 用于同一实例的显式覆写；删除与 `style` 同义的 `fontWeight/fontFamily/textColor/isTextThrough/lineThroughColor` 实例字段。解析顺序为实例 `style` > 实例 `font` 预设 > 子树 Theme `textStyle` > 全局字体 Token。
- Popover 蒙层色和气泡圆角只由 `TPopoverThemeData.barrierColor/borderRadius` 控制；移除 `TPopoverAnchor` 与 `TPopover.showPopover` 的同义实例字段 `overlayColor/radius`。单个气泡可包裹局部 Theme；`borderRadius` 使用 `BorderRadius` 保存原实例圆角的逐角表达能力。默认值仍沿组件原有回退，不以旧 Golden 自动裁定。
- TabBar 顶部分隔线与 Item 之间的竖线虽然在小程序共用 `--td-tab-bar-border-color` 名称，但当前 Flutter 上边线固定读取 `borderLevel1Color`，竖线可由组件 Theme 的 `dividerColor` 覆盖，默认读取灰阶 3。已删除的 `topBorder`、`showTopBorder` 与 `centerDistance` 不在 Theme 中恢复，也不增加兼容回退；迁移文档必须准确说明能力删除。
- SideBar 的选中前景色只由 `TSideBarThemeData.selectedTextStyle.color` 配置；同一个颜色用于选中文字、图标和指示线。移除同层同义的 `selectedColor`，没有显式颜色时仍读取全局品牌色，字体等文字样式继续由 `selectedTextStyle` 控制。
- `TText` 通过完整实例 `style` 覆写单项文字，子树级完整文字样式由 `TTextThemeData.textStyle` 提供默认；两者作用范围不同且按字段合并。内部组合组件已按各自状态计算的逐项文字样式继续由私有解析路径交给 Flutter 原生 `Text`。`TTextSpan` 的 Span 局部样式与父文字样式属于不同富文本层级，单独保留其 Flutter `TextSpan` 语义。
- SwipeCell 的操作项视觉由每个 `TSwipeCellAction` 的实例参数控制；组件 Theme 只保留没有实例同义入口的面板/操作项内边距。操作项的背景、图标、文字默认值从全局 Token 取得，不再通过同义 Theme 字段或 Flutter Material 主题配置。`builder` 与全部内置视觉参数互斥；debug 构造及 release 绘制均须拒绝冲突配置，防止静默忽略参数。
- Popup 的 `TPopupOptions` 管单次方向、尺寸、蒙层行为和生命周期；`TPopupThemeData` 管子树面板背景/圆角及蒙层颜色。蒙层 alpha 只使用 `Color` 自带 alpha，不再叠乘独立 opacity。单次动画时长由 Options 持有，不再在 Theme 保存另一份同义默认。Options 的 `radius/backgroundColor` 暂保留供 ActionSheet 等组合组件传入单次面板外观；其与 Theme 是单次覆盖/子树默认，不另设第三种别名入口。

## 验收标准

- [ ] Theme/API 重叠字段有逐项所有权、迁移与 breaking 风险结论；已实施范围无重复行为控制源。
- [ ] 受影响组件的默认值及自定义全局 Token、组件 Theme、实例配置路径均有测试。
- [ ] Flutter 3.32.0 与 latest 的受影响功能测试和定向分析通过。
- [ ] Linux 3.32.0 对受影响 Golden 先做无更新比对，逐项记录值变化、实现缺陷、旧基线或未裁定项，不直接批量更新。
- [ ] 报告区分已修改、仍有风险和 Golden 未通过的原因，不宣称未验证的 804 项全部对齐。

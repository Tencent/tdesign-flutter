# Theme 配置与隔离契约：设计说明

<a id="source-048"></a>
<a id="source-051"></a>
<a id="source-055"></a>
<a id="source-078"></a>
<a id="source-053"></a>
<a id="source-054"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

全局 Token、组件 Theme、实例参数及外部 Material 主题曾形成重复配置源，静态同值也无法证明运行消费正确。


## 范围与非目标

覆盖本工程职责的设计与验收边界；不将目录整理扩展为新的组件能力、发布动作或远端配置修改。

## 最终方案与行为契约

### 配置分层

- 全局 Token 由 `TThemeData` 承载，提供颜色、字体、尺寸、间距、圆角、阴影等默认来源；未显式覆盖时必须保持动态回退。
- 实例 API 负责内容、状态、规格、结构、交互与回调；组件 Theme 负责有子树批量定制需求的具体视觉默认值。
- 同一具体视觉字段只保留一个明确的显式配置入口，避免实例参数、完整 style、组件 Theme 三处同义配置。
- 支持完整实例 style 时，其显式字段优先；没有同义实例入口时由组件 Theme 覆盖；再回退全局 Token 和已文档化的内置默认值。不得通过同值比较猜测配置是否显式。

### 组件职责与优先级

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

### TThemeData 实例操作

- copyWith 和 lerp 返回 TThemeData，可直接访问 Token、继续复制或赋值给具体类型。
- 移除 copyWithTThemeData 和 ofColor/ofFont/ofCorner/ofFontFamily/ofShadow；动态查询统一通过相应 Token Map。
- parseThemeData 收为私有；公开 JSON 解析统一 fromJson。
- 间距复制参数 marginMap 改为 spacerMap，与字段一致；省略或传 null 的 name 保留原名。
- 移除非必要的 ofExtra 泛型查询包装；业务扩展通过 extraThemeData 字段读取并判断类型。
- 仓库消费者迁移至 copyWith(name: ...)，删除可证明冗余的复制/过渡结果强制转换。
- Token 增量合并、引用链解析、默认回退、空值行为、extraThemeData 继承保持；原 default 名称重置修正为保留当前名称。
- lerp 的 t=0/1 返回两端；空目标返回当前主题；连续 Token 按有效查询值插值，单侧存在的值保留。名称、字体族、业务扩展及明暗关联在 t=0.5 切换。
- 插值覆盖本地、引用与回退键；引用相同且两端无显式覆盖的别名继续保持引用，其余有效值形成独立 Map。字体尺寸与行高保持小数精度。
- 动态 Token 查询、JSON 解析和主题构建能力保留。

TD 内置视觉和行为只接受受支持的实例参数/style、TD ThemeExtension 和 Token。外部 M2/M3 默认及显式主题不作为隐式配置入口。内部可以使用 Material 原生控件，但必须明确视觉及可配置行为的默认值。调用方自定义内容使用原始主题，组件已公开的内容默认样式继续提供。

- Button/IconButton 反馈、鼠标指针按实例/TD Theme 当前状态的非空值回退到 TD 内部默认值，不再读取 Material 按钮主题。Button.style.visualDensity 仍不生效。
- Tooltip 的文字、装饰、尺寸、时长、触发、反馈和语义由内部明确；不透传 TooltipTheme。自定义内容中的 Tooltip 不受影响。
- 内部编辑器的选择颜色、手柄和默认自适应菜单隔离外部视觉主题；保留选择、编辑、剪贴板、平台菜单操作、键盘、控制器、焦点和语义。前后缀不进入编辑器隔离范围。
- TText 默认选择高亮使用 TD brandColor 的 40% alpha，显式 selectionColor 仍优先；不改变祖先 SelectionArea 的选择注册及调用方菜单。
- TD 内部滚动视图使用私有滚动行为，不读取外部 MaterialScrollBehavior / ScrollbarTheme 的视觉或交互配置；取消主题选择的 glow/stretch，桌面原生滚动条由 TD 明确配置。已有公开 physics 等参数继续生效。隔离不传播给自定义内容内部的滚动视图。
- Collapse 明确前置内容居中；Slider 固定当前布局版本及 overlay 半径，不以零 padding 改变现有布局；Button 明确最大尺寸/对齐/动画；加载圆环明确约束和 padding；内部表面关闭 elevation overlay。
- 亮暗模式、平台、语言、方向、系统缩放和无障碍环境继续响应。禁止外部主题控制业务状态，不禁用内部原生能力。
- 实例状态属性仅覆盖非空值，回退到同状态 TD 默认值；显式透明、无边框及自定义图层保持原语义。

### 视觉密度隔离

- Button 最终布局使用标准密度；全局、Material 按钮主题和实例 ButtonStyle.visualDensity 均不能改变组件内置布局。普通和渐变分支一致。
- Button 实例 style 的其他字段继续生效，调用方 child 和 icon 保留原主题上下文；字体缩放仍可撑高内容，tapTargetSize 保留原契约。
- Input 仅对内置 TextField 和清除、密码操作按钮隔离密度。内置装饰沿用既有专属 API 所有权，不继承 Material InputDecorationTheme；外层错误文字仍读取原 errorStyle。原主题其他字段继续继承，prefix、suffix 保留调用方上下文。
- Input 的尺寸不受 ThemeData.visualDensity 或内置操作按钮的 IconButtonTheme 密度影响；编辑、清除、密码切换、disabled/readOnly 行为不变。
- Table 选择框继续依赖 TCheckbox 自身规则与表格约束，移除其不消费的 Material CheckboxTheme。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 具体字段只保留一个明确的显式入口，未配置时动态回退；Material 只承载或接受投影，不反向决定 TD 默认外观。 |
| 保留的边界与代价 | 隔离外观不能关闭原生交互或污染自定义内容；Token 验证作为契约验收而非另建设计方案，承认功能、像素与设备证据边界。 |

### 设计演变中的关键理由

组件实现、示例、公开注释、测试和工具随契约同步维护；删除入口或改变默认行为时明确 breaking 与迁移方法。隔离 Material 主题不能破坏原生交互、自定义内容或系统环境响应。

### 稀疏配置与中断插值的设计依据

- 稀疏 `sizeMap` 不能直接把缺失端点取成另一端：默认 size8=24 向显式 40 过渡时，25% 应为 28，不能跳到 40。getter 与插值共用默认集合，只为尺寸映射补有效默认端点；其他映射保持各自解析规则。
- Tag 统一 padding 与分档 padding 的优先级保持原约定，但显式 `copyWith(smallPadding: ...)` 必须清除该档旧过渡；再次插值不能用遗留的统一过渡覆盖它，未改动档位仍保留自身完整过渡。
- 组件几何默认值依赖实时 Token 和最终规格时，nullable Theme 字段的插值在消费端解析两端有效值，不能把缺失值当零或固定旧常量。例如 Table 默认 padding 回退 spacer1、BackTop 起点随自定义 size13 变化。覆盖双向端点、中间值、Directional、copyWith、显式清除和中断后重启。
- Search 的 IconThemeData 整体替换沿用对象替换语义；新对象未指定 size 时回退全局默认，不继承已替换对象的旧过渡。ThemeExtension 同类型合并仍是替换，部分更新使用原扩展 copyWith。

### 视觉证据选择的取舍

- 真实设计绑定、用户授权的同默认消费点和组件独立配置分别记录；不为 Button 18dp 图标、Badge 气泡圆角或 Tag 净间距伪造全局刻度，不将同值常量冒称上游别名。Tag 分档显式 padding 为边框内净间距，默认盒模型与小程序透明边框差异独立说明。
- BackTop 的中文验证必须通过 TD 字体 Token 配置仓库 CJK fallback，仅配置 Material 字体不能证明 TD 文字正常。Cell 卡片边框用于显露默认圆角，Tabs 采用自然宽度和真实切换场景；均分布局不能证明默认 padding 变化。
- 默认外观变化及从常量转为动态 Token 消费均可能 breaking；即使默认截图相同也须核对联动范围。缺少单属性旧值恢复入口的情况必须说明，不能承诺全面恢复旧视觉。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

覆盖全局 Token、组件 Theme、实例 style 的真实消费、空值回退、动态更新和中断插值；迁移公开字段时同步注释、独立消费测试和 breaking 说明。通过测试不代表所有组件已经完成所有权审查。
忽略外部 Material 视觉主题、密度或原有同义配置入口属于公开行为变化，按实际影响记录 breaking 及迁移方法。保留原生焦点、选择、编辑、键盘、语义、滚动和调用方自定义内容的主题上下文。
必须验证外部 Material 配置不改变 TD 内置视觉、TD 显式配置仍有效、调用方内容保留主题和交互；密度 -4/0/+4、M2/M3、明暗、字体缩放、显式尺寸及实际命中区域都需覆盖。视觉验证遵循 Golden 规范。
补充契约：[渐变按钮几何](./gradient-geometry.md)、[严格边界](./strict-boundary.md)、[Swiper 控制按钮](./swiper-control-style.md)。
Token 真实消费、覆盖路径和视觉证据属于本契约的验收，不另设 Spec。见 [Token 运行验证](./acceptance.md#token-runtime-verification)、[未关闭事项](./tasks.md#token-逐项缺口) 与 `evidence/`。主题输入与同步由独立的 ThemeController Spec 负责。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

## 组件文字槽遗漏修复（patch 提交边界）

沿用已发布 1.0.0 的组合文字槽契约：组件已有文字默认值同时提供给 Text/TText；修复 Avatar、Calendar 副标题、Collapse、Divider、Link、Progress、Table 和内部 Toolbar 的 TD 样式漏接。Drawer 标题已接入 TD 样式，仅修复替换主题时丢失既有 TD 段落配置。

保留每处原生 Text 的段落边界：原先 merge 的位置继续合并祖先段落设置，原先 DefaultTextStyle 构造的位置继续使用组件的段落回退。不以提供字体默认值为由改变 maxLines、softWrap、overflow、textAlign、textWidthBasis 或 textHeightBehavior。显式子样式与内容内部更近主题优先。

Popover 仅修复依据实际样式、支柱、缩放与段落参数的自然尺寸测量。直接 Text 保留既有气泡样式，TText 保留自身文字主题，组合内容仍自行定制；不新增内容子树默认样式。测量不会改变显式尺寸或显式样式的布局路径。

本节仅描述 patch 提交；自定义内容默认值统一由后文 minor 增量提供。patch 不修改全局 TText、工具链、工作流、既有 Golden 基线，不把 minor 的两张已审阅截图带入本 patch。

## 自定义文字槽统一（minor）

在 patch 修复之上，将 Popover 内容子树、Drawer 菜单正文、Toast 自定义文案、Picker itemBuilder、Steps 自定义标题/说明、TabBar 弹出菜单自定义项统一为“组件拥有文字槽默认字体”。不改变全局 TText 隔离、不新增配置；显式字段与内容内部更近的文字主题优先。仅设置颜色的实例仍继承其余组件字体字段。

只传递字体，保留原生 Text 的段落语义及业务自定义内容的换行/溢出控制。TabBar 自定义项自动高度按真实内容测量，至少保留原 48dp 行高；原生内置项及显式高度继续沿用原布局。自定义 Column/Expanded 等需要确定高度的内容继续使用既有 popUpItemHeight。

本节扩展原来的自定义默认值，按 minor 交付并提供迁移说明；不将其冒充既有契约的 patch。发布日期与包版本号由正式发布流程决定。

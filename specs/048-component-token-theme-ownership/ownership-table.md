# Theme/API 所有权判定表

这份表记录公开控制入口的判定，不把同名字段数量直接当作问题数。2026-09-27 的 AST 初筛得到 116 个同名候选对；按 `tdesign_flutter.dart` 实际导出范围过滤后，本批迁移后公开**同名候选为 0**。该扫描未覆盖异名同义字段、完整 `ButtonStyle`/`TextStyle` 或间接包装组件，因此不能据此宣称完成全仓语义收敛；具体剩余项见 [阶段报告](./report.md)。

| 场景 | 唯一所有者 | 判断依据 | 例子 |
| --- | --- | --- | --- |
| 内容、受控状态、回调、交互行为 | 实例 API | 随单个组件实例变化；Theme 不应改变业务行为 | `value`、`onChanged`、`clearable` |
| 离散规格和呈现语义 | 实例 API | 调用方选择哪一种预设，Theme 负责预设的具体外观；Material `ColorScheme` 仍是实际调色板 | `size: small`、`variant: card`、`colorPreset: danger`、`shape` |
| 规格对应的视觉数值 | 组件 Theme，未设置则回退 Token | 同一子树复用；不应硬编码冻结全局 Token | small 的高度、字号、内边距；边框色和阴影 |
| 每实例布局约束或核心视觉输入 | 实例 API，可例外 | 例如图标单体尺寸/颜色与现有 Flutter `IconTheme` 配合；此时不得再有同义组件 Theme 字段 | `TIcon.size/color` 待迁移审计 |
| 装饰性开关 | 逐项判定 | 离散预设选项归 API；仅配置绘制细节的视觉参数归 Theme | `TTable.bordered/stripe` 归 API，颜色归 Theme |

## 已确认的迁移

| 组件 | 原重复入口 | 保留入口 | 移除入口 | 默认视觉变化 | 兼容性 |
| --- | --- | --- | --- | --- | --- |
| SearchBar | `TSearchBar.variant` / `TSearchBarThemeData.variant` | 实例 `variant` | Theme `variant` | 未提供实例值时仍为 square；Navbar Demo 显式传 round | 删除已发布 Theme 字段，breaking |
| Collapse | `TCollapse.variant` / `TCollapseThemeData.variant` | 实例 `variant` | Theme `variant` | 未提供实例值时仍为 block；card 测试改由实例选择 | 删除已发布 Theme 字段，breaking |
| Table | `TTable.bordered/stripe` / 同名 Theme 字段 | 实例 `bordered/stripe` | Theme `bordered/stripe` | 未提供实例值时仍关闭；Theme 仅保留尺寸和颜色 | 删除已发布 Theme 字段，breaking |
| Link | 旧实例 `size/colorScheme/underline` / Theme `defaultSize/defaultColorScheme/underline` | 实例 `size/colorPreset/underline` | Theme 三项选择器及旧实例 `colorScheme` | 默认 medium / defaultTheme / 无下划线不变，Theme 继续控制文字和图标视觉值 | 删除已发布 Theme 字段并重命名实例字段，breaking |
| Cell / CellGroup | 实例 `align/variant` / Theme `align/groupVariant` | 实例两项选择器 | Theme 两项选择器 | 默认居中 / standard 不变，Theme 继续控制尺寸、颜色和间距 | 删除已发布 Theme 字段，breaking |
| Input / Textarea | 实例 `clearButtonMode/cursorColor/minLines` / Theme `clearButtonMode/cursorColor/multilineMinLines` | 实例三项；光标全局默认可继承显式 Material `ColorScheme.primary` | Theme 三项 | 默认无清除按钮、4 行多行输入和品牌光标色不变；Theme 继续控制清除图标尺寸、颜色等 | 删除已发布 Theme 字段，breaking |
| Switch | 实例 `size/variant` / Theme `defaultSize/defaultVariant` | 实例两项选择器 | Theme 两项选择器 | 默认 medium / filled 不变；Theme 继续控制轨道和滑块视觉值 | 删除已发布 Theme 字段，breaking |
| TimeCounter | 实例 `size/variant` / Theme `defaultSize/defaultVariant` | 实例两项选择器 | Theme 两项选择器，改为实际的默认/块文字色、块背景色和方/圆块圆角 Theme 字段 | 默认 medium / plain 不变；正方形 round 默认视觉像素不变，自定义 `radiusCircle` 可生效 | 删除已发布 Theme 字段，新增具体视觉字段，breaking |
| DropdownMenu | 实例 / Theme `animationDuration` | 实例交互时长 | Theme 时长 | 默认 200ms 不变，系统减少动态效果仍置零 | 删除已发布 Theme 字段，breaking |
| Collapse | 实例 / Theme `animationDuration`、`elevation` | 实例交互时长、Theme 阴影 | Theme 时长、实例阴影 | 默认 Flutter 主题动画时长和 0 阴影不变 | 双向删除已发布字段，breaking |
| 全局圆角 / BackTop | `radiusCircleBorder` 额外公开辅助形状 | `radiusCircle` 固定 dp Token；BackTop 内部构造边框 | 辅助 API | BackTop 正圆默认仍为 48×48 且半圆使用 `radiusRound`，移除误用入口 | 辅助 API 属本分支未发布变更；已发布 `radiusCircle` 保持原语义 |
| Stepper | 实例 / Theme `size/variant` | 实例选择器 | Theme 两项 | 默认 medium / normal 不变；直接 Theme 插值以 medium 为几何默认，渲染插值使用实例规格 | 删除已发布 Theme 字段，breaking |
| Button | 实例 `size/variant` / Theme `defaultSize/defaultVariant` | 实例选择器 | Theme 两项 | 默认 medium / fill 不变；Theme 的具体 `ButtonStyle`、padding、形状继续生效 | 删除已发布 Theme 字段，breaking |
| TabsBar | 实例 / Theme `indicator` | Theme 指示器装饰 | 实例 `indicator` | 默认 Line/Tag/Card 指示器行为不变；公开 Demo 自定义指示器改由局部 Theme 提供 | 删除已发布实例字段，breaking |
| Avatar / AvatarGroup | 实例 / Theme `size/shape/variant`、背景/前景/文字样式、`dimension` | 实例尺寸与形状；Theme 颜色、字体、物理边长 | 另一侧同义字段 | 默认尺寸、颜色不变；Demo 的配色改用局部组件 Theme，页面实际截图 SHA 与迁移前一致 | 多个已发布 API 删除，breaking；单项 Theme 动画默认几何仍需检查 |
| Indexes | 实例 / Theme `indexListMaxHeight` | Theme 高度比例 | 实例字段 | 默认 0.8 不变，组件测试通过 | 删除已发布实例字段，breaking |
| Swiper | 实例 / Theme `paginationAlignment` | Theme 对齐 | 实例字段 | 默认值不变；Demo 自定义对齐改用局部 Theme | 删除已发布实例字段，breaking |
| Icon | 实例 / 组件 Theme `size/color` | 实例值及 Flutter 标准 `IconTheme` 子树默认值 | `TIconThemeData` 整个扩展 | 默认 Token 颜色和尺寸不变；Cascader 改用显式 `IconTheme` | 删除已发布 Theme 类，breaking |
| Avatar / Skeleton 圆形块 | 固定宽度一半圆角忽略自定义 `radiusCircle` | 组件 Theme 圆角或全局 `radiusCircle` | 固定宽度一半回退 | 默认正方形视觉逐像素不变；自定义固定 dp 圆角可传导 | 非正方形与 CSS 50% 仍有已批准跨端几何风险 |
| Drawer、SideBar、NavBar、TabBar | 实例视觉数值与同名组件 Theme | 组件 Theme | 实例视觉字段，TabBar `centerDistance` 仅留 Theme | 默认值不变，局部 Demo Theme 保留定制场景 | 公开实例字段删除，breaking |
| Dialog / TConfirmDialog | 面板背景、形状、阴影、宽度、高度、内容内边距 | 组件 Theme | 实例对应字段 | Linux 3.32 的 Dialog Demo 16 项功能测试及图片场景浅色 Golden 通过 | 公开实例字段删除，breaking |
| Form | 标签宽度/文字对齐双入口、表单项区域对齐双入口 | 标签宽度/文字对齐归 Theme；单项区域对齐归实例 | 另一侧同义字段 | 61 项组件测试通过 | 公开字段删除，breaking |
| Text（旧阶段结论） | 子树组件默认值、Flutter 文字继承、单实例 `style`/段落参数 | 旧阶段保留 `TTextThemeData` 的字体 Token、文字和段落默认值；最新严格单入口规则下还未迁移 | 实例便利样式与 Theme 字体/文字样式待重新裁定 | 旧阶段 Text/Cascader/Picker 主题路径测试通过；不构成本轮单入口验收 | `font` 等已发布调用点数量大，须先完成替代写法与外部编译 |
| Popover | 箭头显示和具体视觉数值双入口 | `showArrow` 归实例；偏移、箭头尺寸、内边距归 Theme | 另一侧同义字段 | 65 项组件测试、定制内容浅色 Golden 通过 | 公开字段删除，breaking |
| Avatar 文字样式 | Theme `foregroundColor` / `textStyle.color` 同时决定默认文字颜色 | Theme `foregroundColor` 控制默认文字与图标前景；特殊文字由 `child: Text(style: ...)` 提供 | Theme `textStyle` 整字段 | 默认字号与字重继续随 `size`；单独文字内容仍可定制 | 删除已发布 Theme 字段，breaking |
| Popover 蒙层与圆角 | 实例 `overlayColor/radius` / Theme `barrierColor/borderRadius` | Theme `barrierColor/borderRadius`；单实例用局部 Theme | 实例两字段；Theme `borderRadius` 改为 `BorderRadius?` 以保存逐角能力 | 默认透明蒙层与全局圆角回退不变；旧 Golden 差异单独裁定 | 删除已发布实例字段、Theme 字段改型，breaking |
| Button 完整样式 | 实例 `ButtonStyle` 与 Theme 的四种样式、内边距重叠 | `TButton.style`；离散 `shape` 由实例选择，Theme 仅保留渐变与图文间距 | Theme 的 `filledStyle/outlinedStyle/textButtonStyle/ghostStyle/padding/shape` | 相关非 Golden 功能测试通过 | 子树批量 ButtonStyle 需在调用方共享样式，公开字段删除属于 breaking |
| Input 已输入文字 | 实例 `style` 与 Theme `textStyle` 重叠 | `TInput.style`，禁用态优先使用禁用 Token | Theme `textStyle` | 相关功能测试通过 | 公开字段删除属于 breaking |
| Dialog 操作按钮 | action `style` 与 Theme `actionButtonStyle` 重叠 | `TDialogAction.style` / `TConfirmDialog.buttonStyle` | Theme `actionButtonStyle` | 相关功能测试通过 | 公开字段删除属于 breaking |
| TabsBar 容器装饰 | 实例 `decoration` 与 Theme 背景/分割线重叠 | `TTabsBarThemeData` 对应视觉字段 | 实例 `decoration` | 相关功能测试通过 | 自定义 BoxDecoration 的复杂背景需在外层容器承担，不再是 TabsBar 自身能力 |
| Tag 字体 | Theme `font` 已含 `fontWeight`，又单独开放字重 | `TTagThemeData.font` | Theme `fontWeight` | 相关功能测试通过 | 公开字段删除属于 breaking |

## 待逐项裁定

| 组件或字段族 | 需要检查的点 | 风险 |
| --- | --- | --- |
| 原生 `ButtonStyle` / `TextStyle` 逃逸入口 | 异名同义样式入口尚未单一化，需选择是否保留 Flutter 原生标准例外 | 若一律按同义删除，可能丢失 Flutter 标准能力；若保留，需精确定义例外 |
| 各组件 CSS 变量与 Flutter Theme 字段 | 校验默认表达式、全局回退、数值换算及未开放字段 | 804 个小程序组件变量已按冻结源码列静态证据，尚未全部最终消费验证 |

不能仅靠 `Widget 参数 ?? Theme 字段 ?? Token` 的优先级把重复入口判为合理；它仍给同一行为提供两套公开写法。相反，`size: small` 与 Theme 的 `smallHeight` 不同义，前者选择规格，后者定义该规格的物理值。

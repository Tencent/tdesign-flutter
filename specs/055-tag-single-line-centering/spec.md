# 内置单行文字留白与垂直对齐

排查全部组件的内置文字、可换行段落、文字插槽与输入路径。验收目标是组件内容区内真实绘制行与整体内容的位置正确，不能仅以外层布局框居中、测试通过或快照更新认定通过。需要居中的标签、数字和状态内容块按内容槽验收；正文、帮助、多行编辑按顶部或基线契约验收，调用方 Widget 只由组件负责整体摆放。

内置单行文字默认均分字体额外行高，保留原字体 Token、行高、溢出与缩放行为；默认内容槽以设计尺寸为下限，必要时随内容增长，显式尺寸仍生效。固定数字、星期、索引等短文本使用相同策略，不额外限制换行。最终解析后仅在 leadingDistribution 未指定时补 even；实例 style、组件 Theme 和 TTextThemeData 的显式值保持有效。

内置单行使用与最终字体、行高一致的默认 StrutStyle，避免中英文回退字体混排把行盒撑高。仅用于隐式 even 默认值；显式 leadingDistribution、strutStyle 和 textHeightBehavior 保持原生行为。测量与绘制共享同一支柱配置。

多行配置、公开 TText/TText.rich、调用方自定义 Widget 和段落原生能力保持原行为。可换行文字不能仅因当前文案短就强制改成单行；不以字符串裁切、位移或逐字符像素测量实现居中。此策略改善排版留白，不承诺所有字体与字形零像素光学偏差。

Input 与 Search 的单行编辑文字和提示文案采用一致策略；Textarea 保留多行排版。Switch 的内置行高仅提供默认值，不覆盖显式 TD 行高。Picker、Badge、Rate 原有均分留白统一在最终文字解析阶段回退。

无公开 API 新增或删除，不包含 DateTimePicker 连续滚动修复。逐组件处理范围见 component-review.md；验收覆盖单行长短文案、中英文混排、显式换行、多行、缩放、显式配置、自定义内容、输入选择和原生交互，以及双版本和 Linux Golden。

明确单行先完成自然纵向排版，再用 Flutter 原生 OverflowBox(fit: OverflowBoxFit.deferToChild) 将真实行框居中到内容槽，避免受限 RenderParagraph 的布局框小于绘制行。正常自适应尺寸不变，多行不套此策略。Tag 默认高度作为最小高度，允许缩放文字和图标撑高。Switch 未指定 size 的文字形态随内容增长，显式预设尺寸保留固定几何，滑块内先自然排版后适配；长文案保留可见省略。TimeCounter 未指定 size 的默认数字块随内置文字增长，显式 size 保持固定。Steps 序号容器随自然排版增长，图标实际尺寸与自定义标题/内容保持。

实例与 TD 文字主题的 TextHeightBehavior 实际参与基线计算，默认 even 不遮蔽其 leadingDistribution；Badge 的内置高度行为仅为回退。验收包含实际行框、内容槽中心、裁切、图标关系、状态覆盖与原生交互，兼容性检查仅作为回归门禁，不替代视觉验收。


Picker / DateTimePicker 的默认高度至少为 200，按内置文字的自然行高与 itemCount 增长；显式 TPickerThemeData.height 优先，自定义 itemBuilder 不推测其高度。标准 Picker 弹层采用同一高度。行高切换保留原选中项，不额外发出用户选择回调。

Progress 仅内置百分比的默认 plump / button 轨道高度随内容增长，显式 TProgressThemeData.strokeWidth 与自定义 label 保持原契约。Calendar 默认日期格、星期和月份文字槽随自然行高增长，显式 cellHeight / monthTitleHeight / height 和自定义日期格、月份构建器优先。

Indexes 内置索引和提示的默认尺寸随文字增长，显式 indexItemSize / tipSize 和自定义索引 Widget 保持。索引条超出 indexListMaxHeight 时保持竖向排列并滚动；滚动不选择，点击可见项仍选择，未溢出时保留拖动选中；活动索引、索引序列中的位置、行尺寸或可用高度变化时滚入视窗；仅手动滚动不强制跳回活动项。滚动区域裁切上下越界内容，保留左侧提示气泡。无外部 Material 视觉默认值引入。

ActionSheet 的内置列表项、取消按钮和默认宫格项目随最终 TD 字体及缩放后的内容增长；宫格实例 itemHeight / TD gridItemHeight 显式值仍固定。测量与绘制使用相同 TD 字体、样式、缩放和宽度，描述及分组标题保持段落换行。大字体所需内容超过视窗时仍通过原列表、宫格及分页滚动浏览，原选择、禁用、取消与关闭回调保持。

Refresh 默认 Header 高度及默认刷新阈值至少为 50，必要时随内置四态文字的最大自然高度增长，默认最大下拉范围至少为 80。显式 loadingBarHeight / maxBarHeight 保持固定；显式最大范围限制默认 Header 增长。原生刷新状态机、超时、滚动内容和加载更多阈值保持；该默认大字体阈值变化是内容增长所需的行为调整。

Loading 的内置文字默认使用均分行高留白并在横向布局中按可用宽度换行；显式 TD 文字样式及 refreshWidget / customIcon 的主题与 Widget 内容保持。Loading 本身仍按自然内容布局，动画速度及状态不改。

Calendar 默认月份标题不套用未实际使用过的 Mark 字体；保留原 TText 默认 TD 字体和字重。显式 monthTitleStyle 和 TD 文字主题继续参与最终解析，不改变自定义 monthTitleBuilder。

真机补充：Checkbox / Radio 卡片组按默认高度下限排列，允许内置内容自然增高，不改变选择和指示器尺寸。Textarea 在调用方显式高度中先保留计数器与间距，剩余空间交给原生可滚动编辑区，保持顶部对齐。Upload 默认网格尺寸至少 80，随实际内置文件名及状态行高增长；显式 itemSize 固定，内置自然内容居中到原裁切区域，文件选择、拖拽、状态及自定义 picker 不改。

当显式 Textarea 视窗的剩余空间连计数器也无法完整容纳时，保留父级高度和文字尺寸，内部内容使用原生滚动；编辑器 GlobalKey 保留重排前后的 State、控制器、焦点与输入连接，不以缩字或更改显式高度消除溢出。

PopupHeader 保留原有固定 58 的布局契约，不增加高度 API 或跨层尺寸状态。PickerPopup 使用同一滚轮高度解析加标准头部高度，通用 Popup 的尺寸、生命周期和调用方插槽主题保持原行为。

补充 review：常规环形 Progress 默认尺寸为内置最宽百分比预留空间，显式 circleSize 和自定义 label 保持原配置。Refresh 高度测量使用自身实际宽度及四态实际字体，加载态单独扣除图标和间距。Sidebar 跳转未构建项目时按已布局项目实际高度迭代定位，不继续假设 56dp。Indexes 的内置气泡允许越过索引条上下裁切边界，索引文字仍隐藏越界内容；自定义索引保留原裁切行为。

- Calendar 默认数字使用单个两位日期样本测量两种状态字体，星期及月份仅各排版一个代表文案；不遍历排版所有日期、月份。显式 cellHeight / monthTitleHeight 与自定义 builder 优先，不保证任意自定义字体、超长文案与极小尺寸的组合。

- Input 保留普通 Row / Expanded 布局，不替任意自定义插槽添加滚动，不在极小显式视口中接管全部内容布局。内置 hint 保留自然行框；Textarea 正文顶部排版、合理固定视口内的原生编辑和计数保留。显式尺寸不足或调用方内容过宽属于组合约束，不增加通用兜底。
- TabBar 双层入口的内置图标与文案遵守剩余宽度，保留既有单行省略，禁止固定内容溢出 Row。

维护边界：优先修复通用排版根因，默认高度增长使用有界的布局或测量；不以极端缩放场景驱动新的配置入口、跨层状态、滚动交互或任意内容探测。Indexes 滚动为明确要求的能力，独立保留。

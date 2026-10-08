# 全量组件文档内容审查与 PR 影响报告

日期：2026-10-08。消费 PR：[Tencent/tdesign-flutter #1149](https://github.com/Tencent/tdesign-flutter/pull/1149)。

后续维护者要求精简 API 展示，先仅验收 Popup；当前本地 Popup 资产和展示结果见 [popup-presentation.md](popup-presentation.md)。本文及 review-evidence.json 记录此前全量语义审查，不代表新展示规则已经全量验收。

## 判断与交付范围

57/57 个组件（包含全局 Theme）已逐一对照实现审查，并在候选工具下重新生成、核对和展示。发现的注释及生成问题已修复。**正式依赖交付仍待工具 PR #29 合入 main，消费 PR 暂不能按本轮候选产物声明可合并。**

本轮起点为消费 PR head `9d99f92f47269ed1e8e2337701d6bc0b6db315a8`，基础为 `develop@dacc279ec96c601c8ba690b3baee2c7f6bdadab8`。工具候选见 [TDesignOteam/tdesign-flutter-tools #29](https://github.com/TDesignOteam/tdesign-flutter-tools/pull/29)，消费仓库声明的正式 main 当前仍为 `96f1c693a2d61ae6c135db4d52530bb28dfc2462`。无提交的 path override 或工具 PR ref。

此前“注释非空、结构完整即全量内容验收”的表述撤回。本报告区分人工语义核对、AST 结构验证、页面展示以及正式依赖/CI 门禁，历史记录不能代替本轮结果。

## 审查口径

对每个 manifest 导出的类、构造函数、公开属性/访问器、实例/静态方法、控制器、枚举、typedef、顶层函数与 Theme 核对：签名和默认值、空值含义、受控状态、互斥/有效值约束、回调时序、返回值/异常、资源所有权、样式优先级、明暗 Token 回退。无独立 Theme 的组件按实际共用主题说明。

源码中 318 处构造参数与字段重复说明已统一，以字段的完整契约为构造文档来源；发现冲突时按实现修正，而非机械保留任一旧注释。一般方法参数仍需独立说明。copyWith 的字段含义与本次调用的空值行为明确区分，Popup 的显式 null 重置参数另行记录。

## 逐组件结论

以下“已核对”是本轮源码语义审查与候选文档结果；每行同时覆盖构造、公开 API、Theme/实际主题来源及实际 API 页展示。数量来自独立 analyzer 审计。

| 组件 | 声明 | 参数 | 本轮发现与处理 | 候选结果 |
| --- | ---: | ---: | --- | --- |
| [button](../../tdesign-component/example/assets/api/button_api.md) | 7 | 17 | 去除 L1 等内部术语；核对 size/variant/colorPreset、ButtonStyle 优先级及点击/长按语义。 | 已核对；AST 与页面通过 |
| [divider](../../tdesign-component/example/assets/api/divider_api.md) | 4 | 21 | 修正不存在的 Flutter DividerTheme 回退；补充分割线色、横向 indent 与布局限制。 | 已核对；AST 与页面通过 |
| [fab](../../tdesign-component/example/assets/api/fab_api.md) | 7 | 35 | 补充位置、拖拽边界、吸附阈值及动画默认值；核对控制器以外的手势回调。 | 已核对；AST 与页面通过 |
| [icon](../../tdesign-component/example/assets/api/icon_api.md) | 1 | 10 | 核对字体包、size/color、语义标签与原生 Icon 参数；本轮未发现新增语义问题。 | 已核对；AST 与页面通过 |
| [link](../../tdesign-component/example/assets/api/link_api.md) | 4 | 18 | 补充图标尺寸与间距；核对 disabled、点击回调及前后图标。 | 已核对；AST 与页面通过 |
| [text](../../tdesign-component/example/assets/api/text_api.md) | 4 | 59 | 修正 TFontLoader.load 的 bool 返回值、空列表和加载失败语义；核对 TText/TTextSpan 的字体与样式优先级。 | 已核对；AST 与页面通过 |
| [back-top](../../tdesign-component/example/assets/api/back-top_api.md) | 4 | 32 | 补充外部 ScrollController 所有权、滚动时长/曲线和显示阈值约束。 | 已核对；AST 与页面通过 |
| [drawer](../../tdesign-component/example/assets/api/drawer_api.md) | 7 | 54 | 修正 destroyOnClose 的 maintainState 语义，说明关闭后 State 始终释放；补充 topInset 约束。 | 已核对；AST 与页面通过 |
| [indexes](../../tdesign-component/example/assets/api/indexes_api.md) | 10 | 98 | 补充外部控制器释放责任、索引唯一性及初始索引约束；清除未解析的 child 宏和误识别的参数引用。 | 已核对；AST 与页面通过 |
| [navbar](../../tdesign-component/example/assets/api/navbar_api.md) | 4 | 40 | 核对返回按钮、标题/操作项、边框和插槽，Theme 默认值与回调实现一致；本轮未发现新增语义问题。 | 已核对；AST 与页面通过 |
| [side-bar](../../tdesign-component/example/assets/api/side-bar_api.md) | 4 | 26 | 核对受控选中、宽高、条目禁用和 line/tag 形态的 Theme 解析；本轮未发现新增语义错误。 | 已核对；AST 与页面通过 |
| [steps](../../tdesign-component/example/assets/api/steps_api.md) | 5 | 20 | 核对 current、状态、方向、文字/自定义内容与错误图标回退；使用全局 Token，不虚构独立 Theme。 | 已核对；AST 与页面通过 |
| [tab-bar](../../tdesign-component/example/assets/api/tab-bar_api.md) | 11 | 53 | 补充 300ms 动画与 easeInOutCubic；核对 value 范围、内容依赖及整栏禁用（AbsorbPointer 同时阻止长按）。 | 已核对；AST 与页面通过 |
| [tabs](../../tdesign-component/example/assets/api/tabs_api.md) | 7 | 41 | 明确控制器 length 匹配、外部释放责任与 DefaultTabController；onTap 为空仍可切换；补充 TTab 内容互斥/至少一个内容。 | 已核对；AST 与页面通过 |
| [calendar](../../tdesign-component/example/assets/api/calendar_api.md) | 10 | 49 | 修正 value 长度说明：允许未选、range 的单端；补充默认日期范围，记录日期归一化/去重/排序与星期文案顺序；修正程序化动画滚动不保证通知的回调说明。 | 已核对；AST 与页面通过 |
| [cascader](../../tdesign-component/example/assets/api/cascader_api.md) | 4 | 31 | 补充面板高度 360、容器色/圆角/分隔线/选中图标默认 Token；保留严格受控路径与回调说明。 | 已核对；AST 与页面通过 |
| [checkbox](../../tdesign-component/example/assets/api/checkbox_api.md) | 9 | 49 | 补充选择上限达到后仍能取消、0 的含义、完整选中结果顺序；合并构造与字段说明。 | 已核对；AST 与页面通过 |
| [picker](../../tdesign-component/example/assets/api/picker_api.md) | 10 | 35 | 保留归一化、禁用项处理及父级回传契约；修正 PickerPopup 的 State 生命周期说明；核对共用主题高度与可见项数。 | 已核对；AST 与页面通过 |
| [date-time-picker](../../tdesign-component/example/assets/api/date-time-picker_api.md) | 8 | 24 | 补充无效步进按 1 处理、逆序范围 debug 断言/release 忽略 end；核对 partial 转换和模式字段。 | 已核对；AST 与页面通过 |
| [form](../../tdesign-component/example/assets/api/form_api.md) | 11 | 68 | 补齐 required 对 null/空白/空集合的语义，false/0 有效；标签改为 TextAlign.start，并补充内边距、布局与间距默认值。 | 已核对；AST 与页面通过 |
| [input](../../tdesign-component/example/assets/api/input_api.md) | 4 | 47 | 补充 controller/focusNode 所有权、initialValue 互斥、字数限制互斥及非负约束、行数和密文模式生效条件。 | 已核对；AST 与页面通过 |
| [radio](../../tdesign-component/example/assets/api/radio_api.md) | 8 | 49 | 核对受控值、组和条目禁用的关系、builder 及卡片布局；统一重复构造/字段说明。 | 已核对；AST 与页面通过 |
| [rate](../../tdesign-component/example/assets/api/rate_api.md) | 3 | 28 | 补充 count 正值、value 范围与父级回传要求；统一重复构造/字段说明。 | 已核对；AST 与页面通过 |
| [search](../../tdesign-component/example/assets/api/search_api.md) | 4 | 44 | 修正清除按钮无需焦点的条件；补充 clear/onChanged 时序、长度限制互斥和 controller/focusNode 所有权。 | 已核对；AST 与页面通过 |
| [slider](../../tdesign-component/example/assets/api/slider_api.md) | 5 | 50 | 补充取值范围、max>min、divisions 正值及刻度依赖；修正明暗主题下禁用滑块描边回退。 | 已核对；AST 与页面通过 |
| [stepper](../../tdesign-component/example/assets/api/stepper_api.md) | 4 | 34 | 核对 value/min/max/step、整数输入、受控回调及禁用状态；消除重复构造短说明遮盖字段契约。 | 已核对；AST 与页面通过 |
| [switch](../../tdesign-component/example/assets/api/switch_api.md) | 4 | 32 | 补充“开/关”空值文案与轨道/内容色、字体 Token；合并重复说明，核对 loading 与 disabled。 | 已核对；AST 与页面通过 |
| [textarea](../../tdesign-component/example/assets/api/textarea_api.md) | 2 | 27 | 补充外部控制器和焦点所有权、initialValue 互斥、长度限制互斥/非负约束及最小行数。 | 已核对；AST 与页面通过 |
| [tree-select](../../tdesign-component/example/assets/api/tree-select_api.md) | 3 | 33 | 补充高度 336、根列 103、条目 56；保留固定非根列宽、溢出滚动及完整路径语义。 | 已核对；AST 与页面通过 |
| [upload](../../tdesign-component/example/assets/api/upload_api.md) | 9 | 68 | 明确不执行网络上传、文件 id/数量约束及 video 单文件限制；补充无 size 时校验边界、整批拒绝和业务回传。 | 已核对；AST 与页面通过 |
| [avatar](../../tdesign-component/example/assets/api/avatar_api.md) | 6 | 35 | 补充 maxCount、spacing 的有效值与回退，头像/图标尺寸及组合头像边框默认 Token。 | 已核对；AST 与页面通过 |
| [badge](../../tdesign-component/example/assets/api/badge_api.md) | 5 | 42 | 补充圆点尺寸和内边距，核对 count/dot/content 优先级、溢出文案及零值显示。 | 已核对；AST 与页面通过 |
| [cell](../../tdesign-component/example/assets/api/cell_api.md) | 6 | 57 | 修正 align 空值及默认高度；补充 Cell/CellGroup 的样式、卡片、内边距和分隔线职责与默认值。 | 已核对；AST 与页面通过 |
| [time-counter](../../tdesign-component/example/assets/api/time-counter_api.md) | 7 | 25 | 修正 size/variant 空值为 medium/plain，去除错误的 Theme 结构回退；补充非负 time，核对 format/controller 生命周期。 | 已核对；AST 与页面通过 |
| [collapse](../../tdesign-component/example/assets/api/collapse_api.md) | 7 | 43 | 补充 bodyHeight 约束和卡片、内容、图标 Theme 默认值；恢复完整受控展开及回调说明。 | 已核对；AST 与页面通过 |
| [empty](../../tdesign-component/example/assets/api/empty_api.md) | 2 | 11 | 修正 icon 显式 null 仍回退内置图标；补充空文案字体/颜色 Token。 | 已核对；AST 与页面通过 |
| [footer](../../tdesign-component/example/assets/api/footer_api.md) | 2 | 8 | 核对链接列表、文字与 Theme；本轮未发现新增语义错误，工具修正仅影响说明呈现。 | 已核对；AST 与页面通过 |
| [image](../../tdesign-component/example/assets/api/image_api.md) | 3 | 36 | 补充 Theme 布尔项实际默认 false；核对 image、加载/错误插槽和圆角优先级。 | 已核对；AST 与页面通过 |
| [image-viewer](../../tdesign-component/example/assets/api/image-viewer_api.md) | 3 | 32 | 补充 initialIndex、labels 长度、自动播放间隔的异常约束；核对打开/关闭回调及主题。 | 已核对；AST 与页面通过 |
| [progress](../../tdesign-component/example/assets/api/progress_api.md) | 4 | 65 | 修正不存在的 Flutter ProgressIndicatorTheme 颜色回退；明确状态/渐变优先级、循环时长和比例约束及环形尺寸。 | 已核对；AST 与页面通过 |
| [result](../../tdesign-component/example/assets/api/result_api.md) | 3 | 13 | 补充默认图标 80、标题和描述字体 Token；核对 status 与自定义 icon/title/description。 | 已核对；AST 与页面通过 |
| [skeleton](../../tdesign-component/example/assets/api/skeleton_api.md) | 8 | 47 | 补充背景/高亮色、圆角及行距 Token；核对动画、延迟、预设布局和占位块的宽高/flex。 | 已核对；AST 与页面通过 |
| [swiper](../../tdesign-component/example/assets/api/swiper_api.md) | 8 | 65 | 补充 initialIndex 范围和动画正时长异常；补充指示器对齐、边距、尺寸默认值，核对控制器绑定和循环索引。 | 已核对；AST 与页面通过 |
| [table](../../tdesign-component/example/assets/api/table_api.md) | 15 | 57 | 补充选择回调必需及受控回传；明确 onSortChanged 为空时的显示语义；核对行标识、排序、尺寸互斥、列/跨行约束。 | 已核对；AST 与页面通过 |
| [tag](../../tdesign-component/example/assets/api/tag_api.md) | 7 | 44 | 修正 enabled=false 同时阻止标签点击与关闭图标回调；核对 needCloseIcon 和父级删除责任。 | 已核对；AST 与页面通过 |
| [action-sheet](../../tdesign-component/example/assets/api/action-sheet_api.md) | 8 | 68 | 补充选择/取消先回调再关闭、返回 Handle 及关闭通知；补充网格 rows/count 限制和视觉默认值。 | 已核对；AST 与页面通过 |
| [dialog](../../tdesign-component/example/assets/api/dialog_api.md) | 5 | 60 | 修正不存在的 Flutter DialogTheme 回退；补充 title/content 至少一个、actions 互斥及尺寸/样式默认值。 | 已核对；AST 与页面通过 |
| [dropdown-menu](../../tdesign-component/example/assets/api/dropdown-menu_api.md) | 14 | 94 | 补充外部控制器由调用方释放、单绑定；恢复完整布局、选项、筛选值及展开/关闭说明。 | 已核对；AST 与页面通过 |
| [loading](../../tdesign-component/example/assets/api/loading_api.md) | 4 | 23 | 修正不存在的 Flutter ProgressIndicatorTheme/ColorScheme 回退；补充 duration 归一化、尺寸约束和视觉默认值。 | 已核对；AST 与页面通过 |
| [message](../../tdesign-component/example/assets/api/message_api.md) | 5 | 45 | 补充背景/圆角/阴影与 elevation 默认行为；核对关闭回调与替换/超时管理。 | 已核对；AST 与页面通过 |
| [notice-bar](../../tdesign-component/example/assets/api/notice-bar_api.md) | 4 | 33 | 补充 maxLines/speed 有效值和行高/内边距默认值；核对滚动、前后插槽、关闭与内容点击。 | 已核对；AST 与页面通过 |
| [popover](../../tdesign-component/example/assets/api/popover_api.md) | 7 | 51 | 补充箭头/间距/阴影默认值；核对 showArrow 默认、Anchor/Controller、缺失 Overlay 和关闭时机。 | 已核对；AST 与页面通过 |
| [popup](../../tdesign-component/example/assets/api/popup_api.md) | 16 | 135 | 修正 destroyOnClose 与动画 Theme 归属；逐参数明确 copyWith 的 omission/null/类型语义，修复 context 多行说明截断。 | 已核对；AST 与页面通过 |
| [pull-down-refresh](../../tdesign-component/example/assets/api/pull-down-refresh_api.md) | 4 | 16 | 补充阈值/头部/最大高度限制；保留典型用法示例，核对控制器、超时、错误上报及共用 Loading Theme。 | 已核对；AST 与页面通过 |
| [swipe-cell](../../tdesign-component/example/assets/api/swipe-cell_api.md) | 7 | 27 | 补充 Controller Future 完成/未绑定语义、回调早于动画、切换侧通知顺序；说明 enabled 只控制拖动，操作面板不能为空。 | 已核对；AST 与页面通过 |
| [toast](../../tdesign-component/example/assets/api/toast_api.md) | 5 | 104 | 修正七个入口的固定匿名 ID、infiniteDuration/零负时长、加载 customWidget 只替换文案；核对多实例/替换/关闭。 | 已核对；AST 与页面通过 |
| [theme](../../tdesign-component/example/assets/api/theme_api.md) | 27 | 82 | 清除颜色 getter 被分组分隔线污染的说明，区分 Token 最终回退色；补充 fromJson 失败返回 null 与 recoverDefault 修改全局默认主题的含义，核对 TMap、字体、资源和 Material 构建。 | 已核对；AST 与页面通过 |

## 共用生成工具修复

1. 同一 Markdown 段落内的参数续行不再截断，即使续行以非参数 dartdoc 引用开头也保留；空行、下一有效参数或围栏终止段落。以 TPopupHandle.open/context/navigatorContext 为真实回归案例。
2. 简介保留源码中的段落、代码围栏和完整示例，避免孤立“示例/典型用法”标题。旧 stripIntroductionForApiSummary 入口保留弃用转发，CLI 和 README 一致。
3. copyWith 继承字段说明时明确标识“字段含义”，提示空值行为以方法契约为准；有独立参数注释时优先使用，不猜测各 copyWith 实现。

4. 去除 dartdoc 标记时仅匹配水平空白，保留单独 /// 行对应的段落边界；示例代码内的字面量 /// 不再被全局删除。真实原始注释回归验证参数段落与方法正文独立。

## PR 源码与使用方式影响

| 范围 | 实际改动 | 对使用方的影响 | 证据 |
| --- | --- | --- | --- |
| 组件生产源码 `tdesign-component/lib` | 全 PR 相对 develop 修改 128 个 Dart 文件，本轮追加修复 88 个；全部为注释和格式化 | 公开签名、默认行为、实现、回调执行顺序未变；不需要组件 API 迁移，无 breaking change | analyzer 解析后逐文件比较非注释 Token（忽略格式化逗号），128/128 一致 |
| Demo `example/lib/base/api_widget.dart` | 真实 AssetManifest 中规范化旧注册名/slug，处理异步加载与缺文档回退 | backtop/back-top 等 12 组入口能够加载同一 API；切换到缺失文档不会显示前一页面 | 两 SDK 各 70 项真实 ApiPage 测试 |
| Demo `example/lib/base/example_route.dart` | API 路由复用规范化后的 model 查询 | canonical slug 与旧注册名均能打开文档页 | 与上述路由/资产回归共同覆盖 |
| Demo `example/lib/config.dart` | 注册既有 Theme Demo | 全局主题也有 Demo/API 入口 | 全量 API 页测试包含 theme |
| API 生成清单与审计脚本 | 全量导出、签名/参数/注释审计、幂等校验 | 文档完整呈现构造/方法/控制器/Theme；工具维护更明确 | 369 个公开声明、435 个可调用声明、2510 参数，0 issue |
| 官网 | 以生成 API 资产展示；共用 Theme 链接和 API 标签定位 | 用户看到完整 API 与正确主题来源 | 57 个实际页面逐一打开，369 个声明标题与 713 个代码块可见，0 个空代码块；站点 18 项测试及构建通过 |
| CI | GitHub/CNB 登记同一工具/文档/Demo 回归入口 | 不改变组件运行行为 | 正式消费最新 head 门禁在工具 #29 合并及本轮修复推送后重新核对 |

修正注释会改变读者的理解，但不改变现有实现。例如 Toast 匿名复用、Tag 禁用关闭按钮、Search 清除无需焦点、Calendar 单端范围与 Popup State 生命周期都早已是当前代码行为，本轮只是修正文档误导。

## 验证与限制

| 检查 | 本轮结果 |
| --- | --- |
| 工具 Flutter 3.32.0 / Dart 3.8.0 与 Flutter 3.47.6 / Dart 3.13.5 | 各 65 项完整测试与严格 analyze；以最终工具 head 的结果为准 |
| 两 SDK 全量生成 | 57 份；跨 SDK 与重复生成字节一致，候选 CLI 的正式脚本 --check 均通过（临时进程入口，无提交依赖覆盖） |
| 独立 AST 审计 | 两 SDK 369 声明、435 可调用声明、2510 参数，0 issue |
| 工具 validate | 两 SDK ERROR=0、WARN=0 |
| 组件 analyze | 两 SDK严格零问题 |
| 审计器正反例 | 两 SDK 各 18 项通过 |
| Flutter Demo 文档页 | 两 SDK 各 70 项通过，覆盖全部57组件、旧名/slug和缺文档切换 |
| 官网 | 18 项测试、构建通过；逐页浏览器检查 57/57，369 声明，代码块 713，空代码块 0 |
| 组件生产源码 Token | 相对 develop 128 文件，一致，无运行代码改动 |

复现关键入口：`node tool/generate_api.mjs`、`node tool/generate_api.mjs --check`、`dart run tool/audit_api_docs.dart --json`、`flutter test test/tool/audit_api_docs_test.dart`、Demo 下 `flutter test test/api_docs_test.dart`、官网下 `pnpm site`。最终必须用消费仓库正式 main 解析出的工具执行生成/--check；本轮候选工具的 compiled CLI 用于独立验收，不等同正式依赖已交付。

本次没有视觉运行逻辑改动，不更新 Golden 基线；本报告验证文档内容和显示，不扩展为各组件 Figma、设备或全部交互设计验收。

工具最终 head `f599fcc83bc52c86917bdf643a9bfbd9965a7fb4` 的 8 项远端检查已全部通过；[双版本回归日志](https://github.com/TDesignOteam/tdesign-flutter-tools/actions/runs/37717368286) 确认每版 65 项测试及严格 analyze 零问题，[四平台二进制构建](https://github.com/TDesignOteam/tdesign-flutter-tools/actions/runs/37717368630) 和预览构建通过。工具 PR 仍未合入 main。

## 正式交付顺序

1. 工具 PR #29 的最终 head 通过远端双版本回归/构建并合入正式 main。
2. 消费仓库保持 main，重新解析两 SDK 依赖，记录 resolved-ref，使用最终源码执行 57 份生成与 --check；和候选产物比较。
3. 推送本轮组件修复、生成产物与本报告到 #1149，核对该 head 的 CI、autofix 差异和维护者 review，再判断是否可合并。

本轮组件修复已保存为提交 `1d8c2a093000c8cbe733be2e80b51a0d8f2afe34`。2026-10-08，维护者明确要求先推送，因此将修复和候选产物交付到 #1149；工具 #29 仍未合入正式 main，正式生成验收继续待办。推送后需检查旧工具 autofix 是否覆盖候选文档，工具合并后重新解析正式依赖并恢复、生成和校验最终产物。起点 head 的绿色 CI 不能作为本轮最终 head 的验收证据。

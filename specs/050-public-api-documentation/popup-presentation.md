# Popup API 展示验收

日期：2026-10-08。仅验收 Popup，维护者确认后再扩大范围。以下结论对应本地候选，未推送；工具候选基于本地提交 `ea7734b853872ccc4d65b19848538a5b921abbff`，本次返回值及表格统一调整仍为工作区改动，远端工具 PR #29 的 CI 不包含本次展示调整。

## 当前信息结构

- 三级标题：公开类型或顶层函数。类型用途直接放在类型名下，不重复「简介」标题。
- 四级标题：构造方法、属性、静态成员、静态方法、实例方法、枚举值，以及类型别名的回调参数/返回值或目标类型定义。按此顺序显示实际存在的分组，无空分组。
- 五级标题：具体构造/方法的实际名称。默认构造、命名构造及工厂构造统一置于「构造方法」，默认构造优先，其余按名称排序。
- 六级标题：方法返回值及构造/方法内部说明；继续嵌套时使用加粗段落，避免越过所属 API。
- 全部表格统一为「名称、类型、默认值、说明、必传」五列；参数必传保持源码 required 语义，不适用值用 `-`。
- 参数表直接接在构造/方法说明之后，不再重复「参数」标题。「公开属性（字段与访问器）」精简为「属性」。
- 构造、静态/实例方法及顶层函数统一去掉完整签名代码块和 const 标识；保留参数类型、默认值、必填、位置/命名区别、非 void 返回类型、泛型约束及必要行为说明。无参 API 明示无参数。typedef 以参数/返回值或目标类型表保留类型契约，不重复源码声明。
- API 页去掉完整示例、孤立示例标题和独立类型「声明」章节；专门示例页保留。

`TPopupOptions` 将构造方式和方向专用参数合并为一张表，用中文标明方向；`TPopupPlacement` 仅列枚举方向，不重复构造推荐和尺寸说明。类型用途保留一句，蒙层组合、开关状态、归一化、插值和回调参数使用表格，无「使用说明」及两个组织性子标题。
上述构造分组与层级规则在工具渲染层统一实现；默认构造转为临时渲染对象，复用同一正文入口，不改解析模型。工具校验器和消费审计器同时支持旧默认构造章节及新分组，按下一个同级 API 截断，避免借用后续命名构造的参数表。

## 修改范围与源码影响

此前表格优先阶段修改六个 Popup 源文件的 dartdoc；本次返回值阶段仅修改 `t_popup.dart`、`t_popup_options.dart`、`t_popup_theme_data.dart` 的注释（以及格式化产生的空行）。运行 token 与本轮起点 `0eb6a054` 一致；组件实现、API 签名、默认值与调用方式未改变，无 breaking change，不需要更新日志。

只重新生成 `popup_api.md`，其余 56 份资产未改。135 个参数的名称、类型、声明默认值、必传状态以及位置参数顺序和实际返回类型保持一致；源码完整示例保留。生成器统一将 AST 返回类型与 authored 返回说明渲染为表格；工具顶层函数校验和消费审计同步支持新表格与旧格式。正式依赖 ref 和锁文件未改，共用参数去重和类型链接未实现。

官网在此前阶段调整类型标题重复检查，本次仅补 API 六级标题的字号与行高，以及其下表格的宽度、列宽和换行，保证新返回分组可读；未改站点运行逻辑。

## 逐类型验收

实际页面逐个点击右侧 16 个类型目录，均定位到正确三级标题。按源码 AST 核对页面中的构造/方法及全部参数名称、类型；参数默认值、必填状态及位置顺序由 CLI 契约审计核验。使用说明归属、分组顺序、构造实际名称、枚举表及 typedef 定义逐类型核对。

| 类型 | 构造入口 | 方法 | 参数 | 结果 |
| --- | ---: | ---: | ---: | --- |
| TPopup | 0 | 1 | 4 | 通过 |
| TPopupHeader | 1 | 0 | 4 | 通过 |
| TPopupOptions | 6 | 3 | 94 | 通过 |
| TPopupHandle | 0 | 2 | 2 | 通过 |
| TPopupOverlayConfig | 1 | 0 | 5 | 通过 |
| TPopupInset | 1 | 0 | 0 | 通过 |
| TPopupBottomInset | 1 | 0 | 2 | 通过 |
| TPopupTopInset | 1 | 0 | 2 | 通过 |
| TPopupLeftInset | 1 | 0 | 2 | 通过 |
| TPopupRightInset | 1 | 0 | 2 | 通过 |
| TPopupThemeData | 1 | 4 | 18 | 通过 |
| TPopupPlacement | 0 | 0 | 0 | 通过 |
| TPopupTrigger | 0 | 0 | 0 | 通过 |
| TPopupHeaderBuilder | 0 | 0 | 0 | 通过 |
| TPopupSlotBuilder | 0 | 0 | 0 | 通过 |
| TPopupVisibleChangeCallback | 0 | 0 | 0 | 通过 |

合计：16 个类型、14 个构造、10 个方法、135 个参数及 3 个 typedef 定义，均完整。所有构造/方法无完整源码签名，API 区无二级说明标题、重复简介、旧方向标题或冗余参数标题。

## 信息结构候选验证（移除开场说明前）

| 项目 | Flutter 3.32.0 / Dart 3.8.0 | Flutter 3.47.6 / Dart 3.13.5 |
| --- | --- | --- |
| 工具完整回归 | 75 项通过 | 75 项通过 |
| 文档审计 CLI 正反例 | 39 项通过 | 39 项通过 |
| 真实 Flutter Popup API 页面 | 1 项通过 | 1 项通过 |
| 工具与修改的消费审计器、测试、Popup 源码严格 analyze | 零问题 | 零问题 |
| Popup 生成与 validate | ERROR=0 / WARN=0 | ERROR=0 / WARN=0 |

双 SDK 生成字节一致。源码清单审计零问题；旧组件资产兼容审计通过，但这不代表其余组件已通过新展示规则的逐页验收。

官网 18 项测试与生产构建通过，保留既有大 chunk 提示。Flutter Web 重新构建并装配到本地预览。新增回归覆盖统一构造顺序、默认构造说明的六级标题、后续命名构造的参数不得补足默认构造缺失、错误/多余参数继续被拒绝、CLI 生成及正反例验证。

产物 SHA256：`86b7ce4f7b9a161ecb77c58ccd9c9389d5efb587683537e3a608b9a01f4d0c34`。

## 移除统一开场说明（维护者追加反馈）

移除每页 API 顶部的默认值列含义、Theme/Token 回退阅读规则、必填列阅读规则和参数传入规则总述。规则从生成器统一移除，仅重新生成 Popup。具体 API 的默认值、必填列、位置参数顺序及必要行为说明保留；与上一个候选逐字比较，仅删除这一个开场段落，其余正文完全一致。

追加验证：两 SDK 的既有展示回归各 8 项通过，修改的生成器严格 analyze 均零问题；Popup 双 SDK 输出完全一致，validate 均 ERROR=0/WARN=0。官网 18 项测试、生产构建及 Flutter Web 构建通过，预览已重新装配；浏览器确认开场说明消失、16 个类型仍在。没有重新运行上节完整 75/39 项套件，因为可调用 API、表格及审计逻辑均未改。

追加证据：`preamble-test-*.log`、`preamble-analyze-*.log`、`preamble-generate-*.log`、`preamble-validate-*.log`、`preamble-output-contract.log`、`preamble-site-build.log`、`preamble-web-build.log`、`preamble-browser-check.json` 及 `popup-without-preamble.jpg`。

## 参数表五列表头（维护者追加反馈）

构造、静态/实例方法及顶层函数统一为「名称、类型、默认值、说明、必传」五列。仅重新生成 Popup，其 21 张参数表均使用精确的五列表头；页面仍包含 16 个类型及 135 个参数。与上一候选逐字比较仅改参数表头，数据与说明完全一致。枚举、方向适用关系及可读属性/静态成员表保留各自的真实语义，没有给无需传入的成员虚构必传状态。

消费审计器将新「名称/必传」表头归一化到原有契约键，仍支持其他 56 份旧资产。顶层函数校验同步识别「名称」，避免将其误判为多余参数。增加新表头必传标记错误的反例，并让既有精简/分组夹具使用新表头；旧完整签名夹具保留。

本次双版本完整工具回归各 75 项通过；消费审计定向各 8 项（新旧表头接受、缺失/错误/多余参数、必传错误）通过，工具及修改消费文件严格 analyze 均零问题。Popup 双 SDK 生成字节一致且 validate 均 ERROR=0/WARN=0；新旧资产混合的全量 AST 契约审计两版本均零问题。官网 18 项测试与生产构建、Flutter Web 构建通过；本地已装配新 Web 产物。程序运行前按对应 Flutter 版本重新解析依赖，SDK 切换时旧 package_config 的编译/分析误报已消除。

证据：`tools-columns-*.log`、`columns-audit-*.log`、`columns-*-analyze-*.log`、`columns-inventory-*.json`、`columns-generate-*.log`、`columns-validate-*.log`、`columns-output-contract.log`、`columns-site-build.log`、`columns-web-build.log`、`columns-browser-check.json` 及 `popup-table-columns.jpg`。本次未重新运行完整消费 40 项套件，不沿用此前 39 项结果充当本次完整回归。

## 表格优先与重复文案精简（上一候选）

| 内容 | 调整 |
| --- | --- |
| 构造与方向 | 合并为「构造方法 / 方向 / 方向专用参数」表，避免两份方向概览 |
| 蒙层 | 四种 showOverlay / preventTap 组合用表格表达 |
| open / close | 状态与行为对照表，保留重复调用、嵌套关闭、异常与模式差异 |
| normalized / lerpDouble | 字段保留条件和 null 输入行为表 |
| typedef 回调 | 参数说明表，保留关闭来源及显隐语义 |
| Theme | 优先级表；copyWith 参数直接描述用途，移除工具回退文案「字段含义」「调用时的空值行为见方法说明」 |
| 字段与枚举 | 短说明保留运行时默认、空值、方向限制、安全区和回调时机；删除内部引用和重复推荐 |

核对实际实现后保留的关键契约：配置与方向不匹配在打开时抛 FlutterError；无 Navigator 的 debug/release 差异；非栈顶 Popup 直接移除；copyWith 显式 null 与未传的区别；destroyOnClose 覆盖时的释放与关闭后始终释放；蒙层点击的生效条件；Theme 优先级、尺寸与圆角回退；header/close builder 的触发来源。

| 验证 | Flutter 3.32.0 | Flutter 3.47.6 |
| --- | --- | --- |
| Popup 最终源码 analyze | 零问题 | 零问题 |
| 六个文件运行 token | 全部不变 | 全部不变 |
| Popup generate / validate | ERROR=0 / WARN=0 | ERROR=0 / WARN=0 |
| 全量源码/资产 AST 契约审计 | 零问题 | 零问题 |
| 真实 Flutter Popup API 页面测试 | 1 项通过 | 1 项通过 |

双 SDK 输出字节一致。浏览器实际页面包含 16 个类型、24 个构造/方法、21 张五列参数表、135 个参数及 3 个 typedef 代码块；无旧「使用说明」或回退提示。官网 18 项测试与生产构建通过，Flutter Web 重新构建并装配。本轮工具逻辑未改变，没有重复运行工具 75 项与消费审计 CLI 完整套件。

当前窄窗口中长表格沿用官网横向滚动；本次没有改站点表格样式或宣称窄屏所有列同时可见。示例交互未重验。

证据：`tables-generate-*.log`、`tables-validate-*.log`、`tables-analyze-*.log`、`tables-tokens-*.log`、`tables-inventory-*.json`、`tables-demo-*.log`、`tables-output-contract.json`、`tables-browser-check.json`、`tables-site-build.log`、`tables-web-build.log`、`popup-tables.jpg`。该阶段产物 SHA256：`6d6a79b26051e128ed36083cb656e44fa8328eaecf2174ca185a41edc78dfb18`。

## 返回值结构（上一候选）

`TPopup.show` 的「调用情况 / 行为」两行表合并为一句：每次调用打开独立浮层，可叠加展示；参数与方向不匹配时抛出 FlutterError。参数表之后显示六级「返回值」标题及「类型 / 说明」表，展示 TPopupHandle 及其控制当前浮层的用途。

规则在工具渲染层统一处理静态/实例/扩展方法及顶层函数，构造没有返回值分组，void API 不生成空表格。官网将 API 六级标题字号设为正文大小，避免浏览器默认 h6 字号过小；不改变语义层级；其后的返回表跟随内容区宽度，类型列占 30%，说明换行，避免窄窗口横向截断。源码的返回值章节被提取至表格，其他同级说明保留；缺失说明不会由工具推断。Popup 七个非 void 方法均补齐真实返回说明，泛型及可空类型来自 AST，三个 void 方法没有返回标题。审计器保留旧签名/行内格式兼容，拒绝缺失、错误、重复或借用相邻 API 的返回类型；显式写错 void 返回表仍报错。

参数表严格维持五列，返回表不会被误读为参数。双 SDK 生成字节一致，16 类型、24 可调用入口、21 张参数表及 135 参数保持一致，新增 7 张返回表。

双 SDK 工具完整回归各 77 项、消费审计正反例各 47 项和真实 Popup API 页面各 1 项通过；修改文件严格 analyze 均零问题。六个 Popup 文件运行 token 不变；全量源码/新旧资产 AST 契约审计零问题，Popup validate 均 ERROR=0/WARN=0。官网 18 项测试及生产构建通过，Flutter Web 构建与本地装配完成。实际页面确认参数之后的返回标题、七张有说明的返回表及三个 void API 无空分组；窄窗口下 TPopup.show 返回表与内容区同宽（约 695px），标题字号为 14px，说明完整可读。未重验七个 Demo 交互场景，不宣称全量组件展示验收或远端 CI 通过。当前产物 SHA256：`31a16bddd641e548bd331d82daa407be0959d2fe60657714db699b076bdc1ac3`。

证据：`tools-returns-final-*.log`、`returns-tools-analyze-*.log`、`returns-audit-*.log`、`returns-analyze-*.log`、`returns-inventory-*.json`、`returns-tokens-*.log`、`returns-demo-*.log`、`returns-generate-*.log`、`returns-validate-*.log`、`returns-output-contract.json`、`returns-site-build.log`、`returns-web-build.log`、`returns-browser-check.json`、`popup-return-value.jpg`。

## 所有表统一五列（上一候选）

维护者确认所有表统一为「名称 / 类型 / 默认值 / 说明 / 必传」，不适用项使用 `-`。统一规则在工具渲染层实现，参数、返回值、属性、静态成员、枚举及 dartdoc 说明表均使用同一表头；枚举类型取声明名，返回类型取 AST。说明表原有的条件、方向及结果合并到名称/说明，保留转义竖线和全部关系；已有五列的 authored 表保持数据不变。渲染时标记说明表角色，消费审计与工具 validate 均忽略其数据契约，避免说明行补足缺失参数或误报空类型。

只生成 Popup：46 张表包含 21 张参数表、7 张返回表、4 张属性/静态成员表、2 张枚举表和 12 张说明表。16 个类型、24 个调用入口、135 个参数及 7 个返回类型/说明与上一候选一致。官网五列列宽统一为 18% / 22% / 12% / 40% / 8%，表格跟随内容区宽度，长文本换行。实际 Chrome 页面确认 46 张表头完全一致；TPopup.show 参数表与返回表各列对齐，截图为 `popup-uniform-tables.png`。内置浏览器标签连接不可用，本轮改用已打开的 Chrome 本地页面验收。

本轮未改变组件实现或调用方式，未推送；其他 56 份 API 资产和正式工具依赖 ref 未修改。两版 SDK 的工具完整回归各 78 项、消费审计正反例各 51 项及真实 Popup API 页面各 1 项通过，相关严格 analyze 均零问题。全量新旧资产契约审计均零问题；Popup validate 均 ERROR=0/WARN=0。双版生成字节一致，六个 Popup 源文件运行 token 与 `0eb6a054` 相同，46 张表的数据与关系逐项对比保持完整。官网 18 项测试及生产构建通过，Flutter Web 构建并装配完成，嵌入 API 文件与源码资产字节相同。示例交互未重新验收，远端 CI 未复验。

证据：`tools-uniform-*.log`、`uniform-tools-analyze-*.log`、`uniform-audit-*.log`、`uniform-analyze-*.log`、`uniform-inventory-*.json`、`uniform-tokens-*.log`、`uniform-demo-*.log`、`uniform-generate-*.log`、`uniform-validate-*.log`、`uniform-output-contract.json`、`uniform-site-build.log`、`uniform-web-build.log`、`uniform-browser-check.json`。产物 SHA256：`99112737d0cb1fac746f2416ef40d4bd61e0fcd0d2349dd24a5ec5cfcff3fa90`。

## 回调类型定义改为表格（上一候选）

三个 Popup 回调 typedef 的说明表和源码声明合并为「回调参数」与「返回值」五列表格。参数说明改用标准 dartdoc 参数段落，Widget/void 返回说明由源码维护；生成器沿用可调用成员模型，不在渲染层解析签名文本或猜测参数语义。别名泛型、回调泛型、可空性和位置参数顺序保留；非函数别名以目标类型表呈现。消费审计独立从导出的 AST 比对契约，兼容旧声明资产；正反例涵盖错误类型、必传、顺序、重复/缺失参数、泛型、可空性和错误返回值，说明表不能补足参数。

只生成 Popup：49 张表统一五列，三个回调共 6 个参数及 3 个返回表；原有 16 类型、24 调用入口和 135 个调用参数不变。与上一份五列候选相比，仅三个回调章节变化，另外 13 个类型章节字节相同，页面无源码代码块。六个 Popup 文件运行 token 与 `0eb6a054` 相同，本轮新增组件源码修改只涉及 `t_popup_types.dart` 注释，不改变 API 或组件行为。

双 SDK 工具完整回归各 83 项，新增消费 typedef 契约单元测试各 6 项与真实审计 CLI 正反例各 1 项、Popup API 页面测试各 1 项通过；工具和相关消费源码严格 analyze 零问题。全量 57 份新旧资产 AST 契约审计零问题；Popup validate ERROR=0/WARN=0，双版生成字节相同。此前消费 51 项完整回归属于上一候选，本轮针对 typedef 新分支验证。官网 18 项测试及生产构建、Flutter Web 构建通过，装配后的嵌入 API 与消费资产字节相同。实际 Chrome 页面逐一检查三个回调表的参数类型、说明、必传及 Widget/void 返回值，全部 49 表表头一致，截图 `popup-typedef-tables.png`。

未推送，正式依赖 ref 和其他 56 个组件资产未改动；远端 CI 与示例交互未复验。当前资产 SHA256：`86e4c4d28cb7c93b56a2fd91b1dcb319a20ad33ed80462efe52feb5828085688`。证据：`tools-typedef-*.log`、`typedef-tools-analyze-*.log`、`typedef-consumer-*.log`、`typedef-cli-test-*.log`、`typedef-analyze-*.log`、`typedef-demo-*.log`、`typedef-inventory-*.json`、`typedef-generate-*.log`、`typedef-validate-*.log`、`typedef-tokens-332.log`、`typedef-output-contract.json`、`typedef-browser-check.json`、`typedef-site-build.log`、`typedef-web-build.log`。

## 使用契约说明修正（当前验收范围）

维护者要求先修正 Review 中的安全区、关闭时序、重新打开时的主题配置和尺寸/内容布局说明；示例与类型跳转暂不处理。仅修改公开 dartdoc 并重新生成 Popup，不改组件实现、公开签名、默认行为或其他组件资产，不新增 API 示例、源码声明或组织性说明表。

- 安全区按方向说明实际避让边：top 仅上、bottom 仅下、left 为左/上/下、right 为右/上/下、center 为全部边。
- 区分显隐变化、路由结果和动画完成；关闭完成前重新打开时，旧周期不触发 onClosed。
- handle.options 为 show 时合并后的配置；重新打开重新捕获内容 Theme，但不重新解析已经合并的 Popup Theme 配置。
- 面板尺寸受可用空间约束；底部高度包含头部，居中面板高度不包含外部关闭区，长内容由调用方提供滚动布局。

本轮仅修改 `t_popup.dart`、`t_popup_handle.dart`、`t_popup_options.dart` 的注释，以及生成资产与验收记录。双 SDK 生成字节一致、Popup validate ERROR=0/WARN=0，全量 57 份新旧资产 AST 契约审计零问题，Popup 严格 analyze 零问题，六个 Popup 源文件运行 token 与 HEAD 不变，无 breaking change。

双 SDK 各 10 项现有定向行为测试、2 项临时业务行为验证和 1 项真实 API 页面测试通过。临时验证确认 result 在关闭动画完成前返回、显隐开始通知同步触发、重新打开保留已解析 Popup 配置但内容捕获新 Theme、底部头部占用总面板高度；测试位于证据目录，不新增仓库测试。新版初次测试遇到旧 SDK 遗留的 ink_sparkle 编译资产不可解码，清理生成的 unit_test_assets 后重新运行全部本轮新版检查通过；未改组件或测试来规避。

49 张表继续统一五列，16 个类型及调用契约保留；与本轮起点逐行对比，仅说明单元格变化，名称、类型、默认值、必传与顺序不变，其他 56 份资产不变。实际 Chrome 页面核对了安全区、生命周期、结果、主题及布局说明，旧错误安全区描述消失；未新增源码代码块。

官网 18 项测试与生产构建、最新 SDK Flutter Web 构建通过。Web 已重新装配到预览，嵌入和 HTTP 返回的 Popup API 与源码资产字节相同。示例及跳转暂缓，未重验七个示例交互，未推送或复验远端 CI。

本轮证据目录：`/tmp/tdesign-api-full-review/popup-presentation/usage-contract/`，含 `generate-*.log`、`validate-*.log`、`behavior-*.log`、`characterization-*.log`、`analyze-*.log`、`inventory-*.json`、`tokens-*.log`、`api-page-*.log`、`site-build.log`、`web-build.log`、`output-contract.json`、`browser-check.json`、`preview-assets.json`、`popup-handle-contract.png`。当前资产 SHA256：`6c9d92f47d144e8a7a1909ba15e636ea0770112c3fd1334e74ac6197c06883d1`。

## 本地预览与证据

[Popup API](http://127.0.0.1:4173/flutter/components/popup?tab=api#tpopupoptions)，[Popup 示例](http://127.0.0.1:4173/flutter/components/popup?tab=demo)。

本地官网构建会清理 `_site`，须重新装配 Flutter Web，才能显示嵌入手机：

```sh
cd tdesign-component/example
flutter build web --no-pub --base-href /flutter/example/ --no-web-resources-cdn --pwa-strategy=none
cd ../../
mkdir -p tdesign-site/_site/example
cp -a tdesign-component/example/build/web/. tdesign-site/_site/example/
```

示例页两组源码片段对应当前公开 Demo：基础组五个方向，应用组标题操作与自定义关闭按钮，共七个场景。上一轮浏览器实际打开/关闭中间弹出与标题底部弹出；本轮重新构建 Web，但未重新逐场景交互，不宣称七个场景或组件设计/Golden 均完成验收。窄屏隐藏右侧嵌入手机，可直接访问 `/flutter/example/#popup`。

本轮证据位于 `/tmp/tdesign-api-full-review/popup-presentation/`：

- `tools-organization-*.log`、`organization-tools-analyze-*.log`：工具双版本测试和分析。
- `organization-audit-*.log`、`organization-consumer-analyze-*.log`、`organization-demo-*.log`：消费双版本测试和分析。
- `organization-generate-*.log`、`organization-validate-*.log`、`organization-inventory-332.json`：生成和源码契约。
- `organization-browser-audit.json`、`organization-browser-contract.log`、`organization-anchor-checks.json`：页面 16 个类型、24 个调用入口、135 个参数与实际目录定位。
- `organization-source-contract.log`、`organization-site-build.log`、`organization-web-build.log`：注释修改的 token 等价、官网构建及 Web 构建。
- `popup-organization.jpg`、`popup-placement-organization.jpg`、`popup-constructor-organization.jpg`：实际布局截图。

此前 69/33 项统一精简与 73/35 项标题归属测试属于历史候选；各历史结果仅适用于对应候选，当前候选的结果见「回调类型定义改为表格」一节。历史 Web 场景截图仍为 `web-popup-center.jpg`、`web-popup-header.jpg`。

## 交付边界

- [x] Popup 信息组织修复及本地程序、实际页面逐类型验收完成。
- [x] 维护者已授权以当前 Popup 方案推广全部组件。
- [x] 已推广全量生成与 API 页面结构验收，逐组件记录见 all-presentation.md；正式工具/远端门禁仍单列。
- [ ] 工具和消费仓库正式交付及最终 head 的 CI/autofix 复验。

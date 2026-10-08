# 验收记录

## 当前交付状态

本轮全量内容复检详见 [逐组件审查与影响报告](./component-review.md)。57 个组件逐一对照实现，修复错误、缺失和重复的源码注释；组件生产源码相对 develop 的 128 文件 Token 等价，Demo 使用方式的改动单独列在报告中。

**本轮最终产物依赖工具 PR #29，尚不能声明正式链可合并。** 候选工具已完成本地全量生成和页面验收；正式 main 当前仍为 #28 的合并提交 96f1c693。本轮修复已保存为提交 1d8c2a09，维护者于 2026-10-08 明确要求先推送 #1149；待 #29 合并后重新解析正式依赖、生成/--check，并核对最终 head 的 CI/autofix。不得用起点 head 的绿色 CI 代替本轮交付。

## Popup 展示候选（2026-10-08，仅本地）

当前仅 Popup 采用新的展示规则，其他组件的新展示尚未验收。46 张表全部统一为「名称 / 类型 / 默认值 / 说明 / 必传」，不适用项为 `-`，实际页面确认表头与列宽一致。16 个类型、24 个调用入口、135 个参数及 7 个返回类型/说明保持完整，12 张说明表的全部关系保留。两版 SDK 工具各 78 项、消费审计各 51 项、真实 Popup API 页面各 1 项通过；严格 analyze、全量契约审计及 Popup validate 均无问题。官网 18 项及生产构建、Flutter Web 构建与本地装配通过。六个 Popup 文件运行 token 与 `0eb6a054` 相同，本次组件源码仅改三文件注释及空行，使用方式不变。详细范围、截图和证据见 [Popup 展示验收](./popup-presentation.md)。本轮工作区改动未推送，远端 CI 未复验。

## 历史结构与页面验收（#29 之前）

下列记录针对工具 #28 与消费 PR 原 head，保留用于复现和对比。结构非空与页面可见不能证明自然语言内容正确；此前全量语义通过结论已撤回，本轮以 component-review.md 为准。



- 57 个组件（含全局 Theme）、369 个公开声明、435 个可调用声明、2510 个参数与 analyzer AST 逐项对应。
- 递归导出、part、show/hide、命名扩展、普通实例方法、访问器、控制器、构造函数、枚举和 typedef 纳入文档。
- 修复默认构造参数章节误截断、external 签名、字符串空白、旧式函数参数类型及业务 build/custom override 静默遗漏；补充 TSwipeCellPanel.build 及其 context 的真实语义。
- 自定义 Theme 的 copyWith/lerp 与 TMap.[] 已展示并补注释。声明保留泛型及约束、位置/命名参数、const/factory 标记和默认值；各方法参数表独立完整展示。
- 最终候选工具在两个 SDK 下全量生成 57 份 API，跨版本与重复生成字节完全一致。默认 manifest 的全量 validate 两版本均 ERROR=0、WARN=0。
- 公开声明/字段/枚举值/方法无缺注释；参数说明、类型和默认值非空，签名及参数清单、类型、默认值、必填状态无缺口。检查结果为 0 issue。
- 修复 Swiper 目标索引误复用当前索引说明；Token 查询 key 不使用 Widget key 的说明；普通方法参数不再凭同名字段推测说明。补充 Popup 返回值、Message 关闭回调及 Theme 查询/复制参数的实际语义。
- 没有独立 Theme 的五个组件说明实际共用的 Theme 或全局 Token；官网链接直接打开 API 标签并定位到对应类型。
- 85 个修改的组件生产源码文件与 develop 基础逐 Token 对比，排除注释和格式化尾逗号后完全一致，无签名/默认行为改变，无 breaking change。
- Flutter 3.32.0 / Dart 3.8.0 与官方 stable Flutter 3.47.6@5fc346839b / Dart 3.13.5 分别重新解析依赖，严格 analyze 零问题。
- 工具两版本各 60 项测试通过、严格 analyze 零问题。工具最终 head dc679da 的 8 项远端检查均通过：[双版本完整回归](https://github.com/TDesignOteam/tdesign-flutter-tools/actions/runs/37682677923)、[二进制构建](https://github.com/TDesignOteam/tdesign-flutter-tools/actions/runs/37682678142)；回归日志确认各 60 项测试通过、严格分析零问题。CLI 四次冷启动回归采用两分钟测试上限，正反例断言完整保留。
- 消费仓库新增 18 项审计器 CLI 正反例：缺参数、错类型/默认值/必填、重复/多余参数、泛型约束和位置/命名参数丢失、转义竖线后的空类型、自定义覆盖方法缺注释、JSON 退出码、新增导出未登记及内部声明过滤。加入 GitHub / CNB 同一工具回归入口，两版本均实际执行该入口且 37 项测试通过。
- `pnpm site` 的 18 项测试及站点构建通过，仅有既存构建提示。
- 最终构建逐页打开 API 标签，57/57 页面通过；可见公开声明标题共 369，每页数量与 manifest 对应，Dart 签名代码块非空。DateTimePicker → TPickerThemeData 链接实际定位成功。
- 组件契约检查、Demo 结构检查与示例代码 `--check` 通过；现有 Theme Demo 已注册。
- Demo API 页面使用真实 AssetManifest 解析 API 资产，修复 12 组路由名与文件 slug 不一致；57 个组件的全部公开声明在真实 ApiPage 上显示。旧注册名和 canonical slug 共 69 个入口及缺失文档切换共 70 项测试，两版本全部通过，修改文件两版本严格 analyze 零问题。测试已加入 sharedExampleTests，进入 GitHub / CNB 双版本共享功能回归。
- PR #1149 首轮 head d357be79 的远端双版本 analyze、双版本功能回归、站点预览构建和 Linux Golden 已通过；六个构建与 autofix 日志均确认仅在生成 API 阶段报正式工具不认识 --strict-names；没有自动修改 head。Demo 入口修复后的旧 head 结果不能代替当前 head。代码提交 54212274 的双版本 analyze 和代码扫描已通过，双版本功能回归及站点/Golden 当时仍在运行；六个构建与 autofix 均逐项读取日志，确认仍是正式 main 旧工具不支持 --strict-names。这些运行均发生在工具合并前；合并后按正式依赖重新触发 CI，不沿用旧失败状态。

## 历史语义检查范围（全量通过结论已撤回）

逐组件清单、签名、参数表、注释非空及官网输出均已检查。新增/修改的语义说明按实现核对：Theme 空值保留与插值规则、Token 引用/默认映射回退、Dropdown 布局和关闭时机、Dialog/Popup 路由结果、Form 校验与错误清除、Swiper 索引和动画、TimeCounter 重置、DateTimePicker partial 补齐、Indexes sticky 状态、Font 字号和行高以及五个组件的共用主题。

TThemeData.lerp 明确记录不使用 t 做连续插值；TMap 循环引用中止后仍可走默认映射。自动非空检查不等同于自然语言语义证明。本次没有组件视觉行为变更，不更新 Golden 基线，不宣称设计对齐或设备验收。

## 历史复现命令与门禁

```bash
# 各 Flutter 版本分别执行，先重新解析依赖
cd tdesign-component
flutter pub get
flutter analyze --no-pub --fatal-infos
dart run tool/audit_api_docs.dart
flutter test --no-pub test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart test/tool/audit_api_docs_test.dart

# 工具正式 main 包含 #28 后执行
flutter pub upgrade tdesign_flutter_tools
node tool/generate_api.mjs
node tool/generate_api.mjs --check
dart run tool/audit_api_docs.dart

cd ../tdesign-site
pnpm site
```

正式依赖已确认解析到 96f1c693，两个 SDK 的 57 份生成结果均与提交资产一致，审计结果仍为 369 个声明、435 个可调用声明、2510 个参数及 0 issue；validate 均 ERROR=0、WARN=0。最新 CI/head 与 autofix 产物 diff 以 [PR #1149 的检查和描述](https://github.com/Tencent/tdesign-flutter/pull/1149) 为准，autofix 修改 head 时必须重新检查自动提交内容和最终检查。

## 历史逐组件结构记录

“可调用声明”包含默认/命名/factory 构造及公开方法、顶层函数，包含公开类的隐式构造；标准框架生命周期方法不计入。主题归属按当前实现记录。每行“通过”包括清单、成员、声明签名及参数类型/默认值/必填的 AST 检查和浏览器可见输出；非独立组件 Theme 不虚构新类。所有组件另经过真实 Flutter ApiPage 加载及标题渲染测试；12 组旧名/slug 入口均验证。

| 组件 | 公开声明 | 公开构造 | 可调用声明 | 参数 | 主题归属 | 源码与 API 契约 | 官网 API | Demo API |
| --- | ---: | ---: | ---: | ---: | --- | --- | --- | --- |
| button | 7 | 2 | 4 | 17 | TButtonThemeData | 通过 | 通过 | 通过 |
| divider | 4 | 2 | 4 | 21 | TDividerThemeData | 通过 | 通过 | 通过 |
| fab | 7 | 4 | 6 | 35 | TFabThemeData | 通过 | 通过 | 通过 |
| icon | 1 | 2 | 2 | 10 | 全局 Token + size/color | 通过 | 通过 | 通过 |
| link | 4 | 2 | 4 | 18 | TLinkThemeData | 通过 | 通过 | 通过 |
| text | 4 | 4 | 9 | 59 | TTextThemeData | 通过 | 通过 | 通过 |
| back-top | 4 | 2 | 4 | 32 | TBackTopThemeData | 通过 | 通过 | 通过 |
| drawer | 7 | 3 | 7 | 54 | TDrawerThemeData | 通过 | 通过 | 通过 |
| indexes | 10 | 10 | 13 | 98 | TIndexesThemeData | 通过 | 通过 | 通过 |
| navbar | 4 | 4 | 6 | 40 | TNavBarThemeData | 通过 | 通过 | 通过 |
| side-bar | 4 | 3 | 5 | 26 | TSideBarThemeData | 通过 | 通过 | 通过 |
| steps | 5 | 4 | 4 | 20 | 全局 Token | 通过 | 通过 | 通过 |
| tab-bar | 11 | 6 | 8 | 53 | TTabBarThemeData | 通过 | 通过 | 通过 |
| tabs | 7 | 5 | 7 | 41 | TTabsBarThemeData | 通过 | 通过 | 通过 |
| calendar | 10 | 4 | 6 | 49 | TCalendarThemeData | 通过 | 通过 | 通过 |
| cascader | 4 | 3 | 5 | 31 | TCascaderThemeData | 通过 | 通过 | 通过 |
| checkbox | 9 | 4 | 6 | 49 | TCheckboxThemeData | 通过 | 通过 | 通过 |
| picker | 10 | 7 | 10 | 35 | TPickerThemeData | 通过 | 通过 | 通过 |
| date-time-picker | 8 | 4 | 5 | 24 | TPickerThemeData | 通过 | 通过 | 通过 |
| form | 11 | 6 | 18 | 68 | TFormThemeData | 通过 | 通过 | 通过 |
| input | 4 | 2 | 4 | 47 | TInputThemeData | 通过 | 通过 | 通过 |
| radio | 8 | 5 | 7 | 49 | TRadioThemeData | 通过 | 通过 | 通过 |
| rate | 3 | 2 | 4 | 28 | TRateThemeData | 通过 | 通过 | 通过 |
| search | 4 | 2 | 4 | 44 | TSearchBarThemeData | 通过 | 通过 | 通过 |
| slider | 5 | 3 | 5 | 50 | TSliderThemeData | 通过 | 通过 | 通过 |
| stepper | 4 | 2 | 4 | 34 | TStepperThemeData | 通过 | 通过 | 通过 |
| switch | 4 | 2 | 4 | 32 | TSwitchThemeData | 通过 | 通过 | 通过 |
| textarea | 2 | 1 | 1 | 27 | TInputThemeData + 全局 Token | 通过 | 通过 | 通过 |
| tree-select | 3 | 3 | 5 | 33 | TTreeSelectThemeData | 通过 | 通过 | 通过 |
| upload | 9 | 3 | 6 | 68 | TUploadThemeData | 通过 | 通过 | 通过 |
| avatar | 6 | 3 | 5 | 35 | TAvatarThemeData | 通过 | 通过 | 通过 |
| badge | 5 | 5 | 7 | 42 | TBadgeThemeData | 通过 | 通过 | 通过 |
| cell | 6 | 3 | 5 | 57 | TCellThemeData | 通过 | 通过 | 通过 |
| time-counter | 7 | 3 | 8 | 25 | TTimeCounterThemeData | 通过 | 通过 | 通过 |
| collapse | 7 | 3 | 5 | 43 | TCollapseThemeData | 通过 | 通过 | 通过 |
| empty | 2 | 2 | 4 | 11 | TEmptyThemeData | 通过 | 通过 | 通过 |
| footer | 2 | 2 | 4 | 8 | TFooterThemeData | 通过 | 通过 | 通过 |
| image | 3 | 2 | 4 | 36 | TImageThemeData | 通过 | 通过 | 通过 |
| image-viewer | 3 | 1 | 4 | 32 | TImageViewerThemeData | 通过 | 通过 | 通过 |
| progress | 4 | 7 | 9 | 65 | TProgressThemeData | 通过 | 通过 | 通过 |
| result | 3 | 2 | 4 | 13 | TResultThemeData | 通过 | 通过 | 通过 |
| skeleton | 8 | 10 | 12 | 47 | TSkeletonThemeData | 通过 | 通过 | 通过 |
| swiper | 8 | 4 | 10 | 65 | TSwiperThemeData | 通过 | 通过 | 通过 |
| table | 15 | 6 | 8 | 57 | TTableThemeData | 通过 | 通过 | 通过 |
| tag | 7 | 3 | 5 | 44 | TTagThemeData | 通过 | 通过 | 通过 |
| action-sheet | 8 | 6 | 12 | 68 | TActionSheetThemeData | 通过 | 通过 | 通过 |
| dialog | 5 | 4 | 9 | 60 | TDialogThemeData | 通过 | 通过 | 通过 |
| dropdown-menu | 14 | 9 | 16 | 94 | TDropdownThemeData | 通过 | 通过 | 通过 |
| loading | 4 | 3 | 8 | 23 | TLoadingThemeData | 通过 | 通过 | 通过 |
| message | 5 | 3 | 9 | 45 | TMessageThemeData | 通过 | 通过 | 通过 |
| notice-bar | 4 | 2 | 7 | 33 | TNoticeBarThemeData | 通过 | 通过 | 通过 |
| popover | 7 | 4 | 11 | 51 | TPopoverThemeData | 通过 | 通过 | 通过 |
| popup | 16 | 14 | 24 | 135 | TPopupThemeData | 通过 | 通过 | 通过 |
| pull-down-refresh | 4 | 3 | 4 | 16 | TLoadingThemeData + 全局 Token | 通过 | 通过 | 通过 |
| swipe-cell | 7 | 5 | 11 | 27 | TSwipeCellThemeData | 通过 | 通过 | 通过 |
| toast | 5 | 3 | 16 | 104 | TToastThemeData | 通过 | 通过 | 通过 |
| theme | 27 | 10 | 37 | 82 | 全局 Token / Material 扩展 | 通过 | 通过 | 通过 |

## Popup 表格优先追加验收

已精简六个 Popup 源文件的 dartdoc 并生成本地候选。双 SDK 静态分析、运行 token 等价、生成/validate、全量 AST 契约审计和真实 Popup API 页面测试通过；官网 18 项测试、生产构建和 Flutter Web 构建通过。16 类型、24 可调用 API、135 参数和 3 typedef 保留。具体内容与边界见 [popup-presentation.md](./popup-presentation.md) 最新候选章节；仍待维护者确认，不扩大到其他组件，不推送。


## Popup 返回值追加验收

移除 TPopup.show 调用行为表，行为保留一句；统一在参数之后展示所属方法的返回值标题和类型/说明表，void 与构造不增加空表。Popup 七个非 void 方法补齐源码返回说明，参数与运行 token 不变。两版 SDK 的工具回归各 77 项、消费审计各 47 项、Popup API 页面测试各 1 项通过，严格分析、全量 AST 契约审计及 Popup validate 零问题。官网 18 项测试与构建、Flutter Web 构建通过，本地预览已装配；实际页面核对标题、顺序、类型、说明及窄窗口返回表宽度。仍仅 Popup 候选，待维护者确认，不推送。详细范围和证据见 [popup-presentation.md](./popup-presentation.md)。

## Popup 回调类型定义追加验收

三个回调统一使用五列参数/返回值表，页面不重复源码声明；保留类型、必传、顺序、泛型与可空性。49 张表表头一致，另外 13 个类型章节与上一候选相同，六个 Popup 文件运行 token 不变。双 SDK 工具各 83 项、新增消费契约各 7 项和 Popup API 页面各 1 项通过；相关严格分析、全量新旧资产审计和 Popup validate 零问题。官网及 Flutter Web 构建通过，并逐个核对三个回调的实际页面。详情见 [popup-presentation.md](./popup-presentation.md) 最新候选章节。仍只生成 Popup，未推送，待维护者确认后扩大范围。

## Popup 使用契约说明追加验收

修正安全区边界、关闭结果与动画/回调时序、重新打开时的主题配置，以及面板尺寸和内容布局说明。仅三份 Popup dartdoc、生成文档及验收记录变化，无实现或签名变更；示例及类型跳转按维护者要求暂缓。双 SDK 各 10 项定向行为测试、2 项临时业务行为验证和 1 项真实 API 页面测试通过；严格分析、全量 AST 契约审计和 Popup validate 零问题，生成字节一致，运行 token 不变。49 张五列表格仅说明单元格变化，其他 56 份资产不变。官网 18 项测试、生产构建及最新 Flutter Web 构建通过，预览已装配并核对实际页面和内嵌资产。新版 SDK 测试缓存冲突已清理并重跑通过，未修改组件绕过。范围和证据见 [popup-presentation.md](./popup-presentation.md)「使用契约说明修正」。仍未推送，尚不包含示例、跳转与远端 CI 的完整验收。


## 全量 Popup 展示规则推广（2026-10-08）

维护者已授权推广全部组件，本轮结果详见 [all-presentation.md](all-presentation.md) 和 `all-presentation-evidence.json`。57 份资产保留 369 声明、435 可调用声明、2510 参数；两 SDK 全量 generate/validate、独立 AST 与重复生成一致。当前 101 个修改的生产 Dart 文件全部非注释 token（含逗号）与本轮 HEAD 一致，运行行为/API/Demo 用法不变。

双版本严格 analyze 零问题，各 115 项文档专项、最终各 57 项展示测试、各 70 项真实 API 页测试及候选工具各 83 项完整回归通过。官网 18 项测试与构建通过；实际 API 面板 57/57、369 声明、812 张统一五列表，源码代码块/坏行/空返回说明为 0。新版 Web 构建及 57 份嵌入 API 与源码字节核对通过。

全工具测试中的既有 CJK 字体清单检查仍失败，缺“逆、批”，HEAD 同样缺失，未放宽门禁。逐组件结构结果不等于本轮重跑全部字段语义、Demo 交互、设计或 Golden。正式工具 ref 解析、正式 --check、推送后当前 head 的 CI/autofix 与 review 未复验；维护者随后已要求推送，交付记录见 all-presentation.md。示例补充与类型跳转继续暂缓。

证据：`/tmp/tdesign-api-all-20261008/`。

## 语义合理性修复复核（2026-10-08）

本轮修正六个组件的已证实文档缺口：Calendar、DateTimePicker、Form、Picker、PullDownRefresh、Theme。全部 57 份资产重新由当前源码双 SDK 生成并逐份比对，AST 审计无 issue；两版各 2707 项非 Golden 组件测试、70 项 API 页面测试、115 项文档专项测试通过。该结果证明当前资产、公开契约和回归稳定，不等于全部 Golden、Demo、设备、Figma 或每个业务边界均已完成语义验收。`TThemeData.lerp` 的 extraThemeData 丢失仍作为实现风险单列。

最新逐组件状态、经验和未完成门禁见 [reasonableness-repair.md](reasonableness-repair.md)。

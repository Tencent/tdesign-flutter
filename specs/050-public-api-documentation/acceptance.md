# 验收记录

## 当前交付状态

组件基础 `develop@dacc279e`；分支 `rss1102/docs/component-api-completeness`。独立 [工具 PR #28](https://github.com/TDesignOteam/tdesign-flutter-tools/pull/28) 最终候选提交 `dc679da608cd69df857ec882812bcc9eba9e8244`。

消费仓库保持正式 `main` 依赖，无临时 path override 或 PR 分支依赖。工具 PR 最新 head 的 8 项检查全部通过，含双版本完整回归、四个二进制构建、预览站及产物评论，尚未执行合并。因此正式 main 重新解析、全量生成、幂等校验及消费仓库最新 head 的 CI 仍是最终门禁，不能以候选验收代替。

## 全量结果

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
- PR #1149 首轮 head d357be79 的远端双版本 analyze、双版本功能回归、站点预览构建和 Linux Golden 已通过；六个构建与 autofix 日志均确认仅在生成 API 阶段报正式工具不认识 --strict-names；没有自动修改 head。Demo 入口修复后的旧 head 结果不能代替当前 head。代码提交 54212274 的双版本 analyze 和代码扫描已通过，双版本功能回归及站点/Golden 当时仍在运行；六个构建与 autofix 均逐项读取日志，确认仍是正式 main 旧工具不支持 --strict-names。该提交后的验收记录更新不改变实现，正式依赖门禁仍保留。

## 语义检查与边界

逐组件清单、签名、参数表、注释非空及官网输出均已检查。新增/修改的语义说明按实现核对：Theme 空值保留与插值规则、Token 引用/默认映射回退、Dropdown 布局和关闭时机、Dialog/Popup 路由结果、Form 校验与错误清除、Swiper 索引和动画、TimeCounter 重置、DateTimePicker partial 补齐、Indexes sticky 状态、Font 字号和行高以及五个组件的共用主题。

TThemeData.lerp 明确记录不使用 t 做连续插值；TMap 循环引用中止后仍可走默认映射。自动非空检查不等同于自然语言语义证明。本次没有组件视觉行为变更，不更新 Golden 基线，不宣称设计对齐或设备验收。

## 复现与最终门禁

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

正式工具合并后记录实际解析提交、幂等结果、消费 PR 最新 CI/head 与 autofix 产物 diff。

## 逐组件记录

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

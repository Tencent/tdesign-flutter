# Popup API 展示验收

日期：2026-10-08。仅验收 Popup，维护者确认后再扩大范围。以下结论对应本地候选，未推送；工具提交 `da425675e8eba15b76e77d772b3ce0c3f8187ab9`，远端工具 PR #29 的 CI 不包含本次展示调整。

## 当前信息结构

- 三级标题：公开类型或顶层函数。类型用途直接放在类型名下，不重复「简介」标题。
- 四级标题：使用说明、构造方法、属性、静态成员、静态方法、实例方法、枚举值或类型定义。按此顺序显示实际存在的分组，无空分组。
- 五级标题：使用说明的子节，或具体构造/方法的实际名称。默认构造、命名构造及工厂构造统一置于「构造方法」，默认构造优先，其余按名称排序。
- 六级标题：构造/方法内部说明；继续嵌套时使用加粗段落，避免越过所属 API。
- 参数表直接接在构造/方法说明之后，不再重复「参数」标题。「公开属性（字段与访问器）」精简为「属性」。
- 构造、静态/实例方法及顶层函数统一去掉完整签名代码块和 const 标识；保留参数类型、默认值、必填、位置/命名区别、返回类型、泛型约束及必要行为说明。无参 API 明示无参数。typedef 保留完整类型定义。
- API 页去掉完整示例、孤立示例标题和独立类型「声明」章节；专门示例页保留。

`TPopupOptions` 的「如何创建」改为「构造方式选择」，「字段与 TPopupPlacement」改为「不同弹出方向的可用参数」，两者均属于「使用说明」。生命周期、蒙层、Theme 优先级和默认动画时长作为共用说明放在两个子节之前，避免错误归属于方向参数表。

上述构造分组与层级规则在工具渲染层统一实现；默认构造转为临时渲染对象，复用同一正文入口，不改解析模型。工具校验器和消费审计器同时支持旧默认构造章节及新分组，按下一个同级 API 截断，避免借用后续命名构造的参数表。

## 修改范围与源码影响

本轮两个 Popup 源文件仅修改 dartdoc：`t_popup_options.dart` 调整标题和说明段落位置，`t_popup_types.dart` 同步引用标题。与本轮起点 HEAD 的 Dart token 对比完全一致；组件运行实现、API 签名、默认值和使用方式未改变，无 breaking change。本轮不需要更新日志。

只重新生成 `popup_api.md`，其余 56 份 API 资产未改。参数、属性和枚举表格行内容与上一候选完全一致，仅随构造排序重新组织。源码注释中的完整示例未删除，渲染层决定 API 页展示范围。

官网只调整类型标题重复检查：原子串检查会把五级默认构造标题也算成三级类型标题，改为匹配完整三级标题行。未改站点运行逻辑。正式依赖 ref 和工具锁文件未改。

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

产物 SHA256：`78f06d7c2530d790713c53cff8c34af8ae40e5c526fc71dfb260845dac2e408c`。

## 移除统一开场说明（维护者追加反馈）

移除每页 API 顶部的默认值列含义、Theme/Token 回退阅读规则、必填列阅读规则和参数传入规则总述。规则从生成器统一移除，仅重新生成 Popup。具体 API 的默认值、必填列、位置参数顺序及必要行为说明保留；与上一个候选逐字比较，仅删除这一个开场段落，其余正文完全一致。

追加验证：两 SDK 的既有展示回归各 8 项通过，修改的生成器严格 analyze 均零问题；Popup 双 SDK 输出完全一致，validate 均 ERROR=0/WARN=0。官网 18 项测试、生产构建及 Flutter Web 构建通过，预览已重新装配；浏览器确认开场说明消失、16 个类型仍在。没有重新运行上节完整 75/39 项套件，因为可调用 API、表格及审计逻辑均未改。

追加证据：`preamble-test-*.log`、`preamble-analyze-*.log`、`preamble-generate-*.log`、`preamble-validate-*.log`、`preamble-output-contract.log`、`preamble-site-build.log`、`preamble-web-build.log`、`preamble-browser-check.json` 及 `popup-without-preamble.jpg`。

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

此前 69/33 项统一精简与 73/35 项标题归属测试属于历史候选；本报告以本次 75/39 项结果为准。历史 Web 场景截图仍为 `web-popup-center.jpg`、`web-popup-header.jpg`。

## 交付边界

- [x] Popup 信息组织修复及本地程序、实际页面逐类型验收完成。
- [ ] 维护者确认 Popup 信息组织合理。
- [ ] 确认后生成并逐页验收其余组件，更新全量报告。
- [ ] 工具和消费仓库正式交付及最终 head 的 CI/autofix 复验。

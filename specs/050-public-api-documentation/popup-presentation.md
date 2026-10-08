# Popup API 精简展示验收

日期：2026-10-08。按维护者要求仅验收 Popup，确认后再扩大范围。当前为本地候选，尚未推送这些展示调整。工具候选提交 `ab09c82841d02ed559b65786a3916c5b3ee35b1d`，包含此前类型声明、示例与构造精简候选；远端工具 PR #29 的 CI 不包含本地展示调整。

## 展示规则

- API 正文去掉完整示例代码、孤立示例标题和独立类型「声明」章节；源码 dartdoc 及独立示例页保留。
- 构造、静态/实例方法和顶层函数共用同一个渲染入口，统一去掉完整签名代码块及 const 标识，展示名称、参数表、返回类型和必要行为说明。仅位置参数另列名称及传入顺序，其他参数默认按名称传入，不再重复一整串调用格式；无参 API 注明无参数。
- typedef 保留类型定义；类型与方法泛型约束、extension 适用类型使用简短说明。参数类型、默认值、必填状态、位置/命名参数区别及行为契约不丢失。
- 规则在工具渲染层实现，不修改解析模型，不手工修改生成资产。
- 官网去掉重复维护的「如何创建」和字段关系表，使用 dartdoc 生成的同一份说明。专门示例页保留基础弹出层与应用示例。

## Popup 前后对比

| 内容 | 原展示 | 构造精简候选 | 统一候选 |
| --- | ---: | ---: | ---: |
| 公开类型 | 16 | 16 | 16 |
| 可调用 API | 24 | 24 | 24 |
| 参数 | 135 | 135 | 135 |
| 独立类型声明代码块 | 11 | 0 | 0 |
| 完整示例代码（API 页） | 2 | 0 | 0 |
| 完整构造签名代码块 | 14 | 0 | 0 |
| 完整方法签名代码块 | 10 | 10 | 0 |
| typedef 定义代码块 | 3 | 3 | 3 |
| Dart 代码块总数 | 40 | 13 | 3 |
| 官网「如何创建」 | 2 | 1 | 1 |

本轮参数、属性及枚举表格行逐字不变。组件生产源码和 dartdoc 未修改，无公开 API 或默认行为变更，无 breaking change。其他 56 份 API 资产未重新生成；全量报告和 review-evidence.json 属于历史内容审查，不能代表新展示规则已全量验收。

## Popup 类型逐项验收

按源码 AST 清单核对浏览器参数数量、构造/方法入口、枚举及 typedef；14 个构造入口仍在，const 构造及全命名工厂不重复展示代码。Popup 的构造参数均为命名参数或无参数；方法中的位置参数在浏览器核对传入顺序；构造位置参数、方法泛型和顶层函数的统一规则另由工具及审计器正反例验证。

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

## 本轮验证

- Flutter 3.32.0 / Dart 3.8.0 与 Flutter 3.47.6 / Dart 3.13.5：工具完整回归各 69 项通过，严格静态分析零问题。覆盖全命名、无参、位置/混合参数、const/工厂/external 构造、静态/实例/extension/顶层泛型方法和生成器重复渲染。
- 审计器 CLI 两版本各 33 项正反例通过；接受所有可调用 API 的统一精简展示，仍拒绝错误类型、默认值、必填、缺失/多余/重复参数、位置顺序和分组错误、丢失泛型约束及返回类型；兼容其余组件旧版完整签名资产。改动的工具/审计测试文件严格 analyze 两版本零问题。
- Popup 双 SDK 生成字节一致；validate 两版本 ERROR=0 / WARN=0；源码 AST 审计零问题。
- 真实 Flutter Demo 的 Popup API 页面两版本通过，公开类型完整渲染。
- 官网 18 项测试及生产构建通过（保留既有大 chunk 提示）；浏览器核对 16 个类型、135 个参数，逐类型与 AST 数量相同。API 无独立声明、完整示例和任何可调用 API 的完整签名，剩余 3 个 typedef 代码块；专门示例页的 BasePopupsExample / ApplicationPopupsExample 保留。
- 生成产物仅修改 Popup；未改组件实现、使用方式或正式依赖 ref。SDK 切换引起的工具锁文件变化已还原，不纳入候选。

产物 SHA256：`66accb661ded150fc8b40cbe0ffcc8f9649c8594dad9ace340c06f894d8a8bd2`。

预览：[Popup API](http://127.0.0.1:4173/flutter/components/popup?tab=api)，[Popup 示例](http://127.0.0.1:4173/flutter/components/popup?tab=demo)。

## 待维护者确认

- [x] Popup 全部可调用 API 统一精简实现及本地程序、浏览器验收完成。
- [ ] 维护者确认 Popup 信息组织合理。
- [ ] 确认后生成并逐页验收其余组件，更新全量报告。
- [ ] 工具和消费仓库正式交付及最终 CI/autofix 复验。

证据保存在 `/tmp/tdesign-api-full-review/popup-presentation/unified-*.log`、`unified-browser-audit.json`；截图 `popup-show-unified.jpg`。本轮不含组件设计/Golden 验收。

## 本地 Flutter Web 预览复核

维护者反馈示例仅有两个代码块、手机预览未显示后，核对 `popup_page.dart` 与代码片段 manifest：两组源码片段完整对应当前公开 Demo，基础组含五个方向，应用组含标题操作与自定义关闭按钮，共七个可操作场景。这个数量反映现有 Demo 结构，不等同于全部 API、主题及生命周期行为均有公开示例。

此前仅启动 Vite preview，没有装配 Flutter Web 产物。`/flutter/example/flutter_bootstrap.js` 被 SPA fallback 返回为官网 HTML，导致 iframe 显示错误页面。使用当前源码通过 Flutter 3.32.0 构建 Web，并将产物放入 `_site/example/`；Vite preview 的 `/flutter/` base 会映射这个目录。JavaScript 响应随后为正确的 `text/javascript`，浏览器实际显示 Popup Demo。本地装配步骤：

```sh
cd tdesign-component/example
flutter build web --no-pub --base-href /flutter/example/ --no-web-resources-cdn --pwa-strategy=none
cd ../../
mkdir -p tdesign-site/_site/example
cp -a tdesign-component/example/build/web/. tdesign-site/_site/example/
```

站点再次构建会清理 `_site`，须再次装配 Flutter 产物。正式发布仍使用已有 `preview-build.yml` 的站点与 Web 合并流程，没有修改发布配置。

在桌面断点实际验证：中间弹出打开后显示面板，点击蒙层关闭；带标题及操作的底部弹出显示标题、取消、确定，点击取消关闭。证据为 `web-preview-build.log`、`web-popup-preview.jpg`、`web-popup-center.jpg`、`web-popup-header.jpg`，位于上述临时证据目录。本次浏览器交互仅覆盖这两个场景，其余五个未逐一点击。窄屏站点会隐藏右侧嵌入手机，可直接访问 `/flutter/example/#popup` 查看。

## 注释标题归属修复

实际页面发现 `TPopupOptions` 下「如何创建」及「字段与 TPopupPlacement」原为二级标题，越过所属三级类型标题。生成器此前直接复制 dartdoc 的 Markdown 标题，是层级错误的来源。

修复统一置于渲染层：类型说明从四级开始，默认构造和顶层函数说明从五级开始，命名构造与方法说明从六级开始；内部标题保留相对深度，超出六级改为加粗段落。类型用途说明直接放在类型名下，删除全部 16 处重复「简介」标题。保留原说明内容和标题文字，组件源码 dartdoc 未修改。

审计器同步调整默认构造的章节边界，允许五级说明标题，仍核验其后的参数类型；增加接受正确类型和拒绝错误类型的两个 CLI 回归用例。

浏览器实际定位到 `TPopupOptions` 核验：类型为三级，「如何创建」「字段与 TPopupPlacement」「工厂构造方法」为四级，各命名构造为五级。右侧目录仅有 16 个类型；API 区没有二级标题或「简介」标题，逐类型参数合计仍为 135，三个 typedef 定义完整。参数、属性及枚举表格行与上一候选逐字相同。只重新生成 Popup，其余 56 份资产未改。

标题修复的证据：`headings-browser-audit.json`、`popup-heading-hierarchy.jpg`、`tools-headings-*.log`、`headings-tools-analyze-*.log`、`headings-audit-*.log`、`headings-consumer-analyze-*.log`、`headings-demo-*.log`、`headings-site-build.log` 与 `headings-web-build.log`。之前的 69/33 项结果对应上一轮候选。


本轮修复完成后的验证：Flutter 3.32.0 与 3.47.6 的工具完整回归各 73 项、审计 CLI 各 35 项、真实 Popup API 页面测试各 1 项全部通过；工具与消费审计器的严格静态分析均零问题。两 SDK 生成字节一致，validate 均 ERROR=0/WARN=0，源码清单审计零问题；官网 18 项测试与生产构建通过，Flutter Web 重新构建并装配至本地预览。修复已保存为本地提交，尚未推送，未进行其余组件的新规则验收。

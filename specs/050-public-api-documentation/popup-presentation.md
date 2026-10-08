# Popup API 精简展示验收

日期：2026-10-08。按维护者要求仅验收 Popup，确认后再扩大范围。当前为本地候选，尚未推送这些展示调整。工具候选提交 `36c4f4cd71330ea3bf46e6352f19ab5856123bc0`，包含此前类型声明、示例与构造精简候选；远端工具 PR #29 的 CI 不包含本地展示调整。

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

产物 SHA256：`033ab5a70ef09a8fe76de354f7a3e37fdfecae1fbd60050bb969720a529d0ed9`。

预览：[Popup API](http://127.0.0.1:4173/flutter/components/popup?tab=api)，[Popup 示例](http://127.0.0.1:4173/flutter/components/popup?tab=demo)。

## 待维护者确认

- [x] Popup 全部可调用 API 统一精简实现及本地程序、浏览器验收完成。
- [ ] 维护者确认 Popup 信息组织合理。
- [ ] 确认后生成并逐页验收其余组件，更新全量报告。
- [ ] 工具和消费仓库正式交付及最终 CI/autofix 复验。

证据保存在 `/tmp/tdesign-api-full-review/popup-presentation/unified-*.log`、`unified-browser-audit.json`；截图 `popup-show-unified.jpg`。本轮不含组件设计/Golden 或 Flutter Web 示例交互验收。

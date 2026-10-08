# Popup API 精简展示验收

日期：2026-10-08。维护者要求先只验收 Popup，确认后再扩大范围。当前为本地候选，尚未推送本轮展示调整。工具候选提交 `1ed48549d5ebaef910318abf42ae4dc0ff69d3ef`（工具 PR #29 的远端 CI 尚不包含这次精简）。

## 展示规则

- API 正文不显示完整示例代码与孤立示例标题，源码 dartdoc 不变；行内参数值、默认值、约束、返回值、异常与回调说明保留。
- 删除独立的类/extension「声明」章节；保留构造、静态/实例方法的调用签名及 typedef 定义。泛型参数约束与 extension 适用类型使用简短说明，不丢失类型契约。
- 规则在生成工具的渲染层实现，解析模型不变，不手工删改 API 产物。
- Popup 官网移除重复的手写「如何创建」和字段关系表，保留 dartdoc 生成的同一份说明。示例页仍有基础弹出层和应用示例。

## Popup 前后对比

| 内容 | 修改前 | 修改后 |
| --- | ---: | ---: |
| 公开类型 | 16 | 16 |
| 可调用 API | 24 | 24 |
| 参数 | 135 | 135 |
| 独立类型声明代码块 | 11 | 0 |
| 完整代码示例（API 页） | 2 | 0 |
| Dart 代码块 | 40 | 27（24 个调用签名、3 个 typedef） |
| 官网「如何创建」 | 2 | 1 |

参数、属性、枚举等 Markdown 表格行逐字一致。组件生产源码和 dartdoc 没有修改，无 API/默认行为变更，无 breaking change。其他 56 份 API 资产未重新生成；此前全量报告及 review-evidence.json 是上一轮内容审查记录，不能代表新展示规则的全量验收。

## 本轮验证

- Flutter 3.32.0 / Dart 3.8.0 与 Flutter 3.47.6 / Dart 3.13.5：工具完整回归各 67 项通过，静态分析零问题。
- 审计器 CLI 正反例各 20 项通过；新展示允许省略类型声明，但仍要求泛型约束、extension 适用类型和全部调用签名完整。
- Popup 两 SDK 生成字节一致；重复生成一致；validate ERROR=0 / WARN=0。
- AST 审计 Popup 16 个类型、24 个可调用 API、135 个参数，零问题；组件严格 analyze 两版本均零问题。
- 真实 Flutter Demo 的 Popup API 页面两版本通过，全部公开类型可显示。
- 官网测试与生产构建通过；浏览器只验收 Popup：API 无声明及完整示例，27 个调用/类型签名代码块可见；示例页的 BasePopupsExample / ApplicationPopupsExample 保留。

产物 SHA256：`8ab7096254aefe09fe6028e3c38b6e1665bcfb7f0fc83a50f770622ea3aecf6d`。

预览：[Popup API](http://127.0.0.1:4173/flutter/components/popup?tab=api)，[Popup 示例](http://127.0.0.1:4173/flutter/components/popup?tab=demo)。

## 待维护者确认

- [x] Popup 候选展示实现及本地程序检查完成。
- [ ] 维护者确认 Popup 信息组织合理。
- [ ] 确认后再生成、逐页验收其余组件并更新全量报告。
- [ ] 工具和消费仓库正式交付及最终 CI/autofix 复验。

测试日志和浏览器截图在本地 `/tmp/tdesign-api-full-review/popup-presentation/`；本轮验收不含全部组件设计/Golden 或 Flutter Web 示例交互验收。

# 实施方案

## 全量统一展示推广

维护者授权将 Popup 当前候选推广至其余 56 个组件。统一规则与逐组件流程以 [presentation-rules.md](./presentation-rules.md) 为准；按 manifest 顺序逐组件阅读、修正源码注释、生成与验收，并在 presentation-review.md 记录实际发现和验证。此前「仅 Popup」为历史阶段限制，本轮已扩大到全量；示例补充和类型跳转继续暂缓。正式工具 ref 与远端 CI 门禁仍独立保留，不将本地候选当成正式交付。

## 技术方案

使用 analyzer AST 递归解析入口导出和 part，以声明来源分配组件。将清单与生成的 Markdown 标题、成员逐项比对；缺注释报告源码行号。先修生成器，再根据实现补注释，最后生成和验收。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | lib/src 的公开 dartdoc | 仅文档 |
| 工具 | 独立 tdesign_flutter_tools | 方法、访问器、构造、扩展输出 |
| 清单 | tool/components.json | 移除失效名称，补齐公开声明 |
| 文档 | example/assets/api 与 demo_tool/README.md | 自动生成 API、更新说明 |
| 校验 | tool/audit_api_docs.dart、CI | 检查声明与文档缺口 |
| 官网 | flutter-api 指令、57 页 Markdown、Theme 路由 | 读取 Demo 同一 API 资产，避免旧表重复维护 |
| Demo | example/lib/config.dart、base/api_widget.dart、base/example_route.dart | 注册 Theme；按实际资产清单兼容路由名与 API slug，保持两个文档入口一致 |

## API 变化

无签名或运行行为变化，无 breaking change。

## 风险与取舍

注释非空不能证明语义正确；必须结合实现检查。生成器候选与正式版本的验收分别记录；工具合并前不宣称正式生成链完成。

工具 Review 后补充边界契约：生成与 validate 必须兼容默认构造参数的子标题；签名渲染由独立模块按 AST 成员种类处理 external/构造/方法，不依赖中文章节名。仅移除 token 间的包装缩进，不改字符串字面量；参数表转义须保留代码空白。成员筛选须结合声明所属的框架基类，业务 build 与自定义接口 override 保留；缺注释由审计器报告。函数类型参数完整解析，无法解析的字段/父类类型不能假定为 dynamic。双版本工具完整单测纳入 CI，包含真实 CLI 生成后 validate 的正反例。Markdown 渲染不修改解析模型；生成与验收共用消费仓库 tool/components.json，validate 兼容旧 YAML/JSON 配置。

## 验证策略

工具单元测试，声明/成员完整性检查，生成幂等性，双 Flutter 严格 analyze，站点构建，浏览器文档验收。无视觉行为变化，不更新 Golden。

Demo 加载验证使用真实 AssetBundle 与真实 ApiPage，逐个匹配 57 个组件的既有注册名和 canonical slug。该测试登记到 sharedExampleTests，进入 GitHub / CNB 双版本功能回归。


Popup 信息组织复审：标题语义在源码 dartdoc 维护，生成器只统一 API 分组、顺序与相对层级；默认构造复用构造/方法正文渲染，以实际名称为五级标题。工具 validate 与消费审计器均兼容旧资产，识别新默认构造标题并按同级构造边界截取参数。只生成 Popup，保留其他组件资产，双版本校验和浏览器全类型结构复核完成后记录结果。

## Popup 表格优先追加验收

- [x] 精简源码 dartdoc 的重复说明，合并方向、蒙层和状态关系为表格。
- [x] 核对源码 token、双 SDK 生成/契约审计及本地实际页面，保留 16 类型、24 可调用 API、135 参数。

## Popup 返回值结构追加验收

- [x] 统一返回值渲染、从源码提取说明，并兼容新旧文档契约校验。
- [x] 双 SDK 工具与审计回归、源码 token 核对、Popup 生成和实际预览。

## Popup 所有表统一五列

- [x] 参数、返回值、成员、枚举和说明表统一五列，不适用值使用 `-`。
- [x] 说明表角色与 API 数据契约隔离，保留原始关系及转义竖线。
- [x] 只生成 Popup，确认 46 张表头一致且 135 个参数契约不变。
- [x] 完成双版本审计与构建，并记录实际页面验收。

## Popup 回调类型定义改为表格

- [x] 从 AST 提取回调参数与返回类型，以标准 dartdoc 维护说明，移除重复 typedef 源码。
- [x] 独立审计类型别名契约，覆盖泛型、可空性、参数顺序和旧资产兼容。
- [x] 双 SDK 检查与生成一致，确认其余 Popup 章节不变，并实际页面验收。


## 全量展示推广交付

按 `presentation-rules.md` 延续 Popup 确认规则至所有 57 个组件。生产改动仅为 dartdoc；在保留既有语义审查的基础上补齐返回/回调契约并清理内部展示术语。消费端新增逐组件展示门禁，GitHub/CNB 同步登记。当前候选结果与正式依赖/远端交付门禁分离，逐组件记录和限制见 `all-presentation.md`；既有字体清单失败不通过本轮改字体来掩盖。

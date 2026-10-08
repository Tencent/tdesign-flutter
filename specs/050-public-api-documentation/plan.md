# 实施方案

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

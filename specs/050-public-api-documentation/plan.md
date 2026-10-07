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
| Demo | example/lib/config.dart | 注册现有 Theme 示例页，提供官网示例与 API 的实际入口 |

## API 变化

无签名或运行行为变化，无 breaking change。

## 风险与取舍

注释非空不能证明语义正确；必须结合实现检查。生成器候选与正式版本的验收分别记录；工具合并前不宣称正式生成链完成。

## 验证策略

工具单元测试，声明/成员完整性检查，生成幂等性，双 Flutter 严格 analyze，站点构建，浏览器文档验收。无视觉行为变化，不更新 Golden。

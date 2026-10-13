# 实施方案

## 技术方案

在入口添加 Material export；在 README 快速开始按添加依赖、最小导入、最小使用三部分展示接入；最小使用仅提供 TButton 表达式，不添加布局和事件，通过现有 sync-readme.mjs 同步生成文件。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| API | lib/tdesign_flutter.dart | 新增 Material 重导出 |
| 文档 | README.md / README_zh_CN.md 及副本 | 单入口 Button 快速开始 |

## API 变化

新增公开导出；不改变现有签名、默认值或删除能力。可能与调用方已有同名声明或其他库导出冲突，需要使用 hide/show 或前缀消歧；Flutter 后续新增导出也可能影响命名空间。

## 风险与取舍

接受 Material 命名空间扩展以简化接入。保持发布版本号不变，并说明已发布 alpha.1 的兼容边界。

## 验证策略

将文档示例提取到临时文件，双 SDK 分析；使用临时 Widget 测试确认可渲染且回调触发；验证重复导入及同步副本。全包 analyze 区分本次引入与既有诊断。

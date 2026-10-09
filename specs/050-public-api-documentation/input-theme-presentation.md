# Input Theme 配置表验收（2026-10-09）

排序补充：生成器将已分类的组件 Theme 移到功能 API 之后，保留组内相对顺序。Input 最终顺序为 TInput、TInputClearButtonMode、TInputStatus、TInputThemeData。最新 SDK 的排序定向测试通过，Input 独立 AST 审计 issues=0，浏览器已核对相同顺序。本项排序增量未重跑双版本完整验收。

本轮只生成和验收 Input。`TInputThemeData` 使用源码 dartdoc 的 `ComponentTheme` 分类，生成一张配置项表；不重复默认构造方法、`copyWith`、`lerp` 的参数表。表内保留八个字段的类型、默认值、回退说明及必传标记。普通类不能通过分类隐藏公开 API，组件主题的专有方法和命名构造方法仍保留。

## 最终候选证据

| 检查 | Flutter 3.32.0 | Flutter 3.47.6 |
| --- | --- | --- |
| Input 生成 | 完成 | 完成 |
| Input 工具 validate | ERROR=0，WARN=0 | ERROR=0，WARN=0 |
| 独立 AST 审计 `--components=input --json` | 4 个声明，issues=0 | 4 个声明，issues=0 |
| Input 定向文档测试 | 6 通过 | 6 通过 |
| 真实 Input API 页面测试 | 1 通过 | 1 通过 |
| 生成器配置表定向测试 | 1 通过 | 1 通过 |
| 组件库与生成器静态分析 | 零问题 | 零问题 |

定向审计测试包含正确文档以及删除字段、修改类型、修改默认值、普通类冒用分类的反例。生成器测试还验证专有方法保留和标准方法表省略。

两 SDK 与工作区 Input 文档逐字节一致。其余 56 份 API 文档与本轮起点 SHA-256 一致。两个 Input 生产文件的非注释 Token 与 HEAD 一致，组件行为和公开 API 未变。两个仓库 `git diff --check` 通过。

本地站点 `http://127.0.0.1:19000/flutter/components/input?tab=api#tinputthemedata` 已刷新并通过浏览器核对：Theme 小节只包含配置项表，八个字段完整，类型、说明和默认值均可见，无 Theme 构造方法、copyWith 或 lerp 参数表。

本轮未验收其他组件、Golden 或设备行为。生成器修复位于独立工具 checkout `/tmp/tdesign-flutter-tools-docs`；组件正式工具依赖未切换，本轮候选尚未提交或推送。正式生成链路使用这项规则仍需先交付工具修复。

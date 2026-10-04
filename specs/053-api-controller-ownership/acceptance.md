# Acceptance

Flutter 3.32.0 与 3.47.6：受影响六项组件功能测试均 373 passed；flutter analyze --fatal-infos 均 No issues found。

覆盖率：DropdownMenu 99.17%，Form 98.72%，Popover 98.12%，BackTop 100%；Radio 最低 99.63%，Checkbox 最低 96.99%，均过 95%。

API 重新生成 57 份，根出口直接导出组件声明 282 项全部有章节，另补齐 12 项直接导出 Theme 基础类型及 setTResourceBuilder；本扫描未分析传递 export，不声称整个 Dart 依赖图完整覆盖。示例片段 --check 通过。

完整 57 项最终双版本回归均 2757 passed（116 个已登记功能测试文件）；全部 57 项覆盖率均过 95%，最低 95.53%。双版本 Demo 回归各 275 passed；调度器自测 19 passed。无视觉源码改动，不更新 Golden；远端 Linux Golden 随 PR 执行。

候选决策：保留 Radio 重选（选择请求）、Checkbox 聚合半选（二态用户交互）；Input.borderless 是下边线，Textarea.bordered 是完整外框，职责不同保持现名；Popover 内容事件 dartdoc 已明确目标，不再为命名追加破坏性修改；Popup Click 布尔字段为低优先命名，不改变行为；Loading 未首次绘制卸载延迟清理保持现有已声明限制。

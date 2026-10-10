# 验收

2026-10-10 本地实现检查点：Flutter 3.32.0 / Dart 3.8.0 与 Flutter stable 3.47.6 / Dart 3.13.5。

两版组件测试均 52 项通过；生产源码 LH/LF 220/228 = 96.49%，超过 95% 门禁。共同调度器门禁 19 项通过。全部已登记 Example 回归各 363 项、独立片段各 370 份、严格 analyze 各 No issues found。上述为分支拆分前同源码检查点，独立分支和远端 CI 结果在交付后追加。

回归先在旧实现上失败，修复后通过。API 构造签名与默认值不变，不增加公开参数。

Linux Golden 本地未执行；不更新基线，待 GitHub ubuntu-24.04 / Flutter 3.32.0 CI 验证。当前不将未完成 CI 称为通过。

独立 worktree 验证：仅包含本组件改动的分支，在 Flutter 3.32.0 下组件回归全通过，严格 analyze 为 No issues found。未携带另一组件源码或公共报告；最终远端验证待 CI。

# 本批次审计工具

这两个脚本用于重现 Spec059 的固定批次取证，不是组件日常回归或发布放行入口。命令从仓库根目录执行。

```bash
node specs/059-component-token-runtime-evidence/tools/audit_compiled_token_consumption.mjs <冻结小程序根目录>
node specs/059-component-token-runtime-evidence/tools/summarize_component_token_evidence.mjs <双版本验证日志目录>
```

- 编译工具使用站点安装的 Less，读取 Spec048 审计清单和指定冻结源码，写入本 Spec 的 `compiled-consumption.json`。它证明静态样式消费，不能替代运行或视觉验证。
- 汇总工具读取本 Spec 的编译证据、Spec047/048/058 的清单及双版本日志，校验固定测试数量、源码和覆盖率，生成本 Spec 的阶段报告。日志结构和测试数量属于该批次，不能直接用于后续任意提交。

历史验收命令、JSON 中的工具路径和哈希保留当时原值。原根目录 `tool/` 下的同名脚本已迁移到此处；本目录是当前重现入口。

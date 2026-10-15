# 本批次差异验证工具

此脚本核对 Spec060 的固定32项差异处置，不是通用测试入口。命令从仓库根目录执行：

```bash
node specs/060-token-difference-resolution/tools/verify_token_difference_resolutions.mjs <双版本验证日志目录>
```

输入包括 Spec059 的原始目标、本 Spec 的处置规则、双版本源码快照、测试和覆盖率日志。脚本核对日志、当前源码哈希和强制断言，写入本 Spec 的运行观测、验证命令及处置报告。固定测试数量与日志文件名属于本批次。

历史 JSON 中的原工具路径和哈希保持不变。原 `tool/verify_token_difference_resolutions.mjs` 已迁移到此处；脚本后续生成的新记录使用当前路径。

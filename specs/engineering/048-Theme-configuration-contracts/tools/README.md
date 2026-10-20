# Token 运行证据工具

在仓库根目录执行；输入必须是对应冻结参考源或实际验证日志。工具会重写指定证据输出，因此文档整理阶段不执行它们。

- `node tool/audit_component_token_consumption.mjs`：读取冻结 Token 表，更新静态消费候选；静态命中不等于最终绘制通过。
- `node specs/engineering/048-Theme-configuration-contracts/tools/audit_compiled_token_consumption.mjs <冻结小程序根目录>`：核对实际编译消费。
- `node specs/engineering/048-Theme-configuration-contracts/tools/summarize_component_token_evidence.mjs <双SDK验证日志目录>`：汇总实际运行观察，保留未验证和视觉待审状态。
- `node specs/engineering/048-Theme-configuration-contracts/tools/verify_token_difference_resolutions.mjs <双SDK验证日志目录>`：复核差异处置与源指纹。

证据输出归 `evidence/` 对应分类。旧快照的日期、源码与哈希范围保持；迁移路径不意味着重新生成或验收完成。

文档清理仅修正报告生成说明和相对链接，未重新运行工具或刷新任何冻结证据。旧报告记录的工具哈希仍对应当次工具版本；下次实际运行须重新绑定候选、工具版本与日志。

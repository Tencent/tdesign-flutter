> 当前状态（2026-10-15）：以下为分阶段历史记录。`develop@30767a55` 的双版本功能与 Linux 3.32.0 已登记 Golden 已通过；正式工具 #29 已合入且 API --check 通过。旧失败数/待推送描述不作为当前结论。未登记场景、跨端像素和真机验收仍须独立核验，见 [Spec 057](../057-release-readiness-audit/acceptance.md)。

# 正式工具交付

工具 PR #29 已在 2026-10-09 合入 main，合并提交为 6bcf065e87a2fbd277c9b598205195f0a634414a；合并前八项远端检查通过。

消费仓库仍声明 ref: main，无临时 override。重新解析依赖后，锁文件 resolved-ref 指向上述正式提交；该锁文件按仓库规则忽略，不提交。同步远端 autofix 提交 2a370f3c 后，由正式 main 工具重新生成 57 份 API；产物与此前验收版本逐字节一致。

Flutter 3.32.0 与 3.47.6 各完成全量生成 --check、369 个公开声明 AST 审计 0 issue，以及 57 项展示测试。正式工具解析与生成门禁已完成，最终远端 CI/autofix 需以本次推送后的 head 为准。

PullDownRefresh Demo 的六项 Golden 差异是此前清理文案后截图基线未同步，独立于生成工具；本次不更新这些基线，不宣称全部 CI 已通过。

# 046-Demo-experience 未完成事项

<a id="source-046"></a>
<a id="source-065"></a>
<a id="source-073"></a>

## 原记录明确未关闭

- [ ] 后续实现或发布候选变更时，按 spec.md 重新核对受影响契约与验证结果。

## 当前候选复核

- [ ] 后续实际交付前，将验收标准绑定最终候选 SHA、SDK 与相关环境，核对受影响结果；本次仅做文档整理，未运行组件、Golden 或设备验收。

已完成的开发步骤和旧 PR 创建过程已清理。原记录的远端 CI/Review 或设备连接状态不作为当前事实；相关事项需以实际证据核对，不能随文档整理关闭。

## Guide/navigation follow-up acceptance

- [ ] Browser end-to-end manual check on the final release candidate: quick start, theme and locale previews, folded anchors, back/forward navigation and repeated same-URL history entries. Current unit, dual-SDK functional, site build and Linux Golden results do not replace this check.

## 站点历史转换清理

- [x] #1185 最终 head `41efca99` 的远端检查为 28 项成功、1 项条件跳过，已于 2026-10-23 合并；不替代 #1156 新 head 的检查。

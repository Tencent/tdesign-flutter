# Toast 未完成事项

<a id="record-004-contract-alignment"></a>
<a id="record-006-overlay-config-and-placement"></a>
<a id="record-054-overlay-pointer"></a>

## 原记录明确未关闭

- [ ] 完成 Review
- [ ] 在真实设备 / 页面确认 toast 视觉背景与 TDesign Mobile 对齐。
- [ ] 确认普通 toast 默认 2 秒消失、加载 toast 不自动消失。

## 当前候选复核

- [ ] 后续实际交付前，将验收标准绑定最终候选 SHA、SDK 与相关环境，核对受影响结果；本轮已完成本地组件与 Golden 比较，范围见 acceptance.md；远端 CI 与设备验收须单独取得证据。

已完成的开发步骤和旧 PR 创建过程已清理。原记录的远端 CI/Review 或设备连接状态不作为当前事实；相关事项需以实际证据核对，不能随文档整理关闭。

## 文字槽交付

组件范围和已验证边界见 acceptance.md；共享收口事项统一维护在 [Theme tasks](../../engineering/048-Theme-configuration-contracts/tasks.md#文字槽-review-收口)，不在各组件重复记录分支、推送与 CI 流程。上述既有设备、设计和 Review 待办不因此关闭。


## 1.0.1 overlay-lifecycle

- [x] 完成本独立分支双版本功能回归、覆盖率、静态分析和生成产物验证。
- [x] 按最终候选复核 API、默认行为、绑定边界及测试门禁，记录验收。

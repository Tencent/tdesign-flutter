# Popover 未完成事项

<a id="record-003-contract-hardening"></a>
<a id="record-015-color-scheme-instance-ownership"></a>
<a id="record-022-public-api-convergence"></a>
<a id="record-027-controller-theme-lerp"></a>

## 原记录明确未关闭

- [ ] 在目标设备完成窄屏、键盘、四边 placement 和组合 Widget 交互人工验收
- [ ] 完成最终 Review 后关闭 Spec
- [ ] 窄屏下十二种 placement 的内容和箭头均可接受
- [ ] 刘海屏、圆角屏和底部安全区内不裁切
- [ ] 键盘弹出后底部 Popover 不被遮挡
- [ ] 目标设备页面跳转时 Popover 自动关闭且无视觉残留
- [ ] 真机公开 Demo 文本、自定义内容和十二方位展开正常

## 当前候选复核

- [ ] 后续实际交付前，将验收标准绑定最终候选 SHA、SDK 与相关环境，核对受影响结果；本轮已完成本地组件与 Golden 比较，范围见 acceptance.md；远端 CI 与设备验收须单独取得证据。

已完成的开发步骤和旧 PR 创建过程已清理。原记录的远端 CI/Review 或设备连接状态不作为当前事实；相关事项需以实际证据核对，不能随文档整理关闭。

## 文字槽交付

组件范围和已验证边界见 acceptance.md；共享收口事项统一维护在 [Theme tasks](../../engineering/048-Theme-configuration-contracts/tasks.md#文字槽-review-收口)，不在各组件重复记录分支、推送与 CI 流程。上述既有设备、设计和 Review 待办不因此关闭。

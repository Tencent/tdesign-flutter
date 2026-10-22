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

## 本轮文字槽统一

- [x] 默认字体、包装、显式样式、内部局部主题与原生段落回归；双 SDK、生成文档及 Linux 视觉比较。
- [x] 两张预期菜单 Golden 差异经审阅授权更新，复跑双 SDK 与 Linux 无更新比较通过。
- [x] #1184 目标分支调整为 develop，以触发正常测试流水线。
- [x] 前置 #1182 已合并 develop；#1184 合并最新 develop，保留其单行测量及 Toolbar 合并语义，并按新字体契约更新旧断言。
- [ ] 核对 #1184 合并后的最终 head CI；本轮不新增 Golden 基线改动。

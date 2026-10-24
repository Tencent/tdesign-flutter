# Popup 未完成事项

<a id="record-018-overlay-config"></a>
<a id="record-019-radius-duration-alignment"></a>
<a id="record-020-demo-alignment"></a>
<a id="record-021-slot-convergence"></a>

## 原记录明确未关闭

- [ ] 人工验收：真机确认 left/right 无圆角与动画时长表现

## 当前候选复核

- [ ] 后续实际交付前，将验收标准绑定最终候选 SHA、SDK 与相关环境，核对受影响结果；本次仅做文档整理，未运行组件、Golden 或设备验收。

已完成的开发步骤和旧 PR 创建过程已清理。原记录的远端 CI/Review 或设备连接状态不作为当前事实；相关事项需以实际证据核对，不能随文档整理关闭。

## destroyOnClose 独立修复

- [x] 先明确原 API、默认 false、Navigator 所有权和资源保留风险。
- [x] 实现关闭销毁/保留、State 复用与 Navigator 自动清理，不新增公开 API。
- [x] 在既有登记测试文件中补齐生命周期、重入、语义及释放边界。
- [x] 最终源码完成双版本门禁、覆盖率、生成文档及字体覆盖校验。
- [x] 基于最终源码复审并更新验收、补丁及历史失败证据。
- [x] 内部重构解决隐藏 ModalRoute、语义边界及局部主题重开；正式回归不跳过，最终 Review 无阻塞项。
- [x] 完成底部面板隐藏视口修复后的最终双版本复验。
- 按独立 PR 交付；本地结果不替代远端 CI，合并须另行确认。

## 本轮 LocalHistoryEntry 复审修复

- [x] 恢复未成功 pop 的标记，补齐三类正式回归。
- [x] 补齐声明式页面替换的同帧停放刷新，并重新完成最终双版本验证、补丁及复审。
- 不混入零动画 onClosed 历史问题；交付后核对最终 head 的 CI 与 Review，暂不合并。

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
- [x] 完成检查点双版本门禁、覆盖率与生成文档校验；最终新增回归两版失败，不能判为最终通过。
- [x] 基于最终源码复审并更新验收，保留已登记的失败回归。
- [ ] 解决隐藏期间 ModalRoute 上下文与无障碍兼容；当前 Review 不通过。
- 不推送、不创建 PR；不把本地结果当作远端 CI。

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

## 1.0.1 蒙层配置调整

- [x] final 与 onTap 实现、onClick 废弃兼容、调用点迁移及 FAQ 方案。
- [x] 完成当前候选双版本消费者、功能、文档与严格分析及本地 Review；当前 Popup 覆盖率通过 95% 门禁。
- [ ] 核对提交后精确 head CI，完成源码兼容风险及发布范围的人工评审；保持草稿，暂不合并。

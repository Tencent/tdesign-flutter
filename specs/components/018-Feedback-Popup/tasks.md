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

## API 兼容迁移

- [x] 撤出状态参数、copyWith 扩展及继承适配 FAQ；保留其他兼容命名。
- [x] 重新生成 API，完成撤出后的双版本验证和本地 Review；旧 copyWith 消费者两版无需适配。

- [x] 补充 implements 源码兼容例外及版本化适配示例。
- [x] 外部消费者缺失诊断、适配后分析与真实蒙层点击双 SDK 验证。

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

## 1.0.1 蒙层配置调整

- [x] final 与 onTap 实现、onClick 废弃兼容、调用点迁移及 FAQ 方案。
- [x] 完成当前候选双版本消费者、功能、文档与严格分析及本地 Review；当前 Popup 覆盖率通过 95% 门禁。
- [x] #1199 已合入 develop；本轮同步后继续验证配置 API 契约，不重复交付命名调整。

## 同步最新 develop

- [x] 合并 fabe5f6b 并保留双方正式回归，完成双版本组件/示例/工具、覆盖率、生成文档及严格分析。
- [ ] 推送后核对最终 head CI 与合并冲突状态，暂不合并 PR。

## Drawer 历史生命周期保持

- [x] 内部一次性入口，保持默认 false、遮挡规则、关闭释放和回调时机，不新增公开 API。
- [x] 正式关闭/遮挡/丢弃句柄回归，验证 Popup/Picker 保留规则与内部入口不可见。
- [x] 当前候选双 SDK 完整验证、文档生成、字体、覆盖率及最终复审。
- [ ] 更新 PR 并核对最终 head 的 CI/Review；不合并。

## 替换会话的资源复用边界

- [x] 补齐 Popup FAQ、Spec 与升级提醒：GlobalKey 唯一性、Controller 解绑延后及三类推荐用法，不改实现或 Drawer 规则。
- [x] 在现有 CI 登记文件补齐 Popup/Picker 两入口的 12 项正式边界回归。
- [x] 双 SDK 验证并更新本地验收和补丁，复审 FAQ 与正式测试一致。
- [ ] 更新 PR 并按最终 head 核对 CI/Review，不合并。


## FAQ 精简与跨组件指引

- [x] Popup 保留批准的精简文本，详细边界留在 Spec。
- [x] Picker/DateTimePicker 简短提示与精准锚点；ActionSheet 单独说明未暴露 destroyOnClose。
- [x] 双 SDK 文档、三个链接和四页实际渲染验证，更新本地验收。
- [ ] 更新 PR 并核对最终 head 的 CI/Review；不修改生产实现或 Drawer 规则，不合并。


## Popup 前两问 FAQ 精简

- [x] 按批准版本精简蒙层配置适配及重新打开配置两问；工厂示例、动态 getter/成员兼容及资源边界留在 Spec。
- [x] 双版本文档检查与真实渲染核对，更新本地验收。
- [ ] 更新 PR，按最终 head 核对 CI/Review，不合并。

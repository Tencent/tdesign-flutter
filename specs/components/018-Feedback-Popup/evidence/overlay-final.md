# Popup 蒙层配置 2.0 breaking 草稿验收

基线 develop `3704434fd2adfb6988110bc760aaaa52a814581c`，分支 rss1102/refactor/popup-overlay-config-2.0。只收敛 TPopupOverlayConfig，保持草稿供 2.0 评审，不作为 1.0.1 patch 合并。

## 修改与风险

TPopupOverlayConfig 改为 final，库外 extends/implements 不再合法；onClick 参数/成员改为 onTap，旧名在本 2.0 设计中移除。普通构造和 const 保留，既有遮罩默认值、关闭条件、通知先后不变。Drawer 内部调用同步迁移，不改其公开 onOverlayClick。TPopupOptions/copyWith、destroyOnClose、Controller 及其他类型的继承规则不变。

这是明确的源码 breaking：旧构造调用、成员访问、业务子类、implements 及相关 mock 需要迁移。FAQ 说明设计动机、源码迁移影响和组合工厂示例，不表述未来版本方向；不能用新增 getter 或 noSuchMethod 适配 final。动态 getter 与配置快照可能不等价，handle.open() 沿用创建句柄时的 options；更换配置须重新构造 TPopupOptions，通过 TPopup.show() 创建新会话，不承诺活动 Popup 自动响应外部状态。

final 限制配置类的扩展方式，不删除 Popup 内容、builder、主题、事件或 Controller 能力，也不能保证将来任意必填参数或默认行为调整都兼容。真实动态配置用例仍需 2.0 人工设计评审，测试通过不等于已证明所有现有业务都能等价迁移。

## 初始候选验证

Flutter 3.32.0 / 3.47.7 各 211 项通过：Popup 正式组件、2 项真实遮罩通知先于关闭测试、4 项包外消费者分析及字体/回归登记工具检查。消费者明确验证 final 对 extends/implements 的诊断、旧 onClick 命名参数被拒绝，以及 const 构造和组合用法零诊断。

两版严格 analyze 零诊断；57 份 API --check 通过。Popup 生产覆盖率高版 526/545（96.51%）、低版 531/545（97.43%）。FAQ 站点主题/文档 16 项通过。新增工具文件由现有 test/tool 入口发现，不需重复登记。

日志、LCOV 和输入哈希位于工作区 artifacts/api-split-delivery/03-popup-final。未运行全包组件、真机、Web release 或 Golden；不外推 #1197 的生命周期验证。当前 destroyOnClose 仍沿用 develop，只有独立 #1197 改其关闭保留行为。

## 本地 Review

实现、生成 API、FAQ、Spec 与测试一致；未混入其他组件改名或 TabBar 路由修复。保留明确源码风险及动态 getter 的迁移限制，发布与是否收紧扩展方式仍待 2.0 评审。暂不合并。


## FAQ 修正复验

当前基线 develop `264fc58206309039bc63216a88153be30d1ef407`；以 `d21e40cded137a18b2df16cfc66c681a8975740f` 为文档修正前候选。此次只改 FAQ、Spec 和验收记录，组件源码、测试与生成 API 均与该候选一致。

FAQ 明确 handle.open() 不应用新配置，更换配置须通过 TPopup.show() 创建新会话；去除 FAQ 的未来版本方向表述。PR 仍保持 2.0 breaking 草稿，不作为 1.0.1 patch，也不改变现有实现。

该源码此前在 Flutter 3.32.0 / 3.47.7 各通过 287 项 Popup、Drawer 与消费者回归（review-d21e40cd-low/high.log）。本次两版各重跑 29 项消费者、字体覆盖及回归登记工具检查，并各通过 57 份 API --check；站点主题/文档 33 项通过，57 份组件文档映射 360 份生成示例。低版隔离快照最初缺少 CI 参考文件，补齐同一候选的 .github/.cnb 后重跑通过，不属于组件失败。

本次日志为 faq-api-high.log、faq-tools-high.log、review-d21e40cd-low/faq-api-low.log、review-d21e40cd-low/faq-tools-low.log 及 faq-site.log，均位于上述本地 artifacts 目录。未重跑历史覆盖率、全包、Golden、真机或 Web release；初始候选覆盖率不作为本次新增测量。

复审：FAQ、Spec 与句柄固定 options、open() 重用配置的实现一致；没有新增生命周期、回调或 Controller 变更。final 与旧 onClick 移除的源码 breaking 风险仍在，文档修正不消除该风险。远端 CI 与人工评审状态另见 PR，不以本地通过代替。

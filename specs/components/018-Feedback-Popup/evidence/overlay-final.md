# Popup 蒙层配置 2.0 breaking 草稿验收

基线 develop `3704434fd2adfb6988110bc760aaaa52a814581c`，分支 rss1102/refactor/popup-overlay-config-2.0。只收敛 TPopupOverlayConfig，保持草稿供 2.0 评审，不作为 1.0.1 patch 合并。

## 修改与风险

TPopupOverlayConfig 改为 final，库外 extends/implements 不再合法；onClick 参数/成员改为 onTap，旧名在本 2.0 设计中移除。普通构造和 const 保留，既有遮罩默认值、关闭条件、通知先后不变。Drawer 内部调用同步迁移，不改其公开 onOverlayClick。TPopupOptions/copyWith、destroyOnClose、Controller 及其他类型的继承规则不变。

这是明确的源码 breaking：旧构造调用、成员访问、业务子类、implements 及相关 mock 需要迁移。FAQ 说明设计动机、版本边界和组合工厂示例；不能用新增 getter 或 noSuchMethod 适配 final。动态 getter 与配置快照可能不等价，业务应显式重建配置并按原流程应用，不承诺活动 Popup 自动响应外部状态。

final 限制配置类的扩展方式，不删除 Popup 内容、builder、主题、事件或 Controller 能力，也不能保证将来任意必填参数或默认行为调整都兼容。真实动态配置用例仍需 2.0 人工设计评审，测试通过不等于已证明所有现有业务都能等价迁移。

## 验证

Flutter 3.32.0 / 3.47.7 各 211 项通过：Popup 正式组件、2 项真实遮罩通知先于关闭测试、4 项包外消费者分析及字体/回归登记工具检查。消费者明确验证 final 对 extends/implements 的诊断、旧 onClick 命名参数被拒绝，以及 const 构造和组合用法零诊断。

两版严格 analyze 零诊断；57 份 API --check 通过。Popup 生产覆盖率高版 526/545（96.51%）、低版 531/545（97.43%）。FAQ 站点主题/文档 16 项通过。新增工具文件由现有 test/tool 入口发现，不需重复登记。

日志、LCOV 和输入哈希位于工作区 artifacts/api-split-delivery/03-popup-final。未运行全包组件、真机、Web release 或 Golden；不外推 #1197 的生命周期验证。当前 destroyOnClose 仍沿用 develop，只有独立 #1197 改其关闭保留行为。

## 本地 Review

实现、生成 API、FAQ、Spec 与测试一致；未混入其他组件改名或 TabBar 路由修复。保留明确源码风险及动态 getter 的迁移限制，发布与是否收紧扩展方式仍待 2.0 评审。暂不合并。

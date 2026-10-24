# 1.0.1 API 兼容迁移验收（撤出状态参数迁移）

基线 develop `3704434fd2adfb6988110bc760aaaa52a814581c`；在原 #1196 提交 `07b65c4c` 上撤出状态参数迁移（实现提交 `12e18203`），同步更新 PR 范围；远端 CI 以最终 head 为准，暂不合并。

## 最终范围

保留 NoticeBar.onTargetTap、CheckboxGroup.onSelectionLimitExceeded、Drawer.onItemTap/类型别名、Popover.onLongPress、PopupOverlay.onTap、Steps.onStepTapped、TabBar.onSelected/notifyOnReselect。非空新参数优先，未指定时通过旧 getter 分派，普通旧调用、const/函数类型、默认行为及 Controller 绑定规则保持。

已撤出 Popup/Drawer/Picker 的 maintainState 参数、destroyOnClose 弃用、copyWith 扩展和独立复制入口、继承适配 FAQ 及对应 2.0 迁移计划。TPopupOptions 与 copyWith 恢复 develop 原签名，旧覆盖不再因新增参数适配。本分支不改变 destroyOnClose 的既有生命周期；关闭保留修复在独立分支 `rss1102/fix/popup-destroy-on-close` 交付，不能把其结果外推本分支。

## 验证

Flutter 3.32.0 / 3.47.7 均通过：八组件 882 项功能回归（兼容用例 33 项）、129 项示例/API/代码面板、173 项工具测试（含字体覆盖）、严格 analyze、57 份 API --check 和示例片段 --check。聚焦兼容消费者验证为35项（33项兼容交互加2项外部分析）；原API展示与示例回归仍在对应套件执行。包外旧 copyWith 子类消费者在两版均无诊断，确认不再需要继承签名适配。八组件生产覆盖率均 >=95%；Popup 分别为 534/548 (97.45%)、532/548 (97.08%)。

源码指纹（基线以来组件及 FAQ 的二进制 diff）：`8541b9eb9cb633d896e4d47a75a0c9fd381eb86510a9d90687255ecafef43f7a`。双版本相关文件逐个字节一致；各自依赖/缓存独立。原始日志、LCOV 和本地草稿位于工作区 artifacts/popup-destroy-close/implements-withdraw-high、implements-withdraw-low。先前 932/83 项含已撤出迁移，不作为当前候选数量。

全部生成产物由源码生成，不手工维护。未执行真机或 Web release，本地结果不代表远端新 head CI。

## 最终本地 Review

TPopupOptions/PickerPopup 源码恢复 develop 原版，copyWith 原签名、旧 getter 和默认 false 保留。Popup 路由仅保留蒙层 onTap 兼容迁移。生成 API 没有新增状态参数或独立复制入口，已撤出的 copyWith FAQ 未恢复；另增加 implements 的版本化适配 FAQ。其他组件旧入口分派、非空优先、受控/禁用/重复选择契约与 Controller 规则一致。未发现新阻塞问题。此结论对应上述源码指纹；本轮只增加消费者测试、FAQ和验收说明，生产实现与生成 API 均未变化。远端 CI 与 Review 须核对最终 head，暂不合并。


## implements 源码兼容例外与闭环

1.0.0 → 1.0.1：业务类 implements 本次新增 getter 的公开类时，不会继承默认实现，必须补齐新增成员。以 TPopupOverlayConfig 为例，旧实现缺少 onTap 会产生 non_abstract_class_inherits_abstract_member；在业务类增加 `VoidCallback? get onTap => onClick;` 可沿用旧通知。它属于源码兼容例外，不能用普通调用或 extends 已通过推定零 breaking；不是已撤出的 copyWith 参数适配问题。普通调用、const、已覆盖的 extends/getter 分派、新旧优先级和旧生命周期仍按原契约验证。

正式工具测试 api_implements_consumer_test.dart 创建独立外部包，解析当前公共 package 导出：旧实现断言仅缺少 onTap 的指定错误；适配后无诊断，不使用 noSuchMethod、dynamic 或忽略缺失实现。CI 通过 scripts/run-tooling-checks.sh tool-tests 自动发现这2项，不需新增清单。已有登记 t_api_compatibility_test.dart 增加4项真实 Popup 交互：显式颜色/主题颜色合并两条路径，各验证关闭/不关闭、旧回调转发仅调用一次。

两版各35项聚焦通过；上述882/173/129为本轮最终结果，八组件生产覆盖率仍>=95%。FAQ另通过7项主题桥接与26项文档测试及生产构建。生产 lib、生成 API、依赖锁均与本轮前候选逐字节一致。未外推真机或 Web release，未改 Golden。远端检查只认更新后的最终 head，不沿用上一提交29项通过；暂不合并。

# 1.0.1 API 兼容迁移验收（本地撤出状态参数候选）

基线 develop `3704434fd2adfb6988110bc760aaaa52a814581c`；远端 #1196 保持 `07b65c4c`，本轮不推送、不更新远端正文、不创建 PR。

## 最终范围

保留 NoticeBar.onTargetTap、CheckboxGroup.onSelectionLimitExceeded、Drawer.onItemTap/类型别名、Popover.onLongPress、PopupOverlay.onTap、Steps.onStepTapped、TabBar.onSelected/notifyOnReselect。非空新参数优先，未指定时通过旧 getter 分派，普通旧调用、const/函数类型、默认行为及 Controller 绑定规则保持。

已撤出 Popup/Drawer/Picker 的 maintainState 参数、destroyOnClose 弃用、copyWith 扩展和独立复制入口、继承适配 FAQ 及对应 2.0 迁移计划。TPopupOptions 与 copyWith 恢复 develop 原签名，旧覆盖不再因新增参数适配。本分支不改变 destroyOnClose 的既有生命周期；关闭保留修复在独立本地分支 `rss1102/fix/popup-destroy-on-close` 验证，不能把其结果外推本分支。

## 验证

Flutter 3.32.0 / 3.47.7 均通过：八组件 878 项功能回归（兼容用例 29 项）、129 项示例/API/代码面板、171 项工具测试（含字体覆盖）、严格 analyze、57 份 API --check 和示例片段 --check。聚焦兼容/API 展示为 86 项。包外旧 copyWith 子类消费者在两版均无诊断，确认不再需要继承签名适配。八组件生产覆盖率均 >=95%；Popup 分别为 534/548 (97.45%)、532/548 (97.08%)。

源码指纹（基线以来组件及 FAQ 的二进制 diff）：`183fb302ae5ad47f532790e3efd62cf9c2732cdc39ffe89ac736a0d64b574663`。双版本相关文件逐个字节一致；各自依赖/缓存独立。原始日志、LCOV 和本地草稿位于工作区 artifacts/popup-destroy-close/withdraw-high、withdraw-low。先前 932/83 项含已撤出迁移，不作为当前候选数量。

全部生成产物由源码生成，不手工维护。未执行真机或 Web release，本地结果不代表远端新 head CI。

## 最终本地 Review

TPopupOptions/PickerPopup 源码恢复 develop 原版，copyWith 原签名、旧 getter 和默认 false 保留。Popup 路由仅保留蒙层 onTap 兼容迁移。生成 API 没有新增状态参数或独立复制入口，FAQ 恢复基线。其他组件旧入口分派、非空优先、受控/禁用/重复选择契约与 Controller 规则一致。未发现新阻塞问题。此结论仅对应本地撤出候选，远端 #1196 仍未修改。

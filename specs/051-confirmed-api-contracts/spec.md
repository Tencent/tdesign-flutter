# 已确认 API 契约收敛

基线：PR #1148，c37107882901646af41f84067d883901d56da5cd。

## 范围及行为契约

- BackTop.onPressed 只报告被接受的激活，先于滚动；onCompleted 仅报告成功回顶。无 Controller 不报告完成；动画中断、位置解绑、组件卸载、Controller 替换不报告完成。连续动画期间忽略点击。激活回调若卸载或更换 Controller，不启动旧滚动。
- Refresh Controller 同时只能绑定一个组件；重复绑定抛 StateError，失败不改变原绑定；解绑只清理对应所有者。换 Controller 先尝试绑定新 Controller，成功后解绑旧的，避免失败时破坏原绑定。
- Popover.onLongTap→onLongPress；PopupOverlay.onClick→onTap；Drawer.onItemClick/type→onItemTap/TDrawerItemTapCallback；NoticeBar.onPressed→onTargetTap；TabBar 弹出菜单.onChanged→onSelected；allowMultipleTaps→notifyOnReselect；CheckboxGroup.onMaxSelected→onSelectionLimitExceeded。事件路径、次数、顺序与默认值不变，旧名称移除，不留同义入口。
- Popover onTap 目标是内容，onOpen 是内容插入 Overlay 成功，onClose 是展示周期结束；Popup 显隐回调是发起阶段，不改变生命周期命名。

## 非目标

不改变 Button 长按启用、Radio 重选、Checkbox 半选转换、Steps 的动作/状态模型，不实现未验证 Loading 生命周期方案，不改变视觉。

## 兼容性与迁移

公开改名及 BackTop 触发时机变化是 breaking change。上述旧参数直接替换为新参数；原来带 Controller 的 BackTop.onPressed 完成业务移至 onCompleted，onPressed 用于激活动作。Refresh 共享 Controller 的调用方改为每个组件持有独立实例。

## 验收

已登记组件/Demo 非视觉测试双 SDK 通过，新增边界用例复现时机与绑定保护，严格 analyze 无诊断，生成 API 与示例同步；不更新 Golden。

# Popup 实施方案

<a id="record-018-overlay-config"></a>
<a id="record-019-radius-duration-alignment"></a>
<a id="record-020-demo-alignment"></a>
<a id="record-021-slot-convergence"></a>

## 实现组织

蒙层行为用配置对象收敛；透明度由最终 Color 表达，不再与第二个 opacity 相乘。

bottom 只提供 headerBuilder，center 只提供 closeBuilder；按钮业务回调由调用方持有。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/popup](../../../tdesign-component/lib/src/components/popup) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/popup](../../../tdesign-component/test/components/popup) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

本次文档整理不执行上述实现或候选验收，不据旧命令流水推定当前检查通过。

## destroyOnClose 修复组织

基于 develop 独立交付，原字段/函数签名不变，默认 false。仅 Popup/Picker 的保留句柄拥有一个私有承载 ModalRoute，由内部安装到所属 Navigator 的 Overlay，提供隐藏期间的原生路由上下文，但不进入导航历史；不创建嵌套 Navigator。可见路由正常 push/pop/remove，GlobalKey 同帧转移内容面板；动画、布局及捕获主题包装留在保留边界外，停放前读取已布局面板的实际尺寸，隐藏时用同尺寸约束保留内容，重开时重新构建外层包装；避免主题包装变化销毁内容或隐藏尺寸变化截断滚动位置；可见内容的 Navigator 仍为原所属实例。

私有承载路由始终 offstage、不请求焦点、没有拦截蒙层。隐藏内容 ExcludeFocus、ExcludeSemantics、TickerMode(false)；原生路由发出的 NavigationNotification 在内部截断，避免隐藏 PopScope 改变外部返回状态。保留独立 PrimaryScrollController/PageStorage，重开不丢失输入与滚动。内容面板在同一 RenderConstrainedBox 渲染根内切换停放尺寸约束，避免新增渲染祖先改变语义几何关系；该根声明独立语义边界，脱离父节点后清理自身语义缓存，不改 Flutter 私有实现或全局无障碍状态。

承载槽 State.dispose 随 Navigator 卸载触发幂等释放；未绘制即卸载由一次 post-frame 检查补足。清除句柄关联后，microtask 移除 Overlay 条目、完成私有路由结果并释放动画等资源，避免 Overlay 自身卸载期间重入 setState。跨 Navigator 重开释放旧承载并创建新 State。关闭动画 listener 与既有业务 listener 分离，保持业务回调时机。

验证覆盖销毁/保留、输入与滚动、零动画、系统返回、遮挡后非栈顶关闭、动画中重开、回调重入、隐藏焦点/ticker、嵌套浮层、独立会话、跨 Navigator、未绘制卸载。新增路由上下文及反复关闭重开回归，实际开启语义树并覆盖运行时启用无障碍；断言隐藏内容不可见、底层可点击、返回栈与 NavigatorObserver 不含承载路由、隐藏 PopScope 通知不外泄。双 SDK 独立目录完成登记组件、示例、工具/字体、文档生成与覆盖率检查。

已否决：普通 Overlay 停放丢失 ModalRoute；嵌套 Navigator 停放触发无障碍断言并引入新的 Navigator 祖先。用户已授权扩大内部重构，不通过要求调用方增加空判断或新增公开宿主规避问题。


## LocalHistoryEntry 消费返回后的停放修复

`didPop` 仍在调用 super 前设置弹出中标记，使成功 pop 的 didComplete 不提前停放；若 super 返回 false（只消费局部历史），恢复进入方法前的标记。保持原 fireCloseStart 的调用位置、回调时机及默认 false，不改公开 API 或 Controller 绑定。

正式回归覆盖消费两条局部历史后：直接 removeRoute、遮挡后非栈顶 handle.close，以及正常 pop。前两者验证关闭后 State/输入保留、同句柄重开复用和 Navigator 卸载仅释放一次；正常 pop 验证动画进行中内容仍在原可见路由，result 先完成、onClosed 待动画结束，不提前停放。零动画 onClosed 同步重开的历史问题不纳入修复。

复审补充：Navigator.pages 在构建阶段替换关联页面时，原生 ModalRoute.changedInternalState 不执行 setState，不能保证保留内容同帧转移。私有承载路由用自有 ValueNotifier 驱动内部内容 builder，确保构建阶段也在移除内容前刷新；不延迟到 post-frame（会错过 State 保留），不引入公开 API 或 NavigatorObserver。该信号随私有路由释放。正式回归另覆盖局部历史消费后的声明式页面替换、同 Navigator 重开和卸载清理。

## 1.0.1 蒙层配置调整

#1199 已合入 develop，配置收敛作为本轮基线。保留 final、onTap/onClick 兼容及 FAQ；合并后双 SDK 同时验证配置回调和生命周期，不重复交付原配置迁移。

## Drawer 一次性生命周期隔离

将公共 show 的原实现提取为私有入口；Drawer 通过不从主库导出的 @internal 函数传入私有不可复用标记。句柄仅在可复用且 false 时创建保留容器；可见路由的遮挡保留由内部字段决定，Drawer 使用 !destroyOnClose，Popup/Picker 始终保留。其余 close、onClosed、pop/remove、Controller 与主题解析代码复用，不增加公开参数、方法或专用路由。

在已登记的 t_popup_options_test.dart 补默认/显式 false/true 的关闭与遮挡矩阵、重复丢弃句柄、真实 Picker 入口重开与 Navigator 清理、Popup true 的遮挡状态；消费者测试验证桥接不进入主库 API。双版本完整登记组件、工具/字体、示例与覆盖率及生成文档验收，风险说明只限定 Popup/Picker。

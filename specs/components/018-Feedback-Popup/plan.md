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

基于 develop 独立交付，原字段/函数签名不变，默认 false。每个保留句柄有 Navigator Overlay 内部停放槽；GlobalKey 在同帧转移整个内容子树，路由仍正常移除。重挂载的渲染根在脱离父节点后清理语义缓存；隐藏时关闭语义、焦点和 ticker。路由 disposal 幂等撤销内部登记，Navigator 卸载释放停放槽；未绘制即卸载由一次 post-frame 检查补足。关闭动画 listener 与原业务回调 listener 分离，保持既有回调时机。

验证覆盖销毁/保留、输入状态、零动画、系统返回、遮挡后非栈顶关闭、动画中重开、回调重入、重复关闭、隐藏焦点/ticker、嵌套浮层、独立会话、跨 Navigator 及未绘制卸载。完整登记组件回归验证消费方；双 SDK 独立目录，Popup/Drawer/Picker 生产覆盖率不降低门槛。

复审补充：原路由的 PrimaryScrollController/PageStorage 会随 pop 释放；保留内容使用自有内部滚动控制器与存储桶，实际滚动 320 后关闭重开仍维持位置，避免仅 State 对象保留但局部滚动状态丢失。

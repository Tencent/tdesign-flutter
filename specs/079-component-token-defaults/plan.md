# 方案

在A的稳定提交上恢复af58482e的原始成果，不重新推导已确认数值。077保存完整Figma变量/绑定、小程序固定源码、映射处置、阶段验收与逐图SHA。通过git对象与逐文件SHA核对恢复是否完整，再执行双版本组件字段/全局所有权/57页消费回归。Linux视觉可复用与当前运行源码、原测试、字体和基线完全一致的af58482e已通过记录，但当前PR的远端CI仍须在目标调整为develop后执行。

## 本轮 Review 修正

发现新全局消费者的 nullable 几何插值仍使用旧常量或零。BackTop 四项、Cell 卡片圆角、Table padding、TabBar 高度、Drawer 两项 padding 与图标间距、Search padding 与清除图标、Toast 分形态 padding 改为消费时解析有效 token 默认。保留显式值与 copyWith/merge 中断过渡优先级，不新增 token 绑定、不改变最终默认值与基线。SideBar nullable padding 采用原离散切换，Stepper 已按完整有效样式递归插值，不重复改写。

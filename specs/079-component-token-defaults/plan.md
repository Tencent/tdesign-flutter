# 方案

在A的稳定提交上恢复af58482e的原始成果，不重新推导已确认数值。077保存完整Figma变量/绑定、小程序固定源码、映射处置、阶段验收与逐图SHA。通过git对象与逐文件SHA核对恢复是否完整，再执行双版本组件字段/全局所有权/57页消费回归。Linux视觉可复用与当前运行源码、原测试、字体和基线完全一致的af58482e已通过记录，但当前PR的远端CI仍须在目标调整为develop后执行。

## 本轮 Review 修正

发现新全局消费者的 nullable 几何插值仍使用旧常量或零。BackTop 四项、Cell 卡片圆角、Table padding、TabBar 高度、Drawer 两项 padding 与图标间距、Search padding 与清除图标、Toast 分形态 padding 改为消费时解析有效 token 默认。保留显式值与 copyWith/merge 中断过渡优先级，不新增 token 绑定、不改变最终默认值与基线。SideBar nullable padding 采用原离散切换，Stepper 已按完整有效样式递归插值，不重复改写。

### 堆叠 PR 的合入保护

#1174 当前目标为 #1172 分支，不可直接合入，否则会把 breaking 改动带回原 PR。先合入 #1172 后检查其旧 head 590df49a 是否仍为 develop 的祖先：普通 merge 保留祖先时可正常改 base；若 #1172 经 squash/rebase 合并导致祖先关系丢失，须将 #1174 在 590df49a 之后的独有提交重新整理到最新 develop（处理冲突并重新验证），再核对最终 diff 只有 breaking 增量，执行新 head 完整 CI。仅切 base 不能保证差异范围正确。

## 已执行的 squash 后整理

#1172 已合入且两端tree一致，因此只对原基础之后的5个独有提交执行 rebase --onto 新develop。逐字节证明运行代码和breaking增量未变；本次验收新增只涉及Spec079。当前PR目标已是develop。

# 方案

## 初次拆分方案（历史检查点）

在A的稳定提交上恢复af58482e的原始成果，不重新推导已确认数值。077保存完整Figma变量/绑定、小程序固定源码、映射处置、阶段验收与逐图SHA。通过git对象与逐文件SHA核对恢复是否完整，再执行双版本组件字段/全局所有权/57页消费回归。Linux视觉可复用与当前运行源码、原测试、字体和基线完全一致的af58482e已通过记录，该检查点尚待调整目标和运行远端CI；此步骤现已完成，当前状态见下节。

## 本轮 Review 修正

发现新全局消费者的 nullable 几何插值仍使用旧常量或零。BackTop 四项、Cell 卡片圆角、Table padding、TabBar 高度、Drawer 两项 padding 与图标间距、Search padding 与清除图标、Toast 分形态 padding 改为消费时解析有效 token 默认。保留显式值与 copyWith/merge 中断过渡优先级，不新增 token 绑定、不改变最终默认值与基线。SideBar nullable padding 采用原离散切换，Stepper 已按完整有效样式递归插值，不重复改写。

### 当前基础与合入保护

#1172 已以 squash 提交 `f5d8df2f` 合入 develop；#1174 已将原基础之后的5个独有提交移植到 develop。原重放检查点的整树和 breaking 增量均一致，证据见 rebase-results.json。当前目标分支为 develop，无须再合入旧基础分支。每次新增提交均以新 head 的完整 CI 和 Reviewer 审批为合入条件，历史成功不代替新 head 检查。

## 已执行的 squash 后整理

#1172 已合入且两端tree一致，因此只对原基础之后的5个独有提交执行 rebase --onto 新develop。逐字节证明运行代码和breaking增量未变；本次验收新增只涉及Spec079。当前PR目标已是develop。

## 2026-10-19 实施范围

修正BackTop测试字体token，新增Cell卡片/边框及Tabs可滚动标签的精确Golden，登记visual入口；保持生产源码和全局token映射不变。双SDK运行受影响组件与调度器自测及严格分析，通过后在Linux3.32分别捕获旧默认参考、新实际图，审阅再更新并复跑。补充图片SHA、差异范围、截图覆盖矩阵和验收命令，推送现有PR并等待最终head完整CI。

# 已确认默认样式与新增全局依赖

本PR是1172收敛后的独立breaking增量，以breaking/flutter-web-theme-tokens为base。用户2026-10-18要求保留原已确认依据和测试，先合入不改默认的主题修复，再审阅本PR。

## 行为契约

恢复原af58482e的九组已确认默认值：Badge square圆角2→3、SideBar tag选中内块9→6、Cell card圆角8→9、Table水平padding16→12、Tabs tag内框padding8→16、BackTop图标20→22、Dropdown箭头24→20、Refresh加载图标24→25、Toast左右22→24/上下14→16。

恢复有设计节点alias、组件规范或用户明确裁定支持的新增全局消费者，包括默认值相同但开始跟随size刻度的属性；不把上游固定默认冒称上游全局引用，不新增无依据别名或比例拟合。组件显式覆盖继续优先；18dp图标和气泡10/1仍为独立组件配置，未扩展站点组件控制器。

初次恢复检查点 b374adc2 的运行源码、已有测试、生成产物、077原始依据和98张基线与af58482e逐字节一致。后续 Review 允许修复已复现的插值缺陷，但不得新增绑定、改变默认值或更新基线；新结果单列，不再沿用全树一致性作为当前实现的验收。A专用的“没有新增依赖”边界测试只在A运行，B使用恢复的114消费点和57页矩阵验证新增依赖。

## 兼容性

数值目标已经用户确认，仍属于默认视觉及自定义主题行为变更。Cell/Table/BackTop/Dropdown/Toast有对应显式覆盖；Badge square、SideBar内块、Tabs内框没有独立组件字段，局部全局Token会影响同子树其他消费者；Refresh内部25没有公开的单属性旧24恢复入口。发布需保留breaking说明。

## 合入顺序

A先合入develop，再将本PR的base从A分支调整为develop并运行完整CI；当前仓库CI只响应目标develop的PR。此PR保持Draft，不将历史全绿或树一致性冒充当前head已运行的CI。

## Token 默认与动画

新增全局消费者的组件 Theme 字段未配置时，过渡的 nullable 端点必须在消费处从当前有效 token 解析，不得使用 0 或旧固定常量代替。copyWith、merge 及中断动画保留未覆盖字段的过渡，显式几何字段覆盖对应过渡；Directional padding 按真实文字方向解析。

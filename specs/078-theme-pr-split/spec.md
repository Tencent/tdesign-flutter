# 主题修复与视觉 breaking 拆分

按用户2026-10-18要求，将拆分前af58482e的实现分成两个可单独审阅的PR。

## PR A：现有1172

保留CSS字体/尺寸转换、TThemeData可选sizeMap和稀疏插值修复、Web消息合并、命令式浮层实时主题继承，以及Badge气泡圆角、Button四档图标尺寸、Tag四档净padding九个可选组件字段。全局刻度基础设施只是数据承载，不新增组件消费者。

Badge方形圆角2、SideBar选中块圆角9、Cell卡片圆角8、Table水平padding16、Tabs tag内框padding8、BackTop图标20、Dropdown箭头24、Refresh加载图标24、Toast水平/垂直padding22/14均保持develop默认。Button高度48/40/32/28、水平padding20/16/12/8和图标24/20/18/18不新增sizeMap依赖；原字体Token来源和已存在的全局引用继续保留。

实例显式值和既有组件Theme优先级不变。Tag统一padding优先于分档；显式分档为净值，不再次扣边框。Badge气泡默认10/10/10/1，square不受该字段影响。copyWith与中断过渡测试保留。

## PR B：独立breaking

以PR A分支为base，保留原077完整设计/小程序依据、114个映射处置、九组已确认默认变更、新增组件全局依赖、57页联动矩阵、98张已审阅的Linux基线及对应测试。叠加后的运行源码、原测试和基线必须与af58482e逐字节一致；额外拆分文档可不同。

PR A先合入后再将PR B目标调整为develop。未获新的用户裁定时不改已确认数值，不丢弃设计快照，不通过更新基线掩盖PR A意外外观变化。

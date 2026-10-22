# 剩余45处为什么不支持原全局映射

本文件是用户新策略实施前的历史分类。当前三项默认及22处一致刻度源码位置已处理，最新状态见[fixed-default-mapping.md](fixed-default-mapping.md)；其中Search的3个默认/布局回退不作为额外可见控制能力。原45点中剩余20点仍未新增全局引用；其中6点现已补齐组件Theme配置，其他14点未在本轮处理。最新组件级状态见[component-token-mapping.md](component-token-mapping.md)。


这里的45是源码消费点，不是45个组件。审查对象是此前拟定的全局size/radius/font/shadow映射。不能确认该映射，不等于该属性不能主题化，也不等于现有组件Theme或实例参数失效。

固定依据为小程序develop@a9f3ba680481d438b0be37e2e25cf4a62cf0acb3及用户设计快照。59项比较中的Cell卡片圆角9、Table水平padding12、Tabs标签内padding16已经另经用户裁定实施；它们原本属于3个默认冲突，不在此45项内。六个补齐全局引用依据的点和四个部分成立的点也不在此45项内。

| 原因 | 消费点数 | 典型情况 |
| --- | --- | --- |
| 组件固定默认，未引用拟定全局Token | 28 | Badge dot-size回退16rpx≈8dp，而非全局size4；Button图标、Toast图标、CountDown块尺寸同类。Loading纵向gap直接12rpx。 |
| 固定默认还存在跨端数值差异 | 3 | BackTop图标22/20dp；DropdownMenu图标20/24dp；Refresh加载图标25/24dp（小程序/Flutter）。 |
| 属性、变体或绘制结构不能对应 | 11 | Checkbox tag外框圆角不是方形指示器角；SideBar行项目auto不是tag内框minHeight56；Search图标不是清除命中盒；Steps图标不是数字圆容器；Tree叶操作槽不是根项反向角。 |
| 只确认字号，不能推导字重或行高 | 2 | Avatar大号字号20来源可确定，但未证明w600归属同一Font；CountDown大号字号18不证明26行高，highlight另有24行盒。 |
| 未找到对应效果引用 | 1 | 不能建立shadow1→头像组内置groupShadow的合成别名。 |

## 组件固定默认，未引用拟定全局Token（28处）

28处能读到固定几何/尺寸，多数另有组件CSS变量；默认数值与size刻度相同，不证明依赖关系。

现有组件Theme/参数入口继续有效；要接到全局需该属性的设计绑定、规范引用或用户新的明确策略。不能为统一控制而擅自改变依赖关系。

编号：M005, M006, M020, M021, M033, M034, M035, M046, M049, M051, M056, M058, M059, M060, M061, M079, M088, M090, M091, M092, M093, M096, M097, M098, M100, M102, M104, M106。

## 固定默认还存在跨端数值差异（3处）

没有全局引用，同时小程序默认与Flutter不同。

保留Flutter默认。需要分别确认目标默认及全局来源；只确认数值仍不能推导全局Token。

编号：M016, M050, M055。

## 属性、变体或绘制结构不能对应（11处）

能看到相似组件，无法把源码变量归给被审查的同一属性。

需同一变体、同一属性的设计节点或可证明等价的布局/绘制边界；不能把已确认的相邻属性扩散给整个组件。

编号：M038, M048, M062, M063, M067, M076, M077, M078, M111, M112, M113。

## 只确认字号，不能推导字重或行高（2处）

字号、字重、行高是独立维度。

保持现有字重/行高；需要完整文字样式或独立属性绑定，不整包迁移Font。

编号：M011, M095。

## 未找到对应效果引用（1处）

官方avatar及avatar-group源码未找到头像组投影的shadow引用链。

保留现有groupShadow配置；需要对应效果绑定或组件规范。源码没有引用不等于设计永远不允许阴影。

编号：M001。

## 对站点主题控制的实际含义

目前站点调整全局Token时，这45处不会仅因数值相同就跟随变化。已存在的组件Theme/参数控制入口仍按当前契约生效。若希望站点统一控制某个组件专有属性，需要先明确采用组件变量入口还是新的全局依赖策略；这属于新的设计决策，不能用“官方已有组件CSS变量”冒充已存在的全局绑定。

例如小程序badge-dot-size默认16rpx，改全局size4并不改变其固定回退；改badge-dot-size才直接控制圆点。Flutter对应dotSize入口仍有效。把它接到size4会新增两者的联动关系，而不是恢复已核实的上游行为。

本轮未尝试读取新的Figma节点，不能声称这些属性在所有设计版本里都没有绑定。逐项原文、固定源码与链接见[miniprogram-comparison.md](miniprogram-comparison.md)和[miniprogram-source-snapshot.json](miniprogram-source-snapshot.json)；机器分组见[remaining-45-analysis.json](remaining-45-analysis.json)。

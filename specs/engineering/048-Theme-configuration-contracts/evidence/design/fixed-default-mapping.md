# 用户授权：固定默认的一致Token映射

本轮以用户2026-10-16的新策略为依据：小程序没有全局引用不再阻止映射，但属性归属及基础刻度默认必须一致。以下是Flutter新增依赖，不能称为Figma绑定或小程序原引用链。已逐项核对小程序375宽基准默认及Flutter size1..16 getter；不修改全局定义。

## 三项默认对齐

| 属性 | 之前 | 当前 | 控制来源 |
| --- | --- | --- | --- |
| BackTop图标 | 20 | 22 | 既有组件iconSize；无22的全局size |
| Dropdown触发箭头 | 24 | 20 | size7；显式iconSize优先 |
| Refresh加载图标 | 24 | 25 | 独立默认；无25的全局size |

## 固定默认的处理

28个待审点中22个源码位置使用一致尺寸刻度，6个暂未接入（2个缺少匹配全局刻度、4个Tag需明确边框补偿语义）。源码位置不是独立可见属性数量：Search前缀图标自身显式20，仍独立于24的图标主题字段；M058/M060/M061为主题默认/布局预留回退，不作为额外三项可见图标控制能力。清除图标通过M059实际响应size8，其32命中区域不变。

| 编号 | 属性/用途 | 默认 | Token |
| --- | --- | --- | --- |
| M005 | Avatar大号内置图标 | 32 | size10 |
| M006 | Avatar中号内置图标 | 24 | size8 |
| M021 | Badge圆点直径 | 8 | size4 |
| M033 | Button大档图标 | 24 | size8 |
| M034 | Button中档图标 | 20 | size7 |
| M046 | Drawer菜单图标 | 24 | size8 |
| M049 | Dropdown栏最小高度 | 48 | size13 |
| M051 | Loading纵向图文间距 | 6 | size3 |
| M056 | Search默认最小高度 | 40 | size12 |
| M058 | Search图标主题默认字段；前缀自身20不受它接管 | 24 | size8 |
| M059 | Search清除图标 | 24 | size8 |
| M060 | Search搜索图标预留的布局回退 | 24 | size8 |
| M061 | Search清除图标预留的布局回退 | 24 | size8 |
| M079 | Swiper分数框最小高度 | 24 | size8 |
| M088 | Tabs tag最小高度 | 32 | size10 |
| M096 | CountDown小号背景块 | 20 | size7 |
| M097 | CountDown中号背景块 | 24 | size8 |
| M098 | CountDown大号背景块 | 28 | size9 |
| M100 | Toast横向图标 | 24 | size8 |
| M102 | Toast纵向图标 | 32 | size10 |
| M104 | Toast加载图标 | 32 | size10 |
| M106 | Toast无文字加载图标 | 32 | size10 |

保留的6点：Badge气泡10/1没有匹配圆角档；Button小/超小图标18没有匹配size档；Tag四档原始水平padding为6/8/8/16，分别可对应size3/size4/size4/size6。此前将有1px边框时的净padding5/7/7/15误判为无匹配刻度，现予更正。Tag仍保留现有常数及按实际borderWidth扣减的行为，组件级Token和盒模型语义已由后续组件批次补齐（不新增全局映射），详见[component-token-mapping.md](component-token-mapping.md)。禁止以radius比例、size减2或字体字号借用来凑默认值。

## 优先级与过渡

实例显式值、既有组件Theme继续优先。Token只决定对应默认属性，不缩放整个组件。Avatar中/大图标、Badge dot、Drawer图标、Dropdown箭头/栏高度、Search高度、Toast图标的nullable默认在主题过渡中使用当前有效Token；copyWith和merge保留延迟默认状态。未新增公开样式字段。

本批三项默认外观有意变化；其他匹配项默认保持。剩余45点中的本批25点已处理，另外20点仍保持原行为（2无匹配刻度、4个Tag边框补偿待实现、11结构/属性缺口、2字体维度缺口、1效果缺口）。上轮另列的6个有全局引用依据的候选点不混入这28点统计。验收见[fixed-default-acceptance.md](fixed-default-acceptance.md)。

后续组件级能力已补齐：见[component-token-mapping.md](component-token-mapping.md)。本文件的双SDK结果只属于此前固定默认批次，不作为新字段的验收。

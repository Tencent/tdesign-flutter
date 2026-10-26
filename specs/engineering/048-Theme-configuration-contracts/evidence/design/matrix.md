# 57页修正后的主题链路矩阵

当前依据：[逐项设计复核](mapping-review.md)、[修正后验收](design-acceptance.md)。此前“418项变化”的检查点仅属历史。

每页检查light/dark与五类同时更新，真实触发浮层并遍历滚动终点。✓表示本轮确认保留的链路有正向断言；—表示没有当前已确认的联动契约，可能为固定几何、显式约束或绑定待确认。不能据此推断整页设计不包含该类token；嵌套内容的变化也不等于容器所有权。

| 页面 | 颜色 | 字体 | 圆角 | 阴影 | 尺寸 |
| --- | --- | --- | --- | --- | --- |
| button | ✓ | ✓ | ✓ | — | ✓ |
| divider | ✓ | ✓ | — | — | ✓ |
| fab | ✓ | ✓ | — | ✓ | ✓ |
| icon | ✓ | — | — | — | — |
| link | ✓ | ✓ | — | — | — |
| text | ✓ | ✓ | — | — | — |
| back-top | ✓ | ✓ | ✓ | — | ✓ |
| drawer | ✓ | ✓ | — | — | ✓ |
| indexes | ✓ | ✓ | ✓ | — | ✓ |
| navbar | ✓ | ✓ | — | — | ✓ |
| side-bar | ✓ | ✓ | ✓ | — | ✓ |
| steps | ✓ | ✓ | ✓ | — | — |
| tab-bar | ✓ | ✓ | ✓ | ✓ | ✓ |
| tabs | ✓ | ✓ | — | — | ✓ |
| calendar | ✓ | ✓ | ✓ | — | ✓ |
| cascader | ✓ | ✓ | ✓ | — | ✓ |
| checkbox | ✓ | ✓ | ✓ | — | ✓ |
| picker | ✓ | ✓ | ✓ | — | ✓ |
| date-time-picker | ✓ | ✓ | ✓ | — | ✓ |
| form | ✓ | ✓ | ✓ | — | ✓ |
| input | ✓ | ✓ | — | — | ✓ |
| radio | ✓ | ✓ | ✓ | — | ✓ |
| rate | ✓ | ✓ | ✓ | ✓ | ✓ |
| search | ✓ | ✓ | ✓ | — | ✓ |
| slider | ✓ | ✓ | — | — | ✓ |
| stepper | ✓ | ✓ | ✓ | — | ✓ |
| switch | ✓ | ✓ | — | — | ✓ |
| textarea | ✓ | ✓ | ✓ | — | ✓ |
| tree-select | ✓ | ✓ | — | — | ✓ |
| upload | ✓ | ✓ | ✓ | — | ✓ |
| avatar | ✓ | ✓ | ✓ | — | ✓ |
| badge | ✓ | ✓ | ✓ | — | ✓ |
| cell | ✓ | ✓ | ✓ | — | ✓ |
| time-counter | ✓ | ✓ | ✓ | — | ✓ |
| collapse | ✓ | ✓ | ✓ | — | ✓ |
| empty | ✓ | ✓ | ✓ | — | ✓ |
| footer | ✓ | ✓ | — | — | ✓ |
| image | ✓ | ✓ | ✓ | — | — |
| image-viewer | ✓ | ✓ | ✓ | — | ✓ |
| progress | ✓ | ✓ | ✓ | — | ✓ |
| result | ✓ | ✓ | — | — | ✓ |
| skeleton | ✓ | — | ✓ | — | ✓ |
| swiper | ✓ | ✓ | ✓ | — | ✓ |
| table | ✓ | ✓ | — | — | ✓ |
| tag | ✓ | ✓ | ✓ | — | — |
| action-sheet | ✓ | ✓ | ✓ | — | ✓ |
| dialog | ✓ | ✓ | ✓ | — | ✓ |
| dropdown-menu | ✓ | ✓ | ✓ | — | ✓ |
| loading | ✓ | ✓ | — | — | ✓ |
| message | ✓ | ✓ | ✓ | ✓ | — |
| notice-bar | ✓ | ✓ | — | — | ✓ |
| popover | ✓ | ✓ | ✓ | ✓ | ✓ |
| popup | ✓ | ✓ | ✓ | — | ✓ |
| pull-down-refresh | ✓ | ✓ | — | — | — |
| swipe-cell | ✓ | ✓ | — | — | ✓ |
| toast | ✓ | ✓ | ✓ | — | ✓ |
| theme | ✓ | ✓ | — | — | — |

57页×2模式=114组；404项适用单项正向契约（原388项加两处圆角、Cell/Table/Tabs三类属性和Badge/Swiper/TimeCounter三类尺寸×双模式），另114组组合检查。固定属性与无关token的隔离由聚焦Widget测试验证。

用户圆角裁定后，Badge、SideBar、TabBar、ActionSheet的受影响页面单独进行双SDK复跑；其他页面沿用上次检查点，不把局部复跑称为重新执行全部57页。结果见radius-decision-acceptance.md。

Cell/Table/Tabs本批增量仅复跑这3个详情页双模式，结果见three-results-<SDK>.json；其他页面沿用既有检查点，不宣称本批新跑57页。

固定默认Token批次重新运行完整57页双模式，另将Badge、Swiper、TimeCounter的size加入正向契约；这些只是适用类别计数，独立属性证据见聚焦测试，不以全页变化替代属性依据。

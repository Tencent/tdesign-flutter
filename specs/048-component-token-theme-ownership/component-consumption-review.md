# 组件 Token 消费审查队列

数据来自 [`component-consumption-audit.json`](./component-consumption-audit.json)，固定小程序源码 `1a1c5ca135b0e9bf19abc43a59870c4908a28ad5`。每项均保留小程序变量名、默认浅/暗值、全局回退表达式和 Flutter 代码位置。下表仅是审查范围与优先级，不把静态命中误判为最终绘制一致。

| 分类 | 数量 | 判定与下一步 |
| --- | ---: | --- |
| 同目录全局 getter 候选 | 406 | 验证状态、Theme 覆盖、默认值最终传到 Widget 或 Painter；仅有字段引用不足以通过。 |
| Theme 字段候选，且有全局 getter | 10 | 验证局部 Theme 的值优先于全局回退，且实例不存在同义样式入口。 |
| 仅 Theme 字段候选 | 15 | 验证 Theme 为空时小程序默认值和暗色值。 |
| 同目录无直接字段证据 | 291 | 区分组件能力缺失、等价硬编码、Flutter 原生样式、跨目录封装与小程序未使用变量。 |
| 无对应 Flutter 组件目录 | 82 | 不机械增加组件 Theme 字段；先确认组件能力是否计划支持。 |

未对应的 82 项来自小程序 `color-picker` 21、`count-down` 5、`grid`/`grid-item` 18、`guide` 29、`overlay` 2、`segmented` 7。BackTop、TabBar、SideBar 等命名不同但确有 Flutter 组件的项目，已通过显式目录别名映射，不计入这 82 项。除其中 1 项在冻结源码中未找到消费，其他 81 项属于 Flutter 当前未实现的组件表面，不应给已有组件硬塞同名 Theme 字段；未来若实现对应组件须重新纳入。

早期“113 项 Less 别名未使用”的判断过于粗糙：小程序 Less 通过 `@@变量` 动态拼接消费 Button、StepItem 等 100 项。扩展扫描 Less/WXSS/WXML/WXS/JS/TS 中的 CSS 变量直接引用后，只有 **10 项**在冻结源码中找不到静态消费证据；这些项目前不要求 Flutter 为对齐当前小程序可见样式而新增 Theme 字段，但不能据此删除小程序的公开 CSS 变量。详见 JSON 的 `miniSourceUse` 和 `reviewDecision`。

| 已裁定的组件变量 | 数量 | 证据与结论 |
| --- | ---: | --- |
| Button 四档高度、水平内边距、图标尺寸 | 12 | 小程序明暗默认值均等于 Flutter 尺寸表；[组件测试](../../tdesign-component/test/components/button/t_button_test.dart)检查最终按钮高度、padding 和 IconTheme 尺寸。对齐的是 375 宽下默认值，不代表已开放逐项组件 Theme 覆盖。 |
| Tag 四档字体、图标尺寸、内边距 | 12 | 小程序始终有 1dp 边框；Flutter 无描边态将该边框宽度补入 padding，四档最终边框盒高度、字体、图标及内边距由 [Tag 组件测试](../../tdesign-component/test/components/tag/t_tag_test.dart)验证。没有把原始 CSS padding 误当成 Flutter 的内部 padding。 |
| Tag 浅色三色、outline 背景/默认描边、square 圆角、关闭图标色 | 7 | 小程序引用链已在组件修正，并由实际 Widget 测试检查；Tag 的四张旧 Linux Golden 仍有像素差，故只记“回退链与 Widget 已验证、视觉待裁定”。 |
| 冻结小程序源码无静态消费者 | 10 | 不为了这些声明而给 Flutter 增加 Theme 字段；未来小程序开始消费或发现动态路径时重审。 |

| 优先组件 | 变量总数 | 无直接证据 | 需要重点裁定的差异 |
| --- | ---: | ---: | --- |
| Button | 98 | 29 | 四档高度、水平内边距、图标尺寸共 12 项已确认默认 Widget 值；outline 四套配色和默认/按压/禁用状态已补测试。`dashed`/`ghost` 变体及其他字段仍须按实例检查，不能把 2dp Less 边框机械写成 Flutter 2dp。 |
| Switch | 32 | 30 | 不能从低静态命中率断言视觉错误；应逐项追踪状态/尺寸/滑块的绘制值。 |
| Tag | 31 | 11 | 12 项尺寸默认值和 7 项回退链/Widget 路径已核对；其余状态组合与 Golden 仍须检查，不能用 Demo 覆盖补齐。 |
| Avatar | 18 | 15 | `radiusCircle` 的 Flutter 固定半径例外必须保留并按非正方形实例核对。 |
| Popover | 13 | 11 | 箭头、偏移和内容内边距需分别核对 Theme 入口与最终布局。 |

验收规则：每个被 Flutter 支持且在小程序实际使用的变量，记录小程序浅/暗最终值、Flutter Theme/Token/常量的有效来源，以及一个实际 Widget/Painter 状态断言；设计稿可访问时再加对应实例的像素比对。`reviewDecision` 记录阶段性裁定；当前未完成跨端最终像素验证，所以 `finalPaintVerified` 仍保持 `false`，不能把 24+7 项阶段性结果误称为完全视觉对齐。

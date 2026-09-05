# Indexes 索引设计与契约收敛

## 目标

- 对齐新版 Figma 页面 24386:5239 的 375×812 移动端展示，以及组件集的 type(number/a-z) × theme(normal/capsule) × state(default/active)。
- 公开 Demo 按新版 Figma 拆成“字母索引 / 数字索引 / 胶囊索引”三项，并验证点击、连续拖动、吸顶与滚动联动。
- 组件继续采用 Flutter 的 ScrollController + builder 组合，不复制小程序只能驱动页面级滚动的限制。

## 跨端证据

- Figma 页面组件集包含 8 个变体。字母与数字是数据形态，normal/capsule 是锚点视觉，default/active 是滚动派生状态。
- 小程序 develop 源码 packages/components/indexes：侧栏项 20px、项间距 2px、右侧 8px；提示最小 48px、与侧栏间距 16px；普通/激活索引都使用 body-small；锚点内边距 4px/16px，激活时使用品牌色和 600 字重。
- 小程序 develop 公开 Demo 只有“基础用法 / 胶囊索引”两项：基础示例使用字母城市列表；胶囊示例使用 1,3,5,7,8,10,#、完整索引和胶囊锚点。新版 Figma 单独增加了普通“数字索引”，这是明显的跨端 Demo 差异；Flutter 按新版 Figma 展示三项，但交互继续以小程序为参考。

## API 与状态所有权

| API | 所有权判断 |
|---|---|
| indexList / builderContent | 数据与内容组合，由调用方提供；不增加动态 Map 配置 |
| initialIndex | 非受控首次位置；必须属于 indexList，后续更新不重置用户滚动 |
| builderAnchor / builderIndex | Flutter Widget 扩展点，分别覆盖锚点和侧栏项 |
| scrollController | 支持页面内嵌滚动容器，是 Flutter 原生能力 |
| sticky / stickyOffset / capsuleTheme / reverse | 实例行为，使用具体默认值，不再由 ThemeData 隐式改变 |
| onChanged | 当前锚点随滚动或选择改变时通知 |
| onSelect | 用户在侧栏点击或拖动选择时通知；程序滚动不冒充用户选择 |
| TIndexesThemeData | 只管理尺寸、颜色和字体；实例无重复视觉字段，组件参数优先问题不存在 |

活动锚点由滚动视口派生，是单一状态源。本轮以 initialIndex 表达小程序 Demo 的初始 B，但不机械增加 current/defaultCurrent 双状态；需要定制索引显示时使用 builderIndex，需要外部驱动时使用 scrollController。

## 默认视觉契约

- 侧栏项 20×20，水平命中区 28，项间距 2，距右 8；激活项为品牌色圆形、反色文字。
- 连续拖动或点击产生 48px 最小宽高的品牌浅色提示，长索引允许水平扩展并单行省略。
- 普通锚点为 secondary-container，激活锚点为 container；4/16 内边距，激活底边框；胶囊模式水平外边距 8、圆角为 circle。
- 所有颜色、字体与可定制尺寸从当前 TDesign 子树主题解析，支持明暗主题。

## 兼容性

这是 breaking change：sticky、stickyOffset、capsuleTheme、reverse 从 nullable 改为具体默认值；TIndexesThemeData 移除行为字段并新增视觉字段。新增 initialIndex 为兼容能力。迁移时把行为配置放回每个 TIndexes 实例，把视觉覆盖放入 TIndexesThemeData。

## 验收门禁

- 组件、Demo、Theme 优先级及手势状态均有 Widget 测试；生产代码行/函数覆盖率均不低于 95%。
- Flutter 3.32.0 与 latest 严格 analyze、非视觉测试通过。
- Flutter 3.32.0 固定 375×812、DPR 1、文字缩放 1 生成并无更新参数复跑整页及三种打开态共 8 张明暗 Golden。
- API 文档与示例代码片段由仓库脚本生成并检查。

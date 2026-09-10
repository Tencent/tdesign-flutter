# Progress 设计对齐

## 背景

当前 Progress Demo 的线性与百分比内显示例使用相同配置，状态示例也全部使用默认品牌色；组件缺少状态这一权威入口，导致 warning、error、success 只能由外层 Theme 模拟，无法表达状态语义。设计稿同时标出了条形圆角、标题和按钮形态偏差。

## 目标

- 公开 Demo 按设计稿展示基础线性、百分比内显、环形、微型环形、按钮、微型按钮及三类状态矩阵。
- 由组件实例 `status` 唯一表达 normal、warning、error、success 状态，并提供对应默认颜色和状态图标。
- 线性形态默认将百分比放在右侧，新增 plump 形态承载百分比内显，避免两个公开示例配置相同。
- 条形进度的轨道与已完成部分保持完整圆角；按钮和微型按钮支持真实点击推进进度。

## 非目标

- 不机械复制小程序的 `percentage`、`theme` 或 `size` API；以 Flutter 的 `LinearGradient` 表达设计稿中的逐实例渐变样式。
- 不新增异步任务、Controller 或业务完成状态管理。
- 不保留旧形态、旧标签位置或旧 Theme 字段的兼容代码；本次以 breaking change 一次收敛。

## 范围

- `TProgress` 的形态、状态、默认视觉、语义和公开 dartdoc。
- Progress Demo、生成 API/代码片段、组件与 Demo 测试、light/dark Golden、CI 回归登记。

## 行为契约

- `value` 仍以 0～1 表示，超出范围时收敛到边界，null 表示不确定进度。
- `linear` 默认在右侧显示百分比；`plump` 在进度条内部显示百分比。
- `status` 是状态的唯一实例入口；Theme 只提供具体视觉覆盖，不持有状态选择器。
- warning、error、success 在未传自定义 label 时展示对应状态图标；normal 展示百分比。
- `microCircular` 是只读紧凑环形进度；`microButton` 与 `button` 是可交互形态，只有它们响应 `onTap` / `onLongPress`。
- `microButton` 的可见圆环保持 16px，同时提供至少 44px 的触控区域和按钮语义。
- `button` 默认由组件绘制品牌色轨道和高对比已完成渐变；Demo 仅展示一个实例，初始显示“开始”，每次点击按 10% 逐步增加并显示百分比，不在外层补背景。
- `gradient` 是逐实例完整填充样式，仅用于 linear、plump、button；显式渐变优先于 Theme、Material 主题和 status 默认色。
- `semanticsLabel` / `semanticsValue` 对齐 Flutter ProgressIndicator 的无障碍命名，不输出内部枚举名称。
- 实例状态默认色低于显式组件 Theme / Flutter ProgressIndicatorTheme 的颜色覆盖。

## 验收标准

- [ ] Demo 的分组、标题、顺序、状态和交互结果符合设计稿节点 `24386:5271`。
- [ ] 组件测试覆盖全部形态、四种状态、渐变、Theme 优先级、圆角、触控区域、动画与交互边界。
- [ ] Flutter 3.32.0 与 latest 的功能测试和严格 analyze 通过。
- [ ] 组件生产源码覆盖率 LH/LF 不低于 95%。
- [ ] 固定 Linux Flutter 3.32.0 的 light/dark 整页 Golden 可复现。
- [ ] 最终运行 Demo 并执行一次按钮和微型按钮的真实操作比对。

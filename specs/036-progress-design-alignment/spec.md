# Progress 设计对齐

## 背景

当前 Progress Demo 的线性与百分比内显示例使用相同配置，状态示例也全部使用默认品牌色；组件缺少状态这一权威入口，导致 warning、error、success 只能由外层 Theme 模拟，无法表达状态语义。设计稿同时标出了条形圆角、标题和按钮形态偏差。

## 目标

- 公开 Demo 按设计稿展示基础线性、百分比内显、环形、微型环形、按钮、微型按钮及三类状态矩阵。
- 由组件实例 `status` 唯一表达 primary、warning、error、success 状态，并提供对应默认颜色和状态图标。
- 线性形态默认将百分比放在右侧，新增 plump 形态承载百分比内显，避免两个公开示例配置相同。
- 条形进度的轨道与已完成部分保持完整圆角；按钮和微型按钮支持真实点击推进进度。

## 非目标

- 不机械复制小程序的 `percentage`、`theme`、`size` 或渐变色 API。
- 不新增异步任务、Controller 或业务完成状态管理。
- 不删除已发布的 Theme 样式入口；历史 labelPosition 定制继续兼容。

## 范围

- `TProgress` 的形态、状态、默认视觉、语义和公开 dartdoc。
- Progress Demo、生成 API/代码片段、组件与 Demo 测试、light/dark Golden、CI 回归登记。

## 行为契约

- `value` 仍以 0～1 表示，超出范围时收敛到边界，null 表示不确定进度。
- `linear` 默认在右侧显示百分比；`plump` 在进度条内部显示百分比。
- `status` 是状态的唯一实例入口；Theme 只提供具体视觉覆盖，不持有状态选择器。
- warning、error、success 在未传自定义 label 时展示对应状态图标；primary 展示百分比。
- `button` 与带回调的 `micro` 可点击；普通 linear、plump、circular 不响应交互回调。
- 实例状态默认色低于显式组件 Theme / Flutter ProgressIndicatorTheme 的颜色覆盖。

## 验收标准

- [x] Demo 的分组、标题、顺序、状态和交互结果符合设计稿节点 `24386:5271`。
- [x] 组件测试覆盖全部形态、四种状态、Theme 优先级、圆角、动画与交互边界。
- [x] Flutter 3.32.0 与 latest 的功能测试和严格 analyze 通过。
- [x] 组件生产源码覆盖率 LH/LF 不低于 95%。
- [x] 固定 Linux Flutter 3.32.0 的 light/dark 整页 Golden 可复现。
- [x] 最终运行 Demo 并执行一次按钮进度真实操作比对。

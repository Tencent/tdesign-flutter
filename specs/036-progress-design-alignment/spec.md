# Progress 设计对齐

## 背景

当前 Progress Demo 的线性与百分比内显示例使用相同配置，状态示例也全部使用默认品牌色；组件缺少状态这一权威入口，导致 warning、error、success 只能由外层 Theme 模拟，无法表达状态语义。设计稿同时标出了条形圆角、标题和按钮形态偏差。

## 目标

- 公开 Demo 按设计稿展示基础线性、百分比内显、环形、微型环形、按钮、微型按钮及三类状态矩阵。
- 由组件实例 `status` 唯一表达 normal、warning、error、success 状态，并提供对应默认颜色和状态图标。
- 以 `TProgress.linear`、`TProgress.plump`、`TProgress.circular`、`TProgress.microCircular`、`TProgress.button`、`TProgress.microButton` 命名构造函数表达形态，不再由调用方传入 `variant`。
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
- `variant` 只作为组件实例的只读形态信息；公开创建入口不接受 `variant` 参数。
- 各命名构造函数只暴露对应形态有效的参数：`gradient` 仅在线性、plump 和按钮形态提供，交互回调仅在按钮与微型按钮形态提供。
- `linear` 默认在右侧显示百分比；`plump` 在进度条内部显示百分比。
- `linear` 默认轨道高度为 6px，百分比使用 `Body/Medium`
  （14px / 22px / 400），状态图标为 22px，标签与轨道间距为 8px。
- `plump` 默认高度为 20px，内部百分比使用 `Mark/Small`
  （12px / 20px / 600），右侧内边距为 8px，外置状态图标为 20px。
- 基础线性 Demo 使用设计稿中的 80% 展示值，百分比位于轨道右侧；页面保持设计稿白底，并只设置 16px 水平外间距。
- 默认环形为 112px / 6px 描边，百分比使用 `Title/ExtraLarge`
  （20px / 28px / 600），状态图标为 48px；微型环形为 24px；按钮高度为
  48px，按钮文案使用 `Mark/Large`（16px / 24px / 600）。
- warning、error、success 在线性与环形形态只显示状态图标；plump 保留内部百分比，并将状态图标放在轨道外侧。
- error 图标按形态区分：线性为实心感叹号圆形，plump 为实心叉号圆形，环形为无外圈叉号。
- `status` 是状态的唯一实例入口；Theme 只提供具体视觉覆盖，不持有状态选择器。
- warning、error、success 在未传自定义 label 时按形态展示对应状态图标；normal 展示百分比。
- `microCircular` 是只读紧凑环形进度；`microButton` 与 `button` 是可交互形态，只有它们响应 `onTap` / `onLongPress`。
- `microButton` 的可见圆环保持 24px，组件自身占用并提供 44×44 的触控区域和按钮语义；Demo 不得用裁剪、负位移或溢出布局把组件伪装成 24px 占位。
- `button` 默认由组件绘制品牌色轨道和高对比已完成渐变；Demo 仅展示一个实例，初始显示“开始”，点击一次后自动按 1% 连续增加至 80% 并显示百分比，不在外层补背景。
- `gradient` 是逐实例完整填充样式，仅用于 linear、plump、button；显式渐变优先于 Theme、Material 主题和 status 默认色。
- `semanticsLabel` / `semanticsValue` 对齐 Flutter ProgressIndicator 的无障碍命名，不输出内部枚举名称。
- 填充颜色优先级为实例渐变、组件 Theme、Flutter ProgressIndicatorTheme、`status` 语义 token。Material `ColorScheme.primary` 不覆盖 `status` 语义。

## 验收标准

- [x] Demo 的分组、标题、顺序、状态和交互结果符合设计稿节点 `24386:5271`。
- [x] 组件测试覆盖全部形态、四种状态、渐变、Theme 优先级、圆角、触控区域、动画与交互边界。
- [x] Flutter 3.32.0 与 latest 的功能测试和严格 analyze 通过。
- [x] 组件生产源码覆盖率 LH/LF 不低于 95%。
- [x] 固定 Linux Flutter 3.32.0 的 light/dark 整页 Golden 可复现。
- [x] 最终运行 Demo 并执行一次按钮和微型按钮的真实操作比对。

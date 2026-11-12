# Fab 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

默认动作层受父按钮样式影响，拖拽坐标和点击判定容易分叉。

Flutter `TFab` 已采用“定位层 + 内嵌 `TButton` 动作层”的组合模式，但当前动作层
没有消费 `TFabDefaults` 中声明的默认规格。由于 `TThemeBuilder` 会注入默认
`TButtonThemeData`，默认 Fab 实际解析为 `medium / fill / defaultTheme`，与 TDesign
小程序 Fab 源码固定的 `large / fill / primary` 基线不一致。

源码对照还发现以下偏差：Flutter 默认使用 Material `Icons.add`，缺少小程序
`shadow-2` 投影，图标与文字间距沿用 Button 的 8dp 而不是小程序的 4dp；拖拽边界
在 right/bottom 坐标系中交换了 `start/end` 含义；吸附时长当前只控制延迟跳变，
并未产生动画。

对照基线：

- Flutter：`develop@67d334a7`
- TDesign 小程序：`develop@d973e4aa`

## 范围与非目标

### 目标

- 默认动作层稳定使用 `large / fill / primary`，纯图标为圆形，图标加文字为胶囊形。
- 使用 TDesign add 图标、`spacer4` 和 `shadowsMiddle`（对应小程序 `shadow-2`）。
- 修正非对称水平/垂直拖拽边界的方向映射。
- 让磁吸时长控制真实的平滑动画，并保留拖拽期间的点击语义。
- Demo 按小程序“组件类型 / 组件样式”分组，通过四个通栏按钮切换纯图标、图标加
  文字、可移动和自动收缩场景，页面始终只展示一个悬浮 Fab。
- 不通过 Demo 局部样式修正默认 Fab；自定义插槽示例只负责自定义内容自身。

### 涉及

- `fab/t_fab*.dart` 的默认动作层、投影、拖拽边界和磁吸动画。
- TFab Demo、生成示例资产、站点文档和 API 文档。
- TFab Widget、主题、拖拽和 Golden 回归测试。

### 不涉及

- 不恢复迁移前的 `TFabTheme`、`TFabShape`、`TFabSize` 公共枚举。
- 不复制小程序 `buttonProps`、`openType`、`usingCustomNavbar` 等平台 API。
- 不新增独立颜色、尺寸、形状参数；需要完整自定义动作层时继续使用 `child`。
- 不把“自动收缩”做成 TFab 公共能力；它继续由页面滚动状态和 `child` 组合实现。
- 不修改 `TButton` 的公开 API 或通用视觉契约。

- Button 普通、渐变、尺寸和 shape 的通用实现。
- 页面级路由、Overlay 或业务滚动控制器。
- 小程序特有开放能力。

## 最终方案与行为契约

- 未提供 `child` 时，内嵌 `TButton` 显式使用：
  - `TButtonSize.large`
  - `TButtonVariant.fill`
  - `TButtonColorPreset.primary`
- 未提供 `icon` 时使用 TDesign `TIcons.add`；显式 `icon` 完整保留调用方 Widget。
- `text` 为空时使用 `TButtonShape.circle`；非空时使用 `TButtonShape.round`。
- 图标与文字间距使用内置 4dp；默认动作层投影使用 `shadow2`，对应小程序
  `--td-shadow-2`。自定义 `child` 自行负责内容、形状与投影。
- 默认动作层不继承父级 `TButtonThemeData` 的尺寸、变体、色板、padding 或 gradient，
  避免只覆盖部分字段形成不稳定基线；品牌 Token 保持动态回退，外部 Material ColorScheme 不反向控制内置外观。
  需要完整动作层定制时使用 `child`。
- `right/bottom` 默认值保持 16/32dp，并继续叠加对应安全区。
- `TFabBounds.start/end` 始终描述父 Stack 内容区的起止边：
  - 水平：`start = left`、`end = right`
  - 垂直：`start = top`、`end = bottom`
  - 内部转换为 right/bottom 坐标时不得交换物理边界。
- `TFabDragDetails.position` 明确表示 `Offset(right, bottom)`，不伪装成左上角坐标。
- `magnetAnimationDuration` 控制当前位置到目标边界的真实动画；新一轮拖拽或布局更新
  会终止旧动画，避免延迟任务回写过期位置。
- 单次拖拽手势期间距起点的最大位移未超过 `dragTapSlop` 时，仍触发一次
  `onPressed`；只要曾超过阈值，即使松手前回到起点附近也仍按拖拽处理。默认
  TButton 与自定义 `child` 的点击次数一致，不重复触发。
- `dragTapSlop` 统计屏幕空间中的全方向位移，与 `draggable` 轴向无关；单轴模式只
  限制 Fab 的实际位置更新。手指向锁定轴大幅滑动后不得误触 `onPressed`。
- Demo 与默认组件的边界：前三个场景只使用 TFab 默认能力；自动收缩场景使用
  `child` 组合页面滚动状态，不向 TFab 增加 API。滚动开始时收缩，滚动结束 100ms
  后展开，拖动仍持续时不得因定时器提前展开。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 默认动作层使用受控的内置 Button 配置；完整定制通过 child，保持拖拽、点击和磁吸路径一致。 |
| 保留的边界与代价 | 位置显式使用 right/bottom 坐标，拖拽判定按屏幕全方向位移；轴向限制只影响位置更新。 |

### 设计演变中的关键理由

- 固定动作层基线意味着父级 Button Theme 不再隐式改变 TFab 动作层；需要完整定制时
  使用 `child`，避免恢复跨组件 `buttonProps` 或产生部分继承、部分覆盖的不稳定状态。
- 投影会扩大绘制边界但不扩大布局和命中区域，需要 Golden 与几何测试分别锁定。
- 边界方向修正可能影响依赖旧错误行为的调用方，因此 PR 必须给出迁移说明。
- 磁吸动画不能留下延迟 Future；必须在新拖拽、Widget 更新和 dispose 时安全终止。

## 兼容性与迁移

- 默认 Fab 从当前实际的 `medium / defaultTheme` 调整为小程序基线
  `large / primary`，会改变默认尺寸和颜色，属于用户可感知的默认行为变化。
- 父级 `TButtonThemeData` 不再隐式改变 TFab 默认动作层；原先依赖该路径的调用方应改用
  `child` 明确组合自定义动作层。
- `TFabBounds` 非对称边界修正为 dartdoc 已声明的物理方向；依赖旧错误映射的代码
  需要交换对应的 `start/end` 值。
- `TFabBounds.start/end` 收紧为非负有限值；传入负数、`NaN` 或无穷大会在
  debug 模式触发断言，调用方应先将边界归一化为有效留白。
- 不新增、删除或重命名公开 API。

## 验收标准

- 默认纯图标和图文 Fab 的尺寸、颜色、形状、图标、间距和投影有 Widget/Golden 测试。
- 父级按钮样式及 Material 主题不改变 TFab 内置动作层，自定义 child 不受隔离污染。
- 自定义 `child` 不被默认动作层投影或按钮规格污染。
- 水平和垂直非对称边界分别验证 start/end 映射。
- 磁吸动画验证起点、中间帧、终点以及新拖拽取消旧动画。
- 默认动作层与 child 模式的轻微拖拽点击均只触发一次。
- Demo 分组、通栏切换、文案和四个场景与小程序源码一致，自动收缩无布局溢出
  或拖动期间闪烁，示例资产无漂移。
- Flutter 3.32.0 与 latest 的 analyze、TFab 测试通过。
- Web Demo 构建成功并完成浅色模式截图复查。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

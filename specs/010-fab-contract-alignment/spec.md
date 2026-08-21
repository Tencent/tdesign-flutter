# TFab 视觉与拖拽契约对齐

## 背景

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

## 目标

- 默认动作层稳定使用 `large / fill / primary`，纯图标为圆形，图标加文字为胶囊形。
- 使用 TDesign add 图标、`spacer4` 和 `shadowsMiddle`（对应小程序 `shadow-2`）。
- 修正非对称水平/垂直拖拽边界的方向映射。
- 让磁吸时长控制真实的平滑动画，并保留拖拽期间的点击语义。
- Demo 按小程序“组件类型 / 组件样式”分组，通过四个通栏按钮切换纯图标、图标加
  文字、可移动和自动收缩场景，页面始终只展示一个悬浮 Fab。
- 不通过 Demo 局部样式修正默认 Fab；自定义插槽示例只负责自定义内容自身。

## 非目标

- 不恢复迁移前的 `TFabTheme`、`TFabShape`、`TFabSize` 公共枚举。
- 不复制小程序 `buttonProps`、`openType`、`usingCustomNavbar` 等平台 API。
- 不新增独立颜色、尺寸、形状参数；需要完整自定义动作层时继续使用 `child`。
- 不把“自动收缩”做成 TFab 公共能力；它继续由页面滚动状态和 `child` 组合实现。
- 不修改 `TButton` 的公开 API 或通用视觉契约。

## 范围

### 涉及

- `fab/t_fab*.dart` 的默认动作层、投影、拖拽边界和磁吸动画。
- TFab Demo、生成示例资产、站点文档和 API 文档。
- TFab Widget、主题、拖拽和 Golden 回归测试。

### 不涉及

- Button 普通、渐变、尺寸和 shape 的通用实现。
- 页面级路由、Overlay 或业务滚动控制器。
- 小程序特有开放能力。

## 行为契约

- 未提供 `child` 时，内嵌 `TButton` 显式使用：
  - `TButtonSize.large`
  - `TButtonVariant.fill`
  - `TButtonColorScheme.primary`
- 未提供 `icon` 时使用 TDesign `TIcons.add`；显式 `icon` 完整保留调用方 Widget。
- `text` 为空时使用 `TButtonShape.circle`；非空时使用 `TButtonShape.round`。
- 图标与文字间距使用 `spacer4`；默认动作层投影使用 `shadowsMiddle`，对应小程序
  `--td-shadow-2`。自定义 `child` 自行负责内容、形状与投影。
- 默认动作层不继承父级 `TButtonThemeData` 的尺寸、变体、色板、padding 或 gradient，
  避免只覆盖部分字段形成不稳定基线；品牌 token 和 Flutter `ColorScheme` 仍正常生效。
  需要完整动作层定制时使用 `child`。
- `right/bottom` 默认值保持 16/32dp，并继续叠加对应安全区。
- `TFabBounds.start/end` 始终描述父 Stack 内容区的起止边：
  - 水平：`start = left`、`end = right`
  - 垂直：`start = top`、`end = bottom`
  - 内部转换为 right/bottom 坐标时不得交换物理边界。
- `TFabDragDetails.position` 明确表示 `Offset(right, bottom)`，不伪装成左上角坐标。
- `magnetAnimationDuration` 控制当前位置到目标边界的真实动画；新一轮拖拽或布局更新
  会终止旧动画，避免延迟任务回写过期位置。
- 拖拽手势被识别但总位移未超过 `dragTapSlop` 时仍触发一次 `onPressed`；默认
  TButton 与自定义 `child` 的点击次数一致，不重复触发。
- Demo 与默认组件的边界：前三个场景只使用 TFab 默认能力；自动收缩场景使用
  `child` 组合页面滚动状态，不向 TFab 增加 API。滚动开始时收缩，滚动结束 100ms
  后展开，拖动仍持续时不得因定时器提前展开。

## Breaking change 分析

- 默认 Fab 从当前实际的 `medium / defaultTheme` 调整为小程序基线
  `large / primary`，会改变默认尺寸和颜色，属于用户可感知的默认行为变化。
- 父级 `TButtonThemeData` 不再隐式改变 TFab 默认动作层；原先依赖该路径的调用方应改用
  `child` 明确组合自定义动作层。
- `TFabBounds` 非对称边界修正为 dartdoc 已声明的物理方向；依赖旧错误映射的代码
  需要交换对应的 `start/end` 值。
- 不新增、删除或重命名公开 API。

## 验收标准

- [ ] 默认纯图标和图文 Fab 的尺寸、颜色、形状、图标、间距和投影有 Widget/Golden 测试。
- [ ] 父级 `TButtonThemeData.defaultSize/defaultVariant` 不改变 TFab 默认动作层基线。
- [ ] 自定义 `child` 不被默认动作层投影或按钮规格污染。
- [ ] 水平和垂直非对称边界分别验证 start/end 映射。
- [ ] 磁吸动画验证起点、中间帧、终点以及新拖拽取消旧动画。
- [ ] 默认动作层与 child 模式的轻微拖拽点击均只触发一次。
- [ ] Demo 分组、通栏切换、文案和四个场景与小程序源码一致，自动收缩无布局溢出
  或拖动期间闪烁，示例资产无漂移。
- [ ] Flutter 3.32.0 与 latest 的 analyze、TFab 测试通过。
- [ ] Web Demo 构建成功并完成浅色模式截图复查。

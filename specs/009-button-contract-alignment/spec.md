# Button 尺寸、形状与原生交互契约对齐

## 背景

`TButtonSize` 已声明 48、40、32、28dp 四档视觉尺寸，但普通按钮底层
`ElevatedButton` 默认使用 48dp Material tap target，导致中、小和超小按钮参与父布局时
均占 48dp。该差异会使按钮作为 FormItem 尾部插槽时出现可见内容伪居中。

同时，当前四档文字与图标尺寸没有使用对应的 TDesign mark 字体 token，且普通按钮与
渐变按钮分别维护尺寸 fallback，存在持续漂移。渐变分支也没有完整遵循
`ButtonStyle.tapTargetSize`、视觉密度和按钮语义。

后续源码与真机验收还发现：`square` 将“正方形图标按钮”错误解释为零圆角，多个
variant 又把 `overlayColor` 固定为透明，导致渐变和 ghost 按钮缺少可见点击反馈。
这些问题应在 Button 的统一样式解析中修复，而不是由 Demo 额外绘制。

## 目标

- 让四档按钮默认按 TDesign 48、40、32、28dp 视觉尺寸参与布局。
- 对齐小程序 Button 的字号、行高、字重、水平内边距和图标尺寸。
- 保留 Flutter 原生主题和实例 `ButtonStyle` 对 tap target 的显式控制。
- 统一普通与渐变按钮的尺寸来源、点击区和无障碍按钮语义。
- 使 `TFab` 显式遵循组合组件的 large / fill / primary 基线，不再依赖 Material 默认点击区间接获得尺寸。
- Demo 展示组件自身默认结果，不通过外层位移修正按钮位置。
- Button Demo 按验收小程序的图标、通栏和四种 shape 场景编排；通栏继续由 Flutter
  父布局表达。

## 非目标

- 不复制小程序 `openType`、`block`、`loadingProps` 等平台专属 API。
- 不新增 `loading` 或通栏布局参数；Flutter 调用方继续使用内容组合和父布局。
- 不新增独立的图标按钮组件；纯图标按钮继续由 `TButton(icon: ..., child: null)` 表达。
- 除移除职责混杂且已失去通栏行为的 `TButtonShape.filled`、以及属于父布局职责的
  `TButtonThemeData.margin` 外，不删除或重命名其他公开 API。
- 不在本 PR 重做 Button 全部颜色和变体设计。

## 范围

### 涉及

- `TButton` 普通与渐变渲染分支。
- `TButtonResolve` 的尺寸、字体、图标与 Flutter Theme 解析。
- Button Demo、dartdoc、Widget/Theme/Golden 测试。
- `TFab` 内嵌 Button 的基线配置与拖拽边界回归。

### 不涉及

- Input、Form、Upload 等与 Button 本次行为无关的组件实现。
- 小程序开放能力与业务提交语义。
- 组件公开构造器签名。

## 行为契约

- `large/medium/small/extraSmall` 默认视觉高度分别为 48/40/32/28dp。
- large/medium 使用 `fontMarkLarge`，small/extraSmall 使用 `fontMarkMedium`；
  对应字号为 16/16/14/14dp，并保留 token 行高和字重。
- 默认图标尺寸分别为 24/20/18/18dp；显式传入的 `Icon.size` 和 `Icon.color`
  不被覆盖。
- 图标按钮复用 `TButton` 的内容、状态、事件和主题解析：`icon + child` 表示图文按钮，
  仅 `icon` 表示纯图标按钮，不建立第二套按钮 API。
- `TButtonShape.square` 用于纯图标按钮时约束宽高相等，并使用 `radiusDefault`；
  它不表示零圆角，也不裁剪图文按钮的内容宽度。
  `circle` 同样只改变外形，不改变图标按钮的交互契约。
- 默认 tap target 使用 `MaterialTapTargetSize.shrinkWrap`，使组件布局尺寸与
  TDesign 视觉尺寸一致；对应 Material ButtonTheme 的 `ButtonStyle.tapTargetSize` 可覆盖
  默认值，实例 `ButtonStyle.tapTargetSize` 具有最高优先级。
- `MaterialTapTargetSize.padded` 只扩展点击和布局区域，不放大可见按钮背景；普通与渐变
  分支行为一致。
- 渐变按钮保留 button/enabled 语义，并消费解析后的 visual density、tap target、
  mouse cursor、feedback 和 splash 配置。
- 渐变按钮与 Flutter `ButtonStyleButton` 共用同一状态解析契约：pressed、hovered、
  focused、disabled 变化时，颜色、文字、图标、边框、形状、padding、尺寸、阴影和
  cursor 等 stateful `ButtonStyle` 字段必须按实时状态重新解析，不能只在 build 时按
  enabled/disabled 静态取值。
- 渐变分支支持 `ButtonStyle.alignment`、`backgroundBuilder`、
  `foregroundBuilder`，并与普通分支一样允许实例 `iconColor`、`iconSize` 覆盖组件
  尺寸默认值；显式 `Icon.size` / `Icon.color` 仍保持 Flutter 原生最高优先级。
- `tapTargetSize` 由统一 resolve 入口保证非空，渐变布局不再维护与 resolver 分叉的
  Material Theme fallback；visual density 对约束和 padding 的处理与
  `ButtonStyleButton` 一致。
- 渐变按钮沿用 Flutter `ButtonStyleButton` 的外层 `Semantics` + 内层 `InkWell`
  结构，button/enabled 与 tap 动作必须合并为一个语义节点，不能产生重复按钮节点。
- 渐变分支的本地 tap-target 只承接 Flutter 私有 `_InputPadding` 的公开可见行为：
  48dp padded 点击区、可见按钮居中和空白区命中重定向；intrinsic、dry layout、
  baseline 与 hit test 必须由回归测试锁定。
- 启用态按钮使用 Flutter `WidgetState`/Ink 状态层提供 pressed、hovered、focused 反馈；
  现有语义按压背景 token 继续生效，fill、outline、text、ghost 与渐变分支均必须有可见反馈。显式
  Material ButtonTheme、`TButtonThemeData` 或实例 `ButtonStyle.overlayColor` 可覆盖默认状态层。
- fill、outline、text 已通过语义背景 token 表达 pressed 时，不再叠加第二层 pressed overlay；
  ghost、渐变或静态自定义背景没有 pressed 背景变化时，使用前景色 overlay 补足反馈。
  hover、focused 继续由 overlay 覆盖全部变体。
- 默认状态层基于 P0 合并后的最终前景色和背景状态生成；实例 `ButtonStyle` 提供的
  stateful 背景不会被重复叠加 pressed overlay。
- 禁用按钮的默认状态层保持透明，不响应点击或长按。
- 移除 `TButtonShape.filled`：填充视觉继续由 `TButtonVariant.fill` 表达，通栏由 Flutter
  父布局控制，零圆角通过实例 `ButtonStyle.shape` 定制；不新增替代 shape 枚举。
- 移除 `TButtonThemeData.margin`：按钮外部间距由 `Padding`、`SizedBox`、`Wrap.spacing`
  等 Flutter 父布局表达，组件 Theme 只保留按钮自身视觉与内部布局。
- `TFab` 内嵌 Button 显式使用 large / fill / primary，与 MiniProgram 的组合基线一致。

## 验收标准

- [x] 四档普通和渐变按钮的视觉高度、字号、行高、字重、内边距和图标尺寸均有 Widget 测试。
- [x] 默认、Flutter Theme 和实例三种 tap target 优先级有回归测试。
- [x] padded tap target 下可见 Material 保持规格尺寸，点击区域扩展到 48dp。
- [x] 渐变与普通按钮的 enabled/disabled、点击、长按和语义行为一致。
- [x] fill、outline、text、ghost 与渐变按钮均有可解析的按压反馈，禁用态无反馈，主题和实例
  `overlayColor` 优先级有回归测试。
- [x] Button Golden 与小程序尺寸 Demo 完成截图比对。
- [x] `TFab` 默认尺寸与拖拽边界回归通过。
- [x] Flutter 3.32.0 与 latest 静态检查通过。
- [x] 不新增公开 API，Demo 不使用位移修复组件视觉。
- [x] 渐变分支的实时 pressed/hovered/focused/disabled 样式与动态 cursor 有回归测试。
- [x] 普通与渐变分支的 P0 icon 样式及渐变 layer builder/alignment 有回归测试。

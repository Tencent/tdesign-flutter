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
- Button Demo 按验收小程序的图标、通栏和四种 shape 场景编排；`filled` 不混入 shape Demo，
  通栏继续由 Flutter 父布局表达。

## 非目标

- 不复制小程序 `openType`、`block`、`loadingProps` 等平台专属 API。
- 不新增 `loading` 或通栏布局参数；Flutter 调用方继续使用内容组合和父布局。
- 不新增独立的图标按钮组件；纯图标按钮继续由 `TButton(icon: ..., child: null)` 表达。
- 不删除或重命名现有公开枚举值。
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
- 启用态按钮使用 Flutter `WidgetState`/Ink 状态层提供 pressed、hovered、focused 反馈；
  现有语义按压背景 token 继续生效，渐变和 ghost 分支也必须有可见反馈。显式
  Material ButtonTheme、`TButtonThemeData` 或实例 `ButtonStyle.overlayColor` 可覆盖默认状态层。
- 禁用按钮的默认状态层保持透明，不响应点击或长按。
- `TButtonShape.filled` 只表示直角外形，不承诺自动通栏；按钮宽度继续由 Flutter 父布局控制。
- `TFab` 内嵌 Button 显式使用 large / fill / primary，与 MiniProgram 的组合基线一致。

## 验收标准

- [x] 四档普通和渐变按钮的视觉高度、字号、行高、字重、内边距和图标尺寸均有 Widget 测试。
- [x] 默认、Flutter Theme 和实例三种 tap target 优先级有回归测试。
- [x] padded tap target 下可见 Material 保持规格尺寸，点击区域扩展到 48dp。
- [x] 渐变与普通按钮的 enabled/disabled、点击、长按和语义行为一致。
- [x] 普通、ghost、渐变按钮均有可解析的按压反馈，禁用态无反馈，主题和实例
  `overlayColor` 优先级有回归测试。
- [x] Button Golden 与小程序尺寸 Demo 完成截图比对。
- [x] `TFab` 默认尺寸与拖拽边界回归通过。
- [x] Flutter 3.32.0 与 latest 静态检查通过。
- [x] 不新增公开 API，Demo 不使用位移修复组件视觉。

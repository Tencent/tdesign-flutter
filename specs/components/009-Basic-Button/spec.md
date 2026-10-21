# Button 设计说明

<a id="record-009-contract-alignment"></a>
<a id="record-037-disabled-theme-alignment"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

普通与渐变按钮的尺寸、状态反馈和 tap target 曾走不同路径，Material 主题形成隐式入口。

`TButtonSize` 已声明 48、40、32、28dp 四档视觉尺寸，但普通按钮底层
`ElevatedButton` 默认使用 48dp Material tap target，导致中、小和超小按钮参与父布局时
均占 48dp。该差异会使按钮作为 FormItem 尾部插槽时出现可见内容伪居中。

同时，当前四档文字与图标尺寸没有使用对应的 TDesign mark 字体 token，且普通按钮与
渐变按钮分别维护尺寸 fallback，存在持续漂移。渐变分支也没有完整遵循
`ButtonStyle.tapTargetSize`、视觉密度和按钮语义。

后续源码与真机验收还发现：`square` 将“正方形图标按钮”错误解释为零圆角，多个
variant 又把 `overlayColor` 固定为透明，导致渐变和 ghost 按钮缺少可见点击反馈。
这些问题应在 Button 的统一样式解析中修复，而不是由 Demo 额外绘制。

Button 的默认禁用前景色统一落到通用禁用文本色，且浅色描边按钮背景透明，与设计稿不一致。本次按按钮语义使用现有主题 Token 修正默认视觉。

## 范围与非目标

本组件的内容、状态、布局与生命周期按最终方案维护；跨组件 Token/Material 规则引用 Theme 工程 Spec，公开 Demo 与 Golden 范围引用对应工程规范，不把已取代的阶段限制继续作为当前要求。

## 最终方案与行为契约

### 配置与默认几何

- size/variant/colorPreset/shape 由实例选择。完整 ButtonStyle 是对应具体样式的实例入口；组件 Theme 只保留图文间距、分档图标默认值和渐变等无同义入口的字段。
- large/medium/small/extraSmall 的默认高度下限为 48/40/32/28dp，读取 size13/12/10/9；水平 padding 读取 size7/6/5/4。自然内容与字体缩放可以撑大，显式 style 尺寸仍生效。
- 默认图标尺寸为 24/20/18/18dp；大、中档回退 size8/size7，小档保留独立默认。实例 style 和 Icon 显式值遵循已公开的覆盖规则。
- 图文间距由 iconTextSpacing 覆盖，未设置时是内置 4dp，不读取数值为 32dp 的 spacer4。large/medium 使用 fontMarkLarge，small/extraSmall 使用 fontMarkMedium，保留有效行高和字重。
- square/circle 只表达形状；纯图标 square 宽高相等并保留圆角，不表达通栏或强制零圆角。外部 margin 和通栏由 Flutter 父布局表达。

### 状态、密度和交互

- 普通与渐变复用同一 ButtonStyle 实时状态解析；pressed/hovered/focused/disabled 变化后重新解析颜色、文字、边框、几何与指针。
- 内置默认 tap target 为 shrinkWrap；实例 style 的 tapTargetSize 可改变点击布局，padded 不放大可见背景。visualDensity 始终按标准密度解析，Material 按钮主题、ColorScheme 和实例密度均不反向控制内置尺寸。
- fill/outline/text 的语义按压背景不重复叠加 pressed overlay；ghost、渐变或无按压背景的自定义分支仍有状态层反馈。显式实例 overlayColor 有效，禁用态无点击与长按。
- 渐变与普通分支保持一致的内外框、单一按钮语义、可见背景、命中区、baseline 与 intrinsic/dry layout 行为。渐变边框只绘制一次，不参与额外尺寸叠加。
- 配色与禁用颜色按 colorPreset、明暗及当前 TDesign Token 解析；不保留“显式 Material ColorScheme 优先”的旧桥接。图标插槽内 Loading 使用已解析图标色，独立 Loading 默认值不变。

<a id="source-082"></a>
<a id="record-082-text-slot-defaults"></a>

### 082 · Button文案默认值

Button.child通过既有TTextStyleScope向Text/TText提供组件默认文字样式，在内容实际上下文读取最终DefaultTextStyle，复用已有尺寸、配色、状态与动画解析。作用域仅覆盖child，不延伸到icon或背景/前景装饰构建器。

实例style/font显式字段优先；组件槽覆盖外层通用TD文字主题的重复字段，未重复字段与段落配置保留，内容内部更近的TD文字主题可覆盖。复合内容TText共享文案默认，inherit:false保留既有整体替换语义。

无新增配置或API，全局TText/Resolve/Scope可执行规则不变。本事项改变无样式及部分样式TText的默认字体、颜色和布局，属于breaking；使用显式style/font或内容内部局部主题保留原外观。详见[迁移说明](./text-slot-migration.md)及[原验收](./acceptance.md#source-082)。NavBar标题事项见[NavBar契约](../031-Navigation-NavBar/spec.md#source-082)。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 普通与渐变共用实时 ButtonStyle 状态解析；尺寸是设计下限，保留内容与字体缩放撑大的能力。 |
| 保留的边界与代价 | 实例 style 负责完整样式，组件 Theme 保留图文间距、分档图标和渐变；Material 主题与 visualDensity 不反向控制内置外观。 |

### 被取代的方案与原因

曾沿用 Material 按钮主题和密度覆盖链；最终拒绝反向主题输入，保留实例 ButtonStyle 与 TD Token 的明确覆盖。缩小默认点击区域是紧凑视觉与触控尺寸的取舍，调用方仍可显式选择 padded。

- 精确尺寸会缩小 small/extraSmall 的默认点击区域；这是 TDesign 紧凑尺寸与 Material
  最小点击区的明确取舍，Flutter 原生 padded 配置仍完整保留。
- 更新 mark 字体会改变现有 Button Golden，需要逐项确认是规格修复而非无关像素漂移。
- 自定义渐变路径需维护少量 tap-target 布局代码；测试必须覆盖 hit test 和语义，避免与
  Flutter `ButtonStyleButton` 分叉。
- 默认状态层与语义 pressed 背景会同时参与按压反馈；需通过状态解析测试和真机预览确认
  反馈可见且不过度加深，并保留显式 `overlayColor` 的覆盖能力。

## 兼容性与迁移

- 旧 filled 形状迁移为 variant + 父布局，外部 margin 由父布局表达。
- Material 按钮主题、ColorScheme 与 visualDensity 不再是 TD 内置外观的隐式配置入口；对应定制迁移到实例 ButtonStyle、受支持组件 Theme 或 Token。

## 验收标准

- 逐档验证普通/渐变的自然内容高度、显式尺寸、字体缩放、图标大小和 4dp 默认图文间距。
- Material 主题与密度不改变内置外观；实例 ButtonStyle 的其他样式、状态与 tap target 有效。
- 验证 pressed/hovered/focused/disabled 的反馈、渐变描边、单一语义、hit test、baseline 与布局测量。
- 验证纯图标形状、内置 Loading 图标继承，以及 Fab/Dialog 等直接消费者；Golden 按统一规范逐项比对。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

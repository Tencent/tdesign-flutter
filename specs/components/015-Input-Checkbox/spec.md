# Checkbox 设计说明

<a id="record-015-demo-card-alignment"></a>
<a id="record-016-theme-token-sizes"></a>
<a id="record-041-design-details"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

卡片、多行和禁用状态存在布局偏差，尺寸 Token 的默认与覆盖关系需统一。

Checkbox Flutter Demo 需要以官方站内的小程序实际运行画面为基准。除横向文案、项间距和卡片角标外，实际截图还确认了普通示例应使用圆形指示器，纵向列表的分割线不应引入额外垂直留白，位置示例文案应均为“多选”，横向示例应呈现为连续容器。

`TCheckbox` 与其共享卡片布局仍直接使用 20 / 24 / 28、48 / 56 / 64、56 / 82 等样式尺寸。默认主题下视觉正确，但这些值不会随 TDesign 间距、字体和行高 token 调整，与仓库“样式属性定义在主题中”的约定不一致。

Checkbox Demo 与指定设计稿在命名、多行对齐、禁用未选样式、卡片内容间距和分割线起点上存在偏差；同时 Flutter 默认主题的移动端灰阶与设计稿及其他 TDesign 移动端实现存在 1 个色阶单位的历史偏差。

## 范围与非目标

### 目标

- 横向普通选项在 375dp 手机视口完整显示三个文案。
- 基础、横向、全选、禁用、位置和非通栏示例使用圆形指示器。
- 纵向列表分割线不携带默认外边距，不在选项间产生额外空白。
- 位置示例两项文案均为“多选”。
- 横向普通选项使用同一连续背景容器。
- Checkbox 内置排版和颜色由组件 Theme 与 TD Token 解析，不从外部 Material TextTheme 继承隐式配置。
- Checkbox 主标题默认最多 3 行、副标题默认最多 5 行，超出后省略，与小程序默认值一致。
- Checkbox 默认使用圆形指示器，普通 Checkbox 与 CheckboxGroup 默认显示分割线。
- 普通 Checkbox 的 small / medium / large 带文案项最小高度分别为 48dp / 56dp / 64dp，默认 medium 与小程序 56px 单行高度一致。
- 两组样式示例按公开 Demo 保留 16dp 项间距。
- 横向卡片将小程序的 `48rpx` 按 375dp 基准换算为 24dp，纵向卡片继续使用 28dp。

- Checkbox 三档块高与指示器尺寸由 TDesign token 计算。
- Checkbox 单项及卡片组高度由字体、行高和间距 token 计算。
- 共享选择卡片的边框、角标尺寸与角标圆角由 TDesign token 计算。
- 默认主题下保持现有视觉尺寸和行为不变。

- 统一使用“多选框”命名和“特殊样式”分组。
- 多行文案与指示器顶部对齐。
- 单行文案与指示器在行内容中垂直居中。
- 方形指示器由组件绘制 1.5dp 圆角，不依赖字体图标的外轮廓。
- 禁用未选使用禁用背景色和组件描边色。
- 将默认主题中的移动端 Gy3/Gy4/Gy5/Gy11 分别统一为
  `#E7E7E7` / `#DCDCDC` / `#C5C5C5` / `#383838`。
- 卡片文案垂直居中并与上下边框保持 16dp。
- 普通分割线从文案起点开始。

### 涉及

- Checkbox Demo 横向选项、样式间距和卡片示例。
- `TSelectionCardGroupLayout` 横向布局的内部角标样式。
- 组件测试、Demo 测试、生成片段和 Golden。

- `TCheckbox` 内部尺寸解析。
- `TSelectionCard` 与 `TSelectionCardGroupLayout` 的内部尺寸解析。
- Checkbox 与共享卡片组件测试。

- `TCheckbox`、`TSelectionCard`、Checkbox Demo 及测试。
- 默认主题 Gy3/Gy4/Gy5/Gy11 以及所有实际使用这些共享 Token 的 Linux Golden。

### 不涉及

- 不新增 Checkbox 公开 API。
- 不在 Demo 中展示远程图片图标。
- 不改变 Checkbox 的选中状态、回调或禁用语义。

- Checkbox 公开构造参数、ThemeData 字段和文档 API。
- 其他组件的卡片视觉。

- 不新增或修改 Checkbox 公开构造参数。
- 不改变选中、半选、禁用、回调、分割线或布局语义。
- 不把绘制比例、路径控制点等纯几何关系伪装为样式 token。
- 不调整 Radio 的公开 API 或默认行为。

- Checkbox Demo 结构、文案和交互。
- 新增 ThemeExtension 字段。
- 其他组件的样式重构。

- 不新增或修改公开 API。
- 不改变选择状态和回调语义。

- 不修改 Radio 和其他组件的布局、状态或交互契约；它们只继承 Gy4 的共享默认色值修正。

## 最终方案与行为契约

- `TCheckboxGroup.cardMode` 为 `true` 且 `direction` 为 `Axis.horizontal` 时，内部卡片角标区域为 24dp，勾选图标为 12dp。
- 纵向卡片角标继续为 28dp，勾选图标继续为 14dp。
- 新样式不改变卡片点击、选中、禁用或语义行为。
- `TCheckbox.titleMaxLines` 默认值为 3，`subTitleMaxLines` 默认值为 5；显式传值仍优先。
- 未配置组件 Theme 时，`TCheckbox` 默认使用圆形指示器；`showDivider` 默认值为 `true`。
- `TCheckboxGroup.showDivider` 默认值为 `true`，末项仍不绘制分割线；卡片模式不绘制分割线，无边框横向示例显式关闭分割线。
- Demo 不通过新增公开 API 获得对齐效果。

- 默认主题下 small / medium / large 带文案 Checkbox 高度仍为 48 / 56 / 64dp，指示器仍为 20 / 24 / 28dp。
- 默认主题下无副标题 / 有副标题的选择卡片高度仍为 56 / 82dp。
- 默认主题下选择卡片边框仍为 1.5dp、角标圆角仍为 4dp；纵向 / 横向角标仍分别为 28 / 24dp，勾选图标仍为角标的一半。
- 覆盖相关 TDesign spacer、字体或行高 token 后，上述尺寸随 token 重新计算。
- 绘制器中的无量纲比例和路径控制点不属于可配置样式尺寸，不纳入 token 化范围。

默认亮色主题下，禁用未选指示器填充采用 `bgColorComponentDisabled`（`#EEEEEE`）、描边采用 `componentBorderColor`（Gy4，`#DCDCDC`）；布局尺寸均从现有 TDesign Token 派生。

Gy3/Gy5/Gy11 分别从 `#E8E8E8` / `#C6C6C6` / `#393939` 修正为
`#E7E7E7` / `#C5C5C5` / `#383838`；亮暗主题共用同一套移动端中性灰阶值。
这是共享默认 Token 的修正，不由 Checkbox 或其他 Demo 局部覆写颜色。

Checkbox 根据当前约束下的实际文字排版决定纵向对齐：单行内容居中，多行标题或带副标题内容顶部对齐。1.5dp 是方形指示器的组件专属几何，不扩展为全局圆角 token。

禁用未选状态的描边与填充按组件 Theme 和 TD Token 解析；外部 Material CheckboxTheme 不反向覆盖。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 以实例表达状态和形态，以 Theme/Token 提供具体几何；卡片角标、分割线和禁用色在组件内绘制。 |
| 保留的边界与代价 | 单行与多行使用不同对齐策略，Demo 只组织数据和外部排布，不用位移掩盖组件布局。 |

### 设计演变中的关键理由

- 横向 `cardMode` 的角标按小程序 `48rpx` 换算为 24dp，属于用户可感知的视觉修正，但不改变 API 或交互契约。
- 私有布局上下文仅对横向卡片生效，避免影响单独使用的 `TCheckbox(cardMode: true)` 和纵向卡片。
- 默认行数增加可能改变长文案 Checkbox 的高度；保留显式行数参数作为兼容路径，并增加默认值回归测试。
- 普通带文案 Checkbox 的三档最小高度为 48dp / 56dp / 64dp；仅调整内部布局约束，不改变纯指示器热区或卡片高度。

- 默认 token 下计算结果必须与既有直接数值完全一致，避免 Golden 变化。
- 自定义 spacer/font token 后 Checkbox 尺寸会随主题变化，这是修复目的；既有未自定义主题的用户无感。
- 路径曲线、画笔比例等纯几何常量保留在绘制实现中。

- 默认视觉发生用户可感知变化，但不改变 API 或交互语义。
- Gy4 是共享 Token，需要用全量 Linux 视觉回归确认所有消费者，没有仅为消除失败而批量接受快照。
- 禁用未选从单色图标改为填充与描边分离后，必须继续兼容既有 `disableColor`，同时避免把 Flutter 自动默认主题误判为显式覆盖。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- 375dp 视口的横向选项完整显示“多选标题 / 多选标题 / 上限四字”。
- 普通示例的圆形指示器与官方运行画面一致。
- 纵向列表分割线不产生额外垂直间距。
- 位置示例文案和横向容器层级与官方运行画面一致。
- 外部 Material TextTheme 不覆盖 Checkbox 内置文字；组件 Theme 与 Token 的排版和语义颜色有效。
- Checkbox 默认主标题 3 行、副标题 5 行，超出后省略。
- Checkbox 默认圆形指示器，普通 Checkbox 与 CheckboxGroup 默认显示分割线。
- 普通 Checkbox 三档带文案项高度为 48dp / 56dp / 64dp，默认单行项为 56dp。
- 两组示例的相邻选项间距为 16dp。
- 横向与纵向卡片角标尺寸分别为 24dp 和 28dp。
- Flutter 3.32.0 与 latest analyze 零告警，相关测试通过。
- 完整页 light/dark Golden 与 Android 真机复核无截断或溢出。
- 默认主题下 Checkbox 与卡片尺寸无视觉变化。
- 自定义 token 能改变 Checkbox 块高、指示器、卡片高度、边框与角标尺寸。
- Checkbox 受控交互、禁用、半选和 Group 行为测试保持通过。
- Flutter 3.32.0 与 latest 的相关功能测试及 analyze 零告警。
- Flutter 3.32.0 Linux 的 Checkbox light/dark Golden 无差异通过。
- 六项已确认的 Checkbox 偏差均完成修复。
- 不硬编码设计色值。
- 组件和 Demo 回归覆盖新行为。
- 禁用未选状态保留组件 Theme 的覆盖能力，并隔离外部 Material 主题。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

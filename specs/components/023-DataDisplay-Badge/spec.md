# Badge 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

徽标数量、点状、内容和定位混用容易使组合场景发生偏移。

当前 `TBadge` 将 `small` 尺寸混入 `TBadgeVariant`，并在 Demo 中用 `border` 表达“方形徽标”、用 `dot` 表达角标，无法准确还原 Figma 节点 `28591:41540` 的组件类型、样式和尺寸。现有 Demo 还保留动态加号与零值示例，与设计稿的静态公开示例不一致。

- Figma：`TDesign for mobile` branch `4SdclZkcv5bPgX6pa8AsmI`，node `28591:41540`。
- 可见分组：Type（Dot、Number、Customize）、Style（Circle、Square、Bubble、Ribbon、Triangle）、Size（Large、Medium）。
- Figma 标注：Dot/Number 中心点对齐内容右侧和顶部；Customize 顶边对齐并向左偏移 16px；Button 使用中尺寸。
- 跨端公开实现参考：TDesign 小程序 `packages/components/badge/badge.less`，其中 Medium/Large 分别使用 16/20px 行盒，Ribbon 为 50%～85% 的斜向色带，Triangle 为 50% 后的实心角区。

## 范围与非目标

### 目标

- 按 Figma 节点 `28591:41540` 对齐 Badge 的 Type、Style、Size 三个公开分组。
- 让结构形态、尺寸和逐实例位置偏移各自只有一个权威 API。
- 保留 TText、TBadgeConfig、TBadgeThemeData 和 TD Token 的配置职责，外部 Material BadgeTheme 不反向控制组件。
- 为组件行为、公开 Demo 和 light/dark 视觉提供回归证据。

### 涉及

- `TBadgeVariant`、`TBadgeSize`、`TBadge.offset`。
- Dot、Square、Bubble、Ribbon、Triangle 的布局和绘制；设计稿中的 Circle 由 `normal` 单字符用法表达。
- Badge Demo、示例代码、组件测试、Demo 测试和 Golden。

### 不涉及

- 不机械复制小程序的 `content`、`count`、`maxCount`、`color` 等属性名。
- 不修改 Avatar、Button、Cell 的公开 API。
- 不改变 `label`、`showZero`、`child`、`onTap` 的语义。

- Badge 之外组件的视觉重构。
- `CHANGELOG.md` 手工维护。

## 最终方案与行为契约

- `variant` 只表达预设结构形态：`circle`、`dot`、`square`、`bubble`、左右 Ribbon、左右 Triangle。
- 移除混入尺寸语义的 `TBadgeVariant.small`；调用方迁移到 `size`。
- `size` 仅表达 `medium`、`large`，默认 `medium`；中尺寸使用 `fontMarkExtraSmall` 与 16px 行盒，大尺寸使用 `fontMarkSmall` 与 20px 行盒。
- dot 默认直径读取 size4（默认 8dp），组件 TBadgeThemeData.dotSize 可显式覆盖；不读取 Material BadgeThemeData.smallSize，也不改变原生 Badge 默认值。
- `circle` 单字符呈圆形，多字符随内容扩展为胶囊。完全自定义徽标通过
  `TBadge.custom(badge: ...)` 或 `TBadgeConfig.custom(badge: ...)` 提供，不占用
  `variant` 枚举；`badge` 只表示徽标本体，不包含锚点或 `Positioned`。
- `offset` API 保留为逐实例位置覆盖，解析顺序为实例 offset > 组合消费者的默认位置 >
  `Offset.zero`。普通与自定义徽标默认均以中心点对齐内容的逻辑右上角
  `AlignmentDirectional.topEnd`，RTL 下对应物理左上角；Dot 使用同一锚点规则，
  角标形态由 `variant` 固定物理方位。消费组件提供的默认 offset 根据最终生效的
  alignment 转换方向，实例显式 offset 始终使用物理坐标。
- 当调用方已经拥有锚点 Widget 时直接使用 `TBadge(child: ...)`；TabBar、SideBar、
  ActionSheet 等内部拥有锚点的组合组件接收不可渲染的 `TBadgeConfig`，由组件负责
  注入锚点和场景默认位置。内部配置适配器不进入公开 API 文档。
- `border` 保留为正交的对比色描边能力，不再用于表达 Square。
- Circle 单字符呈圆形、多字符呈胶囊形；Square、Bubble 使用同一标签内容与可见性逻辑；Ribbon、Triangle 固定贴合被标记内容的左上或右上角。
- `ribbonLeft/right` 与 `triangleLeft/right` 表示物理方位，在 RTL 中不自动互换。
- `AlignmentDirectional` 随文字方向解析；显式 `Alignment.topLeft/topRight` 保持
  物理方位，并决定消费组件默认 offset 的方向。
- `label == null` 隐藏普通文字徽标；`dot` 始终显示且不创建文字；`showZero` 仅控制字符串 `0`。
- 默认文字使用 `TText`，Theme 显式 `textStyle` 保持最高覆盖优先级，未指定 `leadingDistribution` 时使用 `even`。
- Badge 默认几何由配置、组件 Theme 与 TD Token 解析；外部 BadgeThemeData 的 textStyle/padding/largeSize 不反向覆盖组件。

### Token 与固定几何

- 背景色、文字色、字体、行高、圆点圆角、容器背景和描边颜色继续来自 TDesign Token / Theme。
- 普通及自定义徽标默认以中心点对齐锚点边角；消费组件的场景位置属于组合几何，
  通过内部最低优先级默认值提供，实例及 `BadgeTheme.offset` 仍可覆盖。
- Medium/Large 的默认水平 padding 分别为 4/6 逻辑像素。
- Square 按用户2026-10-16指定设计稿的 radius-default=3px，适配到当前 Flutter 的 `radiusSmall`（默认3px）；相关全局刻度变更应实时生效。Bubble 左下1px尖角与其余10px普通角仍保留既有形状常量，不随该刻度变化。
- Ribbon/Triangle 画布尺寸由当前 Badge 行盒派生，不依赖设备像素比或平台字体基线。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 徽标本体的配置和锚定位置分开；组合消费者复用同一套测量与优先级。 |
| 保留的边界与代价 | 固定几何与 Token 依赖各自记录，不能仅因数值相同就新增全局绑定。 |

### 设计演变中的关键理由

- 当前包为 `1.0.0-alpha.1`；选择一次性收敛 `small`，避免长期保留冲突状态源。
- `border` 与形态正交且已有独立主题配置，保留该能力但从 Demo 的 Square 语义中移除。
- 角标绘制不依赖平台字体基线；画布尺寸从 Badge Size 派生，文字仍由 `TText` 渲染并在受限区域内缩放。
- Square 2px 与 Bubble 左下 1px 是设计稿专有几何；颜色、字体、通用圆角和描边继续走 Theme/Token。
- 设计稿中的 Circle 使用 `normal` 表达：单字符呈圆形，多字符自然扩展为胶囊形，不新增重复形态枚举。
- 自定义徽标与普通文本徽标共用胶囊视觉，但锚点契约不同，因此用显式 `custom` 形态区分，不根据 `label` 内容做数字/文本启发式判断。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- Figma 的 Type、Style、Size 分组、文案、实例数量和顺序在 Flutter Demo 中一致。
- Button 示例使用中尺寸；Demo 不再包含设计稿之外的动态加号和零值公开示例。
- Dot/Number 中心点及 Customize 偏移满足设计稿标注。
- 所有形态在 1.0、1.5、2.0 文本缩放下无异常、裁切或溢出。
- Demo 契约测试覆盖完整页面，组件测试覆盖 API、主题、RTL 与边界。
- Flutter 3.32.0 与 latest 的非视觉测试和 analyze 通过；Flutter 3.32.0 Golden 通过。
- 默认 Dot 在独立与 child 锚定两条路径中均为 8×8 逻辑像素。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

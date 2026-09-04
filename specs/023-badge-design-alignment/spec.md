# Badge 设计稿对齐与 API 收敛

## 背景

当前 `TBadge` 将 `small` 尺寸混入 `TBadgeVariant`，并在 Demo 中用 `border` 表达“方形徽标”、用 `dot` 表达角标，无法准确还原 Figma 节点 `28591:41540` 的组件类型、样式和尺寸。现有 Demo 还保留动态加号与零值示例，与设计稿的静态公开示例不一致。

## 设计证据

- Figma：`TDesign for mobile` branch `4SdclZkcv5bPgX6pa8AsmI`，node `28591:41540`。
- 可见分组：Type（Dot、Number、Customize）、Style（Circle、Square、Bubble、Ribbon、Triangle）、Size（Large、Medium）。
- Figma 标注：Dot/Number 中心点对齐内容右侧和顶部；Customize 顶边对齐并向左偏移 16px；Button 使用中尺寸。
- 跨端公开实现参考：TDesign 小程序 `packages/components/badge/badge.less`，其中 Medium/Large 分别使用 16/20px 行盒，Ribbon 为 50%～85% 的斜向色带，Triangle 为 50% 后的实心角区。

## 目标

- 按 Figma 节点 `28591:41540` 对齐 Badge 的 Type、Style、Size 三个公开分组。
- 让结构形态、尺寸和逐实例位置偏移各自只有一个权威 API。
- 保留 `TText`、TDesign 字体 Token、Material `BadgeTheme` 与 `TBadgeThemeData` 的主题覆盖能力。
- 为组件行为、公开 Demo 和 light/dark 视觉提供回归证据。

## 非目标

- 不机械复制小程序的 `content`、`count`、`maxCount`、`color` 等属性名。
- 不修改 Avatar、Button、Cell 的公开 API。
- 不改变 `label`、`showZero`、`child`、`onTap` 的语义。

## 范围

### 涉及

- `TBadgeVariant`、`TBadgeSize`、`TBadge.offset`。
- Dot、Square、Bubble、Ribbon、Triangle 的布局和绘制；设计稿中的 Circle 由 `normal` 单字符用法表达。
- Badge Demo、示例代码、组件测试、Demo 测试和 Golden。

### 不涉及

- Badge 之外组件的视觉重构。
- `CHANGELOG.md` 手工维护。

## 行为契约

  - `variant` 只表达结构形态：`normal`、`dot`、`square`、`bubble`、左右 Ribbon、左右 Triangle。
- 移除混入尺寸语义的 `TBadgeVariant.small`；调用方迁移到 `size`。
- `size` 仅表达 `medium`、`large`，默认 `medium`；中尺寸使用 `fontMarkExtraSmall` 与 16px 行盒，大尺寸使用 `fontMarkSmall` 与 20px 行盒。
- `dot` 默认直径为 8 逻辑像素，与官方移动端 `--td-badge-dot-size` 一致；显式
  `BadgeThemeData.smallSize` 仍可覆盖。8px 只属于 `TBadge` 的内置视觉默认值；
  `TThemeBuilder` 不投影 `smallSize`，原生 Material `Badge` 自然回退 Flutter 的
  6px 默认值，不把 TDesign Badge 的尺寸扩散到原生组件。
- `offset` 为逐实例位置偏移，解析顺序为实例 `offset` > 局部 `BadgeTheme.offset` > 全局 `ThemeData.badgeTheme.offset` > 默认值。
- `border` 保留为正交的对比色描边能力，不再用于表达 Square。
- `normal` 单字符呈圆形、多字符呈胶囊形；Square、Bubble 使用同一标签内容与可见性逻辑；Ribbon、Triangle 固定贴合被标记内容的左上或右上角。
- `ribbonLeft/right` 与 `triangleLeft/right` 表示物理方位，在 RTL 中不自动互换。
- `label == null` 隐藏普通文字徽标；`dot` 始终显示且不创建文字；`showZero` 仅控制字符串 `0`。
- 默认文字使用 `TText`，Theme 显式 `textStyle` 保持最高覆盖优先级，未指定 `leadingDistribution` 时使用 `even`。
- `TThemeBuilder` 为原生 Material `Badge` 生成的默认 `BadgeThemeData` 仅视为 Token 投影，不覆盖 `TBadgeSize` 的 16/20px 预设；调用方显式提供的局部或全局 `BadgeThemeData.textStyle`、`padding`、`largeSize` 仍按优先级覆盖两档预设。

## Token 与固定几何

- 背景色、文字色、字体、行高、圆点圆角、容器背景和描边颜色继续来自 TDesign Token / Theme。
- Medium/Large 的默认水平 padding 分别为 4/5 逻辑像素，对应移动端规范的 8/10rpx。
- Square 的 2px 圆角与 Bubble 左下 1px 尖角是 Badge 专有形状常量；当前主题 Token 没有语义等价值，因此不错误映射到 3px 的 `radiusSmall`。
- Ribbon/Triangle 画布尺寸由当前 Badge 行盒派生，不依赖设备像素比或平台字体基线。

## 验收标准

- [x] Figma 的 Type、Style、Size 分组、文案、实例数量和顺序在 Flutter Demo 中一致。
- [x] Button 示例使用中尺寸；Demo 不再包含设计稿之外的动态加号和零值公开示例。
- [x] Dot/Number 中心点及 Customize 偏移满足设计稿标注。
- [x] 所有形态在 1.0、1.5、2.0 文本缩放下无异常、裁切或溢出。
- [x] Demo 契约测试覆盖完整页面，组件测试覆盖 API、主题、RTL 与边界。
- [x] Flutter 3.32.0 与 latest 的非视觉测试和 analyze 通过；Flutter 3.32.0 Golden 通过。
- [x] 默认 Dot 在独立与 child 锚定两条路径中均为 8×8 逻辑像素。

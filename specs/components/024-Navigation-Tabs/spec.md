# Tabs 设计说明

<a id="record-024-contract-alignment"></a>
<a id="record-040-size-content-alignment"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

尺寸、指示器、内容区域和主题入口存在跨层配置重叠。

当前 `TTabsBar` 的 `filled`、`capsule`、`card` 命名与 Tabs 实际的 Line、Tag、Card 结构不一致；默认 Line 指示器需要由 Example 手工传入，选中态颜色、禁用态整体透明度以及多处几何默认值也没有形成统一的 TDesign 视觉契约。Tabs Example 为每个静态示例持有独立 `TabController`，放大了生命周期管理成本，并掩盖了组件已经支持 `DefaultTabController` 的 Flutter 标准用法。

- Figma：`TDesign for mobile` branch `4SdclZkcv5bPgX6pa8AsmI`，node `28591:35767`。
- 可见分组：组件类型、组件状态、组件样式；样式包含 Normal、Tag、Card。
- TDesign 小程序 Tabs：公开 `theme` 为 `line | tag | card`，默认 Line 使用 48px 标签栏、Body Medium 字体、品牌色指示器和语义禁用色。
- Flutter：`TabController` 与 `DefaultTabController` 是同一状态机制的显式和继承式入口；静态局部示例无需自行持有控制器生命周期。

Tabs 公开 Demo 的内容区文字为默认黑色，且组件样式区缺少设计稿中的大小尺寸。本次补齐明确的 Flutter 尺寸契约和 Demo。

## 范围与非目标

### 目标

- 让 `TTabsBar` 生产组件自身提供 TDesign Line、Tag、Card 默认视觉，不由 Example 手工拼装。
- 收敛结构形态命名、主题字段和禁用态样式所有权。
- 保留显式 `TabController` 与 `DefaultTabController` 两种 Flutter 标准接入方式，简化无需命令式控制的 Example。
- 补齐组件行为、公开 Demo 和 light/dark Golden 回归。

### 涉及

- `TTabsBarVariant`、`TTabsBarThemeData`、`TTabsBar`、`TTab` 与内部水平标签栏实现。
- `TTabsBarView` 的无状态化和继承控制器用法。
- Tabs Example、生成示例、组件测试、Demo 测试、覆盖率登记和 Golden。

### 不涉及

- 不新增 `TTabsBarSize`；Figma 的尺寸扩展待形成明确跨端契约后另行设计。
- 不移除显式 `controller`，也不引入 TDesign 私有 Controller。
- 不让 `TTabsBarView` 强制业务内容背景或布局样式。
- 不公开内部 `THorizontalTabBar`。

- Badge API 与视觉契约。
- 底部导航组件 `TTabBar`。
- `CHANGELOG.md` 手工维护。

- 不复制旧版 `TTabSize` 的逐 Tab 尺寸入口，尺寸由 TabBar 统一持有。
- 不硬编码字号或颜色值。

## 最终方案与行为契约

- `TTabsBarVariant` 仅表达结构形态：`line`、`tag`、`card`，默认 `line`；移除 `filled` 与 `capsule`。
- `TTabsBarThemeData.selectedBgColor` 收敛为 `selectedTagBackgroundColor`，`unSelectedBgColor` 收敛为 `tagBackgroundColor`，明确这两个颜色只属于 Tag 形态；新增 `disabledLabelStyle` 作为禁用文字和图标的组件级主题入口。
- API 生成清单登记 `TTabsBarThemeData` 与 `TTabsBarVariant`，使公开主题入口和形态枚举进入 Tabs API 文档。
- `line` 在调用方未传 `indicator` 且 Theme 未提供 `indicator` 时，组件内部使用 TDesign 品牌色、16px 宽、3px 高的圆头指示器；`tag` 与 `card` 默认不绘制指示器。
- 默认选中文字使用品牌色与 600 字重，未选中文字使用主文本色与 400 字重，禁用文字和图标使用禁用文本色；禁用态不再对整个子树统一乘透明度。
- `TTab.enabled` 由 `TTab` 负责禁用视觉、由 `TTabsBar` 负责阻止选择；Material `TabBar` 不识别该扩展字段，直接组合时仅保留禁用视觉语义。
- `tag` 使用次级容器背景和品牌浅色选中背景；圆角由标签可用高度派生。`card` 使用容器与次级容器 Token 形成连接卡片结构。
- 容器与指示器的具体视觉由 TTabsBarThemeData 对应字段覆盖 TD Token/内置默认；实例不再提供同义完整 decoration/indicator 入口。`TabBarThemeData`、Material `ColorScheme`、`disabledColor` 与 `IconTheme` 不参与 Tabs 默认视觉解析，避免底层 Material 默认值或应用级 Material 配置改变 TDesign 组件契约；调用方自定义文字保留自身环境；组件内置文字按 TD 配置链解析。
- 底层可以复用 Material 的布局、动画、手势与 `TabController`，但默认不显示 Material splash/hover overlay，也不从内部 `THorizontalTabBar` 回读 `TabBarThemeData`。
- `controller` 为空时从最近的 `DefaultTabController` 获取；显式控制器用于跨树协调、读取索引或命令式切换，两者不同时拥有状态。
- `TTabsBarView` 与 `TTabsBar` 可共享同一显式或继承控制器；其默认不可滑动语义保持不变。
- Example 只选择 `variant`、`isScrollable`、Tab 内容和内容区，不传自定义指示器、颜色、圆角或尺寸以模拟默认设计。

- 新增 `TTabsBarSize.small` 与 `TTabsBarSize.large`，默认 small。
- small 使用 `fontBodyMedium`，large 使用 `fontBodyLarge`；组件高度和交互行为保持不变。
- 内容区 Demo 展示四个选项，使用 `textColorPlaceholder` 表达灰色辅助内容。
- 等距选项卡 Demo 的六个选项均匀铺满容器宽度，不按内容宽度收缩居中。
- 图标、徽标、尺寸和样式 Demo 的选项文案与移动端设计稿保持一致。
- 组件样式 Demo 按设计稿展示线性和标签两种形态；不删除组件已有的卡片能力。
- Theme 显式 labelStyle 仍优先于 size 默认字体 Token。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 实例决定规格、状态和行为，组件 Theme 提供具体文字、间距、指示器和容器视觉。 |
| 保留的边界与代价 | 内容布局与标签栏测量分开，避免通过内容区补偿标签几何。 |

### 设计演变中的关键理由

- 默认 Line 从无指示器变为 TDesign 指示器，是预期的用户可感知默认行为变化。
- 禁用态不再整体透明，显式指定颜色的自定义 `child` 仍被视为调用方完整样式逃逸，不强行改写。
- Material 仍负责标准 Controller、动画和手势基础设施，但不再成为 Tabs 的视觉 Theme 来源；需要子树级视觉定制时统一使用 `TTabsBarThemeData`。
- 显式 Controller 仍是复杂联动的必要能力；只简化 Example，不删除标准 Flutter 能力。
- 暂不增加尺寸 API，避免为没有明确第三档规范的视觉规格创造公共契约。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- 默认 Line、Tag、Card 由生产组件直接呈现 TDesign 视觉。
- Example 不再持有可由 `DefaultTabController` 替代的控制器，也不再传默认指示器。
- 公开分组、实例数量、顺序、状态和样式由 Demo 测试覆盖。
- 组件测试覆盖三种形态、主题优先级、禁用态、显式与继承控制器。
- Material `TabBarThemeData`、`disabledColor` 与 `IconTheme` 不改变 Tabs 的 TDesign 默认视觉。
- Tabs 手写生产源码覆盖率达到 95%。
- Flutter 3.32.0 与 latest 非视觉测试和 analyze 通过；Flutter 3.32.0 Linux Golden 通过。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

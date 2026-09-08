# Tabs 视觉契约与 API 收敛

## 背景

当前 `TTabsBar` 的 `filled`、`capsule`、`card` 命名与 Tabs 实际的 Line、Tag、Card 结构不一致；默认 Line 指示器需要由 Example 手工传入，选中态颜色、禁用态整体透明度以及多处几何默认值也没有形成统一的 TDesign 视觉契约。Tabs Example 为每个静态示例持有独立 `TabController`，放大了生命周期管理成本，并掩盖了组件已经支持 `DefaultTabController` 的 Flutter 标准用法。

## 设计证据

- Figma：`TDesign for mobile` branch `4SdclZkcv5bPgX6pa8AsmI`，node `28591:35767`。
- 可见分组：组件类型、组件状态、组件样式；样式包含 Normal、Tag、Card。
- TDesign 小程序 Tabs：公开 `theme` 为 `line | tag | card`，默认 Line 使用 48px 标签栏、Body Medium 字体、品牌色指示器和语义禁用色。
- Flutter：`TabController` 与 `DefaultTabController` 是同一状态机制的显式和继承式入口；静态局部示例无需自行持有控制器生命周期。

## 目标

- 让 `TTabsBar` 生产组件自身提供 TDesign Line、Tag、Card 默认视觉，不由 Example 手工拼装。
- 收敛结构形态命名、主题字段和禁用态样式所有权。
- 保留显式 `TabController` 与 `DefaultTabController` 两种 Flutter 标准接入方式，简化无需命令式控制的 Example。
- 补齐组件行为、公开 Demo 和 light/dark Golden 回归。

## 非目标

- 不新增 `TTabsBarSize`；Figma 的尺寸扩展待形成明确跨端契约后另行设计。
- 不移除显式 `controller`，也不引入 TDesign 私有 Controller。
- 不让 `TTabsBarView` 强制业务内容背景或布局样式。
- 不公开内部 `THorizontalTabBar`。

## 范围

### 涉及

- `TTabsBarVariant`、`TTabsBarThemeData`、`TTabsBar`、`TTab` 与内部水平标签栏实现。
- `TTabsBarView` 的无状态化和继承控制器用法。
- Tabs Example、生成示例、组件测试、Demo 测试、覆盖率登记和 Golden。

### 不涉及

- Badge API 与视觉契约。
- 底部导航组件 `TTabBar`。
- `CHANGELOG.md` 手工维护。

## 行为契约

- `TTabsBarVariant` 仅表达结构形态：`line`、`tag`、`card`，默认 `line`；移除 `filled` 与 `capsule`。
- `TTabsBarThemeData.selectedBgColor` 收敛为 `selectedTagBackgroundColor`，`unSelectedBgColor` 收敛为 `tagBackgroundColor`，明确这两个颜色只属于 Tag 形态；新增 `disabledLabelStyle` 作为禁用文字和图标的组件级主题入口。
- API 生成清单登记 `TTabsBarThemeData` 与 `TTabsBarVariant`，使公开主题入口和形态枚举进入 Tabs API 文档。
- `line` 在调用方未传 `indicator` 且 Theme 未提供 `indicator` 时，组件内部使用 TDesign 品牌色、16px 宽、3px 高的圆头指示器；`tag` 与 `card` 默认不绘制指示器。
- 默认选中文字使用品牌色与 600 字重，未选中文字使用主文本色与 400 字重，禁用文字和图标使用禁用文本色；禁用态不再对整个子树统一乘透明度。
- `TTab.enabled` 由 `TTab` 负责禁用视觉、由 `TTabsBar` 负责阻止选择；Material `TabBar` 不识别该扩展字段，直接组合时仅保留禁用视觉语义。
- `tag` 使用次级容器背景和品牌浅色选中背景；圆角由标签可用高度派生。`card` 使用容器与次级容器 Token 形成连接卡片结构。
- 实例 `decoration` / `indicator` > `TTabsBarThemeData` 对应字段 > TDesign Token / 组件内置规范值。`TabBarThemeData`、Material `ColorScheme`、`disabledColor` 与 `IconTheme` 不参与 Tabs 默认视觉解析，避免底层 Material 默认值或应用级 Material 配置改变 TDesign 组件契约；应用字体家族仍允许通过环境字体继承。
- 底层可以复用 Material 的布局、动画、手势与 `TabController`，但默认不显示 Material splash/hover overlay，也不从内部 `THorizontalTabBar` 回读 `TabBarThemeData`。
- `controller` 为空时从最近的 `DefaultTabController` 获取；显式控制器用于跨树协调、读取索引或命令式切换，两者不同时拥有状态。
- `TTabsBarView` 与 `TTabsBar` 可共享同一显式或继承控制器；其默认不可滑动语义保持不变。
- Example 只选择 `variant`、`isScrollable`、Tab 内容和内容区，不传自定义指示器、颜色、圆角或尺寸以模拟默认设计。

## 验收标准

- [x] 默认 Line、Tag、Card 由生产组件直接呈现 TDesign 视觉。
- [x] Example 不再持有可由 `DefaultTabController` 替代的控制器，也不再传默认指示器。
- [x] 公开分组、实例数量、顺序、状态和样式由 Demo 测试覆盖。
- [x] 组件测试覆盖三种形态、主题优先级、禁用态、显式与继承控制器。
- [x] Material `TabBarThemeData`、`disabledColor` 与 `IconTheme` 不改变 Tabs 的 TDesign 默认视觉。
- [x] Tabs 手写生产源码覆盖率达到 95%。
- [x] Flutter 3.32.0 与 latest 非视觉测试和 analyze 通过；Flutter 3.32.0 Linux Golden 通过。
